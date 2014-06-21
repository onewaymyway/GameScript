package com.smartfoxserver.v2.requests.buddylist
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.requests.*;

    public class AddBuddyRequest extends BaseRequest
    {
        private var _name:String;
        public static const KEY_BUDDY_NAME:String = "bn";

        public function AddBuddyRequest(param1:String)
        {
            super(BaseRequest.AddBuddy);
            this._name = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (!param1.buddyManager.isInited)
            {
                _loc_2.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
            }
            if (this._name == null || this._name.length < 1)
            {
                _loc_2.push("Invalid buddy name: " + this._name);
            }
            if (param1.buddyManager.myOnlineState == false)
            {
                _loc_2.push("Can\'t add buddy while off-line");
            }
            var _loc_3:* = param1.buddyManager.getBuddyByName(this._name);
            if (_loc_3 != null && !_loc_3.isTemp)
            {
                _loc_2.push("Can\'t add buddy, it is already in your list: " + this._name);
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("BuddyList request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putUtfString(KEY_BUDDY_NAME, this._name);
            return;
        }// end function

    }
}
