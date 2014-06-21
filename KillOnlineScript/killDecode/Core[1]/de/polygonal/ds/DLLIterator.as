package de.polygonal.ds
{
    import flash.*;

    public class DLLIterator extends Object implements Itr
    {
        public var _walker:DLLNode;
        public var _f:DLL;

        public function DLLIterator(param1:DLL = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _walker = _f.head;
            return;
        }// end function

        public function reset() : Itr
        {
            _walker = _f.head;
            return this;
        }// end function

        public function next() : Object
        {
            var _loc_1:* = _walker.val;
            _walker = _walker.next;
            return _loc_1;
        }// end function

        public function hasNext() : Boolean
        {
            return _walker != null;
        }// end function

    }
}
