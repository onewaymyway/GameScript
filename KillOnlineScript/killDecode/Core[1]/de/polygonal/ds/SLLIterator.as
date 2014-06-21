package de.polygonal.ds
{
    import flash.*;

    public class SLLIterator extends Object implements Itr
    {
        public var _walker:SLLNode;
        public var _f:SLL;

        public function SLLIterator(param1:SLL = ) : void
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

        public function __head(param1:Object) : SLLNode
        {
            return param1.head;
        }// end function

    }
}
