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
namespace Artemis 
{ 
    using Artemis.Utils;
    using Artemis.Blackboard;
    using System.Collections.Generic;

    /**
     * The most raw entity system. It should not typically be used, but you can create your own
     * entity system handling by extending  It is recommended that you use the other provided
     * entity system implementations.
     * 
     * @author Arni Arent
     *
     */
    public abstract class EntitySystem : EntityObserver 
    {
        public static BlackBoard blackboard;
        private int systemIndex;
    
        public World World;
    
        private Bag<Entity> actives;
    
        private Aspect aspect;
    
        private BitSet allSet;
        private BitSet exclusionSet;
        private BitSet oneSet;

        private bool passive;
    
        private bool dummy;

        public static Blackboard.BlackBoard BlackBoard
        {
            get 
            {
                if (blackboard == null)
                    blackboard = new Blackboard.BlackBoard(); 
                return blackboard;
            }
        }

        /**
         * Creates an entity system that uses the specified aspect as a matcher against entities.
         * @param aspect to match against entities
         */
        public EntitySystem(Aspect aspect) 
        {
            actives = new Bag<Entity>();
            this.aspect = aspect;
            systemIndex = SystemIndexManager.GetIndexFor(get_type());
            allSet = aspect.GetAllSet();
            exclusionSet = aspect.GetExclusionSet();
            oneSet = aspect.GetOneSet();
            dummy = allSet.IsEmpty() && oneSet.IsEmpty(); // This system can't possibly be interested in any entity, so it must be "dummy"
        }
        
        /**
         * Called before processing of entities begins. 
         */
        protected virtual void Begin() {}
    
        public void Process() {
            if (CheckProcessing()) {
                Begin();
                ProcessEntities(actives);
                End();
            }
        }
        
        /**
         * Called after the processing of entities ends.
         */
        public virtual void End() {}
        
        /**
         * Any implementing entity system must implement this method and the logic
         * to process the given entities of the system.
         * 
         * @param entities the entities this system contains.
         */
        protected abstract void ProcessEntities(ImmutableBag<Entity> entities);
        
        /**
         * 
         * @return true if the system should be processed, false if not.
         */
        protected virtual bool CheckProcessing() {
            return true;
        }
    
        /**
         * Override to implement code that gets executed when systems are initialized.
         */
        public virtual void Initialize() {}
    
        /**
         * Called if the system has received a entity it is interested in, e.g. created or a component was added to it.
         * @param e the entity that was added to this system.
         */
        public virtual void Inserted(Entity e) {}
    
        /**
         * Called if a entity was removed from this system, e.g. deleted or had one of it's components removed.
         * @param e the entity that was removed from this system.
         */
        protected virtual void Removed(Entity e) {}
    
        /**
         * Will Check if the entity is of interest to this system.
         * @param e entity to Check
         */
        protected void Check(Entity e) {
            if (dummy) {
                return;
            }
            var contains = e.SystemBits[systemIndex];
            var interested = true; // possibly interested, let's try to prove it wrong.
            
            var componentBits = e.ComponentBits;
    
            // Check if the entity possesses ALL of the components defined in the aspect.
            if (!allSet.IsEmpty()) {
                for (var i = allSet.NextSetBit(0); i >= 0; i = allSet.NextSetBit(i+1)) {
                    if (!componentBits[i]) {
                        interested = false;
                        break;
                    }
                }
            }

            // Check if the entity possesses ANY of the exclusion components, if it does then the system is not interested.
            if (!exclusionSet.IsEmpty() && interested) {
                interested = !exclusionSet.Intersects(componentBits);
            }
            
            // Check if the entity possesses ANY of the components in the oneSet. If so, the system is interested.
            if(!oneSet.IsEmpty()) {
                interested = oneSet.Intersects(componentBits);
            }

            if (interested && !contains) 
            {
                InsertToSystem(e);
            } 
            else if (!interested && contains) 
            {
                RemoveFromSystem(e);
            }
        }
    
        private void RemoveFromSystem(Entity e) {
            actives.Remove(e);
            e.SystemBits.Clear(systemIndex);
            Removed(e);
        }
    
        private void InsertToSystem(Entity e) {
            actives.Add(e);
            e.SystemBits[systemIndex] = true;
            Inserted(e);
        }
        
        public override void Added(Entity e) {
            Check(e);
        }
        
        public override void Changed(Entity e) {
            Check(e);
        }
        
        public override void Deleted(Entity e) {
            if(e.SystemBits[systemIndex]) {
                RemoveFromSystem(e);
            }
        }
        
        public override void Disabled(Entity e) {
            if(e.SystemBits[systemIndex]) {
                RemoveFromSystem(e);
            }
        }

        public override void Enabled(Entity e) {
            Check(e);
        }
    
        public void SetWorld(World world) {
            this.World = world;
        }
        
        public bool IsPassive() {
            return passive;
        }
    
        public void SetPassive(bool passive) {
            this.passive = passive;
        }
        
        public ImmutableBag<Entity> GetActive() {
            return actives;
        }
        
        public string to_string()
        {
            var s = new StringBuilder("%s (%s)\n".printf(get_type().name(), allSet.to_string()));
            foreach (var e in actives)
                s.append("  %s\n".printf(e.to_string()));
            return s.str;
        } 
    }
    /**
     * Used to generate a unique bit for each system.
     * Only used internally in EntitySystem.
     */
    private class SystemIndexManager 
    {
        private static int INDEX = 0;
        private static Dictionary<Type, int> indices;
        
        public static int GetIndexFor(Type es) 
        {
            indices = indices ?? new Dictionary<Type, int>();

            var index = 0;
            
            if (indices.ContainsKey(es)) 
            {
                index = indices[es];
            } 
            else 
            {
                index = INDEX++;
                indices[es] = index;
            }
            return index;
        }
    }
}

