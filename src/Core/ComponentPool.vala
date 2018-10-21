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
            return ((pool.Size() > 0) ? pool.Obtain<T>() : GLib.Object.new(componentClass));
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
