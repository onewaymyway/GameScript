package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import flash.*;

    public class DLLNode extends Object
    {
        public var val:Object;
        public var prev:DLLNode;
        public var next:DLLNode;
        public var _list:DLL;

        public function DLLNode(param1:Object = , param2:DLL = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            val = param1;
            _list = param2;
            return;
        }// end function

        public function unlink() : DLLNode
        {
            return _list.unlink(this);
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{DLLNode %s}", [Std.string(val)]);
        }// end function

        public function prevVal() : Object
        {
            return prev.val;
        }// end function

        public function prependTo(param1:DLLNode) : DLLNode
        {
            next = param1;
            if (param1 != null)
            {
                param1.prev = this;
            }
            return this;
        }// end function

        public function prepend(param1:DLLNode) : DLLNode
        {
            param1.next = this;
            prev = param1;
            return param1;
        }// end function

        public function nextVal() : Object
        {
            return next.val;
        }// end function

        public function isTail() : Boolean
        {
            return _list.tail == this;
        }// end function

        public function isHead() : Boolean
        {
            return _list.head == this;
        }// end function

        public function hasPrev() : Boolean
        {
            return prev != null;
        }// end function

        public function hasNext() : Boolean
        {
            return next != null;
        }// end function

        public function getList() : DLL
        {
            return _list;
        }// end function

        public function free() : void
        {
            var _loc_1:Object = null;
            val = _loc_1;
            var _loc_2:DLLNode = null;
            prev = null;
            next = _loc_2;
            _list = null;
            return;
        }// end function

        public function appendTo(param1:DLLNode) : DLLNode
        {
            prev = param1;
            if (param1 != null)
            {
                param1.next = this;
            }
            return this;
        }// end function

        public function append(param1:DLLNode) : DLLNode
        {
            next = param1;
            param1.prev = this;
            return param1;
        }// end function

        public function _unlink() : DLLNode
        {
            var _loc_1:* = next;
            if (prev != null)
            {
                prev.next = next;
            }
            if (next != null)
            {
                next.prev = prev;
            }
            var _loc_2:DLLNode = null;
            prev = null;
            next = _loc_2;
            return _loc_1;
        }// end function

        public function _insertBefore(param1:DLLNode) : void
        {
            param1.next = this;
            param1.prev = prev;
            if (prev != null)
            {
                prev.next = param1;
            }
            prev = param1;
            return;
        }// end function

        public function _insertAfter(param1:DLLNode) : void
        {
            param1.next = next;
            param1.prev = this;
            if (next != null)
            {
                next.prev = param1;
            }
            next = param1;
            return;
        }// end function

    }
}
