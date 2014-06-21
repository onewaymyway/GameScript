package controller
{
    import Core.*;
    import Core.model.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.text.*;
    import flash.utils.*;
    import model.*;
    import roomEvents.*;

    public class KillerRoomMenuController extends Object
    {
        private var facade:MyFacade;
        private var timer:Timer;
        private var totalTime:uint = 0;
        private var goingTime:uint = 0;
        private var _soundObj:Object;
        private var sounder:SoundTransform;
        public var theViewer:killerroom_menu;
        public var aboutCount:String = "";

        public function KillerRoomMenuController(param1:killerroom_menu)
        {
            this.timer = new Timer(1000);
            this.theViewer = param1;
            this.facade = MyFacade.getInstance();
            this.timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this.theViewer.sound_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            if (this.theViewer.task_btn)
            {
                this.theViewer.task_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.gotoTurn_btn)
            {
                this.theViewer.gotoTurn_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.guessegg_btn)
            {
                this.theViewer.guessegg_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.guessprice_btn)
            {
                this.theViewer.guessprice_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.help_btn)
            {
                this.theViewer.help_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.pay_btn)
            {
                this.theViewer.pay_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.share_btn)
            {
                this.theViewer.share_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            if (this.theViewer.gotoTrade_btn)
            {
                this.theViewer.gotoTrade_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            }
            this.theViewer.back_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            this.theViewer.showSpeak_btn.laba_on_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            this.theViewer.showSpeak_btn.laba_off_btn.addEventListener(MouseEvent.CLICK, this.mouseHandler);
            this.theViewer.playerNum_mc.mouseChildren = false;
            this.theViewer.playerNum_mc.addEventListener(MouseEvent.MOUSE_OVER, this.playerNumHandler);
            this.theViewer.playerNum_mc.addEventListener(MouseEvent.MOUSE_OUT, this.playerNumHandler);
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.addedStagehandler);
            var _loc_2:* = new Rectangle(40, 40, 210, 40);
            this.theViewer.aboutPlayerNum_mc._bg.scale9Grid = _loc_2;
            if (UserData.UserInfo.firstlogin == 1)
            {
                this.theViewer.task_log.showIt(true);
                UserData.UserInfo.firstlogin = 0;
            }
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            MainView.ALT.setAlt(this.theViewer.isIp_mc, "本房间禁止相同IP进入", 4);
            this.theViewer.vul_txt.mouseEnabled = false;
            this.theViewer.aboutPlayerNum_mc.visible = false;
            this.sounder = new SoundTransform();
            return;
        }// end function

        public function go123() : void
        {
            return;
        }// end function

        public function set part(param1:String) : void
        {
            return;
        }// end function

        public function set isip(param1:Boolean) : void
        {
            this.theViewer.isIp_mc.visible = param1;
            return;
        }// end function

        public function set roomName(param1:String) : void
        {
            this.theViewer.roomName_txt.htmlText = param1;
            return;
        }// end function

        public function set laba(param1:String) : void
        {
            this.theViewer.menu_lb_txt.htmlText = param1;
            return;
        }// end function

        public function set soundObj(param1:Sprite) : void
        {
            this._soundObj = param1;
            if (this._soundObj.soundTransform.volume == 1)
            {
                this.theViewer.vul_txt.text = "静音";
                this.sounder.volume = 1;
            }
            else
            {
                this.theViewer.vul_txt.text = "音效";
                this.sounder.volume = 0;
                this.facade.sendNotification(KillerRoomEvents.SET_SOUND, this.sounder);
            }
            return;
        }// end function

        private function soundAct() : void
        {
            if (this._soundObj.soundTransform.volume == 1)
            {
                this.theViewer.vul_txt.text = "音效";
                this.sounder.volume = 0;
            }
            else
            {
                this.theViewer.vul_txt.text = "静音";
                this.sounder.volume = 1;
            }
            this._soundObj.soundTransform = this.sounder;
            this.facade.sendNotification(KillerRoomEvents.SET_SOUND, this.sounder);
            return;
        }// end function

        public function setSJPNum(param1:String, param2:String, param3:String) : void
        {
            if (param3 == "--")
            {
                this.theViewer.playerNum_mc.visible = false;
            }
            else
            {
                this.theViewer.playerNum_mc.visible = true;
                param1 = "杀 手 : " + param1;
                if (KillerRoomData.GameType == 15)
                {
                    param2 = "平 民 : " + param2;
                }
                else
                {
                    param2 = "警 察 : " + param2;
                }
                param3 = "剩余人数 : " + param3;
                this.theViewer.playerNum_mc.SNum_text.text = String(param1);
                this.theViewer.playerNum_mc.JNum_text.text = String(param2);
                this.theViewer.playerNum_mc.PNum_text.text = String(param3);
            }
            return;
        }// end function

        public function setTimer(param1:uint) : void
        {
            this.goingTime = param1;
            this.totalTime = param1;
            if (param1 > 0)
            {
                this.theViewer.timer_mc.timer_txt.text = String(this.goingTime);
                this.theViewer.timer_mc.gotoAndStop(1);
                this.timer.start();
            }
            else
            {
                this.theViewer.timer_mc.timer_txt.text = String("");
                this.theViewer.timer_mc.gotoAndStop(100);
            }
            return;
        }// end function

        public function stopTimer() : void
        {
            this.theViewer.timer_mc.timer_txt.text = "";
            this.theViewer.timer_mc.gotoAndStop(100);
            this.timer.stop();
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var _loc_3:String = this;
            var _loc_4:* = this.goingTime - 1;
            _loc_3.goingTime = _loc_4;
            this.theViewer.timer_mc.timer_txt.text = String(this.goingTime);
            var _loc_2:* = 100 - uint(this.goingTime / this.totalTime * 100);
            if (_loc_2 >= 100)
            {
                this.theViewer.timer_mc.timer_txt.text = "";
                this.timer.stop();
                if (!UserData.UserSO.data["iden" + UserData.UserPlayerIden])
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSEOFBTN, this.theViewer.timer_mc);
                }
            }
            this.theViewer.timer_mc.gotoAndStop(100 - uint(this.goingTime / this.totalTime * 100));
            return;
        }// end function

        public function showNewTaskLog(param1:Boolean) : void
        {
            this.theViewer.newTask_log.visible = param1;
            if (param1)
            {
                this.theViewer.newTask_log.gotoAndPlay(1);
            }
            else
            {
                this.theViewer.newTask_log.gotoAndStop(1);
            }
            return;
        }// end function

        public function checkNewTaskLog() : void
        {
            if (MainData.newUserTaskData.isNewUser)
            {
                return;
            }
            MainData.TaskListData.addEventListener(TasksListProxy.LOADED_ALLLIST, this.NewTaskLoaded);
            MainData.TaskListData.LoadAll();
            return;
        }// end function

        private function NewTaskLoaded(event:Event) : void
        {
            MainData.TaskListData.removeEventListener(TasksListProxy.LOADED_ALLLIST, this.NewTaskLoaded);
            if (MainData.TaskListData.isHasNewDayTask() || MainData.TaskListData.isHasNewguideTask() || MainData.TaskListData.isHasNewUpTask())
            {
                this.showNewTaskLog(1);
            }
            else
            {
                this.showNewTaskLog(0);
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            switch(event.currentTarget.name)
            {
                case "sound_btn":
                {
                    this.soundAct();
                    break;
                }
                case "task_btn":
                {
                    if (MainData.newUserTaskData.isNewUser == true)
                    {
                        _loc_3 = new Object();
                        _loc_3.code = "";
                        _loc_3.arr = null;
                        _loc_3.msg = "完成一次游戏任务，开始解锁";
                        this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                        return;
                    }
                    this.showNewTaskLog(0);
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "Task.swf", x:0, y:0});
                    break;
                }
                case "gotoTurn_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "shake.swf", x:0, y:0});
                    break;
                }
                case "guessegg_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/guess_eggs.swf", x:0, y:0});
                    break;
                }
                case "guessprice_btn":
                {
                    ExternalInterface.call("gotoguessprice");
                    break;
                }
                case "help_btn":
                {
                    break;
                }
                case "pay_btn":
                {
                    break;
                }
                case "back_btn":
                {
                    if (KillerRoomData.RoomPlayerList[UserData.UserInfo.UserId] && (KillerRoomData.RoomPlayerList[UserData.UserInfo.UserId].GameStates == "player" || KillerRoomData.RoomPlayerList[UserData.UserInfo.UserId].GameStates == "dead"))
                    {
                        this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, {func:this.leaveRoom, arr:"", msg:"确定要退出游戏吗？\n （强制退出将扣除相应积分）"});
                    }
                    else
                    {
                        this.leaveRoom();
                    }
                    break;
                }
                case "laba_on_btn":
                {
                    MainData.IsShowSpeak = true;
                    this.checkShowSpeak();
                    break;
                }
                case "laba_off_btn":
                {
                    if (UserData.UserInfo.Integral >= 12000)
                    {
                        MainData.IsShowSpeak = false;
                        MainData.NewsMsgObj = new NewsMsgVO();
                        this.facade.sendNotification(GameEvents.NEWSLISTEVENT.MENUNEWS, "");
                        this.checkShowSpeak();
                    }
                    else
                    {
                        _loc_3 = new Object();
                        _loc_3.code = "";
                        _loc_3.arr = null;
                        _loc_3.msg = "积分12000以上才可设置";
                        this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    }
                    break;
                }
                case "share_btn":
                {
                    this.facade.sendNotification("CutPicFrameMediator_SHOW_CUTFRAME");
                    break;
                }
                case "gotoTrade_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/Trade.swf", x:0, y:0});
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function leaveRoom(param1:String = "") : void
        {
            this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADING_AND_BG, {msg:"正在退出房间..."});
            this.facade.sendNotification(KillerRoomEvents.OUTROOM);
            var _loc_2:Object = {cmd:"LeaveRoom"};
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function checkShowSpeak() : void
        {
            if (MainData.IsShowSpeak)
            {
                this.theViewer.showSpeak_btn.laba_on_btn.visible = false;
                this.theViewer.showSpeak_btn.laba_off_btn.visible = true;
            }
            else
            {
                this.theViewer.showSpeak_btn.laba_on_btn.visible = true;
                this.theViewer.showSpeak_btn.laba_off_btn.visible = false;
            }
            return;
        }// end function

        private function playerNumHandler(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                this.showAboutPlayerNum(this.aboutCount);
                this.theViewer.parent.setChildIndex(this.theViewer, (this.theViewer.parent.numChildren - 1));
            }
            else if (event.type == MouseEvent.MOUSE_OUT)
            {
                this.theViewer.parent.setChildIndex(this.theViewer, 2);
                this.showAboutPlayerNum("");
            }
            return;
        }// end function

        private function showAboutPlayerNum(param1:String) : void
        {
            if (param1 != "" && UserData.UserInfo.Wintimes < 20)
            {
                this.theViewer.aboutPlayerNum_mc._txt.autoSize = TextFieldAutoSize.LEFT;
                this.theViewer.aboutPlayerNum_mc._txt.wordWrap = true;
                this.theViewer.aboutPlayerNum_mc._txt.htmlText = param1;
                this.theViewer.aboutPlayerNum_mc.visible = true;
                this.theViewer.aboutPlayerNum_mc._bg.height = 60 + this.theViewer.aboutPlayerNum_mc._txt.height;
            }
            else
            {
                this.theViewer.aboutPlayerNum_mc.visible = false;
            }
            return;
        }// end function

    }
}
