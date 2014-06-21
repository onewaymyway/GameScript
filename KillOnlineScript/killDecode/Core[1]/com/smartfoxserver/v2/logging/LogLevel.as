package com.smartfoxserver.v2.logging
{

    public class LogLevel extends Object
    {
        public static const DEBUG:int = 100;
        public static const INFO:int = 200;
        public static const WARN:int = 300;
        public static const ERROR:int = 400;

        public function LogLevel()
        {
            return;
        }// end function

        public static function fromString(param1:int) : String
        {
            var _loc_2:String = "Unknown";
            if (param1 == DEBUG)
            {
                _loc_2 = "DEBUG";
            }
            else if (param1 == INFO)
            {
                _loc_2 = "INFO";
            }
            else if (param1 == WARN)
            {
                _loc_2 = "WARN";
            }
            else if (param1 == ERROR)
            {
                _loc_2 = "ERROR";
            }
            return _loc_2;
        }// end function

    }
}
