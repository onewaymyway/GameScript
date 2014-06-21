package com.google.analytics.core
{

    public class Utils extends Object
    {

        public function Utils()
        {
            return;
        }// end function

        public static function generate32bitRandom() : int
        {
            return Math.round(Math.random() * 2147483647);
        }// end function

        public static function generateHash(input:String) : int
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_2:int = 1;
            var _loc_3:int = 0;
            if (input != null)
            {
            }
            if (input != "")
            {
                _loc_2 = 0;
                _loc_4 = input.length - 1;
                while (_loc_4 >= 0)
                {
                    
                    _loc_5 = input.charCodeAt(_loc_4);
                    _loc_2 = (_loc_2 << 6 & 268435455) + _loc_5 + (_loc_5 << 14);
                    _loc_3 = _loc_2 & 266338304;
                    if (_loc_3 != 0)
                    {
                        _loc_2 = _loc_2 ^ _loc_3 >> 21;
                    }
                    _loc_4 = _loc_4 - 1;
                }
            }
            return _loc_2;
        }// end function

        public static function trim(raw:String, everything:Boolean = false) : String
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (raw == "")
            {
                return "";
            }
            var _loc_3:Array = [" ", "\n", "\r", "\t"];
            var _loc_4:* = raw;
            if (everything)
            {
                _loc_5 = 0;
                do
                {
                    
                    _loc_4 = _loc_4.split(_loc_3[_loc_5]).join("");
                    _loc_5 = _loc_5 + 1;
                    if (_loc_5 < _loc_3.length)
                    {
                    }
                }while (_loc_4.indexOf(_loc_3[_loc_5]) > -1)
            }
            else
            {
                _loc_6 = 0;
                do
                {
                    
                    _loc_6 = _loc_6 + 1;
                    if (_loc_6 < _loc_4.length)
                    {
                    }
                }while (_loc_3.indexOf(_loc_4.charAt(_loc_6)) > -1)
                _loc_4 = _loc_4.substr(_loc_6);
                _loc_7 = _loc_4.length - 1;
                do
                {
                    
                    _loc_7 = _loc_7 - 1;
                    if (_loc_7 >= 0)
                    {
                    }
                }while (_loc_3.indexOf(_loc_4.charAt(_loc_7)) > -1)
                _loc_4 = _loc_4.substring(0, (_loc_7 + 1));
            }
            return _loc_4;
        }// end function

        public static function validateAccount(account:String) : Boolean
        {
            var _loc_2:* = /^UA-[0-9]*-[0-9]*$""^UA-[0-9]*-[0-9]*$/;
            return _loc_2.test(account);
        }// end function

    }
}
