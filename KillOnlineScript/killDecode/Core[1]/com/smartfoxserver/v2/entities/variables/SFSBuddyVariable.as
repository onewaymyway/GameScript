package com.smartfoxserver.v2.entities.variables
{
    import as3reflect.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.exceptions.*;

    public class SFSBuddyVariable extends Object implements BuddyVariable
    {
        protected var _name:String;
        protected var _type:String;
        protected var _value:Object;
        public static const OFFLINE_PREFIX:String = "$";

        public function SFSBuddyVariable(param1:String, param2, param3:int = -1)
        {
            this._name = param1;
            if (param3 > -1)
            {
                this._value = param2;
                this._type = VariableType.getTypeName(param3);
            }
            else
            {
                this.setValue(param2);
            }
            return;
        }// end function

        public function get isOffline() : Boolean
        {
            return this._name.charAt(0) == "$";
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function getValue()
        {
            return this._value;
        }// end function

        public function getBoolValue() : Boolean
        {
            return this._value as Boolean;
        }// end function

        public function getIntValue() : int
        {
            return this._value as int;
        }// end function

        public function getDoubleValue() : Number
        {
            return this._value as Number;
        }// end function

        public function getStringValue() : String
        {
            return this._value as String;
        }// end function

        public function getSFSObjectValue() : ISFSObject
        {
            return this._value as ISFSObject;
        }// end function

        public function getSFSArrayValue() : ISFSArray
        {
            return this._value as ISFSArray;
        }// end function

        public function isNull() : Boolean
        {
            return this.type == VariableType.getTypeName(VariableType.NULL);
        }// end function

        public function toSFSArray() : ISFSArray
        {
            var _loc_1:* = SFSArray.newInstance();
            _loc_1.addUtfString(this._name);
            _loc_1.addByte(VariableType.getTypeFromName(this._type));
            this.populateArrayWithValue(_loc_1);
            return _loc_1;
        }// end function

        public function toString() : String
        {
            return "[BuddyVar: " + this._name + ", type: " + this._type + ", value: " + this._value + "]";
        }// end function

        private function populateArrayWithValue(param1:ISFSArray) : void
        {
            var _loc_2:* = VariableType.getTypeFromName(this._type);
            switch(_loc_2)
            {
                case VariableType.NULL:
                {
                    param1.addNull();
                    break;
                }
                case VariableType.BOOL:
                {
                    param1.addBool(this.getBoolValue());
                    break;
                }
                case VariableType.INT:
                {
                    param1.addInt(this.getIntValue());
                    break;
                }
                case VariableType.DOUBLE:
                {
                    param1.addDouble(this.getDoubleValue());
                    break;
                }
                case VariableType.STRING:
                {
                    param1.addUtfString(this.getStringValue());
                    break;
                }
                case VariableType.OBJECT:
                {
                    param1.addSFSObject(this.getSFSObjectValue());
                    break;
                }
                case VariableType.ARRAY:
                {
                    param1.addSFSArray(this.getSFSArrayValue());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function setValue(param1) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            this._value = param1;
            if (param1 == null)
            {
                this._type = VariableType.getTypeName(VariableType.NULL);
            }
            else
            {
                _loc_2 = typeof(param1);
                if (_loc_2 == "boolean")
                {
                    this._type = VariableType.getTypeName(VariableType.BOOL);
                }
                else if (_loc_2 == "number")
                {
                    if (int(param1) == param1)
                    {
                        this._type = VariableType.getTypeName(VariableType.INT);
                    }
                    else
                    {
                        this._type = VariableType.getTypeName(VariableType.DOUBLE);
                    }
                }
                else if (_loc_2 == "string")
                {
                    this._type = VariableType.getTypeName(VariableType.STRING);
                }
                else if (_loc_2 == "object")
                {
                    _loc_3 = Type.forInstance(param1).name;
                    if (_loc_3 == "SFSObject")
                    {
                        this._type = VariableType.getTypeName(VariableType.OBJECT);
                    }
                    else if (_loc_3 == "SFSArray")
                    {
                        this._type = VariableType.getTypeName(VariableType.ARRAY);
                    }
                    else
                    {
                        throw new SFSError("Unsupport SFS Variable type: " + _loc_3);
                    }
                }
            }
            return;
        }// end function

        public static function fromSFSArray(param1:ISFSArray) : BuddyVariable
        {
            var _loc_2:* = new SFSBuddyVariable(param1.getUtfString(0), param1.getElementAt(2), param1.getByte(1));
            return _loc_2;
        }// end function

    }
}
