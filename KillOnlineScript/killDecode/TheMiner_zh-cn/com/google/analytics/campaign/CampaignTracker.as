package com.google.analytics.campaign
{
    import com.google.analytics.utils.*;

    public class CampaignTracker extends Object
    {
        public var id:String;
        public var source:String;
        public var clickId:String;
        public var name:String;
        public var medium:String;
        public var term:String;
        public var content:String;

        public function CampaignTracker(id:String = "", source:String = "", clickId:String = "", name:String = "", medium:String = "", term:String = "", content:String = "")
        {
            this.id = id;
            this.source = source;
            this.clickId = clickId;
            this.name = name;
            this.medium = medium;
            this.term = term;
            this.content = content;
            return;
        }// end function

        private function _addIfNotEmpty(arr:Array, field:String, value:String) : void
        {
            if (value != "")
            {
                value = value.split("+").join("%20");
                value = value.split(" ").join("%20");
                arr.push(field + value);
            }
            return;
        }// end function

        public function isValid() : Boolean
        {
            if (this.id == "")
            {
            }
            if (this.source == "")
            {
            }
            if (this.clickId != "")
            {
                return true;
            }
            return false;
        }// end function

        public function fromTrackerString(tracker:String) : void
        {
            var _loc_2:* = tracker.split(CampaignManager.trackingDelimiter).join("&");
            var _loc_3:* = new Variables(_loc_2);
            if (_loc_3.hasOwnProperty("utmcid"))
            {
                this.id = _loc_3["utmcid"];
            }
            if (_loc_3.hasOwnProperty("utmcsr"))
            {
                this.source = "-";
            }
            if (_loc_3.hasOwnProperty("utmccn"))
            {
                this.name = _loc_3["utmccn"];
            }
            if (_loc_3.hasOwnProperty("utmcmd"))
            {
                this.medium = _loc_3["utmcmd"];
            }
            if (_loc_3.hasOwnProperty("utmctr"))
            {
                this.term = _loc_3["utmctr"];
            }
            if (_loc_3.hasOwnProperty("utmcct"))
            {
                this.content = _loc_3["utmcct"];
            }
            if (_loc_3.hasOwnProperty("utmgclid"))
            {
                this.clickId = _loc_3["utmgclid"];
            }
            return;
        }// end function

        public function toTrackerString() : String
        {
            var _loc_1:Array = [];
            this._addIfNotEmpty(_loc_1, "utmcid=", this.id);
            this._addIfNotEmpty(_loc_1, "utmcsr=", "-");
            this._addIfNotEmpty(_loc_1, "utmgclid=", this.clickId);
            this._addIfNotEmpty(_loc_1, "utmccn=", this.name);
            this._addIfNotEmpty(_loc_1, "utmcmd=", this.medium);
            this._addIfNotEmpty(_loc_1, "utmctr=", this.term);
            this._addIfNotEmpty(_loc_1, "utmcct=", this.content);
            return _loc_1.join(CampaignManager.trackingDelimiter);
        }// end function

    }
}
