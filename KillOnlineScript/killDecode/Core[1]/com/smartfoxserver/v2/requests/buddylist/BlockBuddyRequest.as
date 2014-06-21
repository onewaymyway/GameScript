package com.smartfoxserver.v2.requests.buddylist
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.requests.*;

    public class BlockBuddyRequest extends BaseRequest
    {
        private var _buddyName:String;
        private var _blocked:Boolean;
        public static const KEY_BUDDY_NAME:String = "bn";
        public static const KEY_BUDDY_BLOCK_STATE:String = "bs";

        public function BlockBuddyRequest(param1:String, param2:Boolean)
        {
            super(BaseRequest.BlockBuddy);
            this._buddyName = param1;
            this._blocked = param2;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (!param1.buddyManager.isInited)
            {
                _loc_2.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
            }
            if (this._buddyName == null || this._buddyName.length < 1)
            {
                _loc_2.push("Invalid buddy name: " + this._buddyName);
            }
            if (param1.buddyManager.myOnlineState == false)
            {
                _loc_2.push("Can\'t block buddy while off-line");
            }
            var _loc_3:* = param1.buddyManager.getBuddyByName(this._buddyName);
            if (_loc_3 == null)
            {
                _loc_2.push("Can\'t block buddy, it\'s not in your list: " + this._buddyName);
            }
            else if (_loc_3.isBlocked == this._blocked)
            {
                _loc_2.push("BuddyBlock flag is already in the requested state: " + this._blocked + ", for buddy: " + _loc_3);
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("BuddyList request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putUtfString(BlockBuddyRequest.KEY_BUDDY_NAME, this._buddyName);
            _sfso.putBool(BlockBuddyRequest.KEY_BUDDY_BLOCK_STATE, this._blocked);
            return;
        }// end function

    }
}
