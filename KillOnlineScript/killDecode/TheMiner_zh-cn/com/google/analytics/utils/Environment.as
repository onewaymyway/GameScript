package com.google.analytics.utils
{
    import com.google.analytics.debug.*;
    import com.google.analytics.external.*;
    import flash.system.*;

    public class Environment extends Object
    {
        private var _debug:DebugConfiguration;
        private var _dom:HTMLDOM;
        private var _protocol:Protocols;
        private var _appName:String;
        private var _appVersion:Version;
        private var _userAgent:UserAgent;
        private var _url:String;

        public function Environment(url:String = "", app:String = "", version:String = "", debug:DebugConfiguration = null, dom:HTMLDOM = null)
        {
            var _loc_6:Version = null;
            if (app == "")
            {
                if (this.isAIR())
                {
                    app = "AIR";
                }
                else
                {
                    app = "Flash";
                }
            }
            if (version == "")
            {
                _loc_6 = this.flashVersion;
            }
            else
            {
                _loc_6 = Version.fromString(version);
            }
            this._url = url;
            this._appName = app;
            this._appVersion = _loc_6;
            this._debug = debug;
            this._dom = dom;
            return;
        }// end function

        private function _findProtocol() : void
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_1:* = Protocols.none;
            if (this._url != "")
            {
                _loc_4 = this._url.toLowerCase();
                _loc_5 = _loc_4.substr(0, 5);
                switch(_loc_5)
                {
                    case "file:":
                    {
                        _loc_1 = Protocols.file;
                        break;
                    }
                    case "http:":
                    {
                        _loc_1 = Protocols.HTTP;
                        break;
                    }
                    case "https":
                    {
                        if (_loc_4.charAt(5) == ":")
                        {
                            _loc_1 = Protocols.HTTPS;
                        }
                        break;
                    }
                    default:
                    {
                        this._protocol = Protocols.none;
                        break;
                    }
                }
            }
            var _loc_2:* = this._dom.protocol;
            var _loc_3:* = (_loc_1.toString() + ":").toLowerCase();
            if (_loc_2)
            {
            }
            if (_loc_2 != _loc_3)
            {
            }
            if (this._debug)
            {
                this._debug.warning("Protocol mismatch: SWF=" + _loc_3 + ", DOM=" + _loc_2);
            }
            this._protocol = _loc_1;
            return;
        }// end function

        public function get appName() : String
        {
            return this._appName;
        }// end function

        public function set appName(value:String) : void
        {
            this._appName = value;
            this.userAgent.applicationProduct = value;
            return;
        }// end function

        public function get appVersion() : Version
        {
            return this._appVersion;
        }// end function

        public function set appVersion(value:Version) : void
        {
            this._appVersion = value;
            this.userAgent.applicationVersion = value.toString(4);
            return;
        }// end function

        function set url(value:String) : void
        {
            this._url = value;
            return;
        }// end function

        public function get locationSWFPath() : String
        {
            return this._url;
        }// end function

        public function get referrer() : String
        {
            var _loc_1:* = this._dom.referrer;
            if (_loc_1)
            {
                return _loc_1;
            }
            if (this.protocol == Protocols.file)
            {
                return "localhost";
            }
            return "";
        }// end function

        public function get documentTitle() : String
        {
            var _loc_1:* = this._dom.title;
            if (_loc_1)
            {
                return _loc_1;
            }
            return "";
        }// end function

        public function get domainName() : String
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:int = 0;
            if (this.protocol != Protocols.HTTP)
            {
            }
            if (this.protocol == Protocols.HTTPS)
            {
                _loc_1 = this._url.toLowerCase();
                if (this.protocol == Protocols.HTTP)
                {
                    _loc_2 = _loc_1.split("http://").join("");
                }
                else if (this.protocol == Protocols.HTTPS)
                {
                    _loc_2 = _loc_1.split("https://").join("");
                }
                _loc_3 = _loc_2.indexOf("/");
                if (_loc_3 > -1)
                {
                    _loc_2 = _loc_2.substring(0, _loc_3);
                }
                return _loc_2;
            }
            if (this.protocol == Protocols.file)
            {
                return "localhost";
            }
            return "";
        }// end function

        public function isAIR() : Boolean
        {
            if (this.playerType == "Desktop")
            {
            }
            return Security.sandboxType.toString() == "application";
        }// end function

        public function isInHTML() : Boolean
        {
            return Capabilities.playerType == "PlugIn";
        }// end function

        public function get locationPath() : String
        {
            var _loc_1:* = this._dom.pathname;
            if (_loc_1)
            {
                return _loc_1;
            }
            return "";
        }// end function

        public function get locationSearch() : String
        {
            var _loc_1:* = this._dom.search;
            if (_loc_1)
            {
                return _loc_1;
            }
            return "";
        }// end function

        public function get flashVersion() : Version
        {
            var _loc_1:* = Version.fromString(Capabilities.version.split(" ")[1], ",");
            return _loc_1;
        }// end function

        public function get language() : String
        {
            var _loc_1:* = this._dom.language;
            var _loc_2:* = Capabilities.language;
            if (_loc_1)
            {
                if (_loc_1.length > _loc_2.length)
                {
                }
                if (_loc_1.substr(0, _loc_2.length) == _loc_2)
                {
                    _loc_2 = _loc_1;
                }
            }
            return _loc_2;
        }// end function

        public function get languageEncoding() : String
        {
            var _loc_1:String = null;
            if (System.useCodePage)
            {
                _loc_1 = this._dom.characterSet;
                if (_loc_1)
                {
                    return _loc_1;
                }
                return "-";
            }
            return "UTF-8";
        }// end function

        public function get operatingSystem() : String
        {
            return Capabilities.os;
        }// end function

        public function get playerType() : String
        {
            return Capabilities.playerType;
        }// end function

        public function get platform() : String
        {
            var _loc_1:* = Capabilities.manufacturer;
            return _loc_1.split("Adobe ")[1];
        }// end function

        public function get protocol() : Protocols
        {
            if (!this._protocol)
            {
                this._findProtocol();
            }
            return this._protocol;
        }// end function

        public function get screenHeight() : Number
        {
            return Capabilities.screenResolutionY;
        }// end function

        public function get screenWidth() : Number
        {
            return Capabilities.screenResolutionX;
        }// end function

        public function get screenColorDepth() : String
        {
            var _loc_1:String = null;
            switch(Capabilities.screenColor)
            {
                case "bw":
                {
                    _loc_1 = "1";
                    break;
                }
                case "gray":
                {
                    _loc_1 = "2";
                    break;
                }
                case "color":
                {
                }
                default:
                {
                    _loc_1 = "24";
                    break;
                }
            }
            var _loc_2:* = this._dom.colorDepth;
            if (_loc_2)
            {
                _loc_1 = _loc_2;
            }
            return _loc_1;
        }// end function

        public function get userAgent() : UserAgent
        {
            if (!this._userAgent)
            {
                this._userAgent = new UserAgent(this, this.appName, this.appVersion.toString(4));
            }
            return this._userAgent;
        }// end function

        public function set userAgent(custom:UserAgent) : void
        {
            this._userAgent = custom;
            return;
        }// end function

    }
}
