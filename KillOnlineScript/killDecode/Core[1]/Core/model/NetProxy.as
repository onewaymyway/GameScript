package Core.model
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.core.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.requests.*;
    import com.smartfoxserver.v2.util.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import org.puremvc.as3.patterns.proxy.*;
    import uas.*;

    public class NetProxy extends Proxy implements IProxy
    {
        public var connection:SmartFox;
        private var rtmpUrl:Array;
        public var loginVO:LoginVO;
        public var isLoginOut:Boolean = false;
        private var app_URLArr:Array;
        private var connTimes:uint = 0;
        private var serverKey:uint = 0;
        private var so:SharedObject;
        private var appURLRTMP:String = "";
        private var timeTryConn:Timer;
        private var isLogining:Boolean = true;
        private var changeServertimer:Timer;
        private var cmdClient:Object;
        private var reSendCmdObj:Object;
        private var conn:String = "";
        public static const NAME:String = "Core_NetProxy";
        public static var CloseSeverMsg:String = "";

        public function NetProxy()
        {
            this.loginVO = new LoginVO();
            this.app_URLArr = new Array();
            this.changeServertimer = new Timer(1000, 1);
            super(NAME);
            return;
        }// end function

        override public function onRegister() : void
        {
            with ({})
            {
                {}.e = function (event:TimerEvent) : void
            {
                login();
                return;
            }// end function
            ;
            }
            this.changeServertimer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:TimerEvent) : void
            {
                login();
                return;
            }// end function
            );
            this.connection = new SmartFox();
            this.connection.useBlueBox = false;
            this.connection.addEventListener(SFSEvent.CONNECTION, this.onConnection);
            this.connection.addEventListener(SFSEvent.CONNECTION_LOST, this.onConnectionLost);
            this.connection.addEventListener(SFSEvent.CONNECTION_RESUME, this.onConnectionLost);
            this.connection.addEventListener(SFSEvent.LOGIN_ERROR, this.onLoginError);
            this.connection.addEventListener(SFSEvent.LOGIN, this.onLogin);
            this.connection.addEventListener(SFSEvent.ROOM_JOIN_ERROR, this.onRoomJoinError);
            this.connection.addEventListener(SFSEvent.ROOM_JOIN, this.onRoomJoin);
            this.connection.addEventListener(SFSEvent.EXTENSION_RESPONSE, this.onExtensionResponse);
            return;
        }// end function

        public function login() : void
        {
            CloseSeverMsg = "";
            if (this.connection.isConnected)
            {
                this.isLoginOut = true;
                this.connection.killConnection();
                this.connection.disconnect();
            }
            this.isLoginOut = false;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在登录中..."});
            if (this.serverKey < MainData.LoginInfo.Server.length)
            {
            }
            else
            {
                this.serverKey = 0;
            }
            this.conn = String(MainData.LoginInfo.Server[this.serverKey]);
            this.rtmpUrl = String(MainData.LoginInfo.Server[this.serverKey]).split(":");
            trace("rtmpUrl:" + this.rtmpUrl[0] + "-" + this.rtmpUrl[1]);
            this.connection.connect(this.rtmpUrl[0], this.rtmpUrl[1]);
            return;
        }// end function

        public function trylogin() : void
        {
            var _loc_1:* = new AlertVO();
            _loc_1.code = GameEvents.LOGINEVENT.LOGIN;
            _loc_1.msg = "与服务器断开！是否重新连接？";
            this.sendNotification(GameEvents.ALERTEVENT.CONFIRM, _loc_1);
            return;
        }// end function

        private function sfslogin() : void
        {
            var _loc_1:* = new SFSObject();
            _loc_1.putUtfString("UV", MainData.LoginInfo.uservalues);
            _loc_1.putUtfString("IP", MainData.LoginInfo.userip);
            _loc_1.putInt("L", MainData.LoginInfo.Id);
            _loc_1.putInt("R", uint(UserData.UserRoom));
            if (String(UserData.UserRoomPassword) != "")
            {
                _loc_1.putUtfString("RP", String(UserData.UserRoomPassword));
            }
            UserData.UserRoom = 0;
            UserData.UserRoomPassword = "";
            var _loc_2:* = new LoginRequest("", "", MainData.LoginInfo.Zone, _loc_1);
            this.connection.send(_loc_2);
            return;
        }// end function

        private function joinRoom(param1:String) : void
        {
            var _loc_2:* = new JoinRoomRequest(param1);
            this.connection.send(_loc_2);
            return;
        }// end function

        private function onDisconnectBtClick() : void
        {
            this.connection.disconnect();
            return;
        }// end function

        private function onConfigLoadFailure(event:SFSEvent) : void
        {
            return;
        }// end function

        private function onConnection(event:SFSEvent) : void
        {
            var _loc_2:Object = null;
            if (event.params.success)
            {
                this.sfslogin();
            }
            else
            {
                trace(event);
                MainData.failConn(this.conn);
                this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                var _loc_3:String = this;
                var _loc_4:* = this.serverKey + 1;
                _loc_3.serverKey = _loc_4;
                var _loc_3:String = this;
                var _loc_4:* = this.connTimes + 1;
                _loc_3.connTimes = _loc_4;
                if (this.isLogining && this.connTimes < MainData.LoginInfo.Server.length)
                {
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"切换服务器..."});
                    this.changeServertimer.start();
                }
                else
                {
                    this.connTimes = 0;
                    this.sendNotification(GameEvents.LINESBOXEVENT.GET_LINES_DATA);
                    _loc_2 = {msg:"连接服务器失败", code:null, obj:null};
                    sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
            }
            return;
        }// end function

        private function onConnectionLost(event:SFSEvent) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            if (event.params.reason != ClientDisconnectionReason.MANUAL)
            {
                _loc_2 = "已经断开";
                switch(event.params.reason)
                {
                    case ClientDisconnectionReason.IDLE:
                    {
                        _loc_2 = _loc_2 + "\n超时";
                        break;
                    }
                    case ClientDisconnectionReason.KICK:
                    {
                        _loc_2 = _loc_2 + "\n被服务踢出";
                        break;
                    }
                    case ClientDisconnectionReason.BAN:
                    {
                        _loc_2 = _loc_2 + "\n被禁止";
                        break;
                    }
                    case ClientDisconnectionReason.UNKNOWN:
                    {
                        if (this.isLoginOut)
                        {
                            return;
                        }
                        _loc_2 = _loc_2 + " 未知原因\n联系客服QQ：1135309032 ";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                trace(_loc_2);
                this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                this.sendNotification(GameEvents.CONNECTION_LOST);
                if (this.isLoginOut)
                {
                    return;
                }
                if (CloseSeverMsg == "")
                {
                    this.trylogin();
                }
                else
                {
                    _loc_3 = {msg:CloseSeverMsg, code:GameEvents.REFRESH_WEB, obj:null};
                    sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                }
            }
            return;
        }// end function

        private function onLoginError(event:SFSEvent) : void
        {
            var _loc_2:Object = null;
            if (event.params.errorMessage == "NotReg")
            {
            }
            else
            {
                trace("onLoginError:" + t.obj(event.params.errorMessage));
                _loc_2 = {msg:event.params.errorMessage + "\n联系客服QQ：1135309032 ", code:null, obj:null};
                sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            return;
        }// end function

        private function onLogin(event:SFSEvent) : void
        {
            this.joinRoom(MainData.LoginInfo.Room + MainData.LoginInfo.Id);
            return;
        }// end function

        private function onRoomJoinError(event:SFSEvent) : void
        {
            trace("进房间失败: " + event.params.errorMessage);
            var _loc_2:Object = {msg:event.params.errorMessage + "\n联系客服QQ：1135309032 ", code:null, obj:null};
            sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            return;
        }// end function

        private function onRoomJoin(event:SFSEvent) : void
        {
            this.serverKey = 0;
            this.connTimes = 0;
            this.isLogining = false;
            var _loc_2:* = event.params.room;
            t.objToString(event.params);
            MainData.isLoginScenced = 1;
            return;
        }// end function

        public function StatusHandler(event:NetStatusEvent) : void
        {
            var _loc_2:AlertVO = null;
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            trace(event.info.code.toString());
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.serverKey = 0;
                    this.connTimes = 0;
                    this.isLogining = false;
                    break;
                }
                case "NetConnection.Connect.Rejected":
                {
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    _loc_2 = new AlertVO();
                    if (event.info.application)
                    {
                        _loc_2.msg = event.info.application + "";
                    }
                    else
                    {
                        _loc_2.msg = "服务器拒绝";
                    }
                    sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    var _loc_5:String = this;
                    var _loc_6:* = this.serverKey + 1;
                    _loc_5.serverKey = _loc_6;
                    var _loc_5:String = this;
                    var _loc_6:* = this.connTimes + 1;
                    _loc_5.connTimes = _loc_6;
                    if (this.isLogining && this.connTimes < 4)
                    {
                        this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"切换服务器..."});
                        this.changeServertimer.start();
                    }
                    else
                    {
                        _loc_3 = {msg:"连接服务器失败", code:null, obj:null};
                        sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    }
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    this.sendNotification(PlusMediator.CLOSEALL);
                    this.sendNotification("KillerRoomPlugGameMediator_CLOSE");
                    this.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    if (this.isLoginOut)
                    {
                        return;
                    }
                    if (CloseSeverMsg == "")
                    {
                        this.trylogin();
                    }
                    else
                    {
                        _loc_4 = {msg:CloseSeverMsg, code:null, obj:null};
                        sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_4);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function ERRORHandler(param1) : void
        {
            trace(param1);
            return;
        }// end function

        override public function onRemove() : void
        {
            var _loc_1:* = new LogoutRequest();
            this.connection.send(_loc_1);
            return;
        }// end function

        public function SendCmd(param1:Object) : void
        {
            this.reSendCmdObj = param1;
            if (MainData.M != 0)
            {
            }
            var _loc_2:* = new Object();
            _loc_2.BinaryData = CmdData.getData(param1);
            var _loc_3:* = SFSObject.newFromObject(_loc_2);
            var _loc_4:* = new ExtensionRequest("ClientCmd", _loc_3, this.connection.lastJoinedRoom);
            this.connection.send(_loc_4);
            return;
        }// end function

        public function ReSendCmd() : void
        {
            var _loc_1:* = SFSObject.newFromObject(this.reSendCmdObj);
            var _loc_2:* = new ExtensionRequest("ClientCmd", _loc_1, this.connection.lastJoinedRoom);
            this.connection.send(_loc_2);
            return;
        }// end function

        public function SendAdminCmd(param1:Object) : void
        {
            var _loc_2:* = SFSObject.newFromObject(param1);
            _loc_2.putUtfString("key", Resource.AdminPassword);
            var _loc_3:* = new ExtensionRequest("AdminCmd", _loc_2, this.connection.lastJoinedRoom);
            this.connection.send(_loc_3);
            return;
        }// end function

        public function loadUserSO() : void
        {
            return;
        }// end function

        public function setClient(param1:AbsClient) : void
        {
            this.cmdClient = param1;
            return;
        }// end function

        public function clearClient() : void
        {
            this.cmdClient = new Object();
            return;
        }// end function

        public function LoginOut() : void
        {
            this.isLoginOut = true;
            UserData.UserInfo = new UserVO();
            this.connection.disconnect();
            return;
        }// end function

        public function kickClient(param1:Object = null) : void
        {
            if (param1)
            {
                CloseSeverMsg = param1.toString();
            }
            return;
        }// end function

        public function closeClient(param1:Object = null) : void
        {
            this.sendNotification(PlusMediator.CLOSEALL);
            this.sendNotification("KillerRoomPlugGameMediator_CLOSE");
            UserData.UserInfo = new UserVO();
            this.connection.disconnect();
            return;
        }// end function

        public function onExtensionResponse(event:SFSEvent) : void
        {
            var cmd:Object;
            var evt:* = event;
            var responseParams:* = evt.params.params as SFSObject;
            cmd = responseParams.toObject();
            try
            {
                var _loc_3:* = this.cmdClient;
                _loc_3.this.cmdClient[evt.params.cmd](cmd);
            }
            catch (e)
            {
                trace("----------err onExtensionResponse----------");
                trace("-----收到cmd:" + evt.params.cmd + " 命令----");
                t.objToString(cmd);
                trace(e);
                trace("----------err onExtensionResponse---end-------");
            }
            return;
        }// end function

    }
}
