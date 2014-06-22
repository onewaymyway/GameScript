﻿package gs.easing
{

    public class Circ extends Object
    {

        public function Circ()
        {
            return;
        }// end function

        public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return (-param3) * (Math.sqrt(1 - _loc_5 * param1) - 1) + param2;
        }// end function

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4 - 1;
            param1 = param1 / param4 - 1;
            return param3 * Math.sqrt(1 - _loc_5 * param1) + param2;
        }// end function

        public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / (param4 / 2);
            param1 = param1 / (param4 / 2);
            if (_loc_5 < 1)
            {
                return (-param3) / 2 * (Math.sqrt(1 - param1 * param1) - 1) + param2;
            }
            var _loc_5:* = param1 - 2;
            param1 = param1 - 2;
            return param3 / 2 * (Math.sqrt(1 - _loc_5 * param1) + 1) + param2;
        }// end function

    }
}