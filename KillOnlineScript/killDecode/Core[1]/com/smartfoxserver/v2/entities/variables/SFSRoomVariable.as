package com.smartfoxserver.v2.entities.variables
{
    import com.smartfoxserver.v2.entities.data.*;

    public class SFSRoomVariable extends SFSUserVariable implements RoomVariable
    {
        private var _isPersistent:Boolean;
        private var _isPrivate:Boolean;

        public function SFSRoomVariable(param1:String, param2, param3:int = -1)
        {
            super(param1, param2, param3);
            return;
        }// end function

        public function get isPrivate() : Boolean
        {
            return this._isPrivate;
        }// end function

        public function get isPersistent() : Boolean
        {
            return this._isPersistent;
        }// end function

        public function set isPrivate(param1:Boolean) : void
        {
            this._isPrivate = param1;
            return;
        }// end function

        public function set isPersistent(param1:Boolean) : void
        {
            this._isPersistent = param1;
            return;
        }// end function

        override public function toString() : String
        {
            return "[RVar: " + _name + ", type: " + _type + ", value: " + _value + ", isPriv: " + this.isPrivate + "]";
        }// end function

        override public function toSFSArray() : ISFSArray
        {
            var _loc_1:* = super.toSFSArray();
            _loc_1.addBool(this._isPrivate);
            _loc_1.addBool(this._isPersistent);
            return _loc_1;
        }// end function

        public static function fromSFSArray(param1:ISFSArray) : RoomVariable
        {
            var _loc_2:* = new SFSRoomVariable(param1.getUtfString(0), param1.getElementAt(2), param1.getByte(1));
            _loc_2.isPrivate = param1.getBool(3);
            return _loc_2;
        }// end function

    }
}
