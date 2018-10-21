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

    /*
     * BitSets are packed into arrays of "words."  Currently a word
     * consists of 32 bits, requiring 5 address bits.
     */
    const int ADDRESS_BITS_PER_WORD = 5;
    public const int BITS_PER_WORD = 1 << ADDRESS_BITS_PER_WORD; // 32
    const int64 WORD_MASK = 0xffffffff;
  
    /**
     * @see http://stackoverflow.com/questions/6506356/java-implementation-of-long-numberoftrailingzeros
     */
    private uint numberOfTrailingZeros(uint i) 
    {
        if (i == 0) return 32;
        uint x = i;
        uint y;
        uint n = 31;
        y = x << 16; if (y != 0) { n -= 16; x = y; }
        y = x <<  8; if (y != 0) { n -=  8; x = y; }
        y = x <<  4; if (y != 0) { n -=  4; x = y; }
        y = x <<  2; if (y != 0) { n -=  2; x = y; }
        return (n - ((x << 1) >> 31));
    }

    public class BitSet : Object 
    {

        private uint[] words;

        public BitSet(int nbits=0) 
        {
            if (nbits < 0) 
            {
                throw new Exception.RangeError("Negative Array Size: [%d]", nbits);
            } 
            else if (nbits == 0) 
            {
                words = new uint[0];
            } 
            else 
            {
                words = new uint[(((nbits-1) >> ADDRESS_BITS_PER_WORD)+1)];
                for (var i=0, l = words.length; i<l; i++) 
                {
                    words[i] = 0;
                }
            }
        }

        public int NextSetBit(int fromIndex) 
        {
            var u = fromIndex >> ADDRESS_BITS_PER_WORD;
            var wordsInUse = words.length;

            var word = words[u] & (WORD_MASK << fromIndex);
            while (true) 
            {
                if (word != 0)
                    return (int)((u * BITS_PER_WORD) + numberOfTrailingZeros(word));
                if (++u == wordsInUse)
                    return -1;
                word = words[u];
            }
        }

        public bool Intersects(BitSet set) 
        {
            var wordsInUse = words.length;

            for (var i = int.min(wordsInUse, set.words.length) - 1; i >= 0; i--)
                if ((words[i] & set.words[i]) != 0)
                    return true;
            return false;

        }

        public bool IsEmpty() 
        {
            return words.length == 0;
        }

        public void set(int bitIndex, bool value) 
        {
            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            var wordsInUse = words.length;
            var wordsRequired = wordIndex+1;

            if (wordIndex >= words.length) 
            {
                words.resize(wordIndex+1);
            }
            if (wordsInUse < wordsRequired) 
            {
                words.resize(int.max(2 * wordsInUse, wordsRequired));
                // words.length = int.max(2 * wordsInUse, wordsRequired);
                for (var i=wordsInUse, l=words.length; i<l; i++) 
                {
                    words[i] = 0;
                }
            }

            if (value) 
            {
                words[wordIndex] |= (1 << bitIndex);
            } 
            else 
            {
                words[wordIndex] &= ~(1 << bitIndex);
            }
        }


        public bool get(int bitIndex) 
        {
            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            var wordsInUse = words.length;

            return (wordIndex < wordsInUse) && ((words[wordIndex] & (1 << bitIndex)) != 0);
        }


        public void Clear(int bitIndex=-1)  
        {
            if (bitIndex == -1) 
            {
                var wordsInUse = words.length;
                while (wordsInUse>0) 
                {
                    words[--wordsInUse] = 0;
                }
                return;
            }

            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            if (words.length <= wordIndex)
                words.resize(wordIndex+1);
            words[wordIndex] &= ~(1 << bitIndex);
        }

        public string to_string()
        {
            string[] s = new string[words.length];
            for (var i=0; i<words.length; i++)
            {
                s[i] = "0x%08x".printf(words[i]);
            }
            return string.joinv("|", s);
        }

    }
}