package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;

    public class ConfirmAddWeddingBox extends Sprite
    {
        private var thisObj:confirm_AddWedding_box = null;
        private var funcObj:Object;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmAddWeddingBox(viewobj:Object, arr:Object = null)
        {
            this.facade = MyFacade.getInstance();
            this.thisObj = new confirm_AddWedding_box();
            this.Arr = arr;
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.close2_btn.addEventListener("click", this.closelClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.input_txt.addEventListener(FocusEvent.FOCUS_IN, this.focusEventINHandler);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            this.thisObj.pname_txt.htmlText = "<b><a href=\"event:" + this.Arr.ToUserId + "\">" + this.Arr.ToUserName + " </a></b>";
            this.thisObj.input_txt.htmlText = "<font color=\'#CCCCCC\'>请输入你要表达的文字</font>";
            this.setRingType(this.Arr.ToolId);
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "confirm_btn")
            {
                if (this.thisObj.input_txt.text == "请输入你要表达的文字")
                {
                    this.thisObj.input_txt.text = "";
                }
                _loc_2 = new Object();
                _loc_2.cmd = "MarryCmd_Propose";
                _loc_2.ToolId = String(this.Arr.ToolId);
                _loc_2.ToUserId = String(this.Arr.ToUserId);
                _loc_2.Say = String(this.thisObj.input_txt.text);
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

        private function focusEventINHandler(event:Event) : void
        {
            if (this.thisObj.input_txt.text == "请输入你要表达的文字")
            {
                this.thisObj.input_txt.text = "";
            }
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
