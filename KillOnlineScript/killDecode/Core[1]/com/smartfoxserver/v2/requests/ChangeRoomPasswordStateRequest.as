package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class ChangeRoomPasswordStateRequest extends BaseRequest
    {
        private var _room:Room;
        private var _newPass:String;
        public static const KEY_ROOM:String = "r";
        public static const KEY_PASS:String = "p";

        public function ChangeRoomPasswordStateRequest(param1:Room, param2:String)
        {
            super(BaseRequest.ChangeRoomPassword);
            this._room = param1;
            this._newPass = param2;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._room == null)
            {
                _loc_2.push("Provided room is null");
            }
            if (this._newPass == null)
            {
                _loc_2.push("Invalid new room password. It must be a non-null string.");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("ChangePassState request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putInt(KEY_ROOM, this._room.id);
            _sfso.putUtfString(KEY_PASS, this._newPass);
            return;
        }// end function

    }
}
