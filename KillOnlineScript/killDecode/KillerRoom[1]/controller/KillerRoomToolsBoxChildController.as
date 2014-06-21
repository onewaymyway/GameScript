package controller
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import model.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomToolsBoxChildController extends Sprite
    {
        private var _tooldata:Object;
        public var theViewer:KillerRoom_tool_Listmc;
        private var parentController:KillerRoomToolsBoxContrller;
        public var arrI:uint;
        private var facade:MyFacade;

        public function KillerRoomToolsBoxChildController(param1:KillerRoom_tool_Listmc, param2:Object, param3:KillerRoomToolsBoxContrller)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = param1;
            this.parentController = param3;
            this.theViewer.btn_bg.visible = false;
            this.theViewer.add_btn.visible = false;
            this.theViewer.buttonMode = true;
            this.theViewer.useHandCursor = true;
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.addedStagehandler);
            this.theViewer.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            this.setTooldata(param2);
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            return;
        }// end function

        public function setTooldata(param1:Object) : void
        {
            var _loc_3:Vip_Log = null;
            this._tooldata = param1;
            if (KillerRoomData.beToolID == uint(this._tooldata.Id))
            {
                this.theViewer.btn_bg.visible = false;
                this.parentController.selectedChild = null;
            }
            else
            {
                this.parentController.selectedChild = null;
                this.theViewer.btn_bg.visible = false;
            }
            this.theViewer.txt_txt.text = this._tooldata.Name;
            if (this._tooldata.HToolName)
            {
                MainView.ALT.setAlt(this.theViewer.add_btn, "填充弹药", 1);
                this.theViewer.add_btn.visible = true;
                this.theViewer.num_txt.text = this._tooldata.HCount + "/" + this._tooldata.Num;
            }
            else
            {
                this.theViewer.add_btn.visible = false;
                this.theViewer.num_txt.text = this._tooldata.Num;
            }
            if (int(this._tooldata.Vip) > 0)
            {
                _loc_3 = new Vip_Log();
                _loc_3.gotoAndStop("vip" + int(this._tooldata.Vip));
                _loc_3.x = 32;
                _loc_3.y = 2;
                _loc_3.alpha = 0.7;
                this.theViewer.addChild(_loc_3);
            }
            mcFunc.removeAllMc(this.theViewer.pic_show);
            var _loc_2:* = new LoadPic();
            _loc_2.load(Resource.CDN + this._tooldata.Img, this.theViewer.pic_show);
            return;
        }// end function

        public function noSelect() : void
        {
            this.parentController.selectedChild = null;
            KillerRoomData.beToolID = 0;
            this.theViewer.btn_bg.visible = false;
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            if (event.target.name == "add_btn")
            {
                this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/SetHToolNumForm.swf", x:0, y:0, ToolId:this._tooldata.Id, ToolName:this._tooldata.Name, HToolId:this._tooldata.HToolId, HToolName:this._tooldata.HToolName});
                return;
            }
            if (int(UserData.UserInfo.Vip) < int(this._tooldata.Vip))
            {
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, {msg:"你的VIP等级不够,需要 VIP" + this._tooldata.Vip + " 等级以上"});
                return;
            }
            if (this.parentController.selectedChild == this)
            {
                this.noSelect();
            }
            else
            {
                if (this._tooldata.Id == 786 || this._tooldata.Id == 100786)
                {
                    this.facade.sendNotification(KillerRoomEvents.TOOLSACT_SET_SERIESSET, 0);
                }
                if (this.parentController.selectedChild)
                {
                    this.parentController.selectedChild.noSelect();
                }
                this.theViewer.btn_bg.visible = true;
                KillerRoomData.beToolID = uint(this._tooldata.Id);
                this.parentController.selectedChild = this;
            }
            return;
        }// end function

        public function reSet() : void
        {
            if (this._tooldata.HToolName)
            {
                this.theViewer.add_btn.visible = true;
                this.theViewer.num_txt.text = this._tooldata.HCount + "/" + this._tooldata.Num;
            }
            else
            {
                this.theViewer.add_btn.visible = false;
                this.theViewer.num_txt.text = this._tooldata.Num;
            }
            return;
        }// end function

        public function get Tid() : uint
        {
            return uint(this._tooldata.Id);
        }// end function

    }
}
