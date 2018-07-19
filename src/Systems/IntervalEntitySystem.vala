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

    /**
     * A system that processes entities at a interval in milliseconds.
     * A typical usage would be a collision system or physics system.
     *
     * @author Arni Arent
     *
     */
    public abstract class IntervalEntitySystem : EntitySystem {
        private float acc = 0;
        private float interval = 0;

        public IntervalEntitySystem(Aspect aspect, float interval) {
            base(aspect);
            this.interval = interval;
        }


        protected override bool CheckProcessing() {

            if ((acc += World.GetDelta()) >= interval) {
                acc -= interval;
                return true;
            }
            return false;
        }

    }
}
