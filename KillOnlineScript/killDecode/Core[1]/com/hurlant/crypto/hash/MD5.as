package com.hurlant.crypto.hash
{
    import flash.utils.*;

    public class MD5 extends Object implements IHash
    {
        public static const HASH_SIZE:int = 16;

        public function MD5()
        {
            return;
        }// end function

        private function ff(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
        {
            return cmn(param2 & param3 | ~param2 & param4, param1, param2, param5, param6, param7);
        }// end function

        private function hh(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
        {
            return cmn(param2 ^ param3 ^ param4, param1, param2, param5, param6, param7);
        }// end function

        private function cmn(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : uint
        {
            return rol(param2 + param1 + param4 + param6, param5) + param3;
        }// end function

        public function getHashSize() : uint
        {
            return HASH_SIZE;
        }// end function

        private function ii(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
        {
            return cmn(param3 ^ (param2 | ~param4), param1, param2, param5, param6, param7);
        }// end function

        private function rol(param1:uint, param2:uint) : uint
        {
            return param1 << param2 | param1 >>> 32 - param2;
        }// end function

        public function toString() : String
        {
            return "md5";
        }// end function

        public function getInputSize() : uint
        {
            return 64;
        }// end function

        private function gg(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint) : uint
        {
            return cmn(param2 & param4 | param3 & ~param4, param1, param2, param5, param6, param7);
        }// end function

        public function hash(param1:ByteArray) : ByteArray
        {
            var _loc_2:uint = 0;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:uint = 0;
            var _loc_6:Array = null;
            var _loc_7:ByteArray = null;
            _loc_2 = param1.length * 8;
            _loc_3 = param1.endian;
            while (param1.length % 4 != 0)
            {
                
                param1[param1.length] = 0;
            }
            param1.position = 0;
            _loc_4 = [];
            param1.endian = Endian.LITTLE_ENDIAN;
            _loc_5 = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_4.push(param1.readUnsignedInt());
                _loc_5 = _loc_5 + 4;
            }
            _loc_6 = core_md5(_loc_4, _loc_2);
            _loc_7 = new ByteArray();
            _loc_7.endian = Endian.LITTLE_ENDIAN;
            _loc_5 = 0;
            while (_loc_5 < 4)
            {
                
                _loc_7.writeUnsignedInt(_loc_6[_loc_5]);
                _loc_5 = _loc_5 + 1;
            }
            param1.length = _loc_2 / 8;
            param1.endian = _loc_3;
            return _loc_7;
        }// end function

        private function core_md5(param1:Array, param2:uint) : Array
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            var _loc_11:uint = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << param2 % 32;
            param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
            _loc_3 = 1732584193;
            _loc_4 = 4023233417;
            _loc_5 = 2562383102;
            _loc_6 = 271733878;
            _loc_7 = 0;
            while (_loc_7 < param1.length)
            {
                
                param1[_loc_7] = param1[_loc_7] || 0;
                param1[(_loc_7 + 1)] = param1[(_loc_7 + 1)] || 0;
                param1[_loc_7 + 2] = param1[_loc_7 + 2] || 0;
                param1[_loc_7 + 3] = param1[_loc_7 + 3] || 0;
                param1[_loc_7 + 4] = param1[_loc_7 + 4] || 0;
                param1[_loc_7 + 5] = param1[_loc_7 + 5] || 0;
                param1[_loc_7 + 6] = param1[_loc_7 + 6] || 0;
                param1[_loc_7 + 7] = param1[_loc_7 + 7] || 0;
                param1[_loc_7 + 8] = param1[_loc_7 + 8] || 0;
                param1[_loc_7 + 9] = param1[_loc_7 + 9] || 0;
                param1[_loc_7 + 10] = param1[_loc_7 + 10] || 0;
                param1[_loc_7 + 11] = param1[_loc_7 + 11] || 0;
                param1[_loc_7 + 12] = param1[_loc_7 + 12] || 0;
                param1[_loc_7 + 13] = param1[_loc_7 + 13] || 0;
                param1[_loc_7 + 14] = param1[_loc_7 + 14] || 0;
                param1[_loc_7 + 15] = param1[_loc_7 + 15] || 0;
                _loc_8 = _loc_3;
                _loc_9 = _loc_4;
                _loc_10 = _loc_5;
                _loc_11 = _loc_6;
                _loc_3 = ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 0], 7, 3614090360);
                _loc_6 = ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[(_loc_7 + 1)], 12, 3905402710);
                _loc_5 = ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 2], 17, 606105819);
                _loc_4 = ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 3], 22, 3250441966);
                _loc_3 = ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 4], 7, 4118548399);
                _loc_6 = ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 5], 12, 1200080426);
                _loc_5 = ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 6], 17, 2821735955);
                _loc_4 = ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 7], 22, 4249261313);
                _loc_3 = ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 8], 7, 1770035416);
                _loc_6 = ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 9], 12, 2336552879);
                _loc_5 = ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 10], 17, 4294925233);
                _loc_4 = ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 11], 22, 2304563134);
                _loc_3 = ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 12], 7, 1804603682);
                _loc_6 = ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 13], 12, 4254626195);
                _loc_5 = ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 14], 17, 2792965006);
                _loc_4 = ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 15], 22, 1236535329);
                _loc_3 = gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[(_loc_7 + 1)], 5, 4129170786);
                _loc_6 = gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 6], 9, 3225465664);
                _loc_5 = gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 11], 14, 643717713);
                _loc_4 = gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 0], 20, 3921069994);
                _loc_3 = gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 5], 5, 3593408605);
                _loc_6 = gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 10], 9, 38016083);
                _loc_5 = gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 15], 14, 3634488961);
                _loc_4 = gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 4], 20, 3889429448);
                _loc_3 = gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 9], 5, 568446438);
                _loc_6 = gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 14], 9, 3275163606);
                _loc_5 = gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 3], 14, 4107603335);
                _loc_4 = gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 8], 20, 1163531501);
                _loc_3 = gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 13], 5, 2850285829);
                _loc_6 = gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 2], 9, 4243563512);
                _loc_5 = gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 7], 14, 1735328473);
                _loc_4 = gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 12], 20, 2368359562);
                _loc_3 = hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 5], 4, 4294588738);
                _loc_6 = hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 8], 11, 2272392833);
                _loc_5 = hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 11], 16, 1839030562);
                _loc_4 = hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 14], 23, 4259657740);
                _loc_3 = hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[(_loc_7 + 1)], 4, 2763975236);
                _loc_6 = hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 4], 11, 1272893353);
                _loc_5 = hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 7], 16, 4139469664);
                _loc_4 = hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 10], 23, 3200236656);
                _loc_3 = hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 13], 4, 681279174);
                _loc_6 = hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 0], 11, 3936430074);
                _loc_5 = hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 3], 16, 3572445317);
                _loc_4 = hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 6], 23, 76029189);
                _loc_3 = hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 9], 4, 3654602809);
                _loc_6 = hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 12], 11, 3873151461);
                _loc_5 = hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 15], 16, 530742520);
                _loc_4 = hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 2], 23, 3299628645);
                _loc_3 = ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 0], 6, 4096336452);
                _loc_6 = ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 7], 10, 1126891415);
                _loc_5 = ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 14], 15, 2878612391);
                _loc_4 = ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 5], 21, 4237533241);
                _loc_3 = ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 12], 6, 1700485571);
                _loc_6 = ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 3], 10, 2399980690);
                _loc_5 = ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 10], 15, 4293915773);
                _loc_4 = ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[(_loc_7 + 1)], 21, 2240044497);
                _loc_3 = ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 8], 6, 1873313359);
                _loc_6 = ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 15], 10, 4264355552);
                _loc_5 = ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 6], 15, 2734768916);
                _loc_4 = ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 13], 21, 1309151649);
                _loc_3 = ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 4], 6, 4149444226);
                _loc_6 = ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 11], 10, 3174756917);
                _loc_5 = ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 2], 15, 718787259);
                _loc_4 = ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 9], 21, 3951481745);
                _loc_3 = _loc_3 + _loc_8;
                _loc_4 = _loc_4 + _loc_9;
                _loc_5 = _loc_5 + _loc_10;
                _loc_6 = _loc_6 + _loc_11;
                _loc_7 = _loc_7 + 16;
            }
            return [_loc_3, _loc_4, _loc_5, _loc_6];
        }// end function

    }
}
