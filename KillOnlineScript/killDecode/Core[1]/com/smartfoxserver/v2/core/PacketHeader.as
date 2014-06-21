package com.smartfoxserver.v2.core
{

    public class PacketHeader extends Object
    {
        private var _expectedLen:int;
        private var _binary:Boolean;
        private var _compressed:Boolean;
        private var _encrypted:Boolean;
        private var _blueBoxed:Boolean;
        private var _bigSized:Boolean;

        public function PacketHeader(param1:Boolean, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
        {
            this._expectedLen = -1;
            this._binary = true;
            this._compressed = param2;
            this._encrypted = param1;
            this._blueBoxed = param3;
            this._bigSized = param4;
            return;
        }// end function

        public function get expectedLen() : int
        {
            return this._expectedLen;
        }// end function

        public function set expectedLen(param1:int) : void
        {
            this._expectedLen = param1;
            return;
        }// end function

        public function get binary() : Boolean
        {
            return this._binary;
        }// end function

        public function set binary(param1:Boolean) : void
        {
            this._binary = param1;
            return;
        }// end function

        public function get compressed() : Boolean
        {
            return this._compressed;
        }// end function

        public function set compressed(param1:Boolean) : void
        {
            this._compressed = param1;
            return;
        }// end function

        public function get encrypted() : Boolean
        {
            return this._encrypted;
        }// end function

        public function set encrypted(param1:Boolean) : void
        {
            this._encrypted = param1;
            return;
        }// end function

        public function get blueBoxed() : Boolean
        {
            return this._blueBoxed;
        }// end function

        public function set blueBoxed(param1:Boolean) : void
        {
            this._blueBoxed = param1;
            return;
        }// end function

        public function get bigSized() : Boolean
        {
            return this._bigSized;
        }// end function

        public function set bigSized(param1:Boolean) : void
        {
            this._bigSized = param1;
            return;
        }// end function

        public function encode() : int
        {
            var _loc_1:int = 0;
            if (this.binary)
            {
                _loc_1 = _loc_1 + 128;
            }
            if (this.encrypted)
            {
                _loc_1 = _loc_1 + 64;
            }
            if (this.compressed)
            {
                _loc_1 = _loc_1 + 32;
            }
            if (this.blueBoxed)
            {
                _loc_1 = _loc_1 + 16;
            }
            if (this.bigSized)
            {
                _loc_1 = _loc_1 + 8;
            }
            return _loc_1;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + "---------------------------------------------\n";
            _loc_1 = _loc_1 + ("Binary:  \t" + this.binary + "\n");
            _loc_1 = _loc_1 + ("Compressed:\t" + this.compressed + "\n");
            _loc_1 = _loc_1 + ("Encrypted:\t" + this.encrypted + "\n");
            _loc_1 = _loc_1 + ("BlueBoxed:\t" + this.blueBoxed + "\n");
            _loc_1 = _loc_1 + ("BigSized:\t" + this.bigSized + "\n");
            _loc_1 = _loc_1 + "---------------------------------------------\n";
            return _loc_1;
        }// end function

        public static function fromBinary(param1:int) : PacketHeader
        {
            return new PacketHeader((param1 & 64) > 0, (param1 & 32) > 0, (param1 & 16) > 0, (param1 & 8) > 0);
        }// end function

    }
}
