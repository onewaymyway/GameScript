package de.polygonal.core.fmt
{

    public class NumberFormat extends Object
    {
        public static var _hexLUT:Array;

        public function NumberFormat() : void
        {
            return;
        }// end function

        public static function toBin(param1:int, param2:String = , param3:Boolean = false) : String
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_8:int = 0;
            if (param2 == null)
            {
                param2 = "";
            }
            _loc_5 = param1;
            var _loc_4:* = 32 - (_loc_5 < 0 ? (0) : (_loc_5 = _loc_5 | _loc_5 >> 1, _loc_5 = _loc_5 | _loc_5 >> 1 | _loc_5 >> 2, _loc_5 = _loc_5 | _loc_5 >> 1 | _loc_5 >> 2 | _loc_5 >> 4, _loc_5 = _loc_5 | _loc_5 >> 1 | _loc_5 >> 2 | _loc_5 >> 4 | _loc_5 >> 8, _loc_5 = _loc_5 | _loc_5 >> 1 | _loc_5 >> 2 | _loc_5 >> 4 | _loc_5 >> 8 | _loc_5 >> 16, _loc_6 = _loc_5, _loc_6 = _loc_5 - (_loc_6 >> 1 & 1431655765), _loc_6 = (_loc_6 >> 2 & 858993459) + (_loc_6 & 858993459), _loc_6 = (_loc_6 >> 4) + _loc_6 & 252645135, _loc_6 = ((_loc_6 >> 4) + _loc_6 & 252645135) + (_loc_6 >> 8), _loc_6 = ((_loc_6 >> 4) + _loc_6 & 252645135) + (_loc_6 >> 8) + (_loc_6 >> 16), 32 - (_loc_6 & 63)));
            var _loc_7:* = (param1 & 1) > 0 ? ("1") : ("0");
            param1 = param1 >> 1;
            _loc_5 = 1;
            while (_loc_5 < _loc_4)
            {
                
                _loc_5++;
                _loc_6 = _loc_5;
                _loc_7 = ((param1 & 1) > 0 ? ("1") : ("0")) + ((_loc_6 & 7) == 0 ? (param2) : ("")) + _loc_7;
                param1 = param1 >> 1;
            }
            if (param3)
            {
                _loc_5 = 0;
                _loc_6 = 32 - _loc_4;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_8 = _loc_5;
                    _loc_7 = "0" + _loc_7;
                }
            }
            return _loc_7;
        }// end function

        public static function toHex(param1:int) : String
        {
            var _loc_2:String = "";
            var _loc_3:* = NumberFormat._hexLUT;
            while (param1 != 0)
            {
                
                _loc_2 = _loc_3[param1 & 15] + _loc_2;
                param1 = param1 >>> 4;
            }
            return _loc_2;
        }// end function

        public static function toOct(param1:int) : String
        {
            var _loc_4:int = 0;
            var _loc_2:String = "";
            var _loc_3:* = param1;
            while (_loc_3 > 0)
            {
                
                _loc_4 = _loc_3 & 7;
                _loc_2 = _loc_4 + _loc_2;
                _loc_3 = _loc_3 >> 3;
            }
            return _loc_2;
        }// end function

        public static function toRadix(param1:int, param2:int) : String
        {
            var _loc_5:int = 0;
            var _loc_3:String = "";
            var _loc_4:* = param1;
            while (_loc_4 > 0)
            {
                
                _loc_5 = _loc_4 % param2;
                _loc_3 = _loc_5 + _loc_3;
                _loc_4 = _loc_4 / param2;
            }
            return _loc_3;
        }// end function

        public static function toFixed(param1:Number, param2:int) : String
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as String;
            if (Math.isNaN(param1))
            {
                return "NaN";
            }
            else
            {
                _loc_4 = 10;
                _loc_5 = param2;
                _loc_6 = 1;
                _loc_7 = 0;
                while (true)
                {
                    
                    if ((_loc_5 & 1) != 0)
                    {
                        _loc_6 = _loc_4 * _loc_6;
                    }
                    _loc_5 = _loc_5 >> 1;
                    if (_loc_5 == 0)
                    {
                        _loc_7 = _loc_6;
                        break;
                        continue;
                    }
                    _loc_4 = _loc_4 * _loc_4;
                }
                _loc_3 = _loc_7;
                _loc_8 = Std.string(param1 * _loc_3 / _loc_3);
                _loc_4 = _loc_8.indexOf(".");
                if (_loc_4 != -1)
                {
                    _loc_5 = _loc_8.substr((_loc_4 + 1)).length;
                    while (_loc_5 < param2)
                    {
                        
                        _loc_5++;
                        _loc_6 = _loc_5;
                        _loc_8 = _loc_8 + "0";
                    }
                }
                else
                {
                    _loc_8 = _loc_8 + ".";
                    _loc_5 = 0;
                    while (_loc_5 < param2)
                    {
                        
                        _loc_5++;
                        _loc_6 = _loc_5;
                        _loc_8 = _loc_8 + "0";
                    }
                }
                return _loc_8;
            }
        }// end function

        public static function toMMSS(param1:int) : String
        {
            var _loc_2:* = param1 % 1000;
            var _loc_3:* = (param1 - _loc_2) / 1000;
            var _loc_4:* = _loc_3 % 60;
            return ("0" + (_loc_3 - _loc_4) / 60).substr(-2) + ":" + ("0" + _loc_4).substr(-2);
        }// end function

        public static function groupDigits(param1:int, param2:String = ) : String
        {
            var _loc_6:* = null as String;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (param2 == null)
            {
                param2 = ".";
            }
            var _loc_3:* = param1;
            var _loc_4:int = 0;
            while (_loc_3 > 1)
            {
                
                _loc_3 = _loc_3 / 10;
                _loc_4++;
            }
            _loc_4 = _loc_4 / 3;
            var _loc_5:* = Std.string(param1);
            if (_loc_4 == 0)
            {
                return _loc_5;
            }
            else
            {
                _loc_6 = "";
                _loc_7 = 0;
                _loc_8 = _loc_5.length - 1;
                while (_loc_8 >= 0)
                {
                    
                    if (_loc_7 == 3)
                    {
                        _loc_8--;
                        _loc_6 = _loc_5.charAt(_loc_8) + param2 + _loc_6;
                        _loc_7 = 0;
                        _loc_4--;
                    }
                    else
                    {
                        _loc_8--;
                        _loc_6 = _loc_5.charAt(_loc_8) + _loc_6;
                    }
                    _loc_7++;
                }
                return _loc_6;
            }
        }// end function

        public static function centToEuro(param1:int, param2:String = , param3:String = ) : String
        {
            var _loc_5:* = null as String;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (param2 == null)
            {
                param2 = ",";
            }
            if (param3 == null)
            {
                param3 = ".";
            }
            var _loc_4:* = param1 / 100;
            if (param1 / 100 == 0)
            {
                if (param1 < 10)
                {
                    return "0" + param2 + "0" + param1;
                }
                else
                {
                    return "0" + param2 + param1;
                }
            }
            else
            {
                _loc_6 = param1 - _loc_4 * 100;
                if (_loc_6 < 10)
                {
                    _loc_5 = param2 + "0" + _loc_6;
                }
                else
                {
                    _loc_5 = param2 + _loc_6;
                }
                if (_loc_4 >= 1000)
                {
                    _loc_7 = _loc_4;
                    while (_loc_7 >= 1000)
                    {
                        
                        _loc_7 = _loc_4 / 1000;
                        _loc_8 = _loc_4 - _loc_7 * 1000;
                        if (_loc_8 < 10)
                        {
                            _loc_5 = param3 + "00" + _loc_8 + _loc_5;
                        }
                        else if (_loc_8 < 100)
                        {
                            _loc_5 = param3 + "0" + _loc_8 + _loc_5;
                        }
                        else
                        {
                            _loc_5 = param3 + _loc_8 + _loc_5;
                        }
                        _loc_4 = _loc_7;
                    }
                    _loc_5 = _loc_7 + _loc_5;
                    return _loc_5;
                }
                else
                {
                    _loc_5 = _loc_4 + _loc_5;
                }
                return _loc_5;
            }
        }// end function

    }
}
