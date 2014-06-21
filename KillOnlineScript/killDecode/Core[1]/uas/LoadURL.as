package uas
{
    import flash.events.*;
    import flash.net.*;

    public class LoadURL extends EventDispatcher
    {
        private var getdata:Object;
        private var Note:String;
        public var Arg:Object;

        public function LoadURL()
        {
            return;
        }// end function

        public function load(param1:String, param2:String = "null", param3:Object = null) : void
        {
            trace("LoadURL" + param1);
            this.Arg = param3;
            this.Note = param2;
            var _loc_4:* = new URLLoader();
            new URLLoader().load(new URLRequest(param1));
            _loc_4.addEventListener(Event.COMPLETE, this.completeHandler);
            _loc_4.addEventListener(IOErrorEvent.IO_ERROR, this.errHandler);
            _loc_4.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.err2Handler);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            trace("COMP");
            this.getdata = event.target.data;
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        private function errHandler(event:ErrorEvent) : void
        {
            trace("ERR_IO");
            this.getdata = "连接错误";
            dispatchEvent(new Event(ErrorEvent.ERROR));
            return;
        }// end function

        private function err2Handler(event:ErrorEvent) : void
        {
            trace("ERR_SE");
            this.getdata = "安全沙箱问题";
            dispatchEvent(new Event(ErrorEvent.ERROR));
            return;
        }// end function

        public function get data()
        {
            return this.getdata;
        }// end function

        public function get note() : String
        {
            return this.Note;
        }// end function

    }
}
