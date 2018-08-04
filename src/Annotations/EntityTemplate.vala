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
namespace Artemis.Annotations 
{

    using System.Collections.Generic;
    /**
     * EntityTemplate
     * 
     * 
     *   @EntityTemplate('player')
     *   export class PlayerTemplate implements IEntityTemplate {
     *
     *       public buildEntity(entity:Entity, world:World):Entity {
     *          ...
     *
     * 
     *  Adds class to 
     *       EntityTemplate['entityTemplates'][component] = target;
     */
    public class EntityTemplate : Object 
    {

        public static Dictionary<string, Type> entityTemplates;

        public static Dictionary<string, Type> Templates
        {
            get 
            {
                if (entityTemplates == null)
                    entityTemplates = new Dictionary<string, Type>(); 
                return entityTemplates;
            }
        }
        
        public static void Init()
        {
            entityTemplates = new Dictionary<string, Type>(); 
        }

        public static void Register(string name, Type template)
        {
            entityTemplates[name] = template;
        }

    }
}

/**
 * Add the Type to 
 * 
    static construct {
        EntityTemplate.entityTemplates["player"] = typeof(PlayerTemplate);
    }
    
 */

