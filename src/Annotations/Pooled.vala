using Gee;
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

        public static HashMap<string, Object> pooledComponents = new HashMap<string, Object>(); 

    }
}


