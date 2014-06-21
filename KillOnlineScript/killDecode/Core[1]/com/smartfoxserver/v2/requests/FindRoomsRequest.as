package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.match.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class FindRoomsRequest extends BaseRequest
    {
        private var _matchExpr:MatchExpression;
        private var _groupId:String;
        private var _limit:int;
        public static const KEY_EXPRESSION:String = "e";
        public static const KEY_GROUP:String = "g";
        public static const KEY_LIMIT:String = "l";
        public static const KEY_FILTERED_ROOMS:String = "fr";

        public function FindRoomsRequest(param1:MatchExpression, param2:String = null, param3:int = 0) : void
        {
            super(BaseRequest.FindRooms);
            this._matchExpr = param1;
            this._groupId = param2;
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
                throw new SFSValidationError("FindRooms request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putSFSArray(KEY_EXPRESSION, this._matchExpr.toSFSArray());
            if (this._groupId != null)
            {
                _sfso.putUtfString(KEY_GROUP, this._groupId);
            }
            if (this._limit > 0)
            {
                _sfso.putShort(KEY_LIMIT, this._limit);
            }
            return;
        }// end function

    }
}
