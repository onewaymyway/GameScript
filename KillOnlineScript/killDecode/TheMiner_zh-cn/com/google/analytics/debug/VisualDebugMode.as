package com.google.analytics.debug
{

    public class VisualDebugMode extends Object
    {
        private var _name:String;
        private var _value:int;
        public static const basic:VisualDebugMode = new VisualDebugMode(0, "basic");
        public static const advanced:VisualDebugMode = new VisualDebugMode(1, "advanced");
        public static const geek:VisualDebugMode = new VisualDebugMode(2, "geek");

        public function VisualDebugMode(value:int = 0, name:String = "")
        {
            this._value = value;
            this._name = name;
            return;
        }// end function

        public function toString() : String
        {
            return this._name;
        }// end function

        public function valueOf() : int
        {
            return this._value;
        }// end function

    }
}
