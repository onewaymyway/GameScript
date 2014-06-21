package de.polygonal.ds
{
    import flash.*;

    public class ArrayedStackIterator extends Object implements Itr
    {
        public var _i:int;
        public var _f:ArrayedStack;
        public var _a:Array;

        public function ArrayedStackIterator(param1:ArrayedStack = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _a = _f._a;
            _i = _f._top - 1;
            return;
        }// end function

        public function reset() : Itr
        {
            _a = _f._a;
            _i = _f._top - 1;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _i;
            (_i - 1);
            return _a[_loc_1];
        }// end function

        public function hasNext() : Boolean
        {
            return _i >= 0;
        }// end function

        public function __top(param1:Object) : int
        {
            return param1._top;
        }// end function

        public function __a(param1:Object) : Array
        {
            return param1._a;
        }// end function

    }
}
