package com.smartfoxserver.v2.requests
{

    public class RoomEvents extends Object
    {
        private var _allowUserEnter:Boolean;
        private var _allowUserExit:Boolean;
        private var _allowUserCountChange:Boolean;
        private var _allowUserVariablesUpdate:Boolean;

        public function RoomEvents()
        {
            this._allowUserCountChange = false;
            this._allowUserEnter = false;
            this._allowUserExit = false;
            this._allowUserVariablesUpdate = false;
            return;
        }// end function

        public function get allowUserEnter() : Boolean
        {
            return this._allowUserEnter;
        }// end function

        public function set allowUserEnter(param1:Boolean) : void
        {
            this._allowUserEnter = param1;
            return;
        }// end function

        public function get allowUserExit() : Boolean
        {
            return this._allowUserExit;
        }// end function

        public function set allowUserExit(param1:Boolean) : void
        {
            this._allowUserExit = param1;
            return;
        }// end function

        public function get allowUserCountChange() : Boolean
        {
            return this._allowUserCountChange;
        }// end function

        public function set allowUserCountChange(param1:Boolean) : void
        {
            this._allowUserCountChange = param1;
            return;
        }// end function

        public function get allowUserVariablesUpdate() : Boolean
        {
            return this._allowUserVariablesUpdate;
        }// end function

        public function set allowUserVariablesUpdate(param1:Boolean) : void
        {
            this._allowUserVariablesUpdate = param1;
            return;
        }// end function

    }
}
