package de.polygonal.ds
{
    import flash.*;

    public class DAIterator extends Object implements Itr
    {
        public var _s:int;
        public var _i:int;
        public var _f:DA;
        public var _a:Array;

        public function DAIterator(param1:DA = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _a = _f._a;
            _s = _f._size;
            _i = 0;
            return;
        }// end function

        public function reset() : Itr
        {
            _a = _f._a;
            _s = _f._size;
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
            return param1._size;
        }// end function

        public function __a(param1:Object) : Array
        {
            return param1._a;
        }// end function

    }
}
