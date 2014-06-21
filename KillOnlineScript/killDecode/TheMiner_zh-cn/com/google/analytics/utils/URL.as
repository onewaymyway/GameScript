package com.google.analytics.utils
{

    public class URL extends Object
    {
        private var _url:String;

        public function URL(url:String = "")
        {
            this._url = url.toLowerCase();
            return;
        }// end function

        public function get protocol() : Protocols
        {
            var _loc_1:* = this._url.split("://")[0];
            switch(_loc_1)
            {
                case "file":
                {
                    return Protocols.file;
                }
                case "http":
                {
                    return Protocols.HTTP;
                }
                case "https":
                {
                    return Protocols.HTTPS;
                }
                default:
                {
                    return Protocols.none;
                    break;
                }
            }
        }// end function

        public function get hostName() : String
        {
            var _loc_1:* = this._url;
            if (_loc_1.indexOf("://") > -1)
            {
                _loc_1 = _loc_1.split("://")[1];
            }
            if (_loc_1.indexOf("/") > -1)
            {
                _loc_1 = _loc_1.split("/")[0];
            }
            if (_loc_1.indexOf("?") > -1)
            {
                _loc_1 = _loc_1.split("?")[0];
            }
            if (this.protocol != Protocols.file)
            {
            }
            if (this.protocol == Protocols.none)
            {
                return "";
            }
            return _loc_1;
        }// end function

        public function get domain() : String
        {
            var _loc_1:Array = null;
            if (this.hostName != "")
            {
            }
            if (this.hostName.indexOf(".") > -1)
            {
                _loc_1 = this.hostName.split(".");
                switch(_loc_1.length)
                {
                    case 2:
                    {
                        return this.hostName;
                    }
                    case 3:
                    {
                        if (_loc_1[1] == "co")
                        {
                            return this.hostName;
                        }
                        _loc_1.shift();
                        return _loc_1.join(".");
                    }
                    case 4:
                    {
                        _loc_1.shift();
                        return _loc_1.join(".");
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return "";
        }// end function

        public function get subDomain() : String
        {
            if (this.domain != "")
            {
            }
            if (this.domain != this.hostName)
            {
                return this.hostName.split("." + this.domain).join("");
            }
            return "";
        }// end function

        public function get path() : String
        {
            var _loc_1:* = this._url;
            if (_loc_1.indexOf("://") > -1)
            {
                _loc_1 = _loc_1.split("://")[1];
            }
            if (_loc_1.indexOf(this.hostName) == 0)
            {
                _loc_1 = _loc_1.substr(this.hostName.length);
            }
            if (_loc_1.indexOf("?") > -1)
            {
                _loc_1 = _loc_1.split("?")[0];
            }
            if (_loc_1.charAt(0) != "/")
            {
                _loc_1 = "/" + _loc_1;
            }
            return _loc_1;
        }// end function

        public function get search() : String
        {
            var _loc_1:* = this._url;
            if (_loc_1.indexOf("://") > -1)
            {
                _loc_1 = _loc_1.split("://")[1];
            }
            if (_loc_1.indexOf(this.hostName) == 0)
            {
                _loc_1 = _loc_1.substr(this.hostName.length);
            }
            if (_loc_1.indexOf("?") > -1)
            {
                _loc_1 = _loc_1.split("?")[1];
            }
            else
            {
                _loc_1 = "";
            }
            return _loc_1;
        }// end function

    }
}
