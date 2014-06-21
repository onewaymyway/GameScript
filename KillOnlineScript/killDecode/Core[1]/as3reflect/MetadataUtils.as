package as3reflect
{
    import flash.events.*;
    import flash.utils.*;

    public class MetadataUtils extends Object
    {
        private static var _cache:Object = new Object();
        public static var CLEAR_CACHE_INTERVAL:uint = 60000;
        private static var _timer:Timer;

        public function MetadataUtils()
        {
            return;
        }// end function

        public static function getFromString(param1:String) : XML
        {
            var _loc_2:* = getDefinitionByName(param1) as Class;
            return getFromObject(_loc_2);
        }// end function

        public static function clearCache() : void
        {
            _cache = new Object();
            if (_timer && _timer.running)
            {
                _timer.stop();
            }
            return;
        }// end function

        private static function _timerHandler(event:TimerEvent) : void
        {
            clearCache();
            return;
        }// end function

        public static function getFromObject(param1:Object) : XML
        {
            var _loc_3:XML = null;
            var _loc_2:* = getQualifiedClassName(param1);
            if (_cache.hasOwnProperty(_loc_2))
            {
                _loc_3 = _cache[_loc_2];
            }
            else
            {
                if (!_timer)
                {
                    _timer = new Timer(CLEAR_CACHE_INTERVAL, 1);
                    _timer.addEventListener(TimerEvent.TIMER, _timerHandler);
                }
                if (!(param1 is Class))
                {
                    param1 = param1.constructor;
                }
                _loc_3 = describeType(param1);
                _cache[_loc_2] = _loc_3;
                if (!_timer.running)
                {
                    _timer.start();
                }
            }
            return _loc_3;
        }// end function

    }
}
