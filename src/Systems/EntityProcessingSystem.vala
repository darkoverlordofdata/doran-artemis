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
        protected abstract void processEach(Entity e);


        protected override void processEntities(ImmutableBag<Entity> entities) {
            for (var i = 0, s = entities.size(); s > i; i++) {
                this.processEach(entities[i]);
            }
        }


        protected override bool checkProcessing() {
            return true;
        }

    }
}
