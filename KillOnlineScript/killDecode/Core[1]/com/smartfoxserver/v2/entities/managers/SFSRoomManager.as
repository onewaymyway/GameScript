package com.smartfoxserver.v2.entities.managers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.util.*;
    import de.polygonal.ds.*;

    public class SFSRoomManager extends Object implements IRoomManager
    {
        private var _ownerZone:String;
        private var _groups:Array;
        private var _roomsById:HashMap;
        private var _roomsByName:HashMap;
        protected var _smartFox:SmartFox;

        public function SFSRoomManager(param1:SmartFox)
        {
            this._groups = new Array();
            this._roomsById = new HashMap();
            this._roomsByName = new HashMap();
            return;
        }// end function

        public function get ownerZone() : String
        {
            return this._ownerZone;
        }// end function

        public function set ownerZone(param1:String) : void
        {
            this._ownerZone = param1;
            return;
        }// end function

        public function get smartFox() : SmartFox
        {
            return this._smartFox;
        }// end function

        public function addRoom(param1:Room, param2:Boolean = true) : void
        {
            this._roomsById.set(param1.id, param1);
            this._roomsByName.set(param1.name, param1);
            if (param2)
            {
                if (!this.containsGroup(param1.groupId))
                {
                    this.addGroup(param1.groupId);
                }
            }
            else
            {
                param1.isManaged = false;
            }
            return;
        }// end function

        public function replaceRoom(param1:Room, param2:Boolean = true) : Room
        {
            var _loc_3:* = this.getRoomById(param1.id);
            if (_loc_3 != null)
            {
                var _loc_4:* = _loc_3;
                _loc_4.kernel::merge(param1);
                return _loc_3;
            }
            this.addRoom(param1, param2);
            return param1;
        }// end function

        public function changeRoomName(param1:Room, param2:String) : void
        {
            var _loc_3:* = param1.name;
            param1.name = param2;
            this._roomsByName.set(param2, param1);
            this._roomsByName.clr(_loc_3);
            return;
        }// end function

        public function changeRoomPasswordState(param1:Room, param2:Boolean) : void
        {
            param1.setPasswordProtected(param2);
            return;
        }// end function

        public function changeRoomCapacity(param1:Room, param2:int, param3:int) : void
        {
            param1.maxUsers = param2;
            param1.maxSpectators = param3;
            return;
        }// end function

        public function getRoomGroups() : Array
        {
            return this._groups;
        }// end function

        public function addGroup(param1:String) : void
        {
            this._groups.push(param1);
            return;
        }// end function

        public function removeGroup(param1:String) : void
        {
            var _loc_3:Room = null;
            ArrayUtil.removeElement(this._groups, param1);
            var _loc_2:* = this.getRoomListFromGroup(param1);
            for each (_loc_3 in _loc_2)
            {
                
                if (!_loc_3.isJoined)
                {
                    this.removeRoom(_loc_3);
                    continue;
                }
                _loc_3.isManaged = false;
            }
            return;
        }// end function

        public function containsGroup(param1:String) : Boolean
        {
            return this._groups.indexOf(param1) > -1;
        }// end function

        public function containsRoom(param1) : Boolean
        {
            if (typeof(param1) == "number")
            {
                return this._roomsById.hasKey(param1);
            }
            return this._roomsByName.hasKey(param1);
        }// end function

        public function containsRoomInGroup(param1, param2:String) : Boolean
        {
            var _loc_6:Room = null;
            var _loc_3:* = this.getRoomListFromGroup(param2);
            var _loc_4:Boolean = false;
            var _loc_5:* = typeof(param1) == "number";
            for each (_loc_6 in _loc_3)
            {
                
                if (_loc_5)
                {
                    if (_loc_6.id == param1)
                    {
                        _loc_4 = true;
                        break;
                    }
                    continue;
                }
                if (_loc_6.name == param1)
                {
                    _loc_4 = true;
                    break;
                }
            }
            return _loc_4;
        }// end function

        public function getRoomById(param1:int) : Room
        {
            return this._roomsById.get(param1) as Room;
        }// end function

        public function getRoomByName(param1:String) : Room
        {
            return this._roomsByName.get(param1) as Room;
        }// end function

        public function getRoomList() : Array
        {
            return this._roomsById.toDA().getArray();
        }// end function

        public function getRoomCount() : int
        {
            return this._roomsById.size();
        }// end function

        public function getRoomListFromGroup(param1:String) : Array
        {
            var _loc_4:Room = null;
            var _loc_2:* = new Array();
            var _loc_3:* = this._roomsById.iterator();
            while (_loc_3.hasNext())
            {
                
                _loc_4 = _loc_3.next() as Room;
                if (_loc_4.groupId == param1)
                {
                    _loc_2.push(_loc_4);
                }
            }
            return _loc_2;
        }// end function

        public function removeRoom(param1:Room) : void
        {
            this._removeRoom(param1.id, param1.name);
            return;
        }// end function

        public function removeRoomById(param1:int) : void
        {
            var _loc_2:* = this._roomsById.get(param1) as Room;
            if (_loc_2 != null)
            {
                this._removeRoom(param1, _loc_2.name);
            }
            return;
        }// end function

        public function removeRoomByName(param1:String) : void
        {
            var _loc_2:* = this._roomsByName.get(param1) as Room;
            if (_loc_2 != null)
            {
                this._removeRoom(_loc_2.id, param1);
            }
            return;
        }// end function

        public function getJoinedRooms() : Array
        {
            var _loc_3:Room = null;
            var _loc_1:Array = [];
            var _loc_2:* = this._roomsById.iterator();
            while (_loc_2.hasNext())
            {
                
                _loc_3 = _loc_2.next() as Room;
                if (_loc_3.isJoined)
                {
                    _loc_1.push(_loc_3);
                }
            }
            return _loc_1;
        }// end function

        public function getUserRooms(param1:User) : Array
        {
            var _loc_4:Room = null;
            var _loc_2:Array = [];
            var _loc_3:* = this._roomsById.iterator();
            while (_loc_3.hasNext())
            {
                
                _loc_4 = _loc_3.next() as Room;
                if (_loc_4.containsUser(param1))
                {
                    _loc_2.push(_loc_4);
                }
            }
            return _loc_2;
        }// end function

        public function removeUser(param1:User) : void
        {
            var _loc_3:Room = null;
            var _loc_2:* = this._roomsById.iterator();
            while (_loc_2.hasNext())
            {
                
                _loc_3 = _loc_2.next() as Room;
                if (_loc_3.containsUser(param1))
                {
                    _loc_3.removeUser(param1);
                }
            }
            return;
        }// end function

        private function _removeRoom(param1:int, param2:String) : void
        {
            this._roomsById.clr(param1);
            this._roomsByName.clr(param2);
            return;
        }// end function

    }
}
