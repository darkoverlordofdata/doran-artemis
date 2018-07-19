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
     * If you need to group your entities together, e.g. tanks going into "units" group or explosions into "effects",
     * then use this manager. You must retrieve it using world instance.
     *
     * A entity can be assigned to more than one group.
     *
     * @author Arni Arent
     *
     */
    public class GroupManager : Manager {

        private Dictionary<string, Bag<Entity>> entitiesByGroup;
        private Dictionary<Entity, Bag<string>> groupsByEntity;

        public GroupManager() {
            base();
            entitiesByGroup = new Dictionary<string, Bag<Entity>>();
            groupsByEntity = new Dictionary<Entity, Bag<string>>();
        }

        public override void Initialize() {}

        /**
         * Set the group of the entity.
        *
        * @param group group to add the entity into.
        * @param e entity to add into the group.
        */
        public void Add(Entity e, string group) {
            var entities = entitiesByGroup.get(group);
            if (entities == null) {
                entities = new Bag<Entity>();
                entitiesByGroup[group] = entities;
            }
            entities.Add(e);

            var groups = groupsByEntity.get(e);
            if (groups == null) {
                groups = new Bag<string>();
                groupsByEntity[e] = groups;
            }
            groups.Add(group);
        }

        /**
         * Remove the entity from the specified group.
        * @param e
        * @param group
        */
        public void Remove(Entity e, string group) {
            var entities = entitiesByGroup.get(group);
            if (entities != null) {
                entities.Remove(e);
            }

            var groups = groupsByEntity.get(e);
            if (groups != null) {
                groups.Remove(group);
            }
        }

        public void RemoveFromAllGroups(Entity e) {
            var groups = groupsByEntity.get(e);
            if (groups != null) {
                for(var i = 0, s = groups.Size(); s > i; i++) {
                    var entities = entitiesByGroup.get(groups.get(i));
                    if(entities != null) {
                        entities.Remove(e);
                    }
                }
                groups.Clear();
            }
        }

        /**
         * Get all entities that belong to the provided group.
        * @param group name of the group.
        * @return read-only bag of entities belonging to the group.
        */
        public ImmutableBag<Entity> GetEntities(string group) {
            var entities = entitiesByGroup.get(group);
            if (entities == null) {
                entities = new Bag<Entity>();
                entitiesByGroup[group] = entities;
            }
            return entities;
        }

        /**
         * @param e entity
        * @return the groups the entity belongs to, null if none.
        */
        public ImmutableBag<string> GetGroups(Entity e)  {
            return groupsByEntity.get(e);
        }

        /**
         * Checks if the entity belongs to any group.
        * @param e the entity to check.
        * @return true if it is in any group, false if none.
        */
        public bool IsInAnyGroup(Entity e) {
            return GetGroups(e) != null;
        }

        /**
         * Check if the entity is in the supplied group.
        * @param group the group to check in.
        * @param e the entity to check for.
        * @return true if the entity is in the supplied group, false if not.
        */
        public bool IsInGroup(Entity e, string group) {
            if (group != null) {
                var groups = groupsByEntity.get(e);
                for(var i = 0, s = groups.Size(); s > i; i++) {
                    var g = groups[i];
                    if (group == g) {
                        return true;
                    }
                }
            }
            return false;
        }


        public override void Deleted(Entity e) {
            RemoveFromAllGroups(e);
        }

    }
}
