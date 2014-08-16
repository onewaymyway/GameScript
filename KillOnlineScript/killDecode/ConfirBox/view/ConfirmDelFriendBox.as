package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmDelFriendBox extends Object
    {
        private var thisObj:confirm_delFriend_box = null;
        public var Arr:Object;
        private var Func:Object;
        private var facade:Object;

        public function ConfirmDelFriendBox(viewobj:Object, obj:Object = null)
        {
            this.thisObj = new confirm_delFriend_box();
            this.facade = MyFacade.getInstance();
            this.thisObj.confirm_btn.addEventListener("click", this.okClick);
            this.thisObj.cancel_btn.addEventListener("click", this.closelClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.addEventListener(TextEvent.LINK, this.linkHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.Arr = obj.arr;
            this.Func = obj.func;
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            this.thisObj.msg_txt.htmlText = obj.msg;
            this.thisObj.title_txt.mouseEnabled = false;
            if (obj.title)
            {
                this.thisObj.title_txt.text = obj.title;
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
                if (this.Func)
                {
                    this.Arr.Both = String(this.thisObj.isBoth_cb.selectData);
                    this.Func(this.Arr);
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
            if (event.text.indexOf("/") > -1)
            {
                OpenWin.open(event.text);
            }
            else
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, int(event.text));
            }
            return;
        }// end function

    }
}
