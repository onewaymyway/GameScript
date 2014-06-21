package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class LinkedQueue extends Object implements Queue
    {
        public var maxSize:int;
        public var key:int;
        public var _tailPool:LinkedQueueNode;
        public var _tail:LinkedQueueNode;
        public var _size:int;
        public var _reservedSize:int;
        public var _poolSize:int;
        public var _headPool:LinkedQueueNode;
        public var _head:LinkedQueueNode;

        public function LinkedQueue(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:* = null as LinkedQueueNode;
            if (Boot.skip_constructor)
            {
                return;
            }
            maxSize = -1;
            _reservedSize = param1;
            _size = 0;
            _poolSize = 0;
            if (param1 > 0)
            {
                _loc_3 = null;
                _loc_4 = new LinkedQueueNode(_loc_3);
                _tailPool = _loc_4;
                _headPool = _loc_4;
            }
            var _loc_5:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_5;
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{LinkedQueue size: %d}", [_size]);
        }// end function

        public function toDA() : DA
        {
            var _loc_3:int = 0;
            var _loc_1:* = new DA(_size);
            var _loc_2:* = _head;
            while (_loc_2 != null)
            {
                
                _loc_3 = _loc_1._size;
                _loc_1._a[_loc_3] = _loc_2.val;
                if (_loc_3 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
                _loc_2 = _loc_2.next;
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_2:* = new Array(_size);
            var _loc_1:* = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _head;
            while (_loc_4 != null)
            {
                
                _loc_3++;
                _loc_1[_loc_3] = _loc_4.val;
                _loc_4 = _loc_4.next;
            }
            return _loc_1;
        }// end function

        public function size() : int
        {
            return _size;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as LinkedQueueNode;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as Object;
            var _loc_9:* = null as LinkedQueueNode;
            var _loc_10:int = 0;
            var _loc_2:* = _size;
            if (param1 == null)
            {
                _loc_3 = Math;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4 = _loc_3.random() * _loc_2;
                    _loc_5 = _head;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_2)
                    {
                        
                        _loc_6++;
                        _loc_7 = _loc_6;
                        _loc_5 = _loc_5.next;
                    }
                    _loc_8 = _loc_5.val;
                    _loc_9 = _head;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_4)
                    {
                        
                        _loc_6++;
                        _loc_7 = _loc_6;
                        _loc_9 = _loc_9.next;
                    }
                    _loc_5.val = _loc_9.val;
                    _loc_9.val = _loc_8;
                }
            }
            else
            {
                _loc_4 = 0;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4++;
                    _loc_6 = param1._a[_loc_4] * _loc_2;
                    _loc_5 = _head;
                    _loc_7 = 0;
                    while (_loc_7 < _loc_2)
                    {
                        
                        _loc_7++;
                        _loc_10 = _loc_7;
                        _loc_5 = _loc_5.next;
                    }
                    _loc_8 = _loc_5.val;
                    _loc_9 = _head;
                    _loc_7 = 0;
                    while (_loc_7 < _loc_6)
                    {
                        
                        _loc_7++;
                        _loc_10 = _loc_7;
                        _loc_9 = _loc_9.next;
                    }
                    _loc_5.val = _loc_9.val;
                    _loc_9.val = _loc_8;
                }
            }
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_6:* = null as LinkedQueueNode;
            var _loc_7:* = null as Object;
            var _loc_8:* = null as LinkedQueueNode;
            var _loc_9:* = null as Object;
            var _loc_10:* = null as LinkedQueueNode;
            var _loc_2:* = param1;
            if (_size == 0)
            {
                return false;
            }
            var _loc_3:Boolean = false;
            var _loc_4:* = _head;
            var _loc_5:* = _head.next;
            if (_head == _tail)
            {
                if (_head.val == _loc_2)
                {
                    _size = 0;
                    _loc_6 = _head;
                    _loc_7 = _loc_6.val;
                    if (_reservedSize > 0)
                    {
                    }
                    if (_poolSize < _reservedSize)
                    {
                        _loc_8 = _loc_6;
                        _tailPool.next = _loc_8;
                        _tailPool = _loc_8;
                        _loc_9 = null;
                        _loc_6.val = _loc_9;
                        _loc_6.next = null;
                        (_poolSize + 1);
                    }
                    _head = null;
                    _tail = null;
                    return true;
                }
                return false;
            }
            while (_loc_5 != null)
            {
                
                if (_loc_5.val == _loc_2)
                {
                    _loc_3 = true;
                    if (_loc_5 == _tail)
                    {
                        _tail = _loc_4;
                    }
                    _loc_6 = _loc_5.next;
                    _loc_4.next = _loc_6;
                    _loc_7 = _loc_5.val;
                    if (_reservedSize > 0)
                    {
                    }
                    if (_poolSize < _reservedSize)
                    {
                        _loc_8 = _loc_5;
                        _tailPool.next = _loc_8;
                        _tailPool = _loc_8;
                        _loc_9 = null;
                        _loc_5.val = _loc_9;
                        _loc_5.next = null;
                        (_poolSize + 1);
                    }
                    _loc_5 = _loc_6;
                    (_size - 1);
                    continue;
                }
                _loc_4 = _loc_5;
                _loc_5 = _loc_5.next;
            }
            if (_head.val == _loc_2)
            {
                _loc_3 = true;
                _loc_6 = _head.next;
                _loc_8 = _head;
                _loc_7 = _loc_8.val;
                if (_reservedSize > 0)
                {
                }
                if (_poolSize < _reservedSize)
                {
                    _loc_10 = _loc_8;
                    _tailPool.next = _loc_10;
                    _tailPool = _loc_10;
                    _loc_9 = null;
                    _loc_8.val = _loc_9;
                    _loc_8.next = null;
                    (_poolSize + 1);
                }
                _head = _loc_6;
                if (_head == null)
                {
                    _tail = null;
                }
                (_size - 1);
            }
            return _loc_3;
        }// end function

        public function peek() : Object
        {
            return _head.val;
        }// end function

        public function iterator() : Itr
        {
            return new LinkedQueueIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function free() : void
        {
            var _loc_3:* = null as LinkedQueueNode;
            var _loc_4:* = null as LinkedQueueNode;
            var _loc_1:Object = null;
            var _loc_2:* = _head;
            while (_loc_2 != null)
            {
                
                _loc_3 = _loc_2.next;
                _loc_2.next = null;
                _loc_2.val = _loc_1;
                _loc_2 = _loc_3;
            }
            _loc_3 = null;
            _tail = _loc_3;
            _head = _loc_3;
            _loc_3 = _headPool;
            while (_loc_3 != null)
            {
                
                _loc_4 = _loc_3.next;
                _loc_3.next = null;
                _loc_3.val = _loc_1;
                _loc_3 = _loc_4;
            }
            _loc_4 = null;
            _tailPool = _loc_4;
            _headPool = _loc_4;
            return;
        }// end function

        public function fill(param1:Object, param2:int = 0) : void
        {
            var _loc_5:int = 0;
            if (param2 > 0)
            {
            }
            else
            {
                param2 = _size;
            }
            var _loc_3:* = _head;
            var _loc_4:int = 0;
            while (_loc_4 < param2)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _loc_3.val = param1;
                _loc_3 = _loc_3.next;
            }
            return;
        }// end function

        public function enqueue(param1:Object) : void
        {
            var _loc_4:* = null as LinkedQueueNode;
            var _loc_2:* = param1;
            (_size + 1);
            if (_reservedSize != 0)
            {
            }
            var _loc_3:* = _poolSize == 0 ? (new LinkedQueueNode(_loc_2)) : (_loc_4 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_4.val = _loc_2, _loc_4);
            if (_head == null)
            {
                _loc_4 = _loc_3;
                _tail = _loc_4;
                _head = _loc_4;
                _head.next = _tail;
            }
            else
            {
                _tail.next = _loc_3;
                _tail = _loc_3;
            }
            return;
        }// end function

        public function dequeue() : Object
        {
            var _loc_3:* = null as LinkedQueueNode;
            var _loc_4:* = null as Object;
            (_size - 1);
            var _loc_1:* = _head;
            if (_head == _tail)
            {
                _head = null;
                _tail = null;
            }
            else
            {
                _head = _head.next;
            }
            var _loc_2:* = _loc_1.val;
            if (_reservedSize > 0)
            {
            }
            if (_poolSize < _reservedSize)
            {
                _loc_3 = _loc_1;
                _tailPool.next = _loc_3;
                _tailPool = _loc_3;
                _loc_4 = null;
                _loc_1.val = _loc_4;
                _loc_1.next = null;
                (_poolSize + 1);
            }
            return _loc_2;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_2:* = param1;
            var _loc_3:* = _head;
            while (_loc_3 != null)
            {
                
                if (_loc_3.val == _loc_2)
                {
                    return true;
                }
                _loc_3 = _loc_3.next;
            }
            return false;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_5:* = null as LinkedQueueNode;
            var _loc_6:* = null as LinkedQueueNode;
            var _loc_7:* = null as LinkedQueueNode;
            var _loc_8:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new LinkedQueue(_reservedSize, maxSize);
            if (_size == 0)
            {
                return _loc_4;
            }
            if (param1)
            {
                _loc_5 = _head;
                if (_loc_5 != null)
                {
                    _loc_6 = new LinkedQueueNode(_loc_5.val);
                    _loc_4._tail = _loc_6;
                    _loc_4._head = _loc_6;
                    _loc_4._head.next = _loc_4._tail;
                }
                if (_size > 1)
                {
                    _loc_5 = _loc_5.next;
                    while (_loc_5 != null)
                    {
                        
                        _loc_6 = new LinkedQueueNode(_loc_5.val);
                        _loc_7 = _loc_6;
                        _loc_4._tail.next = _loc_7;
                        _loc_4._tail = _loc_7;
                        _loc_5 = _loc_5.next;
                    }
                }
            }
            else if (_loc_3 == null)
            {
                _loc_8 = null;
                _loc_5 = _head;
                if (_loc_5 != null)
                {
                    _loc_8 = _loc_5.val;
                    _loc_6 = new LinkedQueueNode(_loc_8.clone());
                    _loc_4._tail = _loc_6;
                    _loc_4._head = _loc_6;
                    _loc_4._head.next = _loc_4._tail;
                }
                if (_size > 1)
                {
                    _loc_5 = _loc_5.next;
                    while (_loc_5 != null)
                    {
                        
                        _loc_8 = _loc_5.val;
                        _loc_6 = new LinkedQueueNode(_loc_8.clone());
                        _loc_7 = _loc_6;
                        _loc_4._tail.next = _loc_7;
                        _loc_4._tail = _loc_7;
                        _loc_5 = _loc_5.next;
                    }
                }
            }
            else
            {
                _loc_5 = _head;
                if (_loc_5 != null)
                {
                    _loc_6 = new LinkedQueueNode(this._loc_3(_loc_5.val));
                    _loc_4._tail = _loc_6;
                    _loc_4._head = _loc_6;
                    _loc_4._head.next = _loc_4._tail;
                }
                if (_size > 1)
                {
                    _loc_5 = _loc_5.next;
                    while (_loc_5 != null)
                    {
                        
                        _loc_6 = new LinkedQueueNode(this._loc_3(_loc_5.val));
                        _loc_7 = _loc_6;
                        _loc_4._tail.next = _loc_7;
                        _loc_4._tail = _loc_7;
                        _loc_5 = _loc_5.next;
                    }
                }
            }
            _loc_4._size = _size;
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:* = null as LinkedQueueNode;
            var _loc_3:* = null as LinkedQueueNode;
            var _loc_4:* = null as Object;
            var _loc_5:* = null as LinkedQueueNode;
            var _loc_6:* = null as Object;
            if (!param1)
            {
            }
            if (_reservedSize > 0)
            {
                _loc_2 = _head;
                while (_loc_2 != null)
                {
                    
                    _loc_3 = _loc_2.next;
                    _loc_4 = _loc_2.val;
                    if (_reservedSize > 0)
                    {
                    }
                    if (_poolSize < _reservedSize)
                    {
                        _loc_5 = _loc_2;
                        _tailPool.next = _loc_5;
                        _tailPool = _loc_5;
                        _loc_6 = null;
                        _loc_2.val = _loc_6;
                        _loc_2.next = null;
                        (_poolSize + 1);
                    }
                    _loc_2 = _loc_2.next;
                }
            }
            _loc_2 = null;
            _tail = _loc_2;
            _head = _loc_2;
            _size = 0;
            return;
        }// end function

        public function back() : Object
        {
            return _tail.val;
        }// end function

        public function assign(param1:Class, param2:Array = , param3:int = 0) : void
        {
            var _loc_6:int = 0;
            if (param3 > 0)
            {
            }
            else
            {
                param3 = _size;
            }
            var _loc_4:* = _head;
            var _loc_5:int = 0;
            while (_loc_5 < param3)
            {
                
                _loc_5++;
                _loc_6 = _loc_5;
                _loc_4.val = Instance.create(param1, param2);
                _loc_4 = _loc_4.next;
            }
            return;
        }// end function

        public function _putNode(param1:LinkedQueueNode) : Object
        {
            var _loc_3:* = null as LinkedQueueNode;
            var _loc_4:* = null as Object;
            var _loc_2:* = param1.val;
            if (_reservedSize > 0)
            {
            }
            if (_poolSize < _reservedSize)
            {
                _loc_3 = param1;
                _tailPool.next = _loc_3;
                _tailPool = _loc_3;
                _loc_4 = null;
                param1.val = _loc_4;
                param1.next = null;
                (_poolSize + 1);
            }
            return _loc_2;
        }// end function

        public function _getNode(param1:Object) : LinkedQueueNode
        {
            var _loc_2:* = null as LinkedQueueNode;
            if (_reservedSize != 0)
            {
            }
            if (_poolSize == 0)
            {
                return new LinkedQueueNode(param1);
            }
            else
            {
                _loc_2 = _headPool;
                _headPool = _headPool.next;
            }
            (_poolSize - 1);
            _loc_2.val = param1;
            return _loc_2;
        }// end function

    }
}
