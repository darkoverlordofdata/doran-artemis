namespace Artemis {
      
    public interface EntityObserver : Object {
        
        public abstract void Added(Entity e);
        
        public abstract void Changed(Entity e);
        
        public abstract void Deleted(Entity e);
        
        public abstract void Enabled(Entity e);
        
        public abstract void Disabled(Entity e);
        
    }
}
  