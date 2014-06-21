package com.google.analytics.data
{
    import com.google.analytics.utils.*;

    public class UTMB extends UTMCookie
    {
        private var _domainHash:Number;
        private var _trackCount:Number;
        private var _token:Number;
        private var _lastTime:Number;
        public static var defaultTimespan:Number = Timespan.thirtyminutes;

        public function UTMB(domainHash:Number = NaN, trackCount:Number = NaN, token:Number = NaN, lastTime:Number = NaN)
        {
            super("utmb", "__utmb", ["domainHash", "trackCount", "token", "lastTime"], defaultTimespan * 1000);
            this.domainHash = domainHash;
            this.trackCount = trackCount;
            this.token = token;
            this.lastTime = lastTime;
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

        public function get trackCount() : Number
        {
            return this._trackCount;
        }// end function

        public function set trackCount(value:Number) : void
        {
            this._trackCount = value;
            update();
            return;
        }// end function

        public function get token() : Number
        {
            return this._token;
        }// end function

        public function set token(value:Number) : void
        {
            this._token = value;
            update();
            return;
        }// end function

        public function get lastTime() : Number
        {
            return this._lastTime;
        }// end function

        public function set lastTime(value:Number) : void
        {
            this._lastTime = value;
            update();
            return;
        }// end function

    }
}
