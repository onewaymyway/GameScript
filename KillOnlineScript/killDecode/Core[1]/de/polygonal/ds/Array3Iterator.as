package de.polygonal.ds
{
    import flash.*;

    public class Array3Iterator extends Object implements Itr
    {
        public var _s:int;
        public var _i:int;
        public var _f:Array3;
        public var _a:Array;

        public function Array3Iterator(param1:Array3 = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _a = _f._a;
            var _loc_2:* = _f;
            _s = _loc_2._w * _loc_2._h * _loc_2._d;
            _i = 0;
            return;
        }// end function

        public function reset() : Itr
        {
            _a = _f._a;
            var _loc_1:* = _f;
            _s = _loc_1._w * _loc_1._h * _loc_1._d;
            _i = 0;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _i;
            (_i + 1);
            return _a[_loc_1];
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _s;
        }// end function

        public function __size(param1:Object) : int
        {
            return param1._w * param1._h * param1._d;
        }// end function

        public function __a(param1:Object) : Array
        {
            return param1._a;
        }// end function

    }
}
