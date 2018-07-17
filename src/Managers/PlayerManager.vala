/**
 * You may sometimes want to specify to which player an entity belongs to.
 *
 * An entity can only belong to a single player at a time.
 *
 * @author Arni Arent
 *
 */
using System.Collections.Generic;
using Artemis.Utils;

namespace Artemis.Managers {

    public class PlayerManager : Manager {

        private Dictionary<Entity, string> playerByEntity;
        private Dictionary<string, Bag<Entity>> entitiesByPlayer;

        public PlayerManager() {
            base();
            playerByEntity = new Dictionary<Entity, string>();
            entitiesByPlayer = new Dictionary<string, Bag<Entity>>();
        }

        public void SetPlayer(Entity e, string player) {
            playerByEntity[e] = player;
            var entities = entitiesByPlayer.get(player);
            if (entities == null) {
                entities = new Bag<Entity>();
                entitiesByPlayer[player] = entities;
            }
            entities.Add(e);
        }

        public ImmutableBag<Entity> GetEntitiesOfPlayer(string player)  {
            var entities = entitiesByPlayer.get(player);
            if (entities == null) {
                entities = new Bag<Entity>();
            }
            return entities;
        }

        public void RemoveFromPlayer(Entity e) {
            var player = playerByEntity.get(e);
            if (player != null) {
                var entities = entitiesByPlayer.get(player);
                if(entities != null) {
                    entities.Remove(e);
                }
            }
        }

        public string GetPlayer(Entity e) {
            return playerByEntity.get(e);
        }


        public override void Initialize() {}


        public override void Deleted(Entity e) {
            RemoveFromPlayer(e);
        }

    }
}
