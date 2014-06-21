package de.polygonal.ds
{

    public class ArrayConvert extends Object
    {

        public function ArrayConvert() : void
        {
            return;
        }// end function

        public static function toArray2(param1:Array, param2:int, param3:int) : Array2
        {
            var _loc_8:int = 0;
            var _loc_4:* = new Array2(param2, param3);
            var _loc_5:* = new Array2(param2, param3)._a;
            var _loc_6:int = 0;
            var _loc_7:* = param1.length;
            while (_loc_6 < _loc_7)
            {
                
                _loc_6++;
                _loc_8 = _loc_6;
                _loc_5[_loc_8] = param1[_loc_8];
            }
            return _loc_4;
        }// end function

        public static function toArray3(param1:Array, param2:int, param3:int, param4:int) : Array3
        {
            var _loc_9:int = 0;
            var _loc_5:* = new Array3(param2, param3, param4);
            var _loc_6:* = new Array3(param2, param3, param4)._a;
            var _loc_7:int = 0;
            var _loc_8:* = param1.length;
            while (_loc_7 < _loc_8)
            {
                
                _loc_7++;
                _loc_9 = _loc_7;
                _loc_6[_loc_9] = param1[_loc_9];
            }
            return _loc_5;
        }// end function

        public static function toArrayedQueue(param1:Array) : ArrayedQueue
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = null as Array;
            var _loc_7:* = null as Array;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_2:* = param1.length;
            if (_loc_2 > 0)
            {
            }
            var _loc_3:* = new ArrayedQueue((_loc_2 & (_loc_2 - 1)) == 0 ? (_loc_2) : (_loc_4 = _loc_2, _loc_4 = _loc_2 | _loc_4 >> 1, _loc_4 = _loc_2 | _loc_4 >> 1 | _loc_4 >> 2, _loc_4 = _loc_2 | _loc_4 >> 1 | _loc_4 >> 2 | _loc_4 >> 3, _loc_4 = _loc_2 | _loc_4 >> 1 | _loc_4 >> 2 | _loc_4 >> 3 | _loc_4 >> 4, _loc_4 = _loc_2 | _loc_4 >> 1 | _loc_4 >> 2 | _loc_4 >> 3 | _loc_4 >> 4 | _loc_4 >> 5, (_loc_4 + 1)));
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                if (_loc_3._capacity == _loc_3._size)
                {
                    if (_loc_3._isResizable)
                    {
                        (_loc_3._sizeLevel + 1);
                        _loc_7 = new Array(_loc_3._capacity << 1);
                        _loc_6 = _loc_7;
                        _loc_8 = 0;
                        _loc_9 = _loc_3._size;
                        while (_loc_8 < _loc_9)
                        {
                            
                            _loc_8++;
                            _loc_10 = _loc_8;
                            _loc_11 = _loc_3._front;
                            (_loc_3._front + 1);
                            _loc_6[_loc_10] = _loc_3._a[_loc_11];
                            if (_loc_3._front == _loc_3._capacity)
                            {
                                _loc_3._front = 0;
                            }
                        }
                        _loc_3._a = _loc_6;
                        _loc_3._front = 0;
                        _loc_3._capacity = _loc_3._capacity << 1;
                    }
                }
                _loc_8 = _loc_3._size;
                (_loc_3._size + 1);
                _loc_3._a[(_loc_8 + _loc_3._front) % _loc_3._capacity] = param1[_loc_5];
            }
            return _loc_3;
        }// end function

        public static function toArrayedStack(param1:Array) : ArrayedStack
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = new ArrayedStack(param1.length);
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = _loc_2._top;
                (_loc_2._top + 1);
                _loc_2._a[_loc_6] = param1[_loc_5];
            }
            return _loc_2;
        }// end function

        public static function toSLL(param1:Array) : SLL
        {
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:* = null as SLLNode;
            var _loc_8:* = null as SLLNode;
            var _loc_2:* = new SLL();
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = param1[_loc_5];
                if (_loc_2._reservedSize != 0)
                {
                }
                _loc_7 = _loc_2._poolSize == 0 ? (new SLLNode(_loc_6, _loc_2)) : (_loc_8 = _loc_2._headPool, _loc_2._headPool = _loc_2._headPool.next, _loc_2._poolSize - 1, _loc_8.val = _loc_6, _loc_8.next = null, _loc_8);
                if (_loc_2.tail != null)
                {
                    _loc_2.tail.next = _loc_7;
                }
                else
                {
                    _loc_2.head = _loc_7;
                }
                _loc_2.tail = _loc_7;
                (_loc_2._size + 1);
            }
            return _loc_2;
        }// end function

        public static function toDLL(param1:Array) : DLL
        {
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:* = null as DLLNode;
            var _loc_8:* = null as DLLNode;
            var _loc_2:* = new DLL();
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = param1[_loc_5];
                if (_loc_2._reservedSize != 0)
                {
                }
                _loc_7 = _loc_2._poolSize == 0 ? (new DLLNode(_loc_6, _loc_2)) : (_loc_8 = _loc_2._headPool, _loc_2._headPool = _loc_2._headPool.next, _loc_2._poolSize - 1, _loc_8.next = null, _loc_8.val = _loc_6, _loc_8);
                if (_loc_2.tail != null)
                {
                    _loc_2.tail.next = _loc_7;
                    _loc_7.prev = _loc_2.tail;
                }
                else
                {
                    _loc_2.head = _loc_7;
                }
                _loc_2.tail = _loc_7;
                if (_loc_2._circular)
                {
                    _loc_2.tail.next = _loc_2.head;
                    _loc_2.head.prev = _loc_2.tail;
                }
                (_loc_2._size + 1);
            }
            return _loc_2;
        }// end function

        public static function toLinkedQueue(param1:Array) : LinkedQueue
        {
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:* = null as LinkedQueueNode;
            var _loc_8:* = null as LinkedQueueNode;
            var _loc_2:* = new LinkedQueue();
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = param1[_loc_5];
                (_loc_2._size + 1);
                if (_loc_2._reservedSize != 0)
                {
                }
                _loc_7 = _loc_2._poolSize == 0 ? (new LinkedQueueNode(_loc_6)) : (_loc_8 = _loc_2._headPool, _loc_2._headPool = _loc_2._headPool.next, _loc_2._poolSize - 1, _loc_8.val = _loc_6, _loc_8);
                if (_loc_2._head == null)
                {
                    _loc_8 = _loc_7;
                    _loc_2._tail = _loc_8;
                    _loc_2._head = _loc_8;
                    _loc_2._head.next = _loc_2._tail;
                    continue;
                }
                _loc_2._tail.next = _loc_7;
                _loc_2._tail = _loc_7;
            }
            return _loc_2;
        }// end function

        public static function toLinkedStack(param1:Array) : LinkedStack
        {
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:* = null as LinkedStackNode;
            var _loc_8:* = null as LinkedStackNode;
            var _loc_2:* = new LinkedStack();
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = param1[_loc_5];
                if (_loc_2._reservedSize != 0)
                {
                }
                _loc_7 = _loc_2._poolSize == 0 ? (new LinkedStackNode(_loc_6)) : (_loc_8 = _loc_2._headPool, _loc_2._headPool = _loc_2._headPool.next, _loc_2._poolSize - 1, _loc_8.val = _loc_6, _loc_8);
                _loc_7.next = _loc_2._head;
                _loc_2._head = _loc_7;
                (_loc_2._top + 1);
            }
            return _loc_2;
        }// end function

        public static function toDA(param1:Array) : DA
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = new DA(param1.length);
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_6 = _loc_2._size;
                _loc_2._a[_loc_6] = param1[_loc_5];
                if (_loc_6 >= _loc_2._size)
                {
                    (_loc_2._size + 1);
                }
            }
            return _loc_2;
        }// end function

    }
}
