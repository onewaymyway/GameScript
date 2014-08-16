package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmTeachNeedVerifyBox extends Object
    {
        private var thisObj:confirm_TeachVerify_box = null;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmTeachNeedVerifyBox(viewobj:Object, arr:Object = null)
        {
            t.objToString(arr);
            this.thisObj = new confirm_TeachVerify_box();
            this.facade = MyFacade.getInstance();
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.cancel_btn.addEventListener("click", this.okClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.Arr = arr;
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            if (this.Arr.Type == 1)
            {
                this.thisObj.msg_txt.htmlText = "<font color=\'#ff0000\'>[ <a href=\"event:" + arr.FromUserId + "\">" + arr.FromUserName + " </a> ]</font>拜你为师,是否接受？";
            }
            else
            {
                this.thisObj.msg_txt.htmlText = "<font color=\'#ff0000\'>[ <a href=\"event:" + arr.FromUserId + "\">" + arr.FromUserName + " </a> ]</font>收你为徒,是否接受？";
            }
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:* = new Object();
            _loc_2.ToUserId = String(this.Arr.FromUserId);
            _loc_2.Type = this.Arr.Type;
            if (event.currentTarget.name == "confirm_btn")
            {
                _loc_2.cmd = "TeachCmd_Accpet";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "cancel_btn")
            {
                _loc_2.cmd = "TeachCmd_Reject";
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
