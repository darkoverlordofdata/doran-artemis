using Gee;
namespace Artemis.Blackboard {

    public class BlackBoard : Object {
  
        /** the intelligence. */
        private HashMap<string, Object> intelligence;
    
        /** the triggers. */
        private HashMap<string, ArrayList> triggers;
    
        /**
         * Initializes a new instance of the BlackBoard class
         */
        public BlackBoard() {
            intelligence = new HashMap<string, Object>();
            triggers = new HashMap<string, ArrayList<Trigger>>();
        }
    
        /**
         * Adds the trigger.
         *
         * @param trigger   The trigger.
         * @param evaluateNow if set to true [evaluate now].
         */
        public void addTrigger(Trigger trigger, bool evaluateNow=false) {
    
            trigger.blackboard = this;
            for (var i=0; i<trigger.worldPropertiesMonitored.size; i++) {
                var intelName = trigger.worldPropertiesMonitored[i];

                if (!triggers.contains(intelName)) 
                    triggers[intelName] = new ArrayList<Trigger>();
                    
                ((ArrayList<Trigger>)triggers[intelName]).add(trigger);
            }
    
            if (evaluateNow) {
                if (trigger.isFired == false) {
                    trigger.fire(TriggerStateType.TriggerAdded);
                }
            }
        }
    
        /**
         * Atomics the operate on entry.
         * @param operation The operation.
         */
        public void atomicOperateOnEntry(Func<BlackBoard> operation) {
            operation(this);
        }
    
        /**
         * Gets the entry.
         *
         * @param name  The name.
         * @returns {T} The specified element.
         */
        public T getEntry<T>(string name) {
            return intelligence[name];
        }
    
        /**
         * Removes the entry.
         * @param name  The name.
         */
        public void removeEntry(string name) {
            if (intelligence.contains(name)) {
                intelligence.remove(name);
                if (triggers.contains(name)) {
                    foreach (Trigger item in (ArrayList<Trigger>)triggers[name]) {
                        if (item.isFired == false) {
                            item.fire(TriggerStateType.ValueRemoved);
                        }
                    }
                }
            }
        }
    
        /**
         * Removes the trigger.
         * @param trigger The trigger.
         */
        public void removeTrigger(Trigger trigger) {
    
            for (var i=0; i<trigger.worldPropertiesMonitored.size; i++) {
                var intelName = trigger.worldPropertiesMonitored[i];
                ArrayList<Trigger> item = triggers[intelName];
                var index = item.index_of(trigger);
                if (index != -1) {
                    item.remove_at(index);
                }
            }
        }
    
        /**
         * Sets the entry.
         * @param name  The name.
         * @param intel The intel.
         */
        public void setEntry<T>(string name, T intel) {
    
            var triggerStateType = intelligence.contains(name) 
                ? TriggerStateType.ValueChanged 
                : TriggerStateType.ValueAdded;

            intelligence[name] = (Object)intel;
    
            if (triggers.contains(name)) {
                foreach (Trigger item in (ArrayList<Trigger>)triggers[name]) {
                    if (item.isFired == false) {
                        item.fire(triggerStateType);
                    }
                }
            }
        }

        /**
         * Get a list of all related triggers.]
         *
         * @param name  The name.
         * @returns {Array<Trigger>}  List of appropriated triggers.
         */
        public Trigger[] triggerList(string name) {
            return (Trigger[])triggers[name].to_array();
        }
    }
}