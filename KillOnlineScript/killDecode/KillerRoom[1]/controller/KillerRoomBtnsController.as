package controller
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.events.*;
    import model.*;
    import roomEvents.*;
    import view.*;

    public class KillerRoomBtnsController extends Object
    {
        private var facade:Object;
        public var theViewer:killerRoom_btns;

        public function KillerRoomBtnsController(param1:killerRoom_btns)
        {
            this.theViewer = param1;
            this.facade = MyFacade.getInstance();
            this.theViewer.kickhost_mc.kick_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.kickhost_mc.nokick_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.ready_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.noready_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.start_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.set_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.pList_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.fas_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.tools_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            if (this.theViewer.gotoShop_btn)
            {
                this.theViewer.gotoShop_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            }
            if (this.theViewer.QgotoShop_btn)
            {
                this.theViewer.QgotoShop_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            }
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.init);
            this.theViewer.ready_btn.visible = true;
            this.theViewer.noready_btn.visible = false;
            this.theViewer.start_btn.visible = false;
            this.theViewer.set_btn.visible = false;
            this.theViewer.userIdentity_mc.visible = false;
            this.theViewer.kickhost_mc.movie_mc.gotoAndPlay(1);
            this.startBtnEnabled = false;
            this.theViewer.x = MainData.MainStage.stageWidth;
            this.theViewer.y = MainData.MainStage.stageHeight;
            MainView.ALT.setAlt(this.theViewer.userIdentity_mc.mayor_act_log, "否决本轮投票(1次)", 2);
            this.theViewer.userIdentity_mc.mayor_act_log.buttonMode = true;
            this.theViewer.userIdentity_mc.mayor_act_log.mouseEnabled = true;
            this.theViewer.userIdentity_mc.mayor_act_log.useHandCursor = true;
            this.theViewer.userIdentity_mc.mayor_act_log.addEventListener(MouseEvent.CLICK, this.mayorBtnhandler);
            this.setMayorBtn(3);
            return;
        }// end function

        private function init(event:Event) : void
        {
            return;
        }// end function

        public function set iden(param1:String) : void
        {
            this.setMayorBtn(3);
            this.theViewer.userIdentity_mc.y = -196 + int(Math.random() * 26);
            this.theViewer.userIdentity_mc.x = -95 + int(Math.random() * 5);
            this.theViewer.userIdentity_mc.visible = true;
            this.theViewer.userIdentity_mc.gotoAndStop(KillerRoomData.GetKillIden(param1));
            this.theViewer.userIdentity_mc.iden_log.gotoAndPlay(2);
            return;
        }// end function

        public function setMayorBtn(param1:int) : void
        {
            if (this.theViewer.userIdentity_mc.mayor_act_log)
            {
                if (param1 == 3)
                {
                    this.theViewer.userIdentity_mc.mayor_act_log.visible = false;
                }
                else if (param1 == 0)
                {
                    KillerRoomData.firstGamePrompt("白天拥有一票否决权，使用后白天公决无效；\n被杀手阵营杀死，杀手阵营下个夜晚不能行动。");
                    this.theViewer.userIdentity_mc.mayor_act_log.visible = true;
                    this.theViewer.userIdentity_mc.mayor_act_log.gotoAndStop(1);
                }
                else if (param1 == 1)
                {
                    KillerRoomData.firstGamePrompt("使用否决权完成，等待倒计时结束");
                    this.theViewer.userIdentity_mc.mayor_act_log.visible = true;
                    this.theViewer.userIdentity_mc.mayor_act_log.gotoAndStop(2);
                }
            }
            return;
        }// end function

        private function mayorBtnhandler(event:MouseEvent) : void
        {
            var _loc_2:* = this.theViewer.userIdentity_mc.mayor_act_log.currentFrame;
            var _loc_3:* = new Object();
            if (_loc_2 == 1)
            {
                _loc_3.cmd = "GameCmd_Act";
                _loc_3.Act = "MayorUnVote";
                _loc_3.unvote = "1";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_3);
            }
            else if (_loc_2 == 2)
            {
                _loc_3.cmd = "GameCmd_Act";
                _loc_3.Act = "MayorUnVote";
                _loc_3.unvote = "0";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_3);
            }
            return;
        }// end function

        public function set ready(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.ready_btn.visible = false;
                this.theViewer.noready_btn.visible = true;
            }
            else
            {
                this.theViewer.ready_btn.visible = true;
                this.theViewer.noready_btn.visible = false;
            }
            return;
        }// end function

        public function set readyBtnEnabled(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.ready_btn.mouseEnabled = true;
                this.theViewer.noready_btn.mouseEnabled = true;
                this.theViewer.ready_btn.alpha = 1;
                this.theViewer.noready_btn.alpha = 1;
            }
            else
            {
                this.theViewer.ready_btn.mouseEnabled = false;
                this.theViewer.noready_btn.mouseEnabled = false;
                this.theViewer.ready_btn.alpha = 0.5;
                this.theViewer.noready_btn.alpha = 0.5;
            }
            return;
        }// end function

        public function set setBtnEnabled(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.set_btn.mouseEnabled = true;
                this.theViewer.set_btn.alpha = 1;
            }
            else
            {
                this.theViewer.set_btn.mouseEnabled = false;
                this.theViewer.set_btn.alpha = 0.5;
            }
            return;
        }// end function

        public function set startBtnEnabled(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.start_btn.mouseEnabled = true;
                this.theViewer.start_btn.alpha = 1;
            }
            else
            {
                this.theViewer.start_btn.mouseEnabled = false;
                this.theViewer.start_btn.alpha = 0.5;
            }
            return;
        }// end function

        public function set kickHostBtnEnabled(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.kickhost_mc.kick_btn.visible = true;
                this.theViewer.kickhost_mc.nokick_btn.visible = true;
            }
            else
            {
                this.theViewer.kickhost_mc.kick_btn.visible = false;
                this.theViewer.kickhost_mc.nokick_btn.visible = false;
            }
            return;
        }// end function

        public function set startingBtns(param1:Boolean) : void
        {
            if (param1)
            {
                this.theViewer.start_btn.mouseEnabled = false;
                this.theViewer.start_btn.alpha = 0.5;
                this.theViewer.ready_btn.mouseEnabled = false;
                this.theViewer.noready_btn.mouseEnabled = false;
                this.theViewer.ready_btn.alpha = 0.5;
                this.theViewer.noready_btn.alpha = 0.5;
                this.theViewer.kickhost_mc.visible = false;
            }
            else
            {
                this.theViewer.start_btn.mouseEnabled = true;
                this.theViewer.start_btn.alpha = 1;
                this.theViewer.ready_btn.mouseEnabled = true;
                this.theViewer.noready_btn.mouseEnabled = true;
                this.theViewer.ready_btn.alpha = 1;
                this.theViewer.noready_btn.alpha = 1;
                this.theViewer.kickhost_mc.visible = true;
                this.theViewer.userIdentity_mc.visible = false;
            }
            return;
        }// end function

        public function set kickNum(param1:String) : void
        {
            if (param1 != "undefined")
            {
                this.theViewer.kickhost_mc.n1_txt.text = param1;
            }
            else
            {
                this.theViewer.kickhost_mc.n1_txt.text = "0";
            }
            return;
        }// end function

        public function set playerNum(param1:String) : void
        {
            if (param1 != "undefined")
            {
                this.theViewer.kickhost_mc.n2_txt.text = param1;
            }
            else
            {
                this.theViewer.kickhost_mc.n2_txt.text = "0";
            }
            return;
        }// end function

        public function kickHost() : void
        {
            if (KillerRoomData.UserHost == 0)
            {
                this.theViewer.kickhost_mc.n1_txt.text = 0;
                this.theViewer.kickhost_mc.kick_btn.visible = true;
                this.theViewer.kickhost_mc.nokick_btn.visible = false;
                this.theViewer.kickhost_mc.movie_mc.gotoAndPlay(2);
            }
            return;
        }// end function

        private function btnHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            switch(event.currentTarget.name)
            {
                case "kick_btn":
                {
                    this.theViewer.kickhost_mc.kick_btn.visible = false;
                    this.theViewer.kickhost_mc.nokick_btn.visible = true;
                    _loc_2 = new Object();
                    _loc_2.cmd = "KickMaster";
                    _loc_2.Cancel = "false";
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case "nokick_btn":
                {
                    this.theViewer.kickhost_mc.kick_btn.visible = true;
                    this.theViewer.kickhost_mc.nokick_btn.visible = false;
                    _loc_2 = new Object();
                    _loc_2.cmd = "KickMaster";
                    _loc_2.Cancel = "true";
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case "ready_btn":
                {
                    if (!KillerRoomData.isKillGameType)
                    {
                        if (!KillerRoomPlugGameMediator.game.canReady())
                        {
                            return;
                        }
                    }
                    this.ready = true;
                    _loc_2 = new Object();
                    _loc_2.cmd = "GameReady";
                    _loc_2.Cancel = "false";
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case "noready_btn":
                {
                    this.ready = false;
                    _loc_2 = new Object();
                    _loc_2.cmd = "GameReady";
                    _loc_2.Cancel = "true";
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case "start_btn":
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "GameCmd_Start";
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case "pList_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.PLAYERLIST_OPEN);
                    break;
                }
                case "fas_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.FriendPath, x:this.theViewer.stage.stageWidth - 300, y:this.theViewer.stage.stageHeight - 320});
                    break;
                }
                case "tools_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.TOOLSLIST_OPEN);
                    break;
                }
                case "gotoShop_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.PlugPath.MallPlusPath.url, x:0, y:0});
                    break;
                }
                case "QgotoShop_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.PlugPath.MallPlusPath.url, x:0, y:0});
                    break;
                }
                case "set_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.ROOMSET_OPEN);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function respReady(param1) : void
        {
            if (param1)
            {
                this.theViewer.ready_btn.visible = false;
                this.theViewer.noready_btn.visible = true;
            }
            else
            {
                this.theViewer.ready_btn.visible = true;
                this.theViewer.noready_btn.visible = false;
            }
            return;
        }// end function

    }
}
