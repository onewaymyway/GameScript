package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SubscribeRoomGroupRequest extends BaseRequest
    {
        private var _groupId:String;
        public static const KEY_GROUP_ID:String = "g";
        public static const KEY_ROOM_LIST:String = "rl";

        public function SubscribeRoomGroupRequest(param1:String)
        {
            super(BaseRequest.SubscribeRoomGroup);
            this._groupId = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._groupId == null || this._groupId.length == 0)
            {
                _loc_2.push("Invalid groupId. Must be a string with at least 1 character.");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("SubscribeGroup request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putUtfString(KEY_GROUP_ID, this._groupId);
            return;
        }// end function

    }
}
