package Core
{
    import Core.model.data.*;

    public class Matlab extends Object
    {

        public function Matlab()
        {
            return;
        }// end function

        public static function GetFileName(param1:String) : String
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:String = null;
            if (param1 != null)
            {
                _loc_2 = param1.length;
                _loc_3 = _loc_2;
                while (--_loc_3 >= 0)
                {
                    
                    _loc_4 = param1.charAt(_loc_3);
                    if (_loc_4 == "/" || _loc_4 == "\\" || _loc_4 == ":")
                    {
                        return param1.substring((_loc_3 + 1), _loc_2);
                    }
                }
            }
            return param1;
        }// end function

        public static function traceObj(param1:Object, param2:String = "OBJ") : void
        {
            var _loc_3:String = null;
            trace("----" + param2 + "---------");
            for (_loc_3 in param1)
            {
                
                trace(_loc_3 + ":" + param1[_loc_3]);
            }
            trace("----" + param2 + "-END--------");
            return;
        }// end function

        public static function getDomaFristname(param1:String) : String
        {
            var _loc_2:* = param1;
            if (_loc_2.indexOf(":", 8) > 8)
            {
                _loc_2 = _loc_2.substring(7, _loc_2.indexOf(":", 8));
            }
            else if (_loc_2.indexOf("/", 8) > 8)
            {
                _loc_2 = _loc_2.substring(7, _loc_2.indexOf(".", 8));
            }
            return _loc_2;
        }// end function

        public static function getUK() : int
        {
            trace("n:" + MainData.N + " m:" + MainData.M);
            var _loc_1:* = int((Math.pow(MainData.N + 2, 3) + MainData.M) / 13);
            trace("UK:" + _loc_1);
            var _loc_2:* = MainData;
            var _loc_3:* = MainData.N + 1;
            _loc_2.N = _loc_3;
            if (MainData.N >= 999)
            {
                MainData.N = 111;
            }
            return _loc_1;
        }// end function

    }
}
