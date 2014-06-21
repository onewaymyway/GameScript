package de.polygonal.ds
{
    import flash.*;

    public class LinkedQueueIterator extends Object implements Itr
    {
        public var _walker:LinkedQueueNode;
        public var _f:LinkedQueue;

        public function LinkedQueueIterator(param1:LinkedQueue = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _f = param1;
            _walker = _f._head;
            return;
        }// end function

        public function reset() : Itr
        {
            _walker = _f._head;
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

        public function __head(param1:Object) : LinkedQueueNode
        {
            return param1._head;
        }// end function

    }
}
