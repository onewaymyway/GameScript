package com.smartfoxserver.v2.entities.managers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.logging.*;
    import de.polygonal.ds.*;

    public class SFSUserManager extends Object implements IUserManager
    {
        private var _usersByName:HashMap;
        private var _usersById:HashMap;
        protected var _log:Logger;
        protected var _smartFox:SmartFox;

        public function SFSUserManager(param1:SmartFox)
        {
            this._smartFox = param1;
            this._log = Logger.getInstance();
            this._usersByName = new HashMap();
            this._usersById = new HashMap();
            return;
        }// end function

        public function containsUserName(param1:String) : Boolean
        {
            return this._usersByName.hasKey(param1);
        }// end function

        public function containsUserId(param1:int) : Boolean
        {
            return this._usersById.hasKey(param1);
        }// end function

        public function containsUser(param1:User) : Boolean
        {
            return this._usersByName.contains(param1);
        }// end function

        public function getUserByName(param1:String) : User
        {
            return this._usersByName.get(param1) as User;
        }// end function

        public function getUserById(param1:int) : User
        {
            return this._usersById.get(param1) as User;
        }// end function

        public function addUser(param1:User) : void
        {
            if (this._usersById.hasKey(param1.id))
            {
                this._log.warn("Unexpected: duplicate user in UserManager: " + param1);
            }
            this._addUser(param1);
            return;
        }// end function

        protected function _addUser(param1:User) : void
        {
            this._usersByName.set(param1.name, param1);
            this._usersById.set(param1.id, param1);
            return;
        }// end function

        public function removeUser(param1:User) : void
        {
            this._usersByName.clr(param1.name);
            this._usersById.clr(param1.id);
            return;
        }// end function

        public function removeUserById(param1:int) : void
        {
            var _loc_2:* = this._usersById.get(param1) as User;
            if (_loc_2 != null)
            {
                this.removeUser(_loc_2);
            }
            return;
        }// end function

        public function get userCount() : int
        {
            return this._usersById.size();
        }// end function

        public function get smartFox() : SmartFox
        {
            return this._smartFox;
        }// end function

        public function getUserList() : Array
        {
            var _loc_1:Array = [];
            var _loc_2:* = this._usersById.iterator();
            while (_loc_2.hasNext())
            {
                
                _loc_1.push(_loc_2.next());
            }
            return _loc_1;
        }// end function

        function clearAll() : void
        {
            this._usersByName = new HashMap();
            this._usersById = new HashMap();
            return;
        }// end function

    }
}
