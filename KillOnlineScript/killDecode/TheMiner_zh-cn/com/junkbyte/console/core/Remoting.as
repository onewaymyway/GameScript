package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Remoting extends ConsoleCore
    {
        protected var _callbacks:Object;
        protected var _remoting:Boolean;
        protected var _local:LocalConnection;
        protected var _socket:Socket;
        protected var _sendBuffer:ByteArray;
        protected var _recBuffers:Object;
        protected var _senders:Dictionary;
        protected var _loggedIn:Boolean;
        protected var _selfId:String;
        protected var _lastRecieverId:String;

        public function Remoting(m:Console)
        {
            var m:* = m;
            this._callbacks = new Object();
            this._sendBuffer = new ByteArray();
            this._recBuffers = new Object();
            this._senders = new Dictionary();
            super(m);
            this.registerCallback("login", function (bytes:ByteArray) : void
            {
                login(bytes.readUTF());
                return;
            }// end function
            );
            return;
        }// end function

        public function update() : void
        {
            var _loc_1:String = null;
            var _loc_2:ByteArray = null;
            var _loc_3:ByteArray = null;
            if (this._sendBuffer.length)
            {
                if (this._socket)
                {
                }
                if (this._socket.connected)
                {
                    this._socket.writeBytes(this._sendBuffer);
                    this._sendBuffer = new ByteArray();
                }
                else if (this._local)
                {
                    this._sendBuffer.position = 0;
                    if (this._sendBuffer.bytesAvailable < 38000)
                    {
                        _loc_2 = this._sendBuffer;
                        this._sendBuffer = new ByteArray();
                    }
                    else
                    {
                        _loc_2 = new ByteArray();
                        this._sendBuffer.readBytes(_loc_2, 0, Math.min(38000, this._sendBuffer.bytesAvailable));
                        _loc_3 = new ByteArray();
                        this._sendBuffer.readBytes(_loc_3);
                        this._sendBuffer = _loc_3;
                    }
                    this._local.send(this.remoteLocalConnectionName, "synchronize", this._selfId, _loc_2);
                }
                else
                {
                    this._sendBuffer = new ByteArray();
                }
            }
            for (_loc_1 in this._recBuffers)
            {
                
                this.processRecBuffer(_loc_1);
            }
            return;
        }// end function

        protected function get selfLlocalConnectionName() : String
        {
            return config.remotingConnectionName + "Sender";
        }// end function

        protected function get remoteLocalConnectionName() : String
        {
            return config.remotingConnectionName + "Receiver";
        }// end function

        private function processRecBuffer(id:String) : void
        {
            var pointer:uint;
            var cmdlen:uint;
            var cmd:String;
            var arg:ByteArray;
            var callbackData:Object;
            var blen:uint;
            var recbuffer:ByteArray;
            var id:* = id;
            if (!this._senders[id])
            {
                this._senders[id] = true;
                if (this._lastRecieverId)
                {
                    report("Switched to [" + id + "] as primary remote.", -2);
                }
                this._lastRecieverId = id;
            }
            var buffer:* = this._recBuffers[id];
            try
            {
                var _loc_3:int = 0;
                buffer.position = 0;
                pointer = _loc_3;
                while (buffer.bytesAvailable)
                {
                    
                    cmdlen = buffer.readByte();
                    if (buffer.bytesAvailable == 0)
                    {
                        break;
                    }
                    cmd = buffer.readUTFBytes(cmdlen);
                    arg;
                    if (buffer.bytesAvailable == 0)
                    {
                        break;
                    }
                    if (buffer.readBoolean())
                    {
                        if (buffer.bytesAvailable == 0)
                        {
                            break;
                        }
                        blen = buffer.readUnsignedInt();
                        if (buffer.bytesAvailable < blen)
                        {
                            break;
                        }
                        arg = new ByteArray();
                        buffer.readBytes(arg, 0, blen);
                    }
                    callbackData = this._callbacks[cmd];
                    if (callbackData == null)
                    {
                        report("Unknown remote commmand received [" + cmd + "].", ConsoleLevel.ERROR);
                    }
                    else
                    {
                        if (callbackData.latest)
                        {
                        }
                        if (id == this._lastRecieverId)
                        {
                            if (arg)
                            {
                                callbackData.fun(arg);
                            }
                            else
                            {
                                callbackData.fun();
                            }
                        }
                    }
                    pointer = buffer.position;
                }
                if (pointer < buffer.length)
                {
                    recbuffer = new ByteArray();
                    recbuffer.writeBytes(buffer, pointer);
                    var _loc_3:* = recbuffer;
                    buffer = recbuffer;
                    this._recBuffers[id] = _loc_3;
                }
                else
                {
                    delete this._recBuffers[id];
                }
            }
            catch (err:Error)
            {
                report("Remoting sync error: " + err, 9);
            }
            return;
        }// end function

        private function synchronize(id:String, obj:Object) : void
        {
            var _loc_3:* = obj as ByteArray;
            if (_loc_3 == null)
            {
                report("Remoting sync error. Recieved non-ByteArray:" + obj, 9);
                return;
            }
            var _loc_4:* = this._recBuffers[id];
            if (_loc_4)
            {
                _loc_4.position = _loc_4.length;
                _loc_4.writeBytes(_loc_3);
            }
            else
            {
                this._recBuffers[id] = _loc_3;
            }
            return;
        }// end function

        public function send(command:String, arg:ByteArray = null) : Boolean
        {
            if (!this._remoting)
            {
                return false;
            }
            this._sendBuffer.position = this._sendBuffer.length;
            this._sendBuffer.writeByte(command.length);
            this._sendBuffer.writeUTFBytes(command);
            if (arg)
            {
                this._sendBuffer.writeBoolean(true);
                this._sendBuffer.writeUnsignedInt(arg.length);
                this._sendBuffer.writeBytes(arg);
            }
            else
            {
                this._sendBuffer.writeBoolean(false);
            }
            return true;
        }// end function

        public function get connected() : Boolean
        {
            if (this._remoting)
            {
            }
            return this._loggedIn;
        }// end function

        public function get remoting() : Boolean
        {
            return this._remoting;
        }// end function

        public function set remoting(newMode:Boolean) : void
        {
            if (newMode == this._remoting)
            {
                return;
            }
            this._selfId = this.generateId();
            if (newMode)
            {
                this.startRemoting();
            }
            else
            {
                this.close();
            }
            console.panels.updateMenu();
            return;
        }// end function

        protected function startRemoting() : void
        {
            if (!this.startLocalConnection())
            {
                report("Could not create remoting client service.", 10);
                return;
            }
            this._sendBuffer = new ByteArray();
            report("<b>Remoting started.</b> " + this.getInfo(), -1);
            this.send("started");
            return;
        }// end function

        public function remotingSocket(host:String, port:int = 0) : void
        {
            if (this._socket)
            {
            }
            if (this._socket.connected)
            {
                this._socket.close();
                this._socket = null;
            }
            if (host)
            {
            }
            if (port)
            {
                this.remoting = true;
                report("Connecting to socket " + host + ":" + port);
                this._socket = new Socket();
                this._socket.addEventListener(Event.CLOSE, this.socketCloseHandler);
                this._socket.addEventListener(Event.CONNECT, this.socketConnectHandler);
                this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.socketIOErrorHandler);
                this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.socketSecurityErrorHandler);
                this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
                this._socket.connect(host, port);
            }
            return;
        }// end function

        private function socketCloseHandler(event:Event) : void
        {
            if (event.currentTarget == this._socket)
            {
                this._socket = null;
            }
            return;
        }// end function

        private function socketConnectHandler(event:Event) : void
        {
            report("Remoting socket connected.", -1);
            this._sendBuffer = new ByteArray();
            if (!this._loggedIn)
            {
            }
            if (this.checkLogin(""))
            {
                this.sendLoginSuccess();
            }
            else
            {
                this.send("loginRequest");
            }
            return;
        }// end function

        private function socketIOErrorHandler(event:Event) : void
        {
            report("Remoting socket error." + event, 9);
            this.remotingSocket(null);
            return;
        }// end function

        private function socketSecurityErrorHandler(event:Event) : void
        {
            report("Remoting security error." + event, 9);
            this.remotingSocket(null);
            return;
        }// end function

        private function socketDataHandler(event:Event) : void
        {
            this.handleSocket(event.currentTarget as Socket);
            return;
        }// end function

        public function handleSocket(socket:Socket) : void
        {
            if (!this._senders[socket])
            {
                this._senders[socket] = this.generateId();
                this._socket = socket;
            }
            var _loc_2:* = new ByteArray();
            socket.readBytes(_loc_2);
            this.synchronize(this._senders[socket], _loc_2);
            return;
        }// end function

        protected function onLocalConnectionStatus(event:StatusEvent) : void
        {
            if (event.level == "error")
            {
            }
            if (this._loggedIn)
            {
                if (this._socket)
                {
                }
            }
            if (!this._socket.connected)
            {
                report("Remote connection lost.", ConsoleLevel.ERROR);
                this._loggedIn = false;
            }
            return;
        }// end function

        protected function onRemoteAsyncError(event:AsyncErrorEvent) : void
        {
            report("Problem with remote sync. [<a href=\'event:remote\'>Click here</a>] to restart.", 10);
            this.remoting = false;
            return;
        }// end function

        protected function onRemotingSecurityError(event:SecurityErrorEvent) : void
        {
            report("Remoting security error.", 9);
            this.printHowToGlobalSetting();
            return;
        }// end function

        protected function getInfo() : String
        {
            return "<p4>channel:" + config.remotingConnectionName + " (" + Security.sandboxType + ")</p4>";
        }// end function

        protected function printHowToGlobalSetting() : void
        {
            report("Make sure your flash file is \'trusted\' in Global Security Settings.", -2);
            report("Go to Settings Manager [<a href=\'event:settings\'>click here</a>] &gt; \'Global Security Settings Panel\'  &gt; add the location of the local flash (swf) file.", -2);
            return;
        }// end function

        protected function generateId() : String
        {
            return new Date().time + "." + Math.floor(Math.random() * 100000);
        }// end function

        protected function startLocalConnection() : Boolean
        {
            this.close();
            this._remoting = true;
            this._local = new LocalConnection();
            this._local.client = {synchronize:this.synchronize};
            this._local.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRemotingSecurityError, false, 0, true);
            this._local.addEventListener(StatusEvent.STATUS, this.onLocalConnectionStatus, false, 0, true);
            this._local.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onRemoteAsyncError, false, 0, true);
            try
            {
                this._local.connect(this.selfLlocalConnectionName);
            }
            catch (err:Error)
            {
                _remoting = false;
                _local = null;
                return false;
            }
            return true;
        }// end function

        public function registerCallback(key:String, fun:Function, lastestSenderOnly:Boolean = false) : void
        {
            this._callbacks[key] = {fun:fun, latest:lastestSenderOnly};
            return;
        }// end function

        private function sendLoginSuccess() : void
        {
            this._loggedIn = true;
            this.send("loginSuccess");
            dispatchEvent(new Event(Event.CONNECT));
            return;
        }// end function

        public function login(pass:String = "") : void
        {
            if (!this._loggedIn)
            {
            }
            if (this.checkLogin(pass))
            {
                this.sendLoginSuccess();
            }
            else
            {
                this.send("loginFail");
            }
            return;
        }// end function

        private function checkLogin(pass:String) : Boolean
        {
            if (config.remotingPassword === null)
            {
            }
            if (config.keystrokePassword != pass)
            {
            }
            if (config.remotingPassword !== "")
            {
            }
            return config.remotingPassword == pass;
        }// end function

        public function close() : void
        {
            if (this._local)
            {
                try
                {
                    this._local.close();
                }
                catch (error:Error)
                {
                    report("Remote.close: " + error, 10);
                }
            }
            this._remoting = false;
            this._sendBuffer = new ByteArray();
            this._local = null;
            return;
        }// end function

    }
}
