package com.google.analytics.data
{
    import com.google.analytics.core.*;

    public class UTMCookie extends Object implements Cookie
    {
        private var _creation:Date;
        private var _expiration:Date;
        private var _timespan:Number;
        protected var name:String;
        protected var inURL:String;
        protected var fields:Array;
        public var proxy:Buffer;

        public function UTMCookie(name:String, inURL:String, fields:Array, timespan:Number = 0)
        {
            this.name = name;
            this.inURL = inURL;
            this.fields = fields;
            this._timestamp(timespan);
            return;
        }// end function

        private function _timestamp(timespan:Number) : void
        {
            this.creation = new Date();
            this._timespan = timespan;
            if (timespan > 0)
            {
                this.expiration = new Date(this.creation.valueOf() + timespan);
            }
            return;
        }// end function

        protected function update() : void
        {
            this.resetTimestamp();
            if (this.proxy)
            {
                this.proxy.update(this.name, this.toSharedObject());
            }
            return;
        }// end function

        public function get creation() : Date
        {
            return this._creation;
        }// end function

        public function set creation(value:Date) : void
        {
            this._creation = value;
            return;
        }// end function

        public function get expiration() : Date
        {
            if (this._expiration)
            {
                return this._expiration;
            }
            return new Date(new Date().valueOf() + 1000);
        }// end function

        public function set expiration(value:Date) : void
        {
            this._expiration = value;
            return;
        }// end function

        public function fromSharedObject(data:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:* = this.fields.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this.fields[_loc_4];
                if (data[_loc_2])
                {
                    this[_loc_2] = data[_loc_2];
                }
                _loc_4 = _loc_4 + 1;
            }
            if (data.creation)
            {
                this.creation = data.creation;
            }
            if (data.expiration)
            {
                this.expiration = data.expiration;
            }
            return;
        }// end function

        public function isEmpty() : Boolean
        {
            var _loc_2:String = null;
            var _loc_1:int = 0;
            var _loc_3:int = 0;
            while (_loc_3 < this.fields.length)
            {
                
                _loc_2 = this.fields[_loc_3];
                if (this[_loc_2] is Number)
                {
                }
                if (isNaN(this[_loc_2]))
                {
                    _loc_1 = _loc_1 + 1;
                }
                else
                {
                    if (this[_loc_2] is String)
                    {
                    }
                    if (this[_loc_2] == "")
                    {
                        _loc_1 = _loc_1 + 1;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            if (_loc_1 == this.fields.length)
            {
                return true;
            }
            return false;
        }// end function

        public function isExpired() : Boolean
        {
            var _loc_1:* = new Date();
            var _loc_2:* = this.expiration.valueOf() - _loc_1.valueOf();
            if (_loc_2 <= 0)
            {
                return true;
            }
            return false;
        }// end function

        public function reset() : void
        {
            var _loc_1:String = null;
            var _loc_2:int = 0;
            while (_loc_2 < this.fields.length)
            {
                
                _loc_1 = this.fields[_loc_2];
                if (this[_loc_1] is Number)
                {
                    this[_loc_1] = NaN;
                }
                else if (this[_loc_1] is String)
                {
                    this[_loc_1] = "";
                }
                _loc_2 = _loc_2 + 1;
            }
            this.resetTimestamp();
            this.update();
            return;
        }// end function

        public function resetTimestamp(timespan:Number = NaN) : void
        {
            if (!isNaN(timespan))
            {
                this._timespan = timespan;
            }
            this._creation = null;
            this._expiration = null;
            this._timestamp(this._timespan);
            return;
        }// end function

        public function toURLString() : String
        {
            return this.inURL + "=" + this.valueOf();
        }// end function

        public function toSharedObject() : Object
        {
            var _loc_2:String = null;
            var _loc_3:* = undefined;
            var _loc_1:Object = {};
            var _loc_4:int = 0;
            while (_loc_4 < this.fields.length)
            {
                
                _loc_2 = this.fields[_loc_4];
                _loc_3 = this[_loc_2];
                if (_loc_3 is String)
                {
                    _loc_1[_loc_2] = _loc_3;
                }
                else if (_loc_3 == 0)
                {
                    _loc_1[_loc_2] = _loc_3;
                }
                else if (isNaN(_loc_3))
                {
                    ;
                }
                else
                {
                    _loc_1[_loc_2] = _loc_3;
                }
                _loc_4 = _loc_4 + 1;
            }
            _loc_1.creation = this.creation;
            _loc_1.expiration = this.expiration;
            return _loc_1;
        }// end function

        public function toString(showTimestamp:Boolean = false) : String
        {
            var _loc_3:String = null;
            var _loc_4:* = undefined;
            var _loc_2:Array = [];
            var _loc_5:* = this.fields.length;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_3 = this.fields[_loc_6];
                _loc_4 = this[_loc_3];
                if (_loc_4 is String)
                {
                    _loc_2.push(_loc_3 + ": \"" + _loc_4 + "\"");
                }
                else if (_loc_4 == 0)
                {
                    _loc_2.push(_loc_3 + ": " + _loc_4);
                }
                else if (isNaN(_loc_4))
                {
                    ;
                }
                else
                {
                    _loc_2.push(_loc_3 + ": " + _loc_4);
                }
                _loc_6 = _loc_6 + 1;
            }
            var _loc_7:* = this.name.toUpperCase() + " {" + _loc_2.join(", ") + "}";
            if (showTimestamp)
            {
                _loc_7 = _loc_7 + (" creation:" + this.creation + ", expiration:" + this.expiration);
            }
            return _loc_7;
        }// end function

        public function valueOf() : String
        {
            var _loc_2:String = null;
            var _loc_3:* = undefined;
            var _loc_4:Array = null;
            var _loc_1:Array = [];
            var _loc_5:String = "";
            var _loc_6:int = 0;
            while (_loc_6 < this.fields.length)
            {
                
                _loc_2 = this.fields[_loc_6];
                _loc_3 = this[_loc_2];
                if (_loc_3 is String)
                {
                    if (_loc_3 == "")
                    {
                        _loc_3 = "-";
                        _loc_1.push(_loc_3);
                    }
                    else
                    {
                        _loc_1.push(_loc_3);
                    }
                }
                else if (_loc_3 is Number)
                {
                    if (_loc_3 == 0)
                    {
                        _loc_1.push(_loc_3);
                    }
                    else if (isNaN(_loc_3))
                    {
                        _loc_3 = "-";
                        _loc_1.push(_loc_3);
                    }
                    else
                    {
                        _loc_1.push(_loc_3);
                    }
                }
                _loc_6 = _loc_6 + 1;
            }
            if (this.isEmpty())
            {
                return "-";
            }
            return "" + _loc_1.join(".");
        }// end function

    }
}
