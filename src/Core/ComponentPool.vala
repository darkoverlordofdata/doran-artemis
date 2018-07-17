using Artemis.Utils;

namespace Artemis 
{ 
    public class ComponentPool : Object 
    {
        private Bag<Pool> pools;
    
        public ComponentPool() 
        {
            this.pools = new Bag<Pool>();
        }
    
        public T Obtain<T>(Type componentClass, ComponentType type ) 
        {
            var pool = this.GetPool(type.GetIndex());
            return ((pool.Size() > 0) ? pool.Obtain<T>() : Object.new(componentClass));
        }
    
        public void Free(PooledComponent c, ComponentType type) 
        {
            this.FreeByIndex(c, type.GetIndex());
        }
    
        public void FreeByIndex(PooledComponent c, int typeIndex) 
        {
            c.Reset();
            this.GetPool(typeIndex).Free(c);
        }
    
        private Pool GetPool(int typeIndex) 
        {
            var pool = this.pools.SafeGet(typeIndex);
            if (pool == null) {
                pool = new Pool();
                this.pools.set(typeIndex, pool);
            }
            return pool;
        }
    }
    
    public class Pool 
    {
        private Bag<PooledComponent> cache = new Bag<PooledComponent>();
    
        public T Obtain<T>() 
        {
            return this.cache.RemoveLast();
        }
    
        public int Size() 
        {
            return this.cache.Size();
        }
    
        public void Free(PooledComponent component) 
        {
            this.cache.Add(component);
        }
    }
}
