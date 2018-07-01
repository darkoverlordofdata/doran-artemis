using Artemis.Utils;
using Artemis.Annotations;

namespace Artemis {
  
    public enum Taxonomy {
      BASIC, POOLED 
    }

    public class ComponentType : Object {
        private static int INDEX = 0;
        public static ComponentManager componentManager;
    
        private int index = 0;
        private Type type;
        private Taxonomy taxonomy;

        public ComponentType(Type type, int index) {
            this.index = ComponentType.INDEX++;
            this.type = type;
            if (Pooled.pooledComponents[type.name()] == (Object)type) {
                this.taxonomy = Taxonomy.POOLED;
            } else {
                this.taxonomy = Taxonomy.BASIC;
            }
        }

        public string getName() {
            return type.name();
        }

        public int getIndex() {
            return this.index;
        }

        public Taxonomy getTaxonomy() {
        return this.taxonomy;
        }
        
        public string toString() {
            return "ComponentType (%d)".printf(index);
        }
    
    }
  }