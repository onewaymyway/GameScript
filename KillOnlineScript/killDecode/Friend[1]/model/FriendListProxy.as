package model
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import flash.events.*;
    import flash.net.*;
    import json.*;

    public class FriendListProxy extends EventDispatcher
    {
        private var facade:MyFacade;
        private var loader:URLLoader;
        public static var DATE_LOADED:String = "FriendListProxy_DataLoaded";
        public static var importFriends_LOADED:String = "FriendListProxy_importFriendsLoaded";
        public static var ThePage:int = 1;
        public static var MaxPage:int = 1;
        public static var T:int = 0;
        public static var Data:Object;

        public function FriendListProxy()
        {
            this.facade = MyFacade.getInstance();
            return;
        }// end function

        public function LoadData(P:int, t:int)
        {
            ThePage = P;
            T = t;
            if (this.loader)
            {
                this.loader.close();
            }
            this.loader = new URLLoader();
            var _loc_3:* = new URLVariables();
            _loc_3.userid = UserData.UserInfo.UserId;
            _loc_3.u = MainData.LoginInfo.uservalues;
            _loc_3.p = P;
            _loc_3.t = String(T);
            var _loc_4:* = new URLRequest();
            _loc_4.url = "/User/Friend.ss";
            _loc_4.data = _loc_3;
            _loc_4.method = URLRequestMethod.GET;
            this.loader.load(_loc_4);
            this.loader.addEventListener(Event.COMPLETE, this.loaded);
            return;
        }// end function

        private function loaded(e) : void
        {
            var _loc_2:* = JSON.decode(e.target.data);
            Data = _loc_2;
            if (Data.count)
            {
            }
            if (Data.count < 1)
            {
                MaxPage = 1;
            }
            else
            {
                MaxPage = Math.ceil(Data.count / 11);
            }
            this.loader = null;
            dispatchEvent(new Event(DATE_LOADED));
            return;
        }// end function

        public function importFriends()
        {
            var _loc_1:* = new URLLoader();
            var _loc_2:* = new URLVariables();
            _loc_2.u = MainData.LoginInfo.uservalues;
            _loc_2.pf = MainData.LoginInfo.PF;
            var _loc_3:* = new URLRequest();
            _loc_3.url = "/User/ImportFriends.ss";
            _loc_3.data = _loc_2;
            _loc_1.load(_loc_3);
            _loc_1.addEventListener(Event.COMPLETE, this.importFriendsloaded);
            return;
        }// end function

        public function closeLoader() : void
        {
            if (this.loader)
            {
                this.loader.close();
            }
            return;
        }// end function

        private function importFriendsloaded(e) : void
        {
            var _loc_3:AlertVO = null;
            var _loc_2:* = JSON.decode(e.target.data);
            if (_loc_2.msg == "OK")
            {
                _loc_3 = new AlertVO();
                _loc_3.code = "";
                _loc_3.arr = null;
                if (int(_loc_2.num) > 0)
                {
                    _loc_3.msg = "本次成功导入 " + _loc_2.num + " 好友";
                }
                else
                {
                    _loc_3.msg = "没有导入新的好友";
                }
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            else
            {
                _loc_3 = new AlertVO();
                _loc_3.code = "";
                _loc_3.arr = null;
                _loc_3.msg = _loc_2.msg;
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            dispatchEvent(new Event(importFriends_LOADED));
            return;
        }// end function

        public function prve() : void
        {
            var _loc_2:* = ThePage - 1;
            ThePage = _loc_2;
            if (ThePage < 1)
            {
                ThePage = 1;
            }
            this.LoadData(ThePage, T);
            return;
        }// end function

        public function next() : void
        {
            var _loc_2:* = ThePage + 1;
            ThePage = _loc_2;
            if (ThePage >= MaxPage)
            {
                ThePage = MaxPage;
            }
            this.LoadData(ThePage, T);
            return;
        }// end function

        public function reFreshThePage() : void
        {
            this.LoadData(ThePage, T);
            return;
        }// end function

        public function reFreshfirstPage() : void
        {
            ThePage = 1;
            this.LoadData(ThePage, T);
            return;
        }// end function

    }
}
