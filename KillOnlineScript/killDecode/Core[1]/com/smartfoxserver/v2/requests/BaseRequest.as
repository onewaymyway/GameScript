﻿package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.entities.data.*;

    public class BaseRequest extends Object implements IRequest
    {
        protected var _sfso:ISFSObject;
        private var _id:int;
        protected var _targetController:int;
        private var _isEncrypted:Boolean;
        public static const Handshake:int = 0;
        public static const Login:int = 1;
        public static const Logout:int = 2;
        public static const GetRoomList:int = 3;
        public static const JoinRoom:int = 4;
        public static const AutoJoin:int = 5;
        public static const CreateRoom:int = 6;
        public static const GenericMessage:int = 7;
        public static const ChangeRoomName:int = 8;
        public static const ChangeRoomPassword:int = 9;
        public static const ObjectMessage:int = 10;
        public static const SetRoomVariables:int = 11;
        public static const SetUserVariables:int = 12;
        public static const CallExtension:int = 13;
        public static const LeaveRoom:int = 14;
        public static const SubscribeRoomGroup:int = 15;
        public static const UnsubscribeRoomGroup:int = 16;
        public static const SpectatorToPlayer:int = 17;
        public static const PlayerToSpectator:int = 18;
        public static const ChangeRoomCapacity:int = 19;
        public static const PublicMessage:int = 20;
        public static const PrivateMessage:int = 21;
        public static const ModeratorMessage:int = 22;
        public static const AdminMessage:int = 23;
        public static const KickUser:int = 24;
        public static const BanUser:int = 25;
        public static const ManualDisconnection:int = 26;
        public static const FindRooms:int = 27;
        public static const FindUsers:int = 28;
        public static const PingPong:int = 29;
        public static const InitBuddyList:int = 200;
        public static const AddBuddy:int = 201;
        public static const BlockBuddy:int = 202;
        public static const RemoveBuddy:int = 203;
        public static const SetBuddyVariables:int = 204;
        public static const GoOnline:int = 205;
        public static const InviteUser:int = 300;
        public static const InvitationReply:int = 301;
        public static const CreateSFSGame:int = 302;
        public static const QuickJoinGame:int = 303;
        public static const KEY_ERROR_CODE:String = "ec";
        public static const KEY_ERROR_PARAMS:String = "ep";

        public function BaseRequest(param1:int)
        {
            this._sfso = SFSObject.newInstance();
            this._targetController = 0;
            this._isEncrypted = false;
            this._id = param1;
            return;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        public function set id(param1:int) : void
        {
            this._id = param1;
            return;
        }// end function

        public function getMessage() : IMessage
        {
            var _loc_1:* = new Message();
            _loc_1.id = this._id;
            _loc_1.isEncrypted = this._isEncrypted;
            _loc_1.targetController = this._targetController;
            _loc_1.content = this._sfso;
            if (this is ExtensionRequest)
            {
                _loc_1.isUDP = (this as ExtensionRequest).useUDP;
            }
            return _loc_1;
        }// end function

        public function get targetController() : int
        {
            return this._targetController;
        }// end function

        public function set targetController(param1:int) : void
        {
            this._targetController = param1;
            return;
        }// end function

        public function get isEncrypted() : Boolean
        {
            return this._isEncrypted;
        }// end function

        public function set isEncrypted(param1:Boolean) : void
        {
            this._isEncrypted = param1;
            return;
        }// end function

        public function validate(param1:SmartFox) : void
        {
            return;
        }// end function

        public function execute(param1:SmartFox) : void
        {
            return;
        }// end function

    }
}
