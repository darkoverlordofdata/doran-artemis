using System.Collections.Generic;
namespace Artemis.Annotations {

    /**
     * Mapper
     *
     * 
     * target.constructor.prototype[propertyKey] = component;
     */
    public class Mapper : Object {

        public static Dictionary<string, Object> declaredFields;
        
        public static void Init()
        {
            declaredFields = new Dictionary<string, Object>(); 
        }

    }
}


/**
 * Add component type names to 
 * 
 * Mapper.declaredFields[System][Component]
 * 
 * 
 */