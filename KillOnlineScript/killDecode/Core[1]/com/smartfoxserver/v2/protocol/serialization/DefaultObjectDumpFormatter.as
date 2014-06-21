package com.smartfoxserver.v2.protocol.serialization
{
    import com.smartfoxserver.v2.exceptions.*;
    import flash.utils.*;

    public class DefaultObjectDumpFormatter extends Object
    {
        public static const TOKEN_INDENT_OPEN:String = "{";
        public static const TOKEN_INDENT_CLOSE:String = "}";
        public static const TOKEN_DIVIDER:String = ";";
        public static const NEW_LINE:String = "\n";
        public static const TAB:String = "\t";
        public static const DOT:String = ".";
        public static const HEX_BYTES_PER_LINE:int = 16;

        public function DefaultObjectDumpFormatter()
        {
            return;
        }// end function

        public static function prettyPrintByteArray(param1:ByteArray) : String
        {
            if (param1 == null)
            {
                return "Null";
            }
            return "Byte[" + param1.length + "]";
        }// end function

        public static function prettyPrintDump(param1:String) : String
        {
            var _loc_6:String = null;
            var _loc_2:String = "";
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:int = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_6 = param1.charAt(_loc_5);
                if (_loc_6 == TOKEN_INDENT_OPEN)
                {
                    _loc_3++;
                    _loc_2 = _loc_2 + (NEW_LINE + getFormatTabs(_loc_3));
                }
                else if (_loc_6 == TOKEN_INDENT_CLOSE)
                {
                    _loc_3 = _loc_3 - 1;
                    if (_loc_3 < 0)
                    {
                        throw new SFSError("DumpFormatter: the indentPos is negative. TOKENS ARE NOT BALANCED!");
                    }
                    _loc_2 = _loc_2 + (NEW_LINE + getFormatTabs(_loc_3));
                }
                else if (_loc_6 == TOKEN_DIVIDER)
                {
                    _loc_2 = _loc_2 + (NEW_LINE + getFormatTabs(_loc_3));
                }
                else
                {
                    _loc_2 = _loc_2 + _loc_6;
                }
                _loc_5++;
            }
            if (_loc_3 != 0)
            {
                throw new SFSError("DumpFormatter: the indentPos is not == 0. TOKENS ARE NOT BALANCED!");
            }
            return _loc_2;
        }// end function

        private static function getFormatTabs(param1:int) : String
        {
            return strFill(TAB, param1);
        }// end function

        private static function strFill(param1:String, param2:int) : String
        {
            var _loc_3:String = "";
            var _loc_4:int = 0;
            while (_loc_4 < param2)
            {
                
                _loc_3 = _loc_3 + param1;
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function hexDump(param1:ByteArray, param2:int = -1) : String
        {
            var _loc_9:String = null;
            var _loc_10:int = 0;
            var _loc_11:String = null;
            var _loc_12:int = 0;
            var _loc_3:* = param1.position;
            param1.position = 0;
            if (param2 == -1)
            {
                param2 = HEX_BYTES_PER_LINE;
            }
            var _loc_4:* = "Binary Size: " + param1.length + NEW_LINE;
            var _loc_5:String = "";
            var _loc_6:String = "";
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            do
            {
                
                _loc_10 = param1.readByte() & 255;
                _loc_11 = _loc_10.toString(16).toUpperCase();
                if (_loc_11.length == 1)
                {
                    _loc_11 = "0" + _loc_11;
                }
                _loc_5 = _loc_5 + (_loc_11 + " ");
                if (_loc_10 >= 33 && _loc_10 <= 126)
                {
                    _loc_9 = String.fromCharCode(_loc_10);
                }
                else
                {
                    _loc_9 = DOT;
                }
                _loc_6 = _loc_6 + _loc_9;
                if (++_loc_8 == param2)
                {
                    ++_loc_8 = 0;
                    _loc_4 = _loc_4 + (_loc_5 + TAB + _loc_6 + NEW_LINE);
                    _loc_5 = "";
                    _loc_6 = "";
                }
            }while (++_loc_7 < param1.length)
            if (++_loc_8 != 0)
            {
                _loc_12 = param2 - _loc_8;
                while (_loc_12 > 0)
                {
                    
                    _loc_5 = _loc_5 + "   ";
                    _loc_6 = _loc_6 + " ";
                    _loc_12 = _loc_12 - 1;
                }
                _loc_4 = _loc_4 + (_loc_5 + TAB + _loc_6 + NEW_LINE);
            }
            param1.position = _loc_3;
            return _loc_4;
        }// end function

    }
}
