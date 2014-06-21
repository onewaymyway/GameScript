package com.google.analytics.core
{
    import flash.net.*;
    import flash.utils.*;

    public class RequestObject extends Object
    {
        public var start:int;
        public var end:int;
        public var request:URLRequest;

        public function RequestObject(request:URLRequest)
        {
            this.start = getTimer();
            this.request = request;
            return;
        }// end function

        public function get duration() : int
        {
            if (!this.hasCompleted())
            {
                return 0;
            }
            return this.end - this.start;
        }// end function

        public function complete() : void
        {
            this.end = getTimer();
            return;
        }// end function

        public function hasCompleted() : Boolean
        {
            return this.end > 0;
        }// end function

        public function toString() : String
        {
            var _loc_1:Array = [];
            _loc_1.push("duration: " + this.duration + "ms");
            _loc_1.push("url: " + this.request.url);
            return "{ " + _loc_1.join(", ") + " }";
        }// end function

    }
}
