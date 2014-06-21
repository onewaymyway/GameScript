package 
{
    import flash.*;

    public class Std extends Object
    {

        public function Std() : void
        {
            return;
        }// end function

        public static function is(param1, param2) : Boolean
        {
            return Boot.__instanceof(param1, param2);
        }// end function

        public static function string(param1) : String
        {
            return Boot.__string_rec(param1, "");
        }// end function

        public static function _int(param1:Number) : int
        {
            return param1;
        }// end function

        public static function parseInt(param1:String) : Object
        {
            var _loc_2:* = parseInt(param1);
            if (isNaN(_loc_2))
            {
                return null;
            }
            return _loc_2;
        }// end function

        public static function parseFloat(param1:String) : Number
        {
            return parseFloat(param1);
        }// end function

        public static function random(param1:int) : int
        {
            return Math.floor(Math.random() * param1);
        }// end function

    }
}
