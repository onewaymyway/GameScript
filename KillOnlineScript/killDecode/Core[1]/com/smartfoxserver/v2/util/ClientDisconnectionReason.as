package com.smartfoxserver.v2.util
{

    public class ClientDisconnectionReason extends Object
    {
        public static const IDLE:String = "idle";
        public static const KICK:String = "kick";
        public static const BAN:String = "ban";
        public static const MANUAL:String = "manual";
        public static const UNKNOWN:String = "unknown";
        private static var reasons:Array = ["idle", "kick", "ban"];

        public function ClientDisconnectionReason()
        {
            return;
        }// end function

        public static function getReason(param1:int) : String
        {
            return reasons[param1];
        }// end function

    }
}
