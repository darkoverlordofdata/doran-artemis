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

    using System.Collections.Generic;
    
    public class BlackBoard : Object 
    {
  
        private Object entryLock;

        /** the intelligence. */
        private Dictionary<string, System.Variant> intelligence;
    
        /** the triggers. */
        private Dictionary<string, ArrayList<Trigger>> triggers;
    
        /**
         * Initializes a new instance of the BlackBoard class
         */
        public BlackBoard() 
        {
            intelligence = new Dictionary<string, System.Variant>();
            triggers = new Dictionary<string, ArrayList<Trigger>>();
            entryLock = this;//new Object();
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
            return intelligence[name].Value();
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

                intelligence[name] = new System.Variant<T>(intel);
        
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