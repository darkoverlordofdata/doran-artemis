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