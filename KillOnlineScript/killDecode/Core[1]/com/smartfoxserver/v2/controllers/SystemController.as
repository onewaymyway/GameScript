package com.smartfoxserver.v2.controllers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.core.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.invitation.*;
    import com.smartfoxserver.v2.entities.managers.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.requests.*;
    import com.smartfoxserver.v2.requests.buddylist.*;
    import com.smartfoxserver.v2.requests.game.*;
    import com.smartfoxserver.v2.util.*;

    public class SystemController extends BaseController
    {
        private var sfs:SmartFox;
        private var bitSwarm:BitSwarmClient;
        private var requestHandlers:Object;

        public function SystemController(param1:BitSwarmClient)
        {
            this.bitSwarm = param1;
            this.sfs = param1.sfs;
            this.requestHandlers = new Object();
            this.initRequestHandlers();
            return;
        }// end function

        private function initRequestHandlers() : void
        {
            this.requestHandlers[BaseRequest.Handshake] = "fnHandshake";
            this.requestHandlers[BaseRequest.Login] = "fnLogin";
            this.requestHandlers[BaseRequest.Logout] = "fnLogout";
            this.requestHandlers[BaseRequest.JoinRoom] = "fnJoinRoom";
            this.requestHandlers[BaseRequest.CreateRoom] = "fnCreateRoom";
            this.requestHandlers[BaseRequest.GenericMessage] = "fnGenericMessage";
            this.requestHandlers[BaseRequest.ChangeRoomName] = "fnChangeRoomName";
            this.requestHandlers[BaseRequest.ChangeRoomPassword] = "fnChangeRoomPassword";
            this.requestHandlers[BaseRequest.ChangeRoomCapacity] = "fnChangeRoomCapacity";
            this.requestHandlers[BaseRequest.ObjectMessage] = "fnSendObject";
            this.requestHandlers[BaseRequest.SetRoomVariables] = "fnSetRoomVariables";
            this.requestHandlers[BaseRequest.SetUserVariables] = "fnSetUserVariables";
            this.requestHandlers[BaseRequest.CallExtension] = "fnCallExtension";
            this.requestHandlers[BaseRequest.SubscribeRoomGroup] = "fnSubscribeRoomGroup";
            this.requestHandlers[BaseRequest.UnsubscribeRoomGroup] = "fnUnsubscribeRoomGroup";
            this.requestHandlers[BaseRequest.SpectatorToPlayer] = "fnSpectatorToPlayer";
            this.requestHandlers[BaseRequest.PlayerToSpectator] = "fnPlayerToSpectator";
            this.requestHandlers[BaseRequest.InitBuddyList] = "fnInitBuddyList";
            this.requestHandlers[BaseRequest.AddBuddy] = "fnAddBuddy";
            this.requestHandlers[BaseRequest.RemoveBuddy] = "fnRemoveBuddy";
            this.requestHandlers[BaseRequest.BlockBuddy] = "fnBlockBuddy";
            this.requestHandlers[BaseRequest.GoOnline] = "fnGoOnline";
            this.requestHandlers[BaseRequest.SetBuddyVariables] = "fnSetBuddyVariables";
            this.requestHandlers[BaseRequest.FindRooms] = "fnFindRooms";
            this.requestHandlers[BaseRequest.FindUsers] = "fnFindUsers";
            this.requestHandlers[BaseRequest.InviteUser] = "fnInviteUsers";
            this.requestHandlers[BaseRequest.InvitationReply] = "fnInvitationReply";
            this.requestHandlers[BaseRequest.QuickJoinGame] = "fnQuickJoinGame";
            this.requestHandlers[BaseRequest.PingPong] = "fnPingPong";
            this.requestHandlers[1000] = "fnUserEnterRoom";
            this.requestHandlers[1001] = "fnUserCountChange";
            this.requestHandlers[1002] = "fnUserLost";
            this.requestHandlers[1003] = "fnRoomLost";
            this.requestHandlers[1004] = "fnUserExitRoom";
            this.requestHandlers[1005] = "fnClientDisconnection";
            return;
        }// end function

        override public function handleMessage(param1:IMessage) : void
        {
            if (this.sfs.debug)
            {
                log.info(this.getEvtName(param1.id), param1);
            }
            var _loc_2:* = this.requestHandlers[param1.id];
            if (_loc_2 != null)
            {
                var _loc_3:String = this;
                _loc_3.this[_loc_2](param1);
            }
            else
            {
                log.warn("Unknown message id: " + param1.id);
            }
            return;
        }// end function

        private function getEvtName(param1:int) : String
        {
            var _loc_2:* = this.requestHandlers[param1];
            return _loc_2.substr(2);
        }// end function

        private function fnHandshake(param1:IMessage) : void
        {
            var _loc_2:Object = {message:param1};
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.HANDSHAKE, _loc_2));
            return;
        }// end function

        private function fnLogin(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                this.populateRoomList(_loc_2.getSFSArray(LoginRequest.KEY_ROOMLIST));
                this.sfs.mySelf = new SFSUser(_loc_2.getInt(LoginRequest.KEY_ID), _loc_2.getUtfString(LoginRequest.KEY_USER_NAME), true);
                this.sfs.mySelf.userManager = this.sfs.userManager;
                this.sfs.mySelf.privilegeId = _loc_2.getShort(LoginRequest.KEY_PRIVILEGE_ID);
                this.sfs.userManager.addUser(this.sfs.mySelf);
                this.sfs.setReconnectionSeconds(_loc_2.getShort(LoginRequest.KEY_RECONNECTION_SECONDS));
                _loc_3.zone = _loc_2.getUtfString(LoginRequest.KEY_ZONE_NAME);
                _loc_3.user = this.sfs.mySelf;
                _loc_3.data = _loc_2.getSFSObject(LoginRequest.KEY_PARAMS);
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN, _loc_3));
            }
            else
            {
                _loc_4 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_5 = SFSErrorCodes.getErrorMessage(_loc_4, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_5, errorCode:_loc_4};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGIN_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnCreateRoom(param1:IMessage) : void
        {
            var _loc_4:IRoomManager = null;
            var _loc_5:Room = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = this.sfs.roomManager;
                _loc_5 = SFSRoom.fromSFSArray(_loc_2.getSFSArray(CreateRoomRequest.KEY_ROOM));
                _loc_5.roomManager = this.sfs.roomManager;
                _loc_4.addRoom(_loc_5);
                _loc_3.room = _loc_5;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_ADD, _loc_3));
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CREATION_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnJoinRoom(param1:IMessage) : void
        {
            var _loc_5:ISFSArray = null;
            var _loc_6:ISFSArray = null;
            var _loc_7:Room = null;
            var _loc_8:int = 0;
            var _loc_9:ISFSArray = null;
            var _loc_10:User = null;
            var _loc_11:int = 0;
            var _loc_12:String = null;
            var _loc_2:* = this.sfs.roomManager;
            var _loc_3:* = param1.content;
            var _loc_4:Object = {};
            this.sfs.isJoining = false;
            if (_loc_3.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_5 = _loc_3.getSFSArray(JoinRoomRequest.KEY_ROOM);
                _loc_6 = _loc_3.getSFSArray(JoinRoomRequest.KEY_USER_LIST);
                _loc_7 = SFSRoom.fromSFSArray(_loc_5);
                _loc_7.roomManager = this.sfs.roomManager;
                _loc_7 = _loc_2.replaceRoom(_loc_7, _loc_2.containsGroup(_loc_7.groupId));
                _loc_8 = 0;
                while (_loc_8 < _loc_6.size())
                {
                    
                    _loc_9 = _loc_6.com.smartfoxserver.v2.entities.data:ISFSArray::getSFSArray(_loc_8);
                    _loc_10 = this.getOrCreateUser(_loc_9, true, _loc_7);
                    _loc_10.setPlayerId(_loc_9.com.smartfoxserver.v2.entities.data:ISFSArray::getShort(3), _loc_7);
                    _loc_7.addUser(_loc_10);
                    _loc_8++;
                }
                _loc_7.isJoined = true;
                this.sfs.lastJoinedRoom = _loc_7;
                _loc_4.room = _loc_7;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN, _loc_4));
            }
            else
            {
                _loc_11 = _loc_3.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_12 = SFSErrorCodes.getErrorMessage(_loc_11, _loc_3.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_4 = {errorMessage:_loc_12, errorCode:_loc_11};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR, _loc_4));
            }
            return;
        }// end function

        private function fnUserEnterRoom(param1:IMessage) : void
        {
            var _loc_5:ISFSArray = null;
            var _loc_6:User = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = this.sfs.roomManager.getRoomById(_loc_2.getInt("r"));
            if (this.sfs.roomManager.getRoomById(_loc_2.getInt("r")) != null)
            {
                _loc_5 = _loc_2.getSFSArray("u");
                _loc_6 = this.getOrCreateUser(_loc_5, true, _loc_4);
                _loc_4.addUser(_loc_6);
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_ENTER_ROOM, {user:_loc_6, room:_loc_4}));
            }
            return;
        }// end function

        private function fnUserCountChange(param1:IMessage) : void
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = this.sfs.roomManager.getRoomById(_loc_2.getInt("r"));
            if (this.sfs.roomManager.getRoomById(_loc_2.getInt("r")) != null)
            {
                _loc_5 = _loc_2.getShort("uc");
                _loc_6 = 0;
                if (_loc_2.containsKey("sc"))
                {
                    _loc_6 = _loc_2.getShort("sc");
                }
                _loc_4.userCount = _loc_5;
                _loc_4.spectatorCount = _loc_6;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_COUNT_CHANGE, {room:_loc_4, uCount:_loc_5, sCount:_loc_6}));
            }
            return;
        }// end function

        private function fnUserLost(param1:IMessage) : void
        {
            var _loc_5:Array = null;
            var _loc_6:Room = null;
            var _loc_2:* = param1.content;
            var _loc_3:* = _loc_2.getInt("u");
            var _loc_4:* = this.sfs.userManager.getUserById(_loc_3);
            if (this.sfs.userManager.getUserById(_loc_3) != null)
            {
                _loc_5 = this.sfs.roomManager.getUserRooms(_loc_4);
                this.sfs.roomManager.removeUser(_loc_4);
                this.sfs.userManager.removeUser(_loc_4);
                for each (_loc_6 in _loc_5)
                {
                    
                    this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM, {user:_loc_4, room:_loc_6}));
                }
            }
            return;
        }// end function

        private function fnRoomLost(param1:IMessage) : void
        {
            var _loc_7:User = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getInt("r");
            var _loc_5:* = this.sfs.roomManager.getRoomById(_loc_4);
            var _loc_6:* = this.sfs.userManager;
            if (_loc_5 != null)
            {
                this.sfs.roomManager.removeRoom(_loc_5);
                for each (_loc_7 in _loc_5.userList)
                {
                    
                    _loc_6.removeUser(_loc_7);
                }
                _loc_3.room = _loc_5;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_REMOVE, _loc_3));
            }
            return;
        }// end function

        private function fnGenericMessage(param1:IMessage) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:* = _loc_2.getByte(GenericMessageRequest.KEY_MESSAGE_TYPE);
            switch(_loc_3)
            {
                case GenericMessageType.PUBLIC_MSG:
                {
                    this.handlePublicMessage(_loc_2);
                    break;
                }
                case GenericMessageType.PRIVATE_MSG:
                {
                    this.handlePrivateMessage(_loc_2);
                    break;
                }
                case GenericMessageType.BUDDY_MSG:
                {
                    this.handleBuddyMessage(_loc_2);
                    break;
                }
                case GenericMessageType.MODERATOR_MSG:
                {
                    this.handleModMessage(_loc_2);
                    break;
                }
                case GenericMessageType.ADMING_MSG:
                {
                    this.handleAdminMessage(_loc_2);
                    break;
                }
                case GenericMessageType.OBJECT_MSG:
                {
                    this.handleObjectMessage(_loc_2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function handlePublicMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            var _loc_3:* = param1.getInt(GenericMessageRequest.KEY_ROOM_ID);
            var _loc_4:* = this.sfs.roomManager.getRoomById(_loc_3);
            if (this.sfs.roomManager.getRoomById(_loc_3) != null)
            {
                _loc_2.room = _loc_4;
                _loc_2.sender = this.sfs.userManager.getUserById(param1.getInt(GenericMessageRequest.KEY_USER_ID));
                _loc_2.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
                _loc_2.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PUBLIC_MESSAGE, _loc_2));
            }
            else
            {
                log.warn("Unexpected, PublicMessage target room doesn\'t exist. RoomId: " + _loc_3);
            }
            return;
        }// end function

        public function handlePrivateMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            var _loc_3:* = param1.getInt(GenericMessageRequest.KEY_USER_ID);
            var _loc_4:* = this.sfs.userManager.getUserById(_loc_3);
            if (this.sfs.userManager.getUserById(_loc_3) == null)
            {
                if (!param1.containsKey(GenericMessageRequest.KEY_SENDER_DATA))
                {
                    log.warn("Unexpected. Private message has no Sender details!");
                    return;
                }
                _loc_4 = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
            }
            _loc_2.sender = _loc_4;
            _loc_2.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            _loc_2.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PRIVATE_MESSAGE, _loc_2));
            return;
        }// end function

        public function handleBuddyMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            var _loc_3:* = param1.getInt(GenericMessageRequest.KEY_USER_ID);
            var _loc_4:* = this.sfs.buddyManager.getBuddyById(_loc_3);
            _loc_2.isItMe = this.sfs.mySelf.id == _loc_3;
            _loc_2.buddy = _loc_4;
            _loc_2.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            _loc_2.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_MESSAGE, _loc_2));
            return;
        }// end function

        public function handleModMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            _loc_2.sender = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
            _loc_2.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            _loc_2.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.MODERATOR_MESSAGE, _loc_2));
            return;
        }// end function

        public function handleAdminMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            _loc_2.sender = SFSUser.fromSFSArray(param1.getSFSArray(GenericMessageRequest.KEY_SENDER_DATA));
            _loc_2.message = param1.getUtfString(GenericMessageRequest.KEY_MESSAGE);
            _loc_2.data = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ADMIN_MESSAGE, _loc_2));
            return;
        }// end function

        public function handleObjectMessage(param1:ISFSObject) : void
        {
            var _loc_2:Object = {};
            var _loc_3:* = param1.getInt(GenericMessageRequest.KEY_USER_ID);
            _loc_2.sender = this.sfs.userManager.getUserById(_loc_3);
            _loc_2.message = param1.getSFSObject(GenericMessageRequest.KEY_XTRA_PARAMS);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.OBJECT_MESSAGE, _loc_2));
            return;
        }// end function

        private function fnUserExitRoom(param1:IMessage) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getInt("r");
            var _loc_5:* = _loc_2.getInt("u");
            var _loc_6:* = this.sfs.roomManager.getRoomById(_loc_4);
            var _loc_7:* = this.sfs.userManager.getUserById(_loc_5);
            if (_loc_6 != null && _loc_7 != null)
            {
                _loc_6.removeUser(_loc_7);
                this.sfs.userManager.removeUser(_loc_7);
                if (_loc_7.isItMe && _loc_6.isJoined)
                {
                    _loc_6.isJoined = false;
                    if (this.sfs.joinedRooms.length == 0)
                    {
                        this.sfs.lastJoinedRoom = null;
                    }
                    if (!_loc_6.isManaged)
                    {
                        this.sfs.roomManager.removeRoom(_loc_6);
                    }
                }
                _loc_3.user = _loc_7;
                _loc_3.room = _loc_6;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_EXIT_ROOM, _loc_3));
            }
            else
            {
                log.debug("Failed to handle UserExit event. Room: " + _loc_6 + ", User: " + _loc_7);
            }
            return;
        }// end function

        private function fnClientDisconnection(param1:IMessage) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:* = _loc_2.getByte("dr");
            this.sfs.handleClientDisconnection(ClientDisconnectionReason.getReason(_loc_3));
            return;
        }// end function

        private function fnSetRoomVariables(param1:IMessage) : void
        {
            var _loc_8:int = 0;
            var _loc_9:RoomVariable = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getInt(SetRoomVariablesRequest.KEY_VAR_ROOM);
            var _loc_5:* = _loc_2.getSFSArray(SetRoomVariablesRequest.KEY_VAR_LIST);
            var _loc_6:* = this.sfs.roomManager.getRoomById(_loc_4);
            var _loc_7:Array = [];
            if (_loc_6 != null)
            {
                _loc_8 = 0;
                while (_loc_8 < _loc_5.size())
                {
                    
                    _loc_9 = SFSRoomVariable.fromSFSArray(_loc_5.getSFSArray(_loc_8));
                    _loc_6.setVariable(_loc_9);
                    _loc_7.push(_loc_9.name);
                    _loc_8++;
                }
                _loc_3.changedVars = _loc_7;
                _loc_3.room = _loc_6;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_VARIABLES_UPDATE, _loc_3));
            }
            else
            {
                log.warn("RoomVariablesUpdate, unknown Room id = " + _loc_4);
            }
            return;
        }// end function

        private function fnSetUserVariables(param1:IMessage) : void
        {
            var _loc_8:int = 0;
            var _loc_9:UserVariable = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getInt(SetUserVariablesRequest.KEY_USER);
            var _loc_5:* = _loc_2.getSFSArray(SetUserVariablesRequest.KEY_VAR_LIST);
            var _loc_6:* = this.sfs.userManager.getUserById(_loc_4);
            var _loc_7:Array = [];
            if (_loc_6 != null)
            {
                _loc_8 = 0;
                while (_loc_8 < _loc_5.size())
                {
                    
                    _loc_9 = SFSUserVariable.fromSFSArray(_loc_5.getSFSArray(_loc_8));
                    _loc_6.setVariable(_loc_9);
                    _loc_7.push(_loc_9.name);
                    _loc_8++;
                }
                _loc_3.changedVars = _loc_7;
                _loc_3.user = _loc_6;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_VARIABLES_UPDATE, _loc_3));
            }
            else
            {
                log.warn("UserVariablesUpdate: unknown user id = " + _loc_4);
            }
            return;
        }// end function

        private function fnSubscribeRoomGroup(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:ISFSArray = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
                _loc_5 = _loc_2.getSFSArray(SubscribeRoomGroupRequest.KEY_ROOM_LIST);
                if (this.sfs.roomManager.containsGroup(_loc_4))
                {
                    log.warn("SubscribeGroup Error. Group:", _loc_4, "already subscribed!");
                }
                this.populateRoomList(_loc_5);
                _loc_3.groupId = _loc_4;
                _loc_3.newRooms = this.sfs.roomManager.getRoomListFromGroup(_loc_4);
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE, _loc_3));
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnUnsubscribeRoomGroup(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(SubscribeRoomGroupRequest.KEY_GROUP_ID);
                if (!this.sfs.roomManager.containsGroup(_loc_4))
                {
                    log.warn("UnsubscribeGroup Error. Group:", _loc_4, "is not subscribed!");
                }
                this.sfs.roomManager.removeGroup(_loc_4);
                _loc_3.groupId = _loc_4;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE, _loc_3));
            }
            else
            {
                _loc_5 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_6 = SFSErrorCodes.getErrorMessage(_loc_5, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_6, errorCode:_loc_5};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_GROUP_UNSUBSCRIBE_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnChangeRoomName(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:Room = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getInt(ChangeRoomNameRequest.KEY_ROOM);
                _loc_5 = this.sfs.roomManager.getRoomById(_loc_4);
                if (_loc_5 != null)
                {
                    _loc_3.oldName = _loc_5.name;
                    this.sfs.roomManager.changeRoomName(_loc_5, _loc_2.getUtfString(ChangeRoomNameRequest.KEY_NAME));
                    _loc_3.room = _loc_5;
                    this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE, _loc_3));
                }
                else
                {
                    log.warn("Room not found, ID:", _loc_4, ", Room name change failed.");
                }
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_NAME_CHANGE_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnChangeRoomPassword(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:Room = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getInt(ChangeRoomPasswordStateRequest.KEY_ROOM);
                _loc_5 = this.sfs.roomManager.getRoomById(_loc_4);
                if (_loc_5 != null)
                {
                    this.sfs.roomManager.changeRoomPasswordState(_loc_5, _loc_2.getBool(ChangeRoomPasswordStateRequest.KEY_PASS));
                    _loc_3.room = _loc_5;
                    this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE, _loc_3));
                }
                else
                {
                    log.warn("Room not found, ID:", _loc_4, ", Room password change failed.");
                }
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_PASSWORD_STATE_CHANGE_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnChangeRoomCapacity(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:Room = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getInt(ChangeRoomCapacityRequest.KEY_ROOM);
                _loc_5 = this.sfs.roomManager.getRoomById(_loc_4);
                if (_loc_5 != null)
                {
                    this.sfs.roomManager.changeRoomCapacity(_loc_5, _loc_2.getInt(ChangeRoomCapacityRequest.KEY_USER_SIZE), _loc_2.getInt(ChangeRoomCapacityRequest.KEY_SPEC_SIZE));
                    _loc_3.room = _loc_5;
                    this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE, _loc_3));
                }
                else
                {
                    log.warn("Room not found, ID:", _loc_4, ", Room capacity change failed.");
                }
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_CAPACITY_CHANGE_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnLogout(param1:IMessage) : void
        {
            this.sfs.handleLogout();
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            _loc_3.zoneName = _loc_2.getUtfString(LogoutRequest.KEY_ZONE_NAME);
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.LOGOUT, _loc_3));
            return;
        }// end function

        private function fnSpectatorToPlayer(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:User = null;
            var _loc_8:Room = null;
            var _loc_9:int = 0;
            var _loc_10:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getInt(SpectatorToPlayerRequest.KEY_ROOM_ID);
                _loc_5 = _loc_2.getInt(SpectatorToPlayerRequest.KEY_USER_ID);
                _loc_6 = _loc_2.getShort(SpectatorToPlayerRequest.KEY_PLAYER_ID);
                _loc_7 = this.sfs.userManager.getUserById(_loc_5);
                _loc_8 = this.sfs.roomManager.getRoomById(_loc_4);
                if (_loc_8 != null)
                {
                    if (_loc_7 != null)
                    {
                        if (_loc_7.isJoinedInRoom(_loc_8))
                        {
                            _loc_7.setPlayerId(_loc_6, _loc_8);
                            _loc_3.room = _loc_8;
                            _loc_3.user = _loc_7;
                            _loc_3.playerId = _loc_6;
                            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER, _loc_3));
                        }
                        else
                        {
                            log.warn("User: " + _loc_7 + " not joined in Room: ", _loc_8, ", SpectatorToPlayer failed.");
                        }
                    }
                    else
                    {
                        log.warn("User not found, ID:", _loc_5, ", SpectatorToPlayer failed.");
                    }
                }
                else
                {
                    log.warn("Room not found, ID:", _loc_4, ", SpectatorToPlayer failed.");
                }
            }
            else
            {
                _loc_9 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_10 = SFSErrorCodes.getErrorMessage(_loc_9, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_10, errorCode:_loc_9};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.SPECTATOR_TO_PLAYER_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnPlayerToSpectator(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:User = null;
            var _loc_7:Room = null;
            var _loc_8:int = 0;
            var _loc_9:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getInt(PlayerToSpectatorRequest.KEY_ROOM_ID);
                _loc_5 = _loc_2.getInt(PlayerToSpectatorRequest.KEY_USER_ID);
                _loc_6 = this.sfs.userManager.getUserById(_loc_5);
                _loc_7 = this.sfs.roomManager.getRoomById(_loc_4);
                if (_loc_7 != null)
                {
                    if (_loc_6 != null)
                    {
                        if (_loc_6.isJoinedInRoom(_loc_7))
                        {
                            _loc_6.setPlayerId(-1, _loc_7);
                            _loc_3.room = _loc_7;
                            _loc_3.user = _loc_6;
                            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR, _loc_3));
                        }
                        else
                        {
                            log.warn("User: " + _loc_6 + " not joined in Room: ", _loc_7, ", PlayerToSpectator failed.");
                        }
                    }
                    else
                    {
                        log.warn("User not found, ID:", _loc_5, ", PlayerToSpectator failed.");
                    }
                }
                else
                {
                    log.warn("Room not found, ID:", _loc_4, ", PlayerToSpectator failed.");
                }
            }
            else
            {
                _loc_8 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_9 = SFSErrorCodes.getErrorMessage(_loc_8, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_9, errorCode:_loc_8};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.PLAYER_TO_SPECTATOR_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnInitBuddyList(param1:IMessage) : void
        {
            var _loc_4:ISFSArray = null;
            var _loc_5:ISFSArray = null;
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:Buddy = null;
            var _loc_10:int = 0;
            var _loc_11:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getSFSArray(InitBuddyListRequest.KEY_BLIST);
                _loc_5 = _loc_2.getSFSArray(InitBuddyListRequest.KEY_MY_VARS);
                _loc_6 = _loc_2.getUtfStringArray(InitBuddyListRequest.KEY_BUDDY_STATES);
                this.sfs.buddyManager.clearAll();
                _loc_7 = 0;
                while (_loc_7 < _loc_4.size())
                {
                    
                    _loc_9 = SFSBuddy.fromSFSArray(_loc_4.getSFSArray(_loc_7));
                    this.sfs.buddyManager.addBuddy(_loc_9);
                    _loc_7++;
                }
                if (_loc_6 != null)
                {
                    this.sfs.buddyManager.setBuddyStates(_loc_6);
                }
                _loc_8 = [];
                _loc_7 = 0;
                while (_loc_7 < _loc_5.size())
                {
                    
                    _loc_8.push(SFSBuddyVariable.fromSFSArray(_loc_5.getSFSArray(_loc_7)));
                    _loc_7++;
                }
                this.sfs.buddyManager.setMyVariables(_loc_8);
                this.sfs.buddyManager.setInited();
                _loc_3.buddyList = this.sfs.buddyManager.buddyList;
                _loc_3.myVariables = this.sfs.buddyManager.myVariables;
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_LIST_INIT, _loc_3));
            }
            else
            {
                _loc_10 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_11 = SFSErrorCodes.getErrorMessage(_loc_10, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_11, errorCode:_loc_10};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnAddBuddy(param1:IMessage) : void
        {
            var _loc_4:Buddy = null;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = SFSBuddy.fromSFSArray(_loc_2.getSFSArray(AddBuddyRequest.KEY_BUDDY_NAME));
                this.sfs.buddyManager.addBuddy(_loc_4);
                _loc_3.buddy = _loc_4;
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ADD, _loc_3));
            }
            else
            {
                _loc_5 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_6 = SFSErrorCodes.getErrorMessage(_loc_5, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_6, errorCode:_loc_5};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnRemoveBuddy(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:Buddy = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(RemoveBuddyRequest.KEY_BUDDY_NAME);
                _loc_5 = this.sfs.buddyManager.removeBuddyByName(_loc_4);
                if (_loc_5 != null)
                {
                    _loc_3.buddy = _loc_5;
                    this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_REMOVE, _loc_3));
                }
                else
                {
                    log.warn("RemoveBuddy failed, buddy not found: " + _loc_4);
                }
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnBlockBuddy(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:Buddy = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(BlockBuddyRequest.KEY_BUDDY_NAME);
                _loc_5 = this.sfs.buddyManager.getBuddyByName(_loc_4);
                if (_loc_5 != null)
                {
                    _loc_5.setBlocked(_loc_2.getBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE));
                    _loc_3.buddy = _loc_5;
                    this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_BLOCK, _loc_3));
                }
                else
                {
                    log.warn("BlockBuddy failed, buddy not found: " + _loc_4 + ", in local BuddyList");
                }
            }
            else
            {
                _loc_6 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_7 = SFSErrorCodes.getErrorMessage(_loc_6, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_7, errorCode:_loc_6};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnGoOnline(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:Buddy = null;
            var _loc_6:Boolean = false;
            var _loc_7:int = 0;
            var _loc_8:Boolean = false;
            var _loc_9:Boolean = false;
            var _loc_10:int = 0;
            var _loc_11:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(GoOnlineRequest.KEY_BUDDY_NAME);
                _loc_5 = this.sfs.buddyManager.getBuddyByName(_loc_4);
                _loc_6 = _loc_4 == this.sfs.mySelf.name;
                _loc_7 = _loc_2.getByte(GoOnlineRequest.KEY_ONLINE);
                _loc_8 = _loc_7 == BuddyOnlineState.ONLINE;
                _loc_9 = true;
                if (_loc_6)
                {
                    if (this.sfs.buddyManager.myOnlineState != _loc_8)
                    {
                        log.warn("Unexpected: MyOnlineState is not in synch with the server. Resynching: " + _loc_8);
                        this.sfs.buddyManager.setMyOnlineState(_loc_8);
                    }
                }
                else if (_loc_5 != null)
                {
                    _loc_5.setId(_loc_2.getInt(GoOnlineRequest.KEY_BUDDY_ID));
                    _loc_5.setVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE, _loc_8));
                    if (_loc_7 == BuddyOnlineState.LEFT_THE_SERVER)
                    {
                        _loc_5.clearVolatileVariables();
                    }
                    _loc_9 = this.sfs.buddyManager.myOnlineState;
                }
                else
                {
                    log.warn("GoOnline error, buddy not found: " + _loc_4 + ", in local BuddyList.");
                    return;
                }
                if (_loc_9)
                {
                    _loc_3.buddy = _loc_5;
                    _loc_3.isItMe = _loc_6;
                    this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ONLINE_STATE_UPDATE, _loc_3));
                }
            }
            else
            {
                _loc_10 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_11 = SFSErrorCodes.getErrorMessage(_loc_10, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_11, errorCode:_loc_10};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnSetBuddyVariables(param1:IMessage) : void
        {
            var _loc_4:String = null;
            var _loc_5:ISFSArray = null;
            var _loc_6:Buddy = null;
            var _loc_7:Boolean = false;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
            var _loc_10:Boolean = false;
            var _loc_11:int = 0;
            var _loc_12:BuddyVariable = null;
            var _loc_13:int = 0;
            var _loc_14:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getUtfString(SetBuddyVariablesRequest.KEY_BUDDY_NAME);
                _loc_5 = _loc_2.getSFSArray(SetBuddyVariablesRequest.KEY_BUDDY_VARS);
                _loc_6 = this.sfs.buddyManager.getBuddyByName(_loc_4);
                _loc_7 = _loc_4 == this.sfs.mySelf.name;
                _loc_8 = [];
                _loc_9 = [];
                _loc_10 = true;
                _loc_11 = 0;
                while (_loc_11 < _loc_5.size())
                {
                    
                    _loc_12 = SFSBuddyVariable.fromSFSArray(_loc_5.getSFSArray(_loc_11));
                    _loc_9.push(_loc_12);
                    _loc_8.push(_loc_12.name);
                    _loc_11++;
                }
                if (_loc_7)
                {
                    this.sfs.buddyManager.setMyVariables(_loc_9);
                }
                else if (_loc_6 != null)
                {
                    _loc_6.setVariables(_loc_9);
                    _loc_10 = this.sfs.buddyManager.myOnlineState;
                }
                else
                {
                    log.warn("Unexpected. Target of BuddyVariables update not found: " + _loc_4);
                    return;
                }
                if (_loc_10)
                {
                    _loc_3.isItMe = _loc_7;
                    _loc_3.changedVars = _loc_8;
                    _loc_3.buddy = _loc_6;
                    this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_VARIABLES_UPDATE, _loc_3));
                }
            }
            else
            {
                _loc_13 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_14 = SFSErrorCodes.getErrorMessage(_loc_13, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_14, errorCode:_loc_13};
                this.sfs.dispatchEvent(new SFSBuddyEvent(SFSBuddyEvent.BUDDY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnFindRooms(param1:IMessage) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getSFSArray(FindRoomsRequest.KEY_FILTERED_ROOMS);
            var _loc_5:Array = [];
            var _loc_6:int = 0;
            while (_loc_6 < _loc_4.size())
            {
                
                _loc_5.push(SFSRoom.fromSFSArray(_loc_4.getSFSArray(_loc_6)));
                _loc_6++;
            }
            _loc_3.rooms = _loc_5;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_FIND_RESULT, _loc_3));
            return;
        }// end function

        private function fnFindUsers(param1:IMessage) : void
        {
            var _loc_8:User = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:* = _loc_2.getSFSArray(FindUsersRequest.KEY_FILTERED_USERS);
            var _loc_5:Array = [];
            var _loc_6:* = this.sfs.mySelf;
            var _loc_7:int = 0;
            while (_loc_7 < _loc_4.size())
            {
                
                _loc_8 = SFSUser.fromSFSArray(_loc_4.getSFSArray(_loc_7));
                if (_loc_8.id == _loc_6.id)
                {
                    _loc_8 = _loc_6;
                }
                _loc_5.push(_loc_8);
                _loc_7++;
            }
            _loc_3.users = _loc_5;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.USER_FIND_RESULT, _loc_3));
            return;
        }// end function

        private function fnInviteUsers(param1:IMessage) : void
        {
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            var _loc_4:User = null;
            if (_loc_2.containsKey(InviteUsersRequest.KEY_USER_ID))
            {
                _loc_4 = this.sfs.userManager.getUserById(_loc_2.getInt(InviteUsersRequest.KEY_USER_ID));
            }
            else
            {
                _loc_4 = SFSUser.fromSFSArray(_loc_2.getSFSArray(InviteUsersRequest.KEY_USER));
            }
            var _loc_5:* = _loc_2.getShort(InviteUsersRequest.KEY_TIME);
            var _loc_6:* = _loc_2.getInt(InviteUsersRequest.KEY_INVITATION_ID);
            var _loc_7:* = _loc_2.getSFSObject(InviteUsersRequest.KEY_PARAMS);
            var _loc_8:* = new SFSInvitation(_loc_4, this.sfs.mySelf, _loc_5, _loc_7);
            new SFSInvitation(_loc_4, this.sfs.mySelf, _loc_5, _loc_7).com.smartfoxserver.v2.entities.invitation:Invitation::id = _loc_6;
            _loc_3.invitation = _loc_8;
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION, _loc_3));
            return;
        }// end function

        private function fnInvitationReply(param1:IMessage) : void
        {
            var _loc_4:User = null;
            var _loc_5:int = 0;
            var _loc_6:ISFSObject = null;
            var _loc_7:int = 0;
            var _loc_8:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.isNull(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = null;
                if (_loc_2.containsKey(InviteUsersRequest.KEY_USER_ID))
                {
                    _loc_4 = this.sfs.userManager.getUserById(_loc_2.getInt(InviteUsersRequest.KEY_USER_ID));
                }
                else
                {
                    _loc_4 = SFSUser.fromSFSArray(_loc_2.getSFSArray(InviteUsersRequest.KEY_USER));
                }
                _loc_5 = _loc_2.getUnsignedByte(InviteUsersRequest.KEY_REPLY_ID);
                _loc_6 = _loc_2.getSFSObject(InviteUsersRequest.KEY_PARAMS);
                _loc_3.invitee = _loc_4;
                _loc_3.reply = _loc_5;
                _loc_3.data = _loc_6;
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY, _loc_3));
            }
            else
            {
                _loc_7 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_8 = SFSErrorCodes.getErrorMessage(_loc_7, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_8, errorCode:_loc_7};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.INVITATION_REPLY_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnQuickJoinGame(param1:IMessage) : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            if (_loc_2.containsKey(BaseRequest.KEY_ERROR_CODE))
            {
                _loc_4 = _loc_2.getShort(BaseRequest.KEY_ERROR_CODE);
                _loc_5 = SFSErrorCodes.getErrorMessage(_loc_4, _loc_2.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
                _loc_3 = {errorMessage:_loc_5, errorCode:_loc_4};
                this.sfs.dispatchEvent(new SFSEvent(SFSEvent.ROOM_JOIN_ERROR, _loc_3));
            }
            return;
        }// end function

        private function fnPingPong(param1:IMessage) : void
        {
            var _loc_2:* = kernel::lagMonitor.onPingPong();
            var _loc_3:* = new SFSEvent(SFSEvent.PING_PONG, {lagValue:_loc_2});
            this.sfs.dispatchEvent(_loc_3);
            return;
        }// end function

        private function populateRoomList(param1:ISFSArray) : void
        {
            var _loc_4:ISFSArray = null;
            var _loc_5:Room = null;
            var _loc_2:* = this.sfs.roomManager;
            var _loc_3:int = 0;
            while (_loc_3 < param1.size())
            {
                
                _loc_4 = param1.getSFSArray(_loc_3);
                _loc_5 = SFSRoom.fromSFSArray(_loc_4);
                _loc_2.replaceRoom(_loc_5);
                _loc_3++;
            }
            return;
        }// end function

        private function getOrCreateUser(param1:ISFSArray, param2:Boolean = false, param3:Room = null) : User
        {
            var _loc_6:ISFSArray = null;
            var _loc_7:int = 0;
            var _loc_4:* = param1.getInt(0);
            var _loc_5:* = this.sfs.userManager.getUserById(_loc_4);
            if (this.sfs.userManager.getUserById(_loc_4) == null)
            {
                _loc_5 = SFSUser.fromSFSArray(param1, param3);
                _loc_5.userManager = this.sfs.userManager;
            }
            else if (param3 != null)
            {
                _loc_5.setPlayerId(param1.getShort(3), param3);
                _loc_6 = param1.getSFSArray(4);
                _loc_7 = 0;
                while (_loc_7 < _loc_6.size())
                {
                    
                    _loc_5.setVariable(SFSUserVariable.fromSFSArray(_loc_6.getSFSArray(_loc_7)));
                    _loc_7++;
                }
            }
            if (param2)
            {
                this.sfs.userManager.addUser(_loc_5);
            }
            return _loc_5;
        }// end function

    }
}
