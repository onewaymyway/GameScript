package taskbox.model
{
    import Core.model.data.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import json.*;

    public class WeiboShareProxy extends EventDispatcher
    {
        public var data:Object;
        public static var DATE_LOADED:String = "DataLoaded";
        public static var DATE_LOADErr:String = "DataLoadErr";

        public function WeiboShareProxy()
        {
            return;
        }// end function

        public function LoadWeb(url:String)
        {
            var _loc_2:* = new URLVariables();
            _loc_2.UV = escapeMultiByte(MainData.LoginInfo.uservalues);
            var _loc_3:* = new URLRequest();
            _loc_3.url = url;
            _loc_3.method = URLRequestMethod.POST;
            _loc_3.data = _loc_2;
            navigateToURL(_loc_3, "_blank");
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
