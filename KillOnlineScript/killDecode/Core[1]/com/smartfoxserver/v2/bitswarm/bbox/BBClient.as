package com.smartfoxserver.v2.bitswarm.bbox
{
    import com.hurlant.util.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class BBClient extends EventDispatcher
    {
        private const BB_DEFAULT_HOST:String = "localhost";
        private const BB_DEFAULT_PORT:int = 8080;
        private const BB_SERVLET:String = "BlueBox/BlueBox.do";
        private const BB_NULL:String = "null";
        private const CMD_CONNECT:String = "connect";
        private const CMD_POLL:String = "poll";
        private const CMD_DATA:String = "data";
        private const CMD_DISCONNECT:String = "disconnect";
        private const ERR_INVALID_SESSION:String = "err01";
        private const SFS_HTTP:String = "sfsHttp";
        private const SEP:String = "|";
        private const MIN_POLL_SPEED:int = 20;
        private const MAX_POLL_SPEED:int = 10000;
        private const DEFAULT_POLL_SPEED:int = 100;
        private var _isConnected:Boolean = false;
        private var _host:String = "localhost";
        private var _port:int = 8080;
        private var _bbUrl:String;
        private var _debug:Boolean;
        private var _sessId:String;
        private var _loader:URLLoader;
        private var _urlRequest:URLRequest;
        private var _pollSpeed:int = 100;

        public function BBClient(param1:String = "localhost", param2:int = 8080, param3:Boolean = false)
        {
            this._host = param1;
            this._port = param2;
            this._debug = param3;
            return;
        }// end function

        public function get isConnected() : Boolean
        {
            return this._sessId != null;
        }// end function

        public function get isDebug() : Boolean
        {
            return this._debug;
        }// end function

        public function get host() : String
        {
            return this._host;
        }// end function

        public function get port() : int
        {
            return this._port;
        }// end function

        public function get sessionId() : String
        {
            return this._sessId;
        }// end function

        public function get pollSpeed() : int
        {
            return this._pollSpeed;
        }// end function

        public function set pollSpeed(param1:int) : void
        {
            this._pollSpeed = param1;
            return;
        }// end function

        public function set isDebug(param1:Boolean) : void
        {
            this._debug = param1;
            return;
        }// end function

        public function connect(param1:String = "127.0.0.1", param2:int = 8080) : void
        {
            if (this.isConnected)
            {
                throw new IllegalOperationError("BlueBox session is already connected");
            }
            this._host = param1;
            this._port = param2;
            this._bbUrl = "http://" + this._host + ":" + param2 + "/" + this.BB_SERVLET;
            this.sendRequest(this.CMD_CONNECT);
            return;
        }// end function

        public function send(param1:ByteArray) : void
        {
            if (!this.isConnected)
            {
                throw new IllegalOperationError("Can\'t send data, BlueBox connection is not active");
            }
            this.sendRequest(this.CMD_DATA, param1);
            return;
        }// end function

        public function disconnect() : void
        {
            this.sendRequest(this.CMD_DISCONNECT);
            return;
        }// end function

        public function close() : void
        {
            this.handleConnectionLost(false);
            return;
        }// end function

        private function onHttpResponse(event:Event) : void
        {
            var _loc_7:ByteArray = null;
            var _loc_2:* = event.target as URLLoader;
            var _loc_3:* = _loc_2.data as String;
            if (this._debug)
            {
                trace("[ BB-Receive ]: " + _loc_3);
            }
            var _loc_4:* = _loc_3.split(this.SEP);
            var _loc_5:* = _loc_3.split(this.SEP)[0];
            var _loc_6:* = _loc_4[1];
            if (_loc_5 == this.CMD_CONNECT)
            {
                this._sessId = _loc_6;
                this._isConnected = true;
                dispatchEvent(new BBEvent(BBEvent.CONNECT, {}));
                this.poll();
            }
            else if (_loc_5 == this.CMD_POLL)
            {
                _loc_7 = null;
                if (_loc_6 != this.BB_NULL)
                {
                    _loc_7 = this.decodeResponse(_loc_6);
                }
                if (this._isConnected)
                {
                    setTimeout(this.poll, this._pollSpeed);
                }
                dispatchEvent(new BBEvent(BBEvent.DATA, {data:_loc_7}));
            }
            else if (_loc_5 == this.ERR_INVALID_SESSION)
            {
                this.handleConnectionLost();
            }
            return;
        }// end function

        private function onHttpIOError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new BBEvent(BBEvent.IO_ERROR, {message:event.text});
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function poll() : void
        {
            this.sendRequest(this.CMD_POLL);
            return;
        }// end function

        private function sendRequest(param1:String, param2 = null) : void
        {
            this._urlRequest = new URLRequest(this._bbUrl);
            this._urlRequest.method = URLRequestMethod.POST;
            var _loc_3:* = new URLVariables();
            _loc_3[this.SFS_HTTP] = this.encodeRequest(param1, param2);
            this._urlRequest.data = _loc_3;
            if (this._debug)
            {
                trace("[ BB-Send ]: " + _loc_3[this.SFS_HTTP]);
            }
            var _loc_4:* = this.getLoader();
            this.getLoader().data = _loc_3;
            _loc_4.load(this._urlRequest);
            return;
        }// end function

        private function getLoader() : URLLoader
        {
            var _loc_1:* = new URLLoader();
            _loc_1.dataFormat = URLLoaderDataFormat.TEXT;
            _loc_1.addEventListener(Event.COMPLETE, this.onHttpResponse);
            _loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.onHttpIOError);
            _loc_1.addEventListener(IOErrorEvent.NETWORK_ERROR, this.onHttpIOError);
            return _loc_1;
        }// end function

        private function handleConnectionLost(param1:Boolean = true) : void
        {
            if (this._isConnected)
            {
                this._isConnected = false;
                this._sessId = null;
                if (param1)
                {
                    dispatchEvent(new BBEvent(BBEvent.DISCONNECT, {}));
                }
            }
            return;
        }// end function

        private function encodeRequest(param1:String, param2 = null) : String
        {
            var _loc_3:String = "";
            if (param1 == null)
            {
                param1 = this.BB_NULL;
            }
            if (param2 == null)
            {
                param2 = this.BB_NULL;
            }
            else if (param2 is ByteArray)
            {
                param2 = Base64.encodeByteArray(param2);
            }
            _loc_3 = _loc_3 + ((this._sessId == null ? (this.BB_NULL) : (this._sessId)) + this.SEP + param1 + this.SEP + param2);
            return _loc_3;
        }// end function

        private function decodeResponse(param1:String) : ByteArray
        {
            return Base64.decodeToByteArray(param1);
        }// end function

    }
}
