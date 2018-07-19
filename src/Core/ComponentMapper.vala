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
     * High performance component retrieval from entities. Use this wherever you
     * need to retrieve components from entities often and fast.
     * 
     * @author Arni Arent
     *
     * @param <A> the class type of the component
     */
    public class ComponentMapper<A> : Object 
    {
          private ComponentType type;
          private Type classType;
          private Bag<Component> components;
      
          public ComponentMapper(Type type, World world) 
          {
              //this.type_ = ComponentType.GetTypeFor(type);
              this.type = world.GetComponentManager().TypeFactory.GetTypeFor(type);
              components = world.GetComponentManager().GetComponentsByType(this.type);
              classType = type;
          }
      
          /**
          * Fast but unsafe retrieval of a component for this entity.
          * No bounding checks, so this could throw an ArrayIndexOutOfBoundsExeption,
          * however in most scenarios you already know the entity possesses this component.
          * 
          * @param e the entity that should possess the component
          * @return the instance of the component
          */
          public A get(Entity e) 
          {
              return components[e.GetId()];
          }
      
          /**
          * Fast and safe retrieval of a component for this entity.
          * If the entity does not have this component then null is returned.
          * 
          * @param e the entity that should possess the component
          * @return the instance of the component
          */
          public A GetSafe(Entity e) 
          {
              if(components.IsIndexWithinBounds(e.GetId())) {
                  return components[e.GetId()];
              }
              return null;
          }
          
          /**
          * Checks if the entity has this type of component.
          * @param e the entity to check
          * @return true if the entity has this component type, false if it doesn't.
          */
          public bool Has(Entity e) 
          {
              return GetSafe(e) != null;		
          }
      
          /**
          * Returns a component mapper for this type of components.
          * 
          * @param type the type of components this mapper uses.
          * @param world the world that this component mapper should use.
          * @return a new mapper.
          */
          public static ComponentMapper<T> GetFor<T>(Type type, World world) 
          {
              return new ComponentMapper<T>(type, world);
          }
      }
  }