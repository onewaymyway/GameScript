﻿package com.smartfoxserver.v2.requests
{

    public class MessageRecipientMode extends Object
    {
        private var _target:Object;
        private var _mode:int;
        public static const TO_USER:int = 0;
        public static const TO_ROOM:int = 1;
        public static const TO_GROUP:int = 2;
        public static const TO_ZONE:int = 3;

        public function MessageRecipientMode(param1:int, param2)
        {
            if (param1 < TO_USER || param1 > TO_ZONE)
            {
                throw new ArgumentError("Illegal recipient mode: " + param1);
            }
            this._mode = param1;
            this._target = param2;
            return;
        }// end function

        public function get mode() : int
        {
            return this._mode;
        }// end function

        public function get target()
        {
            return this._target;
        }// end function

    }
}
