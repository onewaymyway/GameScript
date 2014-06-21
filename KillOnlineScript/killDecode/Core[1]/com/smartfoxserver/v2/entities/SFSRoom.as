package com.smartfoxserver.v2.entities
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.managers.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.util.*;

    public class SFSRoom extends Object implements Room
    {
        protected var _id:int;
        protected var _name:String;
        protected var _groupId:String;
        protected var _isGame:Boolean;
        protected var _isHidden:Boolean;
        protected var _isJoined:Boolean;
        protected var _isPasswordProtected:Boolean;
        protected var _isManaged:Boolean;
        protected var _variables:Object;
        protected var _properties:Object;
        protected var _userManager:IUserManager;
        protected var _maxUsers:int;
        protected var _maxSpectators:int;
        protected var _userCount:int;
        protected var _specCount:int;
        protected var _roomManager:IRoomManager;

        public function SFSRoom(param1:int, param2:String, param3:String = "default")
        {
            this._id = param1;
            this._name = param2;
            this._groupId = param3;
            var _loc_4:Boolean = false;
            this._isHidden = false;
            var _loc_4:* = _loc_4;
            this._isGame = _loc_4;
            this._isJoined = _loc_4;
            this._isManaged = true;
            var _loc_4:int = 0;
            this._specCount = 0;
            this._userCount = _loc_4;
            this._variables = new Object();
            this._properties = new Object();
            this._userManager = new SFSUserManager(null);
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

        public function set name(param1:String) : void
        {
            this._name = param1;
            return;
        }// end function

        public function get groupId() : String
        {
            return this._groupId;
        }// end function

        public function get isGame() : Boolean
        {
            return this._isGame;
        }// end function

        public function get isHidden() : Boolean
        {
            return this._isHidden;
        }// end function

        public function get isJoined() : Boolean
        {
            return this._isJoined;
        }// end function

        public function get isPasswordProtected() : Boolean
        {
            return this._isPasswordProtected;
        }// end function

        public function set isPasswordProtected(param1:Boolean) : void
        {
            this._isPasswordProtected = param1;
            return;
        }// end function

        public function set isJoined(param1:Boolean) : void
        {
            this._isJoined = param1;
            return;
        }// end function

        public function set isGame(param1:Boolean) : void
        {
            this._isGame = param1;
            return;
        }// end function

        public function set isHidden(param1:Boolean) : void
        {
            this._isHidden = param1;
            return;
        }// end function

        public function get isManaged() : Boolean
        {
            return this._isManaged;
        }// end function

        public function set isManaged(param1:Boolean) : void
        {
            this._isManaged = param1;
            return;
        }// end function

        public function getVariables() : Array
        {
            return ArrayUtil.objToArray(this._variables);
        }// end function

        public function getVariable(param1:String) : RoomVariable
        {
            return this._variables[param1];
        }// end function

        public function get userCount() : int
        {
            if (this._isJoined)
            {
                return this._userManager.userCount;
            }
            return this._userCount;
        }// end function

        public function get maxUsers() : int
        {
            return this._maxUsers;
        }// end function

        public function get capacity() : int
        {
            return this._maxUsers + this._maxSpectators;
        }// end function

        public function get spectatorCount() : int
        {
            var _loc_1:int = 0;
            var _loc_2:User = null;
            if (this._isJoined)
            {
                _loc_1 = 0;
                for each (_loc_2 in this._userManager.getUserList())
                {
                    
                    if (_loc_2.isSpectatorInRoom(this))
                    {
                        _loc_1++;
                    }
                }
                return _loc_1;
            }
            else
            {
                return this._specCount;
            }
        }// end function

        public function get maxSpectators() : int
        {
            return this._maxSpectators;
        }// end function

        public function set userCount(param1:int) : void
        {
            this._userCount = param1;
            return;
        }// end function

        public function set maxUsers(param1:int) : void
        {
            this._maxUsers = param1;
            return;
        }// end function

        public function set spectatorCount(param1:int) : void
        {
            this._specCount = param1;
            return;
        }// end function

        public function set maxSpectators(param1:int) : void
        {
            this._maxSpectators = param1;
            return;
        }// end function

        public function getUserByName(param1:String) : User
        {
            return this._userManager.getUserByName(param1);
        }// end function

        public function getUserById(param1:int) : User
        {
            return this._userManager.getUserById(param1);
        }// end function

        public function get userList() : Array
        {
            return this._userManager.getUserList();
        }// end function

        public function get playerList() : Array
        {
            var _loc_2:User = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._userManager.getUserList())
            {
                
                if (_loc_2.isPlayerInRoom(this))
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function get spectatorList() : Array
        {
            var _loc_2:User = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._userManager.getUserList())
            {
                
                if (_loc_2.isSpectatorInRoom(this))
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function removeUser(param1:User) : void
        {
            this._userManager.removeUser(param1);
            return;
        }// end function

        public function setVariable(param1:RoomVariable) : void
        {
            if (param1.isNull())
            {
                delete this._variables[param1.name];
            }
            else
            {
                this._variables[param1.name] = param1;
            }
            return;
        }// end function

        public function setVariables(param1:Array) : void
        {
            var _loc_2:RoomVariable = null;
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

        public function addUser(param1:User) : void
        {
            this._userManager.addUser(param1);
            return;
        }// end function

        public function containsUser(param1:User) : Boolean
        {
            return this._userManager.containsUser(param1);
        }// end function

        public function get roomManager() : IRoomManager
        {
            return this._roomManager;
        }// end function

        public function set roomManager(param1:IRoomManager) : void
        {
            if (this._roomManager != null)
            {
                throw new SFSError("Room manager already assigned. Room: " + this);
            }
            this._roomManager = param1;
            return;
        }// end function

        public function setPasswordProtected(param1:Boolean) : void
        {
            this._isPasswordProtected = param1;
            return;
        }// end function

        public function toString() : String
        {
            return "[Room: " + this._name + ", Id: " + this._id + ", GroupId: " + this._groupId + "]";
        }// end function

        function merge(param1:Room) : void
        {
            var _loc_2:RoomVariable = null;
            var _loc_3:User = null;
            for each (_loc_2 in param1.getVariables())
            {
                
                this._variables[_loc_2.name] = _loc_2;
            }
            var _loc_4:* = this._userManager;
            _loc_4.kernel::clearAll();
            for each (_loc_3 in param1.userList)
            {
                
                this._userManager.addUser(_loc_3);
            }
            return;
        }// end function

        public static function fromSFSArray(param1:ISFSArray) : Room
        {
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:RoomVariable = null;
            var _loc_2:* = new SFSRoom(param1.getInt(0), param1.getUtfString(1), param1.getUtfString(2));
            _loc_2.isGame = param1.getBool(3);
            _loc_2.isHidden = param1.getBool(4);
            _loc_2.isPasswordProtected = param1.getBool(5);
            _loc_2.userCount = param1.getShort(6);
            _loc_2.maxUsers = param1.getShort(7);
            var _loc_3:* = param1.getSFSArray(8);
            if (_loc_3.size() > 0)
            {
                _loc_4 = new Array();
                _loc_5 = 0;
                while (_loc_5 < _loc_3.size())
                {
                    
                    _loc_6 = SFSRoomVariable.fromSFSArray(_loc_3.getSFSArray(_loc_5));
                    _loc_4.push(_loc_6);
                    _loc_5++;
                }
                _loc_2.setVariables(_loc_4);
            }
            if (_loc_2.isGame)
            {
                _loc_2.spectatorCount = param1.getShort(9);
                _loc_2.maxSpectators = param1.getShort(10);
            }
            return _loc_2;
        }// end function

    }
}
