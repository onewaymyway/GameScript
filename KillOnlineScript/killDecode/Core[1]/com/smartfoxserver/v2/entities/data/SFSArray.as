package com.smartfoxserver.v2.entities.data
{
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.protocol.serialization.*;
    import flash.utils.*;

    public class SFSArray extends Object implements ISFSArray
    {
        private var serializer:ISFSDataSerializer;
        private var dataHolder:Array;

        public function SFSArray()
        {
            this.dataHolder = [];
            this.serializer = DefaultSFSDataSerializer.getInstance();
            return;
        }// end function

        public function contains(param1) : Boolean
        {
            var _loc_4:* = undefined;
            if (param1 is ISFSArray || param1 is ISFSObject)
            {
                throw new SFSError("ISFSArray and ISFSObject are not supported by this method.");
            }
            var _loc_2:Boolean = false;
            var _loc_3:int = 0;
            while (_loc_3 < this.size())
            {
                
                _loc_4 = this.getElementAt(_loc_3);
                if (_loc_4 != null && _loc_4 == param1)
                {
                    _loc_2 = true;
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function getWrappedElementAt(param1:int) : SFSDataWrapper
        {
            return this.dataHolder[param1];
        }// end function

        public function getElementAt(param1:int)
        {
            var _loc_2:* = null;
            if (this.dataHolder[param1] != null)
            {
                _loc_2 = this.dataHolder[param1].data;
            }
            return _loc_2;
        }// end function

        public function removeElementAt(param1:int)
        {
            this.dataHolder.splice(param1, 1);
            return;
        }// end function

        public function size() : int
        {
            var _loc_2:String = null;
            var _loc_1:int = 0;
            for (_loc_2 in this.dataHolder)
            {
                
                _loc_1++;
            }
            return _loc_1;
        }// end function

        public function toBinary() : ByteArray
        {
            return this.serializer.array2binary(this);
        }// end function

        public function toArray() : Array
        {
            return DefaultSFSDataSerializer.getInstance().sfsArrayToGenericArray(this);
        }// end function

        public function getDump(param1:Boolean = true) : String
        {
            var prettyDump:String;
            var format:* = param1;
            if (!format)
            {
                return this.dump();
            }
            try
            {
                prettyDump = DefaultObjectDumpFormatter.prettyPrintDump(this.dump());
            }
            catch (err:Error)
            {
                prettyDump;
            }
            return prettyDump;
        }// end function

        private function dump() : String
        {
            var _loc_2:SFSDataWrapper = null;
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_1:* = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
            for (_loc_5 in this.dataHolder)
            {
                
                _loc_2 = this.dataHolder[_loc_5];
                _loc_4 = _loc_2.type;
                if (_loc_4 == SFSDataType.SFS_OBJECT)
                {
                    _loc_3 = (_loc_2.data as SFSObject).getDump(false);
                }
                else if (_loc_4 == SFSDataType.SFS_ARRAY)
                {
                    _loc_3 = (_loc_2.data as SFSArray).getDump(false);
                }
                else if (_loc_4 > SFSDataType.UTF_STRING && _loc_4 < SFSDataType.CLASS)
                {
                    _loc_3 = "[" + _loc_2.data + "]";
                }
                else if (_loc_4 == SFSDataType.BYTE_ARRAY)
                {
                    _loc_3 = DefaultObjectDumpFormatter.prettyPrintByteArray(_loc_2.data as ByteArray);
                }
                else
                {
                    _loc_3 = _loc_2.data;
                }
                _loc_1 = _loc_1 + ("(" + SFSDataType.fromId(_loc_2.type).toLowerCase() + ") ");
                _loc_1 = _loc_1 + _loc_3;
                _loc_1 = _loc_1 + DefaultObjectDumpFormatter.TOKEN_DIVIDER;
            }
            if (this.size() > 0)
            {
                _loc_1 = _loc_1.slice(0, (_loc_1.length - 1));
            }
            _loc_1 = _loc_1 + DefaultObjectDumpFormatter.TOKEN_INDENT_CLOSE;
            return _loc_1;
        }// end function

        public function getHexDump() : String
        {
            return DefaultObjectDumpFormatter.hexDump(this.toBinary());
        }// end function

        public function addNull() : void
        {
            this.addObject(null, SFSDataType.NULL);
            return;
        }// end function

        public function addBool(param1:Boolean) : void
        {
            this.addObject(param1, SFSDataType.BOOL);
            return;
        }// end function

        public function addByte(param1:int) : void
        {
            this.addObject(param1, SFSDataType.BYTE);
            return;
        }// end function

        public function addShort(param1:int) : void
        {
            this.addObject(param1, SFSDataType.SHORT);
            return;
        }// end function

        public function addInt(param1:int) : void
        {
            this.addObject(param1, SFSDataType.INT);
            return;
        }// end function

        public function addLong(param1:Number) : void
        {
            this.addObject(param1, SFSDataType.LONG);
            return;
        }// end function

        public function addFloat(param1:Number) : void
        {
            this.addObject(param1, SFSDataType.FLOAT);
            return;
        }// end function

        public function addDouble(param1:Number) : void
        {
            this.addObject(param1, SFSDataType.DOUBLE);
            return;
        }// end function

        public function addUtfString(param1:String) : void
        {
            this.addObject(param1, SFSDataType.UTF_STRING);
            return;
        }// end function

        public function addBoolArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.BOOL_ARRAY);
            return;
        }// end function

        public function addByteArray(param1:ByteArray) : void
        {
            this.addObject(param1, SFSDataType.BYTE_ARRAY);
            return;
        }// end function

        public function addShortArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.SHORT_ARRAY);
            return;
        }// end function

        public function addIntArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.INT_ARRAY);
            return;
        }// end function

        public function addLongArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.LONG_ARRAY);
            return;
        }// end function

        public function addFloatArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.FLOAT_ARRAY);
            return;
        }// end function

        public function addDoubleArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.DOUBLE_ARRAY);
            return;
        }// end function

        public function addUtfStringArray(param1:Array) : void
        {
            this.addObject(param1, SFSDataType.UTF_STRING_ARRAY);
            return;
        }// end function

        public function addSFSArray(param1:ISFSArray) : void
        {
            this.addObject(param1, SFSDataType.SFS_ARRAY);
            return;
        }// end function

        public function addSFSObject(param1:ISFSObject) : void
        {
            this.addObject(param1, SFSDataType.SFS_OBJECT);
            return;
        }// end function

        public function addClass(param1) : void
        {
            this.addObject(param1, SFSDataType.CLASS);
            return;
        }// end function

        public function add(param1:SFSDataWrapper) : void
        {
            this.dataHolder.push(param1);
            return;
        }// end function

        private function addObject(param1, param2:int) : void
        {
            this.add(new SFSDataWrapper(param2, param1));
            return;
        }// end function

        public function isNull(param1:int) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:* = this.dataHolder[param1];
            if (_loc_3 == null || _loc_3.type == SFSDataType.NULL)
            {
                _loc_2 = true;
            }
            return _loc_2;
        }// end function

        public function getBool(param1:int) : Boolean
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as Boolean) : (undefined);
        }// end function

        public function getByte(param1:int) : int
        {
            return this.getInt(param1);
        }// end function

        public function getUnsignedByte(param1:int) : int
        {
            return this.getInt(param1) & 255;
        }// end function

        public function getShort(param1:int) : int
        {
            return this.getInt(param1);
        }// end function

        public function getInt(param1:int) : int
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as int) : (undefined);
        }// end function

        public function getLong(param1:int) : Number
        {
            return this.getDouble(param1);
        }// end function

        public function getFloat(param1:int) : Number
        {
            return this.getDouble(param1);
        }// end function

        public function getDouble(param1:int) : Number
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as Number) : (undefined);
        }// end function

        public function getUtfString(param1:int) : String
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as String) : (null);
        }// end function

        private function getArray(param1:int) : Array
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as Array) : (null);
        }// end function

        public function getBoolArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getByteArray(param1:int) : ByteArray
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as ByteArray) : (null);
        }// end function

        public function getUnsignedByteArray(param1:int) : Array
        {
            var _loc_2:* = this.getByteArray(param1);
            if (_loc_2 == null)
            {
                return null;
            }
            var _loc_3:Array = [];
            _loc_2.position = 0;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3.push(_loc_2.readByte() & 255);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function getShortArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getIntArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getLongArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getFloatArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getDoubleArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getUtfStringArray(param1:int) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getSFSArray(param1:int) : ISFSArray
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as ISFSArray) : (null);
        }// end function

        public function getClass(param1:int)
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data) : (null);
        }// end function

        public function getSFSObject(param1:int) : ISFSObject
        {
            var _loc_2:* = this.dataHolder[param1];
            return _loc_2 != null ? (_loc_2.data as ISFSObject) : (null);
        }// end function

        public static function newFromArray(param1:Array, param2:Boolean = false) : SFSArray
        {
            return DefaultSFSDataSerializer.getInstance().genericArrayToSFSArray(param1, param2);
        }// end function

        public static function newFromBinaryData(param1:ByteArray) : SFSArray
        {
            return DefaultSFSDataSerializer.getInstance().binary2array(param1) as SFSArray;
        }// end function

        public static function newInstance() : SFSArray
        {
            return new SFSArray;
        }// end function

    }
}
