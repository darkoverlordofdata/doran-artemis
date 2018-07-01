/**
 * If you need to process entities at a certain interval then use this.
 * A typical usage would be to regenerate ammo or health at certain intervals, no need
 * to do that every game loop, but perhaps every 100 ms. or every second.
 *
 * @author Arni Arent
 *
 */
using Artemis.Utils;

namespace Artemis.Systems {

	public abstract class IntervalEntityProcessingSystem : IntervalEntitySystem {

		public IntervalEntityProcessingSystem(Aspect aspect, float interval) {
			base(aspect, interval);
		}


		/**
		* Process a entity this system is interested in.
		* @param e the entity to process.
		*/
		public abstract void processEach(Entity e);



		protected override void processEntities(ImmutableBag<Entity> entities) {
			for (var i = 0, s = entities.size(); s > i; i++) {
				this.processEach(entities[i]);
			}
		}

	}
}
