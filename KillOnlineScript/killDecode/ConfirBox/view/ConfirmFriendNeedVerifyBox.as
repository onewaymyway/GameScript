package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmFriendNeedVerifyBox extends Object
    {
        private var thisObj:confirm_FriendNeedVerify_box = null;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmFriendNeedVerifyBox(viewobj:Object, arr:Object = null)
        {
            t.objToString(arr);
            this.thisObj = new confirm_FriendNeedVerify_box();
            this.facade = MyFacade.getInstance();
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.cancel_btn.addEventListener("click", this.closelClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.Arr = arr;
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            this.thisObj.msg_txt.htmlText = "你将添加<font color=\'#ff0000\'>[ <a href=\"event:" + arr.UserId + "\">" + arr.UserName + " </a> ]</font>为好友,对方需要验证";
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "confirm_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "FriendCmd_FriendVerify";
                _loc_2.Msg = "请加我为好友";
                _loc_2.UserId = String(this.Arr.UserId);
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
