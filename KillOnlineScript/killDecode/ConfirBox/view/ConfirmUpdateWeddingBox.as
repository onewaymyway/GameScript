package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;

    public class ConfirmUpdateWeddingBox extends Object
    {
        private var thisObj:confirm_marryUpdate_box;
        private var funcObj:Object;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmUpdateWeddingBox(viewobj:Object, arr:Object = null)
        {
            this.facade = MyFacade.getInstance();
            this.thisObj = new confirm_marryUpdate_box();
            this.Arr = arr;
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.thisObj.x = viewobj.stage.stageWidth / 2 - 150;
            this.thisObj.y = viewobj.stage.stageHeight / 2 - 150;
            this.thisObj.ok_btn.addEventListener("click", this.okClick);
            this.thisObj.close_btn.addEventListener("click", this.closelClick);
            this.thisObj.type1.visible = false;
            this.thisObj.type2.visible = false;
            this.thisObj.type3.visible = false;
            this.thisObj.type4.visible = false;
            this.thisObj.type5.visible = false;
            this.thisObj.type6.visible = false;
            this.setMarryType(this.Arr.marrytype);
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            if (event.currentTarget.name == "ok_btn")
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, {code:GameEvents.PlUSEVENT.CONFIRMBOX_ApplyUPDATAMARRY, msg:"您确定现在就开始升级戒指？", marryid:this.Arr.marryid, marrytype:this.Arr.marrytype});
            }
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function closelClick(event:MouseEvent) : void
        {
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function setMarryType(T:uint) : void
        {
            this.thisObj["type" + T].visible = true;
            return;
        }// end function

    }
}
