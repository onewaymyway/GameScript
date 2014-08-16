package taskbox.model
{
    import Core.model.data.*;
    import flash.events.*;
    import flash.utils.*;
    import json.*;
    import uas.*;

    public class SetProxy extends EventDispatcher
    {
        public var data:Object;
        public static var DATE_LOADED:String = "DATE_LOADED";
        public static var DATE_LOADErr:String = "DATE_LOADErr";

        public function SetProxy()
        {
            return;
        }// end function

        public function LoadData(url:String)
        {
            var _loc_2:* = new LoadURL();
            _loc_2.load(url + "&u=" + escapeMultiByte(MainData.LoginInfo.uservalues));
            _loc_2.addEventListener(Event.COMPLETE, this.urlLoaded);
            _loc_2.addEventListener(ErrorEvent.ERROR, this.urlLoadedErr);
            return;
        }// end function

        private function urlLoaded(event:Event) : void
        {
            var sdata:String;
            var r:RegExp;
            var e:* = event;
            try
            {
                sdata = e.target.data;
                r = /\n|\r/g;
                sdata = sdata.split(r).join("");
                this.data = JSON.decode(sdata);
                dispatchEvent(new Event(DATE_LOADED));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            return;
        }// end function

        private function urlLoadedErr(event:Event) : void
        {
            trace("LoadedErr");
            dispatchEvent(new Event(DATE_LOADErr));
            return;
        }// end function

    }
}
