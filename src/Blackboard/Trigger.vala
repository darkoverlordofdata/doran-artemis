using Gee;

namespace Artemis.Blackboard {
  
    public class Trigger : Object {
  
        private delegate void OnFire(Trigger t);
        /** Occurs when [on fire]. */
        private OnFire onFire;
    
        /** Gets the blackboard. */
        public BlackBoard blackboard;
    
        /** Gets the state of the trigger. */
        public TriggerStateType triggerStateType;
    
        /** Gets or sets the entityWorld properties monitored. */
        public ArrayList<string> worldPropertiesMonitored;
    
        /** Gets or sets a value indicating whether this instance is fired. */
        public bool isFired;
    
        /**
         * Initializes a new instance of the Trigger class
         * @param propertyName Name of the property.
         */
        public Trigger(string[] propertyNames) {
            isFired = false;
            worldPropertiesMonitored = new ArrayList<string>();
            worldPropertiesMonitored.add_all_array(propertyNames);
    
        }
    
        /**
         * Removes the this trigger.
         */
        public void removeThisTrigger() {
            blackboard.removeTrigger(this);
        }
    
        /**
         * Fires the specified trigger state.
         * @param triggerStateType
         */
        public void fire(TriggerStateType triggerStateType) {
            isFired = true;
            triggerStateType = triggerStateType;
            if (checkConditionToFire()) {
                calledOnFire(triggerStateType);
                if (onFire != null) {
                    onFire(this);
                }
            }
            this.isFired = false;
        }
    
        /**
         * Called if is fired.
         * @param triggerStateType  State of the trigger.
         */
        protected void calledOnFire(TriggerStateType triggerStateType) {}
    
        /**
         * Checks the condition to fire.
         * @returns {boolean} if XXXX, false otherwise
         */
        protected bool checkConditionToFire() {
            return true;
        }
  
    }
}