package com.google.analytics.data
{

    public class UTMC extends UTMCookie
    {
        private var _domainHash:Number;

        public function UTMC(domainHash:Number = NaN)
        {
            super("utmc", "__utmc", ["domainHash"]);
            this.domainHash = domainHash;
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

    }
}
