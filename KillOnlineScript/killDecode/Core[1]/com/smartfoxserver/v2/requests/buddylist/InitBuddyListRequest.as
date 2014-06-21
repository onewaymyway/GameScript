package com.smartfoxserver.v2.requests.buddylist
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.requests.*;

    public class InitBuddyListRequest extends BaseRequest
    {
        public static const KEY_BLIST:String = "bl";
        public static const KEY_BUDDY_STATES:String = "bs";
        public static const KEY_MY_VARS:String = "mv";

        public function InitBuddyListRequest()
        {
            super(BaseRequest.InitBuddyList);
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (param1.buddyManager.isInited)
            {
                _loc_2.push("Buddy List is already initialized.");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("InitBuddyRequest error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            return;
        }// end function

    }
}
