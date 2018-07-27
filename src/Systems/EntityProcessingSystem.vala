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
namespace Artemis.Systems 
{
    using Artemis.Utils;

    /**
     * A typical entity system. Use this when you need to process entities possessing the
     * provided component types.
     *
     * @author Arni Arent
     *
     */
    public abstract class EntityProcessingSystem : EntitySystem 
    {
        public EntityProcessingSystem(Aspect aspect) 
        {
            base(aspect);
        }

        /**
         * Process a entity this system is interested in.
        * @param e the entity to process.
        */
        protected abstract void ProcessEach(Entity e);


        protected override void ProcessEntities(ImmutableBag<Entity> entities) 
        {         
            for (var i = 0, s = entities.Size(); s > i; i++) 
            {
                ProcessEach(entities[i]);
            }
        }


        protected override bool CheckProcessing() 
        {
            return true;
        }

    }
}
