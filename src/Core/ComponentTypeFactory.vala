using Gee;
using Artemis.Utils;

namespace Artemis {
  
    //  interface IdentityGee.Gee.HashMap {
    //    [key: string]: ComponentType;
    //  }
  
    public class ComponentTypeFactory : Object {
        /**
         * Contains all generated component types, newly generated component types
         * will be stored here.
         */
        private HashMap<string,ComponentType> componentTypes;
    
        /** Amount of generated component types. */
        private int componentTypeCount = 0;
    
        /** Index of this component type in componentTypes. */
        public Bag<ComponentType> types;
    
        public ComponentTypeFactory() {
            componentTypes = new HashMap<string,ComponentType>();
            types = new Bag<ComponentType>();
            Aspect.typeFactory = this;
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
        public ComponentType getTypeFor(Type c) {
            //  if ('number' == typeof c) {
            //  return this.types[parseInt(c)];
            //  }
    
            var type = componentTypes[c.name()];
    
            if (type == null) {
                var index = componentTypeCount++;
                type = new ComponentType(c, index);
                componentTypes[c.name()] = type;
                types.set(index, type);
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
        public int getIndexFor(Type c) {
            return getTypeFor(c).getIndex();
        }
    
        public Taxonomy getTaxonomy(int index) {
            return types[index].getTaxonomy();
        }
    
    }
}
  