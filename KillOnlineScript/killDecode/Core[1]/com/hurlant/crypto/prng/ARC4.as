package com.hurlant.crypto.prng
{
    import com.hurlant.util.*;
    import flash.utils.*;

    public class ARC4 extends Object implements IPRNG, IStreamCipher
    {
        private var S:ByteArray;
        private var i:int = 0;
        private var j:int = 0;
        private const psize:uint = 256;

        public function ARC4(param1:ByteArray = null)
        {
            i = 0;
            j = 0;
            S = new ByteArray();
            if (param1)
            {
                init(param1);
            }
            return;
        }// end function

        public function decrypt(param1:ByteArray) : void
        {
            encrypt(param1);
            return;
        }// end function

        public function init(param1:ByteArray) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            _loc_2 = 0;
            while (_loc_2 < 256)
            {
                
                S[_loc_2] = _loc_2;
                _loc_2++;
            }
            _loc_3 = 0;
            _loc_2 = 0;
            while (_loc_2 < 256)
            {
                
                _loc_3 = _loc_3 + S[_loc_2] + param1[_loc_2 % param1.length] & 255;
                _loc_4 = S[_loc_2];
                S[_loc_2] = S[_loc_3];
                S[_loc_3] = _loc_4;
                _loc_2++;
            }
            this.i = 0;
            this.j = 0;
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:uint = 0;
            _loc_1 = 0;
            if (S != null)
            {
                _loc_1 = 0;
                while (_loc_1 < S.length)
                {
                    
                    S[_loc_1] = Math.random() * 256;
                    _loc_1 = _loc_1 + 1;
                }
                S.length = 0;
                S = null;
            }
            this.i = 0;
            this.j = 0;
            Memory.gc();
            return;
        }// end function

        public function encrypt(param1:ByteArray) : void
        {
            var _loc_2:uint = 0;
            _loc_2 = 0;
            while (_loc_2 < param1.length)
            {
                
                var _loc_3:* = _loc_2 + 1;
                param1[_loc_3] = param1[_loc_3] ^ next();
            }
            return;
        }// end function

        public function next() : uint
        {
            var _loc_1:int = 0;
            i = (i + 1) & 255;
            j = j + S[i] & 255;
            _loc_1 = S[i];
            S[i] = S[j];
            S[j] = _loc_1;
            return S[_loc_1 + S[i] & 255];
        }// end function

        public function getBlockSize() : uint
        {
            return 1;
        }// end function

        public function getPoolSize() : uint
        {
            return psize;
        }// end function

        public function toString() : String
        {
            return "rc4";
        }// end function

    }
}
