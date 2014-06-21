package com.junkbyte.console.core
{
    import Executer.as$253.*;
    import com.junkbyte.console.vos.*;
    import flash.events.*;
    import flash.utils.*;

    public class Executer extends EventDispatcher
    {
        private var _values:Array;
        private var _running:Boolean;
        private var _scope:Object;
        private var _returned:Object;
        private var _saved:Object;
        private var _reserved:Array;
        public var autoScope:Boolean;
        public static const RETURNED:String = "returned";
        public static const CLASSES:String = "ExeValue|((com.junkbyte.console.core::)?Executer)";
        private static const VALKEY:String = "#";

        public function Executer()
        {
            return;
        }// end function

        public function get returned()
        {
            return this._returned;
        }// end function

        public function get scope()
        {
            return this._scope;
        }// end function

        public function setStored(o:Object) : void
        {
            this._saved = o;
            return;
        }// end function

        public function setReserved(a:Array) : void
        {
            this._reserved = a;
            return;
        }// end function

        public function exec(s, str:String)
        {
            var s:* = s;
            var str:* = str;
            if (this._running)
            {
                throw new Error("CommandExec.exec() is already runnnig. Does not support loop backs.");
            }
            this._running = true;
            this._scope = s;
            this._values = [];
            if (!this._saved)
            {
                this._saved = new Object();
            }
            if (!this._reserved)
            {
                this._reserved = new Array();
            }
            try
            {
                this._exec(str);
            }
            catch (e:Error)
            {
                reset();
                throw e;
            }
            this.reset();
            return this._returned;
        }// end function

        private function reset() : void
        {
            this._saved = null;
            this._reserved = null;
            this._values = null;
            this._running = false;
            return;
        }// end function

        private function _exec(str:String) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:String = null;
            var _loc_11:* = undefined;
            var _loc_2:* = /''''|""""|(''(.*?)[^\\\]'')|(""(.*?)[^\\\]"")""''|""|('(.*?)[^\\]')|("(.*?)[^\\]")/;
            var _loc_3:* = _loc_2.exec(str);
            while (_loc_3 != null)
            {
                
                _loc_6 = _loc_3[0];
                _loc_7 = _loc_6.charAt(0);
                _loc_8 = _loc_6.indexOf(_loc_7);
                _loc_9 = _loc_6.lastIndexOf(_loc_7);
                _loc_10 = _loc_6.substring((_loc_8 + 1), _loc_9).replace(/\\\(.)""\\(.)/g, "$1");
                str = this.tempValue(str, new ExeValue(_loc_10), _loc_3.index + _loc_8, _loc_3.index + _loc_9 + 1);
                _loc_3 = _loc_2.exec(str);
            }
            if (str.search(new RegExp("\'|\"")) >= 0)
            {
                throw new Error("Bad syntax extra quotation marks");
            }
            var _loc_4:* = str.split(/\s*;\s*""\s*;\s*/);
            for each (_loc_5 in _loc_4)
            {
                
                if (_loc_5.length)
                {
                    _loc_11 = this._saved[RETURNED];
                    if (_loc_11)
                    {
                    }
                    if (_loc_5 == "/")
                    {
                        this._scope = _loc_11;
                        dispatchEvent(new Event(Event.COMPLETE));
                        continue;
                    }
                    this.execNest(_loc_5);
                }
            }
            return;
        }// end function

        private function execNest(line:String)
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:Boolean = false;
            var _loc_8:int = 0;
            var _loc_9:String = null;
            var _loc_10:Array = null;
            var _loc_11:String = null;
            var _loc_12:ExeValue = null;
            var _loc_13:String = null;
            line = this.ignoreWhite(line);
            var _loc_2:* = line.lastIndexOf("(");
            while (_loc_2 >= 0)
            {
                
                _loc_3 = line.indexOf(")", _loc_2);
                if (line.substring((_loc_2 + 1), _loc_3).search(/\w""\w/) >= 0)
                {
                    _loc_4 = _loc_2;
                    _loc_5 = _loc_2 + 1;
                    do
                    {
                        
                        _loc_4 = _loc_4 + 1;
                        _loc_4 = line.indexOf("(", _loc_4);
                        _loc_5 = line.indexOf(")", (_loc_5 + 1));
                        if (_loc_4 >= 0)
                        {
                        }
                    }while (_loc_4 < _loc_5)
                    _loc_6 = line.substring((_loc_2 + 1), _loc_5);
                    _loc_7 = false;
                    _loc_8 = _loc_2 - 1;
                    while (true)
                    {
                        
                        _loc_9 = line.charAt(_loc_8);
                        if (!_loc_9.match(/[^\s]""[^\s]/))
                        {
                            _loc_9.match(/[^\s]""[^\s]/);
                        }
                        if (_loc_8 <= 0)
                        {
                            if (_loc_9.match(/\w""\w/))
                            {
                                _loc_7 = true;
                            }
                            break;
                        }
                        _loc_8 = _loc_8 - 1;
                    }
                    if (_loc_7)
                    {
                        _loc_10 = _loc_6.split(",");
                        line = this.tempValue(line, new ExeValue(_loc_10), (_loc_2 + 1), _loc_5);
                        for (_loc_11 in _loc_10)
                        {
                            
                            _loc_10[_loc_11] = this.execOperations(this.ignoreWhite(_loc_10[_loc_11])).value;
                        }
                    }
                    else
                    {
                        _loc_12 = new ExeValue(_loc_12);
                        line = this.tempValue(line, _loc_12, _loc_2, (_loc_5 + 1));
                        _loc_12.setValue(this.execOperations(this.ignoreWhite(_loc_6)).value);
                    }
                }
                _loc_2 = line.lastIndexOf("(", (_loc_2 - 1));
            }
            this._returned = this.execOperations(line).value;
            if (this._returned)
            {
            }
            if (this.autoScope)
            {
                _loc_13 = typeof(this._returned);
                if (_loc_13 != "object")
                {
                }
                if (_loc_13 == "xml")
                {
                    this._scope = this._returned;
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
            return this._returned;
        }// end function

        private function tempValue(str:String, v, indOpen:int, indClose:int) : String
        {
            str = str.substring(0, indOpen) + VALKEY + this._values.length + str.substring(indClose);
            this._values.push(v);
            return str;
        }// end function

        private function execOperations(str:String) : ExeValue
        {
            var _loc_7:String = null;
            var _loc_8:* = undefined;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:String = null;
            var _loc_14:ExeValue = null;
            var _loc_15:ExeValue = null;
            var _loc_2:* = /\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof|delete\s)\s*""\s*(((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\=\=?|\!\=|\>\>?\>?|\<\<?)\=?)|=|\~|\sis\s|typeof|delete\s)\s*/g;
            var _loc_3:* = _loc_2.exec(str);
            var _loc_4:Array = [];
            if (_loc_3 == null)
            {
                _loc_4.push(str);
            }
            else
            {
                _loc_11 = 0;
                while (_loc_3 != null)
                {
                    
                    _loc_12 = _loc_3.index;
                    _loc_13 = _loc_3[0];
                    _loc_3 = _loc_2.exec(str);
                    if (_loc_3 == null)
                    {
                        _loc_4.push(str.substring(_loc_11, _loc_12));
                        _loc_4.push(this.ignoreWhite(_loc_13));
                        _loc_4.push(str.substring(_loc_12 + _loc_13.length));
                        continue;
                    }
                    _loc_4.push(str.substring(_loc_11, _loc_12));
                    _loc_4.push(this.ignoreWhite(_loc_13));
                    _loc_11 = _loc_12 + _loc_13.length;
                }
            }
            var _loc_5:* = _loc_4.length;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_4[_loc_6] = this.execSimple(_loc_4[_loc_6]);
                _loc_6 = _loc_6 + 2;
            }
            var _loc_9:* = /((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=""((\|\||\&\&|[+|\-|*|\/|\%|\||\&|\^]|\>\>\>?|\<\<)\=)|=/;
            _loc_6 = 1;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                if (_loc_7.replace(_loc_9, "") != "")
                {
                    _loc_8 = this.operate(_loc_4[(_loc_6 - 1)], _loc_7, _loc_4[(_loc_6 + 1)]);
                    _loc_14 = ExeValue(_loc_4[(_loc_6 - 1)]);
                    _loc_14.setValue(_loc_8);
                    _loc_4.splice(_loc_6, 2);
                    _loc_6 = _loc_6 - 2;
                    _loc_5 = _loc_5 - 2;
                }
                _loc_6 = _loc_6 + 2;
            }
            _loc_4.reverse();
            var _loc_10:* = _loc_4[0];
            _loc_6 = 1;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = _loc_4[_loc_6];
                if (_loc_7.replace(_loc_9, "") == "")
                {
                    _loc_10 = _loc_4[(_loc_6 - 1)];
                    _loc_15 = _loc_4[(_loc_6 + 1)];
                    if (_loc_7.length > 1)
                    {
                        _loc_7 = _loc_7.substring(0, (_loc_7.length - 1));
                    }
                    _loc_8 = this.operate(_loc_15, _loc_7, _loc_10);
                    _loc_15.setValue(_loc_8);
                }
                _loc_6 = _loc_6 + 2;
            }
            return _loc_10;
        }// end function

        private function execSimple(str:String) : ExeValue
        {
            var firstparts:Array;
            var newstr:String;
            var defclose:int;
            var newobj:*;
            var classstr:String;
            var def:*;
            var havemore:Boolean;
            var index:int;
            var isFun:Boolean;
            var basestr:String;
            var newv:ExeValue;
            var newbase:*;
            var closeindex:int;
            var paramstr:String;
            var params:Array;
            var nss:Array;
            var ns:Namespace;
            var nsv:*;
            var str:* = str;
            var v:* = new ExeValue(this._scope);
            if (str.indexOf("new ") == 0)
            {
                newstr = str;
                defclose = str.indexOf(")");
                if (defclose >= 0)
                {
                    newstr = str.substring(0, (defclose + 1));
                }
                newobj = this.makeNew(newstr.substring(4));
                str = this.tempValue(str, new ExeValue(newobj), 0, newstr.length);
            }
            var reg:* = /\.|\(""\.|\(/g;
            var result:* = reg.exec(str);
            if (result != null)
            {
            }
            if (!isNaN(Number(str)))
            {
                return this.execValue(str, this._scope);
            }
            firstparts = String(str.split("(")[0]).split(".");
            if (firstparts.length > 0)
            {
                do
                {
                    
                    classstr = firstparts.join(".");
                    try
                    {
                        def = getDefinitionByName(this.ignoreWhite(classstr));
                        havemore = str.length > classstr.length;
                        str = this.tempValue(str, new ExeValue(def), 0, classstr.length);
                        if (havemore)
                        {
                            reg.lastIndex = 0;
                            result = reg.exec(str);
                        }
                        else
                        {
                            return this.execValue(str);
                        }
                        break;
                    }
                    catch (e:Error)
                    {
                        firstparts.pop();
                    }
                }while (firstparts.length)
            }
            var previndex:int;
            while (result != null)
            {
                
                index = result.index;
                isFun = str.charAt(index) == "(";
                basestr = this.ignoreWhite(str.substring(previndex, index));
                newv = previndex == 0 ? (this.execValue(basestr, v.value)) : (new ExeValue(v.value, basestr));
                if (isFun)
                {
                    newbase = newv.value;
                    closeindex = str.indexOf(")", index);
                    paramstr = str.substring((index + 1), closeindex);
                    paramstr = this.ignoreWhite(paramstr);
                    params;
                    if (paramstr)
                    {
                        params = this.execValue(paramstr).value;
                    }
                    if (!(newbase is Function))
                    {
                        try
                        {
                            nss;
                            var _loc_3:int = 0;
                            var _loc_4:* = nss;
                            while (_loc_4 in _loc_3)
                            {
                                
                                ns = _loc_4[_loc_3];
                                nsv = v.obj[basestr];
                                if (nsv is Function)
                                {
                                    newbase = nsv;
                                    break;
                                }
                            }
                        }
                        catch (e:Error)
                        {
                        }
                        if (!(newbase is Function))
                        {
                            throw new Error(basestr + " is not a function.");
                        }
                    }
                    v.obj = (newbase as Function).apply(v.value, params);
                    v.prop = null;
                    index = (closeindex + 1);
                }
                else
                {
                    v = newv;
                }
                previndex = (index + 1);
                reg.lastIndex = index + 1;
                result = reg.exec(str);
                if (result != null)
                {
                    continue;
                }
                if ((index + 1) < str.length)
                {
                    reg.lastIndex = str.length;
                    result;
                }
            }
            return v;
        }// end function

        private function execValue(str:String, base = null) : ExeValue
        {
            var v:ExeValue;
            var vv:ExeValue;
            var key:String;
            var str:* = str;
            var base:* = base;
            v = new ExeValue();
            if (str == "true")
            {
                v.obj = true;
            }
            else if (str == "false")
            {
                v.obj = false;
            }
            else if (str == "this")
            {
                v.obj = this._scope;
            }
            else if (str == "null")
            {
                v.obj = null;
            }
            else if (!isNaN(Number(str)))
            {
                v.obj = Number(str);
            }
            else if (str.indexOf(VALKEY) == 0)
            {
                vv = this._values[str.substring(VALKEY.length)];
                v.obj = vv.value;
            }
            else if (str.charAt(0) == "$")
            {
                key = str.substring(1);
                if (this._reserved.indexOf(key) < 0)
                {
                    v.obj = this._saved;
                    v.prop = key;
                }
                else if (this._saved is WeakObject)
                {
                    v.obj = WeakObject(this._saved).get(key);
                }
                else
                {
                    v.obj = this._saved[key];
                }
            }
            else
            {
                try
                {
                    v.obj = getDefinitionByName(str);
                }
                catch (e:Error)
                {
                    v.obj = base;
                    v.prop = str;
                }
            }
            return v;
        }// end function

        private function operate(v1:ExeValue, op:String, v2:ExeValue)
        {
            switch(op)
            {
                case "=":
                {
                    return v2.value;
                }
                case "+":
                {
                    return v1.value + v2.value;
                }
                case "-":
                {
                    return v1.value - v2.value;
                }
                case "*":
                {
                    return v1.value * v2.value;
                }
                case "/":
                {
                    return v1.value / v2.value;
                }
                case "%":
                {
                    return v1.value % v2.value;
                }
                case "^":
                {
                    return v1.value ^ v2.value;
                }
                case "&":
                {
                    return v1.value & v2.value;
                }
                case ">>":
                {
                    return v1.value >> v2.value;
                }
                case ">>>":
                {
                    return v1.value >>> v2.value;
                }
                case "<<":
                {
                    return v1.value << v2.value;
                }
                case "~":
                {
                    return ~v2.value;
                }
                case "|":
                {
                    return v1.value | v2.value;
                }
                case "!":
                {
                    return !v2.value;
                }
                case ">":
                {
                    return v1.value > v2.value;
                }
                case ">=":
                {
                    return v1.value >= v2.value;
                }
                case "<":
                {
                    return v1.value < v2.value;
                }
                case "<=":
                {
                    return v1.value <= v2.value;
                }
                case "||":
                {
                    if (!v1.value)
                    {
                    }
                    return v2.value;
                }
                case "&&":
                {
                    if (v1.value)
                    {
                    }
                    return v2.value;
                }
                case "is":
                {
                    return v1.value is v2.value;
                }
                case "typeof":
                {
                    return typeof(v2.value);
                }
                case "delete":
                {
                    return delete v2.obj[v2.prop];
                }
                case "==":
                {
                    return v1.value == v2.value;
                }
                case "===":
                {
                    return v1.value === v2.value;
                }
                case "!=":
                {
                    return v1.value != v2.value;
                }
                case "!==":
                {
                    return v1.value !== v2.value;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function makeNew(str:String)
        {
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_2:* = str.indexOf("(");
            var _loc_3:* = _loc_2 > 0 ? (str.substring(0, _loc_2)) : (str);
            _loc_3 = this.ignoreWhite(_loc_3);
            var _loc_4:* = this.execValue(_loc_3).value;
            if (_loc_2 > 0)
            {
                _loc_5 = str.indexOf(")", _loc_2);
                _loc_6 = str.substring((_loc_2 + 1), _loc_5);
                _loc_6 = this.ignoreWhite(_loc_6);
                _loc_7 = [];
                if (_loc_6)
                {
                    _loc_7 = this.execValue(_loc_6).value;
                }
                _loc_8 = _loc_7.length;
                if (_loc_8 == 0)
                {
                    return new _loc_4;
                }
                if (_loc_8 == 1)
                {
                    return new _loc_4(_loc_7[0]);
                }
                if (_loc_8 == 2)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1]);
                }
                if (_loc_8 == 3)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2]);
                }
                if (_loc_8 == 4)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3]);
                }
                if (_loc_8 == 5)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4]);
                }
                if (_loc_8 == 6)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4], _loc_7[5]);
                }
                if (_loc_8 == 7)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4], _loc_7[5], _loc_7[6]);
                }
                if (_loc_8 == 8)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4], _loc_7[5], _loc_7[6], _loc_7[7]);
                }
                if (_loc_8 == 9)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4], _loc_7[5], _loc_7[6], _loc_7[7], _loc_7[8]);
                }
                if (_loc_8 == 10)
                {
                    return new _loc_4(_loc_7[0], _loc_7[1], _loc_7[2], _loc_7[3], _loc_7[4], _loc_7[5], _loc_7[6], _loc_7[7], _loc_7[8], _loc_7[9]);
                }
                throw new Error("CommandLine can\'t create new class instances with more than 10 arguments.");
            }
            return null;
        }// end function

        private function ignoreWhite(str:String) : String
        {
            str = str.replace(/\s*(.*)""\s*(.*)/, "$1");
            var _loc_2:* = str.length - 1;
            while (_loc_2 > 0)
            {
                
                if (str.charAt(_loc_2).match(/\s""\s/))
                {
                    str = str.substring(0, _loc_2);
                }
                else
                {
                    break;
                }
                _loc_2 = _loc_2 - 1;
            }
            return str;
        }// end function

        public static function Exec(scope:Object, str:String, saved:Object = null)
        {
            var _loc_4:* = new Executer;
            _loc_4.setStored(saved);
            return _loc_4.exec(scope, str);
        }// end function

    }
}
