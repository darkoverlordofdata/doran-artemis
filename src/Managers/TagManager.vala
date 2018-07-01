/**
 * If you need to tag any entity, use  A typical usage would be to tag
 * entities such as "PLAYER", "BOSS" or something that is very unique.
 *
 * @author Arni Arent
 *
 */
using Gee;
using Artemis.Utils;

namespace Artemis.Managers {

    public class TagManager : Manager {

        private HashMap<string, Entity> entitiesByTag;
        private HashMap<Entity, string> tagsByEntity;

        public TagManager() {
            base();
            entitiesByTag = new HashMap<string, Entity>();
            tagsByEntity = new HashMap<Entity, string>();
        }

        public void register(string tag, Entity e) {
            entitiesByTag[tag] = e;
            tagsByEntity[e] = tag;
        }

        public void unregister(string tag) {
            tagsByEntity.unset(entitiesByTag[tag]);
            entitiesByTag.unset(tag);
        }

        public bool isRegistered(string tag) {
            return entitiesByTag.has_key(tag);
        }

        public Entity getEntity(string tag) {
            return entitiesByTag[tag];
        }

        public string[] getRegisteredTags() {
            return tagsByEntity.values.to_array();
        }

        public override void deleted(Entity e) {
            entitiesByTag.unset(tagsByEntity[e]);
            tagsByEntity.unset(e);
        }

        public override void initialize() {}

    }
}
