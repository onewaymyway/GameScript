package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.entities.data.*;

    public class Message extends Object implements IMessage
    {
        private var _id:int;
        private var _content:ISFSObject;
        private var _targetController:int;
        private var _isEncrypted:Boolean;
        private var _isUDP:Boolean;
        private var _packetId:Number = NaN;

        public function Message()
        {
            this._isEncrypted = false;
            this._isUDP = false;
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

        public function get content() : ISFSObject
        {
            return this._content;
        }// end function

        public function set content(param1:ISFSObject) : void
        {
            this._content = param1;
            return;
        }// end function

        public function get targetController() : int
        {
            return this._targetController;
        }// end function

        public function set targetController(param1:int) : void
        {
            this._targetController = param1;
            return;
        }// end function

        public function get isEncrypted() : Boolean
        {
            return this._isEncrypted;
        }// end function

        public function set isEncrypted(param1:Boolean) : void
        {
            this._isEncrypted = param1;
            return;
        }// end function

        public function get isUDP() : Boolean
        {
            return this._isUDP;
        }// end function

        public function set isUDP(param1:Boolean) : void
        {
            this._isUDP = param1;
            return;
        }// end function

        public function get packetId() : Number
        {
            return this._packetId;
        }// end function

        public function set packetId(param1:Number) : void
        {
            this._packetId = param1;
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = "{ Message id: " + this._id + " }\n";
            _loc_1 = _loc_1 + "{ Dump: }\n";
            _loc_1 = _loc_1 + this._content.getDump();
            return _loc_1;
        }// end function

    }
}
