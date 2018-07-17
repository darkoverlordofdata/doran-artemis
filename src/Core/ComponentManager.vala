using Artemis.Utils;

namespace Artemis 
{
    public class ComponentManager : Manager 
    {
        private Bag<Bag<Component>> componentsByType;
        private ComponentPool pooledComponents;
        private Bag<Entity> deleted;
        public ComponentTypeFactory TypeFactory;
  
        public ComponentManager() 
        {
            base();
            componentsByType = new Bag<Bag<Component>>();
            pooledComponents = new ComponentPool();
            deleted = new Bag<Entity>();
  
            TypeFactory = new ComponentTypeFactory();
        }
          
        public override void Initialize() {}
  
        public T Create<T>(Entity owner, Type componentClass) 
        {
            var type = TypeFactory.GetTypeFor(componentClass);
            T component = null;
    
            switch (type.GetTaxonomy()) {
            case Taxonomy.BASIC:
                //console.log('create BASIC');
                component = NewInstance<T>(componentClass);
                break;
            case Taxonomy.POOLED:
                //console.log('create POOLED');
                ReclaimPooled(owner, type);
                /**
                 * YUK! <T> is not working here.
                 * It should be ok, since it will be the same as 'type'
                 */
                component = pooledComponents.Obtain(componentClass, type);
                break;
            default:
                throw new ArtemisException.InvalidComponent("unknown component type %s",type.GetTaxonomy().to_string());
            }
            AddComponent(owner, type, (Component)component);
            return component;
        }
  
        private void ReclaimPooled(Entity owner, ComponentType type) 
        {
            Bag<Component> components = componentsByType.SafeGet(type.GetIndex());
            if (components == null)
                return;
            PooledComponent? old = (PooledComponent)components.SafeGet(owner.GetId());
            if (old != null) {
                pooledComponents.Free(old, type);
            }
        }
    
        public T NewInstance<T>(Type type) 
        {
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
        private void RemoveComponentsOfEntity(Entity e) 
        {
            var componentBits = e.GetComponentBits();
            for (var i = componentBits.NextSetBit(0); i >= 0; i = componentBits.NextSetBit(i+1)) {

                switch(TypeFactory.GetTaxonomy(i)) {

                case Taxonomy.BASIC:
                    //console.log('remove BASIC');
                    componentsByType[i].set(e.GetId(), null);
                    break;

                case Taxonomy.POOLED:
                    //console.log('remove POOLED');
                    var pooled = componentsByType[i][e.GetId()];
                    pooledComponents.FreeByIndex((PooledComponent)pooled, i);
                    componentsByType[i].set(e.GetId(), null);
                    break;

                default:
                    throw new ArtemisException.InvalidComponent("unknown component type %s", TypeFactory.GetTaxonomy(i).to_string());

                }
            }
            componentBits.Clear();
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
        public void AddComponent(Entity e, ComponentType type, Component component) 
        {
            componentsByType.EnsureCapacity(type.GetIndex());

            Bag<Component> components = componentsByType[type.GetIndex()];
            if(components == null) {
                components = new Bag<Component>();
                componentsByType.set(type.GetIndex(), components);
            }
            
            components.set(e.GetId(), component);

            e.GetComponentBits()[type.GetIndex()] = true;
        }
    
        /**
         * Removes the component of given type from the entity.
         *
         * @param e
         *			the entity to remove from
        * @param type
        *			the type of component being removed
        */
        public void RemoveComponent(Entity e, ComponentType type) 
        {
            var index = type.GetIndex();
            switch (type.GetTaxonomy()) {
                case Taxonomy.BASIC:
                    componentsByType[index].set(e.GetId(), null);
                    e.GetComponentBits().Clear(type.GetIndex());
                    break;
                case Taxonomy.POOLED:
                    var pooled = componentsByType[index][e.GetId()];
                    e.GetComponentBits().Clear(type.GetIndex());
                    pooledComponents.Free((PooledComponent)pooled, type);
                    componentsByType[index][e.GetId()] = null;
                    break;
            default:
                    throw new ArtemisException.InvalidComponent("unknown component type %s",type.GetTaxonomy().to_string());
                }
        }
    
        /**
         * Get all components from all entities for a given type.
         *
         * @param type
         *			the type of components to get
        * @return a bag containing all components of the given type
        */
        public Bag<Component> GetComponentsByType(ComponentType type) 
        {
            Bag<Component> components = componentsByType[type.GetIndex()];
            if(components == null) {
                components = new Bag<Component>();
                componentsByType.set(type.GetIndex(), components);
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
        public Component GetComponent(Entity e, ComponentType type) 
        {
            Bag<Component> components = componentsByType[type.GetIndex()];
            if(components != null) {
                return components[e.GetId()];
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
        public Bag<Component> GetComponentsFor(Entity e,  Bag<Component> fillBag) 
        {
            var componentBits = e.GetComponentBits();

            for (var i = componentBits.NextSetBit(0); i >= 0; i = componentBits.NextSetBit(i+1)) {
                fillBag.Add(componentsByType[i][e.GetId()]);
            }
            
            return fillBag;
        }

        
        
        public override void Deleted(Entity e) 
        {
            deleted.Add(e);
        }
        
        public void Clean() 
        {
            if(deleted.Size() > 0) {
                for(var i = 0; deleted.Size() > i; i++) {
                    RemoveComponentsOfEntity(deleted[i]);
                }
                deleted.Clear();
            }
        }
    }
}
  