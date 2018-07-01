/**
 * If you need to group your entities together, e.g. tanks going into "units" group or explosions into "effects",
 * then use this manager. You must retrieve it using world instance.
 *
 * A entity can be assigned to more than one group.
 *
 * @author Arni Arent
 *
 */
using Gee;
using Artemis.Utils;
namespace Artemis.Managers {

    public class GroupManager : Manager {

        private HashMap<string, Bag<Entity>> entitiesByGroup;
        private HashMap<Entity, Bag<string>> groupsByEntity;

        public GroupManager() {
            base();
            entitiesByGroup = new HashMap<string, Bag<Entity>>();
            groupsByEntity = new HashMap<Entity, Bag<string>>();
        }

        public override void initialize() {}

        /**
         * Set the group of the entity.
        *
        * @param group group to add the entity into.
        * @param e entity to add into the group.
        */
        public void add(Entity e, string group) {
            var entities = entitiesByGroup.get(group);
            if (entities == null) {
                entities = new Bag<Entity>();
                entitiesByGroup[group] = entities;
            }
            entities.add(e);

            var groups = groupsByEntity.get(e);
            if (groups == null) {
                groups = new Bag<string>();
                groupsByEntity[e] = groups;
            }
            groups.add(group);
        }

        /**
         * Remove the entity from the specified group.
        * @param e
        * @param group
        */
        public void remove(Entity e, string group) {
            var entities = entitiesByGroup.get(group);
            if (entities != null) {
                entities.remove(e);
            }

            var groups = groupsByEntity.get(e);
            if (groups != null) {
                groups.remove(group);
            }
        }

        public void removeFromAllGroups(Entity e) {
            var groups = groupsByEntity.get(e);
            if (groups != null) {
                for(var i = 0, s = groups.size(); s > i; i++) {
                    var entities = entitiesByGroup.get(groups.get(i));
                    if(entities != null) {
                        entities.remove(e);
                    }
                }
                groups.clear();
            }
        }

        /**
         * Get all entities that belong to the provided group.
        * @param group name of the group.
        * @return read-only bag of entities belonging to the group.
        */
        public ImmutableBag<Entity> getEntities(string group) {
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
        public ImmutableBag<string> getGroups(Entity e)  {
            return groupsByEntity.get(e);
        }

        /**
         * Checks if the entity belongs to any group.
        * @param e the entity to check.
        * @return true if it is in any group, false if none.
        */
        public bool isInAnyGroup(Entity e) {
            return getGroups(e) != null;
        }

        /**
         * Check if the entity is in the supplied group.
        * @param group the group to check in.
        * @param e the entity to check for.
        * @return true if the entity is in the supplied group, false if not.
        */
        public bool isInGroup(Entity e, string group) {
            if (group != null) {
                var groups = groupsByEntity.get(e);
                for(var i = 0, s = groups.size(); s > i; i++) {
                    var g = groups.get(i);
                    if (group == g) {
                        return true;
                    }
                }
            }
            return false;
        }


        public override void deleted(Entity e) {
            removeFromAllGroups(e);
        }

    }
}
