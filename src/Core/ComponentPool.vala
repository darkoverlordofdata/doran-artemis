using Artemis.Utils;

namespace Artemis { 
  
    public class ComponentPool : Object {
  
        private Bag<Pool> pools;
    
        public ComponentPool() {
            this.pools = new Bag<Pool>();
        }
    
        public T obtain<T>(Type componentClass, ComponentType type ) {
            var pool = this.getPool(type.getIndex());
            return ((pool.size() > 0) ? pool.obtain<T>() : Object.new(componentClass));
        }
    
        public void free(PooledComponent c, ComponentType type) {
            this.freeByIndex(c, type.getIndex());
        }
    
        public void freeByIndex(PooledComponent c, int typeIndex) {
            c.reset();
            this.getPool(typeIndex).free(c);
        }
    
        private Pool getPool(int typeIndex) {
            var pool = this.pools.safeGet(typeIndex);
            if (pool == null) {
                pool = new Pool();
                this.pools.set(typeIndex, pool);
            }
            return pool;
        }
    }
    
    public class Pool {
        private Bag<PooledComponent> cache = new Bag<PooledComponent>();
    
        public T obtain<T>() {
            return this.cache.removeLast();
        }
    
        public int size() {
            return this.cache.size();
        }
    
        public void free(PooledComponent component) {
            this.cache.add(component);
        }
    }
}
  
  