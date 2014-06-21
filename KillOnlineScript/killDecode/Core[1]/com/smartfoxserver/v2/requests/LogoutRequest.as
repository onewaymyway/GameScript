package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class LogoutRequest extends BaseRequest
    {
        public static const KEY_ZONE_NAME:String = "zn";

        public function LogoutRequest()
        {
            super(BaseRequest.Logout);
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            if (param1.mySelf == null)
            {
                throw new SFSValidationError("LogoutRequest Error", ["You are not logged in a the moment!"]);
            }
            return;
        }// end function

    }
}
