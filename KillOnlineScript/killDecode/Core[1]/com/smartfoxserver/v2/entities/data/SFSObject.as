package com.smartfoxserver.v2.entities.data
{
    import com.smartfoxserver.v2.protocol.serialization.*;
    import flash.utils.*;

    public class SFSObject extends Object implements ISFSObject
    {
        private var dataHolder:Object;
        private var serializer:ISFSDataSerializer;

        public function SFSObject()
        {
            this.dataHolder = {};
            this.serializer = DefaultSFSDataSerializer.getInstance();
            return;
        }// end function

        public function isNull(param1:String) : Boolean
        {
            var _loc_2:* = this.dataHolder[param1];
            if (_loc_2 == null)
            {
                return true;
            }
            return _loc_2.data == null;
        }// end function

        public function containsKey(param1:String) : Boolean
        {
            var _loc_3:String = null;
            var _loc_2:Boolean = false;
            for (_loc_3 in this.dataHolder)
            {
                
                if (_loc_3 == param1)
                {
                    _loc_2 = true;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function removeElement(param1:String) : void
        {
            delete this.dataHolder[param1];
            return;
        }// end function

        public function getKeys() : Array
        {
            var _loc_2:String = null;
            var _loc_1:Array = [];
            for (_loc_2 in this.dataHolder)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
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
            return this.serializer.object2binary(this);
        }// end function

        public function toObject() : Object
        {
            return DefaultSFSDataSerializer.getInstance().sfsObjectToGenericObject(this);
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
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_1:* = DefaultObjectDumpFormatter.TOKEN_INDENT_OPEN;
            for (_loc_4 in this.dataHolder)
            {
                
                _loc_2 = this.getData(_loc_4);
                _loc_3 = _loc_2.type;
                _loc_1 = _loc_1 + ("(" + SFSDataType.fromId(_loc_2.type).toLowerCase() + ")");
                _loc_1 = _loc_1 + (" " + _loc_4 + ": ");
                if (_loc_3 == SFSDataType.SFS_OBJECT)
                {
                    _loc_1 = _loc_1 + (_loc_2.data as SFSObject).getDump(false);
                }
                else if (_loc_3 == SFSDataType.SFS_ARRAY)
                {
                    _loc_1 = _loc_1 + (_loc_2.data as SFSArray).getDump(false);
                }
                else if (_loc_3 == SFSDataType.BYTE_ARRAY)
                {
                    _loc_1 = _loc_1 + DefaultObjectDumpFormatter.prettyPrintByteArray(_loc_2.data as ByteArray);
                }
                else if (_loc_3 > SFSDataType.UTF_STRING && _loc_3 < SFSDataType.CLASS)
                {
                    _loc_1 = _loc_1 + ("[" + _loc_2.data + "]");
                }
                else
                {
                    _loc_1 = _loc_1 + _loc_2.data;
                }
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

        public function getData(param1:String) : SFSDataWrapper
        {
            return this.dataHolder[param1];
        }// end function

        public function getBool(param1:String) : Boolean
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as Boolean;
            }
            return undefined;
        }// end function

        public function getByte(param1:String) : int
        {
            return this.getInt(param1);
        }// end function

        public function getUnsignedByte(param1:String) : int
        {
            return this.getInt(param1) & 255;
        }// end function

        public function getShort(param1:String) : int
        {
            return this.getInt(param1);
        }// end function

        public function getInt(param1:String) : int
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as int;
            }
            return undefined;
        }// end function

        public function getLong(param1:String) : Number
        {
            return this.getDouble(param1);
        }// end function

        public function getFloat(param1:String) : Number
        {
            return this.getDouble(param1);
        }// end function

        public function getDouble(param1:String) : Number
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as Number;
            }
            return undefined;
        }// end function

        public function getUtfString(param1:String) : String
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as String;
            }
            return null;
        }// end function

        private function getArray(param1:String) : Array
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as Array;
            }
            return null;
        }// end function

        public function getBoolArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getByteArray(param1:String) : ByteArray
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as ByteArray;
            }
            return null;
        }// end function

        public function getUnsignedByteArray(param1:String) : Array
        {
            var _loc_2:* = this.getByteArray(param1);
            if (_loc_2 == null)
            {
                return null;
            }
            _loc_2.position = 0;
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3.push(_loc_2.readByte() & 255);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function getShortArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getIntArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getLongArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getFloatArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getDoubleArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getUtfStringArray(param1:String) : Array
        {
            return this.getArray(param1);
        }// end function

        public function getSFSArray(param1:String) : ISFSArray
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as ISFSArray;
            }
            return null;
        }// end function

        public function getSFSObject(param1:String) : ISFSObject
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data as ISFSObject;
            }
            return null;
        }// end function

        public function getClass(param1:String)
        {
            var _loc_2:* = this.dataHolder[param1] as SFSDataWrapper;
            if (_loc_2 != null)
            {
                return _loc_2.data;
            }
            return null;
        }// end function

        public function putNull(param1:String) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.NULL, null);
            return;
        }// end function

        public function putBool(param1:String, param2:Boolean) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BOOL, param2);
            return;
        }// end function

        public function putByte(param1:String, param2:int) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BYTE, param2);
            return;
        }// end function

        public function putShort(param1:String, param2:int) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SHORT, param2);
            return;
        }// end function

        public function putInt(param1:String, param2:int) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.INT, param2);
            return;
        }// end function

        public function putLong(param1:String, param2:Number) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.LONG, param2);
            return;
        }// end function

        public function putFloat(param1:String, param2:Number) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.FLOAT, param2);
            return;
        }// end function

        public function putDouble(param1:String, param2:Number) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.DOUBLE, param2);
            return;
        }// end function

        public function putUtfString(param1:String, param2:String) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.UTF_STRING, param2);
            return;
        }// end function

        public function putBoolArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BOOL_ARRAY, param2);
            return;
        }// end function

        public function putByteArray(param1:String, param2:ByteArray) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.BYTE_ARRAY, param2);
            return;
        }// end function

        public function putShortArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SHORT_ARRAY, param2);
            return;
        }// end function

        public function putIntArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.INT_ARRAY, param2);
            return;
        }// end function

        public function putLongArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.LONG_ARRAY, param2);
            return;
        }// end function

        public function putFloatArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.FLOAT_ARRAY, param2);
            return;
        }// end function

        public function putDoubleArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY, param2);
            return;
        }// end function

        public function putUtfStringArray(param1:String, param2:Array) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY, param2);
            return;
        }// end function

        public function putSFSArray(param1:String, param2:ISFSArray) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SFS_ARRAY, param2);
            return;
        }// end function

        public function putSFSObject(param1:String, param2:ISFSObject) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.SFS_OBJECT, param2);
            return;
        }// end function

        public function putClass(param1:String, param2) : void
        {
            this.dataHolder[param1] = new SFSDataWrapper(SFSDataType.CLASS, param2);
            return;
        }// end function

        public function put(param1:String, param2:SFSDataWrapper) : void
        {
            this.dataHolder[param1] = param2;
            return;
        }// end function

        public static function newFromObject(param1:Object, param2:Boolean = false) : SFSObject
        {
            return DefaultSFSDataSerializer.getInstance().genericObjectToSFSObject(param1, param2);
        }// end function

        public static function newFromBinaryData(param1:ByteArray) : SFSObject
        {
            return DefaultSFSDataSerializer.getInstance().binary2object(param1) as SFSObject;
        }// end function

        public static function newInstance() : SFSObject
        {
            return new SFSObject;
        }// end function

    }
}
