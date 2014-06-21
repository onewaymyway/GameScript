﻿package com.smartfoxserver.v2.util
{

    public class SFSErrorCodes extends Object
    {
        private static var errorsByCode:Array = ["Client API version is obsolete: {0}; required version: {1}", "Requested Zone {0} does not exist", "User name {0} is not recognized", "Wrong password for user {0}", "User {0} is banned", "Zone {0} is full", "User {0} is already logged in Zone {1}", "The server is full", "Zone {0} is currently inactive", "User name {0} contains bad words; filtered: {1}", "Guest users not allowed in Zone {0}", "IP address {0} is banned", "A Room with the same name already exists: {0}", "Requested Group is not available - Room: {0}; Group: {1}", "Bad Room name length -  Min: {0}; max: {1}; passed name length: {2}", "Room name contains bad words: {0}", "Zone is full; can\'t add Rooms anymore", "You have exceeded the number of Rooms that you can create per session: {0}", "Room creation failed, wrong parameter: {0}", "User {0} already joined in Room", "Room {0} is full", "Wrong password for Room {0}", "Requested Room does not exist", "Room {0} is locked", "Group {0} is already subscribed", "Group {0} does not exist", "Group {0} is not subscribed", "Group {0} does not exist", "{0}", "Room permission error; Room {0} cannot be renamed", "Room permission error; Room {0} cannot change password state", "Room permission error; Room {0} cannot change capacity", "Switch user error; no player slots available in Room {0}", "Switch user error; no spectator slots available in Room {0}", "Switch user error; Room {0} is not a Game Room", "Switch user error; you are not joined in Room {0}", "Buddy Manager initialization error, could not load buddy list: {0}", "Buddy Manager error, your buddy list is full; size is {0}", "Buddy Manager error, was not able to block buddy {0} because offline", "Buddy Manager error, you are attempting to set too many Buddy Variables; limit is {0}", "Game {0} access denied, user does not match access criteria", "QuickJoinGame action failed: no matching Rooms were found", "Your previous invitation reply was invalid or arrived too late"];

        public function SFSErrorCodes()
        {
            throw new Error("This class cannot be instantiated. Please check the documentation for more details on its usage");
        }// end function

        public static function setErrorMessage(param1:int, param2:String) : void
        {
            errorsByCode[param1] = param2;
            return;
        }// end function

        public static function getErrorMessage(param1:int, param2:Array = null) : String
        {
            return stringFormat(errorsByCode[param1], param2);
        }// end function

        private static function stringFormat(param1:String, param2:Array) : String
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            if (param1 == null)
            {
                return "";
            }
            if (param2 != null)
            {
                _loc_3 = 0;
                while (_loc_3 < param2.length)
                {
                    
                    _loc_4 = "{" + _loc_3 + "}";
                    param1 = param1.replace(_loc_4, param2[_loc_3]);
                    _loc_3++;
                }
            }
            return param1;
        }// end function

    }
}
