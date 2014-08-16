package confirmbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class FlaConfirmCallGameBox extends Sprite
    {
        public var drag_mc:MovieClip;
        public var Arr:Object;
        public var msg_txt:TextField;
        private var funcObj:Object;
        public var close_btn:SimpleButton;
        public var cancel_btn:SimpleButton;
        private var thisObj:Object;
        private var facade:Object;
        public var confirm_btn:SimpleButton;

        public function FlaConfirmCallGameBox()
        {
            thisObj = this;
            facade = MyFacade.getInstance();
            confirm_btn.addEventListener("click", okClick);
            cancel_btn.addEventListener("click", CloselClick);
            close_btn.addEventListener("click", CloselClick);
            addEventListener(TextEvent.LINK, linkHandler);
            return;
        }// end function

        private function CloselClick(event:MouseEvent)
        {
            Sprite(parent).removeChild(thisObj);
            return;
        }// end function

        private function okClick(event:MouseEvent)
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "confirm_btn")
            {
                facade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在进房间..."});
                _loc_2 = new CallCmdVO();
                _loc_2.arg = [Arr.arr.WhereArea, Arr.arr.WhereRoom, UserVO.UserInfo.UserID, ""];
                _loc_2.code = "chkRoom";
                _loc_2.resp = new Responder(roomChkRes);
                facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            Sprite(parent).removeChild(thisObj);
            return;
        }// end function

        private function roomChkRes(param1:Object) : void
        {
            var _loc_2:* = new AlertVO();
            if (!param1.ok)
            {
                _loc_2.msg = param1.msg;
                if (param1.msg == "密码不正确")
                {
                }
                else if (param1.msg == "confirm")
                {
                }
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            else
            {
                facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.KillerRoomPath);
            }
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, int(event.text));
            return;
        }// end function

        public function show(param1)
        {
            this.x = stage.stageWidth / 2;
            this.y = stage.stageHeight / 2;
            Arr = param1;
            msg_txt.htmlText = param1.msg;
            return;
        }// end function

    }
}
