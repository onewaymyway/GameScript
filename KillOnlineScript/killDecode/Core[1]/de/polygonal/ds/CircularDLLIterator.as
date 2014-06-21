package de.polygonal.ds
{
    import flash.*;

    public class CircularDLLIterator extends Object implements Itr
    {
        public var _walker:DLLNode;
        public var _s:int;
        public var _i:int;
        public var _f:DLL;

        public function CircularDLLIterator(param1:DLL = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _walker = _f.head;
            _s = _f._size;
            _i = 0;
            return;
        }// end function

        public function reset() : Itr
        {
            _walker = _f.head;
            _s = _f._size;
            _i = 0;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _walker.val;
            _walker = _walker.next;
            (_i + 1);
            return _loc_1;
        }// end function

        public function hasNext() : Boolean
        {
            return _i < _s;
        }// end function

        public function __size(param1:Object) : int
        {
            return param1._size;
        }// end function

    }
}
