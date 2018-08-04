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
    using Artemis.Annotations;

    public enum Taxonomy 
    {
      BASIC, POOLED 
    }

    public class ComponentType : Object 
    {
        private static int INDEX = 0;
        public static ComponentManager componentManager;
    
        private int index = 0;
        private Type type;
        private Taxonomy taxonomy;

        public ComponentType(Type type, int index) 
        {
            this.index = ComponentType.INDEX++;
            this.type = type;
            if (Pooled.pooledComponents.ContainsKey(type.name()))
            {
                if (Pooled.pooledComponents[type.name()] == (Type)type) {
                    this.taxonomy = Taxonomy.POOLED;
                } else {
                    this.taxonomy = Taxonomy.BASIC;
                }
            }
            else
            {
                this.taxonomy = Taxonomy.BASIC;
            }
        }

        public string GetName() 
        {
            return type.name();
        }

        public int GetIndex() 
        {
            return index;
        }

        public Taxonomy GetTaxonomy() 
        {
            return taxonomy;
        }
        
        public string ToString() 
        {
            return "ComponentType (%s - %d)".printf(type.name(), index);
        }
    }
}
