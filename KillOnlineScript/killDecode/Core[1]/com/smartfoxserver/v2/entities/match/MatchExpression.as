package com.smartfoxserver.v2.entities.match
{
    import com.smartfoxserver.v2.entities.data.*;

    public class MatchExpression extends Object
    {
        private var _varName:String;
        private var _condition:IMatcher;
        private var _value:Object;
        var _logicOp:LogicOperator;
        var _parent:MatchExpression;
        var _next:MatchExpression;

        public function MatchExpression(param1:String, param2:IMatcher, param3)
        {
            this._varName = param1;
            this._condition = param2;
            this._value = param3;
            return;
        }// end function

        public function and(param1:String, param2:IMatcher, param3) : MatchExpression
        {
            this._next = chainedMatchExpression(param1, param2, param3, LogicOperator.AND, this);
            return this._next;
        }// end function

        public function or(param1:String, param2:IMatcher, param3) : MatchExpression
        {
            this._next = chainedMatchExpression(param1, param2, param3, LogicOperator.OR, this);
            return this._next;
        }// end function

        public function get varName() : String
        {
            return this._varName;
        }// end function

        public function get condition() : IMatcher
        {
            return this._condition;
        }// end function

        public function get value()
        {
            return this._value;
        }// end function

        public function get logicOp() : LogicOperator
        {
            return this._logicOp;
        }// end function

        public function hasNext() : Boolean
        {
            return this._next != null;
        }// end function

        public function get next() : MatchExpression
        {
            return this._next;
        }// end function

        public function rewind() : MatchExpression
        {
            var _loc_1:MatchExpression = this;
            while (true)
            {
                
                if (_loc_1._parent != null)
                {
                    _loc_1 = _loc_1._parent;
                    continue;
                }
                break;
            }
            return _loc_1;
        }// end function

        public function asString() : String
        {
            var _loc_1:String = "";
            if (this._logicOp != null)
            {
                _loc_1 = _loc_1 + (" " + this.logicOp.id + " ");
            }
            _loc_1 = _loc_1 + "(";
            _loc_1 = _loc_1 + (this._varName + " " + this._condition.symbol + " " + (this.value is String ? ("\'" + this.value + "\'") : (this.value)));
            _loc_1 = _loc_1 + ")";
            return _loc_1;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = this.rewind();
            var _loc_2:* = _loc_1.asString();
            while (_loc_1.hasNext())
            {
                
                _loc_1 = _loc_1.next;
                _loc_2 = _loc_2 + _loc_1.asString();
            }
            return _loc_2;
        }// end function

        public function toSFSArray() : ISFSArray
        {
            var _loc_1:* = this.rewind();
            var _loc_2:* = new SFSArray();
            _loc_2.addSFSArray(_loc_1.expressionAsSFSArray());
            while (_loc_1.hasNext())
            {
                
                _loc_1 = _loc_1.next;
                _loc_2.addSFSArray(_loc_1.expressionAsSFSArray());
            }
            return _loc_2;
        }// end function

        private function expressionAsSFSArray() : ISFSArray
        {
            var _loc_1:* = new SFSArray();
            if (this._logicOp != null)
            {
                _loc_1.addUtfString(this._logicOp.id);
            }
            else
            {
                _loc_1.addNull();
            }
            _loc_1.addUtfString(this._varName);
            _loc_1.addByte(this._condition.type);
            _loc_1.addUtfString(this._condition.symbol);
            if (this._condition.type == 0)
            {
                _loc_1.addBool(this._value);
            }
            else if (this._condition.type == 1)
            {
                _loc_1.addDouble(this._value);
            }
            else
            {
                _loc_1.addUtfString(this._value);
            }
            return _loc_1;
        }// end function

        static function chainedMatchExpression(param1:String, param2:IMatcher, param3, param4:LogicOperator, param5:MatchExpression) : MatchExpression
        {
            var _loc_6:* = new MatchExpression(param1, param2, param3);
            new MatchExpression(param1, param2, param3)._logicOp = param4;
            _loc_6._parent = param5;
            return _loc_6;
        }// end function

    }
}
