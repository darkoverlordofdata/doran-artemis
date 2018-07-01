
/**
 * A non-modifiable bag.
 * <p>
 * A bag is a set that can also hold duplicates. Also known as multiset.
 * </p>
 *
 * @author Arni Arent
 *
 * @param <E>
 *
 * @see Bag
 */
namespace Artemis.Utils {

    public interface ImmutableBag<E> : Object {
        //  public interface ImmutableBag<E> : Iterable<E> {


        /**
         * Returns the element at the specified position in Bag.
         *
         * @param index
         *			index of the element to return
        *
        * @return the element at the specified position in bag
        */
        public abstract E? get(int index);

        /**
         * Returns the number of elements in this bag.
         *
         * @return the number of elements in this bag
         */
        public abstract int size();

        /**
         * Returns true if this bag contains no elements.
         *
         * @return true if this bag contains no elements
         */
        public abstract bool isEmpty();

        /**
         * Check if bag contains this element.
         *
         * @param e
         *
         * @return true if the bag contains this element
         */
        public abstract bool contains(E e);

    }
}