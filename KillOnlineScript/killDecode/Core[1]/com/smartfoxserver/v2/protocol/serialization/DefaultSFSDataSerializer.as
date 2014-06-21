package com.smartfoxserver.v2.protocol.serialization
{
    import as3reflect.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.exceptions.*;
    import flash.utils.*;

    public class DefaultSFSDataSerializer extends Object implements ISFSDataSerializer
    {
        private static const CLASS_MARKER_KEY:String = "$C";
        private static const CLASS_FIELDS_KEY:String = "$F";
        private static const FIELD_NAME_KEY:String = "N";
        private static const FIELD_VALUE_KEY:String = "V";
        private static var _instance:DefaultSFSDataSerializer;
        private static var _lock:Boolean = true;

        public function DefaultSFSDataSerializer()
        {
            if (_lock)
            {
                throw new Error("Can\'t use constructor, please use getInstance() method");
            }
            return;
        }// end function

        public function object2binary(param1:ISFSObject) : ByteArray
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeByte(SFSDataType.SFS_OBJECT);
            _loc_2.writeShort(param1.size());
            return this.obj2bin(param1, _loc_2);
        }// end function

        private function obj2bin(param1:ISFSObject, param2:ByteArray) : ByteArray
        {
            var _loc_4:SFSDataWrapper = null;
            var _loc_5:String = null;
            var _loc_3:* = param1.getKeys();
            for each (_loc_5 in _loc_3)
            {
                
                _loc_4 = param1.getData(_loc_5);
                param2 = this.encodeSFSObjectKey(param2, _loc_5);
                param2 = this.encodeObject(param2, _loc_4.type, _loc_4.data);
            }
            return param2;
        }// end function

        public function array2binary(param1:ISFSArray) : ByteArray
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeByte(SFSDataType.SFS_ARRAY);
            _loc_2.writeShort(param1.com.smartfoxserver.v2.entities.data:ISFSArray::size());
            return this.arr2bin(param1, _loc_2);
        }// end function

        private function arr2bin(param1:ISFSArray, param2:ByteArray) : ByteArray
        {
            var _loc_3:SFSDataWrapper = null;
            var _loc_4:int = 0;
            while (_loc_4 < param1.size())
            {
                
                _loc_3 = param1.getWrappedElementAt(_loc_4);
                param2 = this.encodeObject(param2, _loc_3.type, _loc_3.data);
                _loc_4++;
            }
            return param2;
        }// end function

        public function binary2object(param1:ByteArray) : ISFSObject
        {
            if (param1.length < 3)
            {
                throw new SFSCodecError("Can\'t decode an SFSObject. Byte data is insufficient. Size: " + param1.length + " byte(s)");
            }
            param1.position = 0;
            return this.decodeSFSObject(param1);
        }// end function

        private function decodeSFSObject(param1:ByteArray) : ISFSObject
        {
            var i:int;
            var key:String;
            var decodedObject:SFSDataWrapper;
            var buffer:* = param1;
            var sfsObject:* = SFSObject.newInstance();
            var headerByte:* = buffer.readByte();
            if (headerByte != SFSDataType.SFS_OBJECT)
            {
                throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_OBJECT + ", found: " + headerByte);
            }
            var size:* = buffer.readShort();
            if (size < 0)
            {
                throw new SFSCodecError("Can\'t decode SFSObject. Size is negative: " + size);
            }
            try
            {
                i;
                while (i < size)
                {
                    
                    key = buffer.readUTF();
                    decodedObject = this.decodeObject(buffer);
                    if (decodedObject != null)
                    {
                        sfsObject.put(key, decodedObject);
                    }
                    else
                    {
                        throw new SFSCodecError("Could not decode value for SFSObject with key: " + key);
                    }
                    i = (i + 1);
                }
            }
            catch (err:SFSCodecError)
            {
                throw err;
            }
            return sfsObject;
        }// end function

        public function binary2array(param1:ByteArray) : ISFSArray
        {
            if (param1.length < 3)
            {
                throw new SFSCodecError("Can\'t decode an SFSArray. Byte data is insufficient. Size: " + param1.length + " byte(s)");
            }
            param1.position = 0;
            return this.decodeSFSArray(param1);
        }// end function

        private function decodeSFSArray(param1:ByteArray) : ISFSArray
        {
            var i:int;
            var decodedObject:SFSDataWrapper;
            var buffer:* = param1;
            var sfsArray:* = SFSArray.newInstance();
            var headerByte:* = buffer.readByte();
            if (headerByte != SFSDataType.SFS_ARRAY)
            {
                throw new SFSCodecError("Invalid SFSDataType. Expected: " + SFSDataType.SFS_ARRAY + ", found: " + headerByte);
            }
            var size:* = buffer.readShort();
            if (size < 0)
            {
                throw new SFSCodecError("Can\'t decode SFSArray. Size is negative: " + size);
            }
            try
            {
                i;
                while (i < size)
                {
                    
                    decodedObject = this.decodeObject(buffer);
                    if (decodedObject != null)
                    {
                        sfsArray.add(decodedObject);
                    }
                    else
                    {
                        throw new SFSCodecError("Could not decode SFSArray item at index: " + i);
                    }
                    i = (i + 1);
                }
            }
            catch (err:SFSCodecError)
            {
                throw err;
            }
            return sfsArray;
        }// end function

        private function decodeObject(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:SFSDataWrapper = null;
            var _loc_4:ISFSObject = null;
            var _loc_5:int = 0;
            var _loc_6:* = undefined;
            var _loc_3:* = param1.readByte();
            if (_loc_3 == SFSDataType.NULL)
            {
                _loc_2 = this.binDecode_NULL(param1);
            }
            else if (_loc_3 == SFSDataType.BOOL)
            {
                _loc_2 = this.binDecode_BOOL(param1);
            }
            else if (_loc_3 == SFSDataType.BOOL_ARRAY)
            {
                _loc_2 = this.binDecode_BOOL_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.BYTE)
            {
                _loc_2 = this.binDecode_BYTE(param1);
            }
            else if (_loc_3 == SFSDataType.BYTE_ARRAY)
            {
                _loc_2 = this.binDecode_BYTE_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.SHORT)
            {
                _loc_2 = this.binDecode_SHORT(param1);
            }
            else if (_loc_3 == SFSDataType.SHORT_ARRAY)
            {
                _loc_2 = this.binDecode_SHORT_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.INT)
            {
                _loc_2 = this.binDecode_INT(param1);
            }
            else if (_loc_3 == SFSDataType.INT_ARRAY)
            {
                _loc_2 = this.binDecode_INT_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.LONG)
            {
                _loc_2 = this.binDecode_LONG(param1);
            }
            else if (_loc_3 == SFSDataType.LONG_ARRAY)
            {
                _loc_2 = this.binDecode_LONG_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.FLOAT)
            {
                _loc_2 = this.binDecode_FLOAT(param1);
            }
            else if (_loc_3 == SFSDataType.FLOAT_ARRAY)
            {
                _loc_2 = this.binDecode_FLOAT_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.DOUBLE)
            {
                _loc_2 = this.binDecode_DOUBLE(param1);
            }
            else if (_loc_3 == SFSDataType.DOUBLE_ARRAY)
            {
                _loc_2 = this.binDecode_DOUBLE_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.UTF_STRING)
            {
                _loc_2 = this.binDecode_UTF_STRING(param1);
            }
            else if (_loc_3 == SFSDataType.UTF_STRING_ARRAY)
            {
                _loc_2 = this.binDecode_UTF_STRING_ARRAY(param1);
            }
            else if (_loc_3 == SFSDataType.SFS_ARRAY)
            {
                (param1.position - 1);
                _loc_2 = new SFSDataWrapper(SFSDataType.SFS_ARRAY, this.decodeSFSArray(param1));
            }
            else if (_loc_3 == SFSDataType.SFS_OBJECT)
            {
                (param1.position - 1);
                _loc_4 = this.decodeSFSObject(param1);
                _loc_5 = SFSDataType.SFS_OBJECT;
                _loc_6 = _loc_4;
                if (_loc_4.containsKey(CLASS_MARKER_KEY) && _loc_4.containsKey(CLASS_FIELDS_KEY))
                {
                    _loc_5 = SFSDataType.CLASS;
                    _loc_6 = this.sfs2as(_loc_4);
                }
                _loc_2 = new SFSDataWrapper(_loc_5, _loc_6);
            }
            else
            {
                throw new Error("Unknow SFSDataType ID: " + _loc_3);
            }
            return _loc_2;
        }// end function

        private function encodeObject(param1:ByteArray, param2:int, param3) : ByteArray
        {
            switch(param2)
            {
                case SFSDataType.NULL:
                {
                    param1 = this.binEncode_NULL(param1);
                    break;
                }
                case SFSDataType.BOOL:
                {
                    param1 = this.binEncode_BOOL(param1, param3 as Boolean);
                    break;
                }
                case SFSDataType.BYTE:
                {
                    param1 = this.binEncode_BYTE(param1, param3 as int);
                    break;
                }
                case SFSDataType.SHORT:
                {
                    param1 = this.binEncode_SHORT(param1, param3 as int);
                    break;
                }
                case SFSDataType.INT:
                {
                    param1 = this.binEncode_INT(param1, param3 as int);
                    break;
                }
                case SFSDataType.LONG:
                {
                    param1 = this.binEncode_LONG(param1, param3 as Number);
                    break;
                }
                case SFSDataType.FLOAT:
                {
                    param1 = this.binEncode_FLOAT(param1, param3 as Number);
                    break;
                }
                case SFSDataType.DOUBLE:
                {
                    param1 = this.binEncode_DOUBLE(param1, param3 as Number);
                    break;
                }
                case SFSDataType.UTF_STRING:
                {
                    param1 = this.binEncode_UTF_STRING(param1, param3 as String);
                    break;
                }
                case SFSDataType.BOOL_ARRAY:
                {
                    param1 = this.binEncode_BOOL_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.BYTE_ARRAY:
                {
                    param1 = this.binEncode_BYTE_ARRAY(param1, param3 as ByteArray);
                    break;
                }
                case SFSDataType.SHORT_ARRAY:
                {
                    param1 = this.binEncode_SHORT_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.INT_ARRAY:
                {
                    param1 = this.binEncode_INT_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.LONG_ARRAY:
                {
                    param1 = this.binEncode_LONG_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.FLOAT_ARRAY:
                {
                    param1 = this.binEncode_FLOAT_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.DOUBLE_ARRAY:
                {
                    param1 = this.binEncode_DOUBLE_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.UTF_STRING_ARRAY:
                {
                    param1 = this.binEncode_UTF_STRING_ARRAY(param1, param3 as Array);
                    break;
                }
                case SFSDataType.SFS_ARRAY:
                {
                    param1 = this.addData(param1, this.array2binary(param3 as SFSArray));
                    break;
                }
                case SFSDataType.SFS_OBJECT:
                {
                    param1 = this.addData(param1, this.object2binary(param3 as SFSObject));
                    break;
                }
                case SFSDataType.CLASS:
                {
                    param1 = this.addData(param1, this.object2binary(this.as2sfs(param3)));
                    break;
                }
                default:
                {
                    throw new SFSCodecError("Unrecognized type in SFSObject serialization: " + param2);
                    break;
                }
            }
            return param1;
        }// end function

        private function binDecode_NULL(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.NULL, null);
        }// end function

        private function binDecode_BOOL(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.BOOL, param1.readBoolean());
        }// end function

        private function binDecode_BYTE(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.BYTE, param1.readByte());
        }// end function

        private function binDecode_SHORT(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.SHORT, param1.readShort());
        }// end function

        private function binDecode_INT(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.INT, param1.readInt());
        }// end function

        private function binDecode_LONG(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.LONG, this.decodeLongValue(param1));
        }// end function

        private function decodeLongValue(param1:ByteArray) : Number
        {
            var _loc_2:* = param1.readInt();
            var _loc_3:* = param1.readUnsignedInt();
            return _loc_2 * Math.pow(2, 32) + _loc_3;
        }// end function

        private function encodeLongValue(param1:Number, param2:ByteArray) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (param1 > -1)
            {
                _loc_3 = param1 / Math.pow(2, 32);
                _loc_4 = param1 % Math.pow(2, 32);
            }
            else
            {
                _loc_5 = Math.abs(param1);
                _loc_3 = --_loc_5 / Math.pow(2, 32);
                _loc_4 = --_loc_5 % Math.pow(2, 32);
                _loc_3 = ~_loc_3;
                _loc_4 = ~_loc_4;
            }
            param2.writeUnsignedInt(_loc_3);
            param2.writeUnsignedInt(_loc_4);
            return;
        }// end function

        private function binDecode_FLOAT(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.FLOAT, param1.readFloat());
        }// end function

        private function binDecode_DOUBLE(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.DOUBLE, param1.readDouble());
        }// end function

        private function binDecode_UTF_STRING(param1:ByteArray) : SFSDataWrapper
        {
            return new SFSDataWrapper(SFSDataType.UTF_STRING, param1.readUTF());
        }// end function

        private function binDecode_BOOL_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readBoolean());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.BOOL_ARRAY, _loc_3);
        }// end function

        private function binDecode_BYTE_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = param1.readInt();
            if (_loc_2 < 0)
            {
                throw new SFSCodecError("Array negative size: " + _loc_2);
            }
            var _loc_3:* = new ByteArray();
            param1.readBytes(_loc_3, 0, _loc_2);
            return new SFSDataWrapper(SFSDataType.BYTE_ARRAY, _loc_3);
        }// end function

        private function binDecode_SHORT_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readShort());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.SHORT_ARRAY, _loc_3);
        }// end function

        private function binDecode_INT_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readInt());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.INT_ARRAY, _loc_3);
        }// end function

        private function binDecode_LONG_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(this.decodeLongValue(param1));
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.LONG_ARRAY, _loc_3);
        }// end function

        private function binDecode_FLOAT_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readFloat());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.FLOAT_ARRAY, _loc_3);
        }// end function

        private function binDecode_DOUBLE_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readDouble());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.DOUBLE_ARRAY, _loc_3);
        }// end function

        private function binDecode_UTF_STRING_ARRAY(param1:ByteArray) : SFSDataWrapper
        {
            var _loc_2:* = this.getTypedArraySize(param1);
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3.push(param1.readUTF());
                _loc_4++;
            }
            return new SFSDataWrapper(SFSDataType.UTF_STRING_ARRAY, _loc_3);
        }// end function

        private function getTypedArraySize(param1:ByteArray) : int
        {
            var _loc_2:* = param1.readShort();
            if (_loc_2 < 0)
            {
                throw new SFSCodecError("Array negative size: " + _loc_2);
            }
            return _loc_2;
        }// end function

        private function binEncode_NULL(param1:ByteArray) : ByteArray
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeByte(0);
            return this.addData(param1, _loc_2);
        }// end function

        private function binEncode_BOOL(param1:ByteArray, param2:Boolean) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.BOOL);
            _loc_3.writeBoolean(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_BYTE(param1:ByteArray, param2:int) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.BYTE);
            _loc_3.writeByte(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_SHORT(param1:ByteArray, param2:int) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.SHORT);
            _loc_3.writeShort(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_INT(param1:ByteArray, param2:int) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.INT);
            _loc_3.writeInt(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_LONG(param1:ByteArray, param2:Number) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.LONG);
            this.encodeLongValue(param2, _loc_3);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_FLOAT(param1:ByteArray, param2:Number) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.FLOAT);
            _loc_3.writeFloat(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_DOUBLE(param1:ByteArray, param2:Number) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.DOUBLE);
            _loc_3.writeDouble(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_UTF_STRING(param1:ByteArray, param2:String) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.UTF_STRING);
            _loc_3.writeUTF(param2);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_BOOL_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.BOOL_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeBoolean(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_BYTE_ARRAY(param1:ByteArray, param2:ByteArray) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.BYTE_ARRAY);
            _loc_3.writeInt(param2.length);
            _loc_3.writeBytes(param2, 0, param2.length);
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_SHORT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.SHORT_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeShort(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_INT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.INT_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeInt(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_LONG_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.LONG_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                this.encodeLongValue(param2[_loc_4], _loc_3);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_FLOAT_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.FLOAT_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeFloat(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_DOUBLE_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.DOUBLE_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeDouble(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function binEncode_UTF_STRING_ARRAY(param1:ByteArray, param2:Array) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(SFSDataType.UTF_STRING_ARRAY);
            _loc_3.writeShort(param2.length);
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_3.writeUTF(param2[_loc_4]);
                _loc_4++;
            }
            return this.addData(param1, _loc_3);
        }// end function

        private function encodeSFSObjectKey(param1:ByteArray, param2:String) : ByteArray
        {
            param1.writeUTF(param2);
            return param1;
        }// end function

        private function addData(param1:ByteArray, param2:ByteArray) : ByteArray
        {
            param1.writeBytes(param2, 0, param2.length);
            return param1;
        }// end function

        public function as2sfs(param1) : ISFSObject
        {
            var _loc_2:* = SFSObject.newInstance();
            this.convertAsObj(param1, _loc_2);
            return _loc_2;
        }// end function

        private function encodeClassName(param1:String) : String
        {
            return param1.replace("::", ".");
        }// end function

        private function convertAsObj(param1, param2:ISFSObject) : void
        {
            var _loc_6:Field = null;
            var _loc_7:String = null;
            var _loc_8:* = undefined;
            var _loc_9:ISFSObject = null;
            var _loc_3:* = Type.forInstance(param1);
            var _loc_4:* = this.encodeClassName(ClassUtils.getFullyQualifiedName(_loc_3.clazz));
            if (this.encodeClassName(ClassUtils.getFullyQualifiedName(_loc_3.clazz)) == null)
            {
                throw new SFSCodecError("Cannot detect class name: " + param2);
            }
            if (!(param1 is SerializableSFSType))
            {
                throw new SFSCodecError("Cannot serialize object: " + param1 + ", type: " + _loc_4 + " -- It doesn\'t implement the SerializableSFSType interface");
            }
            var _loc_5:* = SFSArray.newInstance();
            param2.putUtfString(CLASS_MARKER_KEY, _loc_4);
            param2.putSFSArray(CLASS_FIELDS_KEY, _loc_5);
            for each (_loc_6 in _loc_3.fields)
            {
                
                if (_loc_6.isStatic)
                {
                    continue;
                }
                _loc_7 = _loc_6.name;
                _loc_8 = param1[_loc_7];
                if (_loc_7.charAt(0) == "$")
                {
                    continue;
                }
                _loc_9 = SFSObject.newInstance();
                _loc_9.putUtfString(FIELD_NAME_KEY, _loc_7);
                _loc_9.put(FIELD_VALUE_KEY, this.wrapASField(_loc_8));
                _loc_5.addSFSObject(_loc_9);
            }
            return;
        }// end function

        private function wrapASField(param1) : SFSDataWrapper
        {
            var _loc_2:SFSDataWrapper = null;
            if (param1 == null)
            {
                return new SFSDataWrapper(SFSDataType.NULL, null);
            }
            var _loc_3:* = Type.forInstance(param1).name;
            if (param1 is Boolean)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.BOOL, param1);
            }
            else if (param1 is int || param1 is uint)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.INT, param1);
            }
            else if (param1 is Number)
            {
                if (param1 == Math.floor(param1))
                {
                    _loc_2 = new SFSDataWrapper(SFSDataType.LONG, param1);
                }
                else
                {
                    _loc_2 = new SFSDataWrapper(SFSDataType.DOUBLE, param1);
                }
            }
            else if (param1 is String)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.UTF_STRING, param1);
            }
            else if (param1 is Array)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.SFS_ARRAY, this.unrollArray(param1));
            }
            else if (param1 is SerializableSFSType)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.SFS_OBJECT, this.as2sfs(param1));
            }
            else if (param1 is Object)
            {
                _loc_2 = new SFSDataWrapper(SFSDataType.SFS_OBJECT, this.unrollDictionary(param1));
            }
            return _loc_2;
        }// end function

        private function unrollArray(param1:Array) : ISFSArray
        {
            var _loc_2:* = SFSArray.newInstance();
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2.add(this.wrapASField(param1[_loc_3]));
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private function unrollDictionary(param1:Object) : ISFSObject
        {
            var _loc_3:String = null;
            var _loc_2:* = SFSObject.newInstance();
            for (_loc_3 in param1)
            {
                
                _loc_2.put(_loc_3, this.wrapASField(param1[_loc_3]));
            }
            return _loc_2;
        }// end function

        public function sfs2as(param1:ISFSObject)
        {
            var _loc_2:* = undefined;
            if (!param1.containsKey(CLASS_MARKER_KEY) && !param1.containsKey(CLASS_FIELDS_KEY))
            {
                throw new SFSCodecError("The SFSObject passed does not represent any serialized class.");
            }
            var _loc_3:* = param1.getUtfString(CLASS_MARKER_KEY);
            var _loc_4:* = ClassUtils.forName(_loc_3);
            _loc_2 = new ClassUtils.forName(_loc_3);
            if (!(_loc_2 is SerializableSFSType))
            {
                throw new SFSCodecError("Cannot deserialize object: " + _loc_2 + ", type: " + _loc_3 + " -- It doesn\'t implement the SerializableSFSType interface");
            }
            this.convertSFSObject(param1.getSFSArray(CLASS_FIELDS_KEY), _loc_2);
            return _loc_2;
        }// end function

        private function convertSFSObject(param1:ISFSArray, param2) : void
        {
            var _loc_3:ISFSObject = null;
            var _loc_4:String = null;
            var _loc_5:* = undefined;
            var _loc_6:int = 0;
            while (_loc_6 < param1.size())
            {
                
                _loc_3 = param1.getSFSObject(_loc_6);
                _loc_4 = _loc_3.getUtfString(FIELD_NAME_KEY);
                _loc_5 = this.unwrapAsField(_loc_3.getData(FIELD_VALUE_KEY));
                param2[_loc_4] = _loc_5;
                _loc_6++;
            }
            return;
        }// end function

        private function unwrapAsField(param1:SFSDataWrapper)
        {
            var _loc_2:* = undefined;
            var _loc_3:* = param1.type;
            if (_loc_3 <= SFSDataType.UTF_STRING)
            {
                _loc_2 = param1.data;
            }
            else if (_loc_3 == SFSDataType.SFS_ARRAY)
            {
                _loc_2 = this.rebuildArray(param1.data as ISFSArray);
            }
            else if (_loc_3 == SFSDataType.SFS_OBJECT)
            {
                _loc_2 = this.rebuildDict(param1.data as ISFSObject);
            }
            else if (_loc_3 == SFSDataType.CLASS)
            {
                _loc_2 = param1.data;
            }
            return _loc_2;
        }// end function

        private function rebuildArray(param1:ISFSArray) : Array
        {
            var _loc_2:Array = [];
            var _loc_3:int = 0;
            while (_loc_3 < param1.size())
            {
                
                _loc_2.push(this.unwrapAsField(param1.getWrappedElementAt(_loc_3)));
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private function rebuildDict(param1:ISFSObject) : Object
        {
            var _loc_3:String = null;
            var _loc_2:Object = {};
            for each (_loc_3 in param1.getKeys())
            {
                
                _loc_2[_loc_3] = this.unwrapAsField(param1.getData(_loc_3));
            }
            return _loc_2;
        }// end function

        public function genericObjectToSFSObject(param1:Object, param2:Boolean = false) : SFSObject
        {
            var _loc_3:* = new SFSObject();
            this._scanGenericObject(param1, _loc_3, param2);
            return _loc_3;
        }// end function

        private function _scanGenericObject(param1:Object, param2:ISFSObject, param3:Boolean = false) : void
        {
            var _loc_4:String = null;
            var _loc_5:* = undefined;
            var _loc_6:ISFSObject = null;
            for (_loc_4 in param1)
            {
                
                _loc_5 = param1[_loc_4];
                if (_loc_5 == null)
                {
                    param2.putNull(_loc_4);
                    continue;
                }
                if (_loc_5.toString() == "[object Object]" && !(_loc_5 is Array))
                {
                    _loc_6 = new SFSObject();
                    param2.putSFSObject(_loc_4, _loc_6);
                    this._scanGenericObject(_loc_5, _loc_6, param3);
                    continue;
                }
                if (_loc_5 is Array)
                {
                    param2.putSFSArray(_loc_4, this.genericArrayToSFSArray(_loc_5, param3));
                    continue;
                }
                if (_loc_5 is Boolean)
                {
                    param2.putBool(_loc_4, _loc_5);
                    continue;
                }
                if (_loc_5 is int && !param3)
                {
                    param2.putInt(_loc_4, _loc_5);
                    continue;
                }
                if (_loc_5 is Number)
                {
                    param2.putDouble(_loc_4, _loc_5);
                    continue;
                }
                if (_loc_5 is String)
                {
                    param2.putUtfString(_loc_4, _loc_5);
                }
            }
            return;
        }// end function

        public function sfsObjectToGenericObject(param1:ISFSObject) : Object
        {
            var _loc_2:Object = {};
            this._scanSFSObject(param1, _loc_2);
            return _loc_2;
        }// end function

        private function _scanSFSObject(param1:ISFSObject, param2:Object) : void
        {
            var _loc_4:String = null;
            var _loc_5:SFSDataWrapper = null;
            var _loc_6:Object = null;
            var _loc_3:* = param1.getKeys();
            for each (_loc_4 in _loc_3)
            {
                
                _loc_5 = param1.getData(_loc_4);
                if (_loc_5.type == SFSDataType.NULL)
                {
                    param2[_loc_4] = null;
                    continue;
                }
                if (_loc_5.type == SFSDataType.SFS_OBJECT)
                {
                    _loc_6 = {};
                    param2[_loc_4] = _loc_6;
                    this._scanSFSObject(_loc_5.data as ISFSObject, _loc_6);
                    continue;
                }
                if (_loc_5.type == SFSDataType.SFS_ARRAY)
                {
                    param2[_loc_4] = (_loc_5.data as SFSArray).toArray();
                    continue;
                }
                if (_loc_5.type == SFSDataType.CLASS)
                {
                    continue;
                    continue;
                }
                param2[_loc_4] = _loc_5.data;
            }
            return;
        }// end function

        public function genericArrayToSFSArray(param1:Array, param2:Boolean = false) : SFSArray
        {
            var _loc_3:* = new SFSArray();
            this._scanGenericArray(param1, _loc_3, param2);
            return _loc_3;
        }// end function

        private function _scanGenericArray(param1:Array, param2:ISFSArray, param3:Boolean = false) : void
        {
            var _loc_5:* = undefined;
            var _loc_6:ISFSArray = null;
            var _loc_4:int = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_5 = param1[_loc_4];
                if (_loc_5 == null)
                {
                    param2.addNull();
                }
                else if (_loc_5.toString() == "[object Object]" && !(_loc_5 is Array))
                {
                    param2.addSFSObject(this.genericObjectToSFSObject(_loc_5, param3));
                }
                else if (_loc_5 is Array)
                {
                    _loc_6 = new SFSArray();
                    param2.addSFSArray(_loc_6);
                    this._scanGenericArray(_loc_5, _loc_6, param3);
                }
                else if (_loc_5 is Boolean)
                {
                    param2.addBool(_loc_5);
                }
                else if (_loc_5 is int && !param3)
                {
                    param2.addInt(_loc_5);
                }
                else if (_loc_5 is Number)
                {
                    param2.addDouble(_loc_5);
                }
                else if (_loc_5 is String)
                {
                    param2.addUtfString(_loc_5);
                }
                _loc_4++;
            }
            return;
        }// end function

        public function sfsArrayToGenericArray(param1:ISFSArray) : Array
        {
            var _loc_2:Array = [];
            this._scanSFSArray(param1, _loc_2);
            return _loc_2;
        }// end function

        private function _scanSFSArray(param1:ISFSArray, param2:Array) : void
        {
            var _loc_4:SFSDataWrapper = null;
            var _loc_5:Array = null;
            var _loc_3:int = 0;
            while (_loc_3 < param1.size())
            {
                
                _loc_4 = param1.getWrappedElementAt(_loc_3);
                if (_loc_4.type == SFSDataType.NULL)
                {
                    param2[_loc_3] = null;
                }
                else if (_loc_4.type == SFSDataType.SFS_OBJECT)
                {
                    param2[_loc_3] = (_loc_4.data as SFSObject).toObject();
                }
                else if (_loc_4.type == SFSDataType.SFS_ARRAY)
                {
                    _loc_5 = [];
                    param2[_loc_3] = _loc_5;
                    this._scanSFSArray(_loc_4.data as ISFSArray, _loc_5);
                }
                else if (_loc_4.type == SFSDataType.CLASS)
                {
                    ;
                }
                else
                {
                    param2[_loc_3] = _loc_4.data;
                }
                _loc_3++;
            }
            return;
        }// end function

        public static function getInstance() : DefaultSFSDataSerializer
        {
            if (_instance == null)
            {
                _lock = false;
                _instance = new DefaultSFSDataSerializer;
                _lock = true;
            }
            return _instance;
        }// end function

    }
}
