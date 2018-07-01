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
using Gee;
using Artemis.Utils;

namespace Artemis.Managers {

    public class TeamManager : Manager {

        private HashMap<string, Bag<string>> playersByTeam;
        private HashMap<string, string> teamByPlayer;

        public TeamManager() {
            base();
            playersByTeam = new HashMap<string, Bag<string>>();
            teamByPlayer = new HashMap<string, string>();
        }

        public override void initialize() {}

        public string getTeam(string player) {
            return teamByPlayer[player];
        }

        public void setTeam(string player, string team) {
            removeFromTeam(player);

            teamByPlayer[player] = team;

            var players = playersByTeam.get(team);
            if(players == null) {
                players = new Bag<string>();
                playersByTeam[team] = players;
            }
            players.add(player);
        }

        public ImmutableBag<string> getPlayers(string team)  {
            return playersByTeam[team];
        }

        public void removeFromTeam(string player) {
            string team;
            if (teamByPlayer.remove(player, out team)) {
                var players = playersByTeam[team];
                if (players != null) {
                    players.remove(player);
                }
            }
        }

    }
}
