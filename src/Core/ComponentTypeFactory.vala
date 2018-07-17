using System.Collections.Generic;
using Artemis.Utils;

namespace Artemis 
{
  
    public class ComponentTypeFactory : Object 
    {
        /**
         * Contains all generated component types, newly generated component types
         * will be stored here.
         */
        private Dictionary<string,ComponentType> componentTypes;
    
        /** Amount of generated component types. */
        private int componentTypeCount = 0;
    
        /** Index of this component type in componentTypes. */
        public Bag<ComponentType> Types;
    
        public ComponentTypeFactory() 
        {
            componentTypes = new Dictionary<string,ComponentType>();
            Types = new Bag<ComponentType>();
            Aspect.TypeFactory = this;
        }
    
        /**
         * Gets the component type for the given component class.
         * <p>
         * If no component type exists yet, a new one will be created and stored
         * for later retrieval.
         * </p>
         *
         * @param c
         *			the component's class to get the type for
        *
        * @return the component's {@link ComponentType}
        */
        public ComponentType GetTypeFor(Type c) 
        {
            //  if ('number' == typeof c) {
            //  return this.types[parseInt(c)];
            //  }
    
            var type = componentTypes[c.name()];
    
            if (type == null) {
                var index = componentTypeCount++;
                type = new ComponentType(c, index);
                componentTypes[c.name()] = type;
                Types.set(index, type);
            }
    
            return type;
        }
    
        /**
         * Get the index of the component type of given component class.
         *
         * @param c
         *			the component class to get the type index for
        *
        * @return the component type's index
        */
        public int GetIndexFor(Type c) 
        {
            return GetTypeFor(c).GetIndex();
        }
    
        public Taxonomy GetTaxonomy(int index) 
        {
            return Types[index].GetTaxonomy();
        }
    
    }
}
