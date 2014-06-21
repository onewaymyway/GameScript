package uas
{
    import flash.events.*;
    import flash.net.*;

    public class LoadVarsURL extends EventDispatcher
    {
        private var getdata:Object;

        public function LoadVarsURL()
        {
            return;
        }// end function

        public function LoadURL()
        {
            return;
        }// end function

        public function load(param1:String, param2:URLVariables) : void
        {
            var _loc_3:* = new URLLoader();
            var _loc_4:* = new URLRequest();
            new URLRequest().url = param1;
            _loc_4.data = param2;
            _loc_3.load(_loc_4);
            _loc_3.addEventListener(Event.COMPLETE, this.completeHandler);
            _loc_3.addEventListener(IOErrorEvent.IO_ERROR, this.errHandler);
            _loc_3.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.err2Handler);
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

    }
}
