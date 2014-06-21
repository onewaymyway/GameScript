package com.smartfoxserver.v2.requests
{

    public class RoomPermissions extends Object
    {
        private var _allowNameChange:Boolean;
        private var _allowPasswordStateChange:Boolean;
        private var _allowPublicMessages:Boolean;
        private var _allowResizing:Boolean;

        public function RoomPermissions()
        {
            return;
        }// end function

        public function get allowNameChange() : Boolean
        {
            return this._allowNameChange;
        }// end function

        public function set allowNameChange(param1:Boolean) : void
        {
            this._allowNameChange = param1;
            return;
        }// end function

        public function get allowPasswordStateChange() : Boolean
        {
            return this._allowPasswordStateChange;
        }// end function

        public function set allowPasswordStateChange(param1:Boolean) : void
        {
            this._allowPasswordStateChange = param1;
            return;
        }// end function

        public function get allowPublicMessages() : Boolean
        {
            return this._allowPublicMessages;
        }// end function

        public function set allowPublicMessages(param1:Boolean) : void
        {
            this._allowPublicMessages = param1;
            return;
        }// end function

        public function get allowResizing() : Boolean
        {
            return this._allowResizing;
        }// end function

        public function set allowResizing(param1:Boolean) : void
        {
            this._allowResizing = param1;
            return;
        }// end function

    }
}
