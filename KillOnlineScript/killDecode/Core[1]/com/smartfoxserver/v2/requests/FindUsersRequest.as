package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.match.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;

    public class FindUsersRequest extends BaseRequest
    {
        private var _matchExpr:MatchExpression;
        private var _target:Object;
        private var _limit:int;
        public static const KEY_EXPRESSION:String = "e";
        public static const KEY_GROUP:String = "g";
        public static const KEY_ROOM:String = "r";
        public static const KEY_LIMIT:String = "l";
        public static const KEY_FILTERED_USERS:String = "fu";

        public function FindUsersRequest(param1:MatchExpression, param2 = null, param3:int = 0)
        {
            super(BaseRequest.FindUsers);
            this._matchExpr = param1;
            this._target = param2;
            this._limit = param3;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._matchExpr == null)
            {
                _loc_2.push("Missing Match Expression");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("FindUsers request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putSFSArray(KEY_EXPRESSION, this._matchExpr.toSFSArray());
            if (this._target != null)
            {
                if (this._target is Room)
                {
                    _sfso.putInt(KEY_ROOM, (this._target as Room).id);
                }
                else if (this._target is String)
                {
                    _sfso.putUtfString(KEY_GROUP, this._target);
                }
                else
                {
                    Logger.getInstance().warn("Unsupport target type for FindUsersRequest: " + this._target);
                }
            }
            if (this._limit > 0)
            {
                _sfso.putShort(KEY_LIMIT, this._limit);
            }
            return;
        }// end function

    }
}
