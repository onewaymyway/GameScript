package com.smartfoxserver.v2.entities
{
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.managers.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SFSUser extends Object implements User
    {
        protected var _id:int = -1;
        protected var _privilegeId:int = 0;
        protected var _name:String;
        protected var _isItMe:Boolean;
        protected var _variables:Object;
        protected var _properties:Object;
        protected var _isModerator:Boolean;
        protected var _playerIdByRoomId:Object;
        protected var _userManager:IUserManager;

        public function SFSUser(param1:int, param2:String, param3:Boolean = false)
        {
            this._id = param1;
            this._name = param2;
            this._isItMe = param3;
            this._variables = {};
            this._properties = {};
            this._isModerator = false;
            this._playerIdByRoomId = {};
            return;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get playerId() : int
        {
            return this.getPlayerId(this.userManager.smartFox.lastJoinedRoom);
        }// end function

        public function isJoinedInRoom(param1:Room) : Boolean
        {
            return param1.containsUser(this);
        }// end function

        public function get privilegeId() : int
        {
            return this._privilegeId;
        }// end function

        public function set privilegeId(param1:int) : void
        {
            this._privilegeId = param1;
            return;
        }// end function

        public function isGuest() : Boolean
        {
            return this._privilegeId == UserPrivileges.GUEST;
        }// end function

        public function isStandardUser() : Boolean
        {
            return this._privilegeId == UserPrivileges.STANDARD;
        }// end function

        public function isModerator() : Boolean
        {
            return this._privilegeId == UserPrivileges.MODERATOR;
        }// end function

        public function isAdmin() : Boolean
        {
            return this._privilegeId == UserPrivileges.ADMINISTRATOR;
        }// end function

        public function get isPlayer() : Boolean
        {
            return this.playerId > 0;
        }// end function

        public function get isSpectator() : Boolean
        {
            return !this.isPlayer;
        }// end function

        public function getPlayerId(param1:Room) : int
        {
            var _loc_2:int = 0;
            if (this._playerIdByRoomId[param1.id] != null)
            {
                _loc_2 = this._playerIdByRoomId[param1.id];
            }
            return _loc_2;
        }// end function

        public function setPlayerId(param1:int, param2:Room) : void
        {
            this._playerIdByRoomId[param2.id] = param1;
            return;
        }// end function

        public function removePlayerId(param1:Room) : void
        {
            delete this._playerIdByRoomId[param1.id];
            return;
        }// end function

        public function isPlayerInRoom(param1:Room) : Boolean
        {
            return this._playerIdByRoomId[param1.id] > 0;
        }// end function

        public function isSpectatorInRoom(param1:Room) : Boolean
        {
            return this._playerIdByRoomId[param1.id] < 0;
        }// end function

        public function get isItMe() : Boolean
        {
            return this._isItMe;
        }// end function

        public function get userManager() : IUserManager
        {
            return this._userManager;
        }// end function

        public function set userManager(param1:IUserManager) : void
        {
            if (this._userManager != null)
            {
                throw new SFSError("Cannot re-assign the User Manager. Already set. User: " + this);
            }
            this._userManager = param1;
            return;
        }// end function

        public function getVariables() : Array
        {
            var _loc_2:SFSUserVariable = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._variables)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function getVariable(param1:String) : UserVariable
        {
            return this._variables[param1];
        }// end function

        public function setVariable(param1:UserVariable) : void
        {
            if (param1 != null)
            {
                if (param1.isNull())
                {
                    delete this._variables[param1.name];
                }
                else
                {
                    this._variables[param1.name] = param1;
                }
            }
            return;
        }// end function

        public function setVariables(param1:Array) : void
        {
            var _loc_2:UserVariable = null;
            for each (_loc_2 in param1)
            {
                
                this.setVariable(_loc_2);
            }
            return;
        }// end function

        public function containsVariable(param1:String) : Boolean
        {
            return this._variables[param1] != null;
        }// end function

        private function removeUserVariable(param1:String) : void
        {
            delete this._variables[param1];
            return;
        }// end function

        public function get properties() : Object
        {
            return this._properties;
        }// end function

        public function set properties(param1:Object) : void
        {
            this._properties = param1;
            return;
        }// end function

        public function toString() : String
        {
            return "[User: " + this._name + ", Id: " + this._id + ", isMe: " + this._isItMe + "]";
        }// end function

        public static function fromSFSArray(param1:ISFSArray, param2:Room = null) : User
        {
            var _loc_3:* = new SFSUser(param1.getInt(0), param1.getUtfString(1));
            _loc_3.privilegeId = param1.getShort(2);
            if (param2 != null)
            {
                _loc_3.setPlayerId(param1.getShort(3), param2);
            }
            var _loc_4:* = param1.getSFSArray(4);
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4.size())
            {
                
                _loc_3.setVariable(SFSUserVariable.fromSFSArray(_loc_4.getSFSArray(_loc_5)));
                _loc_5++;
            }
            return _loc_3;
        }// end function

    }
}
