package com.smartfoxserver.v2.core
{
    import flash.events.*;

    public class BaseEvent extends Event
    {
        public var params:Object;

        public function BaseEvent(param1:String, param2:Object = null)
        {
            super(param1);
            this.params = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            return new BaseEvent(this.type, this.params);
        }// end function

        override public function toString() : String
        {
            return formatToString("BaseEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
        }// end function

    }
}
