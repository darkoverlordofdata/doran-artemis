/**
 * You may sometimes want to specify to which player an entity belongs to.
 *
 * An entity can only belong to a single player at a time.
 *
 * @author Arni Arent
 *
 */
using Gee;
using Artemis.Utils;

namespace Artemis.Managers {

    public class PlayerManager : Manager {

        private HashMap<Entity, string> playerByEntity;
        private HashMap<string, Bag<Entity>> entitiesByPlayer;

        public PlayerManager() {
            base();
            playerByEntity = new HashMap<Entity, string>();
            entitiesByPlayer = new HashMap<string, Bag<Entity>>();
        }

        public void setPlayer(Entity e, string player) {
            playerByEntity[e] = player;
            var entities = entitiesByPlayer.get(player);
            if (entities == null) {
                entities = new Bag<Entity>();
                entitiesByPlayer[player] = entities;
            }
            entities.add(e);
        }

        public ImmutableBag<Entity> getEntitiesOfPlayer(string player)  {
            var entities = entitiesByPlayer.get(player);
            if (entities == null) {
                entities = new Bag<Entity>();
            }
            return entities;
        }

        public void removeFromPlayer(Entity e) {
            var player = playerByEntity.get(e);
            if (player != null) {
                var entities = entitiesByPlayer.get(player);
                if(entities != null) {
                    entities.remove(e);
                }
            }
        }

        public string getPlayer(Entity e) {
            return playerByEntity.get(e);
        }


        public override void initialize() {}


        public override void deleted(Entity e) {
            removeFromPlayer(e);
        }

    }
}
