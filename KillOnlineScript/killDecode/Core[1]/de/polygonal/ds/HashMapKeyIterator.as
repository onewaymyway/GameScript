package de.polygonal.ds
{
    import flash.*;
    import flash.utils.*;

    public class HashMapKeyIterator extends Object implements Itr
    {
        public var _s:int;
        public var _keys:Array;
        public var _i:int;
        public var _f:Object;

        public function HashMapKeyIterator(param1:Object = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            var _loc_3:int = 0;
            var _loc_2:Array = [];
            var _loc_4:* = _f._map;
            while (_loc_4 in _loc_3)
            {
                
                _loc_2.push(_loc_4[_loc_3]);
            }
            _keys = _loc_2;
            _i = 0;
            _s = _keys.length;
            return;
        }// end function

        public function reset() : Itr
        {
            var _loc_2:int = 0;
            var _loc_1:Array = [];
            var _loc_3:* = _f._map;
            while (_loc_3 in _loc_2)
            {
                
                _loc_1.push(_loc_3[_loc_2]);
            }
            _keys = _loc_1;
            _i = 0;
            _s = _keys.length;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _i;
            (_i + 1);
            return _keys[_loc_1];
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _s;
        }// end function

        public function __map(param1:Object) : Dictionary
        {
            return param1._map;
        }// end function

    }
}
