package com.google.analytics.utils
{
    import com.google.analytics.core.*;
    import flash.system.*;

    public class UserAgent extends Object
    {
        private var _applicationProduct:String;
        private var _localInfo:Environment;
        private var _version:Version;
        public static var minimal:Boolean = false;

        public function UserAgent(localInfo:Environment, product:String = "", version:String = "")
        {
            this._localInfo = localInfo;
            this.applicationProduct = product;
            this._version = Version.fromString(version);
            return;
        }// end function

        public function get applicationComment() : String
        {
            var _loc_1:Array = [];
            _loc_1.push(this._localInfo.platform);
            _loc_1.push(this._localInfo.playerType);
            if (!UserAgent.minimal)
            {
                _loc_1.push(this._localInfo.operatingSystem);
                _loc_1.push(this._localInfo.language);
            }
            if (Capabilities.isDebugger)
            {
                _loc_1.push("DEBUG");
            }
            if (_loc_1.length > 0)
            {
                return "(" + _loc_1.join("; ") + ")";
            }
            return "";
        }// end function

        public function get applicationProduct() : String
        {
            return this._applicationProduct;
        }// end function

        public function set applicationProduct(value:String) : void
        {
            this._applicationProduct = value;
            return;
        }// end function

        public function get applicationProductToken() : String
        {
            var _loc_1:* = this.applicationProduct;
            if (this.applicationVersion != "")
            {
                _loc_1 = _loc_1 + ("/" + this.applicationVersion);
            }
            return _loc_1;
        }// end function

        public function get applicationVersion() : String
        {
            return this._version.toString(2);
        }// end function

        public function set applicationVersion(value:String) : void
        {
            this._version = Version.fromString(value);
            return;
        }// end function

        public function get tamarinProductToken() : String
        {
            if (UserAgent.minimal)
            {
                return "";
            }
            if (System.vmVersion)
            {
                return "Tamarin/" + Utils.trim(System.vmVersion, true);
            }
            return "";
        }// end function

        public function get vendorProductToken() : String
        {
            var _loc_1:String = "";
            if (this._localInfo.isAIR())
            {
                _loc_1 = _loc_1 + "AIR";
            }
            else
            {
                _loc_1 = _loc_1 + "FlashPlayer";
            }
            _loc_1 = _loc_1 + "/";
            _loc_1 = _loc_1 + this._version.toString(3);
            return _loc_1;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + this.applicationProductToken;
            if (this.applicationComment != "")
            {
                _loc_1 = _loc_1 + (" " + this.applicationComment);
            }
            if (this.tamarinProductToken != "")
            {
                _loc_1 = _loc_1 + (" " + this.tamarinProductToken);
            }
            if (this.vendorProductToken != "")
            {
                _loc_1 = _loc_1 + (" " + this.vendorProductToken);
            }
            return _loc_1;
        }// end function

    }
}
