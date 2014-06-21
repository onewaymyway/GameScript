package com.smartfoxserver.v2.entities.invitation
{
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;

    public class SFSInvitation extends Object implements Invitation
    {
        protected var _id:int;
        protected var _inviter:User;
        protected var _invitee:User;
        protected var _secondsForAnswer:int;
        protected var _params:ISFSObject;

        public function SFSInvitation(param1:User, param2:User, param3:int = 15, param4:ISFSObject = null)
        {
            this._inviter = param1;
            this._invitee = param2;
            this._secondsForAnswer = param3;
            this._params = param4;
            return;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        public function set id(param1:int) : void
        {
            this._id = param1;
            return;
        }// end function

        public function get inviter() : User
        {
            return this._inviter;
        }// end function

        public function get invitee() : User
        {
            return this._invitee;
        }// end function

        public function get secondsForAnswer() : int
        {
            return this._secondsForAnswer;
        }// end function

        public function get params() : ISFSObject
        {
            return this._params;
        }// end function

    }
}
