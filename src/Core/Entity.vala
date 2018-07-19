/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
namespace Artemis 
{  
    using Artemis.Utils;

    /**
    * The entity class. Cannot be instantiated outside the framework, you must
    * create new entities using World.
    * 
    * @author Arni Arent
    * 
    */
    public class Entity : Object 
    {
        private string uuid;
        private string name;
    
        private int id;
        private BitSet componentBits;
        private BitSet systemBits;
    
        private World world;
        private EntityManager entityManager;
        private ComponentManager componentManager;
        
        public Entity(World world, int id, string name = "") 
        {
            this.world = world;
            this.id = id;
            this.name = name;
            entityManager = world.GetEntityManager();
            componentManager = world.GetComponentManager();
            systemBits = new BitSet();
            componentBits = new BitSet();
            
            Reset();
        }
      
        /**
         * The internal id for this entity within the framework. No other entity
        * will have the same ID, but ID's are however reused so another entity may
        * acquire this ID if the previous entity was deleted.
        * 
        * @return id of the entity.
        */
        public int GetId() 
        {
            return id;
        }
      
        /**
         * Returns a BitSet instance containing bits of the components the entity possesses.
        * @return
        */
        public BitSet GetComponentBits() 
        {
            return componentBits;
        }
        
        /**
         * Returns a BitSet instance containing bits of the components the entity possesses.
        * @return
        */
        public BitSet GetSystemBits() 
        {
            return systemBits;
        }
    
        /**
         * Make entity ready for re-use.
        * Will generate a new uuid for the entity.
        */
        protected void Reset() 
        {
            systemBits.Clear();
            componentBits.Clear();
            uuid = UUID.RandomUUID();
        }
      
          
        public string ToString() 
        {
            return "Entity[%d]".printf(id);
        }

        public T CreateComponent<T>(Type type, ...) 
        {
            var componentManager = this.world.GetComponentManager();
            var component = componentManager.Create<T>(this, type);
            // var ls = va_list();

            //  if (args.length) {
            //      (<any>component).initialize(...args);
            //  }

            var tf = this.world.GetComponentManager().TypeFactory;
            var componentType = tf.GetTypeFor(type);
            componentBits[componentType.GetIndex()] = true;

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
          // 	this.addComponent(component, ComponentType.GetTypeFor(component.getClass()));
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
        public Entity AddComponent(Component component, ...) 
        {

            var type = component.get_type();
            var tf = this.world.GetComponentManager().TypeFactory;
            var componentType = tf.GetTypeFor(type);
            componentBits[componentType.GetIndex()] = true;
  
            //  var c1 = createComponent(component.get_type());
            //  type = this.GetTypeFor(c1.get_type());
    
            //  this.componentManager.addComponent(this, type, c1);
            return this;
        }
  
        private ComponentType GetTypeFor(Type c) 
        {
            return world.GetComponentManager().TypeFactory.GetTypeFor(c);
        }
        /**
         * Removes the component from this entity.
         * 
         * @param component to remove from this entity.
         * 
         * @return this entity for chaining.
         */
        public Entity RemoveComponentInstance(Component component) 
        {
            RemoveComponent(GetTypeFor(component.get_type()));
            return this;
        }
      
        /**
         * Faster removal of components from a entity.
        * 
        * @param type to remove from this entity.
        * 
        * @return this entity for chaining.
        */
        public Entity RemoveComponent(ComponentType type) 
        {
            componentManager.RemoveComponent(this, type);
            return this;
        }
          
        /**
         * Remove component by its type.
        * @param type
        * 
        * @return this entity for chaining.
        */
        public Entity RemoveComponentByType(Type type) 
        {
            RemoveComponent(GetTypeFor(type));
            return this;
        }
      
        /**
         * Checks if the entity has been added to the world and has not been deleted from it.
        * If the entity has been disabled this will still return true.
        * 
        * @return if it's active.
        */
        public bool IsActive() 
        {
            return entityManager.IsActive(id);
        }
          
        /**
         * Will check if the entity is enabled in the world.
        * By default all entities that are added to world are enabled,
        * this will only return false if an entity has been explicitly disabled.
        * 
        * @return if it's enabled
        */
        public bool IsEnabled() 
        {
            return entityManager.IsEnabled(id);
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
        public Component GetComponent(ComponentType type) 
        {
            return componentManager.GetComponent(this, type);
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
        public Component GetComponentByType(Type type) 
        {
            return componentManager.GetComponent(this, GetTypeFor(type));
        }
      
        /**
         * Returns a bag of all components this entity has.
        * You need to reset the bag yourself if you intend to fill it more than once.
        * 
        * @param fillBag the bag to put the components into.
        * @return the fillBag with the components in.
        */
        public Bag<Component> GetComponents(Bag<Component> fillBag) 
        {
            return componentManager.GetComponentsFor(this, fillBag);
        }
      
        /**
         * Refresh all changes to components for this entity. After adding or
        * removing components, you must call this method. It will update all
        * relevant systems. It is typical to call this after adding components to a
        * newly created entity.
        */
        public void AddToWorld() 
        {
            world.AddEntity(this);
        }
          
        /**
         * This entity has changed, a component added or deleted.
        */
        public void ChangedInWorld() 
        {
            world.ChangedEntity(this);
        }
      
        /**
         * Delete this entity from the world.
        */
        public void DeleteFromWorld() 
        {
            world.DeleteEntity(this);
        }
          
        /**
         * (Re)enable the entity in the world, after it having being disabled.
        * Won't do anything unless it was already disabled.
        */
        public void Enable() 
        {
            world.Enable(this);
        }
          
        /**
         * Disable the entity from being processed. Won't delete it, it will
        * continue to exist but won't get processed.
        */
        public void Disable() 
        {
            world.Disable(this);
        }
          
        /**
         * Get the UUID for this entity.
        * This UUID is unique per entity (re-used entities get a new UUID).
        * @return uuid instance for this entity.
        */
        public string GetUuid() 
        {
            return uuid;
        }
      
        /**
         * Returns the world this entity belongs to.
        * @return world of entity.
        */
        public World GetWorld() 
        {
            return world;
        }
    }
}
