package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class CreateRoomRequest extends BaseRequest
    {
        private var _settings:RoomSettings;
        private var _autoJoin:Boolean;
        private var _roomToLeave:Room;
        public static const KEY_ROOM:String = "r";
        public static const KEY_NAME:String = "n";
        public static const KEY_PASSWORD:String = "p";
        public static const KEY_GROUP_ID:String = "g";
        public static const KEY_ISGAME:String = "ig";
        public static const KEY_MAXUSERS:String = "mu";
        public static const KEY_MAXSPECTATORS:String = "ms";
        public static const KEY_MAXVARS:String = "mv";
        public static const KEY_ROOMVARS:String = "rv";
        public static const KEY_PERMISSIONS:String = "pm";
        public static const KEY_EVENTS:String = "ev";
        public static const KEY_EXTID:String = "xn";
        public static const KEY_EXTCLASS:String = "xc";
        public static const KEY_EXTPROP:String = "xp";
        public static const KEY_AUTOJOIN:String = "aj";
        public static const KEY_ROOM_TO_LEAVE:String = "rl";

        public function CreateRoomRequest(param1:RoomSettings, param2:Boolean = false, param3:Room = null)
        {
            super(BaseRequest.CreateRoom);
            this._settings = param1;
            this._autoJoin = param2;
            this._roomToLeave = param3;
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            var _loc_2:ISFSArray = null;
            var _loc_3:* = undefined;
            var _loc_4:RoomVariable = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            _sfso.putUtfString(KEY_NAME, this._settings.name);
            _sfso.putUtfString(KEY_GROUP_ID, this._settings.groupId);
            _sfso.putUtfString(KEY_PASSWORD, this._settings.password);
            _sfso.putBool(KEY_ISGAME, this._settings.isGame);
            _sfso.putShort(KEY_MAXUSERS, this._settings.maxUsers);
            _sfso.putShort(KEY_MAXSPECTATORS, this._settings.maxSpectators);
            _sfso.putShort(KEY_MAXVARS, this._settings.maxVariables);
            if (this._settings.variables != null && this._settings.variables.length > 0)
            {
                _loc_2 = SFSArray.newInstance();
                for each (_loc_3 in this._settings.variables)
                {
                    
                    if (_loc_3 is RoomVariable)
                    {
                        _loc_4 = _loc_3 as RoomVariable;
                        _loc_2.addSFSArray(_loc_4.toSFSArray());
                    }
                }
                _sfso.putSFSArray(KEY_ROOMVARS, _loc_2);
            }
            if (this._settings.permissions != null)
            {
                _loc_5 = [];
                _loc_5.push(this._settings.permissions.allowNameChange);
                _loc_5.push(this._settings.permissions.allowPasswordStateChange);
                _loc_5.push(this._settings.permissions.allowPublicMessages);
                _loc_5.push(this._settings.permissions.allowResizing);
                _sfso.putBoolArray(KEY_PERMISSIONS, _loc_5);
            }
            if (this._settings.events != null)
            {
                _loc_6 = [];
                _loc_6.push(this._settings.events.allowUserEnter);
                _loc_6.push(this._settings.events.allowUserExit);
                _loc_6.push(this._settings.events.allowUserCountChange);
                _loc_6.push(this._settings.events.allowUserVariablesUpdate);
                _sfso.putBoolArray(KEY_EVENTS, _loc_6);
            }
            if (this._settings.extension != null)
            {
                _sfso.putUtfString(KEY_EXTID, this._settings.extension.id);
                _sfso.putUtfString(KEY_EXTCLASS, this._settings.extension.className);
                if (this._settings.extension.propertiesFile != null && this._settings.extension.propertiesFile.length > 0)
                {
                    _sfso.putUtfString(KEY_EXTPROP, this._settings.extension.propertiesFile);
                }
            }
            _sfso.putBool(KEY_AUTOJOIN, this._autoJoin);
            if (this._roomToLeave != null)
            {
                _sfso.putInt(KEY_ROOM_TO_LEAVE, this._roomToLeave.id);
            }
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._settings.name == null || this._settings.name.length == 0)
            {
                _loc_2.push("Missing room name");
            }
            if (this._settings.maxUsers <= 0)
            {
                _loc_2.push("maxUsers must be > 0");
            }
            if (this._settings.extension != null)
            {
                if (this._settings.extension.className == null || this._settings.extension.className.length == 0)
                {
                    _loc_2.push("Missing Extension class name");
                }
                if (this._settings.extension.id == null || this._settings.extension.id.length == 0)
                {
                    _loc_2.push("Missing Extension id");
                }
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("CreateRoom request error", _loc_2);
            }
            return;
        }// end function

    }
}
