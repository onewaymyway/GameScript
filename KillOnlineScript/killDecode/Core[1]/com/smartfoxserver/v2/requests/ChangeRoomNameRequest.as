package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class ChangeRoomNameRequest extends BaseRequest
    {
        private var _room:Room;
        private var _newName:String;
        public static const KEY_ROOM:String = "r";
        public static const KEY_NAME:String = "n";

        public function ChangeRoomNameRequest(param1:Room, param2:String)
        {
            super(BaseRequest.ChangeRoomName);
            this._room = param1;
            this._newName = param2;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._room == null)
            {
                _loc_2.push("Provided room is null");
            }
            if (this._newName == null || this._newName.length == 0)
            {
                _loc_2.push("Invalid new room name. It must be a non-null and non-empty string.");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("ChangeRoomName request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putInt(KEY_ROOM, this._room.id);
            _sfso.putUtfString(KEY_NAME, this._newName);
            return;
        }// end function

    }
}
