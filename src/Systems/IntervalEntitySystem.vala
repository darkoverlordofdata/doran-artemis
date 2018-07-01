/**
 * A system that processes entities at a interval in milliseconds.
 * A typical usage would be a collision system or physics system.
 *
 * @author Arni Arent
 *
 */
namespace Artemis.Systems {

    public abstract class IntervalEntitySystem : EntitySystem {
        private float acc = 0;
        private float interval = 0;

        public IntervalEntitySystem(Aspect aspect, float interval) {
            base(aspect);
            this.interval = interval;
        }


        protected override bool checkProcessing() {

            if ((acc += world.getDelta()) >= interval) {
                acc -= interval;
                return true;
            }
            return false;
        }

    }
}
