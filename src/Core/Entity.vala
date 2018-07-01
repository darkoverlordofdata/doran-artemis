using Artemis.Utils;

namespace Artemis {
  
    /**
    * The entity class. Cannot be instantiated outside the framework, you must
    * create new entities using World.
    * 
    * @author Arni Arent
    * 
    */
    public class Entity : Object {
        public string uuid;
        public string name;
    
        private int id;
        private BitSet componentBits;
        private BitSet systemBits;
    
        private World world;
        private EntityManager entityManager;
        private ComponentManager componentManager;
        
        public Entity(World world, int id, string name = "") {
            this.world = world;
            this.id = id;
            this.name = name;
            entityManager = world.getEntityManager();
            componentManager = world.getComponentManager();
            systemBits = new BitSet();
            componentBits = new BitSet();
            
            reset();
        }
      
        /**
         * The internal id for this entity within the framework. No other entity
        * will have the same ID, but ID's are however reused so another entity may
        * acquire this ID if the previous entity was deleted.
        * 
        * @return id of the entity.
        */
        public int getId() {
            return id;
        }
      
        /**
         * Returns a BitSet instance containing bits of the components the entity possesses.
        * @return
        */
        public BitSet getComponentBits() {
            return componentBits;
        }
        
        /**
         * Returns a BitSet instance containing bits of the components the entity possesses.
        * @return
        */
        public BitSet getSystemBits() {
            return systemBits;
        }
    
        /**
         * Make entity ready for re-use.
        * Will generate a new uuid for the entity.
        */
        protected void reset() {
            systemBits.clear();
            componentBits.clear();
            uuid = UUID.randomUUID();
        }
      
          
        public string toString() {
            return "Entity[%d]".printf(id);
        }

        public T createComponent<T>(Type type, ...) {
            var componentManager = this.world.getComponentManager();
            var component = componentManager.create<T>(this, type);
            //  if (args.length) {
            //      (<any>component).initialize(...args);
            //  }

            var tf = this.world.getComponentManager().typeFactory;
            var componentType = tf.getTypeFor(type);
            componentBits.set(componentType.getIndex());

            return component;
    
        }
    
        /**
          * Add a component to this entity.
          * 
          * @param component to add to this entity
          * 
          * @return this entity for chaining.
          */
          // public addComponent(component: Component):Entity {
          // 	this.addComponent(component, ComponentType.getTypeFor(component.getClass()));
          // 	return this;
          // }
          
          /**
          * Faster adding of components into the entity. Not neccessery to use this, but
          * in some cases you might need the extra performance.
          * 
          * @param component the component to add
          * @param args of the component
          * 
          * @return this entity for chaining.
          */
        public Entity addComponent(Component component, ...) {

            var type = component.get_type();
            var tf = this.world.getComponentManager().typeFactory;
            var componentType = tf.getTypeFor(type);
            componentBits.set(componentType.getIndex());
  
            //  var c1 = createComponent(component.get_type());
            //  type = this.getTypeFor(c1.get_type());
    
            //  this.componentManager.addComponent(this, type, c1);
            return this;
        }
  
        private ComponentType getTypeFor(Type c) {
            return world.getComponentManager().typeFactory.getTypeFor(c);
        }
        /**
         * Removes the component from this entity.
         * 
         * @param component to remove from this entity.
         * 
         * @return this entity for chaining.
         */
        public Entity removeComponentInstance(Component component) {
            removeComponent(getTypeFor(component.get_type()));
            return this;
        }
      
        /**
         * Faster removal of components from a entity.
        * 
        * @param type to remove from this entity.
        * 
        * @return this entity for chaining.
        */
        public Entity removeComponent(ComponentType type) {
            componentManager.removeComponent(this, type);
            return this;
        }
          
        /**
         * Remove component by its type.
        * @param type
        * 
        * @return this entity for chaining.
        */
        public Entity removeComponentByType(Type type) {
            removeComponent(getTypeFor(type));
            return this;
        }
      
        /**
         * Checks if the entity has been added to the world and has not been deleted from it.
        * If the entity has been disabled this will still return true.
        * 
        * @return if it's active.
        */
        public bool isActive() {
            return entityManager.isActive(id);
        }
          
        /**
         * Will check if the entity is enabled in the world.
        * By default all entities that are added to world are enabled,
        * this will only return false if an entity has been explicitly disabled.
        * 
        * @return if it's enabled
        */
        public bool isEnabled() {
            return entityManager.isEnabled(id);
        }
          
        /**
         * This is the preferred method to use when retrieving a component from a
        * entity. It will provide good performance.
        * But the recommended way to retrieve components from an entity is using
        * the ComponentMapper.
        * 
        * @param type
        *            in order to retrieve the component fast you must provide a
        *            ComponentType instance for the expected component.
        * @return
        */
        public Component getComponent(ComponentType type) {
            return componentManager.getComponent(this, type);
        }
      
        /**
         * Slower retrieval of components from this entity. Minimize usage of this,
        * but is fine to use e.g. when creating new entities and setting data in
        * components.
        * 
        * @param <T>
        *            the expected return component type.
        * @param type
        *            the expected return component type.
        * @return component that matches, or null if none is found.
        */
        public Component getComponentByType(Type type) {
            return componentManager.getComponent(this, getTypeFor(type));
        }
      
        /**
         * Returns a bag of all components this entity has.
        * You need to reset the bag yourself if you intend to fill it more than once.
        * 
        * @param fillBag the bag to put the components into.
        * @return the fillBag with the components in.
        */
        public Bag<Component> getComponents(Bag<Component> fillBag) {
            return componentManager.getComponentsFor(this, fillBag);
        }
      
        /**
         * Refresh all changes to components for this entity. After adding or
        * removing components, you must call this method. It will update all
        * relevant systems. It is typical to call this after adding components to a
        * newly created entity.
        */
        public void addToWorld() {
            world.addEntity(this);
        }
          
        /**
         * This entity has changed, a component added or deleted.
        */
        public void changedInWorld() {
            world.changedEntity(this);
        }
      
        /**
         * Delete this entity from the world.
        */
        public void deleteFromWorld() {
            world.deleteEntity(this);
        }
          
        /**
         * (Re)enable the entity in the world, after it having being disabled.
        * Won't do anything unless it was already disabled.
        */
        public void enable() {
            world.enable(this);
        }
          
        /**
         * Disable the entity from being processed. Won't delete it, it will
        * continue to exist but won't get processed.
        */
        public void disable() {
            world.disable(this);
        }
          
        /**
         * Get the UUID for this entity.
        * This UUID is unique per entity (re-used entities get a new UUID).
        * @return uuid instance for this entity.
        */
        public string getUuid() {
            return uuid;
        }
      
        /**
         * Returns the world this entity belongs to.
        * @return world of entity.
        */
        public World getWorld() {
            return world;
        }
    }
}

