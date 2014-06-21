package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class ArrayedQueue extends Object implements Queue
    {
        public var maxSize:int;
        public var key:int;
        public var capacity:int;
        public var _sizeLevel:int;
        public var _size:int;
        public var _isResizable:Boolean;
        public var _front:int;
        public var _capacity:int;
        public var _a:Array;

        public function ArrayedQueue(param1:int = 0, param2:Boolean = true, param3:int = -1) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            maxSize = -1;
            _capacity = param1;
            _isResizable = param2;
            _sizeLevel = 0;
            var _loc_4:int = 0;
            _front = 0;
            _size = _loc_4;
            var _loc_5:* = new Array(_capacity);
            _a = new Array(_capacity);
            _loc_4 = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_4;
            return;
        }// end function

        public function walk(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_2:int = 0;
            var _loc_3:* = _capacity;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = (_loc_4 + _front) % _capacity;
                _a[_loc_5] = this.param1(_a[_loc_5], _loc_4);
            }
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{ArrayedQueue, size/capacity: %d/%d}", [_size, _capacity]);
        }// end function

        public function toDA() : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_1:* = new DA(_size);
            var _loc_2:int = 0;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = _loc_1._size;
                _loc_1._a[_loc_5] = _a[(_loc_4 + _front) % _capacity];
                if (_loc_5 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_5:int = 0;
            var _loc_2:* = new Array(_size);
            var _loc_1:* = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_loc_5] = _a[(_loc_5 + _front) % _capacity];
            }
            return _loc_1;
        }// end function

        public function swp(param1:int, param2:int) : void
        {
            var _loc_3:* = _a[(param1 + _front) % _capacity];
            _a[(param1 + _front) % _capacity] = _a[(param2 + _front) % _capacity];
            _a[(param2 + _front) % _capacity] = _loc_3;
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
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_2:* = _size;
            if (param1 == null)
            {
                _loc_3 = Math;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4 = (_loc_3.random() * _loc_2 + _front) % _capacity;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_4];
                    _a[_loc_4] = _loc_5;
                }
            }
            else
            {
                _loc_4 = 0;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4++;
                    _loc_6 = (param1._a[_loc_4] * _loc_2 + _front) % _capacity;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_6];
                    _a[_loc_6] = _loc_5;
                }
            }
            return;
        }// end function

        public function set(param1:int, param2:Object) : void
        {
            _a[(param1 + _front) % _capacity] = param2;
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:* = null as Array;
            var _loc_14:* = null as Array;
            var _loc_2:* = param1;
            if (_size == 0)
            {
                return false;
            }
            var _loc_3:Object = null;
            var _loc_4:* = _size;
            var _loc_5:Boolean = false;
            while (_size > 0)
            {
                
                _loc_5 = false;
                _loc_6 = 0;
                _loc_7 = _size;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    if (_a[(_loc_8 + _front) % _capacity] == _loc_2)
                    {
                        _loc_5 = true;
                        _a[(_loc_8 + _front) % _capacity] = _loc_3;
                        if (_loc_8 == 0)
                        {
                            ++_front;
                            if (++_front == _capacity)
                            {
                                _front = 0;
                            }
                            (_size - 1);
                        }
                        else if (_loc_8 == (_size - 1))
                        {
                            (_size - 1);
                        }
                        else
                        {
                            _loc_9 = _front + _loc_8;
                            _loc_10 = _front + _size - 1;
                            _loc_11 = _loc_9;
                            while (_loc_11 < _loc_10)
                            {
                                
                                _loc_11++;
                                _loc_12 = _loc_11;
                                _a[_loc_12 % _capacity] = _a[(_loc_12 + 1) % _capacity];
                            }
                            _a[_loc_10 % _capacity] = _loc_3;
                            (_size - 1);
                        }
                        break;
                    }
                }
                if (!_loc_5)
                {
                    break;
                }
            }
            if (_isResizable)
            {
            }
            if (_size < _loc_4)
            {
                if (_sizeLevel > 0)
                {
                }
                if (_capacity > 2)
                {
                    _loc_6 = _capacity;
                    while (_size <= _loc_6 >> 2)
                    {
                        
                        _loc_6 = _loc_6 >> 2;
                        (_sizeLevel - 1);
                    }
                    _loc_14 = new Array(_loc_6);
                    _loc_13 = _loc_14;
                    _loc_7 = 0;
                    _loc_8 = _size;
                    while (_loc_7 < _loc_8)
                    {
                        
                        _loc_7++;
                        _loc_9 = _loc_7;
                        _loc_10 = _front;
                        (_front + 1);
                        _loc_13[_loc_9] = _a[_loc_10];
                        if (_front == _capacity)
                        {
                            _front = 0;
                        }
                    }
                    _a = _loc_13;
                    _front = 0;
                    _capacity = _loc_6;
                }
            }
            return _size < _loc_4;
        }// end function

        public function peek() : Object
        {
            return _a[_front];
        }// end function

        public function pack() : void
        {
            var _loc_4:int = 0;
            var _loc_1:* = _front + _size;
            var _loc_2:int = 0;
            var _loc_3:* = _capacity - _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[(_loc_4 + _loc_1) % _capacity] = null;
            }
            return;
        }// end function

        public function iterator() : Itr
        {
            return new ArrayedQueueIterator(this);
        }// end function

        public function isFull() : Boolean
        {
            return _size == _capacity;
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function get(param1:int) : Object
        {
            return _a[(param1 + _front) % _capacity];
        }// end function

        public function free() : void
        {
            var _loc_3:int = 0;
            var _loc_1:int = 0;
            var _loc_2:* = _capacity;
            while (_loc_1 < _loc_2)
            {
                
                _loc_1++;
                _loc_3 = _loc_1;
                _a[_loc_3] = null;
            }
            _a = null;
            return;
        }// end function

        public function fill(param1:Object, param2:int = 0) : void
        {
            var _loc_4:int = 0;
            if (param2 > 0)
            {
            }
            else
            {
                param2 = _capacity;
            }
            var _loc_3:int = 0;
            while (_loc_3 < param2)
            {
                
                _loc_3++;
                _loc_4 = _loc_3;
                _a[(_loc_4 + _front) % _capacity] = param1;
            }
            _size = param2;
            return;
        }// end function

        public function enqueue(param1:Object) : void
        {
            var _loc_3:* = null as Array;
            var _loc_4:* = null as Array;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_2:* = param1;
            if (_capacity == _size)
            {
                if (_isResizable)
                {
                    (_sizeLevel + 1);
                    _loc_4 = new Array(_capacity << 1);
                    _loc_3 = _loc_4;
                    _loc_5 = 0;
                    _loc_6 = _size;
                    while (_loc_5 < _loc_6)
                    {
                        
                        _loc_5++;
                        _loc_7 = _loc_5;
                        _loc_8 = _front;
                        (_front + 1);
                        _loc_3[_loc_7] = _a[_loc_8];
                        if (_front == _capacity)
                        {
                            _front = 0;
                        }
                    }
                    _a = _loc_3;
                    _front = 0;
                    _capacity = _capacity << 1;
                }
            }
            _loc_5 = _size;
            (_size + 1);
            _a[(_loc_5 + _front) % _capacity] = _loc_2;
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:Object = null;
            _a[(_front == 0 ? (_capacity) : (_front)) - 1] = _loc_1;
            return;
        }// end function

        public function dequeue() : Object
        {
            var _loc_2:int = 0;
            var _loc_3:* = null as Array;
            var _loc_4:* = null as Array;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            _loc_2 = _front;
            (_front + 1);
            var _loc_1:* = _a[_loc_2];
            if (_front == _capacity)
            {
                _front = 0;
            }
            (_size - 1);
            if (_isResizable)
            {
            }
            if (_sizeLevel > 0)
            {
                if (_size == _capacity >> 2)
                {
                    (_sizeLevel - 1);
                    _loc_4 = new Array(_capacity >> 2);
                    _loc_3 = _loc_4;
                    _loc_2 = 0;
                    _loc_5 = _size;
                    while (_loc_2 < _loc_5)
                    {
                        
                        _loc_2++;
                        _loc_6 = _loc_2;
                        _loc_7 = _front;
                        (_front + 1);
                        _loc_3[_loc_6] = _a[_loc_7];
                        if (_front == _capacity)
                        {
                            _front = 0;
                        }
                    }
                    _a = _loc_3;
                    _front = 0;
                    _capacity = _capacity >> 2;
                }
            }
            return _loc_1;
        }// end function

        public function cpy(param1:int, param2:int) : void
        {
            _a[(param1 + _front) % _capacity] = _a[(param2 + _front) % _capacity];
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_2:* = param1;
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                if (_a[(_loc_5 + _front) % _capacity] == _loc_2)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new ArrayedQueue(_capacity, _isResizable, maxSize);
            new ArrayedQueue(_capacity, _isResizable, maxSize)._sizeLevel = _sizeLevel;
            if (_capacity == 0)
            {
                return _loc_4;
            }
            var _loc_5:* = _loc_4._a;
            if (param1)
            {
                _loc_6 = 0;
                _loc_7 = _size;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    _loc_5[_loc_8] = _a[_loc_8];
                }
            }
            else if (_loc_3 == null)
            {
                _loc_9 = null;
                _loc_6 = 0;
                _loc_7 = _size;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    _loc_9 = _a[_loc_8];
                    _loc_5[_loc_8] = _loc_9.clone();
                }
            }
            else
            {
                _loc_6 = 0;
                _loc_7 = _size;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    _loc_5[_loc_8] = this._loc_3(_a[_loc_8]);
                }
            }
            _loc_4._front = _front;
            _loc_4._size = _size;
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:int = 0;
            var _loc_3:* = null as Object;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:* = null as Array;
            if (param1)
            {
                _loc_2 = _front;
                _loc_3 = null;
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_2++;
                    _a[_loc_2 % _capacity] = _loc_3;
                }
                if (_isResizable)
                {
                }
                if (_sizeLevel > 0)
                {
                    _capacity = _capacity >> _sizeLevel;
                    _sizeLevel = 0;
                    _loc_7 = new Array(_capacity);
                    _a = _loc_7;
                }
            }
            _loc_2 = 0;
            _size = _loc_2;
            _front = _loc_2;
            return;
        }// end function

        public function back() : Object
        {
            return _a[((_size - 1) + _front) % _capacity];
        }// end function

        public function assign(param1:Class, param2:Array = , param3:int = 0) : void
        {
            var _loc_5:int = 0;
            if (param3 > 0)
            {
            }
            else
            {
                param3 = _capacity;
            }
            var _loc_4:int = 0;
            while (_loc_4 < param3)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _a[(_loc_5 + _front) % _capacity] = Instance.create(param1, param2);
            }
            _size = param3;
            return;
        }// end function

        public function _pack(param1:int) : void
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_3:* = new Array(param1);
            var _loc_2:* = _loc_3;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_7 = _front;
                (_front + 1);
                _loc_2[_loc_6] = _a[_loc_7];
                if (_front == _capacity)
                {
                    _front = 0;
                }
            }
            _a = _loc_2;
            return;
        }// end function

        public function _capacityGetter() : int
        {
            return _capacity;
        }// end function

        public function __set(param1:int, param2:Object) : void
        {
            _a[param1] = param2;
            return;
        }// end function

        public function __get(param1:int) : Object
        {
            return _a[param1];
        }// end function

    }
}
