package mx.utils
{

    public class StringUtil extends Object
    {
        static const VERSION:String = "4.5.1.21328";

        public function StringUtil()
        {
            return;
        }// end function

        public static function trim(str:String) : String
        {
            if (str == null)
            {
                return "";
            }
            var _loc_2:int = 0;
            while (isWhitespace(str.charAt(_loc_2)))
            {
                
                _loc_2 = _loc_2 + 1;
            }
            var _loc_3:* = str.length - 1;
            while (isWhitespace(str.charAt(_loc_3)))
            {
                
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 >= _loc_2)
            {
                return str.slice(_loc_2, (_loc_3 + 1));
            }
            return "";
        }// end function

        public static function trimArrayElements(value:String, delimiter:String) : String
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (value != "")
            {
            }
            if (value != null)
            {
                _loc_3 = value.split(delimiter);
                _loc_4 = _loc_3.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_3[_loc_5] = StringUtil.trim(_loc_3[_loc_5]);
                    _loc_5 = _loc_5 + 1;
                }
                if (_loc_4 > 0)
                {
                    value = _loc_3.join(delimiter);
                }
            }
            return value;
        }// end function

        public static function isWhitespace(character:String) : Boolean
        {
            switch(character)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }// end function

        public static function substitute(str:String, ... args) : String
        {
            var _loc_4:Array = null;
            if (str == null)
            {
                return "";
            }
            args = args.length;
            if (args == 1)
            {
            }
            if (args[0] is Array)
            {
                _loc_4 = args[0] as Array;
                args = _loc_4.length;
            }
            else
            {
                _loc_4 = args;
            }
            var _loc_5:int = 0;
            while (_loc_5 < args)
            {
                
                str = str.replace(new RegExp("\\{" + _loc_5 + "\\}", "g"), _loc_4[_loc_5]);
                _loc_5 = _loc_5 + 1;
            }
            return str;
        }// end function

        public static function repeat(str:String, n:int) : String
        {
            if (n == 0)
            {
                return "";
            }
            var _loc_3:* = str;
            var _loc_4:int = 1;
            while (_loc_4 < n)
            {
                
                _loc_3 = _loc_3 + str;
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public static function restrict(str:String, restrict:String) : String
        {
            var _loc_6:uint = 0;
            if (restrict == null)
            {
                return str;
            }
            if (restrict == "")
            {
                return "";
            }
            var _loc_3:Array = [];
            var _loc_4:* = str.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = str.charCodeAt(_loc_5);
                if (testCharacter(_loc_6, restrict))
                {
                    _loc_3.push(_loc_6);
                }
                _loc_5 = _loc_5 + 1;
            }
            return String.fromCharCode.apply(null, _loc_3);
        }// end function

        private static function testCharacter(charCode:uint, restrict:String) : Boolean
        {
            var _loc_9:uint = 0;
            var _loc_11:Boolean = false;
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            var _loc_6:Boolean = true;
            var _loc_7:uint = 0;
            var _loc_8:* = restrict.length;
            if (_loc_8 > 0)
            {
                _loc_9 = restrict.charCodeAt(0);
                if (_loc_9 == 94)
                {
                    _loc_3 = true;
                }
            }
            var _loc_10:int = 0;
            while (_loc_10 < _loc_8)
            {
                
                _loc_9 = restrict.charCodeAt(_loc_10);
                _loc_11 = false;
                if (!_loc_4)
                {
                    if (_loc_9 == 45)
                    {
                        _loc_5 = true;
                    }
                    else if (_loc_9 == 94)
                    {
                        _loc_6 = !_loc_6;
                    }
                    else if (_loc_9 == 92)
                    {
                        _loc_4 = true;
                    }
                    else
                    {
                        _loc_11 = true;
                    }
                }
                else
                {
                    _loc_11 = true;
                    _loc_4 = false;
                }
                if (_loc_11)
                {
                    if (_loc_5)
                    {
                        if (_loc_7 <= charCode)
                        {
                        }
                        if (charCode <= _loc_9)
                        {
                            _loc_3 = _loc_6;
                        }
                        _loc_5 = false;
                        _loc_7 = 0;
                    }
                    else
                    {
                        if (charCode == _loc_9)
                        {
                            _loc_3 = _loc_6;
                        }
                        _loc_7 = _loc_9;
                    }
                }
                _loc_10 = _loc_10 + 1;
            }
            return _loc_3;
        }// end function

    }
}
