package com.google.analytics.external
{
    import com.google.analytics.debug.*;

    public class HTMLDOM extends JavascriptProxy
    {
        private var _host:String;
        private var _language:String;
        private var _characterSet:String;
        private var _colorDepth:String;
        private var _location:String;
        private var _pathname:String;
        private var _protocol:String;
        private var _search:String;
        private var _referrer:String;
        private var _title:String;
        public static var cache_properties_js:XML = <script>r
n            <![CDATA[r
n                    function()r
n                    {r
n                        var obj = {};r
n                            obj.host         = document.location.host;r
n                            obj.language     = navigator.language ? navigator.language : navigator.browserLanguage;r
n                            obj.characterSet = document.characterSet ? document.characterSet : document.charset;r
n                            obj.colorDepth   = window.screen.colorDepth;r
n                            obj.location     = document.location.toString();r
n                            obj.pathname     = document.location.pathname;r
n                            obj.protocol     = document.location.protocol;r
n                            obj.search       = document.location.search;r
n                            obj.referrer     = document.referrer;r
n                            obj.title        = document.title;r
n                        r
n                        return obj;r
n                    }r
n                ]]>r
n         </script>")("<script>
            <![CDATA[
                    function()
                    {
                        var obj = {};
                            obj.host         = document.location.host;
                            obj.language     = navigator.language ? navigator.language : navigator.browserLanguage;
                            obj.characterSet = document.characterSet ? document.characterSet : document.charset;
                            obj.colorDepth   = window.screen.colorDepth;
                            obj.location     = document.location.toString();
                            obj.pathname     = document.location.pathname;
                            obj.protocol     = document.location.protocol;
                            obj.search       = document.location.search;
                            obj.referrer     = document.referrer;
                            obj.title        = document.title;
                        
                        return obj;
                    }
                ]]>
         </script>;

        public function HTMLDOM(debug:DebugConfiguration)
        {
            super(debug);
            return;
        }// end function

        public function cacheProperties() : void
        {
            if (!isAvailable())
            {
                return;
            }
            var _loc_1:* = call(cache_properties_js);
            if (_loc_1)
            {
                this._host = _loc_1.host;
                this._language = _loc_1.language;
                this._characterSet = _loc_1.characterSet;
                this._colorDepth = _loc_1.colorDepth;
                this._location = _loc_1.location;
                this._pathname = _loc_1.pathname;
                this._protocol = _loc_1.protocol;
                this._search = _loc_1.search;
                this._referrer = _loc_1.referrer;
                this._title = _loc_1.title;
            }
            return;
        }// end function

        public function get host() : String
        {
            if (this._host)
            {
                return this._host;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._host = getProperty("document.location.host");
            return this._host;
        }// end function

        public function get language() : String
        {
            if (this._language)
            {
                return this._language;
            }
            if (!isAvailable())
            {
                return null;
            }
            var _loc_1:* = getProperty("navigator.language");
            if (_loc_1 == null)
            {
                _loc_1 = getProperty("navigator.browserLanguage");
            }
            this._language = _loc_1;
            return this._language;
        }// end function

        public function get characterSet() : String
        {
            if (this._characterSet)
            {
                return this._characterSet;
            }
            if (!isAvailable())
            {
                return null;
            }
            var _loc_1:* = getProperty("document.characterSet");
            if (_loc_1 == null)
            {
                _loc_1 = getProperty("document.charset");
            }
            this._characterSet = _loc_1;
            return this._characterSet;
        }// end function

        public function get colorDepth() : String
        {
            if (this._colorDepth)
            {
                return this._colorDepth;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._colorDepth = getProperty("window.screen.colorDepth");
            return this._colorDepth;
        }// end function

        public function get location() : String
        {
            if (this._location)
            {
                return this._location;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._location = getPropertyString("document.location");
            return this._location;
        }// end function

        public function get pathname() : String
        {
            if (this._pathname)
            {
                return this._pathname;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._pathname = getProperty("document.location.pathname");
            return this._pathname;
        }// end function

        public function get protocol() : String
        {
            if (this._protocol)
            {
                return this._protocol;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._protocol = getProperty("document.location.protocol");
            return this._protocol;
        }// end function

        public function get search() : String
        {
            if (this._search)
            {
                return this._search;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._search = getProperty("document.location.search");
            return this._search;
        }// end function

        public function get referrer() : String
        {
            if (this._referrer)
            {
                return this._referrer;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._referrer = getProperty("document.referrer");
            return this._referrer;
        }// end function

        public function get title() : String
        {
            if (this._title)
            {
                return this._title;
            }
            if (!isAvailable())
            {
                return null;
            }
            this._title = getProperty("document.title");
            return this._title;
        }// end function

    }
}
