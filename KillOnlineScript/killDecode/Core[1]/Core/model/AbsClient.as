package Core.model
{
    import Core.*;
    import Core.controller.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.so.*;
    import Core.view.*;
    import flash.net.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.facade.*;
    import uas.*;

    dynamic public class AbsClient extends Object
    {
        protected var facade:IFacade;

        public function AbsClient()
        {
            this.facade = Facade.getInstance();
            return;
        }// end function

        public function NUAlert(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERT, param1);
            return;
        }// end function

        public function NUAlertNgotoLine(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERTGOTOLINE, param1);
            return;
        }// end function

        public function GetRoomUsers(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.ADMIN_GetRoomUsers, param1.Users);
            return;
        }// end function

        public function IntegralPlan(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.ADMIN_IntegralPlanData, param1);
            return;
        }// end function

        public function OnlineGiftPlan(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.ADMIN_OnlineGiftPlanData, param1);
            return;
        }// end function

        public function TeachCmd_Request(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_TeachVerify;
            _loc_2.data = param1;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function MyTeachers(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.MyTeachersINFO, param1);
            return;
        }// end function

        public function MyStudents(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.MyStudentsINFO, param1);
            return;
        }// end function

        public function SpyInfo(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SPYINFO_DATA, param1);
            return;
        }// end function

        public function DnInfo(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.DNINFO_DATA, param1);
            return;
        }// end function

        public function LyInfo(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.LYINFO_DATA, param1);
            return;
        }// end function

        public function OtherInfo(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.OTHERINFO_DATA, param1);
            return;
        }// end function

        public function SearchUser(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.ADMIN_USERLIST_DATA, param1.Users);
            return;
        }// end function

        public function NotReg(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADED);
            this.facade.sendNotification(GameEvents.LOGINEVENT.LOGINOUT);
            param1 = {url:Resource.CreatBoxPath, x:0, y:0};
            this.facade.sendNotification(PlusMediator.OPEN, param1);
            return;
        }// end function

        public function SO_Sync(param1:Object) : void
        {
            ServerSO.SOSync(param1);
            return;
        }// end function

        public function VoiceOpen(param1:Object) : void
        {
            param1.url = Resource.PlugPath.VoicePlusPath.url;
            param1.x = Resource.PlugPath.VoicePlusPath.x;
            param1.y = Resource.PlugPath.VoicePlusPath.y;
            param1.Server = Resource.VoiceServer;
            this.facade.sendNotification(PlusMediator.OPEN, param1);
            return;
        }// end function

        public function VoiceClose(param1:Object) : void
        {
            param1.url = Resource.PlugPath.VoicePlusPath.url;
            this.facade.sendNotification(PlusMediator.CLOSE, param1);
            return;
        }// end function

        public function close() : void
        {
            return;
        }// end function

        public function ServerKick(param1:Object) : void
        {
            NetProxy.CloseSeverMsg = String(param1.Msg);
            return;
        }// end function

        public function ServerCmd(param1:Object) : void
        {
            return;
        }// end function

        public function PlusCmd(param1:Object) : void
        {
            switch(param1.code)
            {
                default:
                {
                    this.facade.sendNotification(PlusMediator.ACTION, param1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function getRoomsList(param1:Object) : void
        {
            return;
        }// end function

        public function UserInfo(param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:SharedObject = null;
            var _loc_4:* = undefined;
            var _loc_5:NetProxy = null;
            t.obj(param1);
            for (_loc_2 in param1)
            {
                
                UserData.UserInfo[_loc_2] = param1[_loc_2];
            }
            _loc_3 = SharedObject.getLocal("u" + UserData.UserInfo.UserId);
            UserData.UserSO = SharedObject.getLocal("u" + UserData.UserInfo.UserId, "/", false);
            for (_loc_4 in _loc_3.data)
            {
                
                UserData.UserSO.data[_loc_4] = _loc_3.data[_loc_4];
            }
            _loc_3.clear();
            for (_loc_2 in param1)
            {
                
                if (_loc_2.indexOf("Game") > -1)
                {
                    if (_loc_2 == "Game10" && !UserData.UserSO.data["Game15"])
                    {
                        UserData.UserSO.data["Game15"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "Game20" && !UserData.UserSO.data["Game0"])
                    {
                        UserData.UserSO.data["Game0"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "Game30" && !UserData.UserSO.data["Game2"])
                    {
                        UserData.UserSO.data["Game2"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "Game40" && !UserData.UserSO.data["Game5"])
                    {
                        UserData.UserSO.data["Game5"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "Game50" && !UserData.UserSO.data["Game11"])
                    {
                        UserData.UserSO.data["Game11"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "Game60" && !UserData.UserSO.data["Game14"])
                    {
                        UserData.UserSO.data["Game14"] = param1[_loc_2];
                        continue;
                    }
                    if (_loc_2 == "GameBT" && !UserData.UserSO.data["Game13"])
                    {
                        UserData.UserSO.data["Game13"] = param1[_loc_2];
                    }
                }
            }
            MainData.M = int(param1.m);
            MainData.N = 111;
            _loc_5 = this.facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            _loc_5.loadUserSO();
            return;
        }// end function

        public function RN(param1:Object) : void
        {
            var _loc_2:NetProxy = null;
            trace("RN");
            trace(MainData.N);
            MainData.N = int(param1.n) + 1;
            trace(MainData.N);
            _loc_2 = this.facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            _loc_2.ReSendCmd();
            return;
        }// end function

        public function JoinHall(param1:Object) : void
        {
            this.facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.HallPath);
            return;
        }// end function

        public function setRoomList(param1:Object) : void
        {
            return;
        }// end function

        public function News(... args) : void
        {
            this.facade.sendNotification(GameEvents.NEWSLISTEVENT.NEWSMSG, args);
            return;
        }// end function

        public function SystemMsg(param1:Object) : void
        {
            param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
            this.facade.sendNotification(GameEvents.NEWSLISTEVENT.NEWSMSG, param1);
            return;
        }// end function

        public function userNews(... args) : void
        {
            this.facade.sendNotification(GameEvents.NEWSLISTEVENT.USERNEWSMSG, args);
            return;
        }// end function

        public function Speaker(param1:Object) : void
        {
            if (MainData.IsShowSpeak)
            {
                param1.Msg = ChatContrller.ChkKeyWord(param1.Msg);
                this.facade.sendNotification(GameEvents.NEWSLISTEVENT.USERNEWSMSG, param1);
            }
            return;
        }// end function

        public function AlertMsg(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = "";
            _loc_2.arr = null;
            _loc_2.msg = param1["Msg"];
            this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            return;
        }// end function

        public function AlertGameMsg(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = "";
            _loc_2.arr = null;
            _loc_2.msg = param1["Msg"];
            this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            return;
        }// end function

        public function BoxMsg(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function offonline(... args) : void
        {
            trace("offonline");
            this.facade.sendNotification(GameEvents.LOGINEVENT.LOGINOUT);
            this.facade.sendNotification(GameEvents.NEWSLISTEVENT.CLEANMSG);
            args = new AlertVO();
            args.msg = "与服务器断开！";
            args.code = ScenceLoaderMediator.LOAD;
            args.arr = Resource.LinesBoxPath;
            this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, args);
            return;
        }// end function

        public function SayToAll(param1:Object) : void
        {
            return;
        }// end function

        public function reSayTrumpet(... args) : void
        {
            args = new Object();
            args.code = null;
            args.obj = null;
            if (args[0] == 2)
            {
                args.msg = "喇叭发送失败!\n您的金币余额不足！";
            }
            else if (args[0] == 1)
            {
                args.msg = "喇叭发送成功!\n消费2个金币！";
            }
            else if (args[0] == 0)
            {
                args.msg = "喇叭发送失败!\n 网络繁忙";
            }
            this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, args);
            return;
        }// end function

        public function returnGetSkinList(... args) : void
        {
            args[1] = "skin";
            this.skinListsData(args);
            return;
        }// end function

        public function returnGetSkinToolsList(... args) : void
        {
            args[1] = "tool";
            this.skinListsData(args);
            return;
        }// end function

        public function returnGetPetList(... args) : void
        {
            args[1] = "pet";
            this.skinListsData(args);
            return;
        }// end function

        public function skinListsData(param1:Array) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, param1);
            return;
        }// end function

        public function returnGetFasList(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FRIENDLISTDATA, param1);
            return;
        }// end function

        public function ReGetFasList() : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.RELOADFRIENDLISTDATA);
            return;
        }// end function

        public function returnGetBadFasList(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.BLACKLISTDATA, param1);
            return;
        }// end function

        public function returnGetFasID(param1:Object) : void
        {
            var _loc_2:Object = null;
            if (param1.Results)
            {
                _loc_2 = {kinds:"adds", Uname:param1.F_NAME, MsgUID:param1.F_ID};
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, _loc_2);
            }
            else
            {
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, {msg:param1.STR});
            }
            return;
        }// end function

        public function receiveGamequest() : void
        {
            trace("receiveGamequest");
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function ShowUserMessage(... args) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, args[0]);
            return;
        }// end function

        public function ShowFrameBg(... args) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FBFRAME_LOADSWF, {URL:args[0], MSG:args[1]});
            return;
        }// end function

        public function ShowForeground(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FBFRAME_LOADSWF, {URL:param1.Url, MSG:param1.Msg});
            return;
        }// end function

        public function reScore(... args) : void
        {
            this.facade.sendNotification("FAMILY_CONFIRM_SCORE_RE", args);
            return;
        }// end function

        public function reFamilySendMsg(... args) : void
        {
            this.facade.sendNotification("FAMILY_CONFIRM_SEND_MSG_RE", args);
            return;
        }// end function

        public function GetUserNextNoviceTask(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.NEWUSER_TASK_RECALL, param1);
            return;
        }// end function

        public function GetUserNextNewTask(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.TASK_RECALL, param1);
            return;
        }// end function

        public function GetUserDayTask(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.TASK_RECALL, param1);
            return;
        }// end function

        public function GetUserNextToolTask(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.TASK_RECALL, param1);
            return;
        }// end function

        public function returnTaskInfo3_task(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.TASK_RECALL, param1);
            return;
        }// end function

        public function returnTaskInfo4_task(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.TASK_RECALL, param1);
            return;
        }// end function

        public function PlayerInfo(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.PLAYERINFO, param1);
            return;
        }// end function

        public function RefreshMyInfo(param1:Object) : void
        {
            UserData.updateInfo(param1);
            this.facade.sendNotification(GameEvents.USERINFO);
            return;
        }// end function

        public function UpdateMyInfo(param1:Object) : void
        {
            UserData.updateInfo(param1);
            this.facade.sendNotification(GameEvents.USERINFO);
            return;
        }// end function

        public function MyFriends(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FRIENDLISTDATA, param1["Friends"]);
            return;
        }// end function

        public function GetAllOnlineFamilyUsers(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FRIEND_FamilyUsersLISTDATA, param1["FamilyUsers"]);
            return;
        }// end function

        public function MyBadFriends(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.BLACKLISTDATA, param1["Friends"]);
            return;
        }// end function

        public function FriendNeedVerify(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_FriendNeedVerify, param1);
            return;
        }// end function

        public function FriendOK(param1:Object) : void
        {
            trace("FriendOK");
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function FriendReject(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.UserName + "拒绝加你为好友，" + param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function FriendVerify(param1:Object) : void
        {
            trace("FriendVerify");
            t.objToString(param1);
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_FriendVerify;
            _loc_2.data = param1;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function FriendSet(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FRIENDSTRING, String(param1["Status"]));
            return;
        }// end function

        public function UserHoners(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.HONORINFO, param1["Honer"]);
            trace("MyWeekHoner====================");
            t.objToString(param1["Honer"]);
            return;
        }// end function

        public function UserMedals(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.MEDALINFO, param1["Medal"]);
            trace("UserMedals====================");
            t.objToString(param1["Medal"]);
            return;
        }// end function

        public function UserLuxury(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.LuxuryINFO, param1["Luxury"]);
            return;
        }// end function

        public function OnlineHonor(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.HONORONLINE_SHOW, param1);
            return;
        }// end function

        public function MySkins(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, new Array(param1["Skins"], "skin"));
            return;
        }// end function

        public function MyPets(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, new Array(param1["Pets"], "pet"));
            return;
        }// end function

        public function MyTools(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, new Array(param1["Tools"], "tool"));
            return;
        }// end function

        public function MyStuffs(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.SKINLISTDATA, new Array(param1["Stuffs"], "stuff"));
            return;
        }// end function

        public function GetFamilyByUserid(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.FAMILYINFO, param1["UserFamily"]);
            return;
        }// end function

        public function FamilyUsers(param1:Object) : void
        {
            t.objToString(param1);
            this.facade.sendNotification("FAMILY_MYFAMILY_ACCLIST_DATA", param1);
            return;
        }// end function

        public function FamilyList(param1:Object) : void
        {
            t.objToForVO(param1["Familys"][0]);
            this.facade.sendNotification("FAMILY_FAMILYLIST_DATA", param1);
            return;
        }// end function

        public function DelFamilyNotify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function ExitFamilyNotify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function InviteFamilyVerify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = param1;
            _loc_2.data.msg = param1.Msg + "\n 加入积分:" + String(param1.UserMinScore) + "\n 初始贡献积分:" + String(param1.OfferMinScore);
            _loc_2.data.code = GameEvents.PlUSEVENT.CONFIRMBOX_AgreeInviteJoinFamily;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function ApplyFamilyVerify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = param1;
            _loc_2.data.msg = "<font color=\"#ff0000\">[ <a href=\"event:" + param1.Userid + "\">" + param1.UserName + "</a> ]</font> 申请加入家族";
            _loc_2.data.code = GameEvents.PlUSEVENT.CONFIRMBOX_AgreeApplyJoinFamily;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function FamilyMsg(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_FamilyMsg;
            _loc_2.data = param1;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function KickFamilyNotify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function AgreeInviteFamilyVerify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function AgreeApplyFamilyVerify(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = {code:"", msg:param1.Msg};
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function Invite(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_OPEN;
            _loc_2.data = param1;
            _loc_2.data.code = GameEvents.PlUSEVENT.CONFIRMBOX_AgreeJoinRooms;
            _loc_2.data.msg = param1.Msg;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function PlayerDrop(param1:Object) : void
        {
            return;
        }// end function

        public function PlayerBack(param1:Object) : void
        {
            return;
        }// end function

        public function JoinRoom(param1:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:Array = null;
            t.obj(param1);
            if (param1.Msg == "NeedPassword")
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_RoomPssword, param1);
                return;
            }
            if (param1.LineId && MainData.LoginInfo.Id != uint(param1.LineId))
            {
                _loc_2 = uint(param1.LineId);
                UserData.UserRoom = param1.RoomId;
                MainData.LoginInfo.Id = _loc_2;
                if (MainData.LinesObj[_loc_2].Server.indexOf("|") > -1)
                {
                    _loc_3 = MainData.LinesObj[_loc_2].Server.split("|");
                }
                else
                {
                    _loc_3 = new Array(MainData.LinesObj[_loc_2].Server);
                }
                Resource.so.data.serverI = 0;
                MainData.LoginInfo.Server = _loc_3;
                this.facade.sendNotification(GameEvents.LOGINEVENT.LOGIN);
                return;
            }
            if (UserData.UserRoom != 0)
            {
                this.facade.sendNotification("KillerRoom_OUTROOM");
            }
            UserData.UserRoom = uint(param1.RoomId);
            UserData.UserRoomPlayerType = param1.Msg;
            if (param1.RoomType && param1.RoomType != "" && param1.RoomType != "taskroom")
            {
                this.facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.HTTP + param1.RoomType + ".swf");
            }
            else
            {
                this.facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.KillerRoomPath);
            }
            return;
        }// end function

        public function Marry_Propose(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = GameEvents.PlUSEVENT.CONFIRMBOX_Marry_Propose;
            _loc_2.data = param1;
            UserData.UserMsgs.push(_loc_2);
            MainData.UserMsg_LB = true;
            this.facade.sendNotification(GameEvents.USERMSGLB);
            return;
        }// end function

        public function Marry_Info(param1:Object) : void
        {
            this.facade.sendNotification(GameEvents.PlUSEVENT.MARRYINFO, param1);
            return;
        }// end function

        public function PrivateChat(param1:Object) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:Object = null;
            var _loc_2:* = new Object();
            _loc_2.url = Resource.HTTP + "PriaveChatBox.swf";
            _loc_2.x = 0;
            _loc_2.y = 0;
            _loc_2.msgs = param1.PrivateChats;
            if (MainData.isPrivateChatOpen)
            {
                this.facade.sendNotification(PlusMediator.ACTION, _loc_2);
            }
            else
            {
                while (_loc_3 < UserData.UserMsgs.length)
                {
                    
                    if (UserData.UserMsgs[_loc_3].data.url == _loc_2.url)
                    {
                        UserData.UserMsgs[_loc_3].data.msgs = UserData.UserMsgs[_loc_3].data.msgs.concat(_loc_2.msgs);
                        return;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                _loc_4 = new Object();
                _loc_4.code = PlusMediator.ACTION;
                _loc_4.data = _loc_2;
                UserData.UserMsgs.push(_loc_4);
                MainData.UserMsg_LB = true;
                this.facade.sendNotification(GameEvents.USERMSGLB);
            }
            return;
        }// end function

    }
}
