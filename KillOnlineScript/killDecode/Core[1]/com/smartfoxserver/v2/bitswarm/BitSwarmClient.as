package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.bitswarm.bbox.*;
    import com.smartfoxserver.v2.controllers.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;
    import com.smartfoxserver.v2.util.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class BitSwarmClient extends EventDispatcher
    {
        private var _socket:Socket;
        private var _bbClient:BBClient;
        private var _ioHandler:IoHandler;
        private var _controllers:Object;
        private var _compressionThreshold:int = 2000000;
        private var _maxMessageSize:int = 10000;
        private var _sfs:SmartFox;
        private var _connected:Boolean;
        private var _lastIpAddress:String;
        private var _lastTcpPort:int;
        private var _reconnectionDelayMillis:int = 1000;
        private var _reconnectionSeconds:int = 0;
        private var _attemptingReconnection:Boolean = false;
        private var _log:Logger;
        private var _sysController:SystemController;
        private var _extController:ExtensionController;
        private var _udpManager:IUDPManager;
        private var _controllersInited:Boolean = false;
        private var _useBlueBox:Boolean = false;
        private var _connectionMode:String;

        public function BitSwarmClient(param1:SmartFox = null)
        {
            this._controllers = {};
            this._sfs = param1;
            this._connected = false;
            this._log = Logger.getInstance();
            this._udpManager = new DefaultUDPManager(param1);
            return;
        }// end function

        public function get sfs() : SmartFox
        {
            return this._sfs;
        }// end function

        public function get connected() : Boolean
        {
            return this._connected;
        }// end function

        public function get connectionMode() : String
        {
            return this._connectionMode;
        }// end function

        public function get ioHandler() : IoHandler
        {
            return this._ioHandler;
        }// end function

        public function set ioHandler(param1:IoHandler) : void
        {
            if (this._ioHandler != null)
            {
                throw new SFSError("IOHandler is already set!");
            }
            this._ioHandler = param1;
            return;
        }// end function

        public function get maxMessageSize() : int
        {
            return this._maxMessageSize;
        }// end function

        public function set maxMessageSize(param1:int) : void
        {
            this._maxMessageSize = param1;
            return;
        }// end function

        public function get compressionThreshold() : int
        {
            return this._compressionThreshold;
        }// end function

        public function set compressionThreshold(param1:int) : void
        {
            if (param1 > 100)
            {
                this._compressionThreshold = param1;
            }
            else
            {
                throw new ArgumentError("Compression threshold cannot be < 100 bytes.");
            }
            return;
        }// end function

        public function get reconnectionDelayMillis() : int
        {
            return this._reconnectionDelayMillis;
        }// end function

        public function get useBlueBox() : Boolean
        {
            return this._useBlueBox;
        }// end function

        public function forceBlueBox(param1:Boolean) : void
        {
            if (!this.connected)
            {
                this._useBlueBox = param1;
            }
            else
            {
                throw new IllegalOperationError("You can\'t change the BlueBox mode while the connection is running");
            }
            return;
        }// end function

        public function set reconnectionDelayMillis(param1:int) : void
        {
            this._reconnectionDelayMillis = param1;
            return;
        }// end function

        public function enableBBoxDebug(param1:Boolean) : void
        {
            this._bbClient.isDebug = param1;
            return;
        }// end function

        public function init() : void
        {
            if (!this._controllersInited)
            {
                this.initControllers();
                this._controllersInited = true;
            }
            this._socket = new Socket();
            this._socket.addEventListener(Event.CONNECT, this.onSocketConnect);
            this._socket.addEventListener(Event.CLOSE, this.onSocketClose);
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.onSocketIOError);
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecurityError);
            this._bbClient = new BBClient();
            this._bbClient.addEventListener(BBEvent.CONNECT, this.onBBConnect);
            this._bbClient.addEventListener(BBEvent.DATA, this.onBBData);
            this._bbClient.addEventListener(BBEvent.DISCONNECT, this.onBBDisconnect);
            this._bbClient.addEventListener(BBEvent.IO_ERROR, this.onBBError);
            this._bbClient.addEventListener(BBEvent.SECURITY_ERROR, this.onBBError);
            return;
        }// end function

        public function destroy() : void
        {
            this._socket.removeEventListener(Event.CONNECT, this.onSocketConnect);
            this._socket.removeEventListener(Event.CLOSE, this.onSocketClose);
            this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
            this._socket.removeEventListener(IOErrorEvent.IO_ERROR, this.onSocketIOError);
            this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecurityError);
            if (this._socket.connected)
            {
                this._socket.close();
            }
            this._socket = null;
            return;
        }// end function

        public function getController(param1:int) : IController
        {
            return this._controllers[param1] as IController;
        }// end function

        public function get systemController() : SystemController
        {
            return this._sysController;
        }// end function

        public function get extensionController() : ExtensionController
        {
            return this._extController;
        }// end function

        public function get isReconnecting() : Boolean
        {
            return this._attemptingReconnection;
        }// end function

        public function set isReconnecting(param1:Boolean) : void
        {
            this._attemptingReconnection = param1;
            return;
        }// end function

        public function getControllerById(param1:int) : IController
        {
            return this._controllers[param1];
        }// end function

        public function get connectionIp() : String
        {
            if (!this.connected)
            {
                return "Not Connected";
            }
            return this._lastIpAddress;
        }// end function

        public function get connectionPort() : int
        {
            if (!this.connected)
            {
                return -1;
            }
            return this._lastTcpPort;
        }// end function

        private function addController(param1:int, param2:IController) : void
        {
            if (param2 == null)
            {
                throw new ArgumentError("Controller is null, it can\'t be added.");
            }
            if (this._controllers[param1] != null)
            {
                throw new ArgumentError("A controller with id: " + param1 + " already exists! Controller can\'t be added: " + param2);
            }
            this._controllers[param1] = param2;
            return;
        }// end function

        public function addCustomController(param1:int, param2:Class) : void
        {
            var _loc_3:* = this.param2(this);
            this.addController(param1, _loc_3);
            return;
        }// end function

        public function connect(param1:String = "127.0.0.1", param2:int = 9933) : void
        {
            this._lastIpAddress = param1;
            this._lastTcpPort = param2;
            if (this._useBlueBox)
            {
                this._bbClient.connect(param1, param2);
                this._connectionMode = ConnectionMode.HTTP;
            }
            else
            {
                this._socket.connect(param1, param2);
                this._connectionMode = ConnectionMode.SOCKET;
            }
            return;
        }// end function

        public function send(param1:IMessage) : void
        {
            this._ioHandler.codec.onPacketWrite(param1);
            return;
        }// end function

        public function get socket() : Socket
        {
            return this._socket;
        }// end function

        public function get httpSocket() : BBClient
        {
            return this._bbClient;
        }// end function

        public function disconnect(param1:String = null) : void
        {
            if (this._useBlueBox)
            {
                this._bbClient.close();
            }
            else
            {
                this._socket.close();
            }
            this.onSocketClose(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:param1}));
            return;
        }// end function

        public function nextUdpPacketId() : Number
        {
            return this._udpManager.nextUdpPacketId();
        }// end function

        public function killConnection() : void
        {
            this._socket.close();
            this.onSocketClose(new Event(Event.CLOSE));
            return;
        }// end function

        public function get udpManager() : IUDPManager
        {
            return this._udpManager;
        }// end function

        public function set udpManager(param1:IUDPManager) : void
        {
            this._udpManager = param1;
            return;
        }// end function

        private function initControllers() : void
        {
            this._sysController = new SystemController(this);
            this._extController = new ExtensionController(this);
            this.addController(0, this._sysController);
            this.addController(1, this._extController);
            return;
        }// end function

        public function get reconnectionSeconds() : int
        {
            return this._reconnectionSeconds;
        }// end function

        public function set reconnectionSeconds(param1:int) : void
        {
            if (param1 < 0)
            {
                this._reconnectionSeconds = 0;
            }
            else
            {
                this._reconnectionSeconds = param1;
            }
            return;
        }// end function

        private function onSocketConnect(event:Event) : void
        {
            this._connected = true;
            var _loc_2:* = new BitSwarmEvent(BitSwarmEvent.CONNECT);
            _loc_2.params = {success:true, _isReconnection:this._attemptingReconnection};
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onSocketClose(event:Event) : void
        {
            var evt:* = event;
            this._connected = false;
            var isRegularDisconnection:* = !this._attemptingReconnection && this.sfs.getReconnectionSeconds() == 0;
            var isManualDisconnection:* = evt is BitSwarmEvent && (evt as BitSwarmEvent).params.reason == ClientDisconnectionReason.MANUAL;
            if (this._attemptingReconnection || isRegularDisconnection || isManualDisconnection)
            {
                this._udpManager.reset();
                if (evt is BitSwarmEvent)
                {
                    dispatchEvent(evt);
                }
                else
                {
                    dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:ClientDisconnectionReason.UNKNOWN}));
                }
                return;
            }
            this._attemptingReconnection = true;
            dispatchEvent(new BitSwarmEvent(BitSwarmEvent.RECONNECTION_TRY));
            setTimeout(function () : void
            {
                connect(_lastIpAddress, _lastTcpPort);
                return;
            }// end function
            , this._reconnectionDelayMillis);
            return;
        }// end function

        private function onSocketData(event:ProgressEvent) : void
        {
            var buffer:ByteArray;
            var event:BitSwarmEvent;
            var evt:* = event;
            try
            {
                buffer = new ByteArray();
                this._socket.readBytes(buffer);
                this._ioHandler.onDataRead(buffer);
            }
            catch (error:Error)
            {
                trace("## SocketDataError: " + evt.toString());
                event = new BitSwarmEvent(BitSwarmEvent.DATA_ERROR);
                event.params = {message:evt.toString()};
                dispatchEvent(event);
            }
            return;
        }// end function

        private function onSocketIOError(event:IOErrorEvent) : void
        {
            if (this._attemptingReconnection)
            {
                dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:ClientDisconnectionReason.UNKNOWN}));
                return;
            }
            trace("## SocketError: " + event.toString());
            var _loc_2:* = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
            _loc_2.params = {message:event.toString()};
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onSocketSecurityError(event:SecurityErrorEvent) : void
        {
            trace("## SecurityError: " + event.toString());
            var _loc_2:* = new BitSwarmEvent(BitSwarmEvent.SECURITY_ERROR);
            _loc_2.params = {message:event.text};
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onBBConnect(event:BBEvent) : void
        {
            this._connected = true;
            var _loc_2:* = new BitSwarmEvent(BitSwarmEvent.CONNECT);
            _loc_2.params = {success:true};
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onBBData(event:BBEvent) : void
        {
            var _loc_2:* = event.params.data;
            if (_loc_2 != null)
            {
                this._ioHandler.onDataRead(_loc_2);
            }
            return;
        }// end function

        private function onBBDisconnect(event:BBEvent) : void
        {
            this._connected = false;
            dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT, {reason:ClientDisconnectionReason.UNKNOWN}));
            return;
        }// end function

        private function onBBError(event:BBEvent) : void
        {
            trace("## BlueBox Error: " + event.params.message);
            var _loc_2:* = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
            _loc_2.params = {message:event.params.message};
            dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
