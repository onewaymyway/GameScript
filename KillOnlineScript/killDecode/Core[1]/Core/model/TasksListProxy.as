package Core.model
{
    import Core.model.data.*;
    import flash.events.*;
    import flash.utils.*;
    import json.*;
    import uas.*;

    public class TasksListProxy extends EventDispatcher
    {
        public var upListdata:Object;
        public var dayListdata:Object;
        public var guideListdata:Object;
        private var loadI:int = 0;
        public static var LOADED_ALLLIST:String = "LOADED_ALLLIST";
        public static var LOADED_DAYLIST:String = "LOADED_DAYLIST";
        public static var LOADED_UPLIST:String = "LOADED_UPLIST";
        public static var LOADED_GuideLIST:String = "LOADED_GuideLIST";
        public static var DATE_LOADErr:String = "DataLoadErr";

        public function TasksListProxy()
        {
            return;
        }// end function

        public function LoadAll(param1:Boolean = false) : void
        {
            this.loadI = 0;
            if (param1)
            {
                this.LoadUpListData();
                this.LoadDayListData();
                this.LoadGuideListData();
                return;
            }
            if (this.upListdata == null)
            {
                this.LoadUpListData();
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this.loadI + 1;
                _loc_2.loadI = _loc_3;
            }
            if (this.dayListdata == null)
            {
                this.LoadDayListData();
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this.loadI + 1;
                _loc_2.loadI = _loc_3;
            }
            if (this.guideListdata == null)
            {
                this.LoadGuideListData();
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this.loadI + 1;
                _loc_2.loadI = _loc_3;
            }
            if (this.loadI == 3)
            {
                dispatchEvent(new Event(LOADED_ALLLIST));
            }
            return;
        }// end function

        public function isHasNewDayTask() : Boolean
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.dayListdata.taskInfo.length)
            {
                
                if (this.dayListdata.taskInfo[_loc_1].Status == 1 || this.dayListdata.taskInfo[_loc_1].Status == 3)
                {
                    return true;
                }
                _loc_1 = _loc_1 + 1;
            }
            return false;
        }// end function

        public function isHasNewUpTask() : Boolean
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.upListdata.taskInfo.length)
            {
                
                if (this.upListdata.taskInfo[_loc_1].Status == 1 || this.upListdata.taskInfo[_loc_1].Status == 3)
                {
                    return true;
                }
                _loc_1 = _loc_1 + 1;
            }
            return false;
        }// end function

        public function isHasNewguideTask() : Boolean
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.guideListdata.taskInfo.length)
            {
                
                if (this.guideListdata.taskInfo[_loc_1].Status == 1 || this.guideListdata.taskInfo[_loc_1].Status == 0)
                {
                    return true;
                }
                _loc_1 = _loc_1 + 1;
            }
            return false;
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
                r = /\
n|\r""\n|\r/g;
                sdata = sdata.split(r).join("");
                this.dayListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_DAYLIST));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            var _loc_3:String = this;
            var _loc_4:* = this.loadI + 1;
            _loc_3.loadI = _loc_4;
            if (this.loadI == 3)
            {
                dispatchEvent(new Event(LOADED_ALLLIST));
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
                r = /\
n|\r""\n|\r/g;
                sdata = sdata.split(r).join("");
                this.upListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_UPLIST));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            var _loc_3:String = this;
            var _loc_4:* = this.loadI + 1;
            _loc_3.loadI = _loc_4;
            if (this.loadI == 3)
            {
                dispatchEvent(new Event(LOADED_ALLLIST));
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
                r = /\
n|\r""\n|\r/g;
                sdata = sdata.split(r).join("");
                this.guideListdata = JSON.decode(sdata);
                dispatchEvent(new Event(LOADED_GuideLIST));
            }
            catch (e)
            {
                trace("urlLoadedcatch:" + e);
                dispatchEvent(new Event(DATE_LOADErr));
            }
            var _loc_3:String = this;
            var _loc_4:* = this.loadI + 1;
            _loc_3.loadI = _loc_4;
            if (this.loadI == 3)
            {
                dispatchEvent(new Event(LOADED_ALLLIST));
            }
            return;
        }// end function

        private function urlLoadedErr(event:Event) : void
        {
            trace("LoadedErr");
            dispatchEvent(new Event(DATE_LOADErr));
            var _loc_2:String = this;
            var _loc_3:* = this.loadI + 1;
            _loc_2.loadI = _loc_3;
            if (this.loadI == 3)
            {
                dispatchEvent(new Event(LOADED_ALLLIST));
            }
            return;
        }// end function

    }
}
