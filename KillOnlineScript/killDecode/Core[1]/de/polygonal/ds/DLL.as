package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class DLL extends Object implements Collection
    {
        public var tail:DLLNode;
        public var maxSize:int;
        public var key:int;
        public var head:DLLNode;
        public var _tailPool:DLLNode;
        public var _size:int;
        public var _reservedSize:int;
        public var _poolSize:int;
        public var _headPool:DLLNode;
        public var _circular:Boolean;

        public function DLL(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:* = null as DLLNode;
            if (Boot.skip_constructor)
            {
                return;
            }
            maxSize = -1;
            _reservedSize = param1;
            _circular = false;
            _size = 0;
            _poolSize = 0;
            if (param1 > 0)
            {
                _loc_3 = null;
                _loc_4 = new DLLNode(_loc_3, this);
                _tailPool = _loc_4;
                _headPool = _loc_4;
            }
            _loc_4 = null;
            tail = _loc_4;
            head = _loc_4;
            var _loc_5:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_5;
            return;
        }// end function

        public function unlink(param1:DLLNode) : DLLNode
        {
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as Object;
            var _loc_2:* = param1.next;
            if (param1 == head)
            {
                head = head.next;
                if (_circular)
                {
                    if (head == tail)
                    {
                        head = null;
                    }
                    else
                    {
                        tail.next = head;
                    }
                }
                if (head == null)
                {
                    tail = null;
                }
            }
            else if (param1 == tail)
            {
                tail = tail.prev;
                if (_circular)
                {
                    head.prev = tail;
                }
                if (tail == null)
                {
                    head = null;
                }
            }
            param1._unlink();
            var _loc_3:* = param1.val;
            if (_reservedSize > 0)
            {
            }
            if (_poolSize < _reservedSize)
            {
                _loc_4 = param1;
                _tailPool.next = _loc_4;
                _tailPool = _loc_4;
                _loc_5 = null;
                param1.val = _loc_5;
                (_poolSize + 1);
            }
            else
            {
                param1._list = null;
            }
            (_size - 1);
            return _loc_2;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{DLL, size: %d, circular: %s}", [_size, _circular]);
        }// end function

        public function toDA() : DA
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_1:* = new DA(_size);
            var _loc_2:* = head;
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = _loc_1._size;
                _loc_1._a[_loc_6] = _loc_2.val;
                if (_loc_6 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
                _loc_2 = _loc_2.next;
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_6:int = 0;
            var _loc_2:* = new Array(_size);
            var _loc_1:* = _loc_2;
            var _loc_3:* = head;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_1[_loc_6] = _loc_3.val;
                _loc_3 = _loc_3.next;
            }
            return _loc_1;
        }// end function

        public function sort(param1:Function, param2:Boolean = false) : void
        {
            if (_size > 1)
            {
                if (_circular)
                {
                    tail.next = null;
                    head.prev = null;
                }
                if (param1 == null)
                {
                    head = param2 ? (_insertionSortComparable(head)) : (_mergeSortComparable(head));
                }
                else
                {
                    head = param2 ? (_insertionSort(head, param1)) : (_mergeSort(head, param1));
                }
                if (_circular)
                {
                    tail.next = head;
                    head.prev = tail;
                }
            }
            return;
        }// end function

        public function size() : int
        {
            return _size;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as DLLNode;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as Object;
            var _loc_9:* = null as DLLNode;
            var _loc_10:int = 0;
            var _loc_2:* = _size;
            if (param1 == null)
            {
                _loc_3 = Math;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4 = _loc_3.random() * _loc_2;
                    _loc_5 = head;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_2)
                    {
                        
                        _loc_6++;
                        _loc_7 = _loc_6;
                        _loc_5 = _loc_5.next;
                    }
                    _loc_8 = _loc_5.val;
                    _loc_9 = head;
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
                    _loc_5 = head;
                    _loc_7 = 0;
                    while (_loc_7 < _loc_2)
                    {
                        
                        _loc_7++;
                        _loc_10 = _loc_7;
                        _loc_5 = _loc_5.next;
                    }
                    _loc_8 = _loc_5.val;
                    _loc_9 = head;
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
            if (_circular)
            {
                tail.next = head;
                head.prev = tail;
            }
            return;
        }// end function

        public function shiftUp() : void
        {
            var _loc_1:* = null as DLLNode;
            if (_size > 1)
            {
                _loc_1 = head;
                if (head.next == tail)
                {
                    head = tail;
                    head.prev = null;
                    tail = _loc_1;
                    tail.next = null;
                    head.next = tail;
                    tail.prev = head;
                }
                else
                {
                    head = head.next;
                    head.prev = null;
                    tail.next = _loc_1;
                    _loc_1.next = null;
                    _loc_1.prev = tail;
                    tail = _loc_1;
                }
                if (_circular)
                {
                    tail.next = head;
                    head.prev = tail;
                }
            }
            return;
        }// end function

        public function reverse() : void
        {
            var _loc_1:* = null as Object;
            var _loc_2:* = null as DLLNode;
            var _loc_3:* = null as DLLNode;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (_size <= 1)
            {
                return;
            }
            else if (_size <= 3)
            {
                _loc_1 = head.val;
                head.val = tail.val;
                tail.val = _loc_1;
            }
            else
            {
                _loc_2 = head;
                _loc_3 = tail;
                _loc_4 = 0;
                _loc_5 = _size >> 1;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_1 = _loc_2.val;
                    _loc_2.val = _loc_3.val;
                    _loc_3.val = _loc_1;
                    _loc_2 = _loc_2.next;
                    _loc_3 = _loc_3.prev;
                }
            }
            return;
        }// end function

        public function removeTail() : Object
        {
            var _loc_2:* = null as DLLNode;
            var _loc_4:* = null as Object;
            var _loc_1:* = tail;
            if (head == tail)
            {
                _loc_2 = null;
                tail = _loc_2;
                head = _loc_2;
            }
            else
            {
                tail = tail.prev;
                _loc_1.prev = null;
                if (_circular)
                {
                    tail.next = head;
                    head.prev = tail;
                }
                else
                {
                    tail.next = null;
                }
            }
            (_size - 1);
            var _loc_3:* = _loc_1.val;
            if (_reservedSize > 0)
            {
            }
            if (_poolSize < _reservedSize)
            {
                _loc_2 = _loc_1;
                _tailPool.next = _loc_2;
                _tailPool = _loc_2;
                _loc_4 = null;
                _loc_1.val = _loc_4;
                (_poolSize + 1);
            }
            else
            {
                _loc_1._list = null;
            }
            return _loc_3;
        }// end function

        public function removeHead() : Object
        {
            var _loc_2:* = null as DLLNode;
            var _loc_4:* = null as Object;
            var _loc_1:* = head;
            if (head == tail)
            {
                _loc_2 = null;
                tail = _loc_2;
                head = _loc_2;
            }
            else
            {
                head = head.next;
                _loc_1.next = null;
                if (_circular)
                {
                    head.prev = tail;
                    tail.next = head;
                }
                else
                {
                    head.prev = null;
                }
            }
            (_size - 1);
            var _loc_3:* = _loc_1.val;
            if (_reservedSize > 0)
            {
            }
            if (_poolSize < _reservedSize)
            {
                _loc_2 = _loc_1;
                _tailPool.next = _loc_2;
                _tailPool = _loc_2;
                _loc_4 = null;
                _loc_1.val = _loc_4;
                (_poolSize + 1);
            }
            else
            {
                _loc_1._list = null;
            }
            return _loc_3;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_2:* = param1;
            var _loc_3:* = _size;
            if (_loc_3 == 0)
            {
                return false;
            }
            var _loc_4:* = head;
            while (_loc_4 != null)
            {
                
                if (_loc_4.val == _loc_2)
                {
                    _loc_4 = unlink(_loc_4);
                    continue;
                }
                _loc_4 = _loc_4.next;
            }
            return _size < _loc_3;
        }// end function

        public function prepend(param1:Object) : DLLNode
        {
            var _loc_3:* = null as DLLNode;
            if (_reservedSize != 0)
            {
            }
            var _loc_2:* = _poolSize == 0 ? (new DLLNode(param1, this)) : (_loc_3 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_3.next = null, _loc_3.val = param1, _loc_3);
            _loc_2.next = head;
            if (head != null)
            {
                head.prev = _loc_2;
            }
            else
            {
                tail = _loc_2;
            }
            head = _loc_2;
            if (_circular)
            {
                tail.next = head;
                head.prev = tail;
            }
            (_size + 1);
            return _loc_2;
        }// end function

        public function popDown() : void
        {
            var _loc_1:* = null as DLLNode;
            if (_size > 1)
            {
                _loc_1 = tail;
                if (tail.prev == head)
                {
                    tail = head;
                    tail.next = null;
                    head = _loc_1;
                    head.prev = null;
                    head.next = tail;
                    tail.prev = head;
                }
                else
                {
                    tail = tail.prev;
                    tail.next = null;
                    head.prev = _loc_1;
                    _loc_1.prev = null;
                    _loc_1.next = head;
                    head = _loc_1;
                }
                if (_circular)
                {
                    tail.next = head;
                    head.prev = tail;
                }
            }
            return;
        }// end function

        public function open() : void
        {
            if (!_circular)
            {
                return;
            }
            _circular = false;
            if (head != null)
            {
                tail.next = null;
                head.prev = null;
            }
            return;
        }// end function

        public function nodeOf(param1:Object, param2:DLLNode = ) : DLLNode
        {
            var _loc_6:int = 0;
            if (param2 == null)
            {
                param2 = head;
            }
            var _loc_3:* = param2;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_3.val == param1)
                {
                    break;
                }
                _loc_3 = _loc_3.next;
            }
            return _loc_3;
        }// end function

        public function merge(param1:DLL) : void
        {
            var _loc_2:* = null as DLLNode;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (param1.head != null)
            {
                _loc_2 = param1.head;
                _loc_3 = 0;
                _loc_4 = param1._size;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_3++;
                    _loc_5 = _loc_3;
                    _loc_2._list = this;
                    _loc_2 = _loc_2.next;
                }
                if (head != null)
                {
                    tail.next = param1.head;
                    param1.head.prev = tail;
                    tail = param1.tail;
                }
                else
                {
                    head = param1.head;
                    tail = param1.tail;
                }
                _size = _size + param1._size;
                if (_circular)
                {
                    tail.next = head;
                    head.prev = tail;
                }
            }
            return;
        }// end function

        public function lastNodeOf(param1:Object, param2:DLLNode = ) : DLLNode
        {
            var _loc_6:int = 0;
            if (param2 == null)
            {
                param2 = tail;
            }
            var _loc_3:* = param2;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_3.val == param1)
                {
                    break;
                }
                _loc_3 = _loc_3.prev;
            }
            return _loc_3;
        }// end function

        public function join(param1:String) : String
        {
            var _loc_3:* = null as DLLNode;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:String = "";
            if (_size > 0)
            {
                _loc_3 = head;
                _loc_4 = 0;
                _loc_5 = _size - 1;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_2 = _loc_2 + (Std.string(_loc_3.val) + param1);
                    _loc_3 = _loc_3.next;
                }
                _loc_2 = _loc_2 + Std.string(_loc_3.val);
            }
            return _loc_2;
        }// end function

        public function iterator() : Itr
        {
            if (_circular)
            {
                return new CircularDLLIterator(this);
            }
            else
            {
            }
            return new DLLIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function isCircular() : Boolean
        {
            return _circular;
        }// end function

        public function insertBefore(param1:DLLNode, param2:Object) : DLLNode
        {
            var _loc_4:* = null as DLLNode;
            if (_reservedSize != 0)
            {
            }
            var _loc_3:* = _poolSize == 0 ? (new DLLNode(param2, this)) : (_loc_4 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_4.next = null, _loc_4.val = param2, _loc_4);
            param1._insertBefore(_loc_3);
            if (param1 == head)
            {
                head = _loc_3;
                if (_circular)
                {
                    head.prev = tail;
                }
            }
            (_size + 1);
            return _loc_3;
        }// end function

        public function insertAfter(param1:DLLNode, param2:Object) : DLLNode
        {
            var _loc_4:* = null as DLLNode;
            if (_reservedSize != 0)
            {
            }
            var _loc_3:* = _poolSize == 0 ? (new DLLNode(param2, this)) : (_loc_4 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_4.next = null, _loc_4.val = param2, _loc_4);
            param1._insertAfter(_loc_3);
            if (param1 == tail)
            {
                tail = _loc_3;
                if (_circular)
                {
                    tail.next = head;
                }
            }
            (_size + 1);
            return _loc_3;
        }// end function

        public function getNodeAt(param1:int) : DLLNode
        {
            var _loc_4:int = 0;
            var _loc_2:* = head;
            var _loc_3:int = 0;
            while (_loc_3 < param1)
            {
                
                _loc_3++;
                _loc_4 = _loc_3;
                _loc_2 = _loc_2.next;
            }
            return _loc_2;
        }// end function

        public function free() : void
        {
            var _loc_3:* = null as DLLNode;
            var _loc_4:* = null as DLLNode;
            var _loc_1:Object = null;
            var _loc_2:* = head;
            while (_loc_2 != null)
            {
                
                _loc_3 = _loc_2.next;
                _loc_4 = null;
                _loc_2.prev = _loc_4;
                _loc_2.next = _loc_4;
                _loc_2.val = _loc_1;
                _loc_2 = _loc_3;
            }
            _loc_3 = null;
            tail = _loc_3;
            head = _loc_3;
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

        public function fill(param1:Object, param2:Array = , param3:int = 0) : void
        {
            var _loc_6:int = 0;
            if (param3 > 0)
            {
            }
            else
            {
                param3 = _size;
            }
            var _loc_4:* = head;
            var _loc_5:int = 0;
            while (_loc_5 < param3)
            {
                
                _loc_5++;
                _loc_6 = _loc_5;
                _loc_4.val = param1;
                _loc_4 = _loc_4.next;
            }
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = param1;
            var _loc_3:* = head;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_loc_3.val == _loc_2)
                {
                    return true;
                }
                _loc_3 = _loc_3.next;
            }
            return false;
        }// end function

        public function concat(param1:DLL) : DLL
        {
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as DLLNode;
            var _loc_6:* = null as DLLNode;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:* = null as DLLNode;
            var _loc_2:* = new DLL();
            var _loc_3:* = param1._size;
            if (_loc_3 > 0)
            {
                _loc_4 = param1.tail;
                _loc_6 = new DLLNode(_loc_4.val, _loc_2);
                _loc_2.tail = _loc_6;
                _loc_5 = _loc_6;
                _loc_4 = _loc_4.prev;
                _loc_7 = _loc_3 - 1;
                do
                {
                    
                    _loc_6 = new DLLNode(_loc_4.val, _loc_2);
                    _loc_6.next = _loc_5;
                    _loc_5.prev = _loc_6;
                    _loc_5 = _loc_6;
                    _loc_4 = _loc_4.prev;
                    _loc_7--;
                }while (_loc_7 > 0)
                _loc_2.head = _loc_5;
                _loc_2._size = _loc_3;
                if (_size > 0)
                {
                    _loc_6 = tail;
                    _loc_8 = _size;
                    do
                    {
                        
                        _loc_9 = new DLLNode(_loc_6.val, _loc_2);
                        _loc_9.next = _loc_5;
                        _loc_5.prev = _loc_9;
                        _loc_5 = _loc_9;
                        _loc_6 = _loc_6.prev;
                        _loc_8--;
                    }while (_loc_8 > 0)
                    _loc_2.head = _loc_5;
                    _loc_2._size = _loc_2._size + _size;
                }
            }
            else if (_size > 0)
            {
                _loc_4 = tail;
                _loc_6 = new DLLNode(_loc_4.val, this);
                _loc_2.tail = _loc_6;
                _loc_5 = _loc_6;
                _loc_4 = _loc_4.prev;
                _loc_7 = _size - 1;
                do
                {
                    
                    _loc_6 = new DLLNode(_loc_4.val, this);
                    _loc_6.next = _loc_5;
                    _loc_5.prev = _loc_6;
                    _loc_5 = _loc_6;
                    _loc_4 = _loc_4.prev;
                    _loc_7--;
                }while (_loc_7 > 0)
                _loc_2.head = _loc_5;
                _loc_2._size = _size;
            }
            return _loc_2;
        }// end function

        public function close() : void
        {
            if (_circular)
            {
                return;
            }
            _circular = true;
            if (head != null)
            {
                tail.next = head;
                head.prev = tail;
            }
            return;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_5:* = null as DLLNode;
            var _loc_6:* = null as DLLNode;
            var _loc_7:* = null as DLLNode;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:* = null as DLLNode;
            var _loc_12:* = null as DLLNode;
            var _loc_13:* = null as Cloneable;
            var _loc_3:* = param2;
            if (_size == 0)
            {
                return new DLL(_reservedSize, maxSize);
            }
            var _loc_4:* = new DLL();
            new DLL()._size = _size;
            if (param1)
            {
                _loc_5 = head;
                _loc_7 = new DLLNode(head.val, _loc_4);
                _loc_4.head = _loc_7;
                _loc_6 = _loc_7;
                if (_size == 1)
                {
                    _loc_4.tail = _loc_4.head;
                    return _loc_4;
                }
                _loc_5 = _loc_5.next;
                _loc_8 = 1;
                _loc_9 = _size - 1;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_8++;
                    _loc_10 = _loc_8;
                    _loc_7 = _loc_6;
                    _loc_11 = _loc_5;
                    _loc_12 = new DLLNode(_loc_5.val, _loc_4);
                    _loc_6.next = _loc_12;
                    _loc_6 = _loc_12;
                    _loc_6.prev = _loc_7;
                    _loc_11 = _loc_5;
                    _loc_5 = _loc_11.next;
                }
                _loc_7 = _loc_6;
                _loc_11 = new DLLNode(_loc_5.val, _loc_4);
                _loc_6.next = _loc_11;
                _loc_4.tail = _loc_11;
                _loc_4.tail.prev = _loc_7;
            }
            else if (_loc_3 == null)
            {
                _loc_5 = head;
                _loc_13 = head.val;
                _loc_7 = new DLLNode(_loc_13.clone(), _loc_4);
                _loc_4.head = _loc_7;
                _loc_6 = _loc_7;
                if (_size == 1)
                {
                    _loc_4.tail = _loc_4.head;
                    return _loc_4;
                }
                _loc_5 = _loc_5.next;
                _loc_8 = 1;
                _loc_9 = _size - 1;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_8++;
                    _loc_10 = _loc_8;
                    _loc_7 = _loc_6;
                    _loc_11 = _loc_5;
                    _loc_13 = _loc_5.val;
                    _loc_12 = new DLLNode(_loc_13.clone(), _loc_4);
                    _loc_6.next = _loc_12;
                    _loc_6 = _loc_12;
                    _loc_6.prev = _loc_7;
                    _loc_11 = _loc_5;
                    _loc_5 = _loc_11.next;
                }
                _loc_13 = _loc_5.val;
                _loc_7 = _loc_6;
                _loc_11 = new DLLNode(_loc_13.clone(), _loc_4);
                _loc_6.next = _loc_11;
                _loc_4.tail = _loc_11;
                _loc_4.tail.prev = _loc_7;
            }
            else
            {
                _loc_5 = head;
                _loc_7 = new DLLNode(this._loc_3(head.val), _loc_4);
                _loc_4.head = _loc_7;
                _loc_6 = _loc_7;
                if (_size == 1)
                {
                    _loc_4.tail = _loc_4.head;
                    return _loc_4;
                }
                _loc_5 = _loc_5.next;
                _loc_8 = 1;
                _loc_9 = _size - 1;
                while (_loc_8 < _loc_9)
                {
                    
                    _loc_8++;
                    _loc_10 = _loc_8;
                    _loc_7 = _loc_6;
                    _loc_11 = _loc_5;
                    _loc_12 = new DLLNode(this._loc_3(_loc_5.val), _loc_4);
                    _loc_6.next = _loc_12;
                    _loc_6 = _loc_12;
                    _loc_6.prev = _loc_7;
                    _loc_11 = _loc_5;
                    _loc_5 = _loc_11.next;
                }
                _loc_7 = _loc_6;
                _loc_11 = new DLLNode(this._loc_3(_loc_5.val), _loc_4);
                _loc_6.next = _loc_11;
                _loc_4.tail = _loc_11;
                _loc_4.tail.prev = _loc_7;
            }
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:* = null as Object;
            var _loc_3:* = null as DLLNode;
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as Object;
            var _loc_6:* = null as DLLNode;
            var _loc_7:* = null as Object;
            if (!param1)
            {
            }
            if (_reservedSize > 0)
            {
                _loc_2 = null;
                _loc_3 = head;
                while (_loc_3 != null)
                {
                    
                    _loc_4 = _loc_3.next;
                    _loc_3.prev = null;
                    _loc_3.next = null;
                    _loc_5 = _loc_3.val;
                    if (_reservedSize > 0)
                    {
                    }
                    if (_poolSize < _reservedSize)
                    {
                        _loc_6 = _loc_3;
                        _tailPool.next = _loc_6;
                        _tailPool = _loc_6;
                        _loc_7 = null;
                        _loc_3.val = _loc_7;
                        (_poolSize + 1);
                    }
                    else
                    {
                        _loc_3._list = null;
                    }
                    _loc_3 = _loc_4;
                }
            }
            _loc_3 = null;
            tail = _loc_3;
            head = _loc_3;
            _size = 0;
            return;
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
            var _loc_4:* = head;
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

        public function append(param1:Object) : DLLNode
        {
            var _loc_3:* = null as DLLNode;
            if (_reservedSize != 0)
            {
            }
            var _loc_2:* = _poolSize == 0 ? (new DLLNode(param1, this)) : (_loc_3 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_3.next = null, _loc_3.val = param1, _loc_3);
            if (tail != null)
            {
                tail.next = _loc_2;
                _loc_2.prev = tail;
            }
            else
            {
                head = _loc_2;
            }
            tail = _loc_2;
            if (_circular)
            {
                tail.next = head;
                head.prev = tail;
            }
            (_size + 1);
            return _loc_2;
        }// end function

        public function _valid(param1:DLLNode) : Boolean
        {
            return param1 != null;
        }// end function

        public function _putNode(param1:DLLNode) : Object
        {
            var _loc_3:* = null as DLLNode;
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
                (_poolSize + 1);
            }
            else
            {
                param1._list = null;
            }
            return _loc_2;
        }// end function

        public function _mergeSortComparable(param1:DLLNode) : DLLNode
        {
            var _loc_3:* = null as DLLNode;
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as DLLNode;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_2:* = param1;
            var _loc_6:DLLNode = null;
            var _loc_7:int = 1;
            while (true)
            {
                
                _loc_3 = _loc_2;
                _loc_6 = null;
                _loc_2 = _loc_6;
                _loc_8 = 0;
                while (_loc_3 != null)
                {
                    
                    _loc_8++;
                    _loc_9 = 0;
                    _loc_4 = _loc_3;
                    _loc_12 = 0;
                    while (_loc_12 < _loc_7)
                    {
                        
                        _loc_12++;
                        _loc_13 = _loc_12;
                        _loc_9++;
                        _loc_4 = _loc_4.next;
                        if (_loc_4 == null)
                        {
                            break;
                        }
                    }
                    _loc_10 = _loc_7;
                    do
                    {
                        
                        if (_loc_9 == 0)
                        {
                            _loc_5 = _loc_4;
                            _loc_4 = _loc_4.next;
                            _loc_10--;
                        }
                        else
                        {
                            if (_loc_10 != 0)
                            {
                            }
                            if (_loc_4 == null)
                            {
                                _loc_5 = _loc_3;
                                _loc_3 = _loc_3.next;
                                _loc_9--;
                            }
                            else if (_loc_3.val.compare(_loc_4.val) >= 0)
                            {
                                _loc_5 = _loc_3;
                                _loc_3 = _loc_3.next;
                                _loc_9--;
                            }
                            else
                            {
                                _loc_5 = _loc_4;
                                _loc_4 = _loc_4.next;
                                _loc_10--;
                            }
                        }
                        if (_loc_6 != null)
                        {
                            _loc_6.next = _loc_5;
                        }
                        else
                        {
                            _loc_2 = _loc_5;
                        }
                        _loc_5.prev = _loc_6;
                        _loc_6 = _loc_5;
                        if (_loc_9 <= 0)
                        {
                            if (_loc_10 > 0)
                            {
                            }
                        }
                    }while (_loc_4 != null)
                    _loc_3 = _loc_4;
                }
                param1.prev = _loc_6;
                _loc_6.next = null;
                if (_loc_8 <= 1)
                {
                    break;
                }
                _loc_7 = _loc_7 << 1;
            }
            _loc_2.prev = null;
            tail = _loc_6;
            return _loc_2;
        }// end function

        public function _mergeSort(param1:DLLNode, param2:Function) : DLLNode
        {
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as DLLNode;
            var _loc_6:* = null as DLLNode;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_3:* = param1;
            var _loc_7:DLLNode = null;
            var _loc_8:int = 1;
            while (true)
            {
                
                _loc_4 = _loc_3;
                _loc_7 = null;
                _loc_3 = _loc_7;
                _loc_9 = 0;
                while (_loc_4 != null)
                {
                    
                    _loc_9++;
                    _loc_10 = 0;
                    _loc_5 = _loc_4;
                    _loc_13 = 0;
                    while (_loc_13 < _loc_8)
                    {
                        
                        _loc_13++;
                        _loc_14 = _loc_13;
                        _loc_10++;
                        _loc_5 = _loc_5.next;
                        if (_loc_5 == null)
                        {
                            break;
                        }
                    }
                    _loc_11 = _loc_8;
                    do
                    {
                        
                        if (_loc_10 == 0)
                        {
                            _loc_6 = _loc_5;
                            _loc_5 = _loc_5.next;
                            _loc_11--;
                        }
                        else
                        {
                            if (_loc_11 != 0)
                            {
                            }
                            if (_loc_5 == null)
                            {
                                _loc_6 = _loc_4;
                                _loc_4 = _loc_4.next;
                                _loc_10--;
                            }
                            else if (this.param2(_loc_5.val, _loc_4.val) >= 0)
                            {
                                _loc_6 = _loc_4;
                                _loc_4 = _loc_4.next;
                                _loc_10--;
                            }
                            else
                            {
                                _loc_6 = _loc_5;
                                _loc_5 = _loc_5.next;
                                _loc_11--;
                            }
                        }
                        if (_loc_7 != null)
                        {
                            _loc_7.next = _loc_6;
                        }
                        else
                        {
                            _loc_3 = _loc_6;
                        }
                        _loc_6.prev = _loc_7;
                        _loc_7 = _loc_6;
                        if (_loc_10 <= 0)
                        {
                            if (_loc_11 > 0)
                            {
                            }
                        }
                    }while (_loc_5 != null)
                    _loc_4 = _loc_5;
                }
                param1.prev = _loc_7;
                _loc_7.next = null;
                if (_loc_9 <= 1)
                {
                    break;
                }
                _loc_8 = _loc_8 << 1;
            }
            _loc_3.prev = null;
            tail = _loc_7;
            return _loc_3;
        }// end function

        public function _insertionSortComparable(param1:DLLNode) : DLLNode
        {
            var _loc_4:* = null as DLLNode;
            var _loc_5:* = null as DLLNode;
            var _loc_6:* = null as Object;
            var _loc_7:* = null as DLLNode;
            var _loc_2:* = param1;
            var _loc_3:* = _loc_2.next;
            while (_loc_3 != null)
            {
                
                _loc_4 = _loc_3.next;
                _loc_5 = _loc_3.prev;
                _loc_6 = _loc_3.val;
                if (_loc_5.val.compare(_loc_6) < 0)
                {
                    _loc_7 = _loc_5;
                    while (_loc_7.prev != null)
                    {
                        
                        if (_loc_7.prev.val.compare(_loc_6) < 0)
                        {
                            _loc_7 = _loc_7.prev;
                            continue;
                        }
                        break;
                    }
                    if (_loc_4 != null)
                    {
                        _loc_5.next = _loc_4;
                        _loc_4.prev = _loc_5;
                    }
                    else
                    {
                        _loc_5.next = null;
                        tail = _loc_5;
                    }
                    if (_loc_7 == _loc_2)
                    {
                        _loc_3.prev = null;
                        _loc_3.next = _loc_7;
                        _loc_7.prev = _loc_3;
                        _loc_2 = _loc_3;
                    }
                    else
                    {
                        _loc_3.prev = _loc_7.prev;
                        _loc_7.prev.next = _loc_3;
                        _loc_3.next = _loc_7;
                        _loc_7.prev = _loc_3;
                    }
                }
                _loc_3 = _loc_4;
            }
            return _loc_2;
        }// end function

        public function _insertionSort(param1:DLLNode, param2:Function) : DLLNode
        {
            var _loc_5:* = null as DLLNode;
            var _loc_6:* = null as DLLNode;
            var _loc_7:* = null as Object;
            var _loc_8:* = null as DLLNode;
            var _loc_3:* = param1;
            var _loc_4:* = _loc_3.next;
            while (_loc_4 != null)
            {
                
                _loc_5 = _loc_4.next;
                _loc_6 = _loc_4.prev;
                _loc_7 = _loc_4.val;
                if (this.param2(_loc_7, _loc_6.val) < 0)
                {
                    _loc_8 = _loc_6;
                    while (_loc_8.prev != null)
                    {
                        
                        if (this.param2(_loc_7, _loc_8.prev.val) < 0)
                        {
                            _loc_8 = _loc_8.prev;
                            continue;
                        }
                        break;
                    }
                    if (_loc_5 != null)
                    {
                        _loc_6.next = _loc_5;
                        _loc_5.prev = _loc_6;
                    }
                    else
                    {
                        _loc_6.next = null;
                        tail = _loc_6;
                    }
                    if (_loc_8 == _loc_3)
                    {
                        _loc_4.prev = null;
                        _loc_4.next = _loc_8;
                        _loc_8.prev = _loc_4;
                        _loc_3 = _loc_4;
                    }
                    else
                    {
                        _loc_4.prev = _loc_8.prev;
                        _loc_8.prev.next = _loc_4;
                        _loc_4.next = _loc_8;
                        _loc_8.prev = _loc_4;
                    }
                }
                _loc_4 = _loc_5;
            }
            return _loc_3;
        }// end function

        public function _getNode(param1:Object) : DLLNode
        {
            var _loc_2:* = null as DLLNode;
            if (_reservedSize != 0)
            {
            }
            if (_poolSize == 0)
            {
                return new DLLNode(param1, this);
            }
            else
            {
                _loc_2 = _headPool;
                _headPool = _headPool.next;
                (_poolSize - 1);
            }
            _loc_2.next = null;
            _loc_2.val = param1;
            return _loc_2;
        }// end function

        public function __unlink(param1:Object) : void
        {
            param1._unlink();
            return;
        }// end function

        public function __list(param1:Object, param2:DLL) : void
        {
            param1._list = param2;
            return;
        }// end function

        public function __insertBefore(param1:Object, param2:DLLNode) : void
        {
            param1._insertBefore(param2);
            return;
        }// end function

        public function __insertAfter(param1:Object, param2:DLLNode) : void
        {
            param1._insertAfter(param2);
            return;
        }// end function

    }
}
