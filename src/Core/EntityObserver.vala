namespace Artemis {
      
    public interface EntityObserver : Object {
        
        public abstract void added(Entity e);
        
        public abstract void changed(Entity e);
        
        public abstract void deleted(Entity e);
        
        public abstract void enabled(Entity e);
        
        public abstract void disabled(Entity e);
        
    }
}
  