using Gee;
namespace Artemis.Annotations {

    /**
     * Mapper
     *
     * 
     * target.constructor.prototype[propertyKey] = component;
     */
    public class Mapper : Object {

        public static HashMap<string, Object> declaredFields = new HashMap<string, Object>(); 

    }
}


/**
 * Add component type names to 
 * 
 * Mapper.declaredFields[System][Component]
 * 
 * 
 */