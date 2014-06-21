package com.smartfoxserver.v2.entities
{
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.util.*;

    public class SFSBuddy extends Object implements Buddy
    {
        protected var _name:String;
        protected var _id:int;
        protected var _isBlocked:Boolean;
        protected var _variables:Object;
        protected var _isTemp:Boolean;

        public function SFSBuddy(param1:int, param2:String, param3:Boolean = false, param4:Boolean = false)
        {
            this._id = param1;
            this._name = param2;
            this._isBlocked = param3;
            this._variables = {};
            this._isTemp = param4;
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

        public function get isBlocked() : Boolean
        {
            return this._isBlocked;
        }// end function

        public function get isTemp() : Boolean
        {
            return this._isTemp;
        }// end function

        public function get isOnline() : Boolean
        {
            var _loc_1:* = this.getVariable(ReservedBuddyVariables.BV_ONLINE);
            var _loc_2:* = _loc_1 == null ? (true) : (_loc_1.getBoolValue());
            return _loc_2 && this._id > -1;
        }// end function

        public function get state() : String
        {
            var _loc_1:* = this.getVariable(ReservedBuddyVariables.BV_STATE);
            return _loc_1 == null ? (null) : (_loc_1.getStringValue());
        }// end function

        public function get nickName() : String
        {
            var _loc_1:* = this.getVariable(ReservedBuddyVariables.BV_NICKNAME);
            return _loc_1 == null ? (null) : (_loc_1.getStringValue());
        }// end function

        public function get variables() : Array
        {
            return ArrayUtil.objToArray(this._variables);
        }// end function

        public function getVariable(param1:String) : BuddyVariable
        {
            return this._variables[param1];
        }// end function

        public function getOfflineVariables() : Array
        {
            var _loc_2:BuddyVariable = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._variables)
            {
                
                if (_loc_2.name.charAt(0) == SFSBuddyVariable.OFFLINE_PREFIX)
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function getOnlineVariables() : Array
        {
            var _loc_2:BuddyVariable = null;
            var _loc_1:Array = [];
            for each (_loc_2 in this._variables)
            {
                
                if (_loc_2.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
                {
                    _loc_1.push(_loc_2);
                }
            }
            return _loc_1;
        }// end function

        public function containsVariable(param1:String) : Boolean
        {
            return this._variables[param1] != null;
        }// end function

        public function setVariable(param1:BuddyVariable) : void
        {
            this._variables[param1.name] = param1;
            return;
        }// end function

        public function setVariables(param1:Array) : void
        {
            var _loc_2:BuddyVariable = null;
            for each (_loc_2 in param1)
            {
                
                this.setVariable(_loc_2);
            }
            return;
        }// end function

        public function setId(param1:int) : void
        {
            this._id = param1;
            return;
        }// end function

        public function setBlocked(param1:Boolean) : void
        {
            this._isBlocked = param1;
            return;
        }// end function

        public function removeVariable(param1:String) : void
        {
            delete this._variables[param1];
            return;
        }// end function

        public function clearVolatileVariables() : void
        {
            var _loc_1:BuddyVariable = null;
            for each (_loc_1 in this.variables)
            {
                
                if (_loc_1.name.charAt(0) != SFSBuddyVariable.OFFLINE_PREFIX)
                {
                    this.removeVariable(_loc_1.name);
                }
            }
            return;
        }// end function

        public function toString() : String
        {
            return "[Buddy: " + this.name + ", id: " + this.id + "]";
        }// end function

        public static function fromSFSArray(param1:ISFSArray) : Buddy
        {
            var _loc_2:* = new SFSBuddy(param1.getInt(0), param1.getUtfString(1), param1.getBool(2), param1.size() > 3 ? (param1.getBool(4)) : (false));
            var _loc_3:* = param1.getSFSArray(3);
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.size())
            {
                
                _loc_2.setVariable(SFSBuddyVariable.fromSFSArray(_loc_3.getSFSArray(_loc_4)));
                _loc_4++;
            }
            return _loc_2;
        }// end function

    }
}
