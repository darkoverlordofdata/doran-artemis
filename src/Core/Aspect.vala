/**
 * An Aspects is used by systems as a matcher against entities, to check if a system is
 * interested in an entity. Aspects define what sort of component types an entity must
 * possess, or not possess.
 *
 * This creates an aspect where an entity must possess A and B and C:
 * Aspect.getAspectForAll(A.class, B.class, C.class)
 *
 * This creates an aspect where an entity must possess A and B and C, but must not possess U or V.
 * Aspect.getAspectForAll(A.class, B.class, C.class).exclude(U.class, V.class)
 *
 * This creates an aspect where an entity must possess A and B and C, but must not possess U or V, but must possess one of X or Y or Z.
 * Aspect.getAspectForAll(A.class, B.class, C.class).exclude(U.class, V.class).one(X.class, Y.class, Z.class)
 *
 * You can create and compose aspects in many ways:
 * Aspect.getEmpty().one(X.class, Y.class, Z.class).all(A.class, B.class, C.class).exclude(U.class, V.class)
 * is the same as:
 * Aspect.getAspectForAll(A.class, B.class, C.class).exclude(U.class, V.class).one(X.class, Y.class, Z.class)
 *
 * @author Arni Arent
 *
 */
using Artemis.Utils;

namespace Artemis 
{

    public class Aspect : Object 
    {
        public static ComponentTypeFactory TypeFactory;
        private BitSet allSet;
        private BitSet exclusionSet;
        private BitSet oneSet;
        private World world;
        
        /**
         * @constructor
         */
        public Aspect() 
        {
            allSet = new BitSet();
            exclusionSet = new BitSet();
            oneSet = new BitSet();
        }

        /**
         *
         * @param {artemis.World} world
         */
        public void SetWorld(World world) 
        {
            this.world = world;
        }
        
        public BitSet GetAllSet() 
        {
            return allSet;
        }

        public BitSet GetExclusionSet() 
        {
            return exclusionSet;
        }

        public BitSet GetOneSet() 
        {
            return oneSet;
        }

        //  private int getIndexFor(Component c) {
        //      return Aspect.TypeFactory.getIndexFor(c.get_type());
        //  }
        
        /**
         * Returns an aspect where an entity must possess all of the specified component types.
         * @param {Type} type a required component type
         * @param {Array<Type>} types a required component type
         * @return {artemis.Aspect} an aspect that can be matched against entities
         */
        public Aspect All(Type[] types) 
        {
            foreach (var t in types) 
            {
                allSet[Aspect.TypeFactory.GetIndexFor(t)] = true;
            }
    
            return this;
        }
        
        /**
         * Excludes all of the specified component types from the aspect. A system will not be
         * interested in an entity that possesses one of the specified exclusion component types.
         *
         * @param {Type} type component type to exclude
         * @param {Array<Type>} types component type to exclude
         * @return {artemis.Aspect} an aspect that can be matched against entities
         */
        public Aspect Exclude(Type[] types) 
        {
            foreach (var t in types) 
            {
                exclusionSet[Aspect.TypeFactory.GetIndexFor(t)] = true;
            }
            return this;
        }
        
        
        /**
         * Returns an aspect where an entity must possess one of the specified component types.
         * @param {Type} type one of the types the entity must possess
         * @param {Array<Type>} types one of the types the entity must possess
         * @return {artemis.Aspect} an aspect that can be matched against entities
         */
        public Aspect One(Type[] types) 
        {
            foreach (var t in types) 
            {
                oneSet[Aspect.TypeFactory.GetIndexFor(t)] = true;
            }
            return this;
        }
    
        /**
         * Creates an aspect where an entity must possess all of the specified component types.
         *
         * @param {Type} type the type the entity must possess
         * @param {Array<Type>} types the type the entity must possess
         * @return {artemis.Aspect} an aspect that can be matched against entities
         *
         * @deprecated
         * @see getAspectForAll
         */
        public static Aspect GetAspectFor(Type[] types) 
        {
            return Aspect.GetAspectForAll(types);
        }

        /**
         * Creates an aspect where an entity must possess all of the specified component types.
         *
         * @param {Type} type a required component type
         * @param {Array<Type>} types a required component type
         * @return {artemis.Aspect} an aspect that can be matched against entities
         */
        public static Aspect GetAspectForAll(Type[] types) 
        {
            var aspect = new Aspect();
            aspect.All(types);
            return aspect;
        }
        
        /**
         * Creates an aspect where an entity must possess one of the specified component types.
         *
         * @param {Type} type one of the types the entity must possess
         * @param {Array<Type>} types one of the types the entity must possess
         * @return {artemis.Aspect} an aspect that can be matched against entities
         */
        public static Aspect GetAspectForOne(Type[] types) 
        {
            var aspect = new Aspect();
            aspect.One(types);
            return aspect;
        }
    
        /**
         * Creates and returns an empty aspect. This can be used if you want a system that processes no entities, but
         * still gets invoked. Typical usages is when you need to create special purpose systems for debug rendering,
         * like rendering FPS, how many entities are active in the world, etc.
         *
         * You can also use the all, one and exclude methods on this aspect, so if you wanted to create a system that
         * processes only entities possessing just one of the components A or B or C, then you can do:
         * Aspect.getEmpty().one(A,B,C);
         *
         * @return {artemis.Aspect} an empty Aspect that will reject all entities.
         */
        public static Aspect GetEmpty() 
        {
            return new Aspect();
        }
    }
}
