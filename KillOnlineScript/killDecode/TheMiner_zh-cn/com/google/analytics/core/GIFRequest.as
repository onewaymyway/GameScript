package com.google.analytics.core
{
    import com.google.analytics.debug.*;
    import com.google.analytics.utils.*;
    import com.google.analytics.v4.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class GIFRequest extends Object
    {
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _buffer:Buffer;
        private var _info:Environment;
        private var _utmac:String;
        private var _lastRequest:URLRequest;
        private var _count:int;
        private var _alertcount:int;
        private var _requests:Array;
        private static const MAX_REQUEST_LENGTH:Number = 2048;

        public function GIFRequest(config:Configuration, debug:DebugConfiguration, buffer:Buffer, info:Environment)
        {
            this._config = config;
            this._debug = debug;
            this._buffer = buffer;
            this._info = info;
            this._count = 0;
            this._alertcount = 0;
            this._requests = [];
            return;
        }// end function

        public function get utmac() : String
        {
            return this._utmac;
        }// end function

        public function get utmwv() : String
        {
            return this._config.version;
        }// end function

        public function get utmn() : String
        {
            return Utils.generate32bitRandom() as String;
        }// end function

        public function get utmhn() : String
        {
            return this._info.domainName;
        }// end function

        public function get utmsp() : String
        {
            return this._config.sampleRate * 100 as String;
        }// end function

        public function get utmcc() : String
        {
            var _loc_1:Array = [];
            if (this._buffer.hasUTMA())
            {
                _loc_1.push(this._buffer.utma.toURLString() + ";");
            }
            if (this._buffer.hasUTMZ())
            {
                _loc_1.push(this._buffer.utmz.toURLString() + ";");
            }
            if (this._buffer.hasUTMV())
            {
                _loc_1.push(this._buffer.utmv.toURLString() + ";");
            }
            return _loc_1.join("+");
        }// end function

        public function updateToken() : void
        {
            var _loc_2:Number = NaN;
            var _loc_1:* = new Date().getTime();
            _loc_2 = (_loc_1 - this._buffer.utmb.lastTime) * (this._config.tokenRate / 1000);
            if (this._debug.verbose)
            {
                this._debug.info("tokenDelta: " + _loc_2, VisualDebugMode.geek);
            }
            if (_loc_2 >= 1)
            {
                this._buffer.utmb.token = Math.min(Math.floor(this._buffer.utmb.token + _loc_2), this._config.bucketCapacity);
                this._buffer.utmb.lastTime = _loc_1;
                if (this._debug.verbose)
                {
                    this._debug.info(this._buffer.utmb.toString(), VisualDebugMode.geek);
                }
            }
            return;
        }// end function

        private function _debugSend(request:URLRequest) : void
        {
            var _loc_3:String = null;
            var _loc_2:String = "";
            switch(this._debug.mode)
            {
                case VisualDebugMode.geek:
                {
                    _loc_2 = "Gif Request #" + this._alertcount + ":\n" + request.url;
                    break;
                }
                case VisualDebugMode.advanced:
                {
                    _loc_3 = request.url;
                    if (_loc_3.indexOf("?") > -1)
                    {
                        _loc_3 = _loc_3.split("?")[0];
                    }
                    _loc_3 = this._shortenURL(_loc_3);
                    _loc_2 = "Send Gif Request #" + this._alertcount + ":\n" + _loc_3 + " ?";
                    break;
                }
                case VisualDebugMode.basic:
                {
                }
                default:
                {
                    _loc_2 = "Send " + this._config.serverMode.toString() + " Gif Request #" + this._alertcount + " ?";
                    break;
                }
            }
            this._debug.alertGifRequest(_loc_2, request, this);
            var _loc_4:String = this;
            var _loc_5:* = this._alertcount + 1;
            _loc_4._alertcount = _loc_5;
            return;
        }// end function

        private function _shortenURL(url:String) : String
        {
            var _loc_2:Array = null;
            if (url.length > 60)
            {
                _loc_2 = url.split("/");
                while (url.length > 60)
                {
                    
                    _loc_2.shift();
                    url = "../" + _loc_2.join("/");
                }
            }
            return url;
        }// end function

        public function onSecurityError(event:SecurityErrorEvent) : void
        {
            if (this._debug.GIFRequests)
            {
                this._debug.failure(event.text);
            }
            return;
        }// end function

        public function onIOError(event:IOErrorEvent) : void
        {
            var _loc_2:* = this._lastRequest.url;
            var _loc_3:* = String((this._requests.length - 1));
            var _loc_4:* = "Gif Request #" + _loc_3 + " failed";
            if (this._debug.GIFRequests)
            {
                if (!this._debug.verbose)
                {
                    if (_loc_2.indexOf("?") > -1)
                    {
                        _loc_2 = _loc_2.split("?")[0];
                    }
                    _loc_2 = this._shortenURL(_loc_2);
                }
                if (int(this._debug.mode) > int(VisualDebugMode.basic))
                {
                    _loc_4 = _loc_4 + (" \"" + _loc_2 + "\" does not exists or is unreachable");
                }
                this._debug.failure(_loc_4);
            }
            else
            {
                this._debug.warning(_loc_4);
            }
            this._removeListeners(event.target);
            return;
        }// end function

        public function onComplete(event:Event) : void
        {
            var _loc_2:* = event.target.loader.name;
            this._requests[_loc_2].complete();
            var _loc_3:* = "Gif Request #" + _loc_2 + " sent";
            var _loc_4:* = this._requests[_loc_2].request.url;
            if (this._debug.GIFRequests)
            {
                if (!this._debug.verbose)
                {
                    if (_loc_4.indexOf("?") > -1)
                    {
                        _loc_4 = _loc_4.split("?")[0];
                    }
                    _loc_4 = this._shortenURL(_loc_4);
                }
                if (int(this._debug.mode) > int(VisualDebugMode.basic))
                {
                    _loc_3 = _loc_3 + (" to \"" + _loc_4 + "\"");
                }
                this._debug.success(_loc_3);
            }
            else
            {
                this._debug.info(_loc_3);
            }
            this._removeListeners(event.target);
            return;
        }// end function

        private function _removeListeners(target:Object) : void
        {
            target.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            target.removeEventListener(Event.COMPLETE, this.onComplete);
            return;
        }// end function

        public function sendRequest(request:URLRequest) : void
        {
            var request:* = request;
            if (request.url.length > MAX_REQUEST_LENGTH)
            {
                this._debug.failure("No request sent. URI length too long.");
                return;
            }
            var loader:* = new Loader();
            var _loc_3:String = this;
            _loc_3._count = this._count + 1;
            loader.name = String(this._count++);
            var context:* = new LoaderContext(false);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this._lastRequest = request;
            this._requests[loader.name] = new RequestObject(request);
            try
            {
                loader.load(request, context);
            }
            catch (e:Error)
            {
                _debug.failure("\"Loader.load()\" could not instanciate Gif Request");
            }
            return;
        }// end function

        public function send(account:String, variables:Variables = null, force:Boolean = false, rateLimit:Boolean = false) : void
        {
            var _loc_5:String = null;
            var _loc_6:URLRequest = null;
            var _loc_7:URLRequest = null;
            this._utmac = account;
            if (!variables)
            {
                variables = new Variables();
            }
            variables.URIencode = false;
            variables.pre = ["utmwv", "utmn", "utmhn", "utmt", "utme", "utmcs", "utmsr", "utmsc", "utmul", "utmje", "utmfl", "utmdt", "utmhid", "utmr", "utmp"];
            variables.post = ["utmcc"];
            if (this._debug.verbose)
            {
                this._debug.info("tracking: " + this._buffer.utmb.trackCount + "/" + this._config.trackingLimitPerSession, VisualDebugMode.geek);
            }
            if (this._buffer.utmb.trackCount >= this._config.trackingLimitPerSession)
            {
            }
            if (force)
            {
                if (rateLimit)
                {
                    this.updateToken();
                }
                if (!force)
                {
                }
                if (rateLimit)
                {
                }
                if (this._buffer.utmb.token >= 1)
                {
                    if (!force)
                    {
                    }
                    if (rateLimit)
                    {
                        (this._buffer.utmb.token - 1);
                    }
                    (this._buffer.utmb.trackCount + 1);
                    if (this._debug.verbose)
                    {
                        this._debug.info(this._buffer.utmb.toString(), VisualDebugMode.geek);
                    }
                    variables.utmwv = this.utmwv;
                    variables.utmn = Utils.generate32bitRandom();
                    if (this._info.domainName != "")
                    {
                        variables.utmhn = this._info.domainName;
                    }
                    if (this._config.sampleRate < 1)
                    {
                        variables.utmsp = this._config.sampleRate * 100;
                    }
                    if (this._config.serverMode != ServerOperationMode.local)
                    {
                    }
                    if (this._config.serverMode == ServerOperationMode.both)
                    {
                        _loc_5 = this._info.locationSWFPath;
                        if (_loc_5.lastIndexOf("/") > 0)
                        {
                            _loc_5 = _loc_5.substring(0, _loc_5.lastIndexOf("/"));
                        }
                        _loc_6 = new URLRequest();
                        if (this._config.localGIFpath.indexOf("http") == 0)
                        {
                            _loc_6.url = this._config.localGIFpath;
                        }
                        else
                        {
                            _loc_6.url = _loc_5 + this._config.localGIFpath;
                        }
                        _loc_6.url = _loc_6.url + ("?" + variables.toString());
                        if (this._debug.active)
                        {
                        }
                        if (this._debug.GIFRequests)
                        {
                            this._debugSend(_loc_6);
                        }
                        else
                        {
                            this.sendRequest(_loc_6);
                        }
                    }
                    if (this._config.serverMode != ServerOperationMode.remote)
                    {
                    }
                    if (this._config.serverMode == ServerOperationMode.both)
                    {
                        _loc_7 = new URLRequest();
                        if (this._info.protocol == Protocols.HTTPS)
                        {
                            _loc_7.url = this._config.secureRemoteGIFpath;
                        }
                        else if (this._info.protocol == Protocols.HTTP)
                        {
                            _loc_7.url = this._config.remoteGIFpath;
                        }
                        else
                        {
                            _loc_7.url = this._config.remoteGIFpath;
                        }
                        variables.utmac = this.utmac;
                        variables.utmcc = encodeURIComponent(this.utmcc);
                        _loc_7.url = _loc_7.url + ("?" + variables.toString());
                        if (this._debug.active)
                        {
                        }
                        if (this._debug.GIFRequests)
                        {
                            this._debugSend(_loc_7);
                        }
                        else
                        {
                            this.sendRequest(_loc_7);
                        }
                    }
                }
            }
            return;
        }// end function

    }
}
