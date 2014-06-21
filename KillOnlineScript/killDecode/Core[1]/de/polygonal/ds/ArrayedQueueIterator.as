package de.polygonal.ds
{
    import flash.*;

    public class ArrayedQueueIterator extends Object implements Itr
    {
        public var _size:int;
        public var _i:int;
        public var _front:int;
        public var _f:ArrayedQueue;
        public var _capacity:int;
        public var _a:Array;

        public function ArrayedQueueIterator(param1:ArrayedQueue = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _a = _f._a;
            _front = _f._front;
            _capacity = _f._capacity;
            _size = _f._size;
            _i = 0;
            return;
        }// end function

        public function reset() : Itr
        {
            _a = _f._a;
            _front = _f._front;
            _capacity = _f._capacity;
            _size = _f._size;
            _i = 0;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _i;
            (_i + 1);
            return _a[(_loc_1 + _front) % _capacity];
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _size;
        }// end function

        public function __size(param1:Object) : int
        {
            return param1._capacity;
        }// end function

        public function __front(param1:Object) : int
        {
            return param1._front;
        }// end function

        public function __count(param1:Object) : int
        {
            return param1._size;
        }// end function

        public function __a(param1:Object) : Array
        {
            return param1._a;
        }// end function

    }
}
