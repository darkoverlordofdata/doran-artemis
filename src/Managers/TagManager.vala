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
namespace Artemis.Managers 
{
    using System.Collections.Generic;
    using Artemis.Utils;

    /**
     * If you need to tag any entity, use  A typical usage would be to tag
     * entities such as "PLAYER", "BOSS" or something that is very unique.
     *
     * @author Arni Arent
     *
     */
    public class TagManager : Manager 
    {

        private Dictionary<string, Entity> entitiesByTag;
        private Dictionary<Entity, string> tagsByEntity;

        public TagManager() {
            base();
            entitiesByTag = new Dictionary<string, Entity>();
            tagsByEntity = new Dictionary<Entity, string>();
        }

        public void Register(string tag, Entity e) {
            entitiesByTag[tag] = e;
            tagsByEntity[e] = tag;
        }

        public void Unregister(string tag) {
            tagsByEntity.Remove(entitiesByTag[tag]);
            entitiesByTag.Remove(tag);
        }

        public bool IsRegistered(string tag) {
            return entitiesByTag.ContainsKey(tag);
        }

        public Entity GetEntity(string tag) {
            return entitiesByTag[tag];
        }

        public string[] GetRegisteredTags() {
            return tagsByEntity.Values.ToArray();
        }

        public override void Deleted(Entity e) {
            entitiesByTag.Remove(tagsByEntity[e]);
            tagsByEntity.Remove(e);
        }

        public override void Initialize() {}

    }
}
