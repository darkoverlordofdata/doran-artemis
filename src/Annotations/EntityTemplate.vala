using System.Collections.Generic;
namespace Artemis.Annotations {

    /**
     * EntityTemplate
     * 
     * 
     *   @EntityTemplate('player')
     *   export class PlayerTemplate implements IEntityTemplate {
     *
     *       public buildEntity(entity:Entity, world:World):Entity {
     *          ...
     *
     * 
     *  Adds class to 
     *       EntityTemplate['entityTemplates'][component] = target;
     */
    public class EntityTemplate : Object {

        public static Dictionary<string, Type> entityTemplates = new Dictionary<string, Type>(); 

    }
}

/**
 * Add the Type to 
 * 
    static construct {
        EntityTemplate.entityTemplates["player"] = typeof(PlayerTemplate);
    }
    
 */

