package com.smartfoxserver.v2.entities.managers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.util.*;

    public class SFSBuddyManager extends Object implements IBuddyManager
    {
        protected var _buddiesByName:Object;
        protected var _myVariables:Object;
        protected var _myOnlineState:Boolean;
        protected var _inited:Boolean;
        private var _buddyStates:Array;
        private var _sfs:SmartFox;

        public function SFSBuddyManager(param1:SmartFox)
        {
            this._sfs = param1;
            this._buddiesByName = {};
            this._myVariables = {};
            this._inited = false;
            return;
        }// end function

        public function get isInited() : Boolean
        {
            return this._inited;
        }// end function

        public function setInited() : void
        {
            this._inited = true;
            return;
        }// end function

        public function addBuddy(param1:Buddy) : void
        {
            this._buddiesByName[param1.name] = param1;
            return;
        }// end function

        public function clearAll() : void
        {
            this._buddiesByName = {};
            return;
        }// end function

        public function removeBuddyById(param1:int) : Buddy
        {
            var _loc_2:* = this.getBuddyById(param1);
            if (_loc_2 != null)
            {
                delete this._buddiesByName[_loc_2.name];
            }
            return _loc_2;
        }// end function

        public function removeBuddyByName(param1:String) : Buddy
        {
            var _loc_2:* = this.getBuddyByName(param1);
            if (_loc_2 != null)
            {
                delete this._buddiesByName[param1];
            }
            return _loc_2;
        }// end function

        public function getBuddyById(param1:int) : Buddy
        {
            var _loc_2:Buddy = null;
            if (param1 > -1)
            {
                for each (_loc_2 in this._buddiesByName)
                {
                    
                    if (_loc_2.id == param1)
                    {
                        return _loc_2;
                    }
                }
            }
            return null;
        }// end function

        public function containsBuddy(param1:String) : Boolean
        {
            return this.getBuddyByName(param1) != null;
        }// end function

        public function getBuddyByName(param1:String) : Buddy
        {
            return this._buddiesByName[param1];
        }// end function

        public function getBuddyByNickName(param1:String) : Buddy
        {
            var _loc_2:Buddy = null;
            for each (_loc_2 in this._buddiesByName)
            {
                
                if (_loc_2.nickName == param1)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function get offlineBuddies() : Array
        {
            var _loc_2:Buddy = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._buddiesByName)
            {
                
                if (!_loc_2.isOnline)
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function get onlineBuddies() : Array
        {
            var _loc_2:Buddy = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._buddiesByName)
            {
                
                if (_loc_2.isOnline)
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function get buddyList() : Array
        {
            return ArrayUtil.objToArray(this._buddiesByName);
        }// end function

        public function getMyVariable(param1:String) : BuddyVariable
        {
            return this._myVariables[param1] as BuddyVariable;
        }// end function

        public function get myVariables() : Array
        {
            return ArrayUtil.objToArray(this._myVariables);
        }// end function

        public function get myOnlineState() : Boolean
        {
            if (!this._inited)
            {
                return false;
            }
            var _loc_1:Boolean = true;
            var _loc_2:* = this.getMyVariable(ReservedBuddyVariables.BV_ONLINE);
            if (_loc_2 != null)
            {
                _loc_1 = _loc_2.getBoolValue();
            }
            return _loc_1;
        }// end function

        public function get myNickName() : String
        {
            var _loc_1:* = this.getMyVariable(ReservedBuddyVariables.BV_NICKNAME);
            return _loc_1 != null ? (_loc_1.getStringValue()) : (null);
        }// end function

        public function get myState() : String
        {
            var _loc_1:* = this.getMyVariable(ReservedBuddyVariables.BV_STATE);
            return _loc_1 != null ? (_loc_1.getStringValue()) : (null);
        }// end function

        public function get buddyStates() : Array
        {
            return this._buddyStates;
        }// end function

        public function setMyVariable(param1:BuddyVariable) : void
        {
            this._myVariables[param1.name] = param1;
            return;
        }// end function

        public function setMyVariables(param1:Array) : void
        {
            var _loc_2:BuddyVariable = null;
            for each (_loc_2 in param1)
            {
                
                this.setMyVariable(_loc_2);
            }
            return;
        }// end function

        public function setMyOnlineState(param1:Boolean) : void
        {
            this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_ONLINE, param1));
            return;
        }// end function

        public function setMyNickName(param1:String) : void
        {
            this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_NICKNAME, param1));
            return;
        }// end function

        public function setMyState(param1:String) : void
        {
            this.setMyVariable(new SFSBuddyVariable(ReservedBuddyVariables.BV_STATE, param1));
            return;
        }// end function

        public function setBuddyStates(param1:Array) : void
        {
            this._buddyStates = param1;
            return;
        }// end function

    }
}
