namespace Artemis {
    
    /**
     * Manager.
    * 
    * @author Arni Arent
    * 
    */
    public abstract class Manager : Object, EntityObserver {
        protected World world;
        
        public abstract void initialize();
    
        public void setWorld(World world) {
            this.world = world;
        }
    
        public World getWorld() {
            return world;
        }
        
        public virtual void added(Entity e) {}
        
        public virtual void changed(Entity e) {}
        
        public virtual void deleted(Entity e) {}
        
        public virtual void disabled(Entity e) {}
        
        public virtual void enabled(Entity e) {}
        
    }
}

