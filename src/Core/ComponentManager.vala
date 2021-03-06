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
                component = NewInstance<T>(componentClass);
                break;
            case Taxonomy.POOLED:
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
            PooledComponent? old = (PooledComponent)components.SafeGet(owner.Id);
            if (old != null) {
                pooledComponents.Free(old, type);
            }
        }
    
        public T NewInstance<T>(Type type) 
        {
            return GLib.Object.new(type);
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
            var componentBits = e.ComponentBits;
            for (var i = componentBits.NextSetBit(0); i >= 0; i = componentBits.NextSetBit(i+1)) {

                switch(TypeFactory.GetTaxonomy(i)) {

                case Taxonomy.BASIC:
                    componentsByType[i].set(e.Id, null);
                    break;

                case Taxonomy.POOLED:
                    var pooled = componentsByType[i][e.Id];
                    pooledComponents.FreeByIndex((PooledComponent)pooled, i);
                    componentsByType[i].set(e.Id, null);
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
                componentsByType[type.GetIndex()] = components;
            }
            
            components[e.Id] = component;
            e.ComponentBits[type.GetIndex()] = true;
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
                    componentsByType[index].set(e.Id, null);
                    e.ComponentBits.Clear(type.GetIndex());
                    break;
                case Taxonomy.POOLED:
                    var pooled = componentsByType[index][e.Id];
                    e.ComponentBits.Clear(type.GetIndex());
                    pooledComponents.Free((PooledComponent)pooled, type);
                    componentsByType[index][e.Id] = null;
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
                return components[e.Id];
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
            var componentBits = e.ComponentBits;

            for (var i = componentBits.NextSetBit(0); i >= 0; i = componentBits.NextSetBit(i+1)) {
                fillBag.Add(componentsByType[i][e.Id]);
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
  