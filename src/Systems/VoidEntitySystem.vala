/**
 * This system has an empty aspect so it processes no entities, but it still gets invoked.
 * You can use this system if you need to execute some game logic and not have to concern
 * yourself about aspects or entities.
 *
 * @author Arni Arent
 *
 */
using Artemis.Utils;

namespace Artemis.Systems {

    public abstract class VoidEntitySystem : EntitySystem {

        public VoidEntitySystem() {
            base(Aspect.GetEmpty());
        }


        protected override void ProcessEntities(ImmutableBag<Entity> entities) {
            this.ProcessSystem();
        }

        protected abstract void ProcessSystem();


        protected override bool CheckProcessing() {
            return true;
        }

    }
}
