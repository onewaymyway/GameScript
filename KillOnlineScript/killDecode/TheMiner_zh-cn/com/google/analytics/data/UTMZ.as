package com.google.analytics.data
{
    import com.google.analytics.utils.*;

    public class UTMZ extends UTMCookie
    {
        private var _domainHash:Number;
        private var _campaignCreation:Number;
        private var _campaignSessions:Number;
        private var _responseCount:Number;
        private var _campaignTracking:String;
        public static var defaultTimespan:Number = Timespan.sixmonths;

        public function UTMZ(domainHash:Number = NaN, campaignCreation:Number = NaN, campaignSessions:Number = NaN, responseCount:Number = NaN, campaignTracking:String = "")
        {
            super("utmz", "__utmz", ["domainHash", "campaignCreation", "campaignSessions", "responseCount", "campaignTracking"], defaultTimespan * 1000);
            this.domainHash = domainHash;
            this.campaignCreation = campaignCreation;
            this.campaignSessions = campaignSessions;
            this.responseCount = responseCount;
            this.campaignTracking = campaignTracking;
            return;
        }// end function

        public function get domainHash() : Number
        {
            return this._domainHash;
        }// end function

        public function set domainHash(value:Number) : void
        {
            this._domainHash = value;
            update();
            return;
        }// end function

        public function get campaignCreation() : Number
        {
            return this._campaignCreation;
        }// end function

        public function set campaignCreation(value:Number) : void
        {
            this._campaignCreation = value;
            update();
            return;
        }// end function

        public function get campaignSessions() : Number
        {
            return this._campaignSessions;
        }// end function

        public function set campaignSessions(value:Number) : void
        {
            this._campaignSessions = value;
            update();
            return;
        }// end function

        public function get responseCount() : Number
        {
            return this._responseCount;
        }// end function

        public function set responseCount(value:Number) : void
        {
            this._responseCount = value;
            update();
            return;
        }// end function

        public function get campaignTracking() : String
        {
            return this._campaignTracking;
        }// end function

        public function set campaignTracking(value:String) : void
        {
            this._campaignTracking = value;
            update();
            return;
        }// end function

    }
}
