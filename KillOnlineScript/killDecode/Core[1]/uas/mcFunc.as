package uas
{
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;

    public class mcFunc extends Object
    {

        public function mcFunc() : void
        {
            return;
        }// end function

        public static function removeAllMc(param1:Object, param2:Array = null, param3:Array = null) : void
        {
            var _loc_5:String = null;
            var _loc_4:* = param1.numChildren;
            while (_loc_4 > 0)
            {
                
                if (param2)
                {
                    for (_loc_5 in param2)
                    {
                        
                        if (param1.getChildAt(0).hasEventListener(param2[_loc_5]))
                        {
                            param1.getChildAt(0).removeEventListener(param2[_loc_5], param3[_loc_5]);
                        }
                    }
                }
                if (param1.getChildAt(0) is Sprite || param1.getChildAt(0) is MovieClip)
                {
                    param1.getChildAt(0).soundTransform = new SoundTransform(0);
                }
                param1.removeChildAt(0);
                _loc_4 = _loc_4 - 1;
            }
            return;
        }// end function

        public static function reSetMcsWhere(param1:Object, param2:int, param3:int, param4:int, param5:int) : uint
        {
            var _loc_10:Object = null;
            var _loc_6:* = param1.numChildren;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            while (_loc_9 < _loc_6)
            {
                
                _loc_10 = param1.getChildAt(_loc_9);
                if (param3 == 0)
                {
                    _loc_10.x = param4 * _loc_7;
                    _loc_10.y = param5 * _loc_8;
                    _loc_7 = _loc_7 + 1;
                    if (param4 * _loc_7 + _loc_10.width >= param2)
                    {
                        _loc_7 = 0;
                        _loc_8 = _loc_8 + 1;
                    }
                }
                else
                {
                    _loc_10.x = param4 * _loc_7;
                    _loc_10.y = param5 * _loc_8;
                    _loc_8 = _loc_8 + 1;
                    if (param5 * _loc_8 + _loc_10.height >= param3)
                    {
                        _loc_7 = _loc_7 + 1;
                        _loc_8 = 0;
                    }
                }
                _loc_9 = _loc_9 + 1;
            }
            return _loc_6;
        }// end function

        public static function hasTheChlid(param1:Object, param2:Object) : Boolean
        {
            var _loc_5:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:* = param2.numChildren;
            while (_loc_4 > 0)
            {
                
                _loc_4 = _loc_4 - 1;
                _loc_5 = param2.getChildAt(_loc_4);
                if (_loc_5 == param1)
                {
                    _loc_3 = true;
                }
            }
            return _loc_3;
        }// end function

        public static function copyDisplayObject(param1:DisplayObject, param2:Boolean = false) : DisplayObject
        {
            var _loc_5:Rectangle = null;
            var _loc_3:* = Object(param1).constructor;
            var _loc_4:* = new _loc_3;
            new _loc_3.transform = param1.transform;
            _loc_4.filters = param1.filters;
            _loc_4.cacheAsBitmap = param1.cacheAsBitmap;
            _loc_4.opaqueBackground = param1.opaqueBackground;
            if (param1.scale9Grid)
            {
                _loc_5 = param1.scale9Grid;
                _loc_4.scale9Grid = _loc_5;
            }
            if (param2 && param1.parent)
            {
                param1.parent.addChild(_loc_4);
            }
            return _loc_4;
        }// end function

    }
}
