/**
 * The most raw entity system. It should not typically be used, but you can create your own
 * entity system handling by extending  It is recommended that you use the other provided
 * entity system implementations.
 * 
 * @author Arni Arent
 *
 */
using Gee;
using Artemis.Utils;
using Artemis.Blackboard;

namespace Artemis {
    
    public abstract class EntitySystem : Object, EntityObserver {

        public static BlackBoard blackBoard = new BlackBoard();
        private int systemIndex;
    
        public World world;
    
        private Bag<Entity> actives;
    
        private Aspect aspect;
    
        private BitSet allSet;
        private BitSet exclusionSet;
        private BitSet oneSet;
    
        private bool passive;
    
        private bool dummy;
        
        /**
         * Creates an entity system that uses the specified aspect as a matcher against entities.
        * @param aspect to match against entities
        */
        public EntitySystem(Aspect aspect) {
            actives = new Bag<Entity>();
            this.aspect = aspect;
            systemIndex = SystemIndexManager.getIndexFor(typeof(EntitySystem));
            allSet = aspect.getAllSet();
            exclusionSet = aspect.getExclusionSet();
            oneSet = aspect.getOneSet();
            dummy = allSet.isEmpty() && oneSet.isEmpty(); // This system can't possibly be interested in any entity, so it must be "dummy"
        }
        
        /**
         * Called before processing of entities begins. 
         */
        protected void begin() {}
    
        public void process() {
            if (checkProcessing()) {
                begin();
                processEntities(actives);
                end();
            }
        }
        
        /**
         * Called after the processing of entities ends.
         */
        protected void end() {}
        
        /**
         * Any implementing entity system must implement this method and the logic
         * to process the given entities of the system.
         * 
         * @param entities the entities this system contains.
         */
        protected abstract void processEntities(ImmutableBag<Entity> entities);
        
        /**
         * 
         * @return true if the system should be processed, false if not.
         */
        protected virtual bool checkProcessing() {
            return true;
        }
    
        /**
         * Override to implement code that gets executed when systems are initialized.
        */
        public void initialize() {}
    
        /**
         * Called if the system has received a entity it is interested in, e.g. created or a component was added to it.
        * @param e the entity that was added to this system.
        */
        public void inserted(Entity e) {}
    
        /**
         * Called if a entity was removed from this system, e.g. deleted or had one of it's components removed.
        * @param e the entity that was removed from this system.
        */
        protected void removed(Entity e) {}
    
        /**
         * Will check if the entity is of interest to this system.
        * @param e entity to check
        */
        protected void check(Entity e) {
            if (dummy) {
                return;
            }
            
            var contains = e.getSystemBits().get(systemIndex);
            var interested = true; // possibly interested, let's try to prove it wrong.
            
            var componentBits = e.getComponentBits();
    
            // Check if the entity possesses ALL of the components defined in the aspect.
            if (!allSet.isEmpty()) {
                for (var i = allSet.nextSetBit(0); i >= 0; i = allSet.nextSetBit(i+1)) {
                    if (!componentBits.get(i)) {
                        interested = false;
                        break;
                    }
                }
            }
            
            // Check if the entity possesses ANY of the exclusion components, if it does then the system is not interested.
            if (!exclusionSet.isEmpty() && interested) {
                interested = !exclusionSet.intersects(componentBits);
            }
            
            // Check if the entity possesses ANY of the components in the oneSet. If so, the system is interested.
            if(!oneSet.isEmpty()) {
                interested = oneSet.intersects(componentBits);
            }
    
            if (interested && !contains) {
                insertToSystem(e);
            } else if (!interested && contains) {
                removeFromSystem(e);
            }
        }
    
        private void removeFromSystem(Entity e) {
            actives.remove(e);
            e.getSystemBits().clear(systemIndex);
            removed(e);
        }
    
        private void insertToSystem(Entity e) {
            actives.add(e);
            e.getSystemBits().set(systemIndex);
            inserted(e);
        }
        
        
        
        public void added(Entity e) {
            check(e);
        }
        
        
        public void changed(Entity e) {
            check(e);
        }
        
        
        public void deleted(Entity e) {
            if(e.getSystemBits().get(systemIndex)) {
                removeFromSystem(e);
            }
        }
        
        
        public void disabled(Entity e) {
            if(e.getSystemBits().get(systemIndex)) {
                removeFromSystem(e);
            }
        }

        public void enabled(Entity e) {
            check(e);
        }
        
    
        public void setWorld(World world) {
            this.world = world;
        }
        
        public bool isPassive() {
            return passive;
        }
    
        public void setPassive(bool passive) {
            this.passive = passive;
        }
        
        public ImmutableBag<Entity> getActive() {
            return actives;
        }
    }
    /**
     * Used to generate a unique bit for each system.
     * Only used internally in EntitySystem.
     */
    class SystemIndexManager {
        private static int INDEX = 0;
        private static HashMap<Type, int> indices = new HashMap<Type, int>();
        
        public static int getIndexFor(Type es) {

            var index = 0;
            
            if (indices.contains(es)) {
                index = indices[es];
            } else {
                index = INDEX++;
                indices[es] = index;
            }
            return index;
        }
    }
}

