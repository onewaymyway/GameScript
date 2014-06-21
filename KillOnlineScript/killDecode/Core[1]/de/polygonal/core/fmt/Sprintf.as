package de.polygonal.core.fmt
{
    import flash.*;

    public class Sprintf extends Object
    {
        public var _bits:Array;
        public static var BIT_MINUS:int;
        public static var BIT_PLUS:int;
        public static var BIT_SPACE:int;
        public static var BIT_SHARP:int;
        public static var BIT_ZERO:int;
        public static var BIT_h:int;
        public static var BIT_l:int;
        public static var BIT_L:int;
        public static var BIT_c:int;
        public static var BIT_d:int;
        public static var BIT_i:int;
        public static var BIT_e:int;
        public static var BIT_E:int;
        public static var BIT_f:int;
        public static var BIT_g:int;
        public static var BIT_G:int;
        public static var BIT_o:int;
        public static var BIT_s:int;
        public static var BIT_u:int;
        public static var BIT_x:int;
        public static var BIT_X:int;
        public static var BIT_p:int;
        public static var BIT_n:int;
        public static var BIT_b:int;
        public static var MASK_SPECIFIERS:int;
        public static var _I:Sprintf;

        public function Sprintf() : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (Boot.skip_constructor)
            {
                return;
            }
            _bits = [];
            var _loc_1:String = "-+ #0hlLcdieEfgGosuxXpnb";
            var _loc_2:int = 0;
            while (_loc_2 < 255)
            {
                
                _loc_2++;
                _loc_3 = _loc_2;
                _bits[_loc_3] = 0;
            }
            _loc_2 = 0;
            _loc_3 = _loc_1.length;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _bits[_loc_1.charCodeAt(_loc_4)] = 1 << _loc_4;
            }
            return;
        }// end function

        public function cca(param1:String, param2:int) : int
        {
            return param1.charCodeAt(param2);
        }// end function

        public function _rpad(param1:String, param2:String, param3:int) : String
        {
            var _loc_7:int = 0;
            var _loc_4:* = param2;
            var _loc_5:int = 0;
            var _loc_6:* = param3 - 1;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                _loc_4 = _loc_4 + param2;
            }
            return param1 + _loc_4;
        }// end function

        public function _padNumber(param1:String, param2:Number, param3:int, param4:int) : String
        {
            var _loc_6:* = null as String;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:* = null as String;
            var _loc_5:* = param1.length;
            if (param4 > 0)
            {
            }
            if (_loc_5 < param4)
            {
                param4 = param4 - _loc_5;
                if ((param3 & 1) != 0)
                {
                    _loc_6 = " ";
                    _loc_7 = 0;
                    _loc_8 = param4 - 1;
                    while (_loc_7 < _loc_8)
                    {
                        
                        _loc_7++;
                        _loc_9 = _loc_7;
                        _loc_6 = _loc_6 + " ";
                    }
                    param1 = param1 + _loc_6;
                }
                else if (param2 >= 0)
                {
                    _loc_6 = (param3 & 16) != 0 ? ("0") : (" ");
                    _loc_10 = _loc_6;
                    _loc_7 = 0;
                    _loc_8 = param4 - 1;
                    while (_loc_7 < _loc_8)
                    {
                        
                        _loc_7++;
                        _loc_9 = _loc_7;
                        _loc_10 = _loc_10 + _loc_6;
                    }
                    param1 = _loc_10 + param1;
                }
                else if ((param3 & 16) != 0)
                {
                    _loc_6 = "0";
                    _loc_7 = 0;
                    _loc_8 = param4 - 1;
                    while (_loc_7 < _loc_8)
                    {
                        
                        _loc_7++;
                        _loc_9 = _loc_7;
                        _loc_6 = _loc_6 + "0";
                    }
                    param1 = "-" + (_loc_6 + param1.substr(1));
                }
                else
                {
                    _loc_6 = " ";
                    _loc_7 = 0;
                    _loc_8 = param4 - 1;
                    while (_loc_7 < _loc_8)
                    {
                        
                        _loc_7++;
                        _loc_9 = _loc_7;
                        _loc_6 = _loc_6 + " ";
                    }
                    param1 = _loc_6 + param1;
                }
            }
            return param1;
        }// end function

        public function _lpad(param1:String, param2:String, param3:int) : String
        {
            var _loc_7:int = 0;
            var _loc_4:* = param2;
            var _loc_5:int = 0;
            var _loc_6:* = param3 - 1;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                _loc_4 = _loc_4 + param2;
            }
            return _loc_4 + param1;
        }// end function

        public function _format(param1:String, param2:Array) : String
        {
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Boolean = false;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:* = null as String;
            var _loc_13:int = 0;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_17:* = null as String;
            var _loc_18:int = 0;
            var _loc_19:int = 0;
            var _loc_20:* = null as String;
            var _loc_21:int = 0;
            var _loc_22:int = 0;
            var _loc_23:int = 0;
            var _loc_24:* = null as String;
            var _loc_25:int = 0;
            var _loc_3:int = 0;
            var _loc_4:String = "";
            var _loc_5:int = 0;
            var _loc_6:* = param1.length;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = param1.charCodeAt(_loc_5);
                if (_loc_7 == 37)
                {
                    _loc_5++;
                    _loc_7 = param1.charCodeAt(_loc_5);
                    if (_loc_7 == 37)
                    {
                        _loc_4 = _loc_4 + "%";
                    }
                    else
                    {
                        _loc_8 = 0;
                        while ((_bits[_loc_7] & 31) != 0)
                        {
                            
                            _loc_8 = _loc_8 | _bits[_loc_7];
                            _loc_5++;
                            _loc_7 = param1.charCodeAt(_loc_5);
                        }
                        if ((_loc_8 & 17) == 17)
                        {
                            _loc_8 = _loc_8 & -17;
                        }
                        if ((_loc_8 & 6) == 6)
                        {
                            _loc_8 = _loc_8 & -5;
                        }
                        _loc_9 = false;
                        _loc_10 = 0;
                        if (_loc_7 == 42)
                        {
                            _loc_9 = true;
                            _loc_5++;
                            _loc_7 = param1.charCodeAt(_loc_5);
                        }
                        else
                        {
                            if (_loc_7 >= 48)
                            {
                            }
                            if (_loc_7 <= 57)
                            {
                                _loc_10 = _loc_7 - 48;
                                _loc_5++;
                                _loc_7 = param1.charCodeAt(_loc_5);
                                if (_loc_7 >= 48)
                                {
                                }
                                if (_loc_7 <= 57)
                                {
                                    _loc_10 = _loc_7 - 48 + _loc_10 * 10;
                                    _loc_5++;
                                    _loc_7 = param1.charCodeAt(_loc_5);
                                    if (_loc_7 >= 48)
                                    {
                                    }
                                    if (_loc_7 <= 57)
                                    {
                                        do
                                        {
                                            
                                            _loc_5++;
                                            _loc_7 = param1.charCodeAt(_loc_5);
                                            if (_loc_7 >= 48)
                                            {
                                            }
                                        }while (_loc_7 <= 57)
                                    }
                                }
                            }
                        }
                        _loc_11 = -1;
                        if (_loc_7 == 46)
                        {
                            _loc_5++;
                            _loc_7 = param1.charCodeAt(_loc_5);
                            if (_loc_7 == 42)
                            {
                                _loc_3++;
                                _loc_11 = param2[_loc_3];
                                _loc_5++;
                                _loc_7 = param1.charCodeAt(_loc_5);
                            }
                            else
                            {
                                if (_loc_7 >= 48)
                                {
                                }
                                if (_loc_7 <= 57)
                                {
                                    _loc_11 = _loc_7 - 48;
                                    _loc_5++;
                                    _loc_7 = param1.charCodeAt(_loc_5);
                                    if (_loc_7 >= 48)
                                    {
                                    }
                                    if (_loc_7 <= 57)
                                    {
                                        _loc_11 = _loc_7 - 48 + _loc_11 * 10;
                                        _loc_5++;
                                        _loc_7 = param1.charCodeAt(_loc_5);
                                        if (_loc_7 >= 48)
                                        {
                                        }
                                        if (_loc_7 <= 57)
                                        {
                                            do
                                            {
                                                
                                                _loc_5++;
                                                _loc_7 = param1.charCodeAt(_loc_5);
                                                if (_loc_7 >= 48)
                                                {
                                                }
                                            }while (_loc_7 <= 57)
                                        }
                                    }
                                }
                                else
                                {
                                    _loc_11 = 0;
                                }
                            }
                        }
                        while ((_bits[_loc_7] & 224) != 0)
                        {
                            
                            _loc_8 = _loc_8 | _bits[_loc_7];
                            _loc_5++;
                            _loc_7 = param1.charCodeAt(_loc_5);
                        }
                        _loc_12 = "";
                        if (_loc_9)
                        {
                            _loc_3++;
                            _loc_10 = param2[_loc_3];
                        }
                        _loc_13 = _bits[_loc_7];
                        if ((_loc_13 & 16776960) != 0)
                        {
                            if ((_loc_13 & 8192) != 0)
                            {
                                if (_loc_11 == -1)
                                {
                                    _loc_11 = 6;
                                }
                                _loc_3++;
                                _loc_14 = param2[_loc_3];
                                if (_loc_11 == 0)
                                {
                                    _loc_12 = Std.string(_loc_14 > 0 ? (_loc_14 + 0.5) : (_loc_14 < 0 ? (_loc_14 - 0.5) : (0)));
                                    if ((_loc_8 & 8) != 0)
                                    {
                                        _loc_12 = _loc_12 + ".";
                                    }
                                }
                                else
                                {
                                    _loc_15 = Math.pow(0.1, _loc_11);
                                    _loc_16 = _loc_14 / _loc_15;
                                    _loc_14 = (_loc_16 > 0 ? (_loc_16 + 0.5) : (_loc_16 < 0 ? (_loc_16 - 0.5) : (0))) * _loc_15;
                                    _loc_12 = NumberFormat.toFixed(_loc_14, _loc_11);
                                }
                                if ((_loc_8 & 2) != 0)
                                {
                                }
                                if (_loc_14 >= 0)
                                {
                                    _loc_12 = "+" + _loc_12;
                                }
                                else
                                {
                                    if ((_loc_8 & 4) != 0)
                                    {
                                    }
                                    if (_loc_14 >= 0)
                                    {
                                        _loc_12 = " " + _loc_12;
                                    }
                                }
                                _loc_17 = _loc_12;
                                _loc_18 = _loc_10;
                                _loc_19 = _loc_17.length;
                                if (_loc_18 > 0)
                                {
                                }
                                if (_loc_19 < _loc_18)
                                {
                                    _loc_18 = _loc_18 - _loc_19;
                                    if ((_loc_8 & 1) != 0)
                                    {
                                        _loc_20 = " ";
                                        _loc_21 = 0;
                                        _loc_22 = _loc_18 - 1;
                                        while (_loc_21 < _loc_22)
                                        {
                                            
                                            _loc_21++;
                                            _loc_23 = _loc_21;
                                            _loc_20 = _loc_20 + " ";
                                        }
                                        _loc_17 = _loc_17 + _loc_20;
                                    }
                                    else if (_loc_14 >= 0)
                                    {
                                        _loc_20 = (_loc_8 & 16) != 0 ? ("0") : (" ");
                                        _loc_24 = _loc_20;
                                        _loc_21 = 0;
                                        _loc_22 = _loc_18 - 1;
                                        while (_loc_21 < _loc_22)
                                        {
                                            
                                            _loc_21++;
                                            _loc_23 = _loc_21;
                                            _loc_24 = _loc_24 + _loc_20;
                                        }
                                        _loc_17 = _loc_24 + _loc_17;
                                    }
                                    else if ((_loc_8 & 16) != 0)
                                    {
                                        _loc_20 = "0";
                                        _loc_21 = 0;
                                        _loc_22 = _loc_18 - 1;
                                        while (_loc_21 < _loc_22)
                                        {
                                            
                                            _loc_21++;
                                            _loc_23 = _loc_21;
                                            _loc_20 = _loc_20 + "0";
                                        }
                                        _loc_17 = "-" + (_loc_20 + _loc_17.substr(1));
                                    }
                                    else
                                    {
                                        _loc_20 = " ";
                                        _loc_21 = 0;
                                        _loc_22 = _loc_18 - 1;
                                        while (_loc_21 < _loc_22)
                                        {
                                            
                                            _loc_21++;
                                            _loc_23 = _loc_21;
                                            _loc_20 = _loc_20 + " ";
                                        }
                                        _loc_17 = _loc_20 + _loc_17;
                                    }
                                }
                                _loc_4 = _loc_4 + _loc_17;
                            }
                            else if ((_loc_13 & 131328) != 0)
                            {
                                if ((_loc_8 & 2) != 0)
                                {
                                    _loc_8 = _loc_8 & -3;
                                }
                                if ((_loc_8 & 4) != 0)
                                {
                                    _loc_8 = _loc_8 & -5;
                                }
                                else if ((_loc_8 & 16) != 0)
                                {
                                    _loc_8 = _loc_8 & -17;
                                }
                                else if ((_loc_8 & 8) != 0)
                                {
                                    _loc_8 = _loc_8 & -9;
                                }
                                if (_loc_13 == 131072)
                                {
                                    _loc_3++;
                                    _loc_12 = Std.string(param2[_loc_3]);
                                    if (_loc_11 > 0)
                                    {
                                        _loc_12 = _loc_12.substr(0, _loc_11);
                                    }
                                }
                                else
                                {
                                    _loc_3++;
                                    _loc_12 = String.fromCharCode(param2[_loc_3]);
                                }
                                _loc_18 = _loc_12.length;
                                if (_loc_10 > 0)
                                {
                                }
                                if (_loc_18 < _loc_10)
                                {
                                    _loc_10 = _loc_10 - _loc_18;
                                    if ((_loc_8 & 1) != 0)
                                    {
                                        _loc_17 = " ";
                                        _loc_19 = 0;
                                        _loc_21 = _loc_10 - 1;
                                        while (_loc_19 < _loc_21)
                                        {
                                            
                                            _loc_19++;
                                            _loc_22 = _loc_19;
                                            _loc_17 = _loc_17 + " ";
                                        }
                                        _loc_12 = _loc_12 + _loc_17;
                                    }
                                    else
                                    {
                                        _loc_17 = " ";
                                        _loc_19 = 0;
                                        _loc_21 = _loc_10 - 1;
                                        while (_loc_19 < _loc_21)
                                        {
                                            
                                            _loc_19++;
                                            _loc_22 = _loc_19;
                                            _loc_17 = _loc_17 + " ";
                                        }
                                        _loc_12 = _loc_17 + _loc_12;
                                    }
                                }
                                _loc_4 = _loc_4 + _loc_12;
                            }
                            else if ((_loc_13 & 10290688) != 0)
                            {
                                if (_loc_11 == -1)
                                {
                                    _loc_11 = 1;
                                }
                                _loc_3++;
                                _loc_18 = param2[_loc_3];
                                if (_loc_11 == 0)
                                {
                                }
                                if (_loc_18 == 0)
                                {
                                    _loc_12 = "";
                                }
                                else
                                {
                                    if ((_loc_13 & 32) != 0)
                                    {
                                        _loc_18 = _loc_18 & 65535;
                                    }
                                    else if ((_loc_13 & 65536) != 0)
                                    {
                                        _loc_12 = NumberFormat.toOct(_loc_18);
                                        if ((_loc_8 & 8) != 0)
                                        {
                                            _loc_12 = "0" + _loc_12;
                                        }
                                    }
                                    else if ((_loc_13 & 524288) != 0)
                                    {
                                        _loc_12 = NumberFormat.toHex(_loc_18).toLowerCase();
                                        if ((_loc_8 & 8) != 0)
                                        {
                                        }
                                        if (_loc_18 != 0)
                                        {
                                            _loc_12 = "0x" + _loc_12;
                                        }
                                    }
                                    else if ((_loc_13 & 1048576) != 0)
                                    {
                                        _loc_12 = NumberFormat.toHex(_loc_18).toUpperCase();
                                        if ((_loc_8 & 8) != 0)
                                        {
                                        }
                                        if (_loc_18 != 0)
                                        {
                                            _loc_12 = "0X" + _loc_12;
                                        }
                                    }
                                    else if ((_loc_13 & 8388608) != 0)
                                    {
                                        _loc_12 = NumberFormat.toBin(_loc_18);
                                        if (_loc_11 > 1)
                                        {
                                            if (_loc_12.length < _loc_11)
                                            {
                                                _loc_11 = _loc_11 - _loc_12.length;
                                                _loc_19 = 0;
                                                while (_loc_19 < _loc_11)
                                                {
                                                    
                                                    _loc_19++;
                                                    _loc_21 = _loc_19;
                                                    _loc_12 = "0" + _loc_12;
                                                }
                                            }
                                            _loc_11 = 0;
                                        }
                                        if ((_loc_8 & 8) != 0)
                                        {
                                            _loc_12 = "b" + _loc_12;
                                        }
                                    }
                                    else
                                    {
                                        _loc_12 = Std.string(_loc_18);
                                    }
                                    if (_loc_11 > 1)
                                    {
                                    }
                                    if (_loc_12.length < _loc_11)
                                    {
                                        if (_loc_18 > 0)
                                        {
                                            _loc_19 = 0;
                                            _loc_21 = _loc_11 - 1;
                                            while (_loc_19 < _loc_21)
                                            {
                                                
                                                _loc_19++;
                                                _loc_22 = _loc_19;
                                                _loc_12 = "0" + _loc_12;
                                            }
                                        }
                                        else
                                        {
                                            _loc_12 = "0" + (-_loc_18);
                                            _loc_19 = 0;
                                            _loc_21 = _loc_11 - 2;
                                            while (_loc_19 < _loc_21)
                                            {
                                                
                                                _loc_19++;
                                                _loc_22 = _loc_19;
                                                _loc_12 = "0" + _loc_12;
                                            }
                                            _loc_12 = "-" + _loc_12;
                                        }
                                    }
                                }
                                if (_loc_18 >= 0)
                                {
                                    if ((_loc_8 & 2) != 0)
                                    {
                                        _loc_12 = "+" + _loc_12;
                                    }
                                    else if ((_loc_8 & 4) != 0)
                                    {
                                        _loc_12 = " " + _loc_12;
                                    }
                                }
                                _loc_17 = _loc_12;
                                _loc_19 = _loc_10;
                                _loc_21 = _loc_17.length;
                                if (_loc_19 > 0)
                                {
                                }
                                if (_loc_21 < _loc_19)
                                {
                                    _loc_19 = _loc_19 - _loc_21;
                                    if ((_loc_8 & 1) != 0)
                                    {
                                        _loc_20 = " ";
                                        _loc_22 = 0;
                                        _loc_23 = _loc_19 - 1;
                                        while (_loc_22 < _loc_23)
                                        {
                                            
                                            _loc_22++;
                                            _loc_25 = _loc_22;
                                            _loc_20 = _loc_20 + " ";
                                        }
                                        _loc_17 = _loc_17 + _loc_20;
                                    }
                                    else if (_loc_18 >= 0)
                                    {
                                        _loc_20 = (_loc_8 & 16) != 0 ? ("0") : (" ");
                                        _loc_24 = _loc_20;
                                        _loc_22 = 0;
                                        _loc_23 = _loc_19 - 1;
                                        while (_loc_22 < _loc_23)
                                        {
                                            
                                            _loc_22++;
                                            _loc_25 = _loc_22;
                                            _loc_24 = _loc_24 + _loc_20;
                                        }
                                        _loc_17 = _loc_24 + _loc_17;
                                    }
                                    else if ((_loc_8 & 16) != 0)
                                    {
                                        _loc_20 = "0";
                                        _loc_22 = 0;
                                        _loc_23 = _loc_19 - 1;
                                        while (_loc_22 < _loc_23)
                                        {
                                            
                                            _loc_22++;
                                            _loc_25 = _loc_22;
                                            _loc_20 = _loc_20 + "0";
                                        }
                                        _loc_17 = "-" + (_loc_20 + _loc_17.substr(1));
                                    }
                                    else
                                    {
                                        _loc_20 = " ";
                                        _loc_22 = 0;
                                        _loc_23 = _loc_19 - 1;
                                        while (_loc_22 < _loc_23)
                                        {
                                            
                                            _loc_22++;
                                            _loc_25 = _loc_22;
                                            _loc_20 = _loc_20 + " ";
                                        }
                                        _loc_17 = _loc_20 + _loc_17;
                                    }
                                }
                                _loc_4 = _loc_4 + _loc_17;
                            }
                            else if ((_loc_13 & 6144) != 0)
                            {
                                if (_loc_11 == -1)
                                {
                                    _loc_11 = 6;
                                }
                                _loc_3++;
                                _loc_14 = param2[_loc_3];
                                _loc_18 = _loc_14 > 0 ? (1) : (_loc_14 < 0 ? (-1) : (0));
                                _loc_14 = _loc_14 < 0 ? (-_loc_14) : (_loc_14);
                                _loc_19 = 0;
                                if (_loc_14 > 1)
                                {
                                    while (_loc_14 > 10)
                                    {
                                        
                                        _loc_14 = _loc_14 / 10;
                                        _loc_19++;
                                    }
                                }
                                else
                                {
                                    while (_loc_14 < 1)
                                    {
                                        
                                        _loc_14 = _loc_14 * 10;
                                        _loc_19--;
                                    }
                                }
                                _loc_15 = 0.1;
                                _loc_21 = 0;
                                _loc_22 = _loc_11 - 1;
                                while (_loc_21 < _loc_22)
                                {
                                    
                                    _loc_21++;
                                    _loc_23 = _loc_21;
                                    _loc_15 = _loc_15 * 0.1;
                                }
                                _loc_16 = _loc_14 / _loc_15;
                                _loc_14 = (_loc_16 > 0 ? (_loc_16 + 0.5) : (_loc_16 < 0 ? (_loc_16 - 0.5) : (0))) * _loc_15;
                                _loc_12 = _loc_12 + ((_loc_18 < 0 ? ("-") : ((_loc_8 & 2) != 0 ? ("+") : (""))) + Std.string(_loc_14).substr(0, _loc_11 + 2));
                                _loc_12 = _loc_12 + ((_loc_13 & 2048) != 0 ? ("e") : ("E"));
                                _loc_12 = _loc_12 + (_loc_19 > 0 ? ("+") : ("-"));
                                if (_loc_19 < 10)
                                {
                                    _loc_17 = "0";
                                    _loc_21 = 0;
                                    _loc_22 = 1;
                                    while (_loc_21 < _loc_22)
                                    {
                                        
                                        _loc_21++;
                                        _loc_23 = _loc_21;
                                        _loc_17 = _loc_17 + "0";
                                    }
                                    _loc_12 = _loc_12 + _loc_17;
                                }
                                else if (_loc_19 < 100)
                                {
                                    _loc_17 = "0";
                                    _loc_21 = 0;
                                    _loc_22 = 0;
                                    while (_loc_21 < _loc_22)
                                    {
                                        
                                        _loc_21++;
                                        _loc_23 = _loc_21;
                                        _loc_17 = _loc_17 + "0";
                                    }
                                    _loc_12 = _loc_12 + _loc_17;
                                }
                                _loc_12 = _loc_12 + Std.string(_loc_19 < 0 ? (-_loc_19) : (_loc_19));
                                _loc_4 = _loc_4 + _loc_12;
                            }
                            else if ((_loc_13 & 49152) != 0)
                            {
                                _loc_11 = 0;
                                _loc_17 = "";
                                if ((_loc_8 & 1) != 0)
                                {
                                    _loc_17 = _loc_17 + "-";
                                }
                                if ((_loc_8 & 2) != 0)
                                {
                                    _loc_17 = _loc_17 + "+";
                                }
                                if ((_loc_8 & 4) != 0)
                                {
                                    _loc_17 = _loc_17 + " ";
                                }
                                if ((_loc_8 & 16) != 0)
                                {
                                    _loc_17 = _loc_17 + "0";
                                }
                                _loc_3++;
                                _loc_14 = param2[_loc_3];
                                _loc_20 = _format("%" + _loc_17 + "." + _loc_11 + "f", [_loc_14]);
                                _loc_24 = _format("%" + _loc_17 + "." + _loc_11 + (_loc_7 == 71 ? ("E") : ("e")), [_loc_14]);
                                if ((_loc_8 & 8) != 0)
                                {
                                    if (_loc_20.indexOf(".") != -1)
                                    {
                                        _loc_18 = _loc_20.length - 1;
                                        while (_loc_20.charCodeAt(_loc_18) == 48)
                                        {
                                            
                                            _loc_18--;
                                        }
                                        _loc_20 = _loc_20.substr(0, _loc_18);
                                    }
                                }
                                _loc_4 = _loc_4 + (_loc_20.length < _loc_24.length ? (_loc_20) : (_loc_24));
                            }
                            else if ((_loc_13 & 6291456) != 0)
                            {
                                Boot.lastError = new Error();
                                throw "warning: specifier \'p\' and \'n\' are not supported";
                            }
                        }
                        else
                        {
                            Boot.lastError = new Error();
                            throw "malformed format string: no specifier found";
                        }
                    }
                    continue;
                }
                _loc_4 = _loc_4 + param1.charAt((_loc_5 - 1));
            }
            return _loc_4;
        }// end function

        public static function get() : Sprintf
        {
            if (Sprintf._I == null)
            {
                Sprintf._I = new Sprintf();
            }
            return Sprintf._I;
        }// end function

        public static function format(param1:String, param2:Array) : String
        {
            if (Sprintf._I == null)
            {
                Sprintf._I = new Sprintf();
            }
            return Sprintf._I._format(param1, param2);
        }// end function

    }
}
