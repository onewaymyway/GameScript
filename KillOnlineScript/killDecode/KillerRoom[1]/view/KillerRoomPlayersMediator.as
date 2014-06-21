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
    import flash.media.*;
    import flash.utils.*;
    import model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomPlayersMediator extends Mediator implements IMediator
    {
        private var players_frame1:Object;
        private var players_frame2:Object;
        private var players_frame3:Object;
        private var playersWhere0:Array;
        private var playersWhere1:Array;
        private var playersWhere6:Array;
        private var playersWhere9:Array;
        private var playersWhere12:Array;
        private var mousePic_obj:Object;
        private var PlayerSo:SO;
        private var isFrist:Boolean = true;
        private var playerChangeI:uint = 0;
        public static const NAME:String = "KillerRoomPlayersMediator";
        public static var playersArr:Array;
        public static var userPID:uint = 0;

        public function KillerRoomPlayersMediator(param1:Object = null)
        {
            super(NAME, param1);
            return;
        }// end function

        override public function onRegister() : void
        {
            playersArr = new Array();
            this.playersWhere0 = new Array();
            this.playersWhere0[0] = {x:480, y:295, z:1};
            this.playersWhere0[1] = {x:390, y:310, z:1};
            this.playersWhere0[2] = {x:300, y:325, z:1};
            this.playersWhere0[3] = {x:210, y:325, z:1};
            this.playersWhere0[4] = {x:120, y:325, z:1};
            this.playersWhere0[5] = {x:35, y:250, z:2};
            this.playersWhere0[6] = {x:130, y:140, z:3};
            this.playersWhere0[7] = {x:210, y:130, z:3};
            this.playersWhere0[8] = {x:300, y:110, z:3};
            this.playersWhere0[9] = {x:390, y:100, z:3};
            this.playersWhere0[10] = {x:480, y:95, z:3};
            this.playersWhere0[11] = {x:570, y:100, z:3};
            this.playersWhere0[12] = {x:660, y:110, z:3};
            this.playersWhere0[13] = {x:750, y:130, z:3};
            this.playersWhere0[14] = {x:840, y:140, z:3};
            this.playersWhere0[15] = {x:910, y:250, z:2};
            this.playersWhere0[16] = {x:840, y:325, z:1};
            this.playersWhere0[17] = {x:750, y:325, z:1};
            this.playersWhere0[18] = {x:660, y:325, z:1};
            this.playersWhere0[19] = {x:570, y:310, z:1};
            this.playersWhere0[20] = {x:480, y:310, z:1};
            this.playersWhere1 = new Array();
            this.playersWhere1[0] = {x:30, y:220, z:1};
            this.playersWhere1[1] = {x:50, y:220, z:1};
            this.playersWhere1[2] = {x:210, y:130, z:2};
            this.playersWhere1[3] = {x:370, y:100, z:3};
            this.playersWhere1[4] = {x:530, y:100, z:3};
            this.playersWhere1[5] = {x:690, y:130, z:2};
            this.playersWhere1[6] = {x:850, y:220, z:1};
            this.playersWhere6 = new Array();
            this.playersWhere6[0] = {x:30, y:220, z:1};
            this.playersWhere6[1] = {x:50, y:220, z:1};
            this.playersWhere6[2] = {x:210, y:130, z:2};
            this.playersWhere6[3] = {x:370, y:100, z:3};
            this.playersWhere6[4] = {x:530, y:100, z:3};
            this.playersWhere6[5] = {x:690, y:130, z:2};
            this.playersWhere6[6] = {x:850, y:220, z:1};
            this.playersWhere9 = new Array();
            this.playersWhere9[0] = {x:30, y:220, z:1};
            this.playersWhere9[1] = {x:100, y:220, z:1};
            this.playersWhere9[2] = {x:200, y:180, z:2};
            this.playersWhere9[3] = {x:300, y:130, z:2};
            this.playersWhere9[4] = {x:400, y:100, z:3};
            this.playersWhere9[5] = {x:500, y:100, z:3};
            this.playersWhere9[6] = {x:600, y:130, z:2};
            this.playersWhere9[7] = {x:700, y:180, z:2};
            this.playersWhere9[8] = {x:800, y:220, z:1};
            this.playersWhere12 = new Array();
            this.playersWhere12[0] = {x:100, y:320, z:1};
            this.playersWhere12[1] = {x:100, y:110, z:1};
            this.playersWhere12[2] = {x:100, y:320, z:1};
            this.playersWhere12[3] = {x:740, y:110, z:1};
            this.playersWhere12[4] = {x:830, y:150, z:1};
            this.playersWhere12[5] = {x:910, y:270, z:1};
            this.playersWhere12[6] = {x:830, y:400, z:1};
            this.players_frame3 = this.viewComponent.addChild(new Sprite());
            this.players_frame2 = this.viewComponent.addChild(new Sprite());
            this.players_frame1 = this.viewComponent.addChild(new Sprite());
            this.mousePic_obj = this.viewComponent.addChild(new mouse_pic_log());
            this.mousePic_obj.mouseEnabled = false;
            return;
        }// end function

        public function openSharedObject() : void
        {
            if (this.PlayerSo)
            {
                this.closeSO();
            }
            playersArr = null;
            mcFunc.removeAllMc(this.players_frame1);
            mcFunc.removeAllMc(this.players_frame2);
            mcFunc.removeAllMc(this.players_frame3);
            playersArr = new Array();
            var _loc_1:* = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            this.PlayerSo = ServerSO.getRemote("Player" + UserData.UserRoom);
            this.PlayerSo.addEventListener(SyncEvent.SYNC, this.syncPlayerSOHandler);
            this.PlayerSo.connect();
            return;
        }// end function

        private function closeSO() : void
        {
            if (this.PlayerSo)
            {
                this.PlayerSo.removeEventListener(SyncEvent.SYNC, this.syncPlayerSOHandler);
                this.PlayerSo.close();
                this.PlayerSo = null;
            }
            return;
        }// end function

        private function syncPlayerSOHandler(event:SyncEvent) : void
        {
            KillerRoomData.RoomPlayerList = this.PlayerSo.data;
            var _loc_2:int = 0;
            while (_loc_2 < event.changeList.length)
            {
                
                switch(event.changeList[_loc_2].code)
                {
                    case "clear":
                    {
                        break;
                    }
                    case "change":
                    {
                        this.changePlayer(event.changeList[_loc_2].name);
                        break;
                    }
                    case "delete":
                    {
                        this.removePlayer(event.changeList[_loc_2].name);
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

        public function getUser(param1:String) : Object
        {
            return this.PlayerSo.data[param1];
        }// end function

        public function getUserSite(param1:String) : uint
        {
            var _loc_2:uint = 0;
            if (this.PlayerSo != null)
            {
                if (this.PlayerSo.data[param1])
                {
                    _loc_2 = this.PlayerSo.data[param1].RoomSite;
                }
            }
            return _loc_2;
        }// end function

        override public function onRemove() : void
        {
            if (this.PlayerSo)
            {
                this.PlayerSo.removeEventListener(SyncEvent.SYNC, this.syncPlayerSOHandler);
                this.PlayerSo.close();
                this.PlayerSo = null;
            }
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [KillerRoomEvents.CREATPLAYER, KillerRoomEvents.REMOVEPLAYER, KillerRoomEvents.ADDPLAYER, KillerRoomEvents.BODYFACE, KillerRoomEvents.PLAYERREADY, KillerRoomEvents.CHATBOXMSG, KillerRoomEvents.SETHOST, KillerRoomEvents.ROOMTOBEKILL, KillerRoomEvents.SETOFFLINE, KillerRoomEvents.SET_PALYER_VIEW, KillerRoomEvents.OUTROOM, KillerRoomEvents.LASTBOXMSG, KillerRoomEvents.ROOMACT_STARTGAME, KillerRoomEvents.ROOMACT_GAMEINFO, KillerRoomEvents.ROOMACT_GAMEIDEN, KillerRoomEvents.ROOMACT_CHECK, KillerRoomEvents.ROOMACT_CHECKED, KillerRoomEvents.ROOMACT_KILL, KillerRoomEvents.ROOMACT_KILLONE, KillerRoomEvents.ROOMACT_VOTE, KillerRoomEvents.ROOMACT_VOTEONE, KillerRoomEvents.ROOMACT_DEADONE, KillerRoomEvents.ROOMACT_SAVE, KillerRoomEvents.ROOMACT_SAVEONE, KillerRoomEvents.ROOMACT_SNIPEONE, KillerRoomEvents.ROOMACT_SNIPE, KillerRoomEvents.ROOMACT_BARRIER, KillerRoomEvents.ROOMACT_GAG, KillerRoomEvents.ROOMACT_GAGONE, KillerRoomEvents.ROOMACT_EXPLOSION, KillerRoomEvents.ROOMACT_EXPLOSIONONE, KillerRoomEvents.ROOMACT_SAgentKillOne, KillerRoomEvents.ROOMACT_CupidAct, KillerRoomEvents.ROOMACT_SPYCHECK, KillerRoomEvents.ROOMACT_MAYORACT, KillerRoomEvents.ROOMACT_ROGUEACT, KillerRoomEvents.ROOMACT_ACTFAIL, KillerRoomEvents.ROOMACT_GAMEOVER, KillerRoomEvents.TOOLSACT_ACT, KillerRoomEvents.TOOLSACT_ACT_ALLPLAYERS, KillerRoomEvents.TOOLSACT_ACT_ONE_TO_ONE, KillerRoomEvents.TOOLSACT_SEND, KillerRoomEvents.TOOLSACT_REMOTETOOL_SETUP, KillerRoomEvents.TOOLSACT_REMOTETOOL_USE, KillerRoomEvents.MARRY_TYPE, KillerRoomEvents.RESET_PLAYERLIST_WHERE, KillerRoomEvents.ROOMACT_ROUND_CLEAR];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            switch(param1.getName())
            {
                case KillerRoomEvents.ROOMTOBEKILL:
                {
                    if (param1.getBody()[0] == "kill1")
                    {
                        playersArr[param1.getBody()[1]].beKilled(1);
                    }
                    else if (param1.getBody()[0] == "kill2")
                    {
                        playersArr[param1.getBody()[1]].beKilled(2);
                    }
                    else if (param1.getBody()[0] == "isview")
                    {
                        playersArr[param1.getBody()[1]].states = "viewer";
                    }
                    else if (param1.getBody()[0] == "offline")
                    {
                        playersArr[param1.getBody()[1]].states = "offliner";
                    }
                    break;
                }
                case KillerRoomEvents.CREATPLAYER:
                {
                    this.openSharedObject();
                    break;
                }
                case KillerRoomEvents.REMOVEPLAYER:
                {
                    break;
                }
                case KillerRoomEvents.ADDPLAYER:
                {
                    break;
                }
                case KillerRoomEvents.SETOFFLINE:
                {
                    this.setOffline(param1.getBody());
                    break;
                }
                case KillerRoomEvents.BODYFACE:
                {
                    this.showFace(param1.getBody());
                    break;
                }
                case KillerRoomEvents.PLAYERREADY:
                {
                    this.showOneReady(param1.getBody() as Array);
                    break;
                }
                case KillerRoomEvents.CHATBOXMSG:
                {
                    if (playersArr[param1.getBody().Site])
                    {
                        playersArr[param1.getBody().Site].say = String(param1.getBody().Msg);
                    }
                    break;
                }
                case KillerRoomEvents.LASTBOXMSG:
                {
                    playersArr[param1.getBody().Site].lastSay = String(param1.getBody().Msg);
                    break;
                }
                case KillerRoomEvents.SETHOST:
                {
                    this.setHost(uint(KillerRoomData.RoomInfo.RoomMaster));
                    break;
                }
                case KillerRoomEvents.ROOMACT_STARTGAME:
                {
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEINFO:
                {
                    if (param1.getBody().gameStates != 3)
                    {
                        _loc_2 = 0;
                        while (_loc_2 < playersArr.length)
                        {
                            
                            if (playersArr[_loc_2] != null)
                            {
                                playersArr[_loc_2].voteNum = 0;
                                playersArr[_loc_2].vote = 0;
                                playersArr[_loc_2].toBeSave();
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEIDEN:
                {
                    if (KillerRoomData.isKillGameType)
                    {
                        this.idenShow(param1.getBody());
                    }
                    break;
                }
                case KillerRoomEvents.ROOMACT_CHECK:
                {
                    this.check(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_CHECKED:
                {
                    this.mousePic_obj.act("nothing");
                    KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
                    this.checked(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_KILL:
                {
                    this.kill(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_KILLONE:
                {
                    this.mousePic_obj.act("nothing");
                    KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
                    this.killOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_VOTE:
                {
                    this.vote(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_VOTEONE:
                {
                    this.mousePic_obj.act("nothing");
                    KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
                    this.voteOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_DEADONE:
                {
                    this.mousePic_obj.act("nothing");
                    KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
                    this.deadOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SNIPE:
                {
                    this.Snipe(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SNIPEONE:
                {
                    this.snipeOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SAVE:
                {
                    this.Save(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SAVEONE:
                {
                    this.saveOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_BARRIER:
                {
                    this.Barrier(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAG:
                {
                    this.Gag(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAGONE:
                {
                    this.gagOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_EXPLOSION:
                {
                    break;
                }
                case KillerRoomEvents.ROOMACT_EXPLOSIONONE:
                {
                    this.ExplosionOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SAgentKillOne:
                {
                    this.sAgentKillOne(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_SPYCHECK:
                {
                    this.spyCheck(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_CupidAct:
                {
                    this.cupidAct(param1.getBody());
                    break;
                }
                case KillerRoomEvents.TOOLSACT_ACT:
                {
                    this.actionTools(param1.getBody());
                    break;
                }
                case KillerRoomEvents.TOOLSACT_ACT_ALLPLAYERS:
                {
                    break;
                }
                case KillerRoomEvents.TOOLSACT_ACT_ONE_TO_ONE:
                {
                    break;
                }
                case KillerRoomEvents.TOOLSACT_SEND:
                {
                    this.sendTools(param1.getBody()[0], param1.getBody()[1], param1.getBody()[2]);
                    break;
                }
                case KillerRoomEvents.TOOLSACT_REMOTETOOL_SETUP:
                {
                    this.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/RemoteToolForm.swf", x:0, y:0, Tools:param1.getBody().Tools, FromUserId:param1.getBody().FromUserId, FromUserName:param1.getBody().FromUserName});
                    break;
                }
                case KillerRoomEvents.TOOLSACT_REMOTETOOL_USE:
                {
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEOVER:
                {
                    _loc_3 = 0;
                    while (_loc_3 < playersArr.length)
                    {
                        
                        if (playersArr[_loc_3] != null)
                        {
                            if (playersArr[_loc_3].playerInfo.states == "offliner")
                            {
                                if (mcFunc.hasTheChlid(playersArr[_loc_3].theViewer, this.players_frame1))
                                {
                                    playersArr[_loc_3].clear();
                                    this.players_frame1.removeChild(playersArr[_loc_3].theViewer);
                                }
                                if (mcFunc.hasTheChlid(playersArr[_loc_3].theViewer, this.players_frame2))
                                {
                                    playersArr[_loc_3].clear();
                                    this.players_frame2.removeChild(playersArr[_loc_3].theViewer);
                                }
                                if (mcFunc.hasTheChlid(playersArr[_loc_3].theViewer, this.players_frame3))
                                {
                                    playersArr[_loc_3].clear();
                                    this.players_frame3.removeChild(playersArr[_loc_3].theViewer);
                                }
                                playersArr[_loc_3] = null;
                            }
                            else
                            {
                                playersArr[_loc_3].def();
                            }
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    if (param1.getBody())
                    {
                        if (param1.getBody().Players)
                        {
                            _loc_4 = 0;
                            while (_loc_4 < param1.getBody().Players.length)
                            {
                                
                                if (uint(param1.getBody().Winner) == 3)
                                {
                                    if (uint(param1.getBody().Players[_loc_4].Iden) == 3 || uint(param1.getBody().Players[_loc_4].Iden) == 6)
                                    {
                                        if (playersArr[param1.getBody().Players[_loc_4].Site])
                                        {
                                            playersArr[param1.getBody().Players[_loc_4].Site].bodyFace("haha");
                                        }
                                    }
                                    else if (playersArr[param1.getBody().Players[_loc_4].Site])
                                    {
                                        playersArr[param1.getBody().Players[_loc_4].Site].bodyFace("cry");
                                    }
                                }
                                else if (uint(param1.getBody().Winner) == 2)
                                {
                                    if (uint(param1.getBody().Players[_loc_4].Iden) == 1 || uint(param1.getBody().Players[_loc_4].Iden) == 2 || uint(param1.getBody().Players[_loc_4].Iden) == 7)
                                    {
                                        if (playersArr[param1.getBody().Players[_loc_4].Site])
                                        {
                                            playersArr[param1.getBody().Players[_loc_4].Site].bodyFace("haha");
                                        }
                                    }
                                    else if (playersArr[param1.getBody().Players[_loc_4].Site])
                                    {
                                        playersArr[param1.getBody().Players[_loc_4].Site].bodyFace("cry");
                                    }
                                }
                                _loc_4 = _loc_4 + 1;
                            }
                        }
                    }
                    break;
                }
                case KillerRoomEvents.MARRY_TYPE:
                {
                    if (playersArr[param1.getBody()[0]])
                    {
                        playersArr[param1.getBody()[0]].playerInfo.marryid = param1.getBody()[1];
                        playersArr[param1.getBody()[0]].marryType = param1.getBody()[2];
                    }
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    this.closeSO();
                    playersArr = null;
                    mcFunc.removeAllMc(this.players_frame1);
                    mcFunc.removeAllMc(this.players_frame2);
                    mcFunc.removeAllMc(this.players_frame3);
                    break;
                }
                case KillerRoomEvents.RESET_PLAYERLIST_WHERE:
                {
                    this.reSetPlayerWhere(param1.getBody() as uint);
                    break;
                }
                case KillerRoomEvents.ROOMACT_ROUND_CLEAR:
                {
                    KillerRoomData.votePlayerID = 0;
                    _loc_2 = 0;
                    while (_loc_2 < playersArr.length)
                    {
                        
                        if (playersArr[_loc_2] != null)
                        {
                            playersArr[_loc_2].voteNum = 0;
                            playersArr[_loc_2].vote = 0;
                            playersArr[_loc_2].toBeSave();
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                    break;
                }
                case KillerRoomEvents.ROOMACT_MAYORACT:
                {
                    this.MayorAct(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_ROGUEACT:
                {
                    this.RogueAct(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_ACTFAIL:
                {
                    this.ActFail(param1.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function MayorAct(param1:Object) : void
        {
            var _loc_2:String = null;
            if (param1.isRogue)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>盗贼</b></font>";
            }
            else
            {
                _loc_2 = "<font color=\'#0099FF\'><b>市长</b></font>";
            }
            var _loc_3:* = new Object();
            _loc_3.code = "";
            _loc_3.arr = null;
            _loc_3.msg = _loc_2 + " 否决公投，白天公决某人无效";
            facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_3);
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_3.msg);
            return;
        }// end function

        private function RogueAct(param1:Object) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_2:* = new Object();
            _loc_2.code = "";
            _loc_2.arr = null;
            if (param1.Site1 != 0 && playersArr[param1.Site2] && param1.Site1 == KillerRoomData.UserPlayerID)
            {
                _loc_4 = playersArr[param1.Site2].playerInfo.UserName;
                _loc_2.msg = "成功盗取[" + param1.Site2 + "]" + _loc_4 + "技能，其身份" + this.getStringIden(param1.Iden);
                KillerRoomData.firstGamePrompt("盗取完成，等待倒计时结束");
            }
            else if (param1.Site2 != 0 && playersArr[param1.Site2] && param1.Site2 == KillerRoomData.UserPlayerID)
            {
                _loc_2.msg = "你被盗贼盗取了你的技能，你的技能已丧失";
            }
            else
            {
                _loc_2.msg = this.getStringIden(param1.Iden) + "技能已被‘盗贼’盗取";
            }
            _loc_3 = this.getStringIden(param1.Iden) + "技能已被‘盗贼’盗取";
            facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_3);
            return;
        }// end function

        private function setPlayers(param1:Object) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < playersArr.length)
            {
                
                if (playersArr[_loc_2] != null)
                {
                    playersArr[_loc_2].ready = false;
                    if (uint(param1[_loc_2 + ""]) > 0)
                    {
                        playersArr[_loc_2].states = "player";
                    }
                    else
                    {
                        playersArr[_loc_2].states = "viewer";
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function creatPlayer() : void
        {
            var _loc_4:String = null;
            mcFunc.removeAllMc(this.players_frame1);
            mcFunc.removeAllMc(this.players_frame2);
            mcFunc.removeAllMc(this.players_frame3);
            var _loc_5:* = uint(this.PlayerSo.data[UserData.UserInfo.UserId].RoomSite);
            userPID = uint(this.PlayerSo.data[UserData.UserInfo.UserId].RoomSite);
            KillerRoomData.UserPlayerID = _loc_5;
            var _loc_1:* = uint(userPID);
            var _loc_2:* = this.PlayerSo.data;
            var _loc_3:uint = 0;
            for (_loc_4 in _loc_2)
            {
                
                if (uint(this.getUser(_loc_2[_loc_4]).UserId) != 0)
                {
                    if (uint(this.getUser(_loc_2[_loc_4]).RoomSite) - _loc_1 > 0)
                    {
                        _loc_3 = int(uint(this.getUser(_loc_2[_loc_4]).RoomSite) - _loc_1);
                    }
                    else if (uint(this.getUser(_loc_2[_loc_4]).RoomSite) - _loc_1 < 0)
                    {
                        _loc_3 = int(uint(this.getUser(_loc_2[_loc_4]).RoomSite) - _loc_1 + 20);
                    }
                    else if (uint(this.getUser(_loc_2[_loc_4]).RoomSite) - _loc_1 == 0)
                    {
                        _loc_3 = 0;
                    }
                    if (playersArr[this.getUser(_loc_2[_loc_4]).RoomSite] == null)
                    {
                        playersArr[this.getUser(_loc_2[_loc_4]).RoomSite] = new KillerPlayerController(new player_mc());
                        playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].mousePicObj = this.mousePic_obj;
                    }
                    this["players_frame" + this.playersWhere0[_loc_3].z].addChild(playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].theViewer);
                    playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].theViewer.x = this.playersWhere0[_loc_3].x;
                    playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].theViewer.y = this.playersWhere0[_loc_3].y;
                    playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].playerInfo = this.getUser(_loc_2[_loc_4]);
                    playersArr[this.getUser(_loc_2[_loc_4]).RoomSite].isCanClick = true;
                }
            }
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
            return;
        }// end function

        private function removePlayer(param1:String) : void
        {
            var _loc_3:Object = null;
            var _loc_2:uint = 0;
            for (_loc_3 in playersArr)
            {
                
                if (playersArr[_loc_3])
                {
                    if (param1 == String(playersArr[_loc_3].playerInfo.UserId))
                    {
                        KillerRoomData.seriesToolAct.chickHaveStop(uint(playersArr[_loc_3].playerInfo.UserId));
                        _loc_2 = uint(playersArr[_loc_3].playerInfo.RoomSite);
                        if (KillerRoomData.roomStates == 0 || playersArr[_loc_2].playerInfo.states == "viewer" || playersArr[_loc_2].playerInfo.states == "wait")
                        {
                            this.clearOnePlayer(String(_loc_2));
                            continue;
                        }
                        playersArr[_loc_2].states = "offliner";
                    }
                }
            }
            return;
        }// end function

        private function reSetPlayerWhere(param1:uint) : void
        {
            var _loc_2:Object = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if (KillerRoomData.isKillGameType || param1 == 9 || param1 == 10)
            {
                for (_loc_2 in playersArr)
                {
                    
                    if (playersArr[_loc_2])
                    {
                        _loc_3 = 0;
                        if (UserData.UserRoomPlayerType == "Player" || UserData.UserRoomPlayerType == "Wait")
                        {
                            var _loc_7:* = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            RoomData.Rooms.UserPlayerID = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            var _loc_7:* = _loc_7;
                            KillerRoomData.UserPlayerID = _loc_7;
                            _loc_3 = _loc_7;
                        }
                        _loc_4 = 0;
                        if (uint(_loc_2) - _loc_3 > 0)
                        {
                            _loc_4 = int(uint(_loc_2) - _loc_3);
                        }
                        else if (uint(_loc_2) - _loc_3 < 0)
                        {
                            _loc_4 = int(uint(_loc_2) - _loc_3 + 20);
                        }
                        else if (uint(_loc_2) - _loc_3 == 0)
                        {
                            _loc_4 = 0;
                        }
                        this["players_frame" + this.playersWhere0[_loc_4].z].addChild(playersArr[_loc_2].theViewer);
                        playersArr[_loc_2].setWhere(this.playersWhere0[_loc_4].x, this.playersWhere0[_loc_4].y);
                    }
                }
            }
            else if (param1 == 1 || param1 == 6)
            {
                for (_loc_2 in playersArr)
                {
                    
                    if (playersArr[_loc_2] && this.playersWhere1[_loc_2])
                    {
                        this["players_frame" + this.playersWhere1[_loc_2].z].addChild(playersArr[_loc_2].theViewer);
                        playersArr[_loc_2].setWhere(this.playersWhere1[_loc_2].x, this.playersWhere1[_loc_2].y);
                    }
                }
            }
            else if (param1 == 12)
            {
                for (_loc_2 in playersArr)
                {
                    
                    if (playersArr[_loc_2])
                    {
                        _loc_3 = 0;
                        if (UserData.UserRoomPlayerType == "Player" || UserData.UserRoomPlayerType == "Wait")
                        {
                            var _loc_7:* = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            RoomData.Rooms.UserPlayerID = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            var _loc_7:* = _loc_7;
                            KillerRoomData.UserPlayerID = _loc_7;
                            _loc_3 = _loc_7;
                        }
                        _loc_4 = 0;
                        if (uint(_loc_2) < 3 && _loc_3 < 3)
                        {
                            if (uint(_loc_2) - _loc_3 > 0)
                            {
                                _loc_4 = int(uint(_loc_2) - _loc_3);
                            }
                            else if (uint(_loc_2) - _loc_3 < 0)
                            {
                                _loc_4 = int(uint(_loc_2) - _loc_3 + 2);
                            }
                            else if (uint(_loc_2) - _loc_3 == 0)
                            {
                                _loc_4 = 0;
                            }
                        }
                        else
                        {
                            _loc_4 = uint(_loc_2);
                        }
                        this["players_frame" + this["playersWhere" + param1][_loc_4].z].addChild(playersArr[_loc_2].theViewer);
                        playersArr[_loc_2].setWhere(this.playersWhere12[_loc_4].x, this.playersWhere12[_loc_4].y);
                    }
                }
            }
            else
            {
                for (_loc_2 in playersArr)
                {
                    
                    if (playersArr[_loc_2] && this["playersWhere" + param1][_loc_2])
                    {
                        this["players_frame" + this["playersWhere" + param1][_loc_2].z].addChild(playersArr[_loc_2].theViewer);
                        playersArr[_loc_2].setWhere(this["playersWhere" + param1].x, this["playersWhere" + param1].y);
                    }
                }
            }
            return;
        }// end function

        private function changePlayer(param1:String) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:Object = null;
            if (this.getUser(param1).RoomSite > 0)
            {
                if (playersArr[this.getUser(param1).RoomSite])
                {
                    if (playersArr[this.getUser(param1).RoomSite].playerInfo.states == "offliner")
                    {
                        this.clearOnePlayer(this.getUser(param1).RoomSite);
                    }
                }
                if (playersArr[this.getUser(param1).RoomSite] == null || playersArr[this.getUser(param1).RoomSite].playerInfo.states == "offliner")
                {
                    this.clearOnePlayer(this.getUser(param1).RoomSite);
                    playersArr[this.getUser(param1).RoomSite] = new KillerPlayerController(new player_mc());
                    playersArr[this.getUser(param1).RoomSite].mousePicObj = this.mousePic_obj;
                    if (KillerRoomData.isKillGameType || KillerRoomData.GameType == 9 || KillerRoomData.GameType == 10)
                    {
                        _loc_2 = 0;
                        if (UserData.UserRoomPlayerType == "Player")
                        {
                            var _loc_5:* = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            RoomData.Rooms.UserPlayerID = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            var _loc_5:* = _loc_5;
                            KillerRoomData.UserPlayerID = _loc_5;
                            _loc_2 = _loc_5;
                        }
                        _loc_3 = 0;
                        if (uint(this.getUser(param1).RoomSite) - _loc_2 > 0)
                        {
                            _loc_3 = int(uint(this.getUser(param1).RoomSite) - _loc_2);
                        }
                        else if (uint(this.getUser(param1).RoomSite) - _loc_2 < 0)
                        {
                            _loc_3 = int(uint(this.getUser(param1).RoomSite) - _loc_2 + (this["playersWhere" + 0].length - 1));
                        }
                        else if (uint(this.getUser(param1).RoomSite) - _loc_2 == 0)
                        {
                            _loc_3 = 0;
                        }
                        this["players_frame" + this["playersWhere" + 0][_loc_3].z].addChild(playersArr[this.getUser(param1).RoomSite].theViewer);
                        playersArr[this.getUser(param1).RoomSite].setWhere(this["playersWhere" + 0][_loc_3].x, this["playersWhere" + 0][_loc_3].y);
                    }
                    else if (KillerRoomData.GameType == 1 || KillerRoomData.GameType == 6)
                    {
                        if (UserData.UserRoomPlayerType == "Player")
                        {
                            var _loc_5:* = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            RoomData.Rooms.UserPlayerID = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            KillerRoomData.UserPlayerID = _loc_5;
                        }
                        this["players_frame" + this["playersWhere" + KillerRoomData.GameType][this.getUser(param1).RoomSite].z].addChild(playersArr[this.getUser(param1).RoomSite].theViewer);
                        playersArr[this.getUser(param1).RoomSite].setWhere(this["playersWhere" + KillerRoomData.GameType][this.getUser(param1).RoomSite].x, this["playersWhere" + KillerRoomData.GameType][this.getUser(param1).RoomSite].y);
                    }
                    else if (KillerRoomData.GameType == 12)
                    {
                        _loc_2 = 0;
                        if (UserData.UserRoomPlayerType == "Player")
                        {
                            var _loc_5:* = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            RoomData.Rooms.UserPlayerID = this.getUser(String(UserData.UserInfo.UserId)).RoomSite;
                            var _loc_5:* = _loc_5;
                            KillerRoomData.UserPlayerID = _loc_5;
                            _loc_2 = _loc_5;
                        }
                        _loc_3 = 0;
                        if (_loc_2 < 3 && this.getUser(param1).RoomSite < 3)
                        {
                            if (uint(this.getUser(param1).RoomSite) - _loc_2 > 0)
                            {
                                _loc_3 = int(uint(this.getUser(param1).RoomSite) - _loc_2);
                            }
                            else if (uint(this.getUser(param1).RoomSite) - _loc_2 < 0)
                            {
                                _loc_3 = int(uint(this.getUser(param1).RoomSite) - _loc_2 + 2);
                            }
                            else if (uint(this.getUser(param1).RoomSite) - _loc_2 == 0)
                            {
                                _loc_3 = 0;
                            }
                        }
                        else
                        {
                            _loc_3 = this.getUser(param1).RoomSite;
                        }
                        this["players_frame" + this["playersWhere" + KillerRoomData.GameType][_loc_3].z].addChild(playersArr[this.getUser(param1).RoomSite].theViewer);
                        playersArr[this.getUser(param1).RoomSite].setWhere(this["playersWhere" + KillerRoomData.GameType][_loc_3].x, this["playersWhere" + KillerRoomData.GameType][_loc_3].y);
                    }
                    else
                    {
                        this["players_frame" + this["playersWhere" + KillerRoomData.GameType][_loc_3].z].addChild(playersArr[this.getUser(param1).RoomSite].theViewer);
                        playersArr[this.getUser(param1).RoomSite].setWhere(this["playersWhere" + 0][_loc_3].x, this["playersWhere" + 0][_loc_3].y);
                    }
                    playersArr[this.getUser(param1).RoomSite].playerInfo = this.getUser(param1);
                    playersArr[this.getUser(param1).RoomSite].marryType = uint(this.getUser(param1).MarryType);
                    if (KillerRoomData.isKillGameType || KillerRoomData.GameType == 9 || KillerRoomData.GameType == 10)
                    {
                        playersArr[this.getUser(param1).RoomSite].states = String(this.getUser(param1).GameStates);
                        if (this.getUser(param1).GameStates == "viewer" && String(UserData.UserInfo.UserId) == String(param1))
                        {
                            _loc_4 = new Object();
                            _loc_4.Act = "setViewer";
                            _loc_4.cmd = "GameCmd_Act";
                            this.sendNotification(GameEvents.NETCALL, _loc_4);
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 旁观者 ’！\n................................................................");
                            this.sendNotification(KillerRoomEvents.SET_PALYER_VIEW);
                        }
                    }
                    else if (this.getUser(param1).GameStates == "viewer")
                    {
                        playersArr[this.getUser(param1).RoomSite].states = "wait";
                        if (UserData.UserInfo.UserId == uint(param1))
                        {
                            this.sendNotification(KillerRoomEvents.ROOMACT_GAMEIDEN, {Iden:"4"});
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 旁观者 ’！\n................................................................");
                        }
                    }
                    else
                    {
                        playersArr[this.getUser(param1).RoomSite].states = String(this.getUser(param1).GameStates);
                    }
                    if ((this.getUser(param1).GameStates == "player" || this.getUser(param1).GameStates == "dead") && String(UserData.UserInfo.UserId) == String(param1))
                    {
                        if (KillerRoomData.isKillGameType)
                        {
                            _loc_4 = new Object();
                            _loc_4.Act = "comeBack";
                            _loc_4.cmd = "GameCmd_Act";
                            this.sendNotification(GameEvents.NETCALL, _loc_4);
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       回到了房间，继续游戏！\n................................................................");
                        }
                    }
                    if (KillerRoomData.RoomInfo.RoomMaster == param1)
                    {
                        playersArr[this.getUser(param1).RoomSite].host = true;
                    }
                    if (KillerRoomData.RoomInfo.RoomMaster == UserData.UserInfo.UserId)
                    {
                        this.sendNotification(KillerRoomEvents.HOSTPOWER);
                    }
                    if (UserData.UserInfo.UserId == uint(param1))
                    {
                        this.sendNotification(KillerRoomEvents.PLAYERREADY, false);
                    }
                }
                else
                {
                    if (KillerRoomData.isKillGameType || KillerRoomData.GameType == 9 || KillerRoomData.GameType == 10)
                    {
                        playersArr[this.getUser(param1).RoomSite].states = String(this.getUser(param1).GameStates);
                    }
                    else if (this.getUser(param1).GameStates == "viewer")
                    {
                        if (playersArr[this.getUser(param1).RoomSite].states != "wait")
                        {
                            playersArr[this.getUser(param1).RoomSite].states = "wait";
                        }
                        if (UserData.UserInfo.UserId == uint(param1))
                        {
                            this.sendNotification(KillerRoomEvents.ROOMACT_GAMEIDEN, {Iden:"4"});
                            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 旁观者 ’！\n................................................................");
                        }
                    }
                    else
                    {
                        playersArr[this.getUser(param1).RoomSite].states = String(this.getUser(param1).GameStates);
                    }
                    if (UserData.UserInfo.UserId == uint(param1))
                    {
                        if (playersArr[this.getUser(param1).RoomSite].states == "wait")
                        {
                            this.sendNotification(KillerRoomEvents.PLAYERREADY, false);
                        }
                        else if (playersArr[this.getUser(param1).RoomSite].states == "ready")
                        {
                            this.sendNotification(KillerRoomEvents.PLAYERREADY, true);
                        }
                    }
                    this.checkPlayersReady();
                    playersArr[this.getUser(param1).RoomSite].updatePlayerInfo(this.getUser(param1));
                    playersArr[this.getUser(param1).RoomSite].level = int(this.getUser(param1).Integral);
                    playersArr[this.getUser(param1).RoomSite].playerName = String(this.getUser(param1).UserName);
                    playersArr[this.getUser(param1).RoomSite].familyName = String(this.getUser(param1).FamilyName);
                    playersArr[this.getUser(param1).RoomSite].marryType = uint(this.getUser(param1).MarryType);
                    playersArr[this.getUser(param1).RoomSite].UserToolState = this.getUser(param1).UserToolState;
                    playersArr[this.getUser(param1).RoomSite].UserSex = String(this.getUser(param1).UserSex);
                }
                if (UserData.UserInfo.UserId == uint(param1) && String(this.getUser(param1).GameStates) == "dead")
                {
                    KillerRoomData.isCanSpeaker = false;
                }
                else if (UserData.UserInfo.UserId == uint(param1) && String(this.getUser(param1).GameStates) != "dead")
                {
                    KillerRoomData.isCanSpeaker = true;
                }
            }
            return;
        }// end function

        private function checkPlayersReady() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Object = null;
            if (KillerRoomData.roomStates == 0 && MainData.newUserTaskData.nowId == 1003 && MainData.newUserTaskData.nowStep == 3 && KillerRoomData.RoomInfo.RoomMaster == UserData.UserInfo.UserId)
            {
                _loc_1 = 0;
                for (_loc_2 in playersArr)
                {
                    
                    if (playersArr[_loc_2] && playersArr[_loc_2].states == "ready")
                    {
                        _loc_1++;
                    }
                }
                if (_loc_1 >= 6)
                {
                    this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(0, "点击开始游戏", 1));
                }
            }
            return;
        }// end function

        private function setOffline(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            playersArr[_loc_2].states = "offliner";
            playersArr[_loc_2].iden = _loc_3;
            var _loc_4:* = this.getStringIden(_loc_3);
            if (this.getStringIden(_loc_3) != "")
            {
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>" + playersArr[_loc_2].playerInfo.UserName + "</b></font> 逃跑了其身份为‘ " + _loc_4 + " ’！";
            }
            else
            {
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>" + playersArr[_loc_2].playerInfo.UserName + "</b></font> 逃跑了！";
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_4);
            return;
        }// end function

        private function setViewer(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            playersArr[_loc_2].states = "viewer";
            playersArr[_loc_2].iden = _loc_3;
            return;
        }// end function

        private function showFace(param1:Object) : void
        {
            if (playersArr[param1.Site])
            {
                playersArr[param1.Site].bodyFace(param1.Type);
            }
            return;
        }// end function

        private function setHost(param1:uint) : void
        {
            var _loc_2:uint = 0;
            if (param1 > 0)
            {
                _loc_2 = this.getUserSite(param1 + "");
                if (playersArr[_loc_2])
                {
                    playersArr[_loc_2].host = true;
                }
                if (UserData.UserInfo.UserId == param1)
                {
                    this.sendNotification(KillerRoomEvents.HOSTPOWER);
                }
            }
            return;
        }// end function

        private function showOneReady(param1:Array) : void
        {
            return;
        }// end function

        private function idenShow(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:Array = null;
            var _loc_5:uint = 0;
            _loc_2 = int(KillerRoomData.GetKillIden(param1.Iden));
            _loc_4 = param1.Sites;
            if (_loc_4)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_4.length)
                {
                    
                    if (playersArr[_loc_4[_loc_5]])
                    {
                        playersArr[_loc_4[_loc_5]].iden = _loc_2;
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            if (_loc_2 == 5)
            {
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n       你为‘ 围观者 ’！\n................................................................");
            }
            else
            {
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, "................................................................\n      <font color=\'#99FF00\'><b>[ 杀人游戏开始 ]</b></font>   \n................................................................");
            }
            return;
        }// end function

        private function ActFail(param1:Object) : void
        {
            var _loc_2:Object = null;
            KillerRoomData.mouseAct = KillerRoomEvents.MOUSEACT_NOTHING;
            if (param1.Msg)
            {
                KillerRoomData.firstGamePrompt("");
                _loc_2 = new Object();
                _loc_2.code = "";
                _loc_2.arr = null;
                _loc_2.msg = param1.Msg;
                facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            }
            return;
        }// end function

        private function voteOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            if (_loc_2 != 0)
            {
                _loc_4 = playersArr[_loc_2].playerInfo.UserName;
                _loc_5 = this.getStringIden(_loc_3);
                if (param1.IsB == 12)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 受到\'恋爱关系\'影响一起被公决<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else if (param1.IsB == 13)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 为了爱情替爱人 被公决<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 被公决<font color=\'#ffffff\'>其身份</font>  " + _loc_5;
                }
                playersArr[_loc_2].toolsid = 0;
                playersArr[_loc_2].isCanClick = false;
                playersArr[_loc_2].iden = _loc_3;
                playersArr[_loc_2].beKilled(1);
            }
            else
            {
                _loc_5 = "没有人被公决！";
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_5);
            return;
        }// end function

        private function deadOne(param1:Object) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = param1.sysMsg;
            if (param1.Site != 0)
            {
                _loc_3 = playersArr[param1.Site].playerInfo.UserName;
                playersArr[param1.Site].toolsid = 0;
                playersArr[param1.Site].isCanClick = false;
                playersArr[param1.Site].beKilled(param1.Type);
            }
            else
            {
                _loc_2 = "没有人被公决！";
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_2);
            return;
        }// end function

        private function killOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            if (_loc_2 != 0)
            {
                _loc_4 = playersArr[_loc_2].playerInfo.UserName;
                _loc_5 = this.getStringIden(_loc_3);
                if (param1.IsB == 1)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 受到\'护体\'影响一起被杀害！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else if (param1.IsB == 12)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 受到\'恋爱关系\'影响一起被杀害！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else if (param1.IsB == 13)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 为了爱人挡刀 被杀害！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 被‘杀手’杀害<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                playersArr[_loc_2].toolsid = 0;
                playersArr[_loc_2].isCanClick = false;
                playersArr[_loc_2].iden = _loc_3;
                playersArr[_loc_2].beKilled(2);
            }
            else
            {
                _loc_5 = "平安夜, 没有人被杀害！";
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_5);
            return;
        }// end function

        private function snipeOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            if (_loc_2 != 0)
            {
                _loc_4 = playersArr[_loc_2].playerInfo.UserName;
                _loc_5 = this.getStringIden(_loc_3);
                if (param1.IsB == 1)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 受到\'护体\'影响一起被狙！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else if (param1.IsB == 12)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 受到\'恋爱关系\'影响一起被狙！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else if (param1.IsB == 13)
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 为了爱人挡枪 被狙！<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                else
                {
                    _loc_5 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_4 + " ]</b></font> 被 ‘狙击手’爆头<font color=\'#ffffff\'>其身份</font> " + _loc_5;
                }
                playersArr[_loc_2].toolsid = 0;
                playersArr[_loc_2].isCanClick = false;
                playersArr[_loc_2].iden = _loc_3;
                playersArr[_loc_2].beKilled(3);
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_5);
                if (UserData.UserPlayerIden == 6)
                {
                    KillerRoomData.firstGamePrompt("狙杀玩家完成，等待倒计时结束", KillerRoomData.UserPlayerID);
                }
            }
            return;
        }// end function

        private function ExplosionOne(param1:Object) : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_2:String = "";
            if (param1.IsB == 1 || param1.IsB == 12)
            {
                _loc_3 = playersArr[param1.Site].playerInfo.UserName;
                _loc_4 = this.getStringIden(param1.Iden);
                if (param1.IsB == 1)
                {
                    _loc_2 = "<font color=\'#FFFF00\'><b>[" + param1.Site + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_3 + " ]</b></font> 受到\'护体\'影响一起被爆！<font color=\'#ffffff\'>其身份</font> " + _loc_4;
                }
                else if (param1.IsB == 12)
                {
                    _loc_2 = "<font color=\'#FFFF00\'><b>[" + param1.Site + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_3 + " ]</b></font> 受到\'恋爱关系\'影响一起被爆！<font color=\'#ffffff\'>其身份</font> " + _loc_4;
                }
                playersArr[param1.Site].toolsid = 0;
                playersArr[param1.Site].isCanClick = false;
                playersArr[param1.Site].iden = param1.Iden;
                playersArr[param1.Site].beKilled(10);
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_2);
                return;
            }
            if (param1.Site != 0 && playersArr[param1.Site])
            {
                _loc_5 = playersArr[param1.Site].playerInfo.UserName;
                _loc_6 = this.getStringIden(param1.Iden);
                playersArr[param1.Site].toolsid = 0;
                playersArr[param1.Site].isCanClick = false;
                playersArr[param1.Site].iden = param1.Iden;
                playersArr[param1.Site].beKilled(10);
                _loc_2 = "<font color=\'#FFFF00\'><b>[" + param1.Site + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 自杀身亡<font color=\'#ffffff\'>其身份</font> " + _loc_6;
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_2);
                if (UserData.UserPlayerIden == 10)
                {
                    KillerRoomData.firstGamePrompt("牺牲自己爆死对方完成，等待倒计时结束", KillerRoomData.UserPlayerID);
                }
            }
            if (param1.Site2 != 0 && playersArr[param1.Site2])
            {
                _loc_7 = playersArr[param1.Site2].playerInfo.UserName;
                _loc_8 = this.getStringIden(param1.Iden2);
                playersArr[param1.Site2].toolsid = 0;
                playersArr[param1.Site2].isCanClick = false;
                playersArr[param1.Site2].iden = param1.Iden2;
                playersArr[param1.Site2].beKilled(10);
                if (param1.IsB == 13)
                {
                    _loc_2 = "<font color=\'#FFFF00\'><b>[" + param1.Site2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_7 + " ]</b></font> 为了爱人 被爆！<font color=\'#ffffff\'>其身份</font> " + _loc_8;
                }
                else
                {
                    _loc_2 = "<font color=\'#FFFF00\'><b>[" + param1.Site2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_7 + " ]</b></font> 被 \'恐怖份子\' 爆死<font color=\'#ffffff\'>其身份</font> " + _loc_8;
                }
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_2);
            }
            return;
        }// end function

        private function gagOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            _loc_2 = param1.Site;
            if (_loc_2 != 0)
            {
                if (_loc_2 == KillerRoomData.UserPlayerID)
                {
                    KillerRoomData.isBeGaged = true;
                }
                if (param1.isRogue)
                {
                    _loc_4 = "<font color=\'#FF0000\'><b>盗贼</b></font>";
                }
                else
                {
                    _loc_4 = "<font color=\'#0099FF\'><b>森林老人</b></font>";
                }
                _loc_5 = playersArr[_loc_2].playerInfo.UserName;
                _loc_6 = "<font color=\'#FF0000\'><b>[提示] </b><font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " \'禁言\' 了.</font>";
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_6);
            }
            return;
        }// end function

        private function saveOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            _loc_2 = param1.Site;
            if (_loc_2 != 0)
            {
                if (param1.isRogue)
                {
                    _loc_4 = "<font color=\'#FF0000\'><b>盗贼</b></font>";
                }
                else
                {
                    _loc_4 = "<font color=\'#0099FF\'><b>医生</b></font>";
                }
                _loc_5 = playersArr[_loc_2].playerInfo.UserName;
                _loc_7 = "";
                if (uint(param1.Type) == 1)
                {
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " 救活，险些被杀死.";
                    playersArr[_loc_2].toBeSave(1);
                }
                else if (uint(param1.Type) == 6)
                {
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被狙杀，" + _loc_4 + " 也没能救活.";
                }
                else if (uint(param1.Type) == 7)
                {
                    _loc_6 = this.getStringIden(uint(param1.Iden));
                    if (param1.IsB == 12)
                    {
                        _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 受到\'恋爱关系\'影响一起被扎死了,<font color=\'#ffffff\'>身份</font> " + _loc_6;
                    }
                    else if (param1.IsB == 13)
                    {
                        _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 为了爱情替爱人 被 " + _loc_4 + " 扎死,<font color=\'#ffffff\'>身份</font> " + _loc_6;
                    }
                    else
                    {
                        _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " 二空针扎死了,<font color=\'#ffffff\'>身份</font> " + _loc_6;
                    }
                    playersArr[_loc_2].iden = uint(param1.Iden);
                    playersArr[_loc_2].toBeSave(7);
                }
                else if (uint(param1.Type) == 0)
                {
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " 扎了一空针.";
                    playersArr[_loc_2].toBeSave(0);
                }
                else if (uint(param1.Type) == 10)
                {
                    _loc_6 = this.getStringIden(uint(param1.Iden));
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " 二空针扎死了,<font color=\'#ffffff\'>身份</font> " + _loc_6;
                    playersArr[_loc_2].iden = uint(param1.Iden);
                    playersArr[_loc_2].toBeSave(7);
                    this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_7);
                    _loc_6 = this.getStringIden(uint(param1.Iden2));
                    _loc_5 = playersArr[param1.Site2].playerInfo.UserName;
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + param1.Site2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 受到恐怖份子自爆身亡,<font color=\'#ffffff\'>身份</font> " + _loc_6;
                    playersArr[param1.Site2].iden = uint(param1.Iden2);
                    playersArr[param1.Site2].beKilled(10);
                }
                else if (uint(param1.Type) == 11)
                {
                    _loc_7 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被暗杀，" + _loc_4 + " 也没能救活.";
                }
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_7);
            }
            return;
        }// end function

        private function vote(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            var _loc_4:String = "";
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.votes;
                playersArr[param1.P1].voteNum = param1.P2;
                if (KillerRoomData.isKillGameType)
                {
                    _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 怀疑 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> 是杀手！";
                }
                KillerRoomData.firstGamePrompt("投票完成，玩家累计超过50%票数，\n倒计时结束后则会被公决", param1.P1);
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.votes;
                playersArr[param1.P1].voteNum = 0;
                if (KillerRoomData.isKillGameType)
                {
                    _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 取消对 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> 的怀疑！";
                }
                KillerRoomData.firstGamePrompt("白天来了，选择怀疑玩家进行投票公决", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.votes;
                playersArr[param1.P1].voteNum = 0;
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, _loc_4);
            return;
        }// end function

        private function kill(param1:Object) : void
        {
            var _loc_5:Boolean = false;
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            var _loc_4:String = "";
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.kills;
                playersArr[param1.P1].voteNum = param1.P2;
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 想杀 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> ！";
                _loc_5 = KillerRoomData.firstGamePrompt("已选择被杀对象，等待倒计时结束", param1.P1);
                if (_loc_5)
                {
                    facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_ONE, new NewUserTaskStepVO(0, "等待倒计时结束", 5));
                }
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.kills;
                playersArr[param1.P1].voteNum = 0;
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 取消对 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> 的行凶！";
                KillerRoomData.firstGamePrompt("点击任意玩家形象，杀了他！", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.kills;
                playersArr[param1.P1].voteNum = 0;
            }
            this.sendNotification(KillerRoomEvents.SCHATBOXMSG, _loc_4);
            return;
        }// end function

        private function check(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            var _loc_4:String = "";
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.checks;
                playersArr[param1.P1].voteNum = param1.P2;
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 想查 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> ！";
                KillerRoomData.firstGamePrompt("已查验玩家身份,等待倒计时结束。", param1.P1);
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.checks;
                playersArr[param1.P1].voteNum = 0;
                _loc_4 = "<font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_2 + "]</b></font> 取消对 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[" + _loc_3 + "]</b></font> 的怀疑！";
                KillerRoomData.firstGamePrompt("点击任意玩家形象，查看他的身份！", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.checks;
                playersArr[param1.P1].voteNum = 0;
            }
            this.sendNotification(KillerRoomEvents.JCHATBOXMSG, _loc_4);
            return;
        }// end function

        private function checked(param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            _loc_2 = param1.UserName;
            _loc_3 = param1.Iden;
            _loc_4 = param1.Site;
            var _loc_5:String = "";
            if (playersArr[_loc_4])
            {
                playersArr[_loc_4].iden = _loc_3;
                playersArr[_loc_4].cheked();
                _loc_5 = playersArr[_loc_4].playerInfo.UserName;
            }
            var _loc_6:* = this.getStringIden(_loc_3);
            _loc_6 = "查出<font color=\'#FFFF00\'>[" + _loc_4 + "]</b></font><font color=\'#99FF00\'><b>" + _loc_5 + "</b></font> 的身份为 " + _loc_6;
            this.sendNotification(KillerRoomEvents.JCHATBOXMSG, _loc_6);
            KillerRoomData.firstGamePrompt("已查验玩家身份,等待倒计时结束。");
            return;
        }// end function

        private function getStringIden(param1:int) : String
        {
            var _loc_2:String = "";
            if (param1 == 1)
            {
                _loc_2 = "<font color=\'#FFcc00\'><b>‘平民’</b></font>！";
            }
            else if (param1 == 2)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘警察’</b></font>！";
            }
            else if (param1 == 3)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>‘杀手’</b></font>！";
            }
            else if (param1 == 6)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>‘狙击手’</b></font>！";
            }
            else if (param1 == 7)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘医生’</b></font>！";
            }
            else if (param1 == 8)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘花蝴蝶’</b></font>！";
            }
            else if (param1 == 9)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘森林老人’</b></font>！";
            }
            else if (param1 == 10)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>‘恐怖份子’</b></font>！";
            }
            else if (param1 == 11)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘特工’</b></font>！";
            }
            else if (param1 == 12)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘丘比特’</b></font>！";
            }
            else if (param1 == 13)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>‘间谍’</b></font>！";
            }
            else if (param1 == 14)
            {
                _loc_2 = "<font color=\'#0099FF\'><b>‘市长’</b></font>！";
            }
            else if (param1 == 15)
            {
                _loc_2 = "<font color=\'#FF0000\'><b>‘盗贼’</b></font>！";
            }
            return _loc_2;
        }// end function

        private function Snipe(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            var _loc_4:String = "";
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.snipes;
                playersArr[param1.P1].voteNum = param1.P2;
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.snipes;
                playersArr[param1.P1].voteNum = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.snipes;
                playersArr[param1.P1].voteNum = 0;
            }
            return;
        }// end function

        private function Save(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            var _loc_4:String = "";
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.saves;
                playersArr[param1.P1].voteNum = param1.P2;
                KillerRoomData.firstGamePrompt("选择针救的玩家完成，等待倒计时结束", param1.P1);
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.saves;
                playersArr[param1.P1].voteNum = 0;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行针救\n救活被杀玩家，累计2空针可针死玩家", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.saves;
                playersArr[param1.P1].voteNum = 0;
            }
            return;
        }// end function

        private function Barrier(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.barriers;
                playersArr[param1.P1].voteNum = param1.P2;
                KillerRoomData.firstGamePrompt("选择保护的玩家完成，等待倒计时结束", param1.P1);
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.barriers;
                playersArr[param1.P1].voteNum = 0;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行保护", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.barriers;
                playersArr[param1.P1].voteNum = 0;
            }
            return;
        }// end function

        private function Gag(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            if (param1.isClick == 1)
            {
                playersArr[param1.P2].vote = param1.gags;
                playersArr[param1.P1].voteNum = param1.P2;
                KillerRoomData.firstGamePrompt("选择禁言的玩家完成，等待倒计时结束", param1.P1);
            }
            else if (param1.isClick == 0)
            {
                playersArr[param1.P2].vote = param1.gags;
                playersArr[param1.P1].voteNum = 0;
                KillerRoomData.firstGamePrompt("点击任意玩家形象，进行禁言\n被禁言白天不能发言(下个黑夜自动解除)", param1.P1);
            }
            else
            {
                KillerRoomData.votePlayerID = 0;
                playersArr[param1.P2].vote = param1.gags;
                playersArr[param1.P1].voteNum = 0;
            }
            return;
        }// end function

        private function sAgentKillOne(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            _loc_2 = param1.Site;
            _loc_3 = param1.Iden;
            if (_loc_2 != 0)
            {
                if (param1.isRogue)
                {
                    _loc_4 = "<font color=\'#FF0000\'><b>盗贼</b></font>";
                }
                else
                {
                    _loc_4 = "<font color=\'#0099FF\'><b>特工</b></font>";
                }
                _loc_5 = playersArr[_loc_2].playerInfo.UserName;
                _loc_6 = this.getStringIden(_loc_3);
                if (param1.IsB == 12)
                {
                    _loc_6 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 受到\'恋爱关系\'影响一起被 " + _loc_4 + " 暗杀！<font color=\'#ffffff\'>其身份</font> " + _loc_6;
                }
                else if (param1.IsB == 13)
                {
                    _loc_6 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 为了爱人挡枪 被 " + _loc_4 + " 暗杀！<font color=\'#ffffff\'>其身份</font> " + _loc_6;
                }
                else
                {
                    _loc_6 = "<font color=\'#FFFF00\'><b>[" + _loc_2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_5 + " ]</b></font> 被 " + _loc_4 + " 暗杀<font color=\'#ffffff\'>其身份</font> " + _loc_6;
                }
                playersArr[_loc_2].toolsid = 0;
                playersArr[_loc_2].isCanClick = false;
                playersArr[_loc_2].iden = _loc_3;
                playersArr[_loc_2].beKilled(11);
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_6);
                if (UserData.UserPlayerIden == 10)
                {
                    KillerRoomData.firstGamePrompt("暗杀完成，等待倒计时结束", KillerRoomData.UserPlayerID);
                }
            }
            else
            {
                KillerRoomData.firstGamePrompt("");
            }
            return;
        }// end function

        private function spyCheck(param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            _loc_2 = param1.UserName;
            _loc_3 = param1.Iden;
            _loc_4 = param1.Site;
            var _loc_5:String = "";
            if (playersArr[_loc_4])
            {
                playersArr[_loc_4].iden = _loc_3;
                playersArr[_loc_4].cheked();
                _loc_5 = playersArr[_loc_4].playerInfo.UserName;
            }
            var _loc_6:* = this.getStringIden(_loc_3);
            var _loc_7:* = new Object();
            new Object().code = "";
            _loc_7.arr = null;
            _loc_7.msg = "查出<font color=\'#FFFF00\'><b>[" + _loc_4 + "]</b></font><font color=\'#99FF00\'><b>" + _loc_5 + "</b></font> 的身份为 " + _loc_6;
            this.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_7);
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_7.msg);
            KillerRoomData.firstGamePrompt("查看身份完成，等待倒计时结束");
            return;
        }// end function

        private function cupidAct(param1:Object) : void
        {
            var _loc_2:* = playersArr[param1.P1].playerInfo.UserName;
            var _loc_3:* = playersArr[param1.P2].playerInfo.UserName;
            playersArr[param1.P2].toBeCupid();
            playersArr[param1.P1].toBeCupid();
            var _loc_4:String = "达成恋爱关系";
            if (playersArr[param1.P1].playerInfo.UserId == UserData.UserInfo.UserId)
            {
                _loc_4 = "您与 <font color=\'#FFFF00\'><b>[" + param1.P2 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_3 + " ]</b></font>" + _loc_4;
            }
            else
            {
                _loc_4 = "您与 <font color=\'#FFFF00\'><b>[" + param1.P1 + "]</b></font><font color=\'#99FF00\'><b>[ " + _loc_2 + " ]</b></font>" + _loc_4;
            }
            this.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'><b>[提示] </b>" + _loc_4);
            if (UserData.UserPlayerIden == 12)
            {
                KillerRoomData.firstGamePrompt("选择恋爱对象完成，等待倒计时结束");
            }
            return;
        }// end function

        private function setGView(param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:uint = 0;
            for (_loc_2 in param1)
            {
                
                _loc_3 = int(param1[_loc_2]);
                if (playersArr[_loc_3])
                {
                    playersArr[_loc_3].states = 1;
                }
            }
            return;
        }// end function

        private function sendTools(param1:uint, param2:uint, param3:String) : void
        {
            playersArr[param1].sendTool(param2);
            return;
        }// end function

        private function actionTools(param1:Object) : void
        {
            var PIPs:Array;
            var TID:uint;
            var AT:uint;
            var INTEG:int;
            var UINTEG:int;
            var UIP:uint;
            var str:String;
            var timer:Timer;
            var data:* = param1;
            if (UserData.UserRoom != 0)
            {
                PIPs = data.ToSite;
                TID = data.ToolId;
                AT = data.ActionType;
                INTEG = data.Integral;
                UINTEG;
                UIP = data.FromSite;
                if (UIP == uint(RoomData.Rooms.UserPlayerID))
                {
                    this.sendNotification(KillerRoomEvents.TOOLSLIST_TOOL_USED, TID);
                }
                if (PIPs.length == 0)
                {
                    return;
                }
                if (playersArr[UIP])
                {
                    playersArr[UIP].sendTool(PIPs[0].Site);
                }
                str = "<font color=\'#FF0000\'>[提示]</b></font> " + data.Msg;
                this.sendNotification(KillerRoomEvents.SYSBOXMSG, str);
                timer = new Timer(1000, 1);
                with ({})
                {
                    {}.e = function (event:TimerEvent)
            {
                var i:String;
                var PIP:uint;
                var FACEURL:String;
                var Say:String;
                var TOOLSURL:String;
                var TYPES:uint;
                var toolid:uint;
                var oldUrl:String;
                var thisFrameI:uint;
                var _enterHandler:*;
                var e:* = event;
                if (UserData.UserRoom != 0)
                {
                    if (AT == 9)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (playersArr[PIPs[i].Site])
                            {
                                KillerRoomData.beTooledpName = playersArr[PIPs[i].Site].playerInfo.UserName;
                                playersArr[PIPs[i].Site].toolface = PIPs[i].AfterUrl;
                                playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                if (PIPs[i].Url && PIPs[i].Url != "undefined" && PIPs[i].Url != "null")
                                {
                                    ViewPicLoad.load(PIPs[i].Url + "?msg=" + PIPs[i].Msg, viewComponent);
                                }
                            }
                        }
                        return;
                    }
                    if (AT == 7)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (playersArr[PIPs[i].Site])
                            {
                                if (PIPs[i].Url == "/resource/tool/217.swf")
                                {
                                    mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    if (playersArr[PIPs[i].Site].isShowTool)
                                    {
                                        ViewPicLoad.load("/resource/tool/217.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    }
                                    continue;
                                }
                                if (PIPs[i].Url == "/resource/tool/746.swf")
                                {
                                    playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                    playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                    mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    if (playersArr[PIPs[i].Site].isShowTool)
                                    {
                                        ViewPicLoad.load("/resource/tool/746.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    }
                                    continue;
                                }
                                if (playersArr[PIPs[i].Site])
                                {
                                    playersArr[PIPs[i].Site].toolface = PIPs[i].AfterUrl;
                                    playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                    playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                    TOOLSURL = PIPs[i].Url + "?msg=" + PIPs[i].Msg;
                                }
                            }
                        }
                        ViewPicLoad.load(TOOLSURL, viewComponent);
                        return;
                    }
                    if (AT == 10)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (PIPs[i].Site && playersArr[PIPs[i].Site])
                            {
                                mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                ViewPicLoad.load("/resource/tool/face/changeskin.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                playersArr[PIPs[i].Site].toolFigure(PIPs[i].Url);
                                playersArr[PIPs[i].Site].toolsid = TID;
                            }
                        }
                        return;
                    }
                    if (AT == 11)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (PIPs[i].Site && playersArr[PIPs[i].Site])
                            {
                                mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                ViewPicLoad.load("/resource/tool/face/ghostskinanim.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                playersArr[PIPs[i].Site].changePlayerType();
                                playersArr[PIPs[i].Site].toolsid = TID;
                            }
                        }
                        return;
                    }
                    var _loc_3:int = 0;
                    var _loc_4:* = PIPs;
                    while (_loc_4 in _loc_3)
                    {
                        
                        i = _loc_4[_loc_3];
                        if (PIPs[i].Site && playersArr[PIPs[i].Site])
                        {
                            PIP = PIPs[i].Site;
                            FACEURL = PIPs[i].AfterUrl;
                            Say;
                            if (PIPs[i].Say && PIPs[i].Say != "")
                            {
                                Say = PIPs[i].Say;
                            }
                            TOOLSURL = PIPs[i].Url + "?msg=" + Say;
                            TYPES = uint(PIPs[i].ToolMc);
                            if (uint(TID) == 744)
                            {
                                playersArr[PIPs[i].Site].changePlayerType();
                            }
                            playersArr[PIP].inter = String(PIPs[i].Integral);
                            playersArr[PIP].interOther = int(PIPs[i].SkillIntegral);
                            if (FACEURL != "")
                            {
                                playersArr[PIP].toolface = FACEURL;
                            }
                            if (playersArr[PIP].isShowTool)
                            {
                                if (TOOLSURL != "")
                                {
                                    toolid = playersArr[PIP].toolsid;
                                    if (int(TYPES) == 0)
                                    {
                                        if (TID == toolid)
                                        {
                                            if (playersArr[PIP].theViewer.thetools_mc.numChildren > 0)
                                            {
                                                oldUrl = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).loaderInfo.url;
                                                if (oldUrl.substr(oldUrl.indexOf("tool")) == TOOLSURL.substr(TOOLSURL.indexOf("tool")))
                                                {
                                                    thisFrameI = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.currentFrame;
                                                    _enterHandler = function (event:Event)
                {
                    var frameI:uint;
                    var tool_copy:DisplayObject;
                    var evt:* = event;
                    try
                    {
                        frameI = evt.target.currentFrame;
                        if (thisFrameI != frameI)
                        {
                            tool_copy = mcFunc.copyDisplayObject(evt.target as DisplayObject, true);
                            tool_copy.addEventListener(Event.ENTER_FRAME, toolcopyEnterFrameHandler);
                        }
                        else
                        {
                            evt.target.play();
                        }
                    }
                    catch (e)
                    {
                    }
                    evt.target.removeEventListener(Event.ENTER_FRAME, _enterHandler);
                    return;
                }// end function
                ;
                                                    playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.addEventListener(Event.ENTER_FRAME, _enterHandler);
                                                }
                                                else
                                                {
                                                    mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                                    ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                                }
                                            }
                                            else
                                            {
                                                ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                            }
                                        }
                                        else
                                        {
                                            playersArr[PIP].toolsid = TID;
                                            mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                            ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                        }
                                        continue;
                                    }
                                    if (int(TYPES) == 1)
                                    {
                                        if (TID == toolid)
                                        {
                                            if (playersArr[PIP].theViewer.thetools_mc.numChildren > 0)
                                            {
                                                oldUrl = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).loaderInfo.url;
                                                if (oldUrl.substr(oldUrl.indexOf("tool")) == TOOLSURL.substr(TOOLSURL.indexOf("tool")))
                                                {
                                                    thisFrameI = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.currentFrame;
                                                    _enterHandler = function (event:Event)
                {
                    var frameI:uint;
                    var tool_copy:DisplayObject;
                    var evt:* = event;
                    try
                    {
                        frameI = evt.target.currentFrame;
                        if (thisFrameI != frameI)
                        {
                            tool_copy = mcFunc.copyDisplayObject(evt.target as DisplayObject, true);
                            tool_copy.addEventListener(Event.ENTER_FRAME, toolcopyEnterFrameHandler);
                        }
                        else
                        {
                            evt.target.play();
                        }
                    }
                    catch (e)
                    {
                    }
                    evt.target.removeEventListener(Event.ENTER_FRAME, _enterHandler);
                    return;
                }// end function
                ;
                                                    playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.addEventListener(Event.ENTER_FRAME, _enterHandler);
                                                }
                                                else
                                                {
                                                    mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                                    ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                                }
                                            }
                                            else
                                            {
                                                ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                            }
                                            continue;
                                        }
                                        playersArr[PIP].toolsid = TID;
                                        mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                        ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                    }
                                }
                            }
                        }
                    }
                }
                return;
            }// end function
            ;
                }
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent)
            {
                var i:String;
                var PIP:uint;
                var FACEURL:String;
                var Say:String;
                var TOOLSURL:String;
                var TYPES:uint;
                var toolid:uint;
                var oldUrl:String;
                var thisFrameI:uint;
                var _enterHandler:*;
                var e:* = event;
                if (UserData.UserRoom != 0)
                {
                    if (AT == 9)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (playersArr[PIPs[i].Site])
                            {
                                KillerRoomData.beTooledpName = playersArr[PIPs[i].Site].playerInfo.UserName;
                                playersArr[PIPs[i].Site].toolface = PIPs[i].AfterUrl;
                                playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                if (PIPs[i].Url && PIPs[i].Url != "undefined" && PIPs[i].Url != "null")
                                {
                                    ViewPicLoad.load(PIPs[i].Url + "?msg=" + PIPs[i].Msg, viewComponent);
                                }
                            }
                        }
                        return;
                    }
                    if (AT == 7)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (playersArr[PIPs[i].Site])
                            {
                                if (PIPs[i].Url == "/resource/tool/217.swf")
                                {
                                    mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    if (playersArr[PIPs[i].Site].isShowTool)
                                    {
                                        ViewPicLoad.load("/resource/tool/217.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    }
                                    continue;
                                }
                                if (PIPs[i].Url == "/resource/tool/746.swf")
                                {
                                    playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                    playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                    mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    if (playersArr[PIPs[i].Site].isShowTool)
                                    {
                                        ViewPicLoad.load("/resource/tool/746.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                    }
                                    continue;
                                }
                                if (playersArr[PIPs[i].Site])
                                {
                                    playersArr[PIPs[i].Site].toolface = PIPs[i].AfterUrl;
                                    playersArr[PIPs[i].Site].inter = String(PIPs[i].Integral);
                                    playersArr[PIPs[i].Site].interOther = int(PIPs[i].SkillIntegral);
                                    TOOLSURL = PIPs[i].Url + "?msg=" + PIPs[i].Msg;
                                }
                            }
                        }
                        ViewPicLoad.load(TOOLSURL, viewComponent);
                        return;
                    }
                    if (AT == 10)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (PIPs[i].Site && playersArr[PIPs[i].Site])
                            {
                                mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                ViewPicLoad.load("/resource/tool/face/changeskin.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                playersArr[PIPs[i].Site].toolFigure(PIPs[i].Url);
                                playersArr[PIPs[i].Site].toolsid = TID;
                            }
                        }
                        return;
                    }
                    if (AT == 11)
                    {
                        var _loc_3:int = 0;
                        var _loc_4:* = PIPs;
                        while (_loc_4 in _loc_3)
                        {
                            
                            i = _loc_4[_loc_3];
                            if (PIPs[i].Site && playersArr[PIPs[i].Site])
                            {
                                mcFunc.removeAllMc(playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                ViewPicLoad.load("/resource/tool/face/ghostskinanim.swf", playersArr[PIPs[i].Site].theViewer.thetools_mc);
                                playersArr[PIPs[i].Site].changePlayerType();
                                playersArr[PIPs[i].Site].toolsid = TID;
                            }
                        }
                        return;
                    }
                    var _loc_3:int = 0;
                    var _loc_4:* = PIPs;
                    while (_loc_4 in _loc_3)
                    {
                        
                        i = _loc_4[_loc_3];
                        if (PIPs[i].Site && playersArr[PIPs[i].Site])
                        {
                            PIP = PIPs[i].Site;
                            FACEURL = PIPs[i].AfterUrl;
                            Say;
                            if (PIPs[i].Say && PIPs[i].Say != "")
                            {
                                Say = PIPs[i].Say;
                            }
                            TOOLSURL = PIPs[i].Url + "?msg=" + Say;
                            TYPES = uint(PIPs[i].ToolMc);
                            if (uint(TID) == 744)
                            {
                                playersArr[PIPs[i].Site].changePlayerType();
                            }
                            playersArr[PIP].inter = String(PIPs[i].Integral);
                            playersArr[PIP].interOther = int(PIPs[i].SkillIntegral);
                            if (FACEURL != "")
                            {
                                playersArr[PIP].toolface = FACEURL;
                            }
                            if (playersArr[PIP].isShowTool)
                            {
                                if (TOOLSURL != "")
                                {
                                    toolid = playersArr[PIP].toolsid;
                                    if (int(TYPES) == 0)
                                    {
                                        if (TID == toolid)
                                        {
                                            if (playersArr[PIP].theViewer.thetools_mc.numChildren > 0)
                                            {
                                                oldUrl = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).loaderInfo.url;
                                                if (oldUrl.substr(oldUrl.indexOf("tool")) == TOOLSURL.substr(TOOLSURL.indexOf("tool")))
                                                {
                                                    thisFrameI = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.currentFrame;
                                                    _enterHandler = function (event:Event)
                {
                    var frameI:uint;
                    var tool_copy:DisplayObject;
                    var evt:* = event;
                    try
                    {
                        frameI = evt.target.currentFrame;
                        if (thisFrameI != frameI)
                        {
                            tool_copy = mcFunc.copyDisplayObject(evt.target as DisplayObject, true);
                            tool_copy.addEventListener(Event.ENTER_FRAME, toolcopyEnterFrameHandler);
                        }
                        else
                        {
                            evt.target.play();
                        }
                    }
                    catch (e)
                    {
                    }
                    evt.target.removeEventListener(Event.ENTER_FRAME, _enterHandler);
                    return;
                }// end function
                ;
                                                    playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.addEventListener(Event.ENTER_FRAME, _enterHandler);
                                                }
                                                else
                                                {
                                                    mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                                    ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                                }
                                            }
                                            else
                                            {
                                                ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                            }
                                        }
                                        else
                                        {
                                            playersArr[PIP].toolsid = TID;
                                            mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                            ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                        }
                                        continue;
                                    }
                                    if (int(TYPES) == 1)
                                    {
                                        if (TID == toolid)
                                        {
                                            if (playersArr[PIP].theViewer.thetools_mc.numChildren > 0)
                                            {
                                                oldUrl = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).loaderInfo.url;
                                                if (oldUrl.substr(oldUrl.indexOf("tool")) == TOOLSURL.substr(TOOLSURL.indexOf("tool")))
                                                {
                                                    thisFrameI = playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.currentFrame;
                                                    _enterHandler = function (event:Event)
                {
                    var frameI:uint;
                    var tool_copy:DisplayObject;
                    var evt:* = event;
                    try
                    {
                        frameI = evt.target.currentFrame;
                        if (thisFrameI != frameI)
                        {
                            tool_copy = mcFunc.copyDisplayObject(evt.target as DisplayObject, true);
                            tool_copy.addEventListener(Event.ENTER_FRAME, toolcopyEnterFrameHandler);
                        }
                        else
                        {
                            evt.target.play();
                        }
                    }
                    catch (e)
                    {
                    }
                    evt.target.removeEventListener(Event.ENTER_FRAME, _enterHandler);
                    return;
                }// end function
                ;
                                                    playersArr[PIP].theViewer.thetools_mc.getChildAt(0).mc.addEventListener(Event.ENTER_FRAME, _enterHandler);
                                                }
                                                else
                                                {
                                                    mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                                    ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                                }
                                            }
                                            else
                                            {
                                                ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                            }
                                            continue;
                                        }
                                        playersArr[PIP].toolsid = TID;
                                        mcFunc.removeAllMc(playersArr[PIP].theViewer.thetools_mc);
                                        ViewPicLoad.load(TOOLSURL, playersArr[PIP].theViewer.thetools_mc);
                                    }
                                }
                            }
                        }
                    }
                }
                return;
            }// end function
            );
                timer.start();
            }
            return;
        }// end function

        private function toolcopyEnterFrameHandler(event:Event) : void
        {
            var _loc_2:* = event.target as MovieClip;
            if (_loc_2.currentFrame == _loc_2.totalFrames || _loc_2.currentFrameLabel == "firstStop")
            {
                _loc_2.removeEventListener(Event.ENTER_FRAME, this.toolcopyEnterFrameHandler);
                if (_loc_2.parent)
                {
                    if (_loc_2 is Sprite || _loc_2 is MovieClip)
                    {
                        _loc_2.soundTransform = new SoundTransform(0);
                    }
                    _loc_2.parent.removeChild(_loc_2);
                }
            }
            return;
        }// end function

        private function clearOnePlayer(param1:String) : void
        {
            if (playersArr[param1])
            {
                if (mcFunc.hasTheChlid(playersArr[param1].theViewer, this.players_frame1))
                {
                    playersArr[param1].clear();
                    this.players_frame1.removeChild(playersArr[param1].theViewer);
                }
                if (mcFunc.hasTheChlid(playersArr[param1].theViewer, this.players_frame2))
                {
                    playersArr[param1].clear();
                    this.players_frame2.removeChild(playersArr[param1].theViewer);
                }
                if (mcFunc.hasTheChlid(playersArr[param1].theViewer, this.players_frame3))
                {
                    playersArr[param1].clear();
                    this.players_frame3.removeChild(playersArr[param1].theViewer);
                }
                playersArr[param1] = null;
            }
            return;
        }// end function

    }
}
