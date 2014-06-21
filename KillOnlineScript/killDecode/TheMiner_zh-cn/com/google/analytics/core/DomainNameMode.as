package com.google.analytics.core
{

    public class DomainNameMode extends Object
    {
        private var _value:int;
        private var _name:String;
        public static const none:DomainNameMode = new DomainNameMode(0, "none");
        public static const auto:DomainNameMode = new DomainNameMode(1, "auto");
        public static const custom:DomainNameMode = new DomainNameMode(2, "custom");

        public function DomainNameMode(value:int = 0, name:String = "")
        {
            this._value = value;
            this._name = name;
            return;
        }// end function

        public function valueOf() : int
        {
            return this._value;
        }// end function

        public function toString() : String
        {
            return this._name;
        }// end function

    }
}
