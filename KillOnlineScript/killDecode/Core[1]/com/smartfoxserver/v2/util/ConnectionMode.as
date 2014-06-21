package com.smartfoxserver.v2.util
{

    public class ConnectionMode extends Object
    {
        public static const SOCKET:String = "socket";
        public static const HTTP:String = "http";

        public function ConnectionMode()
        {
            throw new ArgumentError("The ConnectionMode class has no constructor!");
        }// end function

    }
}
