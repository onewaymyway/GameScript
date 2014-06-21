package com.google.analytics.data
{

    public class UTMX extends UTMCookie
    {
        private var _value:String;

        public function UTMX()
        {
            super("utmx", "__utmx", ["value"], 0);
            this._value = "-";
            return;
        }// end function

        public function get value() : String
        {
            return this._value;
        }// end function

        public function set value(value:String) : void
        {
            this._value = value;
            return;
        }// end function

    }
}
