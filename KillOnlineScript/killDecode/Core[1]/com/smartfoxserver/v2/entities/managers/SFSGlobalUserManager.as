package com.smartfoxserver.v2.entities.managers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;

    public class SFSGlobalUserManager extends SFSUserManager
    {
        private var _roomRefCount:Array;

        public function SFSGlobalUserManager(param1:SmartFox)
        {
            super(param1);
            this._roomRefCount = [];
            return;
        }// end function

        override public function addUser(param1:User) : void
        {
            if (this._roomRefCount[param1] == null)
            {
                super._addUser(param1);
                this._roomRefCount[param1] = 1;
            }
            else
            {
                super._addUser(param1);
                var _loc_2:* = this._roomRefCount;
                var _loc_3:* = param1;
                var _loc_4:* = this._roomRefCount[param1] + 1;
                _loc_2[_loc_3] = _loc_4;
            }
            return;
        }// end function

        override public function removeUser(param1:User) : void
        {
            if (this._roomRefCount != null)
            {
                if (this._roomRefCount[param1] < 1)
                {
                    _log.warn("GlobalUserManager RefCount is already at zero. User: " + param1);
                    return;
                }
                var _loc_2:* = this._roomRefCount;
                var _loc_3:* = param1;
                var _loc_4:* = this._roomRefCount[param1] - 1;
                _loc_2[_loc_3] = _loc_4;
                if (this._roomRefCount[param1] == 0)
                {
                    super.removeUser(param1);
                    delete this._roomRefCount[param1];
                }
            }
            else
            {
                _log.warn("Can\'t remove User from GlobalUserManager. RefCount missing. User: " + param1);
            }
            return;
        }// end function

        private function dumpRefCount() : void
        {
            return;
        }// end function

    }
}
