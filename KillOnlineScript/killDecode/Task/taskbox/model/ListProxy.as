package taskbox.model
{
    import Core.model.data.*;
    import flash.events.*;
    import flash.utils.*;
    import json.*;
    import uas.*;

    public class ListProxy extends EventDispatcher
    {
        public var upListdata:Object;
        public var dayListdata:Object;
        public var guideListdata:Object;
        public static var LOADED_DAYLIST:String = "LOADED_DAYLIST";
        public static var LOADED_UPLIST:String = "LOADED_UPLIST";
        public static var LOADED_GuideLIST:String = "LOADED_GuideLIST";
        public static var DATE_LOADErr:String = "DataLoadErr";

        public function ListProxy()
        {
            return;
        }// end function

        public function LoadDayListData()
        {
            var _loc_1:* = new LoadURL();
            var _loc_2:* = "/Task/GetDayList.ss?u=" + escapeMultiByte(MainData.LoginInfo.uservalues);
            _loc_1.load(_loc_2);
            _loc_1.addEventListener(Event.COMPLETE, this.DayListLoaded);
            _loc_1.addEventListener(ErrorEvent.ERROR, this.urlLoadedErr);
            return;
        }// end function

        private function DayListLoaded(event:Event) : void
        {
            var sdata:String;
            var r:RegExp;
            var e:* = event;
            try
            {
                sdata = e.target.data;
                r = /\n|\r/g;
                sdata = sdata.split(r).join("");
                this.dayListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_DAYLIST));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            return;
        }// end function

        public function LoadUpListData()
        {
            var _loc_1:* = new LoadURL();
            var _loc_2:* = "/Task/GetUpList.ss?u=" + escapeMultiByte(MainData.LoginInfo.uservalues);
            _loc_1.load(_loc_2);
            _loc_1.addEventListener(Event.COMPLETE, this.UpListLoaded);
            _loc_1.addEventListener(ErrorEvent.ERROR, this.urlLoadedErr);
            return;
        }// end function

        private function UpListLoaded(event:Event) : void
        {
            var sdata:String;
            var r:RegExp;
            var e:* = event;
            try
            {
                sdata = e.target.data;
                r = /\n|\r/g;
                sdata = sdata.split(r).join("");
                this.upListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_UPLIST));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            return;
        }// end function

        public function LoadGuideListData()
        {
            var _loc_1:* = new LoadURL();
            var _loc_2:* = "/Task/GetGuideList.ss?u=" + escapeMultiByte(MainData.LoginInfo.uservalues);
            _loc_1.load(_loc_2);
            _loc_1.addEventListener(Event.COMPLETE, this.GuideListLoaded);
            _loc_1.addEventListener(ErrorEvent.ERROR, this.urlLoadedErr);
            return;
        }// end function

        private function GuideListLoaded(event:Event) : void
        {
            var sdata:String;
            var r:RegExp;
            var e:* = event;
            try
            {
                sdata = e.target.data;
                r = /\n|\r/g;
                sdata = sdata.split(r).join("");
                this.guideListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_GuideLIST));
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
