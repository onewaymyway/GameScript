package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class IVMode extends Object
    {
        protected var lastIV:ByteArray;
        protected var iv:ByteArray;
        protected var blockSize:uint;
        protected var padding:IPad;
        protected var prng:Random;
        protected var key:ISymmetricKey;

        public function IVMode(param1:ISymmetricKey, param2:IPad = null)
        {
            this.key = param1;
            blockSize = param1.getBlockSize();
            if (param2 == null)
            {
                param2 = new PKCS5(blockSize);
            }
            else
            {
                param2.setBlockSize(blockSize);
            }
            this.padding = param2;
            prng = new Random();
            iv = null;
            lastIV = new ByteArray();
            return;
        }// end function

        public function set IV(param1:ByteArray) : void
        {
            iv = param1;
            lastIV.length = 0;
            lastIV.writeBytes(iv);
            return;
        }// end function

        protected function getIV4d() : ByteArray
        {
            var _loc_1:ByteArray = null;
            _loc_1 = new ByteArray();
            if (iv)
            {
                _loc_1.writeBytes(iv);
            }
            else
            {
                throw new Error("an IV must be set before calling decrypt()");
            }
            return _loc_1;
        }// end function

        protected function getIV4e() : ByteArray
        {
            var _loc_1:ByteArray = null;
            _loc_1 = new ByteArray();
            if (iv)
            {
                _loc_1.writeBytes(iv);
            }
            else
            {
                prng.nextBytes(_loc_1, blockSize);
            }
            lastIV.length = 0;
            lastIV.writeBytes(_loc_1);
            return _loc_1;
        }// end function

        public function get IV() : ByteArray
        {
            return lastIV;
        }// end function

        public function dispose() : void
        {
            var _loc_1:uint = 0;
            if (iv != null)
            {
                _loc_1 = 0;
                while (_loc_1 < iv.length)
                {
                    
                    iv[_loc_1] = prng.nextByte();
                    _loc_1 = _loc_1 + 1;
                }
                iv.length = 0;
                iv = null;
            }
            if (lastIV != null)
            {
                _loc_1 = 0;
                while (_loc_1 < iv.length)
                {
                    
                    lastIV[_loc_1] = prng.nextByte();
                    _loc_1 = _loc_1 + 1;
                }
                lastIV.length = 0;
                lastIV = null;
            }
            key.dispose();
            key = null;
            padding = null;
            prng.dispose();
            prng = null;
            Memory.gc();
            return;
        }// end function

        public function getBlockSize() : uint
        {
            return key.getBlockSize();
        }// end function

    }
}
