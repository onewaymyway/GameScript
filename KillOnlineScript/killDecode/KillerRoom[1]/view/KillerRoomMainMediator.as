package view
{
    import Core.*;
    import Core.model.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.so.*;
    import Core.view.*;
    import controller.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import model.*;
    import mx.utils.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomMainMediator extends Mediator implements IMediator
    {
        private var gameType_mc:gameType_box;
        private var top_frame:Object;
        private var roomSetSprite:set_form;
        private var menuSprite:KillerRoomMenuController;
        private var btnsSprite:KillerRoomBtnsController;
        private var _roomInfo:Object;
        private var _gameInfo:Object;
        private var partAlertMc:Object;
        private var go123Mc:Object;
        private var JChatBoxMc:JChat_box = null;
        private var SChatBoxMc:SChat_box = null;
        private var DChatBoxMc:DChat_box = null;
        private var LastSayBoxMc:lastSay_box = null;
        private var UserBoxMc:KillerRoomUserBoxController = null;
        private var GameOverFrame:KillerRoomGameOverController = null;
        private var roomSetSelectData:Object = null;
        private var roomSetGameTypeSelectData:Object = null;
        private var roomSetInfoXml:XML;
        private var RoomSo:SO;
        private var GameSo:SO;
        private var isComing:Object = true;
        private var timer:Timer;
        private var MenuLabaColorI:uint;
        private var task_game_prompt:killerroom_task_prompt;
        private var newuserTaskCalloutRoomTimer:Timer;
        public static const NAME:String = "KillerRoomMainMediator";

        public function KillerRoomMainMediator(param1:Object = null)
        {
            super(NAME, param1);
            this.newuserTaskCalloutRoomTimer = new Timer(60000, 1);
            this.newuserTaskCalloutRoomTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.TaskCalloutRoomTimerHandler);
            return;
        }// end function

        private function TaskCalloutRoomTimerHandler(event:Event) : void
        {
            this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_PROMPTTITLE, "等待时间过长，建议重新选择房间");
            this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(0, "退出房间", 5));
            return;
        }// end function

        public function openGameSharedObject() : void
        {
            var _loc_1:* = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            this.GameSo = ServerSO.getRemote("Game" + UserData.UserRoom);
            this.GameSo.addEventListener(SyncEvent.SYNC, this.syncGameSoHandler);
            this.GameSo.connect();
            return;
        }// end function

        private function syncGameSoHandler(event:SyncEvent) : void
        {
            KillerRoomData.GameInfo = this.GameSo.data;
            this._gameInfo = this.GameSo.data;
            var _loc_2:int = 0;
            while (_loc_2 < event.changeList.length)
            {
                
                switch(event.changeList[_loc_2].code)
                {
                    case "change":
                    {
                        if (event.changeList[_loc_2].name == "gameStates")
                        {
                            this.sendNotification(KillerRoomEvents.ROOMACT_GAMEINFO, this._gameInfo);
                        }
                        else if (event.changeList[_loc_2].name == "snum" || event.changeList[_loc_2].name == "jnum" || event.changeList[_loc_2].name == "pnum")
                        {
                            this.menuSprite.setSJPNum(this._gameInfo.snum, this._gameInfo.jnum, this._gameInfo.pnum);
                        }
                        break;
                    }
                    case "delete":
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        public function openSharedObject() : void
        {
            var _loc_1:* = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            this.RoomSo = ServerSO.getRemote("Room" + UserData.UserRoom);
            this.RoomSo.addEventListener(SyncEvent.SYNC, this.syncRoomSoHandler);
            this.RoomSo.connect();
            return;
        }// end function

        private function syncRoomSoHandler(event:SyncEvent) : void
        {
            var _loc_3:Object = null;
            if (KillerRoomData.RoomInfo == null)
            {
                sendNotification(KillerRoomEvents.CREATPLAYER);
            }
            KillerRoomData.RoomInfo = this.RoomSo.data;
            UserData.MyRoomInfo = this.RoomSo.data;
            this._roomInfo = this.RoomSo.data;
            var _loc_2:int = 0;
            while (_loc_2 < event.changeList.length)
            {
                
                switch(event.changeList[_loc_2].code)
                {
                    case "change":
                    {
                        if (event.changeList[_loc_2].name == "BackGround")
                        {
                            this.sendNotification(KillerRoomEvents.LOADBG, this._roomInfo.BackGround);
                        }
                        else if (event.changeList[_loc_2].name == "RoomMaster")
                        {
                            this.sendNotification(KillerRoomEvents.SETHOST);
                            if (UserData.UserInfo.UserId == this._roomInfo.RoomMaster && !(this._roomInfo.GameType == 9 || this._roomInfo.GameType == 10) && this._roomInfo.RoomStatus == 0 && MainData.getGameArea() == GameAreaType.spy)
                            {
                                _loc_3 = new Object();
                                _loc_3.RoomName = UserData.UserInfo.UserName + "的房间";
                                _loc_3.Password = "";
                                _loc_3.MaxPlayerNum = String(8);
                                _loc_3.BackGround = String("spybg");
                                _loc_3.LimitIp = String("true");
                                _loc_3.GameType = String(9);
                                _loc_3.cmd = "SetRoom";
                                this.sendNotification(GameEvents.NETCALL, _loc_3);
                            }
                        }
                        else if (event.changeList[_loc_2].name == "PlayerNum")
                        {
                            this.btnsSprite.playerNum = String(this._roomInfo.PlayerNum);
                        }
                        else if (event.changeList[_loc_2].name == "KickerNum")
                        {
                            this.btnsSprite.kickNum = String(this._roomInfo.KickerNum);
                        }
                        else if (event.changeList[_loc_2].name == "RoomName" || event.changeList[_loc_2].name == "MaxPlayerNum")
                        {
                            this.menuSprite.roomName = RoomData.getRoomWhereName(uint(UserData.UserRoom)) + "(" + this._roomInfo.MaxPlayerNum + "人)" + this._roomInfo.RoomName;
                        }
                        else if (event.changeList[_loc_2].name == "LimitIp")
                        {
                            this.menuSprite.isip = this._roomInfo.LimitIp;
                        }
                        else if (event.changeList[_loc_2].name == "RoomStatus")
                        {
                            this.sendNotification(KillerRoomEvents.ROOMINFO);
                            if (this._roomInfo.RoomStatus == 1)
                            {
                                this.sendNotification(KillerRoomEvents.SETCHATMAXSCORLL, 0);
                            }
                            else
                            {
                                this.sendNotification(KillerRoomEvents.SETCHATMAXSCORLL, 100);
                            }
                        }
                        else if (String(event.changeList[_loc_2].name).indexOf("Ready") > -1)
                        {
                            this.sendNotification(KillerRoomEvents.PLAYERREADY, [true, String(event.changeList[_loc_2].name).slice(5)]);
                        }
                        else if (event.changeList[_loc_2].name == "GameType")
                        {
                            this.changeGameType(this._roomInfo.GameType);
                        }
                        else if (event.changeList[_loc_2].name == "BGSound")
                        {
                            this.sendNotification(KillerRoomEvents.LOAD_BG_SOUND, this._roomInfo.BGSound);
                        }
                        else if (event.changeList[_loc_2].name == "DoubleIntegral")
                        {
                            this.gameType_mc.inteX2_log.visible = Boolean(this._roomInfo.DoubleIntegral);
                        }
                        break;
                    }
                    case "delete":
                    {
                        if (event.changeList[_loc_2].name == "KickerNum")
                        {
                            this.btnsSprite.kickHost();
                        }
                        else if (String(event.changeList[_loc_2].name).indexOf("Ready") > -1)
                        {
                            this.sendNotification(KillerRoomEvents.PLAYERREADY, [false, String(event.changeList[_loc_2].name).slice(5)]);
                        }
                        break;
                    }
                    case "clear":
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        private function closeSO() : void
        {
            UserData.MyRoomInfo = null;
            KillerRoomData.RoomInfo = null;
            if (this.RoomSo)
            {
                this.RoomSo.removeEventListener(SyncEvent.SYNC, this.syncRoomSoHandler);
                this.RoomSo.close();
                this.RoomSo = null;
            }
            if (this.GameSo)
            {
                this.GameSo.removeEventListener(SyncEvent.SYNC, this.syncGameSoHandler);
                this.GameSo.close();
                this.GameSo = null;
            }
            return;
        }// end function

        public function gotoRoom() : void
        {
            this.closeSO();
            if (MainData.newUserTaskData.nowId == 1003)
            {
                if (MainData.LoginInfo.PF == "tapp")
                {
                    MainData.newUserTaskData.tasks[1003].step[0] = new NewUserTaskStepVO(1003, "选择房间", 5, "", new Rectangle(10, 65, 450, 445));
                }
                else
                {
                    MainData.newUserTaskData.tasks[1003].step[0] = new NewUserTaskStepVO(1003, "选择房间", 5, "", new Rectangle(10, 75, 690, 445));
                }
                this.newuserTaskCalloutRoomTimer.start();
            }
            else if (MainData.newUserTaskData.nowId == 1005 || MainData.newUserTaskData.nowId == 1006 || MainData.newUserTaskData.nowId == 1007)
            {
                this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"打开道具"});
            }
            this.isComing = true;
            KillerRoomData.isBeGaged = false;
            KillerRoomData.UserPlayerID = 0;
            UserData.UserPlayerIden = 0;
            KillerRoomData.GameType = -1;
            KillerRoomData.isKillGameType = true;
            KillerRoomData.isKillVoice = false;
            KillerRoomData.gameStates = 0;
            this.roomSetSelectData = null;
            this.viewComponent.visible = true;
            this.btnsSprite.theViewer.noready_btn.visible = false;
            this.btnsSprite.theViewer.readyBtnEnabled = false;
            this.btnsSprite.theViewer.start_btn.visible = false;
            this.btnsSprite.theViewer.set_btn.visible = false;
            this.btnsSprite.theViewer.kickHostBtnEnabled = true;
            this.btnsSprite.theViewer.userIdentity_mc.visible = false;
            this.UserBoxMc.init();
            this.btnsSprite.playerNum = String(0);
            this.btnsSprite.kickNum = String(0);
            if (this.JChatBoxMc)
            {
                this.JChatBoxMc.visible = false;
            }
            if (this.SChatBoxMc)
            {
                this.SChatBoxMc.visible = false;
            }
            if (this.DChatBoxMc)
            {
                this.DChatBoxMc.visible = false;
            }
            this.menuSprite.setTimer(0);
            this.menuSprite.setSJPNum("--", "--", "--");
            this.task_game_prompt.visible = false;
            this.openSharedObject();
            this.showMenuNewsMsg(MainData.NewsMsgObj);
            this.menuSprite.checkShowSpeak();
            this.aboutGameTypeToSysChat();
            MainData.newUserTaskData.setTarget("完成任务获取奖励", this.menuSprite.theViewer.task_btn);
            MainData.newUserTaskData.setTarget("等待倒计时结束", this.menuSprite.theViewer.timer_mc);
            MainData.newUserTaskData.setTarget("打开商城", this.btnsSprite.theViewer.gotoShop_btn);
            this.menuSprite.showNewTaskLog(0);
            this.menuSprite.checkNewTaskLog();
            return;
        }// end function

        override public function onRegister() : void
        {
            this.timer = new Timer(500);
            this.MenuLabaColorI = 0;
            this.timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this.roomSetSprite = null;
            this.btnsSprite = new KillerRoomBtnsController(new killerRoom_btns());
            this.viewComponent.addChild(this.btnsSprite.theViewer);
            var _loc_1:* = new RoomUser_box();
            this.UserBoxMc = new KillerRoomUserBoxController(_loc_1);
            this.viewComponent.addChild(_loc_1);
            this.viewComponent.setChildIndex(_loc_1, 1);
            this.menuSprite = new KillerRoomMenuController(new killerroom_menu());
            this.menuSprite.theViewer.addEventListener(TextEvent.LINK, this.linkHandler);
            this.viewComponent.addChild(this.menuSprite.theViewer);
            this.viewComponent.setChildIndex(this.menuSprite.theViewer, 2);
            this.gameType_mc = new gameType_box();
            MainView.ALT.setAlt(this.gameType_mc.inteX2_log, "开启双倍积", 2);
            this.gameType_mc.x = this.viewComponent.stage.stageWidth - this.gameType_mc.width - 20;
            this.gameType_mc.y = 27;
            this.gameType_mc.btn.addEventListener(MouseEvent.CLICK, this.gameTypeClickHandler);
            this.viewComponent.addChild(this.gameType_mc);
            this.viewComponent.setChildIndex(this.gameType_mc, 1);
            this.partAlertMc = new partAlert_mc();
            this.partAlertMc.x = this.viewComponent.stage.stageWidth / 2;
            this.partAlertMc.y = this.viewComponent.stage.stageHeight / 2 - 50;
            this.partAlertMc.mouseEnabled = false;
            this.partAlertMc.visible = false;
            this.viewComponent.addChild(this.partAlertMc);
            this.go123Mc = new go123_mc();
            this.go123Mc.x = this.viewComponent.stage.stageWidth / 2;
            this.go123Mc.y = this.viewComponent.stage.stageHeight / 2 - 50;
            this.go123Mc.visible = false;
            this.viewComponent.addChild(this.go123Mc);
            this.task_game_prompt = new killerroom_task_prompt();
            this.task_game_prompt.x = 0;
            this.task_game_prompt.y = 115;
            this.task_game_prompt.visible = false;
            this.viewComponent.addChild(this.task_game_prompt);
            this.menuSprite.soundObj = this.viewComponent as Sprite;
            UserData.UserRoom = uint(UserData.UserRoom);
            if (!this.roomSetSprite)
            {
                this.roomSetSprite = new set_form();
                this.roomSetSprite.x = this.viewComponent.stage.stageWidth / 2 - 100;
                this.roomSetSprite.y = this.viewComponent.stage.stageHeight / 2 - 100;
                this.roomSetSprite.save_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                this.roomSetSprite.close_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                this.roomSetSprite.close2_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                this.roomSetSprite.game_select.addEventListener(Event.CHANGE, this.game_selectChangeHandler);
            }
            this.GameOverFrame = new KillerRoomGameOverController(new gameOver_frame(), this.viewComponent);
            this.loadbgList();
            MainData.newUserTaskData.setTarget("点击准备游戏", this.btnsSprite.theViewer.ready_btn);
            MainData.newUserTaskData.setTarget("点击开始游戏", this.btnsSprite.theViewer.start_btn);
            MainData.newUserTaskData.setTarget("退出房间", this.menuSprite.theViewer.back_btn);
            MainData.newUserTaskData.setTarget("打开道具", this.btnsSprite.theViewer.tools_btn);
            MainData.newUserTaskData.setTarget("任务按钮", this.menuSprite.theViewer.task_btn);
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.MenuLabaColorI + 1;
            _loc_2.MenuLabaColorI = _loc_3;
            if (this.MenuLabaColorI >= MainData.NewsMsgObj.MsgColors.length)
            {
                this.MenuLabaColorI = 0;
            }
            if (MainData.NewsMsgObj.Msg != "")
            {
                this.menuSprite.laba = MainData.NewsMsgObj.MsgTitle + "<font color=\'" + MainData.NewsMsgObj.MsgColors[this.MenuLabaColorI] + "\'>" + MainData.NewsMsgObj.Msg + "</font>";
            }
            else
            {
                mcFunc.removeAllMc(this.menuSprite.theViewer.laba_bg);
                this.MenuLabaColorI = 0;
                this.menuSprite.laba = "";
                this.timer.stop();
            }
            return;
        }// end function

        override public function onRemove() : void
        {
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [KillerRoomEvents.ROOMINFO, GameEvents.NEWSLISTEVENT.MENUNEWS, KillerRoomEvents.SYSBOXMSG, KillerRoomEvents.CHATBOXMSG, KillerRoomEvents.JCHATBOXMSG, KillerRoomEvents.SCHATBOXMSG, KillerRoomEvents.DCHATBOXMSG, KillerRoomEvents.KICKHOST, KillerRoomEvents.STARTBTN, KillerRoomEvents.SHOWBTNS, KillerRoomEvents.HOSTPOWER, KillerRoomEvents.OUTROOM, KillerRoomEvents.ROOMSET_OPEN, KillerRoomEvents.ROOMACT_STARTGAME, KillerRoomEvents.ROOMACT_GAMEIDEN, KillerRoomEvents.ROOMACT_GAMEINFO, KillerRoomEvents.ROOMACT_GAMEOVER, KillerRoomEvents.TIMEBAR, KillerRoomEvents.LOADED_BG, GameEvents.USERINFO, GameEvents.USERMSGLB, KillerRoomEvents.SET_PALYER_ONLOOKER, KillerRoomEvents.SET_PALYER_VIEW, KillerRoomEvents.PLAYERREADY, KillerRoomEvents.ROOMACT_ROUND_CLEAR, KillerRoomEvents.TOOLSACT_SERIESACT_START, KillerRoomEvents.TOOLSACT_SERIESACT_STOP, KillerRoomEvents.ROOMACT_MAYORUNVOTE, GameEvents.USER_NEW_TASK_LOG];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var chatmsg:String;
            var cmd:Object;
            var sender:* = param1;
            switch(sender.getName())
            {
                case KillerRoomEvents.ROOMINFO:
                {
                    if (this._roomInfo.RoomStatus == 1)
                    {
                        this.gameType(-1);
                        this.btnsSprite.startingBtns = true;
                        this.btnsSprite.setBtnEnabled = false;
                        if (KillerRoomData.isKillGameType || KillerRoomData.GameType == 9 || KillerRoomData.GameType == 10)
                        {
                            this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:0, isCanTool:0, isCanReady:0});
                            if (this.isComing)
                            {
                                if (KillerRoomData.isKillGameType)
                                {
                                    this.openGameSharedObject();
                                }
                                var _loc_3:* = true && MainData.newUserTaskData.nowId == 1003;
                                MainData.newUserTaskData.isNewUser = true && MainData.newUserTaskData.nowId == 1003;
                                if (_loc_3)
                                {
                                    this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(0, "退出房间", 5, "选择其它房间\n\n此房间已经开始了游戏，请退出房间"));
                                }
                            }
                            if (UserData.UserRoomPlayerType == "Player")
                            {
                            }
                            else
                            {
                                if (this.isComing)
                                {
                                    this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 围观者 ’！\n................................................................");
                                    this.btnsSprite.iden = String("5");
                                }
                                else
                                {
                                    var _loc_3:* = true && MainData.newUserTaskData.nowId == 1003;
                                    MainData.newUserTaskData.isNewUser = true && MainData.newUserTaskData.nowId == 1003;
                                    if (_loc_3)
                                    {
                                        this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(0, "退出房间", 5, "选择其它房间\n\n房间位置已满，请退出房间"));
                                    }
                                }
                                if (UserData.UserRoomPlayerType == "Viewer")
                                {
                                    cmd = new Object();
                                    cmd.Act = "setViewer";
                                    cmd.cmd = "GameCmd_Act";
                                    this.sendNotification(GameEvents.NETCALL, cmd);
                                }
                            }
                        }
                        else
                        {
                            this.sendNotification(KillerRoomEvents.SET_BG_STATES, 1);
                            if (UserData.UserRoomPlayerType == "Player")
                            {
                                this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:1, isCanTool:1, isCanReady:0});
                                this.btnsSprite.startingBtns = true;
                                this.btnsSprite.setBtnEnabled = false;
                            }
                            else
                            {
                                if (this.isComing)
                                {
                                    this.btnsSprite.iden = String("5");
                                    this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 围观者 ’！\n................................................................");
                                }
                                this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:1, isCanTool:0, isCanReady:0, isDChat:0});
                                this.btnsSprite.startingBtns = true;
                                this.btnsSprite.setBtnEnabled = false;
                            }
                        }
                    }
                    else
                    {
                        this.go123(false);
                        this.gameType(KillerRoomData.GameType);
                        this.sendNotification(KillerRoomEvents.SET_BG_STATES, 0);
                        if (UserData.UserRoomPlayerType == "Player")
                        {
                            this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:1, isCanTool:1, isCanReady:1});
                            this.btnsSprite.startingBtns = false;
                            this.btnsSprite.setBtnEnabled = true;
                        }
                        else
                        {
                            var _loc_3:* = true && MainData.newUserTaskData.nowId == 1003;
                            MainData.newUserTaskData.isNewUser = true && MainData.newUserTaskData.nowId == 1003;
                            if (_loc_3)
                            {
                                this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(1003, "退出房间", 5, "选择其它房间\n\n房间位置已满，请退出房间"));
                            }
                            if (this.isComing)
                            {
                                this.btnsSprite.iden = String("5");
                                this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 围观者 ’！\n................................................................");
                            }
                            this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:1, isCanTool:0, isCanReady:0, isDChat:0});
                            this.btnsSprite.startingBtns = true;
                            this.btnsSprite.setBtnEnabled = false;
                        }
                    }
                    this.isComing = false;
                    KillerRoomData.roomStates = this._roomInfo.RoomStatus;
                    break;
                }
                case KillerRoomEvents.ROOMACT_STARTGAME:
                {
                    this.newuserTaskCalloutRoomTimer.stop();
                    UserData.UserPlayerIden = 0;
                    if (KillerRoomData.isKillGameType)
                    {
                        this.openGameSharedObject();
                    }
                    this.btnsSprite.startingBtns = true;
                    this.go123(true);
                    this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSE);
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEIDEN:
                {
                    if (sender.getBody().Iden)
                    {
                        this.btnsSprite.iden = String(sender.getBody().Iden);
                        UserData.UserPlayerIden = uint(KillerRoomData.GetKillIden(sender.getBody().Iden));
                    }
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEINFO:
                {
                    this.go123(false);
                    KillerRoomData.votePlayerID = 0;
                    KillerRoomData.gameStates = uint(this._gameInfo.gameStates);
                    switch(uint(this._gameInfo.gameStates))
                    {
                        case 0:
                        {
                            KillerRoomData.isBeGaged = false;
                            this.menuSprite.setTimer(0);
                            this.menuSprite.setSJPNum("--", "--", "--");
                            break;
                        }
                        case 1:
                        {
                            KillerRoomData.isBeGaged = false;
                            this.part("nighting");
                            this.menuSprite.setTimer(uint(this._gameInfo.time));
                            this.menuSprite.setSJPNum(this._gameInfo.snum, this._gameInfo.jnum, this._gameInfo.pnum);
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n<font color=\'#99FF00\'><b>[  进入黑夜..杀手出来杀人了..大家小心 ]</b></font>\n................................................................");
                            this.sendNotification(KillerRoomEvents.SET_BG_STATES, 1);
                            break;
                        }
                        case 2:
                        {
                            this.part("daying");
                            this.menuSprite.setTimer(uint(this._gameInfo.time));
                            this.menuSprite.setSJPNum(this._gameInfo.snum, this._gameInfo.jnum, this._gameInfo.pnum);
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n<font color=\'#99FF00\'><b>[  白天来临..大家开始自由投票.发言.抓杀手.. ]</b></font>\n................................................................");
                            this.sendNotification(KillerRoomEvents.SET_BG_STATES, 2);
                            break;
                        }
                        case 3:
                        {
                            KillerRoomData.isBeGaged = false;
                            this.part("");
                            this.menuSprite.setTimer(0);
                            this.menuSprite.setSJPNum("--", "--", "--");
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n<font color=\'#99FF00\'><b>[  杀人游戏结束  ]</b></font>\n................................................................");
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    break;
                }
                case GameEvents.NEWSLISTEVENT.MENUNEWS:
                {
                    this.showMenuNewsMsg(sender.getBody());
                    break;
                }
                case KillerRoomEvents.KICKHOST:
                {
                    break;
                }
                case KillerRoomEvents.STARTBTN:
                {
                    if (sender.getBody())
                    {
                        this.btnsSprite.startBtnEnabled = true;
                    }
                    else
                    {
                        this.btnsSprite.startBtnEnabled = false;
                    }
                    break;
                }
                case KillerRoomEvents.SHOWBTNS:
                {
                    this.setBtn(sender.getBody());
                    break;
                }
                case KillerRoomEvents.HOSTPOWER:
                {
                    this.setRoomHostPower();
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    if (MainData.newUserTaskData.nowId == 1003)
                    {
                        MainData.newUserTaskData.tasks[1003].step[3] = new NewUserTaskStepVO(1003, "准备开始游戏", 4);
                    }
                    this.newuserTaskCalloutRoomTimer.stop();
                    KillerRoomData.firstGamePrompt("");
                    this.GameOverFrame.closeFrame();
                    KillerRoomData.seriesToolAct.stop();
                    if (this.JChatBoxMc)
                    {
                        this.JChatBoxMc.visible = false;
                        this.JChatBoxMc.cleanChat();
                    }
                    if (this.SChatBoxMc)
                    {
                        this.SChatBoxMc.visible = false;
                        this.SChatBoxMc.cleanChat();
                    }
                    if (this.DChatBoxMc)
                    {
                        this.DChatBoxMc.visible = false;
                        this.DChatBoxMc.cleanChat();
                    }
                    this.viewComponent.visible = false;
                    if (this.LastSayBoxMc)
                    {
                        this.LastSayBoxMc.close();
                    }
                    this.closeSO();
                    if (mcFunc.hasTheChlid(this.roomSetSprite, this.viewComponent))
                    {
                        this.viewComponent.removeChild(this.roomSetSprite);
                    }
                    if (this.roomSetSprite)
                    {
                        this.roomSetSprite.psw_txt.text = "";
                    }
                    this.timer.stop();
                    this.MenuLabaColorI = 0;
                    this.menuSprite.laba = "";
                    this.menuSprite.roomName = "";
                    this.menuSprite.setTimer(0);
                    this.menuSprite.setSJPNum("--", "--", "--");
                    this.btnsSprite.kickNum = "0";
                    this.btnsSprite.playerNum = "0";
                    UserData.UserPlayerIden = 0;
                    this.go123(false);
                    this.roomSetSelectData = null;
                    this.sendNotification(KillerRoomPlugGameMediator.CLOSE);
                    break;
                }
                case KillerRoomEvents.ROOMSET_OPEN:
                {
                    if (!this.roomSetSprite)
                    {
                        this.roomSetSprite = new set_form();
                        this.loadbgList();
                        this.roomSetSprite.x = this.viewComponent.stage.stageWidth / 2 - 100;
                        this.roomSetSprite.y = this.viewComponent.stage.stageHeight / 2 - 100;
                        this.roomSetSprite.save_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                        this.roomSetSprite.close_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                        this.roomSetSprite.close2_btn.addEventListener(MouseEvent.CLICK, this.roomSetbtnClickHandler);
                        this.roomSetSprite.game_select.addEventListener(Event.CHANGE, this.game_selectChangeHandler);
                    }
                    this.viewComponent.addChild(this.roomSetSprite);
                    this.setSetFormValue(this._roomInfo);
                    break;
                }
                case KillerRoomEvents.ROOMSET_CLOSE:
                {
                    this.closeSetForm();
                    break;
                }
                case KillerRoomEvents.JCHATBOXMSG:
                {
                    if (this.JChatBoxMc)
                    {
                        if (sender.getBody() is String)
                        {
                            this.JChatBoxMc.addChat("<font color=\'#FF0000\'>[提示] </font>" + sender.getBody());
                        }
                        else
                        {
                            chatmsg = sender.getBody().UserName;
                            if (KillerRoomData.UserPlayerID == sender.getBody().Site)
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + " :</b></font> ";
                            }
                            else
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#99FF00\'><b>" + chatmsg + " :</b></font> ";
                            }
                            chatmsg = chatmsg + sender.getBody().Msg;
                            this.JChatBoxMc.addChat(String(chatmsg));
                        }
                    }
                    break;
                }
                case KillerRoomEvents.SCHATBOXMSG:
                {
                    if (this.SChatBoxMc)
                    {
                        if (sender.getBody() is String)
                        {
                            this.SChatBoxMc.addChat("<font color=\'#FF0000\'>[提示] </font>" + sender.getBody());
                        }
                        else
                        {
                            chatmsg = sender.getBody().UserName;
                            if (KillerRoomData.UserPlayerID == sender.getBody().Site)
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + " :</b></font> ";
                            }
                            else
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#99FF00\'><b>" + chatmsg + " :</b></font> ";
                            }
                            chatmsg = chatmsg + sender.getBody().Msg;
                            this.SChatBoxMc.addChat(String(chatmsg));
                        }
                    }
                    break;
                }
                case KillerRoomEvents.DCHATBOXMSG:
                {
                    if (this.DChatBoxMc)
                    {
                        if (sender.getBody() is String)
                        {
                            this.DChatBoxMc.addChat("<font color=\'#FF0000\'>[提示] </font>" + sender.getBody());
                        }
                        else
                        {
                            chatmsg = sender.getBody().UserName;
                            if (KillerRoomData.UserPlayerID == sender.getBody().Site)
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + " :</b></font> ";
                            }
                            else
                            {
                                chatmsg = "<font color=\'#FFFF00\'><b>[" + sender.getBody().Site + "]</b></font><font color=\'#99FF00\'><b>" + chatmsg + " :</b></font> ";
                            }
                            chatmsg = chatmsg + sender.getBody().Msg;
                            this.DChatBoxMc.addChat(String(chatmsg));
                        }
                    }
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEOVER:
                {
                    KillerRoomData.firstGamePrompt("");
                    try
                    {
                        if (!UserData.UserSO.data["iden" + UserData.UserPlayerIden])
                        {
                            UserData.UserSO.data["iden" + UserData.UserPlayerIden] = 1;
                        }
                    }
                    catch (e:Event)
                    {
                    }
                    UserData.UserPlayerIden = 0;
                    if (UserData.UserRoomPlayerType == "Player")
                    {
                        this.btnsSprite.theViewer.userIdentity_mc.visible = false;
                        this.btnsSprite.theViewer.readyBtnEnabled = true;
                    }
                    if (this.LastSayBoxMc)
                    {
                        this.LastSayBoxMc.close();
                    }
                    if (KillerRoomData.isKillGameType)
                    {
                        this.part("");
                        this.menuSprite.setTimer(0);
                        this.menuSprite.setSJPNum("--", "--", "--");
                        this.sendNotification(KillerRoomEvents.SET_BG_STATES, 3);
                        this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n<font color=\'#99FF00\'><b>[  杀人游戏结束  ]</b></font>\n................................................................");
                        if (this.GameSo)
                        {
                            this.GameSo.removeEventListener(SyncEvent.SYNC, this.syncGameSoHandler);
                            this.GameSo.close();
                        }
                        if (this.JChatBoxMc)
                        {
                            this.JChatBoxMc.visible = false;
                            this.JChatBoxMc.cleanChat();
                        }
                        if (this.SChatBoxMc)
                        {
                            this.SChatBoxMc.visible = false;
                            this.SChatBoxMc.cleanChat();
                        }
                        if (this.DChatBoxMc)
                        {
                            this.DChatBoxMc.visible = false;
                            this.DChatBoxMc.cleanChat();
                        }
                        this.GameOverFrame.setValue(sender.getBody(), this._roomInfo.DoubleIntegral);
                    }
                    break;
                }
                case KillerRoomEvents.LOADED_BG:
                {
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADED_AND_BG, {msg:"读取场景资料..."});
                    break;
                }
                case GameEvents.USERMSGLB:
                {
                    this.UserBoxMc.theViewer.lb_mc.gotoAndStop(2);
                    break;
                }
                case GameEvents.USERINFO:
                {
                    this.showGameTaskPrompt();
                    this.UserBoxMc.reUserInfo();
                    break;
                }
                case KillerRoomEvents.SET_PALYER_ONLOOKER:
                {
                    this.setOnlookers();
                    break;
                }
                case KillerRoomEvents.SET_PALYER_VIEW:
                {
                    this.setViewer();
                    break;
                }
                case KillerRoomEvents.PLAYERREADY:
                {
                    this.btnsSprite.ready = sender.getBody() as Boolean;
                    break;
                }
                case KillerRoomEvents.TIMEBAR:
                {
                    this.menuSprite.setTimer(uint(sender.getBody()));
                    break;
                }
                case KillerRoomEvents.ROOMACT_ROUND_CLEAR:
                {
                    this.go123(false);
                    break;
                }
                case KillerRoomEvents.TOOLSACT_SERIESACT_START:
                {
                    KillerRoomData.seriesToolAct.start(sender.getBody());
                    break;
                }
                case KillerRoomEvents.TOOLSACT_SERIESACT_STOP:
                {
                    KillerRoomData.seriesToolAct.stop();
                    break;
                }
                case KillerRoomEvents.ROOMACT_MAYORUNVOTE:
                {
                    this.btnsSprite.setMayorBtn(sender.getBody().unvote);
                    break;
                }
                case GameEvents.USER_NEW_TASK_LOG:
                {
                    MainData.UserNewTask_isLog = int(sender.getBody());
                    this.menuSprite.showNewTaskLog(int(sender.getBody()));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function showGameTaskPrompt() : void
        {
            this.task_game_prompt.visible = false;
            if (UserData.UserInfo.Integral >= 700 || UserData.UserSO.data["Integral700"] || MainData.getGameArea() == GameAreaType.spy)
            {
                return;
            }
            if (UserData.UserInfo.Integral < 700)
            {
                this.task_game_prompt.visible = true;
                this.task_game_prompt._txt.htmlText = "等级6级(700积分)\n<font color=\'#cc66ff\'>解锁高手区</font>";
            }
            return;
        }// end function

        private function showMenuNewsMsg(param1:Object) : void
        {
            var _loc_2:String = null;
            this.timer.stop();
            this.MenuLabaColorI = 0;
            mcFunc.removeAllMc(this.menuSprite.theViewer.laba_bg);
            if (param1 is String)
            {
                this.menuSprite.laba = String(param1);
                if (String(param1) == "")
                {
                    this.MenuLabaColorI = 0;
                }
            }
            else if (param1 is NewsMsgVO)
            {
                if (param1.bg)
                {
                    ViewPicLoad.load(param1.bg + ".swf", this.menuSprite.theViewer.laba_bg);
                }
                _loc_2 = param1.MsgTitle + "<font color=\'" + param1.MsgColors[this.MenuLabaColorI] + "\'>" + param1.Msg + "</font>";
                this.menuSprite.laba = _loc_2;
                if (param1.MsgColors.length > 1)
                {
                    this.timer.start();
                }
            }
            return;
        }// end function

        private function setOnlookers() : void
        {
            UserData.UserRoomPlayerType = "Viewer";
            this.btnsSprite.iden = String("5");
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 围观者 ’！\n................................................................");
            this.sendNotification(KillerRoomEvents.SHOWBTNS, {isCanChat:1, isCanTool:0, isCanReady:0});
            this.btnsSprite.startingBtns = true;
            this.btnsSprite.setBtnEnabled = false;
            return;
        }// end function

        private function setViewer() : void
        {
            this.btnsSprite.iden = String("4");
            return;
        }// end function

        private function changeGameType(param1:uint) : void
        {
            var o:Object;
            var t:* = param1;
            this.gameType(t);
            if (KillerRoomData.GameType != t)
            {
                if (this._roomInfo.RoomStatus == 0 && UserData.UserRoomPlayerType == "Player")
                {
                    if (KillerRoomData.GameType == -1 && !UserData.UserSO.data["Game" + t] && (t == 0 || t == 2 || t == 5 || t == 11 || t == 13 || t == 14 || t == 15))
                    {
                        try
                        {
                            UserData.UserSO.data["Game" + t] = 1;
                        }
                        catch (e:Event)
                        {
                        }
                        this.sendNotification(PlusMediator.OPEN, {url:"/swf/about/aboutkiller" + t + ".swf", x:MainData.MainStage.stageWidth / 2, y:MainData.MainStage.stageHeight / 2});
                    }
                    else if (MainData.newUserTaskData.nowId == 1003 && UserData.UserSO.data["Game" + t] == 1)
                    {
                        this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"点击准备游戏"});
                    }
                }
                this.sendNotification(KillerRoomEvents.CLEANSYSMSGBOX);
                KillerRoomData.GameType = t;
                KillerRoomData.isKillGameType = false;
                KillerRoomData.isKillVoice = false;
                if (t == 0 || t == 2 || t == 5 || t == 11 || t == 13 || t == 14 || t == 8 || t == 15)
                {
                    KillerRoomData.isKillGameType = true;
                    this.showGameTaskPrompt();
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.CLOSE);
                }
                else if (t == 3 || t == 4)
                {
                    KillerRoomData.isKillGameType = true;
                    KillerRoomData.isKillVoice = true;
                    o = Resource.PlugGames[t];
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.OPEN, o);
                }
                else if (t == 1)
                {
                    o = Resource.PlugGames[t];
                    if (this._roomInfo.RoomStatus == 1)
                    {
                        o.Act = "comeBack";
                    }
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.OPEN, o);
                }
                else if (t == 6)
                {
                    o = Resource.PlugGames[t];
                    if (this._roomInfo.RoomStatus == 1)
                    {
                        o.Act = "comeBack";
                    }
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.OPEN, o);
                }
                else if (t == 9 || t == 10)
                {
                    o = Resource.PlugGames[t];
                    if (this._roomInfo.RoomStatus == 1 && UserData.UserRoomPlayerType == "Player")
                    {
                        o.Act = "comeBack";
                    }
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.OPEN, o);
                }
                else if (t == 12)
                {
                    o = Resource.PlugGames[t];
                    if (this._roomInfo.RoomStatus == 1)
                    {
                        o.Act = "comeBack";
                    }
                    this.sendNotification(KillerRoomEvents.RESET_PLAYERLIST_WHERE, t);
                    this.sendNotification(KillerRoomPlugGameMediator.OPEN, o);
                }
                this.aboutGameTypeToSysChat();
                if (this._roomInfo.RoomStatus == 0)
                {
                    this.sendNotification(KillerRoomEvents.SET_BG_STATES, 0);
                }
            }
            if (KillerRoomData.RoomSetInfoXml)
            {
                var _loc_4:int = 0;
                var _loc_5:* = KillerRoomData.RoomSetInfoXml.games;
                var _loc_3:* = new XMLList("");
                for each (_loc_6 in _loc_5)
                {
                    
                    var _loc_7:* = _loc_5[_loc_4];
                    with (_loc_5[_loc_4])
                    {
                        if (@gametype == String(KillerRoomData.GameType) && @linetype == String(MainData.getGameArea()))
                        {
                            _loc_3[_loc_4] = _loc_6;
                        }
                    }
                }
                this.menuSprite.aboutCount = String(_loc_3.about).split("\r").join("");
            }
            return;
        }// end function

        private function aboutGameTypeToSysChat(param1:int = 0) : void
        {
            var _loc_2:String = "";
            switch(KillerRoomData.GameType)
            {
                case 0:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：2.0版杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 1:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：大话骰盅</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules2.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 2:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：3.0版杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules1.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 3:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：2.0版语音杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 4:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：3.0版语音杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules1.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 5:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：4.0版杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules3.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 6:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：斗牛</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules4.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 9:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：卧底游戏</b>\n";
                    _loc_2 = _loc_2 + "1人卧底拿到不同的身份词,其余玩家拿到相同的身份词.\n";
                    _loc_2 = _loc_2 + "1.每轮每人说一句话描述自己的身份\n";
                    _loc_2 = _loc_2 + "2.发言结束投票找出卧底.\n";
                    _loc_2 = _loc_2 + "3.卧底撑到最后一轮(场上剩2个平民时)则卧底胜利.</font>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules5.shtml\">[<U>查看游戏视频</U>]</a></font>\n";
                    break;
                }
                case 10:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：卧底游戏</b>\n";
                    _loc_2 = _loc_2 + "1人卧底拿到不同的身份词,其余玩家拿到相同的身份词.\n";
                    _loc_2 = _loc_2 + "1.每轮换身份词，每人说一句话描述自己的身份\n";
                    _loc_2 = _loc_2 + "2.发言结束投票找出卧底.\n";
                    _loc_2 = _loc_2 + "3.卧底撑到最后一轮(场上剩2个平民时)则卧底胜利.</font>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules5.shtml\">[<U>查看游戏视频</U>]</a></font>\n";
                    break;
                }
                case 11:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：5.0版杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules6.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 12:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：2人斗地主</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules7.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 13:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：加强版杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules8.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 14:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：6.0杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules9.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                case 15:
                {
                    _loc_2 = "<font color=\'#FF0000\'>[提示]</font> <font color=\'#ff0000\'><b>游戏模式：1.0杀人游戏</b>\n";
                    _loc_2 = _loc_2 + "<font color=\'#FFFF00\'><a href=\"event:http://www.ss911.cn/Pages/GameRules10.shtml\">[<U>查看规则介绍</U>]</a></font>\n";
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_2);
            return;
        }// end function

        private function loadbgList() : void
        {
            var _loc_1:* = new LoadURL();
            _loc_1.addEventListener(Event.COMPLETE, this.loadbgListHandler);
            _loc_1.load(Resource.HTTP + "roomsetinfo.xml?v=" + Resource.V + "." + uint(Resource.ChildV.roomsetinfo));
            return;
        }// end function

        private function loadbgListHandler(event:Event) : void
        {
            this.roomSetInfoXml = new XML(event.target.data);
            KillerRoomData.RoomSetInfoXml = this.roomSetInfoXml;
            this.gotoRoom();
            this.roomSetSetValue();
            return;
        }// end function

        private function roomSetSetValue() : void
        {
            var i:uint;
            var gt:String;
            var areaNumArr:Array;
            var i2:uint;
            var i3:uint;
            var xml:* = new Object();
            xml.def = this.roomSetInfoXml.@def;
            if (this.RoomSo.data.NewUserRoom)
            {
                gt;
                if (this.RoomSo.data.NewUserRoom == 1)
                {
                    gt;
                }
                else if (this.RoomSo.data.NewUserRoom == 2)
                {
                    gt;
                }
                if (gt != "")
                {
                    var _loc_3:int = 0;
                    var _loc_4:* = this.roomSetInfoXml.games;
                    var _loc_2:* = new XMLList("");
                    for each (_loc_5 in _loc_4)
                    {
                        
                        var _loc_6:* = _loc_4[_loc_3];
                        with (_loc_4[_loc_3])
                        {
                            if (@linetype == String(MainData.getGameArea()) && @gametype == gt)
                            {
                                _loc_2[_loc_3] = _loc_5;
                            }
                        }
                    }
                    xml.games = _loc_2;
                }
                else
                {
                    var _loc_3:int = 0;
                    var _loc_4:* = this.roomSetInfoXml.games;
                    var _loc_2:* = new XMLList("");
                    for each (_loc_5 in _loc_4)
                    {
                        
                        var _loc_6:* = _loc_4[_loc_3];
                        with (_loc_4[_loc_3])
                        {
                            if (@linetype == String(MainData.getGameArea()))
                            {
                                _loc_2[_loc_3] = _loc_5;
                            }
                        }
                    }
                    xml.games = _loc_2;
                }
            }
            else
            {
                var _loc_3:int = 0;
                var _loc_4:* = this.roomSetInfoXml.games;
                var _loc_2:* = new XMLList("");
                for each (_loc_5 in _loc_4)
                {
                    
                    var _loc_6:* = _loc_4[_loc_3];
                    with (_loc_4[_loc_3])
                    {
                        if (@linetype == String(MainData.getGameArea()))
                        {
                            _loc_2[_loc_3] = _loc_5;
                        }
                    }
                }
                xml.games = _loc_2;
            }
            this.roomSetGameTypeSelectData = new Object();
            this.roomSetSelectData = new Object();
            this.roomSetGameTypeSelectData["labelArr"] = new Array();
            this.roomSetGameTypeSelectData["dataArr"] = new Array();
            this.roomSetGameTypeSelectData["def"] = uint(xml.def);
            i;
            while (i < xml.games.length())
            {
                
                areaNumArr = xml.games[i].@area.toString().split("-");
                if (UserData.UserRoom > uint(areaNumArr[0]) && UserData.UserRoom < uint(areaNumArr[1]))
                {
                    this.roomSetGameTypeSelectData["labelArr"].push(xml.games[i].@name.toString());
                    this.roomSetGameTypeSelectData["dataArr"].push(xml.games[i].@gametype.toString());
                    this.roomSetSelectData[xml.games[i].@gametype] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["about"] = new String();
                    this.roomSetSelectData[xml.games[i].@gametype]["about"] = String(xml.games[i].about).split("\r").join("");
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["labelArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["dataArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["def"] = uint(xml.games[i].pnlist.@def);
                    i2;
                    while (i2 < xml.games[i].pnlist.pn.length())
                    {
                        
                        this.roomSetSelectData[xml.games[i].@gametype]["pn"]["labelArr"].push(xml.games[i].pnlist.pn[i2].toString());
                        this.roomSetSelectData[xml.games[i].@gametype]["pn"]["dataArr"].push(xml.games[i].pnlist.pn[i2].@value.toString());
                        i2 = (i2 + 1);
                    }
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["labelArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["dataArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["def"] = uint(xml.games[i].bglist.@def);
                    i3;
                    while (i3 < xml.games[i].bglist.bg.length())
                    {
                        
                        this.roomSetSelectData[xml.games[i].@gametype]["bg"]["labelArr"].push(xml.games[i].bglist.bg[i3].toString());
                        this.roomSetSelectData[xml.games[i].@gametype]["bg"]["dataArr"].push(xml.games[i].bglist.bg[i3].@value.toString());
                        i3 = (i3 + 1);
                    }
                }
                i = (i + 1);
            }
            if (this.roomSetSelectData[KillerRoomData.GameType])
            {
                this.roomSetSprite.game_select.setData(this.roomSetGameTypeSelectData);
                this.roomSetSprite.count_select.setData(this.roomSetSelectData[KillerRoomData.GameType]["pn"]);
                this.roomSetSprite.bg_select.setData(this.roomSetSelectData[KillerRoomData.GameType]["bg"]);
                this.menuSprite.aboutCount = this.roomSetSelectData[KillerRoomData.GameType]["about"];
            }
            this.roomSetSprite.score_chickBox.visible = KillerRoomData.isKillGameType;
            if (this._roomInfo)
            {
                this.roomSetSprite.bg_select.selectData = this._roomInfo.BackGround;
                this.roomSetSprite.count_select.selectData = this._roomInfo.MaxPlayerNum;
                this.roomSetSprite.isip_chickBox.selectData = String(this._roomInfo.LimitIp);
                this.roomSetSprite.score_chickBox.selectData = String(this._roomInfo.DoubleIntegral);
                this.roomSetSprite.game_select.selectData = String(this._roomInfo.GameType);
                this.roomSetSprite.roomName_txt.text = this._roomInfo.RoomName;
            }
            return;
        }// end function

        private function game_selectChangeHandler(event:Event) : void
        {
            var _loc_2:* = this.roomSetSprite.game_select.selectData;
            if (_loc_2 == 0 || _loc_2 == 2 || _loc_2 == 5 || _loc_2 == 11 || _loc_2 == 13 || _loc_2 == 3 || _loc_2 == 4 || _loc_2 == 14 || _loc_2 == 15)
            {
                this.roomSetSprite.score_chickBox.visible = true;
            }
            else
            {
                this.roomSetSprite.score_chickBox.selectData = "false";
                this.roomSetSprite.score_chickBox.visible = false;
            }
            this.roomSetSprite.count_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["pn"]);
            this.roomSetSprite.bg_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["bg"]);
            return;
        }// end function

        private function roomSetbtnClickHandler(event:Event) : void
        {
            var _loc_2:Object = null;
            switch(event.currentTarget.name)
            {
                case "save_btn":
                {
                    this.roomSetSprite.roomName_txt.text = StringUtil.trim(this.roomSetSprite.roomName_txt.text);
                    _loc_2 = new Object();
                    _loc_2.RoomName = this.roomSetSprite.roomName_txt.text;
                    _loc_2.Password = this.roomSetSprite.psw_txt.text;
                    _loc_2.MaxPlayerNum = String(this.roomSetSprite.count_select.selectData);
                    _loc_2.BackGround = String(this.roomSetSprite.bg_select.selectData);
                    _loc_2.LimitIp = String(this.roomSetSprite.isip_chickBox.selectData);
                    _loc_2.DoubleIntegral = String(this.roomSetSprite.score_chickBox.selectData);
                    _loc_2.GameType = String(this.roomSetSprite.game_select.selectData);
                    _loc_2.cmd = "SetRoom";
                    this.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.closeSetForm();
                    break;
                }
                case "close_btn":
                {
                    this.closeSetForm();
                    break;
                }
                case "close2_btn":
                {
                    this.closeSetForm();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function setSetFormValue(param1:Object) : void
        {
            if (this.roomSetInfoXml)
            {
                if (this.roomSetSelectData && !this.RoomSo.data.NewUserRoom)
                {
                    this.roomSetSprite.score_chickBox.visible = KillerRoomData.isKillGameType;
                    this.roomSetSprite.game_select.setData(this.roomSetGameTypeSelectData);
                    this.roomSetSprite.count_select.setData(this.roomSetSelectData[KillerRoomData.GameType]["pn"]);
                    this.roomSetSprite.bg_select.setData(this.roomSetSelectData[KillerRoomData.GameType]["bg"]);
                    this.roomSetSprite.bg_select.selectData = this._roomInfo.BackGround;
                    this.roomSetSprite.count_select.selectData = this._roomInfo.MaxPlayerNum;
                    this.roomSetSprite.isip_chickBox.selectData = String(this._roomInfo.LimitIp);
                    this.roomSetSprite.score_chickBox.selectData = String(this._roomInfo.DoubleIntegral);
                    this.roomSetSprite.game_select.selectData = String(this._roomInfo.GameType);
                    this.roomSetSprite.roomName_txt.text = this._roomInfo.RoomName;
                }
                else
                {
                    this.roomSetSetValue();
                }
            }
            else
            {
                this.loadbgList();
            }
            return;
        }// end function

        private function closeSetForm() : void
        {
            if (mcFunc.hasTheChlid(this.roomSetSprite, this.viewComponent))
            {
                this.viewComponent.removeChild(this.roomSetSprite);
            }
            return;
        }// end function

        private function setBtn(param1:Object) : void
        {
            KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
            if (param1.isCanTool)
            {
                KillerRoomData.isCanTool = true;
            }
            else
            {
                KillerRoomData.isCanTool = true;
            }
            if (param1.isCanReady)
            {
                this.btnsSprite.ready = false;
                this.btnsSprite.theViewer.readyBtn = true;
                this.btnsSprite.setBtnEnabled = true;
                this.btnsSprite.theViewer.kickhost_mc.visible = true;
            }
            else
            {
                this.btnsSprite.ready = false;
                this.btnsSprite.theViewer.readyBtn = false;
                this.btnsSprite.setBtnEnabled = false;
                this.btnsSprite.theViewer.kickhost_mc.visible = false;
            }
            if (param1.CHK4)
            {
            }
            if (param1.isCanVoteAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_VOTEACT;
                KillerRoomData.firstGamePrompt("白天来了，选择怀疑玩家进行投票公决");
            }
            param1.isSChat = KillerRoomData.GetKillPlayerDo(param1.isSChat + "");
            if (param1.isSChat)
            {
                if (this.SChatBoxMc)
                {
                    if (this.SChatBoxMc.x > MainData.MainStage.stageWidth - 20 || this.SChatBoxMc.y > MainData.MainStage.stageHeight - 20)
                    {
                        MainView.ReMoveToRandomXY(this.SChatBoxMc, 30, 30, 338, 416);
                    }
                    else
                    {
                        MainView.ReMoveToRandomXY(this.SChatBoxMc, 10, 10);
                    }
                    this.SChatBoxMc.visible = true;
                }
                else
                {
                    this.SChatBoxMc = new SChat_box();
                    this.viewComponent.addChild(this.SChatBoxMc);
                    MainView.DRAG.setDrag(this.SChatBoxMc.drag_mc, this.SChatBoxMc, this.viewComponent);
                    MainView.ReMoveToRandomXY(this.SChatBoxMc, 30, 10, 338, 416);
                }
            }
            else if (this.SChatBoxMc)
            {
                this.SChatBoxMc.visible = false;
            }
            if (param1.CHK7)
            {
            }
            if (param1.isJChat)
            {
                if (this.JChatBoxMc)
                {
                    this.JChatBoxMc.visible = true;
                }
                else
                {
                    this.JChatBoxMc = new JChat_box();
                    this.viewComponent.addChild(this.JChatBoxMc);
                    MainView.DRAG.setDrag(this.JChatBoxMc.drag_mc, this.JChatBoxMc, this.viewComponent);
                }
            }
            else if (this.JChatBoxMc)
            {
                this.JChatBoxMc.visible = false;
            }
            if (param1.isLastSay)
            {
                if (this.LastSayBoxMc)
                {
                    this.LastSayBoxMc.start();
                }
                else
                {
                    this.LastSayBoxMc = new lastSay_box();
                    this.viewComponent.addChild(this.LastSayBoxMc);
                    this.LastSayBoxMc.start();
                    MainView.DRAG.setDrag(this.LastSayBoxMc.drag_mc, this.LastSayBoxMc, this.viewComponent);
                }
            }
            else if (this.LastSayBoxMc)
            {
                this.LastSayBoxMc.close();
            }
            if (!param1.isDChat && UserData.UserPlayerIden == 1 && this._gameInfo.gameStates == 1)
            {
                KillerRoomData.firstGamePrompt("黑夜来了，等待杀手行动");
            }
            if (param1.isDChat)
            {
                if (this.DChatBoxMc)
                {
                    this.DChatBoxMc.visible = true;
                }
                else
                {
                    this.DChatBoxMc = new DChat_box();
                    this.viewComponent.addChild(this.DChatBoxMc);
                    MainView.DRAG.setDrag(this.DChatBoxMc.drag_mc, this.DChatBoxMc, this.viewComponent);
                }
                this.DChatBoxMc.cleanChat();
                if (!UserData.UserSO.data["iden" + UserData.UserPlayerIden])
                {
                    KillerRoomData.firstGamePrompt("您为“旁观”、“围观”或“灵魂”状态\n“灵魂”状态退出游戏，将扣除相应积分");
                    UserData.UserSO.data["iden" + UserData.UserPlayerIden] = 1;
                }
                this.sendNotification(KillerRoomEvents.DCHATBOXMSG, "<font color=\'#999999\'>您为\"旁观\",\"围观\"或\"灵魂\",请等待游戏结束后再游戏;\n如果是\"灵魂\"状态退出游戏,系统会扣除相应积分.</font>");
            }
            else if (this.DChatBoxMc)
            {
                this.DChatBoxMc.visible = false;
            }
            param1.isCanKillAct = KillerRoomData.GetKillPlayerDo(param1.isCanKillAct + "");
            if (param1.isCanKillAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_KILLACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，杀了他！");
            }
            if (param1.isCanCheckAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_CHECKACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，查看他的身份！");
            }
            if (param1.isCanSnipeAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_SNIPEACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，蹦了他\n狙击无视医生的针，被蹦玩家立刻倒地");
            }
            if (param1.isCanSaveAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_SAVEACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行针救\n救活被杀玩家，累计2空针可针死玩家");
            }
            if (param1.isCanBarrierAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_BARRIERACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行保护");
            }
            if (param1.isCanGagAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_GAGACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行禁言\n被禁言白天不能发言(下个黑夜自动解除)");
            }
            if (param1.isCanExplosionAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_EXPLOSIONACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，牺牲自己爆死对方\n无视医生的针和花蝴蝶的护体");
            }
            if (param1.isCanCupidAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_CupidACT;
                KillerRoomData.firstGamePrompt("选择一名玩家与他达成恋爱关系\n丘比特死后死双方，恋爱对象死后只死丘比特");
            }
            if (param1.isCanSAgentAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_SAgentACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行暗杀\n暗杀杀手阵营才有效，未使用暗杀时不能被杀手和狙击手杀掉");
            }
            if (param1.isCanSpyAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_SpyACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，查看他的身份！");
            }
            if (param1.isCanMayorAct)
            {
                this.btnsSprite.setMayorBtn(0);
            }
            else
            {
                this.btnsSprite.setMayorBtn(3);
            }
            if (param1.isCanRogueAct)
            {
                KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_RogueACT;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，偷盗身份\n不能偷盗警察、平民和杀手阵营(偷盗失败下个晚上可继续)");
            }
            this.sendNotification(KillerRoomEvents.MOUSEACT_CHANGE);
            return;
        }// end function

        public function gameType(param1:Number)
        {
            if (param1 < 0)
            {
                this.gameType_mc.visible = false;
            }
            else
            {
                this.gameType_mc.visible = true;
                this.gameType_mc.gotoAndStop("gametype" + param1);
            }
            return;
        }// end function

        private function setRoomHostPower() : void
        {
            KillerRoomData.UserHost = 1;
            this.btnsSprite.theViewer.set_btn.visible = true;
            this.btnsSprite.theViewer.start_btn.visible = true;
            this.btnsSprite.theViewer.kickHostBtnEnabled = false;
            return;
        }// end function

        private function part(param1:String) : void
        {
            if (param1 != "")
            {
                this.partAlertMc.gotoAndPlay(param1);
                this.partAlertMc.visible = true;
            }
            else
            {
                this.partAlertMc.visible = false;
            }
            return;
        }// end function

        private function go123(param1:Boolean) : void
        {
            if (param1)
            {
                this.go123Mc.visible = true;
                this.go123Mc.gotoAndPlay(2);
            }
            else
            {
                this.go123Mc.visible = false;
            }
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            this.sendNotification(GameEvents.PlUSEVENT.INFOBOXSHOW, int(event.text));
            return;
        }// end function

        private function gameTypeClickHandler(event:MouseEvent) : void
        {
            switch(KillerRoomData.GameType)
            {
                case 0:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules.shtml");
                    break;
                }
                case 2:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules1.shtml");
                    break;
                }
                case 3:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules.shtml");
                    break;
                }
                case 4:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules1.shtml");
                    break;
                }
                case 5:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules3.shtml");
                    break;
                }
                case 9:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules5.shtml");
                    break;
                }
                case 10:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules5.shtml");
                    break;
                }
                case 11:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules6.shtml");
                    break;
                }
                case 13:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules8.shtml");
                    break;
                }
                case 14:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules9.shtml");
                    break;
                }
                case 15:
                {
                    OpenWin.open("http://www.ss911.cn/Pages/GameRules10.shtml");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
