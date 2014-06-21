package model
{
    import Core.*;
    import Core.controller.*;
    import Core.model.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import roomEvents.*;
    import uas.*;
    import view.*;

    dynamic public class KillerRoomClient extends AbsClient
    {

        public function KillerRoomClient()
        {
            return;
        }// end function

        override public function AlertGameMsg(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = "";
            _loc_2.arr = null;
            _loc_2.msg = param1["Msg"];
            facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            if (param1["IsSys"])
            {
                facade.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'>[提示] " + param1["Msg"] + "</font>  ");
            }
            return;
        }// end function

        public function IdenActFail(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_ACTFAIL, param1);
            return;
        }// end function

        public function CanNotKillerAct(param1:Object) : void
        {
            var _loc_2:String = null;
            if (param1.now)
            {
                _loc_2 = "全城戒备晚上杀手阵营禁止行动";
            }
            else
            {
                _loc_2 = "市长被杀，全城戒备下个晚上杀手阵营禁止行动";
            }
            facade.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'>[提示] " + _loc_2 + "</font>  ");
            var _loc_3:* = new Object();
            _loc_3.code = "";
            _loc_3.arr = null;
            _loc_3.msg = _loc_2;
            facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_3);
            return;
        }// end function

        public function MobileVoice(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.CHATBOXVOICE, param1);
            return;
        }// end function

        public function WaitKickMaster(param1:Object) : void
        {
            facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, {func:this.KickMaster, arr:param1, msg:param1.Msg});
            return;
        }// end function

        public function KickMaster(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.cmd = "KickUser";
            _loc_2.UserId = String(param1.UserId);
            facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function RemoteTool_Setup(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_REMOTETOOL_SETUP, param1);
            return;
        }// end function

        public function RemoteTool_Use(param1:Object) : void
        {
            facade.sendNotification(PlusMediator.ACTION, {url:Resource.HTTP + "plus/RemoteToolForm.swf", data:param1});
            return;
        }// end function

        public function MyOneTool(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_MYONETOOLNUM, param1.Tool);
            return;
        }// end function

        public function SeriesToolActStop(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_SERIESACT_STOP);
            return;
        }// end function

        public function CupidAct(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_CupidAct, param1);
            return;
        }// end function

        public function SAgentKillOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SAgentKillOne, param1);
            return;
        }// end function

        public function SpyCheck(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SPYCHECK, param1);
            return;
        }// end function

        public function PlusGameCmd(param1:Object) : void
        {
            param1.url = Resource.PlugGames[KillerRoomData.GameType].url;
            facade.sendNotification(KillerRoomPlugGameMediator.ACTION, param1);
            return;
        }// end function

        override public function ServerCmd(param1:Object) : void
        {
            return;
        }// end function

        public function SetVotedSite(param1:Object) : void
        {
            KillerRoomData.votePlayerID = int(param1.Site);
            return;
        }// end function

        public function SetOnlooker(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SET_PALYER_ONLOOKER);
            return;
        }// end function

        public function RoomMsg(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'>[提示] " + param1.Msg + "</font>  ");
            return;
        }// end function

        public function getSystemMsg(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'>[提示] </font>" + param1[0]);
            return;
        }// end function

        public function SayInRoom(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            facade.sendNotification(KillerRoomEvents.CHATBOXMSG, param1);
            return;
        }// end function

        public function LastSay(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            facade.sendNotification(KillerRoomEvents.LASTBOXMSG, param1);
            return;
        }// end function

        public function Game(param1:Object) : void
        {
            t.objToString(param1);
            if (this.hasOwnProperty(param1.Act))
            {
                var _loc_2:String = this;
                _loc_2.this[param1.Act](param1);
            }
            return;
        }// end function

        public function SayToAllJ(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            facade.sendNotification(KillerRoomEvents.JCHATBOXMSG, param1);
            return;
        }// end function

        public function SayToAllS(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            facade.sendNotification(KillerRoomEvents.SCHATBOXMSG, param1);
            return;
        }// end function

        public function SayToAllD(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            facade.sendNotification(KillerRoomEvents.DCHATBOXMSG, param1);
            return;
        }// end function

        public function Emot(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.BODYFACE, param1);
            return;
        }// end function

        public function createPlayer(param1:Object) : void
        {
            RoomData.Rooms.UserPlayerID = uint(param1[0]);
            facade.sendNotification(KillerRoomEvents.CREATPLAYER, param1);
            return;
        }// end function

        public function removePlayer(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.REMOVEPLAYER, param1[0]);
            return;
        }// end function

        public function addPlayer(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ADDPLAYER, param1);
            return;
        }// end function

        public function SetHost(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SETHOST, param1[0]);
            return;
        }// end function

        public function StartBtn(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.STARTBTN, param1);
            return;
        }// end function

        public function CloseVideo(param1:Object) : void
        {
            return;
        }// end function

        public function GetRoomInfo(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMINFO, param1[0]);
            return;
        }// end function

        public function SetRoomPower(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.HOSTPOWER);
            return;
        }// end function

        public function ShowBtn(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SHOWBTNS, param1);
            return;
        }// end function

        public function updatePlist(param1:Object) : void
        {
            KillerRoomData.RoomPlayerList = param1[0];
            facade.sendNotification(KillerRoomEvents.PLAYERLIST_DATA);
            return;
        }// end function

        public function reKickHost(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.KICKHOST, param1[0]);
            return;
        }// end function

        public function OneReady(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.PLAYERREADY, param1);
            return;
        }// end function

        public function VoteOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_VOTEONE, param1);
            return;
        }// end function

        public function Vote(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_VOTE, param1);
            return;
        }// end function

        public function KillOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_KILLONE, param1);
            return;
        }// end function

        public function Kill(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_KILL, param1);
            return;
        }// end function

        public function Check(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_CHECK, param1);
            return;
        }// end function

        public function Snipe(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SNIPE, param1);
            return;
        }// end function

        public function SnipeOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SNIPEONE, param1);
            return;
        }// end function

        public function Save(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SAVE, param1);
            return;
        }// end function

        public function SaveOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_SAVEONE, param1);
            return;
        }// end function

        public function Barrier(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_BARRIER, param1);
            return;
        }// end function

        public function Gag(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_GAG, param1);
            return;
        }// end function

        public function GagOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_GAGONE, param1);
            return;
        }// end function

        public function Explosion(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_EXPLOSION, param1);
            return;
        }// end function

        public function ExplosionOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_EXPLOSIONONE, param1);
            return;
        }// end function

        public function MayorUnVote(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_MAYORUNVOTE, param1);
            return;
        }// end function

        public function MayorAct(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_MAYORACT, param1);
            return;
        }// end function

        public function RogueAct(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_ROGUEACT, param1);
            return;
        }// end function

        public function SetGView(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SET_PALYER_VIEW, param1);
            return;
        }// end function

        public function sendTools(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_SEND, param1);
            return;
        }// end function

        public function ToolAction(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_ACT, param1);
            return;
        }// end function

        public function ActionToolsAllPlayer(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_ACT_ALLPLAYERS, param1);
            return;
        }// end function

        public function ActionToolsOneToOne(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSACT_ACT_ONE_TO_ONE, param1);
            return;
        }// end function

        public function reChgName(param1:Object) : void
        {
            facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_RECHANGENAME, param1);
            return;
        }// end function

        public function regetTool(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SYSBOXMSG, param1[0]);
            return;
        }// end function

        public function regetWedCHK(param1:String, param2:uint, param3:uint) : void
        {
            var _loc_4:Object = {kinds:"addwedding", Uname:param1, UID:param2, UIP:KillerRoomData.UserPlayerID, TID:param3};
            facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, _loc_4);
            return;
        }// end function

        public function weddingSendAcc(param1:Object) : void
        {
            facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, param1);
            return;
        }// end function

        public function reDelMarryage(param1:Boolean, param2:String) : void
        {
            var _loc_3:* = new AlertVO();
            if (param1)
            {
                _loc_3.msg = "分手成功！";
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            else
            {
                _loc_3.msg = param2;
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            return;
        }// end function

        public function reWebTools() : void
        {
            return;
        }// end function

        public function returnGetToolsList(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.TOOLSLIST_DATALIST, param1[0]);
            return;
        }// end function

        override public function MyTools(param1:Object) : void
        {
            facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, new Array(param1["Tools"], "tool"));
            facade.sendNotification(KillerRoomEvents.TOOLSLIST_DATALIST, param1["Tools"]);
            return;
        }// end function

        public function StartGame(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_STARTGAME, param1);
            return;
        }// end function

        public function IdenShow(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_GAMEIDEN, param1);
            return;
        }// end function

        public function SetOffline(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.SETOFFLINE, param1);
            return;
        }// end function

        public function GActionInfo(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.ROOMACT_GAMEINFO, param1[0]);
            return;
        }// end function

        public function JCheck(param1:Object) : void
        {
            t.obj(param1);
            facade.sendNotification(KillerRoomEvents.ROOMACT_CHECKED, param1);
            return;
        }// end function

        public function GameOver(param1:Object) : void
        {
            t.objToString(param1);
            facade.sendNotification(KillerRoomEvents.ROOMACT_GAMEOVER, param1);
            return;
        }// end function

        public function ShowMarryType(param1:Object) : void
        {
            facade.sendNotification(KillerRoomEvents.MARRY_TYPE, param1);
            return;
        }// end function

    }
}
