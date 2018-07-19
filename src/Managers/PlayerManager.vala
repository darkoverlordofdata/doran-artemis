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
     * You may sometimes want to specify to which player an entity belongs to.
     *
     * An entity can only belong to a single player at a time.
     *
     * @author Arni Arent
     *
     */
    public class PlayerManager : Manager 
    {

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
