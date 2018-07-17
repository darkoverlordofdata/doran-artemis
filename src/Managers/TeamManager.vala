/**
 * Use this class together with PlayerManager.
 *
 * You may sometimes want to create teams in your game, so that
 * some players are team mates.
 *
 * A player can only belong to a single team.
 *
 * @author Arni Arent
 *
 */
using System.Collections.Generic;
using Artemis.Utils;

namespace Artemis.Managers {

    public class TeamManager : Manager {

        private Dictionary<string, Bag<string>> playersByTeam;
        private Dictionary<string, string> teamByPlayer;

        public TeamManager() {
            base();
            playersByTeam = new Dictionary<string, Bag<string>>();
            teamByPlayer = new Dictionary<string, string>();
        }

        public override void Initialize() {}

        public string GetTeam(string player) {
            return teamByPlayer[player];
        }

        public void SetTeam(string player, string team) {
            RemoveFromTeam(player);

            teamByPlayer[player] = team;

            var players = playersByTeam.get(team);
            if(players == null) {
                players = new Bag<string>();
                playersByTeam[team] = players;
            }
            players.Add(player);
        }

        public ImmutableBag<string> GetPlayers(string team)  {
            return playersByTeam[team];
        }

        public void RemoveFromTeam(string player) {
            var team = teamByPlayer[player];
            if (teamByPlayer.Remove(player)) {
                var players = playersByTeam[team];
                if (players != null) {
                    players.Remove(player);
                }
            }
        }

    }
}
