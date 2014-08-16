package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmFriendVerifyBox extends Object
    {
        private var thisObj:confirm_FriendVerify_box = null;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmFriendVerifyBox(viewobj:Object, arr:Object = null)
        {
            t.objToString(arr);
            this.thisObj = new confirm_FriendVerify_box();
            this.facade = MyFacade.getInstance();
            this.thisObj.confirm2_btn.addEventListener("click", this.okClick);
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.cancel_btn.addEventListener("click", this.okClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.Arr = arr;
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            this.thisObj.msg_txt.htmlText = "<font color=\'#ff0000\'>[ <a href=\"event:" + arr.UserId + "\">" + arr.UserName + " </a> ]</font>想加你为好友，,你是否接受？";
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "confirm_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "FriendCmd_FriendAccept";
                _loc_2.UserId = String(this.Arr.UserId);
                _loc_2.UserName = this.Arr.UserName;
                _loc_2.Key = String(this.Arr.Key);
                _loc_2.AddEachOther = "false";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "confirm2_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "FriendCmd_FriendAccept";
                _loc_2.UserId = String(this.Arr.UserId);
                _loc_2.UserName = this.Arr.UserName;
                _loc_2.Key = String(this.Arr.Key);
                _loc_2.AddEachOther = "true";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "cancel_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "FriendCmd_FriendReject";
                _loc_2.UserId = String(this.Arr.UserId);
                _loc_2.Msg = "拒绝理由";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
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
