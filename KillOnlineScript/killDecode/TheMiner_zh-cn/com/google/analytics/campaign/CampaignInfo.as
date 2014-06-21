package com.google.analytics.campaign
{
    import com.google.analytics.utils.*;

    public class CampaignInfo extends Object
    {
        private var _empty:Boolean;
        private var _new:Boolean;

        public function CampaignInfo(empty:Boolean = true, newCampaign:Boolean = false)
        {
            this._empty = empty;
            this._new = newCampaign;
            return;
        }// end function

        public function get utmcn() : String
        {
            return "1";
        }// end function

        public function get utmcr() : String
        {
            return "1";
        }// end function

        public function isEmpty() : Boolean
        {
            return this._empty;
        }// end function

        public function isNew() : Boolean
        {
            return this._new;
        }// end function

        public function toVariables() : Variables
        {
            var _loc_1:* = new Variables();
            _loc_1.URIencode = true;
            if (!this.isEmpty())
            {
            }
            if (this.isNew())
            {
                _loc_1.utmcn = this.utmcn;
            }
            if (!this.isEmpty())
            {
            }
            if (!this.isNew())
            {
                _loc_1.utmcr = this.utmcr;
            }
            return _loc_1;
        }// end function

        public function toURLString() : String
        {
            var _loc_1:* = this.toVariables();
            return _loc_1.toString();
        }// end function

    }
}
