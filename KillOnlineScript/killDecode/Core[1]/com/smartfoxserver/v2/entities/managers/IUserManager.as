package com.smartfoxserver.v2.entities.managers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;

    public interface IUserManager
    {

        public function IUserManager();

        function containsUserName(param1:String) : Boolean;

        function containsUserId(param1:int) : Boolean;

        function containsUser(param1:User) : Boolean;

        function getUserByName(param1:String) : User;

        function getUserById(param1:int) : User;

        function addUser(param1:User) : void;

        function removeUser(param1:User) : void;

        function removeUserById(param1:int) : void;

        function get userCount() : int;

        function getUserList() : Array;

        function get smartFox() : SmartFox;

    }
}
