package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;

    public class ConfirmDefBox extends Object
    {
        private var thisObj:confirm_box = null;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmDefBox(viewobj:Object, arr:Object = null)
        {
            this.thisObj = new confirm_box();
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
            this.thisObj.msg_txt.htmlText = arr.msg;
            if (arr.title)
            {
                this.thisObj.title_txt.text = arr.title;
            }
            else
            {
                this.thisObj.title_txt.text = "ÌבÊ¾";
            }
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            if (event.currentTarget.name == "confirm_btn")
            {
                if (this.Arr.code)
                {
                }
                if (this.Arr.code != "")
                {
                    this.facade.sendNotification(this.Arr.code, this.Arr);
                }
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
