package com.smartfoxserver.v2.protocol
{
    import com.smartfoxserver.v2.bitswarm.*;

    public interface IProtocolCodec
    {

        public function IProtocolCodec();

        function onPacketRead(param1) : void;

        function onPacketWrite(param1:IMessage) : void;

        function get ioHandler() : IoHandler;

        function set ioHandler(param1:IoHandler) : void;

    }
}
