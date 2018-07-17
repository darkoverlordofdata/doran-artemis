namespace Artemis {
    
    /**
     * Manager.
    * 
    * @author Arni Arent
    * 
    */
    public abstract class Manager : Object, EntityObserver {
        protected World world;
        
        public abstract void Initialize();
    
        public void SetWorld(World world) {
            this.world = world;
        }
    
        public World GetWorld() {
            return world;
        }
        
        public virtual void Added(Entity e) {}
        
        public virtual void Changed(Entity e) {}
        
        public virtual void Deleted(Entity e) {}
        
        public virtual void Disabled(Entity e) {}
        
        public virtual void Enabled(Entity e) {}
        
    }
}

