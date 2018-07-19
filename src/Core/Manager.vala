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
    
    /**
     * Manager.
    * 
    * @author Arni Arent
    * 
    */
    public abstract class Manager : Object, EntityObserver 
    {
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

