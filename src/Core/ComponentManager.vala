using Artemis.Utils;

namespace Artemis {
  
      
    public class ComponentManager : Manager {

        private Bag<Bag<Component>> componentsByType;
        private ComponentPool pooledComponents;
        private Bag<Entity> _deleted;
        public ComponentTypeFactory typeFactory;
  
        public ComponentManager() {
            base();
            componentsByType = new Bag<Bag<Component>>();
            pooledComponents = new ComponentPool();
            _deleted = new Bag<Entity>();
  
            typeFactory = new ComponentTypeFactory();
        }
          
        public override void initialize() {}
  
        public T create<T>(Entity owner, Type componentClass) {
  
            var type = typeFactory.getTypeFor(componentClass);
            T component = null;
    
            switch (type.getTaxonomy()) {
            case Taxonomy.BASIC:
                //console.log('create BASIC');
                component = newInstance<T>(componentClass);
                break;
            case Taxonomy.POOLED:
                //console.log('create POOLED');
                reclaimPooled(owner, type);
                /**
                 * YUK! <T> is not working here.
                 * It should be ok, since it will be the same as 'type'
                 */
                component = pooledComponents.obtain(componentClass, type);
                break;
            default:
                throw new ArtemisException.InvalidComponent("unknown component type %s",type.getTaxonomy().to_string());
            }
            addComponent(owner, type, (Component)component);
            return component;
        }
  
        private void reclaimPooled(Entity owner, ComponentType type) {
            Bag<Component> components = componentsByType.safeGet(type.getIndex());
            if (components == null)
                return;
            PooledComponent? old = (PooledComponent)components.safeGet(owner.getId());
            if (old != null) {
                pooledComponents.free(old, type);
            }
        }
    
        public T newInstance<T>(Type type) {
            return Object.new(type);
        }
        //  public T newInstance<T>(Type type, bool constructorHasWorldParameter) {
        //      if (constructorHasWorldParameter) {
        //          return Object.new(type).setWorld(world);
        //      } else {
        //          return Object.new(type);
        //      }
        //  }
    
        /**
         * Removes all components from the entity associated in this manager.
         *
         * @param e
         *			the entity to remove components from
        */
        private void removeComponentsOfEntity(Entity e) {
            var componentBits = e.getComponentBits();
            for (var i = componentBits.nextSetBit(0); i >= 0; i = componentBits.nextSetBit(i+1)) {

                switch(typeFactory.getTaxonomy(i)) {

                case Taxonomy.BASIC:
                    //console.log('remove BASIC');
                    componentsByType[i].set(e.getId(), null);
                    break;

                case Taxonomy.POOLED:
                    //console.log('remove POOLED');
                    var pooled = componentsByType[i][e.getId()];
                    pooledComponents.freeByIndex((PooledComponent)pooled, i);
                    componentsByType[i].set(e.getId(), null);
                    break;

                default:
                    throw new ArtemisException.InvalidComponent("unknown component type %s",typeFactory.getTaxonomy(i).to_string());

                }
            }
            componentBits.clear();
        }
    
        /**
         * Adds the component of the given type to the entity.
         * <p>
         * Only one component of given type can be associated with a entity at the
         * same time.
         * </p>
         *
         * @param e
         *			the entity to add to
        * @param type
        *			the type of component being added
        * @param component
        *			the component to add
        */
        public void addComponent(Entity e, ComponentType type, Component component) {
            componentsByType.ensureCapacity(type.getIndex());

            Bag<Component> components = componentsByType[type.getIndex()];
            if(components == null) {
                components = new Bag<Component>();
                componentsByType.set(type.getIndex(), components);
            }
            
            components.set(e.getId(), component);

            e.getComponentBits().set(type.getIndex());
        }
    
        /**
         * Removes the component of given type from the entity.
         *
         * @param e
         *			the entity to remove from
        * @param type
        *			the type of component being removed
        */
        public void removeComponent(Entity e, ComponentType type) {
            var index = type.getIndex();
            switch (type.getTaxonomy()) {
                case Taxonomy.BASIC:
                    componentsByType[index].set(e.getId(), null);
                    e.getComponentBits().clear(type.getIndex());
                    break;
                case Taxonomy.POOLED:
                    var pooled = componentsByType[index][e.getId()];
                    e.getComponentBits().clear(type.getIndex());
                    pooledComponents.free((PooledComponent)pooled, type);
                    componentsByType[index][e.getId()] = null;
                    break;
            default:
                    throw new ArtemisException.InvalidComponent("unknown component type %s",type.getTaxonomy().to_string());
                }
        }
    
        /**
         * Get all components from all entities for a given type.
         *
         * @param type
         *			the type of components to get
        * @return a bag containing all components of the given type
        */
        public Bag<Component> getComponentsByType(ComponentType type) {
            Bag<Component> components = componentsByType[type.getIndex()];
            if(components == null) {
                components = new Bag<Component>();
                componentsByType.set(type.getIndex(), components);
            }
            return components;
        }
    
        /**
         * Get a component of an entity.
         *
         * @param e
         *			the entity associated with the component
        * @param type
        *			the type of component to get
        * @return the component of given type
        */
        public Component getComponent(Entity e, ComponentType type) {
            Bag<Component> components = componentsByType[type.getIndex()];
            if(components != null) {
                return components[e.getId()];
            }
            return null;
        }
    
        /**
         * Get all component associated with an entity.
         *
         * @param e
         *			the entity to get components from
        * @param fillBag
        *			a bag to be filled with components
        * @return the {@code fillBag}, filled with the entities components
        */
        public Bag<Component> getComponentsFor(Entity e,  Bag<Component> fillBag) {
            var componentBits = e.getComponentBits();

            for (var i = componentBits.nextSetBit(0); i >= 0; i = componentBits.nextSetBit(i+1)) {
                fillBag.add(componentsByType[i][e.getId()]);
            }
            
            return fillBag;
        }

        
        
        public override void deleted(Entity e) {
            _deleted.add(e);
        }
        
        public void clean() {
            if(_deleted.size() > 0) {
                for(var i = 0; _deleted.size() > i; i++) {
                    removeComponentsOfEntity(_deleted[i]);
                }
                _deleted.clear();
            }
        }
        
    }
}
  