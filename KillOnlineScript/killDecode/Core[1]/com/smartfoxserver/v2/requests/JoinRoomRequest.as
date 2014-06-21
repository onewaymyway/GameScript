package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class JoinRoomRequest extends BaseRequest
    {
        private var _id:int = -1;
        private var _name:String;
        private var _pass:String;
        private var _roomIdToLeave:Number;
        private var _asSpectator:Boolean;
        public static const KEY_ROOM:String = "r";
        public static const KEY_USER_LIST:String = "ul";
        public static const KEY_ROOM_NAME:String = "n";
        public static const KEY_ROOM_ID:String = "i";
        public static const KEY_PASS:String = "p";
        public static const KEY_ROOM_TO_LEAVE:String = "rl";
        public static const KEY_AS_SPECTATOR:String = "sp";

        public function JoinRoomRequest(param1, param2:String = null, param3:Number = NaN, param4:Boolean = false)
        {
            super(BaseRequest.JoinRoom);
            if (param1 is String)
            {
                this._name = param1;
            }
            else if (param1 is Number)
            {
                this._id = param1;
            }
            else if (param1 is Room)
            {
                this._id = (param1 as Room).id;
            }
            this._pass = param2;
            this._roomIdToLeave = param3;
            this._asSpectator = param4;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._id < 0 && this._name == null)
            {
                _loc_2.push("Missing Room id or name, you should provide at least one");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("JoinRoom request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            if (this._id > -1)
            {
                _sfso.putInt(KEY_ROOM_ID, this._id);
            }
            else if (this._name != null)
            {
                _sfso.putUtfString(KEY_ROOM_NAME, this._name);
            }
            if (this._pass != null)
            {
                _sfso.putUtfString(KEY_PASS, this._pass);
            }
            if (!isNaN(this._roomIdToLeave))
            {
                _sfso.putInt(KEY_ROOM_TO_LEAVE, this._roomIdToLeave);
            }
            if (this._asSpectator)
            {
                _sfso.putBool(KEY_AS_SPECTATOR, this._asSpectator);
            }
            return;
        }// end function

    }
}
