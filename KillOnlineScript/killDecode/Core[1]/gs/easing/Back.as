package gs.easing
{

    public class Back extends Object
    {

        public function Back()
        {
            return;
        }// end function

        public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
        {
            var _loc_6:* = param1 / param4;
            param1 = param1 / param4;
            return param3 * _loc_6 * param1 * ((param5 + 1) * param1 - param5) + param2;
        }// end function

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
        {
            var _loc_6:* = param1 / param4 - 1;
            param1 = param1 / param4 - 1;
            return param3 * (_loc_6 * param1 * ((param5 + 1) * param1 + param5) + 1) + param2;
        }// end function

        public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number = 1.70158) : Number
        {
            var _loc_6:* = param1 / (param4 / 2);
            param1 = param1 / (param4 / 2);
            if (_loc_6 < 1)
            {
                var _loc_6:* = param5 * 1.525;
                param5 = param5 * 1.525;
                return param3 / 2 * (param1 * param1 * ((_loc_6 + 1) * param1 - param5)) + param2;
            }
            var _loc_6:* = param1 - 2;
            param1 = param1 - 2;
            var _loc_6:* = param5 * 1.525;
            param5 = param5 * 1.525;
            return param3 / 2 * (_loc_6 * param1 * ((_loc_6 + 1) * param1 + param5) + 2) + param2;
        }// end function

    }
}
