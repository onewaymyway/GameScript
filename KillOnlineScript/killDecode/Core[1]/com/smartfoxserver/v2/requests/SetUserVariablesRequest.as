package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SetUserVariablesRequest extends BaseRequest
    {
        private var _userVariables:Array;
        public static const KEY_USER:String = "u";
        public static const KEY_VAR_LIST:String = "vl";

        public function SetUserVariablesRequest(param1:Array)
        {
            super(BaseRequest.SetUserVariables);
            this._userVariables = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (this._userVariables == null || this._userVariables.length == 0)
            {
                _loc_2.push("No variables were specified");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("SetUserVariables request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            var _loc_3:UserVariable = null;
            var _loc_2:* = SFSArray.newInstance();
            for each (_loc_3 in this._userVariables)
            {
                
                _loc_2.addSFSArray(_loc_3.toSFSArray());
            }
            _sfso.putSFSArray(KEY_VAR_LIST, _loc_2);
            return;
        }// end function

    }
}
