package com.smartfoxserver.v2
{
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.core.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.managers.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;
    import com.smartfoxserver.v2.requests.*;
    import com.smartfoxserver.v2.util.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public class SmartFox extends EventDispatcher
    {
        private const DEFAULT_HTTP_PORT:int = 8080;
        private var _majVersion:int = 0;
        private var _minVersion:int = 9;
        private var _subVersion:int = 17;
        private var _bitSwarm:BitSwarmClient;
        private var _lagMonitor:LagMonitor;
        private var _useBlueBox:Boolean = true;
        private var _isConnected:Boolean = false;
        private var _isJoining:Boolean = false;
        private var _mySelf:User;
        private var _sessionToken:String;
        private var _lastJoinedRoom:Room;
        private var _log:Logger;
        private var _inited:Boolean = false;
        private var _debug:Boolean = false;
        private var _isConnecting:Boolean = false;
        private var _userManager:IUserManager;
        private var _roomManager:IRoomManager;
        private var _buddyManager:IBuddyManager;
        private var _config:ConfigData;
        private var _currentZone:String;
        private var _autoConnectOnConfig:Boolean = false;
        private var _lastIpAddress:String;

        public function SmartFox(param1:Boolean = false)
        {
            this._log = Logger.getInstance();
            this._log.enableEventDispatching = true;
            this._debug = param1;
            this.initialize();
            return;
        }// end function

        private function initialize() : void
        {
            if (this._inited)
            {
                return;
            }
            this._bitSwarm = new BitSwarmClient(this);
            this._bitSwarm.ioHandler = new SFSIOHandler(this._bitSwarm);
            this._bitSwarm.init();
            this._bitSwarm.addEventListener(BitSwarmEvent.CONNECT, this.onSocketConnect);
            this._bitSwarm.addEventListener(BitSwarmEvent.DISCONNECT, this.onSocketClose);
            this._bitSwarm.addEventListener(BitSwarmEvent.RECONNECTION_TRY, this.onSocketReconnectionTry);
            this._bitSwarm.addEventListener(BitSwarmEvent.IO_ERROR, this.onSocketIOError);
            this._bitSwarm.addEventListener(BitSwarmEvent.SECURITY_ERROR, this.onSocketSecurityError);
            this._bitSwarm.addEventListener(BitSwarmEvent.DATA_ERROR, this.onSocketDataError);
            addEventListener(SFSEvent.HANDSHAKE, this.handleHandShake);
            addEventListener(SFSEvent.LOGIN, this.handleLogin);
            this._inited = true;
            this.reset();
            return;
        }// end function

        private function reset() : void
        {
            this._userManager = new SFSGlobalUserManager(this);
            this._roomManager = new SFSRoomManager(this);
            this._buddyManager = new SFSBuddyManager(this);
            if (this._lagMonitor != null)
            {
                this._lagMonitor.destroy();
            }
            this._lagMonitor = new LagMonitor(this);
            this._isConnected = false;
            this._isJoining = false;
            this._currentZone = null;
            this._lastJoinedRoom = null;
            this._sessionToken = null;
            this._mySelf = null;
            return;
        }// end function

        public function enableLagMonitor(param1:Boolean) : void
        {
            if (this._mySelf == null)
            {
                this.logger.warn("Lag Monitoring requires that you are logged in a Zone!");
                return;
            }
            if (param1)
            {
                this._lagMonitor.start();
            }
            else
            {
                this._lagMonitor.stop();
            }
            return;
        }// end function

        function get socketEngine() : BitSwarmClient
        {
            return this._bitSwarm;
        }// end function

        function get lagMonitor() : LagMonitor
        {
            return this._lagMonitor;
        }// end function

        public function get isConnected() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this._bitSwarm != null)
            {
                _loc_1 = this._bitSwarm.connected;
            }
            return _loc_1;
        }// end function

        public function get connectionMode() : String
        {
            return this._bitSwarm.connectionMode;
        }// end function

        public function get version() : String
        {
            return "" + this._majVersion + "." + this._minVersion + "." + this._subVersion;
        }// end function

        public function get config() : ConfigData
        {
            return this._config;
        }// end function

        public function get compressionThreshold() : int
        {
            return this._bitSwarm.compressionThreshold;
        }// end function

        public function get maxMessageSize() : int
        {
            return this._bitSwarm.maxMessageSize;
        }// end function

        public function getRoomById(param1:int) : Room
        {
            return this.roomManager.getRoomById(param1);
        }// end function

        public function getRoomByName(param1:String) : Room
        {
            return this.roomManager.getRoomByName(param1);
        }// end function

        public function getRoomListFromGroup(param1:String) : Array
        {
            return this.roomManager.getRoomListFromGroup(param1);
        }// end function

        public function killConnection() : void
        {
            this._bitSwarm.killConnection();
            return;
        }// end function

        public function connect(param1:String = null, param2:int = -1) : void
        {
            if (this.isConnected)
            {
                this._log.warn("Already connected");
                return;
            }
            if (this._isConnecting)
            {
                this._log.warn("A connection attempt is already in progress");
                return;
            }
            if (this.config != null)
            {
                if (param1 == null)
                {
                    param1 = this.config.host;
                }
                if (param2 == -1)
                {
                    param2 = this.config.port;
                }
            }
            if (param1 == null || param1.length == 0)
            {
                throw new ArgumentError("Invalid connection host/address");
            }
            if (param2 < 0 || param2 > 65535)
            {
                throw new ArgumentError("Invalid connection port");
            }
            this._lastIpAddress = param1;
            this._isConnecting = true;
            this._bitSwarm.connect(param1, param2);
            return;
        }// end function

        public function disconnect() : void
        {
            if (this.isConnected)
            {
                if (this._bitSwarm.reconnectionSeconds > 0)
                {
                    this.send(new ManualDisconnectionRequest());
                }
                setTimeout(function () : void
            {
                _bitSwarm.disconnect(ClientDisconnectionReason.MANUAL);
                return;
            }// end function
            , 100);
            }
            else
            {
                this._log.info("You are not connected");
            }
            return;
        }// end function

        public function get debug() : Boolean
        {
            return this._debug;
        }// end function

        public function set debug(param1:Boolean) : void
        {
            this._debug = param1;
            return;
        }// end function

        public function get currentIp() : String
        {
            return this._bitSwarm.connectionIp;
        }// end function

        public function get currentPort() : int
        {
            return this._bitSwarm.connectionPort;
        }// end function

        public function get currentZone() : String
        {
            return this._currentZone;
        }// end function

        public function get mySelf() : User
        {
            return this._mySelf;
        }// end function

        public function set mySelf(param1:User) : void
        {
            this._mySelf = param1;
            return;
        }// end function

        public function get useBlueBox() : Boolean
        {
            return this._useBlueBox;
        }// end function

        public function set useBlueBox(param1:Boolean) : void
        {
            this._useBlueBox = param1;
            return;
        }// end function

        public function get logger() : Logger
        {
            return this._log;
        }// end function

        public function get lastJoinedRoom() : Room
        {
            return this._lastJoinedRoom;
        }// end function

        public function set lastJoinedRoom(param1:Room) : void
        {
            this._lastJoinedRoom = param1;
            return;
        }// end function

        public function get joinedRooms() : Array
        {
            return this.roomManager.getJoinedRooms();
        }// end function

        public function get roomList() : Array
        {
            return this._roomManager.getRoomList();
        }// end function

        public function get roomManager() : IRoomManager
        {
            return this._roomManager;
        }// end function

        public function get userManager() : IUserManager
        {
            return this._userManager;
        }// end function

        public function get buddyManager() : IBuddyManager
        {
            return this._buddyManager;
        }// end function

        public function get udpAvailable() : Boolean
        {
            return this.isAirRuntime();
        }// end function

        public function get udpInited() : Boolean
        {
            return this._bitSwarm.udpManager.inited;
        }// end function

        public function initUDP(param1:IUDPManager, param2:String = null, param3:int = -1) : void
        {
            if (this.isAirRuntime())
            {
                if (!this.isConnected)
                {
                    this._log.warn("Cannot initialize UDP protocol until the client is connected to SFS2X.");
                    return;
                }
                if (this.config != null)
                {
                    if (param2 == null)
                    {
                        param2 = this.config.udpHost;
                    }
                    if (param3 == -1)
                    {
                        param3 = this.config.udpPort;
                    }
                }
                if (param2 == null || param2.length == 0)
                {
                    throw new ArgumentError("Invalid UDP host/address");
                }
                if (param3 < 0 || param3 > 65535)
                {
                    throw new ArgumentError("Invalid UDP port range");
                }
                if (!this._bitSwarm.udpManager.inited && this._bitSwarm.udpManager is DefaultUDPManager)
                {
                    param1.sfs = this;
                    this._bitSwarm.udpManager = param1;
                }
                this._bitSwarm.udpManager.initialize(param2, param3);
            }
            else
            {
                this._log.warn("UDP Failure: the protocol is available only for the AIR 2.0 runtime.");
            }
            return;
        }// end function

        private function isAirRuntime() : Boolean
        {
            return Capabilities.playerType.toLowerCase() == "desktop";
        }// end function

        public function get isJoining() : Boolean
        {
            return this._isJoining;
        }// end function

        public function set isJoining(param1:Boolean) : void
        {
            this._isJoining = param1;
            return;
        }// end function

        public function get sessionToken() : String
        {
            return this._sessionToken;
        }// end function

        public function getReconnectionSeconds() : int
        {
            return this._bitSwarm.reconnectionSeconds;
        }// end function

        public function setReconnectionSeconds(param1:int) : void
        {
            this._bitSwarm.reconnectionSeconds = param1;
            return;
        }// end function

        public function send(param1:IRequest) : void
        {
            var errMsg:String;
            var errorItem:String;
            var request:* = param1;
            if (!this.isConnected)
            {
                this._log.warn("You are not connected. Request cannot be sent: " + request);
                return;
            }
            try
            {
                if (request is JoinRoomRequest)
                {
                    if (this._isJoining)
                    {
                        return;
                    }
                    else
                    {
                        this._isJoining = true;
                    }
                }
                request.validate(this);
                request.execute(this);
                this._bitSwarm.send(request.getMessage());
            }
            catch (problem:SFSValidationError)
            {
                errMsg = problem.message;
                var _loc_4:int = 0;
                var _loc_5:* = problem.errors;
                while (_loc_5 in _loc_4)
                {
                    
                    errorItem = _loc_5[_loc_4];
                    errMsg = errMsg + ("\t" + errorItem + "\n");
                }
                _log.warn(errMsg);
                ;
            }
            catch (error:SFSCodecError)
            {
                _log.warn(error.message);
            }
            return;
        }// end function

        public function loadConfig(param1:String = "sfs-config.xml", param2:Boolean = true) : void
        {
            var _loc_3:* = new ConfigLoader();
            _loc_3.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, this.onConfigLoadSuccess);
            _loc_3.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, this.onConfigLoadFailure);
            this._autoConnectOnConfig = param2;
            _loc_3.loadConfig(param1);
            return;
        }// end function

        public function addJoinedRoom(param1:Room) : void
        {
            if (!this.roomManager.containsRoom(param1.id))
            {
                this.roomManager.addRoom(param1);
                this._lastJoinedRoom = param1;
            }
            else
            {
                throw new SFSError("Unexpected: joined room already exists for this User: " + this.mySelf.name + ", Room: " + param1);
            }
            return;
        }// end function

        public function removeJoinedRoom(param1:Room) : void
        {
            this.roomManager.removeRoom(param1);
            if (this.joinedRooms.length > 0)
            {
                this._lastJoinedRoom = this.joinedRooms[(this.joinedRooms.length - 1)];
            }
            return;
        }// end function

        private function onSocketConnect(event:BitSwarmEvent) : void
        {
            if (event.params.success)
            {
                this.sendHandshakeRequest(event.params._isReconnection);
            }
            else
            {
                this._log.warn("Connection attempt failed");
                this.handleConnectionProblem(event);
            }
            return;
        }// end function

        private function onSocketClose(event:BitSwarmEvent) : void
        {
            this.reset();
            dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_LOST, {reason:event.params.reason}));
            return;
        }// end function

        private function onSocketReconnectionTry(event:BitSwarmEvent) : void
        {
            dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RETRY, {}));
            return;
        }// end function

        private function onSocketDataError(event:BitSwarmEvent) : void
        {
            dispatchEvent(new SFSEvent(SFSEvent.SOCKET_ERROR, {errorMessage:event.params.message}));
            return;
        }// end function

        private function onSocketIOError(event:BitSwarmEvent) : void
        {
            if (this._isConnecting)
            {
                this.handleConnectionProblem(event);
            }
            return;
        }// end function

        private function onSocketSecurityError(event:BitSwarmEvent) : void
        {
            if (this._isConnecting)
            {
                this.handleConnectionProblem(event);
            }
            return;
        }// end function

        private function onConfigLoadSuccess(event:SFSEvent) : void
        {
            var _loc_2:* = event.target as ConfigLoader;
            var _loc_3:* = event.params.cfg as ConfigData;
            _loc_2.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, this.onConfigLoadSuccess);
            _loc_2.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE, this.onConfigLoadFailure);
            if (_loc_3.host == null || _loc_3.host.length == 0)
            {
                throw new ArgumentError("Invalid Host/IpAddress in external config file");
            }
            if (_loc_3.port < 0 || _loc_3.port > 65535)
            {
                throw new ArgumentError("Invalid TCP port in external config file");
            }
            if (_loc_3.zone == null || _loc_3.zone.length == 0)
            {
                throw new ArgumentError("Invalid Zone name in external config file");
            }
            this._debug = _loc_3.debug;
            this._useBlueBox = _loc_3.useBlueBox;
            this._config = _loc_3;
            var _loc_4:* = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS, {config:_loc_3});
            dispatchEvent(_loc_4);
            if (this._autoConnectOnConfig)
            {
                this.connect(this._config.host, this._config.port);
            }
            return;
        }// end function

        private function onConfigLoadFailure(event:SFSEvent) : void
        {
            var _loc_2:* = event.target as ConfigLoader;
            _loc_2.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, this.onConfigLoadSuccess);
            _loc_2.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE, this.onConfigLoadFailure);
            var _loc_3:* = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE, {});
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function handleHandShake(event:SFSEvent) : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            var _loc_2:* = event.params.message;
            var _loc_3:* = _loc_2.content;
            if (_loc_3.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                this._sessionToken = _loc_3.getUtfString(HandshakeRequest.KEY_SESSION_TOKEN);
                this._bitSwarm.compressionThreshold = _loc_3.getInt(HandshakeRequest.KEY_COMPRESSION_THRESHOLD);
                this._bitSwarm.maxMessageSize = _loc_3.getInt(HandshakeRequest.KEY_MAX_MESSAGE_SIZE);
                if (this._bitSwarm.isReconnecting)
                {
                    this._bitSwarm.isReconnecting = false;
                    dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RESUME, {}));
                }
                else
                {
                    this._isConnecting = false;
                    dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, {success:true}));
                }
            }
            else
            {
                _loc_4 = _loc_3.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_5 = SFSErrorCodes.getErrorMessage(_loc_4, _loc_3.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_6 = {success:false, errorMessage:_loc_5, errorCode:_loc_4};
                dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, _loc_6));
            }
            return;
        }// end function

        private function handleLogin(event:SFSEvent) : void
        {
            this._currentZone = event.params.zone;
            return;
        }// end function

        public function handleClientDisconnection(param1:String) : void
        {
            this._bitSwarm.reconnectionSeconds = 0;
            this._bitSwarm.disconnect(param1);
            this.reset();
            return;
        }// end function

        public function handleLogout() : void
        {
            this._userManager = new SFSGlobalUserManager(this);
            this._roomManager = new SFSRoomManager(this);
            this._isJoining = false;
            this._lastJoinedRoom = null;
            this._currentZone = null;
            this._mySelf = null;
            return;
        }// end function

        private function handleConnectionProblem(event:BitSwarmEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            if (this._bitSwarm.connectionMode == ConnectionMode.SOCKET && this._useBlueBox)
            {
                this._bitSwarm.forceBlueBox(true);
                _loc_2 = this.config != null ? (this.config.httpPort) : (this.DEFAULT_HTTP_PORT);
                this._bitSwarm.connect(this._lastIpAddress, _loc_2);
                dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_ATTEMPT_HTTP, {}));
            }
            else
            {
                _loc_3 = {success:false, errorMessage:event.params.message};
                dispatchEvent(new SFSEvent(SFSEvent.CONNECTION, _loc_3));
                var _loc_4:Boolean = false;
                this._isConnected = false;
                this._isConnecting = _loc_4;
            }
            return;
        }// end function

        private function sendHandshakeRequest(param1:Boolean = false) : void
        {
            var _loc_2:* = new HandshakeRequest(this.version, param1 ? (this._sessionToken) : (null));
            this.send(_loc_2);
            return;
        }// end function

    }
}
