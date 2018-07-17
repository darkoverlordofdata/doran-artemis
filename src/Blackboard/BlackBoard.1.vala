using System.Collections.Generic;
namespace Artemis.Blackboard 
{

    public class BlackBoard : Object 
    {
  
        private Object entryLock;

        /** the intelligence. */
        private Dictionary<string, Object> intelligence;
    
        /** the triggers. */
        private Dictionary<string, ArrayList<Trigger>> triggers;
    
        /**
         * Initializes a new instance of the BlackBoard class
         */
        public BlackBoard() 
        {
            intelligence = new Dictionary<string, Object>();
            triggers = new Dictionary<string, ArrayList<Trigger>>();
            entryLock = new Object();
        }
    
        /**
         * Adds the trigger.
         *
         * @param trigger   The trigger.
         * @param evaluateNow if set to true [evaluate now].
         */
        public void AddTrigger(Trigger trigger, bool evaluateNow=false) 
        {

            lock (entryLock)
            {

                trigger.BlackBoard = this;
                foreach (string intelName in trigger.WorldPropertiesMonitored)
                {
                    if (this.triggers.ContainsKey(intelName))
                    {
                        this.triggers[intelName].Add(trigger);
                    }
                    else
                    {
                        this.triggers[intelName] = new ArrayList<Trigger>();
                        this.triggers[intelName].Add(trigger);
                    }
                }

                if (evaluateNow)
                {
                    if (trigger.IsFired == false)
                    {
                        trigger.Fire(TriggerStateType.TriggerAdded);
                    }
                }
            }
        }
    
        /**
         * Atomics the operate on entry.
         * @param operation The operation.
         */
        public void AtomicOperateOnEntry(Func<BlackBoard> operation) 
        {
            lock (entryLock)
            {
                operation(this);
            }
        }
    
        /**
         * Gets the entry.
         *
         * @param name  The name.
         * @returns {T} The specified element.
         */
        public T GetEntry<T>(string name) 
        {
            return (T)intelligence[name];
        }
    
        /**
         * Removes the entry.
         * @param name  The name.
         */
        public void RemoveEntry(string name) 
        {

            lock (entryLock)
            {
                if (intelligence.ContainsKey(name)) {
                    intelligence.Remove(name);
                    if (triggers.ContainsKey(name)) {
                        foreach (Trigger item in (ArrayList<Trigger>)triggers[name]) {
                            if (item.IsFired == false) {
                                item.Fire(TriggerStateType.ValueRemoved);
                            }
                        }
                    }
                }
            }
        }
    
        /**
         * Removes the trigger.
         * @param trigger The trigger.
         */
        public void RemoveTrigger(Trigger trigger) 
        {
    
            lock (entryLock)
            {
                foreach (string intelName in trigger.WorldPropertiesMonitored)
                {
                    this.triggers[intelName].Remove(trigger);
                }
            }
        }
    
        /**
         * Sets the entry.
         * @param name  The name.
         * @param intel The intel.
         */
        public void SetEntry<T>(string name, T intel) 
        {
            lock (entryLock)
            {
                var triggerStateType = intelligence.ContainsKey(name) 
                    ? TriggerStateType.ValueChanged 
                    : TriggerStateType.ValueAdded;

                intelligence[name] = (Object)intel;
        
                if (triggers.ContainsKey(name)) {
                    foreach (Trigger item in (ArrayList<Trigger>)triggers[name]) {
                        if (item.IsFired == false) {
                            item.Fire(triggerStateType);
                        }
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
        public Trigger[] TriggerList(string name) 
        {
            return (Trigger[])triggers[name].ToArray();
        }
    }
}