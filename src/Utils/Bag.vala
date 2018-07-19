/* ******************************************************************************
 * Copyright 2018 darkoverlordofdata.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/
namespace Artemis.Utils 
{
    /**
     * Collection type a bit like ArrayList but does not preserve the order of its
     * entities, speedwise it is very good, especially suited for games.
     *
     * @param <E>
     *		object type this bag holds
     *
     * @author Arni Arent
     */
    public class Bag<E> : Object, ImmutableBag<E> 
    {
        /** The backing array. */
        E[] data;
        /** The amount of elements contained in bag. */
        protected int length = 0;
        /** The iterator, it is only created once and reused when required. */
        //  private BagIterator it;
  
        /**
         * Constructs an empty Bag with the specified initial capacity.
         * Constructs an empty Bag with an initial capacity of 64.
         *
         * @constructor
         * @param capacity the initial capacity of Bag
         */
        public Bag(int capacity = 64) 
        {
            data = new E[capacity];
        }
    
        /**
         * Removes the element at the specified position in this Bag. does this by
         * overwriting it was last element then removing last element
         *
         * @param index
         *            the index of element to be removed
         * @return {Object} element that was removed from the Bag
         */
        public E RemoveAt(int index) 
        {    
            var e = data[index]; // make copy of element to remove so it can be returned
            data[index] = data[--length]; // overwrite item to remove with last element
            data[length] = null; // null last element, so gc can do its work
            return e;
        }
    
    
        /**
         * Removes the first occurrence of the specified element from this Bag, if
         * it is present. If the Bag does not contain the element, it is unchanged.
         * does this by overwriting it was last element then removing last element
         *
         * @param e
         *            element to be removed from this list, if present
         * @return {boolean} true if this list contained the specified element
         */
        public bool Remove(E e) 
        {
            E e2;
            var size = length;
    
            for (var i = 0; i < size; i++) 
            {
                e2 = data[i];
        
                if (e == e2) 
                {
                    // data.move(i+1, i, 1);
                    data[i] = data[--size]; // overwrite item to remove with last element
                    data[size] = null; // null last element, so gc can do its work
                    return true;
                }
            }
    
            return false;
        }
    
        /**
         * Sorts the bag using the {@code comparator}.
         *
         * @param comparator
         */
        //  public void sort(Comparator<E> comparator) {
        //      Sort.instance().sort(this, comparator);
        //  }
        
        /**
         * Remove and return the last object in the bag.
         *
         * @return {Object} the last object in the bag, null if empty.
         */
        public E RemoveLast() 
        {
            if (length > 0) 
            {
                var e = data[--length];
                data[length] = null;
                return e;
            }
            return null;
        }
    
        /**
         * Check if bag contains this element.
         *
         * @param e
         * @return {boolean}
         */
        public bool Contains(E e) 
        {

            for (var i=0; length > i; i++) 
            {
                if (e == data[i])
                {
                    return true;
                }
            }
            return false;
        }
    
        /**
         * Removes from this Bag all of its elements that are contained in the
         * specified Bag.
         *
         * @param bag
         *            Bag containing elements to be removed from this Bag
         * @return {boolean} true if this Bag changed as a result of the call
         */
        public bool RemoveAll(ImmutableBag<E> bag) 
        {
            var modified = false;
            int i;
            int j;
            int l;
            E e1;
            E e2;
    
            for (i = 0, l=bag.Size(); i < l; i++) 
            {
                e1 = bag[i];
        
                for (j = 0; j < length; j++) 
                {
                    e2 = data[j];
        
                    if (e1 == e2) 
                    {
                        RemoveAt(j);
                        j--;
                        modified = true;
                        break;
                    }
                }
            }
    
            return modified;
        }
    
        /**
         * Returns the element at the specified position in Bag.
         *
         * @param index
         *            index of the element to return
         * @return {Object} the element at the specified position in bag
         */
        public E? get(int index) 
        {
            if (index >= data.length) 
            {
                throw new Exception.ArrayIndexOutOfBounds(" at %d", index);
            }
            return data[index];
        }
    
        /**
         * Returns the element at the specified position in Bag. This method
         * ensures that the bag grows if the requested index is outside the bounds
         * of the current backing array.
         *
         * @param index
         *      index of the element to return
         *
         * @return {Object} the element at the specified position in bag
         *
         */
        public E SafeGet(int index) 
        {
            if (index >= data.length) 
            {
                Grow((int)Math.fmaxf((2 * data.length), (3 * index) / 2));
            }
            return data[index];
        }
    
        /**
         * Returns the number of elements in this bag.
         *
         * @return {number} the number of elements in this bag
         */
        public int Size() 
        {
            return length;
        }
    
        /**
         * Returns the number of elements the bag can hold without growing.
         *
         * @return {number} the number of elements the bag can hold without growing.
         */
        public int GetCapacity() 
        {
            return data.length;
        }
    
        /**
         * Checks if the internal storage supports this index.
         *
         * @param index
         * @return {boolean}
         */
        public bool IsIndexWithinBounds(int index) 
        {
            return index < GetCapacity();
        }
    
        /**
         * Returns true if this list contains no elements.
         *
         * @return {boolean} true if this list contains no elements
         */
        public bool IsEmpty() 
        {
            return length == 0;
        }
    
        /**
         * Adds the specified element to the end of this bag. if needed also
         * increases the capacity of the bag.
         *
         * @param e
         *            element to be added to this list
         */
        public void Add(E e) 
        {
            // is length greater than capacity increase capacity
            if (length == data.length) 
                Grow(data.length * 2);
    
            data[length++] = e;
        }
    
        /**
         *<em>Unsafe method.</em> Sets element at specified index in the bag,
         * without updating size. Internally used by artemis when operation is
         * known to be safe.
         *
         * @param index
         *			position of element
         * @param e
         *			the element
         */
        public void UnsafeSet(int index, E e) 
        {
            data[index] = e;
        }

        /**
         * Set element at specified index in the bag.
         *
         * @param index position of element
         * @param e the element
         */
        public void set(int index, E e) 
        {
            if (index >= data.length) 
            {
                Grow(index * 2);
            }
            length = index + 1;
            data[index] = e;
        }
    
        public void Grow(int newCapacity) 
        {
            data.resize(newCapacity);
        }
    
        /**
         * Check if an item, if added at the given item will fit into the bag.
         * <p>
         * If not, the bag capacity will be increased to hold an item at the index.
         * </p>
         *
         * <p>yeah, sorry, it's weird, but we don't want to change existing change behavior</p>
         *
         * @param index
         *			index to check
         */
        public void EnsureCapacity(int index) 
        {
            if (index >= data.length) 
            {
                Grow(index * 2);
            }
        }
    
        /**
         * Removes all of the elements from this bag. The bag will be empty after
         * this call returns.
         */
        public void Clear() 
        {
            // null all element the slow way so that gc can clean up
            for (var i=0; i < length; i++) 
            {
                data[i] = null;
            }
    
            length = 0;
        }
    
        /**
         * Add all items into this bag.
         * @param items
         */
        public void AddAll(ImmutableBag<E> items) 
        {
            for (var i = 0; items.Size() > i; i++) 
            {
                Add(items[i]);
            }
        }
    
        /**
         * Returns this bag's underlying array.
         * 
         * <p>
         * <b>Use of this method requires typed instantiation, e.g. Bag<E>(Class<E>)</b>
         * </p>
         *
         * @return the underlying array
         *
         * @see Bag#Size()
         */
        public E[] GetData() 
        {
            return data;
        }
        
    }
}
  