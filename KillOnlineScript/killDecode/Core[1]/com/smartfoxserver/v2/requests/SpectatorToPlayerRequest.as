package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SpectatorToPlayerRequest extends BaseRequest
    {
        private var _room:Room;
        public static const KEY_ROOM_ID:String = "r";
        public static const KEY_USER_ID:String = "u";
        public static const KEY_PLAYER_ID:String = "p";

        public function SpectatorToPlayerRequest(param1:Room = null)
        {
            super(BaseRequest.SpectatorToPlayer);
            this._room = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (param1.joinedRooms.length < 1)
            {
                _loc_2.push("You are not joined in any rooms");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("LeaveRoom request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            if (this._room == null)
            {
                this._room = param1.lastJoinedRoom;
            }
            _sfso.putInt(KEY_ROOM_ID, this._room.id);
            return;
        }// end function

    }
}
