package controller
{
    import Core.*;
    import Core.model.data.*;
    import flash.events.*;
    import uas.*;

    public class KillerRoomUserBoxController extends Object
    {
        public var theViewer:RoomUser_box;
        private var loadFaceUrl:String = "";
        private var facade:Object;

        public function KillerRoomUserBoxController(param1:RoomUser_box)
        {
            this.theViewer = param1;
            this.facade = MyFacade.getInstance();
            this.theViewer.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStagehandler);
            this.theViewer.show_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.lb_mc.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.lb_mc.buttonMode = true;
            this.theViewer.lb_mc.useHandCursor = true;
            this.theViewer.lb_mc.gotoAndStop(1);
            this.theViewer.x = 5;
            this.theViewer.y = 25;
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            this.init();
            return;
        }// end function

        private function removeStagehandler(event:Event) : void
        {
            return;
        }// end function

        public function init() : void
        {
            this.theViewer.player_info.visible = false;
            this.theViewer.userName_txt.text = UserData.UserInfo.UserName;
            if (this.theViewer.headPic_mc)
            {
                this.loadUserFace(UserData.UserInfo.UserFace);
            }
            if (MainData.UserMsg_LB)
            {
                this.theViewer.lb_mc.gotoAndStop(2);
            }
            else
            {
                this.theViewer.lb_mc.gotoAndStop(1);
            }
            return;
        }// end function

        private function btnHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            switch(event.currentTarget.name)
            {
                case "show_btn":
                {
                    if (this.theViewer.player_info.visible)
                    {
                        this.theViewer.parent.setChildIndex(this.theViewer, 1);
                        this.theViewer.player_info.visible = false;
                    }
                    else
                    {
                        this.theViewer.parent.setChildIndex(this.theViewer, (this.theViewer.parent.numChildren - 1));
                        this.theViewer.player_info.visible = true;
                        this.reUserInfo();
                    }
                    break;
                }
                case "lb_mc":
                {
                    _loc_2 = UserData.UserMsgs.shift();
                    if (UserData.UserMsgs.length == 0)
                    {
                        MainData.UserMsg_LB = false;
                        this.theViewer.lb_mc.gotoAndStop(1);
                    }
                    this.facade.sendNotification(_loc_2.code, _loc_2.data);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function showLb() : void
        {
            this.theViewer.lb_mc.gotoAndStop(2);
            return;
        }// end function

        public function reUserInfo() : void
        {
            if (this.loadFaceUrl != UserData.UserInfo.UserFace && this.theViewer.headPic_mc)
            {
                this.loadUserFace(UserData.UserInfo.UserFace);
                this.loadFaceUrl = UserData.UserInfo.UserFace;
            }
            this.theViewer.userName_txt.htmlText = UserData.UserInfo.UserName;
            this.theViewer.player_info.theIntegral_txt.text = String(UserData.UserInfo.Integral);
            this.theViewer.player_info.theWinP_txt.text = int(int(UserData.UserInfo.Wintimes) / (int(UserData.UserInfo.Wintimes) + int(UserData.UserInfo.Losttimes)) * 100) + "%";
            this.theViewer.player_info.theEXP_txt.text = String(UserData.UserInfo.EXP);
            this.theViewer.player_info.gold_txt.text = String(UserData.UserInfo.Money);
            return;
        }// end function

        private function loaderErrHandler(event:Event) : void
        {
            return;
        }// end function

        private function loadUserFace(param1:String) : void
        {
            var _loc_2:* = new LoadPic();
            _loc_2.addEventListener(LoadPic.COMPLETE, this.completeloadUserFaceHandler);
            _loc_2.load(param1);
            return;
        }// end function

        private function completeloadUserFaceHandler(event:Event) : void
        {
            var _loc_2:* = event.target.data;
            mcFunc.removeAllMc(this.theViewer.headPic_mc.pic_mc);
            _loc_2.width = 80;
            _loc_2.scaleY = _loc_2.scaleX;
            this.theViewer.headPic_mc.pic_mc.addChild(_loc_2);
            return;
        }// end function

    }
}
