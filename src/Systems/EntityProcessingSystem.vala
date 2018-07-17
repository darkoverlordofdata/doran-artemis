/**
 * A typical entity system. Use this when you need to process entities possessing the
 * provided component types.
 *
 * @author Arni Arent
 *
 */
using Artemis.Utils;

namespace Artemis.Systems {

    public abstract class EntityProcessingSystem : EntitySystem {

        public EntityProcessingSystem(Aspect aspect) {
            base(aspect);
        }

        /**
         * Process a entity this system is interested in.
        * @param e the entity to process.
        */
        protected abstract void ProcessEach(Entity e);


        protected override void ProcessEntities(ImmutableBag<Entity> entities) {
            for (var i = 0, s = entities.Size(); s > i; i++) {
                ProcessEach(entities[i]);
            }
        }


        protected override bool CheckProcessing() {
            return true;
        }

    }
}
