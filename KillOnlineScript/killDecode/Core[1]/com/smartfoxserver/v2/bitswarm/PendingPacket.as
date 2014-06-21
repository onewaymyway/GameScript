package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.core.*;
    import flash.utils.*;

    public class PendingPacket extends Object
    {
        private var _header:PacketHeader;
        private var _buffer:ByteArray;

        public function PendingPacket(param1:PacketHeader)
        {
            this._header = param1;
            this._buffer = new ByteArray();
            return;
        }// end function

        public function get header() : PacketHeader
        {
            return this._header;
        }// end function

        public function get buffer() : ByteArray
        {
            return this._buffer;
        }// end function

        public function set buffer(param1:ByteArray) : void
        {
            this._buffer = param1;
            return;
        }// end function

    }
}
