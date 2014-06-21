﻿package com.smartfoxserver.v2.logging
{
    import com.smartfoxserver.v2.core.*;
    import flash.events.*;

    public class LoggerEvent extends BaseEvent
    {
        public static const DEBUG:String = "debug";
        public static const INFO:String = "info";
        public static const WARNING:String = "warn";
        public static const ERROR:String = "error";

        public function LoggerEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

        override public function clone() : Event
        {
            return new LoggerEvent(this.type, this.params);
        }// end function

        override public function toString() : String
        {
            return formatToString("LoggerEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
        }// end function

    }
}
