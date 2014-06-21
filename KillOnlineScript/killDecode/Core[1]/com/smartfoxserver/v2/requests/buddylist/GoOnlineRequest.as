package com.smartfoxserver.v2.requests.buddylist
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.requests.*;

    public class GoOnlineRequest extends BaseRequest
    {
        private var _online:Boolean;
        public static const KEY_ONLINE:String = "o";
        public static const KEY_BUDDY_NAME:String = "bn";
        public static const KEY_BUDDY_ID:String = "bi";

        public function GoOnlineRequest(param1:Boolean)
        {
            super(BaseRequest.GoOnline);
            this._online = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (!param1.buddyManager.isInited)
            {
                _loc_2.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("GoOnline request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            param1.buddyManager.setMyOnlineState(this._online);
            _sfso.putBool(KEY_ONLINE, this._online);
            return;
        }// end function

    }
}
