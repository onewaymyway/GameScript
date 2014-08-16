package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmRoomPasswordBox extends Object
    {
        private var thisObj:confirm_RoomPassword_box = null;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmRoomPasswordBox(viewobj:Object, arr:Object = null)
        {
            this.thisObj = new confirm_RoomPassword_box();
            this.facade = MyFacade.getInstance();
            this.thisObj.confirm2_btn.addEventListener("click", this.okClick);
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.Arr = arr;
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            var _loc_3:String = "";
            if (this.Arr.LineId)
            {
            }
            if (MainData.LoginInfo.Id != uint(this.Arr.LineId))
            {
                _loc_3 = MainData.getLineName(this.Arr.LineId) + "-";
            }
            this.thisObj.title_txt.htmlText = "<b>" + _loc_3 + RoomData.getRoomWhereName(this.Arr.RoomId) + " </b> 需要密码！";
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            trace("Passjoin");
            t.obj(this.Arr);
            if (event.currentTarget.name == "confirm_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "JoinRoom";
                _loc_2.RoomId = String(this.Arr.RoomId);
                _loc_2.Password = String(this.thisObj.password_txt.text);
                UserData.UserRoomPassword = String(this.thisObj.password_txt.text);
                if (this.Arr.UserId)
                {
                    _loc_2.UserId = String(this.Arr.UserId);
                }
                if (this.Arr.LineId)
                {
                    _loc_2.LineId = String(this.Arr.LineId);
                }
                trace("JoinRoomcmd");
                t.obj(_loc_2);
                this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在进房间..."});
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "confirm2_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "BreakInRoom";
                _loc_2.RoomId = String(this.Arr.RoomId);
                if (this.Arr.UserId)
                {
                    _loc_2.UserId = String(this.Arr.UserId);
                }
                if (this.Arr.LineId)
                {
                    _loc_2.LineId = String(this.Arr.LineId);
                }
                this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在进房间..."});
                trace("BreakInRoomcmd");
                t.obj(_loc_2);
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "cancel_btn")
            {
            }
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function closelClick(event:MouseEvent) : void
        {
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, int(event.text));
            return;
        }// end function

    }
}
