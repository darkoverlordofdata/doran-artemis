using System.Collections.Generic;

namespace Artemis.Blackboard 
{
  
    public class Trigger : Object 
    {
  
        private delegate void OnFire(Trigger t);
        /** Occurs when [on fire]. */
        private OnFire onFire;
    
        /** Gets the blackboard. */
        public BlackBoard BlackBoard;
    
        /** Gets the state of the trigger. */
        public TriggerStateType TriggerStateType;
    
        /** Gets or sets the entityWorld properties monitored. */
        public ArrayList<string> WorldPropertiesMonitored;
    
        /** Gets or sets a value indicating whether this instance is fired. */
        public bool IsFired;
    
        /**
         * Initializes a new instance of the Trigger class
         * @param propertyName Name of the property.
         */
        public Trigger(string[] propertyName) 
        {
            IsFired = false;
            WorldPropertiesMonitored = new ArrayList<string>();
            foreach (var item in propertyName)
            {
                WorldPropertiesMonitored.Add(item);
            }
    
        }
    
        /**
         * Removes the this trigger.
         */
        public void RemoveThisTrigger() 
        {
            BlackBoard.RemoveTrigger(this);
        }
    
        /**
         * Fires the specified trigger state.
         * @param TriggerStateType
         */
        public void Fire(TriggerStateType triggerStateType) 
        {
            IsFired = true;
            TriggerStateType = triggerStateType;
            if (CheckConditionToFire()) {
                CalledOnFire(TriggerStateType);
                if (onFire != null) {
                    onFire(this);
                }
            }
            this.IsFired = false;
        }
    
        /**
         * Called if is fired.
         * @param TriggerStateType  State of the trigger.
         */
        protected virtual void CalledOnFire(TriggerStateType triggerStateType) {}
    
        /**
         * Checks the condition to fire.
         * @returns {boolean} if XXXX, false otherwise
         */
        protected virtual bool CheckConditionToFire() 
        {
            return true;
        }
  
    }
}