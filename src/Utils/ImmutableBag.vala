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
    public interface ImmutableBag<E> : Object 
    {
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
        public abstract int Size();

        /**
         * Returns true if this bag contains no elements.
         *
         * @return true if this bag contains no elements
         */
        public abstract bool IsEmpty();

        /**
         * Check if bag contains this element.
         *
         * @param e
         *
         * @return true if the bag contains this element
         */
        public abstract bool Contains(E e);

    }
}