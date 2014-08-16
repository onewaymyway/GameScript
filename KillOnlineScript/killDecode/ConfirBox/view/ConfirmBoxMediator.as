package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.events.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class ConfirmBoxMediator extends Mediator implements IMediator
    {
        private var loader:Object;
        public static const NAME:String = "ConfirmBoxMediator";

        public function ConfirmBoxMediator(viewComponent:Object = null)
        {
            this.loader = new LoadURL();
            super(NAME, viewComponent);
            this.loader.addEventListener(Event.COMPLETE, this.loaderHandler);
            this.loader.addEventListener(ErrorEvent.ERROR, this.loaderHandler);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, GameEvents.PlUSEVENT.CONFIRMBOX_FriendNeedVerify, GameEvents.PlUSEVENT.CONFIRMBOX_FriendVerify, GameEvents.PlUSEVENT.CONFIRMBOX_ADDTOBAD, GameEvents.PlUSEVENT.CONFIRMBOX_RECHANGENAME, GameEvents.PlUSEVENT.CONFIRMBOX_UNWEDDING, GameEvents.PlUSEVENT.CONFIRMBOX_UPDATAMARRY, GameEvents.PlUSEVENT.CONFIRMBOX_ApplyUPDATAMARRY, GameEvents.PlUSEVENT.CONFIRMBOX_AgreeApplyJoinFamily, GameEvents.PlUSEVENT.CONFIRMBOX_AgreeInviteJoinFamily, GameEvents.PlUSEVENT.CONFIRMBOX_FamilyMsg, GameEvents.PlUSEVENT.CONFIRMBOX_AgreeJoinRooms, GameEvents.PlUSEVENT.CONFIRMBOX_RoomPssword, GameEvents.PlUSEVENT.CONFIRMBOX_BriDay, GameEvents.PlUSEVENT.CONFIRMBOX_CHANGENAME, GameEvents.PlUSEVENT.CONFIRMBOX_ADDWEDDING, GameEvents.PlUSEVENT.CONFIRMBOX_Marry_Propose, GameEvents.PlUSEVENT.CONFIRMBOX_TeachVerify, GameEvents.PlUSEVENT.CONFIRMBOX_CreateRoom, GameEvents.PlUSEVENT.CONFIRMBOX_DELFRIEND];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            var _loc_2:Object = null;
            var _loc_3:AlertVO = null;
            var _loc_4:Object = null;
            switch(sender.getName())
            {
                case GameEvents.PlUSEVENT.CONFIRMBOX_OPEN:
                {
                    new ConfirmDefBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN:
                {
                    new ConfirmWithFuncBoxController(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_FriendNeedVerify:
                {
                    new ConfirmFriendNeedVerifyBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_FriendVerify:
                {
                    new ConfirmFriendVerifyBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_ADDTOBAD:
                {
                    _loc_2 = new CallCmdVO();
                    _loc_2.arg = [sender.getBody().FTbID];
                    _loc_2.code = "badOneFas";
                    _loc_2.resp = null;
                    this.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_RECHANGENAME:
                {
                    _loc_3 = new AlertVO();
                    _loc_4 = sender.getBody();
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    if (uint(_loc_4.re) == 1)
                    {
                        _loc_3.msg = "昵称成功更改为 [" + _loc_4.UserName + "]";
                        facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    }
                    else
                    {
                        _loc_3.msg = "[" + _loc_4.UserName + "]\n" + _loc_4.err;
                        facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_UNWEDDING:
                {
                    _loc_2 = new Object();
                    _loc_2.MarryId = String(sender.getBody().marryid);
                    _loc_2.cmd = "MarryCmd_Divorce";
                    this.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_UPDATAMARRY:
                {
                    new ConfirmUpdateWeddingBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_ApplyUPDATAMARRY:
                {
                    _loc_2 = new Object();
                    _loc_2.MarryId = String(sender.getBody().marryid);
                    _loc_2.MarryType = String(sender.getBody().marrytype);
                    _loc_2.cmd = "MarryCmd_Levelup";
                    this.sendNotification(GameEvents.NETCALL, _loc_2);
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_AgreeApplyJoinFamily:
                {
                    this.AgreeApplyJoinFamily(sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_AgreeInviteJoinFamily:
                {
                    this.AgreeInviteJoinFamily(sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_FamilyMsg:
                {
                    new ConfirmFamilyMsgBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_AgreeJoinRooms:
                {
                    this.AgreeJoinRoom(sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_RoomPssword:
                {
                    facade.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"正在进房间..."});
                    new ConfirmRoomPasswordBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_BriDay:
                {
                    new ConfirmBriDayBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_CHANGENAME:
                {
                    new ConfirmChangeNameBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_ADDWEDDING:
                {
                    new ConfirmAddWeddingBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_Marry_Propose:
                {
                    new ConfirmAccWeddingBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_TeachVerify:
                {
                    new ConfirmTeachNeedVerifyBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_CreateRoom:
                {
                    new ConfirmCreateRoomBox(this.viewComponent, sender.getBody());
                    break;
                }
                case GameEvents.PlUSEVENT.CONFIRMBOX_DELFRIEND:
                {
                    new ConfirmDelFriendBox(this.viewComponent, sender.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function AgreeJoinRoom(info:Object) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:Array = null;
            var _loc_4:Object = null;
            if (info.LineId)
            {
            }
            if (MainData.LoginInfo.Id != uint(info.LineId))
            {
                _loc_2 = uint(info.LineId);
                UserData.UserRoom = info.RoomId;
                if (info.RoomPwd)
                {
                    UserData.UserRoomPassword = String(info.RoomPwd);
                }
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
                this.sendNotification(GameEvents.LOGINEVENT.LOGIN);
                return;
            }
            if (UserData.UserRoom != uint(info.RoomId))
            {
                RoomData.RoomInfo = {RoomId:info.RoomId};
                _loc_4 = {};
                _loc_4.cmd = "LeaveRoom";
                _loc_4.ToRoomId = String(info.RoomId);
                if (info.RoomPwd)
                {
                }
                facade.sendNotification(GameEvents.NETCALL, _loc_4);
            }
            return;
        }// end function

        private function AgreeApplyJoinFamily(info:Object) : void
        {
            var _loc_2:Object = {cmd:"FamilyCmd_AgreeApplyJoinFamily", Fid:info.Fid + "", UserName:info.UserName, Userid:String(info.Userid), Offer:String(info.OfferMinScore), Fname:String(info.Fname)};
            this.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function AgreeInviteJoinFamily(info:Object) : void
        {
            var _loc_2:Object = {cmd:"FamilyCmd_AgreeInviteJoinFamily", Fid:info.Fid + "", Offer:String(info.OfferMinScore), Fname:String(info.Fname)};
            this.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var _loc_4:String = null;
            var _loc_5:Object = null;
            var _loc_2:* = UStr.getObjByString(event.target.data);
            var _loc_3:* = new AlertVO();
            facade.sendNotification(GameEvents.LOADINGEVENT.LOADED);
            if (_loc_2.re == 1)
            {
                _loc_4 = this.GetrindName((uint(event.target.note) + 1));
                _loc_5 = new CallCmdVO();
                _loc_5.arg = [_loc_4];
                _loc_5.code = "UpdateMarry";
                _loc_5.resp = null;
                this.sendNotification(GameEvents.NETCALL, _loc_5);
                _loc_3.msg = "戒指成功升级为 “" + _loc_4 + "”";
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            else if (_loc_2.re == 0)
            {
                _loc_3.msg = _loc_2.err;
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            else
            {
                _loc_3.msg = event.target.data;
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            return;
        }// end function

        private function GetrindName(T:uint) : String
        {
            if (T == 1)
            {
                return "爱誓言";
            }
            if (T == 2)
            {
                return "情一生";
            }
            if (T == 3)
            {
                return "心永恒";
            }
            if (T == 4)
            {
                return "七彩虹";
            }
            if (T == 5)
            {
                return "蓝宝石";
            }
            if (T == 6)
            {
                return "红宝石";
            }
            if (T == 7)
            {
                return "黑宝石";
            }
            return "";
        }// end function

        private function showUserMsg(INFO:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:AlertVO = null;
            switch(INFO.kinds)
            {
                case "confirm":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = INFO.code;
                    _loc_3.msg = INFO.msg;
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "accepts":
                {
                    break;
                }
                case "callGame":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "<font color=\'#ff0000\'>[ <a href=\"event:" + INFO.MsgUID + "\">" + INFO.Uname + " </a> ]</font> 邀请你一起游戏！";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_callgame_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "other":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = INFO.MsgStr;
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "adds":
                {
                    break;
                }
                case "addToBad":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = GameEvents.PlUSEVENT.CONFIRMBOX_ADDTOBAD;
                    _loc_3.msg = "你确定将<font color=\'#ff0000\'>[ <a href=\"event:" + INFO.MsgUID + "\">" + INFO.Uname + " </a> ]</font>加入黑名单？";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "bridayConfirm":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_Birthdaycake_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "changeNameConfirm":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_ChangeName_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "addwedding":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_AddWedding_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "accwedding":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_AccWedding_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "updataMarry":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_marryUpdate_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "family":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = INFO.MsgStr;
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "familymsg":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "<b>" + INFO.cuname + " (族长):</b>\n" + INFO.msg + "\n\n" + DateStr.dateToDate2b(INFO.date);
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "familyApp":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = GameEvents.PlUSEVENT.CONFIRMBOX_FAMILYJOIN;
                    _loc_3.msg = "<font color=\'#ff0000\'>[<a href=\"event:" + INFO.AUserID + "\"> " + INFO.AUserName + " </a>]</font> 申请加入你的家族。\n\n你确定通过其申请吗？";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "familyCall":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = GameEvents.PlUSEVENT.CONFIRMBOX_FAMILYADD;
                    _loc_3.msg = "<font color=\'#ff0000\'>" + INFO.Fname + "</font> 家族邀请你的加入。\n其家族的初始贡献积分为 " + INFO.Iscore + "\n\n(将会扣除你 " + INFO.Iscore + " 积分)\n你是否同意加入?";
                    _loc_3.arr = INFO;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        GameEvents.PlUSEVENT.CONFIRMBOX_OPEN = "PlUSEVENT_CONFIRMBOX_OPEN";
        GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN = "PlUSEVENT_CONFIRMBOWITHFUNC_OPEN";
        GameEvents.PlUSEVENT.CONFIRMBOX_FriendNeedVerify = "PlUSEVENT_CONFIRMBOX_FriendNeedVerify";
        GameEvents.PlUSEVENT.CONFIRMBOX_FriendVerify = "PlUSEVENT_CONFIRMBOX_FriendVerify";
        GameEvents.PlUSEVENT.CONFIRMBOX_ADDTOBAD = "PlUSEVENT_CONFIRMBOX_ADDTOBAD";
        GameEvents.PlUSEVENT.CONFIRMBOX_RECHANGENAME = "PlUSEVENT_CONFIRMBOX_RECHANGENAME";
        GameEvents.PlUSEVENT.CONFIRMBOX_UNWEDDING = "PlUSEVENT_CONFIRMBOX_UNWEDDING";
        GameEvents.PlUSEVENT.CONFIRMBOX_UPDATAMARRY = "PlUSEVENT_CONFIRMBOX_UPDATAMARRY";
        GameEvents.PlUSEVENT.CONFIRMBOX_ApplyUPDATAMARRY = "PlUSEVENT_CONFIRMBOX_ApplyUPDATAMARRY";
        GameEvents.PlUSEVENT.CONFIRMBOX_AgreeApplyJoinFamily = "PlUSEVENT_CONFIRMBOX_AgreeApplyJoinFamily";
        GameEvents.PlUSEVENT.CONFIRMBOX_AgreeInviteJoinFamily = "PlUSEVENT_CONFIRMBOX_AgreeInviteJoinFamily";
        GameEvents.PlUSEVENT.CONFIRMBOX_FamilyMsg = "PlUSEVENT_CONFIRMBOX_FamilyMsg";
        GameEvents.PlUSEVENT.CONFIRMBOX_AgreeJoinRooms = "PlUSEVENT_CONFIRMBOX_AgreeJoinRooms";
        GameEvents.PlUSEVENT.CONFIRMBOX_RoomPssword = "PlUSEVENT_CONFIRMBOX_RoomPssword";
        GameEvents.PlUSEVENT.CONFIRMBOX_BriDay = "PlUSEVENT_CONFIRMBOX_BriDay";
        GameEvents.PlUSEVENT.CONFIRMBOX_CHANGENAME = "PlUSEVENT_CONFIRMBOX_CHANGENAME";
        GameEvents.PlUSEVENT.CONFIRMBOX_ADDWEDDING = "PlUSEVENT_CONFIRMBOX_ADDWEDDING";
        GameEvents.PlUSEVENT.CONFIRMBOX_Marry_Propose = "PlUSEVENT_CONFIRMBOX_Marry_Propose";
        GameEvents.PlUSEVENT.CONFIRMBOX_TeachVerify = "PlUSEVENT_CONFIRMBOX_TeachVerify";
        GameEvents.PlUSEVENT.CONFIRMBOX_CreateRoom = "PlUSEVENT_CONFIRMBOX_CreateRoom";
        GameEvents.PlUSEVENT.CONFIRMBOX_DELFRIEND = "PlUSEVENT_CONFIRMBOX_DELFRIEND";
    }
}
