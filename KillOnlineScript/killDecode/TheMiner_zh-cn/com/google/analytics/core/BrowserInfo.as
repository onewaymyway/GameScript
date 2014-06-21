package com.google.analytics.core
{
    import com.google.analytics.utils.*;
    import com.google.analytics.v4.*;

    public class BrowserInfo extends Object
    {
        private var _config:Configuration;
        private var _info:Environment;

        public function BrowserInfo(config:Configuration, info:Environment)
        {
            this._config = config;
            this._info = info;
            return;
        }// end function

        public function get utmcs() : String
        {
            return this._info.languageEncoding;
        }// end function

        public function get utmsr() : String
        {
            return this._info.screenWidth + "x" + this._info.screenHeight;
        }// end function

        public function get utmsc() : String
        {
            return this._info.screenColorDepth + "-bit";
        }// end function

        public function get utmul() : String
        {
            return this._info.language.toLowerCase();
        }// end function

        public function get utmje() : String
        {
            return "0";
        }// end function

        public function get utmfl() : String
        {
            var _loc_1:Version = null;
            if (this._config.detectFlash)
            {
                _loc_1 = this._info.flashVersion;
                return _loc_1.major + "." + _loc_1.minor + " r" + _loc_1.build;
            }
            return "-";
        }// end function

        public function toVariables() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            _loc_1.utmcs = this.utmcs;
            _loc_1.utmsr = this.utmsr;
            _loc_1.utmsc = this.utmsc;
            _loc_1.utmul = this.utmul;
            _loc_1.utmje = this.utmje;
            _loc_1.utmfl = this.utmfl;
            return _loc_1;
        }// end function

        public function toURLString() : String
        {
            var _loc_1:* = this.toVariables();
            return _loc_1.toString();
        }// end function

    }
}
