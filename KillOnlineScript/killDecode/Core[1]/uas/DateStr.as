package uas
{

    public class DateStr extends Object
    {

        public function DateStr()
        {
            return;
        }// end function

        public static function strToDateFormat(param1:String) : Date
        {
            var _loc_2:Date = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            if (param1.indexOf(" ") > 0)
            {
                _loc_3 = param1.split(" ");
                _loc_4 = _loc_3[0].split("-");
                _loc_5 = _loc_3[1].split(":");
                _loc_2 = new Date(_loc_4[0], (Number(_loc_4[1]) - 1), _loc_4[2], _loc_5[0], _loc_5[1], _loc_5[2]);
            }
            else
            {
                _loc_6 = param1.split("-");
                _loc_2 = new Date(_loc_6[0], (Number(_loc_6[1]) - 1), _loc_6[2], 0, 0, 0);
            }
            return _loc_2;
        }// end function

        public static function dateFormatToStr(param1:Date, param2:Boolean = false) : String
        {
            var _loc_3:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_4:* = param1.getFullYear().toString();
            var _loc_5:* = ((param1.getMonth() + 1)).toString();
            var _loc_6:* = param1.getDate().toString();
            if (_loc_5.length < 2)
            {
                _loc_5 = "0" + _loc_5;
            }
            if (_loc_6.length < 2)
            {
                _loc_6 = "0" + _loc_6;
            }
            _loc_3 = _loc_4 + "-" + _loc_5 + "-" + _loc_6;
            if (param2)
            {
                _loc_7 = param1.getHours().toString();
                _loc_8 = param1.getMinutes().toString();
                _loc_9 = param1.getSeconds().toString();
                if (_loc_7.length < 2)
                {
                    _loc_7 = "0" + _loc_7;
                }
                if (_loc_8.length < 2)
                {
                    _loc_8 = "0" + _loc_8;
                }
                if (_loc_9.length < 2)
                {
                    _loc_9 = "0" + _loc_9;
                }
                _loc_3 = _loc_3 + (" " + _loc_7 + ":" + _loc_8 + ":" + _loc_9);
            }
            return _loc_3;
        }// end function

        public static function dateToDate2b(param1:String) : String
        {
            var _loc_2:* = param1.split(" ");
            var _loc_3:* = _loc_2[0].split("-");
            var _loc_4:* = _loc_2[1].split(":");
            if (String(_loc_3[1]).length < 2)
            {
                _loc_3[1] = "0" + _loc_3[1];
            }
            if (String(_loc_3[2]).length < 2)
            {
                _loc_3[2] = "0" + _loc_3[2];
            }
            if (String(_loc_4[0]).length < 2)
            {
                _loc_4[0] = "0" + _loc_4[0];
            }
            if (String(_loc_4[1]).length < 2)
            {
                _loc_4[1] = "0" + _loc_4[1];
            }
            if (String(_loc_4[2]).length < 2)
            {
                _loc_4[2] = "0" + _loc_4[2];
            }
            var _loc_5:* = _loc_3[0] + "-" + _loc_3[1] + "-" + _loc_3[2] + " " + _loc_4[0] + ":" + _loc_4[1] + ":" + _loc_4[2];
            return _loc_3[0] + "-" + _loc_3[1] + "-" + _loc_3[2] + " " + _loc_4[0] + ":" + _loc_4[1] + ":" + _loc_4[2];
        }// end function

    }
}
