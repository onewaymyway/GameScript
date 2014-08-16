package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import mx.utils.*;

    public class ConfirmBriDayBox extends Sprite
    {
        private var thisObj:confirm_Birthdaycake_box = null;
        private var funcObj:Object;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmBriDayBox(viewobj:Object, arr:Object = null)
        {
            this.thisObj = new confirm_Birthdaycake_box();
            this.Arr = arr;
            this.facade = MyFacade.getInstance();
            this.thisObj.ok_btn.addEventListener("click", this.okClick);
            this.thisObj.close2_btn.addEventListener("click", this.okClick);
            this.thisObj.close_btn.addEventListener("click", this.CloselClick);
            this.thisObj.msg_txt.addEventListener(Event.CHANGE, this.txtChangeHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "ok_btn")
            {
                _loc_2 = new Object();
                _loc_2.ToolId = String(this.Arr.TID);
                _loc_2.UserId = String(this.Arr.PIP);
                _loc_2.Say = String(this.thisObj.msg_txt.text);
                _loc_2.cmd = "UseTool";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.currentTarget.name == "cancel_btn")
            {
            }
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function CloselClick(event:MouseEvent) : void
        {
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function txtChangeHandler(event:Event) : void
        {
            this.thisObj.msg_txt.text = StringUtil.trim(this.thisObj.msg_txt.text);
            return;
        }// end function

    }
}
