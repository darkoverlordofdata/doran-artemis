/**
 * If you need to tag any entity, use  A typical usage would be to tag
 * entities such as "PLAYER", "BOSS" or something that is very unique.
 *
 * @author Arni Arent
 *
 */
using System.Collections.Generic;
using Artemis.Utils;

namespace Artemis.Managers {

    public class TagManager : Manager {

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
