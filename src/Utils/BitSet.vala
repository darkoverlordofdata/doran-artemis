namespace Artemis.Utils {

    /*
       * BitSets are packed into arrays of "words."  Currently a word
       * consists of 32 bits, requiring 5 address bits.
       */
    const int ADDRESS_BITS_PER_WORD = 5;
    const int BITS_PER_WORD = 1 << ADDRESS_BITS_PER_WORD; // 32
    const int64 WORD_MASK = 0xffffffff;
  
    /**
     * @see http://stackoverflow.com/questions/6506356/java-implementation-of-long-numberoftrailingzeros
     */
    uint numberOfTrailingZeros(uint i) {
        if (i == 0) return 64;
        uint x = i;
        uint y;
        uint n = 63;
        y = x << 32; if (y != 0) { n -= 32; x = y; }
        y = x << 16; if (y != 0) { n -= 16; x = y; }
        y = x <<  8; if (y != 0) { n -=  8; x = y; }
        y = x <<  4; if (y != 0) { n -=  4; x = y; }
        y = x <<  2; if (y != 0) { n -=  2; x = y; }
        return (n - ((x << 1) >> 63));
    }
  
    public class BitSet : Object {

        private uint[] words;

        public BitSet(int nbits=0) {
            if (nbits < 0) {
                throw new Exception.RangeError("Negative Array Size: [%d]", nbits);
            } else if (nbits == 0) {
                this.words = new uint[0];
            } else {
                var words = this.words = new uint[(((nbits-1) >> ADDRESS_BITS_PER_WORD)+1)];
                for (var i=0, l = words.length; i<l; i++) {
                    words[i] = 0;
                }
            }
        }

        public int nextSetBit(int fromIndex) {

            var u = fromIndex >> ADDRESS_BITS_PER_WORD;
            var words = this.words;
            var wordsInUse = words.length;

            var word = words[u] & (WORD_MASK << fromIndex);
            while (true) {
                if (word != 0)
                    return (int)((u * BITS_PER_WORD) + numberOfTrailingZeros(word));
                if (++u == wordsInUse)
                    return -1;
                word = words[u];
            }
        }

        public bool intersects(BitSet set) {
            var words = this.words;
            var wordsInUse = words.length;

            for (var i = int.min(wordsInUse, set.words.length) - 1; i >= 0; i--)
                if ((words[i] & set.words[i]) != 0)
                    return true;
            return false;

        }

        public bool isEmpty() {
            return this.words.length == 0;
        }

        public uint set(int bitIndex, bool value=true) {
            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            var words = this.words;
            var wordsInUse = words.length;
            var wordsRequired = wordIndex+1;

            if (wordsInUse < wordsRequired) {
                words.length = int.max(2 * wordsInUse, wordsRequired);
                for (var i=wordsInUse, l=words.length; i<l; i++) {
                    words[i] = 0;
                }
            }

            if (value) {
                return words[wordIndex] |= (1 << bitIndex);
            } else {
                return words[wordIndex] &= ~(1 << bitIndex);
            }
        }


        public bool get(int bitIndex) {

            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            var words = this.words;
            var wordsInUse = words.length;

            return (wordIndex < wordsInUse) && ((words[wordIndex] & (1 << bitIndex)) != 0);
        }


        public void clear(int bitIndex=-1)  {
            if (bitIndex == -1) {
                var words = this.words;
                var wordsInUse = words.length;
                while (wordsInUse>0) {
                    words[--wordsInUse] = 0;
                }
                return;
            }

            var wordIndex = bitIndex >> ADDRESS_BITS_PER_WORD;
            this.words[wordIndex] &= ~(1 << bitIndex);
        }

    }
}