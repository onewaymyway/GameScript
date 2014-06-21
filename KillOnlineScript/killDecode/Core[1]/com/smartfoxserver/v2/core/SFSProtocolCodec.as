package com.smartfoxserver.v2.core
{
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;
    import flash.utils.*;

    public class SFSProtocolCodec extends Object implements IProtocolCodec
    {
        private var _ioHandler:IoHandler;
        private var log:Logger;
        private var bitSwarm:BitSwarmClient;
        private static const CONTROLLER_ID:String = "c";
        private static const ACTION_ID:String = "a";
        private static const PARAM_ID:String = "p";
        private static const USER_ID:String = "u";
        private static const UDP_PACKET_ID:String = "i";

        public function SFSProtocolCodec(param1:IoHandler, param2:BitSwarmClient)
        {
            this._ioHandler = param1;
            this.log = Logger.getInstance();
            this.bitSwarm = param2;
            return;
        }// end function

        public function onPacketRead(param1) : void
        {
            var _loc_2:ISFSObject = null;
            if (param1 is ByteArray)
            {
                _loc_2 = SFSObject.newFromBinaryData(param1);
            }
            else
            {
                _loc_2 = param1 as ISFSObject;
            }
            this.dispatchRequest(_loc_2);
            return;
        }// end function

        public function onPacketWrite(param1:IMessage) : void
        {
            var _loc_2:ISFSObject = null;
            if (param1.isUDP)
            {
                _loc_2 = this.prepareUDPPacket(param1);
            }
            else
            {
                _loc_2 = this.prepareTCPPacket(param1);
            }
            param1.content = _loc_2;
            if (this.bitSwarm.sfs.debug)
            {
                this.log.info("Object going out: " + param1.content.getDump());
            }
            this.ioHandler.onDataWrite(param1);
            return;
        }// end function

        private function prepareTCPPacket(param1:IMessage) : ISFSObject
        {
            var _loc_2:* = new SFSObject();
            _loc_2.putByte(CONTROLLER_ID, param1.targetController);
            _loc_2.putShort(ACTION_ID, param1.id);
            _loc_2.putSFSObject(PARAM_ID, param1.content);
            return _loc_2;
        }// end function

        private function prepareUDPPacket(param1:IMessage) : ISFSObject
        {
            var _loc_2:* = new SFSObject();
            _loc_2.putByte(CONTROLLER_ID, param1.targetController);
            _loc_2.putInt(USER_ID, this.bitSwarm.sfs.mySelf != null ? (this.bitSwarm.sfs.mySelf.com.smartfoxserver.v2.entities:User::id) : (-1));
            _loc_2.putLong(UDP_PACKET_ID, this.bitSwarm.nextUdpPacketId());
            _loc_2.putSFSObject(PARAM_ID, param1.content);
            return _loc_2;
        }// end function

        public function get ioHandler() : IoHandler
        {
            return this._ioHandler;
        }// end function

        public function set ioHandler(param1:IoHandler) : void
        {
            if (this._ioHandler != null)
            {
                throw new SFSError("IOHandler is already defined for thir ProtocolHandler instance: " + this);
            }
            this._ioHandler = this.ioHandler;
            return;
        }// end function

        private function dispatchRequest(param1:ISFSObject) : void
        {
            var _loc_2:* = new Message();
            if (param1.isNull(CONTROLLER_ID))
            {
                throw new SFSCodecError("Request rejected: No Controller ID in request!");
            }
            if (param1.isNull(ACTION_ID))
            {
                throw new SFSCodecError("Request rejected: No Action ID in request!");
            }
            _loc_2.id = param1.getByte(ACTION_ID);
            _loc_2.content = param1.getSFSObject(PARAM_ID);
            _loc_2.isUDP = param1.containsKey(UDP_PACKET_ID);
            if (_loc_2.isUDP)
            {
                _loc_2.packetId = param1.getLong(UDP_PACKET_ID);
            }
            var _loc_3:* = param1.getByte(CONTROLLER_ID);
            var _loc_4:* = this.bitSwarm.getController(_loc_3);
            if (this.bitSwarm.getController(_loc_3) == null)
            {
                throw new SFSError("Cannot handle server response. Unknown controller, id: " + _loc_3);
            }
            _loc_4.handleMessage(_loc_2);
            return;
        }// end function

    }
}
