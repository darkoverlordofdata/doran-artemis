namespace Artemis.Blackboard 
{
  
    public class TriggerMultiCondition : Trigger 
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
         * @param condition The condition.
         * @param onFire  The event.
         * @param names  The names.
         */
        public TriggerMultiCondition(Condition condition, OnFire onFire, string[] names) 
        {
            base(names);
            this.condition = condition;
            this.onFire = onFire;
        }
    
        /**
         * Removes the this trigger.
         */
        public void RemoveThisTrigger() 
        {
            this.BlackBoard.RemoveTrigger(this);
        }
    
        /**
         * Called if is fired.
         * @param triggerStateType  State of the trigger.
         */
        protected override void CalledOnFire(TriggerStateType triggerStateType) 
        {
            if (onFire != null) {
                onFire(triggerStateType);
            }
        }
    
        /**
         * Checks the condition to fire.
         * @returns {boolean} if XXXX, false otherwise
         */
        protected override bool CheckConditionToFire() 
        {
            return condition(BlackBoard, TriggerStateType);
        }
    }
}