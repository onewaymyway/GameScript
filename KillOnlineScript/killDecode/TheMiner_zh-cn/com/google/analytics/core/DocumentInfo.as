package com.google.analytics.core
{
    import com.google.analytics.external.*;
    import com.google.analytics.utils.*;
    import com.google.analytics.v4.*;

    public class DocumentInfo extends Object
    {
        private var _config:Configuration;
        private var _info:Environment;
        private var _adSense:AdSenseGlobals;
        private var _pageURL:String;
        private var _utmr:String;

        public function DocumentInfo(config:Configuration, info:Environment, formatedReferrer:String, pageURL:String = null, adSense:AdSenseGlobals = null)
        {
            this._config = config;
            this._info = info;
            this._adSense = adSense;
            return;
        }// end function

        private function _generateHitId() : Number
        {
            var _loc_1:Number = NaN;
            if (this._adSense.hid)
            {
            }
            if (this._adSense.hid != "")
            {
                _loc_1 = Number(this._adSense.hid);
            }
            else
            {
                _loc_1 = Math.round(Math.random() * 2147483647);
                this._adSense.hid = String(_loc_1);
            }
            return _loc_1;
        }// end function

        private function _renderPageURL(pageURL:String = "") : String
        {
            var _loc_2:* = this._info.locationPath;
            var _loc_3:* = this._info.locationSearch;
            if (pageURL)
            {
            }
            if (pageURL == "")
            {
                pageURL = _loc_2 + unescape(_loc_3);
                if (pageURL == "")
                {
                    pageURL = "/";
                }
            }
            return pageURL;
        }// end function

        public function get utmdt() : String
        {
            return this._info.documentTitle;
        }// end function

        public function get utmhid() : String
        {
            return String(this._generateHitId());
        }// end function

        public function get utmr() : String
        {
            if (!this._utmr)
            {
                return "-";
            }
            return "";
        }// end function

        public function get utmp() : String
        {
            return this._renderPageURL(this._pageURL);
        }// end function

        public function toVariables() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            if (this._config.detectTitle)
            {
            }
            if (this.utmdt != "")
            {
                _loc_1.utmdt = this.utmdt;
            }
            _loc_1.utmhid = this.utmhid;
            _loc_1.utmr = "";
            _loc_1.utmp = this.utmp;
            return _loc_1;
        }// end function

        public function toURLString() : String
        {
            var _loc_1:* = this.toVariables();
            return _loc_1.toString();
        }// end function

    }
}
