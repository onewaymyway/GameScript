package com.smartfoxserver.v2.core
{
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;
    import com.smartfoxserver.v2.protocol.*;
    import com.smartfoxserver.v2.protocol.serialization.*;
    import flash.errors.*;
    import flash.utils.*;

    public class SFSIOHandler extends Object implements IoHandler
    {
        private var bitSwarm:BitSwarmClient;
        private var log:Logger;
        private var readState:int;
        private var pendingPacket:PendingPacket;
        private var protocolCodec:IProtocolCodec;
        private const EMPTY_BUFFER:ByteArray;
        public static const SHORT_BYTE_SIZE:int = 2;
        public static const INT_BYTE_SIZE:int = 4;

        public function SFSIOHandler(param1:BitSwarmClient)
        {
            this.EMPTY_BUFFER = new ByteArray();
            this.bitSwarm = param1;
            this.log = Logger.getInstance();
            this.readState = PacketReadState.WAIT_NEW_PACKET;
            this.protocolCodec = new SFSProtocolCodec(this, param1);
            return;
        }// end function

        public function get codec() : IProtocolCodec
        {
            return this.protocolCodec;
        }// end function

        public function set codec(param1:IProtocolCodec) : void
        {
            this.protocolCodec = param1;
            return;
        }// end function

        public function onDataRead(param1:ByteArray) : void
        {
            if (param1.length == 0)
            {
                throw new SFSError("Unexpected empty packet data: no readable bytes available!");
            }
            if (this.bitSwarm != null && this.bitSwarm.sfs.debug)
            {
                if (param1.length > 1024)
                {
                    this.log.info("Data Read: Size > 1024, dump omitted");
                }
                else
                {
                    this.log.info("Data Read: " + DefaultObjectDumpFormatter.hexDump(param1));
                }
            }
            param1.position = 0;
            while (param1.length > 0)
            {
                
                if (this.readState == PacketReadState.WAIT_NEW_PACKET)
                {
                    param1 = this.handleNewPacket(param1);
                }
                if (this.readState == PacketReadState.WAIT_DATA_SIZE)
                {
                    param1 = this.handleDataSize(param1);
                }
                if (this.readState == PacketReadState.WAIT_DATA_SIZE_FRAGMENT)
                {
                    param1 = this.handleDataSizeFragment(param1);
                }
                if (this.readState == PacketReadState.WAIT_DATA)
                {
                    param1 = this.handlePacketData(param1);
                }
            }
            return;
        }// end function

        private function handleNewPacket(param1:ByteArray) : ByteArray
        {
            this.log.debug("Handling New Packet");
            var _loc_2:* = param1.readByte();
            if (!(_loc_2 & 128) > 0)
            {
                throw new SFSError("Unexpected header byte: " + _loc_2 + "\n" + DefaultObjectDumpFormatter.hexDump(param1));
            }
            var _loc_3:* = PacketHeader.fromBinary(_loc_2);
            this.pendingPacket = new PendingPacket(_loc_3);
            this.readState = PacketReadState.WAIT_DATA_SIZE;
            return this.resizeByteArray(param1, 1, (length - 1));
        }// end function

        private function handleDataSize(param1:ByteArray) : ByteArray
        {
            this.log.debug("Handling Header Size. Size: " + param1.length + " (" + (this.pendingPacket.header.bigSized ? ("big") : ("small")) + ")");
            var _loc_2:int = -1;
            var _loc_3:int = 2;
            if (this.pendingPacket.header.bigSized)
            {
                if (param1.length >= 4)
                {
                    _loc_2 = param1.readUnsignedInt();
                }
                _loc_3 = 4;
            }
            else if (param1.length >= 2)
            {
                _loc_2 = param1.readUnsignedShort();
            }
            if (_loc_2 != -1)
            {
                this.pendingPacket.header.expectedLen = _loc_2;
                param1 = this.resizeByteArray(param1, _loc_3, param1.length - _loc_3);
                this.readState = PacketReadState.WAIT_DATA;
            }
            else
            {
                this.readState = PacketReadState.WAIT_DATA_SIZE_FRAGMENT;
                this.pendingPacket.buffer.writeBytes(param1);
                param1 = this.EMPTY_BUFFER;
            }
            return param1;
        }// end function

        private function handleDataSizeFragment(param1:ByteArray) : ByteArray
        {
            var _loc_3:int = 0;
            this.log.debug("Handling Size fragment. Data: " + param1.length);
            var _loc_2:* = this.pendingPacket.header.bigSized ? (4 - this.pendingPacket.buffer.position) : (2 - this.pendingPacket.buffer.position);
            if (param1.length >= _loc_2)
            {
                this.pendingPacket.buffer.writeBytes(param1, 0, _loc_2);
                this.pendingPacket.buffer.position = 0;
                _loc_3 = this.pendingPacket.header.bigSized ? (this.pendingPacket.buffer.readInt()) : (this.pendingPacket.buffer.readShort());
                this.log.debug("DataSize is ready:", _loc_3, "bytes");
                this.pendingPacket.header.expectedLen = _loc_3;
                this.pendingPacket.buffer = new ByteArray();
                this.readState = PacketReadState.WAIT_DATA;
                if (param1.length > _loc_2)
                {
                    param1 = this.resizeByteArray(param1, _loc_2, param1.length - _loc_2);
                }
                else
                {
                    param1 = this.EMPTY_BUFFER;
                }
            }
            else
            {
                this.pendingPacket.buffer.writeBytes(param1);
                param1 = this.EMPTY_BUFFER;
            }
            return param1;
        }// end function

        private function handlePacketData(param1:ByteArray) : ByteArray
        {
            var _loc_2:* = this.pendingPacket.header.expectedLen - this.pendingPacket.buffer.length;
            var _loc_3:* = param1.length > _loc_2;
            this.log.debug("Handling Data: " + param1.length + ", previous state: " + this.pendingPacket.buffer.length + "/" + this.pendingPacket.header.expectedLen);
            if (param1.length >= _loc_2)
            {
                this.pendingPacket.buffer.writeBytes(param1, 0, _loc_2);
                this.log.debug("<<< Packet Complete >>>");
                if (this.pendingPacket.header.compressed)
                {
                    this.pendingPacket.buffer.uncompress();
                }
                this.protocolCodec.onPacketRead(this.pendingPacket.buffer);
                this.readState = PacketReadState.WAIT_NEW_PACKET;
            }
            else
            {
                this.pendingPacket.buffer.writeBytes(param1);
            }
            if (_loc_3)
            {
                param1 = this.resizeByteArray(param1, _loc_2, param1.length - _loc_2);
            }
            else
            {
                param1 = this.EMPTY_BUFFER;
            }
            return param1;
        }// end function

        private function resizeByteArray(param1:ByteArray, param2:int, param3:int) : ByteArray
        {
            var _loc_4:* = new ByteArray();
            new ByteArray().writeBytes(param1, param2, param3);
            _loc_4.position = 0;
            return _loc_4;
        }// end function

        public function onDataWrite(param1:IMessage) : void
        {
            var _loc_2:* = new ByteArray();
            var _loc_3:* = param1.content.toBinary();
            var _loc_4:Boolean = false;
            if (_loc_3.length > this.bitSwarm.compressionThreshold)
            {
                _loc_3.compress();
                _loc_4 = true;
            }
            if (_loc_3.length > this.bitSwarm.maxMessageSize)
            {
                throw new SFSCodecError("Message size is too big: " + _loc_3.length + ", the server limit is: " + this.bitSwarm.maxMessageSize);
            }
            var _loc_5:* = SHORT_BYTE_SIZE;
            if (_loc_3.length > 65535)
            {
                _loc_5 = INT_BYTE_SIZE;
            }
            var _loc_6:* = new PacketHeader(param1.isEncrypted, _loc_4, false, _loc_5 == INT_BYTE_SIZE);
            _loc_2.writeByte(_loc_6.encode());
            if (_loc_5 > SHORT_BYTE_SIZE)
            {
                _loc_2.writeInt(_loc_3.length);
            }
            else
            {
                _loc_2.writeShort(_loc_3.length);
            }
            _loc_2.writeBytes(_loc_3);
            if (this.bitSwarm.useBlueBox)
            {
                this.bitSwarm.httpSocket.send(_loc_2);
            }
            else if (this.bitSwarm.socket.connected)
            {
                if (param1.isUDP)
                {
                    this.writeUDP(param1, _loc_2);
                }
                else
                {
                    this.writeTCP(param1, _loc_2);
                }
            }
            return;
        }// end function

        private function writeTCP(param1:IMessage, param2:ByteArray) : void
        {
            var message:* = param1;
            var writeBuffer:* = param2;
            try
            {
                this.bitSwarm.socket.writeBytes(writeBuffer);
                this.bitSwarm.socket.flush();
                if (this.bitSwarm.sfs.debug)
                {
                    this.log.info("Data written: " + message.content.getHexDump());
                }
            }
            catch (error:IOError)
            {
                log.warn("WriteTCP operation failed due to I/O Error: " + error.toString());
            }
            return;
        }// end function

        private function writeUDP(param1:IMessage, param2:ByteArray) : void
        {
            this.bitSwarm.udpManager.send(param2);
            return;
        }// end function

    }
}
