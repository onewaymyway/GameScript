package flash
{
    import flash.display.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Lib extends Object
    {
        public static var current:MovieClip;

        public function Lib() : void
        {
            return;
        }// end function

        public static function getTimer() : int
        {
            return getTimer();
        }// end function

        public static function eval(param1:String)
        {
            var _loc_6:* = null;
            var _loc_8:* = null as String;
            var _loc_3:* = param1.split(".");
            var _loc_4:Array = [];
            var _loc_5:* = null;
            while (_loc_3.length > 0)
            {
                
                _loc_5 = getDefinitionByName(_loc_3.join("."));
                ;
                _loc_6 = null;
                if (_loc_6 as Error)
                {
                    Boot.lastError = _loc_6;
                }
                _loc_4.unshift(_loc_3.pop());
                if (_loc_5 != null)
                {
                    break;
                }
            }
            var _loc_7:int = 0;
            while (_loc_7 < _loc_4.length)
            {
                
                _loc_8 = _loc_4[_loc_7];
                _loc_7++;
                if (_loc_5 == null)
                {
                    return null;
                }
                _loc_5 = _loc_5[_loc_8];
            }
            return _loc_5;
        }// end function

        public static function getURL(param1:URLRequest, param2:String = ) : void
        {
            var _loc_3:* = navigateToURL;
            if (param2 == null)
            {
                null._loc_3(param1);
            }
            else
            {
                null._loc_3(param1, param2);
            }
            return;
        }// end function

        public static function fscommand(param1:String, param2:String = ) : void
        {
            fscommand(param1, param2 == null ? ("") : (param2));
            return;
        }// end function

        public static function trace(param1) : void
        {
            trace(param1);
            return;
        }// end function

        public static function attach(param1:String) : MovieClip
        {
            var _loc_2:* = getDefinitionByName(param1) as Class;
            return new _loc_2;
        }// end function

        public static function as(param1, param2:Class) : Object
        {
            return param1 as param2;
        }// end function

    }
}
