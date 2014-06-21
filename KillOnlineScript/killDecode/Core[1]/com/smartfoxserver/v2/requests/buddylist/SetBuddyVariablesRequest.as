package com.smartfoxserver.v2.requests.buddylist
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.entities.variables.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.requests.*;

    public class SetBuddyVariablesRequest extends BaseRequest
    {
        private var _buddyVariables:Array;
        public static const KEY_BUDDY_NAME:String = "bn";
        public static const KEY_BUDDY_VARS:String = "bv";

        public function SetBuddyVariablesRequest(param1:Array)
        {
            super(BaseRequest.SetBuddyVariables);
            this._buddyVariables = param1;
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            var _loc_2:Array = [];
            if (!param1.buddyManager.isInited)
            {
                _loc_2.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
            }
            if (param1.buddyManager.myOnlineState == false)
            {
                _loc_2.push("Can\'t set buddy variables while off-line");
            }
            if (this._buddyVariables == null || this._buddyVariables.length == 0)
            {
                _loc_2.push("No variables were specified");
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("SetBuddyVariables request error", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            var _loc_3:BuddyVariable = null;
            var _loc_2:* = new SFSArray();
            for each (_loc_3 in this._buddyVariables)
            {
                
                _loc_2.addSFSArray(_loc_3.toSFSArray());
            }
            _sfso.putSFSArray(KEY_BUDDY_VARS, _loc_2);
            return;
        }// end function

    }
}
