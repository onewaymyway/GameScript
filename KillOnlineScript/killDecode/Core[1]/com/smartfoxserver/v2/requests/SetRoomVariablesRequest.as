package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SetRoomVariablesRequest extends BaseRequest
    {
        private var _roomVariables:Array;
        private var _room:Room;
        public static const KEY_VAR_ROOM:String = "r";
        public static const KEY_VAR_LIST:String = "vl";

        public function SetRoomVariablesRequest(param1:Array, param2:Room = null)
        {
            super(BaseRequest.SetRoomVariables);
            this._roomVariables = param1;
            this._room = param2;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._room != null)
            {
                if (!this._room.containsUser(param1.mySelf))
                {
                    _loc_2.push("You are not joined in the target room");
                }
            }
            else if (param1.lastJoinedRoom == null)
            {
                _loc_2.push("You are not joined in any rooms");
            }
            if (this._roomVariables == null || this._roomVariables.length == 0)
            {
                _loc_2.push("No variables were specified");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("SetRoomVariables request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            var _loc_3:RoomVariable = null;
            var _loc_2:* = SFSArray.newInstance();
            for each (_loc_3 in this._roomVariables)
            {
                
                _loc_2.addSFSArray(_loc_3.toSFSArray());
            }
            if (this._room == null)
            {
                this._room = param1.lastJoinedRoom;
            }
            _sfso.putSFSArray(KEY_VAR_LIST, _loc_2);
            _sfso.putInt(KEY_VAR_ROOM, this._room.id);
            return;
        }// end function

    }
}
