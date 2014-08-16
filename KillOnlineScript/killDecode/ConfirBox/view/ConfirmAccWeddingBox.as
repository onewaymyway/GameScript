package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;

    public class ConfirmAccWeddingBox extends Sprite
    {
        private var thisObj:confirm_AccWedding_box = null;
        private var funcObj:Object;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmAccWeddingBox(viewobj:Object, arr:Object = null)
        {
            this.facade = MyFacade.getInstance();
            this.thisObj = new confirm_AccWedding_box();
            this.Arr = arr;
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            this.thisObj.accept_btn.addEventListener("click", this.okClick);
            this.thisObj.reject_btn.addEventListener("click", this.okClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            this.thisObj.pname_txt.htmlText = "<b><a href=\"event:" + this.Arr.FromUserId + "\">" + this.Arr.FromUserName + " </a></b>";
            this.thisObj.msg_txt.htmlText = String(this.Arr.Say);
            this.setRingType(this.Arr.ToolId);
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "accept_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "MarryCmd_Appect";
                _loc_2.ToolId = String(this.Arr.ToolId);
                _loc_2.FromUserId = String(this.Arr.FromUserId);
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "reject_btn")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "MarryCmd_Reject";
                _loc_2.FromUserId = String(this.Arr.FromUserId);
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
            this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, int(this.thisObj.linkEvent.text));
            return;
        }// end function

        private function setRingType(TID:uint) : void
        {
            if (TID == 726)
            {
                this.thisObj.marrytype_mc.gotoAndStop(("type" + 1));
            }
            else if (TID == 727)
            {
                this.thisObj.marrytype_mc.gotoAndStop("type" + 2);
            }
            else if (TID == 728)
            {
                this.thisObj.marrytype_mc.gotoAndStop("type" + 3);
            }
            else
            {
                this.thisObj.marrytype_mc.gotoAndStop("type" + 0);
            }
            return;
        }// end function

    }
}
