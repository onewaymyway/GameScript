package com.hurlant.crypto.prng
{
    import com.hurlant.util.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Random extends Object
    {
        private var psize:int;
        private var ready:Boolean = false;
        private var seeded:Boolean = false;
        private var state:IPRNG;
        private var pool:ByteArray;
        private var pptr:int;

        public function Random(param1:Class = null)
        {
            var _loc_2:uint = 0;
            ready = false;
            seeded = false;
            if (param1 == null)
            {
                param1 = ARC4;
            }
            state = new param1 as IPRNG;
            psize = state.getPoolSize();
            pool = new ByteArray();
            pptr = 0;
            while (pptr < psize)
            {
                
                _loc_2 = 65536 * Math.random();
                var _loc_3:* = pptr + 1;
                pool[_loc_3] = _loc_2 >>> 8;
                pool[++pptr] = _loc_2 & 255;
            }
            pptr = 0;
            seed();
            return;
        }// end function

        public function seed(param1:int = 0) : void
        {
            if (param1 == 0)
            {
                param1 = new Date().getTime();
            }
            var _loc_2:* = pptr + 1;
            pool[_loc_2] = pool[_loc_2] ^ param1 & 255;
            var _loc_3:* = pptr + 1;
            pool[_loc_3] = pool[_loc_3] ^ param1 >> 8 & 255;
            pool[++pptr] = pool[++pptr] ^ param1 >> 16 & 255;
            pool[++pptr] = pool[++pptr] ^ param1 >> 24 & 255;
            pptr = pptr % psize;
            seeded = true;
            return;
        }// end function

        public function toString() : String
        {
            return "random-" + state.toString();
        }// end function

        public function dispose() : void
        {
            var _loc_1:uint = 0;
            _loc_1 = 0;
            while (_loc_1 < pool.length)
            {
                
                pool[_loc_1] = Math.random() * 256;
                _loc_1 = _loc_1 + 1;
            }
            pool.length = 0;
            pool = null;
            state.dispose();
            state = null;
            psize = 0;
            pptr = 0;
            Memory.gc();
            return;
        }// end function

        public function autoSeed() : void
        {
            var _loc_1:ByteArray = null;
            var _loc_2:Array = null;
            var _loc_3:Font = null;
            _loc_1 = new ByteArray();
            _loc_1.writeUnsignedInt(System.totalMemory);
            _loc_1.writeUTF(Capabilities.serverString);
            _loc_1.writeUnsignedInt(getTimer());
            _loc_1.writeUnsignedInt(new Date().getTime());
            _loc_2 = Font.enumerateFonts(true);
            for each (_loc_3 in _loc_2)
            {
                
                _loc_1.writeUTF(_loc_3.fontName);
                _loc_1.writeUTF(_loc_3.fontStyle);
                _loc_1.writeUTF(_loc_3.fontType);
            }
            _loc_1.position = 0;
            while (_loc_1.bytesAvailable >= 4)
            {
                
                seed(_loc_1.readUnsignedInt());
            }
            return;
        }// end function

        public function nextByte() : int
        {
            if (!ready)
            {
                if (!seeded)
                {
                    autoSeed();
                }
                state.init(pool);
                pool.length = 0;
                pptr = 0;
                ready = true;
            }
            return state.next();
        }// end function

        public function nextBytes(param1:ByteArray, param2:int) : void
        {
            while (param2--)
            {
                
                param1.writeByte(nextByte());
            }
            return;
        }// end function

    }
}
