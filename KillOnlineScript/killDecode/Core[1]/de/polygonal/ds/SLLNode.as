package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import flash.*;

    public class SLLNode extends Object
    {
        public var val:Object;
        public var next:SLLNode;
        public var _list:SLL;

        public function SLLNode(param1:Object = , param2:SLL = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            val = param1;
            _list = param2;
            return;
        }// end function

        public function unlink() : SLLNode
        {
            var _loc_3:* = null as SLLNode;
            var _loc_4:* = null as SLLNode;
            var _loc_5:* = null as Object;
            var _loc_6:* = null as Object;
            var _loc_1:* = _list;
            var _loc_2:* = next;
            if (_loc_1.head == this)
            {
                _loc_3 = _loc_1.head;
                if (_loc_1._size > 1)
                {
                    _loc_1.head = _loc_1.head.next;
                    if (_loc_1.head == null)
                    {
                        _loc_1.tail = null;
                    }
                    (_loc_1._size - 1);
                }
                else
                {
                    _loc_4 = null;
                    _loc_1.tail = _loc_4;
                    _loc_1.head = _loc_4;
                    _loc_1._size = 0;
                }
                _loc_3.next = null;
                _loc_5 = _loc_3.val;
                if (_loc_1._reservedSize > 0)
                {
                }
                if (_loc_1._poolSize < _loc_1._reservedSize)
                {
                    _loc_4 = _loc_3;
                    _loc_1._tailPool.next = _loc_4;
                    _loc_1._tailPool = _loc_4;
                    _loc_6 = null;
                    _loc_3.val = _loc_6;
                    _loc_3.next = null;
                    (_loc_1._poolSize + 1);
                }
                else
                {
                    _loc_3._list = null;
                }
            }
            else
            {
                _loc_4 = _loc_1.head;
                while (_loc_4.next != this)
                {
                    
                    _loc_4 = _loc_4.next;
                }
                _loc_3 = _loc_4;
                if (_loc_3.next == _loc_1.tail)
                {
                    _loc_1.tail = _loc_3;
                }
                _loc_3.next = next;
                _loc_5 = val;
                if (_loc_1._reservedSize > 0)
                {
                }
                if (_loc_1._poolSize < _loc_1._reservedSize)
                {
                    _loc_4 = this;
                    _loc_1._tailPool.next = _loc_4;
                    _loc_1._tailPool = _loc_4;
                    _loc_6 = null;
                    val = _loc_6;
                    next = null;
                    (_loc_1._poolSize + 1);
                }
                else
                {
                    _list = null;
                }
                (_loc_1._size - 1);
            }
            return _loc_2;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{SLLNode: %s}", [Std.string(val)]);
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

        public function hasNext() : Boolean
        {
            return next != null;
        }// end function

        public function getList() : SLL
        {
            return _list;
        }// end function

        public function free() : void
        {
            var _loc_1:Object = null;
            val = _loc_1;
            next = null;
            return;
        }// end function

        public function _insertAfter(param1:SLLNode) : void
        {
            param1.next = next;
            next = param1;
            return;
        }// end function

    }
}
