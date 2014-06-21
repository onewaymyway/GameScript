package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.protocol.*;
    import flash.utils.*;

    public interface IoHandler
    {

        public function IoHandler();

        function onDataRead(param1:ByteArray) : void;

        function onDataWrite(param1:IMessage) : void;

        function get codec() : IProtocolCodec;

    }
}
