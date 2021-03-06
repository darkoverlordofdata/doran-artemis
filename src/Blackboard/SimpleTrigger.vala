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
namespace Artemis.Blackboard 
{
  
    public class SimpleTrigger : Trigger 
    {

        public delegate bool Condition(BlackBoard b, TriggerStateType t);
        public delegate void OnFire(TriggerStateType t);

        /** The condition. */
        private Condition condition;
    
        /** The onFire event. */
        private OnFire onFire;
        
        /**
         * Initializes a new instance of the SimpleTrigger class.
         *
         * @param name  The name.
         * @param condition The condition.
         * @param onFire  The event.
         */
        public SimpleTrigger(string name, Condition condition, OnFire onFire) 
        {
            base( { name } );
            this.condition = condition;
            this.onFire = onFire;
        }
    
        /**
         * Called if is fired.
         * @param triggerStateType  State of the trigger.
         */
        protected void CalledOnFire(TriggerStateType triggerStateType) 
        {
            if (onFire != null) {
                onFire(triggerStateType);
            }
        }
    
        /**
         * Checks the condition to fire.
         * @returns {boolean} if XXXX, false otherwise
         */
        protected bool checkConditionToFire() 
        {
            return condition(BlackBoard, TriggerStateType);
        }
    }
}