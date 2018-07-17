using System.Collections.Generic;
namespace Artemis.Annotations {

    /**
     * Pooled
     *
     * 
     *     @Pooled()
     *     export class BoundsComponent extends PooledComponent {
     *          ...
     * 
     * Adds to Pooled['pooledComponents']
     * 
     */
    public class Pooled : Object {

        public static Dictionary<string, Object> pooledComponents;
        
        public static void Init()
        {
            pooledComponents = new Dictionary<string, Object>(); 
        }

    }
}


