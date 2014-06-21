package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class DA extends Object implements Collection
    {
        public var maxSize:int;
        public var key:int;
        public var _size:int;
        public var _a:Array;

        public function DA(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Array;
            if (Boot.skip_constructor)
            {
                return;
            }
            _size = 0;
            maxSize = -1;
            if (param1 > 0)
            {
                _loc_3 = new Array(param1);
                _a = _loc_3;
            }
            else
            {
                _a = [];
            }
            var _loc_4:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_4;
            return;
        }// end function

        public function trim(param1:int) : void
        {
            _size = param1;
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{DA, size: %d}", [_size]);
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
                _loc_1._a[_loc_5] = _a[_loc_4];
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
                _loc_1[_loc_5] = _a[_loc_5];
            }
            return _loc_1;
        }// end function

        public function swp(param1:int, param2:int) : void
        {
            var _loc_3:* = _a[param1];
            _a[param1] = _a[param2];
            if (param1 >= _size)
            {
                (_size + 1);
            }
            _a[param2] = _loc_3;
            if (param2 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function swapWithBack(param1:int) : void
        {
            var _loc_3:* = null as Object;
            var _loc_2:* = _size - 1;
            if (param1 < _loc_2)
            {
                _loc_3 = _a[(_size - 1)];
                _a[_loc_2] = _a[param1];
                _a[param1] = _loc_3;
            }
            return;
        }// end function

        public function sort(param1:Function, param2:Boolean = false) : void
        {
            var _loc_3:* = null as Array;
            var _loc_4:int = 0;
            if (_size > 1)
            {
                if (param1 == null)
                {
                    if (param2)
                    {
                        _insertionSortComparable();
                    }
                    else
                    {
                        _quickSortComparable(0, _size);
                    }
                }
                else if (param2)
                {
                    _insertionSort(param1);
                }
                else
                {
                    _loc_3 = _a;
                    _loc_4 = _size;
                    if (_loc_3.length > _loc_4)
                    {
                        _loc_3.length = _loc_4;
                    }
                    _a.sort(param1);
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
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_2:* = _size;
            if (param1 == null)
            {
                _loc_3 = Math;
                do
                {
                    
                    _loc_4 = _loc_3.random() * _loc_2;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_4];
                    _a[_loc_4] = _loc_5;
                    _loc_2--;
                }while (_loc_2 > 1)
            }
            else
            {
                _loc_4 = 0;
                do
                {
                    
                    _loc_4++;
                    _loc_6 = param1._a[_loc_4] * _loc_2;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_6];
                    _a[_loc_6] = _loc_5;
                    _loc_2--;
                }while (_loc_2 > 1)
            }
            return;
        }// end function

        public function set(param1:int, param2:Object) : void
        {
            _a[param1] = param2;
            if (param1 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function reverse() : void
        {
            var _loc_1:* = null as Array;
            var _loc_2:int = 0;
            if (_a.length > _size)
            {
                _loc_1 = _a;
                _loc_2 = _size;
                if (_loc_1.length > _loc_2)
                {
                    _loc_1.length = _loc_2;
                }
                _a = _loc_1;
            }
            _a.reverse();
            return;
        }// end function

        public function reserve(param1:int) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (_size == param1)
            {
                return;
            }
            var _loc_2:* = _a;
            var _loc_3:* = new Array(param1);
            _a = _loc_3;
            if (_size < param1)
            {
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _a[_loc_6] = _loc_2[_loc_6];
                }
            }
            return;
        }// end function

        public function removeRange(param1:int, param2:int, param3:DA = ) : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (param3 == null)
            {
                _loc_4 = _size;
                _loc_5 = param1 + param2;
                while (_loc_5 < _loc_4)
                {
                    
                    _a[_loc_5 - param2] = _a[_loc_5];
                    _loc_5++;
                }
            }
            else
            {
                _loc_4 = _size;
                _loc_5 = param1 + param2;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_7 = _loc_5 - param2;
                    _loc_6 = _a[_loc_7];
                    _loc_8 = param3._size;
                    param3._a[_loc_8] = _loc_6;
                    if (_loc_8 >= param3._size)
                    {
                        (param3._size + 1);
                    }
                    _loc_5++;
                    _a[_loc_7] = _a[_loc_5];
                }
            }
            _size = _size - param2;
            return param3;
        }// end function

        public function removeAt(param1:int) : Object
        {
            var _loc_2:* = _a[param1];
            var _loc_3:* = _size - 1;
            var _loc_4:* = param1;
            while (_loc_4 < _loc_3)
            {
                
                _loc_4++;
                _a[_loc_4] = _a[_loc_4];
            }
            (_size - 1);
            return _loc_2;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_2:* = param1;
            if (_size == 0)
            {
                return false;
            }
            var _loc_3:int = 0;
            var _loc_4:* = _size;
            while (_loc_3 < _loc_4)
            {
                
                if (_a[_loc_3] == _loc_2)
                {
                    _loc_4--;
                    _loc_5 = _loc_3;
                    while (_loc_5 < _loc_4)
                    {
                        
                        _a[_loc_5] = _a[(_loc_5 + 1)];
                        _loc_5++;
                    }
                    continue;
                }
                _loc_3++;
            }
            var _loc_6:* = _size - _loc_4 != 0;
            _size = _loc_4;
            return _loc_6;
        }// end function

        public function pushFront(param1:Object) : void
        {
            if (maxSize != -1)
            {
            }
            var _loc_2:* = _size;
            while (_loc_2 > 0)
            {
                
                _loc_2--;
                _a[_loc_2] = _a[_loc_2];
            }
            _a[0] = param1;
            (_size + 1);
            return;
        }// end function

        public function pushBack(param1:Object) : void
        {
            var _loc_2:* = _size;
            _a[_loc_2] = param1;
            if (_loc_2 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function popFront() : Object
        {
            var _loc_1:* = _a[0];
            var _loc_2:* = _size - 1;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_3++;
                _a[_loc_3] = _a[_loc_3];
            }
            (_size - 1);
            return _loc_1;
        }// end function

        public function popBack() : Object
        {
            var _loc_1:* = _a[(_size - 1)];
            (_size - 1);
            return _loc_1;
        }// end function

        public function pack() : void
        {
            var _loc_6:int = 0;
            var _loc_1:* = _a.length;
            if (_loc_1 == _size)
            {
                return;
            }
            var _loc_2:* = _a;
            var _loc_3:* = new Array(_size);
            _a = _loc_3;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _a[_loc_6] = _loc_2[_loc_6];
            }
            _loc_4 = _size;
            _loc_5 = _loc_2.length;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_2[_loc_6] = null;
            }
            return;
        }// end function

        public function memmove(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (param2 == param1)
            {
                return;
            }
            else if (param2 <= param1)
            {
                _loc_4 = param2 + param3;
                _loc_5 = param1 + param3;
                _loc_6 = 0;
                while (_loc_6 < param3)
                {
                    
                    _loc_6++;
                    _loc_7 = _loc_6;
                    _loc_4--;
                    _loc_5--;
                    _a[_loc_5] = _a[_loc_4];
                }
            }
            else
            {
                _loc_4 = param2;
                _loc_5 = param1;
                _loc_6 = 0;
                while (_loc_6 < param3)
                {
                    
                    _loc_6++;
                    _loc_7 = _loc_6;
                    _a[_loc_5] = _a[_loc_4];
                    _loc_4++;
                    _loc_5++;
                }
            }
            return;
        }// end function

        public function lastIndexOf(param1:Object, param2:int = -1) : int
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (_size == 0)
            {
                return -1;
            }
            else
            {
                if (param2 < 0)
                {
                    param2 = _size + param2;
                }
                _loc_3 = -1;
                _loc_4 = param2;
                do
                {
                    
                    if (_a[_loc_4] == param1)
                    {
                        _loc_3 = _loc_4;
                        break;
                    }
                    _loc_4--;
                }while (_loc_4 > 0)
            }
            return _loc_3;
        }// end function

        public function join(param1:String) : String
        {
            var _loc_5:int = 0;
            if (_size == 0)
            {
                return "";
            }
            if (_size == 1)
            {
                return Std.string(_a[0]);
            }
            var _loc_2:* = Std.string(_a[0]) + param1;
            var _loc_3:int = 1;
            var _loc_4:* = _size - 1;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_2 = _loc_2 + Std.string(_a[_loc_5]);
                _loc_2 = _loc_2 + param1;
            }
            _loc_2 = _loc_2 + Std.string(_a[(_size - 1)]);
            return _loc_2;
        }// end function

        public function iterator() : Itr
        {
            return new DAIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function insertAt(param1:int, param2:Object) : void
        {
            var _loc_3:* = _size;
            while (_loc_3 > param1)
            {
                
                _loc_3--;
                _a[_loc_3] = _a[_loc_3];
            }
            _a[param1] = param2;
            (_size + 1);
            return;
        }// end function

        public function indexOf(param1:Object, param2:int = 0, param3:Boolean = false, param4:Object = ) : int
        {
            var _loc_5:* = null as Array;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            if (_size == 0)
            {
                return -1;
            }
            else if (param3)
            {
                if (param4 != null)
                {
                    _loc_5 = _a;
                    _loc_6 = _size - 1;
                    _loc_7 = param2;
                    _loc_9 = _loc_6 + 1;
                    while (_loc_7 < _loc_9)
                    {
                        
                        _loc_8 = _loc_7 + (_loc_9 - _loc_7 >> 1);
                        if (this.param4(_loc_5[_loc_8], param1) < 0)
                        {
                            _loc_7 = _loc_8 + 1;
                            continue;
                        }
                        _loc_9 = _loc_8;
                    }
                    if (_loc_7 <= _loc_6)
                    {
                    }
                    return this.param4(_loc_5[_loc_7], param1) == 0 ? (_loc_7) : (~_loc_7);
                }
                else
                {
                    _loc_6 = _size;
                    _loc_7 = param2;
                    _loc_9 = _loc_6;
                    while (_loc_7 < _loc_9)
                    {
                        
                        _loc_8 = _loc_7 + (_loc_9 - _loc_7 >> 1);
                        if (_a[_loc_8].compare(param1) < 0)
                        {
                            _loc_7 = _loc_8 + 1;
                            continue;
                        }
                        _loc_9 = _loc_8;
                    }
                    if (_loc_7 <= _loc_6)
                    {
                    }
                    return _a[_loc_7].compare(param1) == 0 ? (_loc_7) : (-_loc_7);
                }
            }
            else
            {
                _loc_6 = param2;
                _loc_7 = -1;
                _loc_8 = _size - 1;
                do
                {
                    
                    if (_a[_loc_6] == param1)
                    {
                        _loc_7 = _loc_6;
                        break;
                    }
                    _loc_6++;
                }while (_loc_6 < _loc_8)
                return _loc_7;
            }
            return;
        }// end function

        public function inRange(param1:int) : Boolean
        {
            if (param1 >= 0)
            {
            }
            return param1 <= _size;
        }// end function

        public function getPrev(param1:int) : Object
        {
            return _a[(param1 - 1) == -1 ? ((_size - 1)) : ((param1 - 1))];
        }// end function

        public function getNext(param1:int) : Object
        {
            return _a[(param1 + 1) == _size ? (0) : ((param1 + 1))];
        }// end function

        public function getArray() : Array
        {
            return _a;
        }// end function

        public function get(param1:int) : Object
        {
            return _a[param1];
        }// end function

        public function front() : Object
        {
            return _a[0];
        }// end function

        public function free() : void
        {
            var _loc_4:int = 0;
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            var _loc_3:* = _a.length;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[_loc_4] = _loc_1;
            }
            _a = null;
            return;
        }// end function

        public function fill(param1:Object, param2:int = 0) : void
        {
            var _loc_4:int = 0;
            if (param2 > 0)
            {
                _size = param2;
            }
            else
            {
                param2 = _size;
            }
            var _loc_3:int = 0;
            while (_loc_3 < param2)
            {
                
                _loc_3++;
                _loc_4 = _loc_3;
                _a[_loc_4] = param1;
            }
            return;
        }// end function

        public function cpy(param1:int, param2:int) : void
        {
            _a[param1] = _a[param2];
            if (param1 >= _size)
            {
                (_size + 1);
            }
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:* = _size;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_a[_loc_6] == _loc_2)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function concat(param1:DA, param2:Boolean = false) : DA
        {
            var _loc_3:* = null as DA;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (param2)
            {
                _loc_3 = new DA();
                _loc_3._size = _size + param1._size;
                _loc_4 = 0;
                _loc_5 = _size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_3._a[_loc_6] = _a[_loc_6];
                    if (_loc_6 >= _loc_3._size)
                    {
                        (_loc_3._size + 1);
                    }
                }
                _loc_4 = _size;
                _loc_5 = _size + param1._size;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_3._a[_loc_6] = param1._a[_loc_6 - _size];
                    if (_loc_6 >= _loc_3._size)
                    {
                        (_loc_3._size + 1);
                    }
                }
                return _loc_3;
            }
            else
            {
                _loc_4 = _size;
                _size = _size + param1._size;
                _loc_5 = 0;
                _loc_6 = param1._size;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_4++;
                    _a[_loc_4] = param1._a[_loc_7];
                }
            }
            return this;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new DA(_size, maxSize);
            new DA(_size, maxSize)._size = _size;
            if (param1)
            {
                _loc_5 = 0;
                _loc_6 = _size;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_4._a[_loc_7] = _a[_loc_7];
                }
            }
            else if (_loc_3 == null)
            {
                _loc_8 = null;
                _loc_5 = 0;
                _loc_6 = _size;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_8 = _a[_loc_7];
                    _loc_4._a[_loc_7] = _loc_8.clone();
                }
            }
            else
            {
                _loc_5 = 0;
                _loc_6 = _size;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_4._a[_loc_7] = this._loc_3(_a[_loc_7]);
                }
            }
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:* = null as Object;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (param1)
            {
                _loc_2 = null;
                _loc_3 = 0;
                _loc_4 = _a.length;
                while (_loc_3 < _loc_4)
                {
                    
                    _loc_3++;
                    _loc_5 = _loc_3;
                    _a[_loc_5] = _loc_2;
                }
            }
            _size = 0;
            return;
        }// end function

        public function back() : Object
        {
            return _a[(_size - 1)];
        }// end function

        public function assign(param1:Class, param2:Array = , param3:int = 0) : void
        {
            var _loc_5:int = 0;
            if (param3 > 0)
            {
                _size = param3;
            }
            else
            {
                param3 = _size;
            }
            var _loc_4:int = 0;
            while (_loc_4 < param3)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _a[_loc_5] = Instance.create(param1, param2);
            }
            return;
        }// end function

        public function _quickSortComparable(param1:int, param2:int) : void
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:* = null as Object;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as Object;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:* = null as Object;
            var _loc_3:* = param1 + param2 - 1;
            var _loc_4:* = param1;
            var _loc_5:* = _loc_3;
            if (param2 > 1)
            {
                _loc_6 = param1;
                _loc_7 = _loc_6 + (param2 >> 1);
                _loc_8 = _loc_6 + param2 - 1;
                _loc_9 = _a[_loc_6];
                _loc_10 = _a[_loc_7];
                _loc_11 = _a[_loc_8];
                _loc_13 = _loc_9.compare(_loc_11);
                if (_loc_13 < 0)
                {
                }
                if (_loc_9.compare(_loc_10) < 0)
                {
                    _loc_12 = _loc_10.compare(_loc_11) < 0 ? (_loc_7) : (_loc_8);
                }
                else
                {
                    if (_loc_9.compare(_loc_10) < 0)
                    {
                    }
                    if (_loc_10.compare(_loc_11) < 0)
                    {
                        _loc_12 = _loc_13 < 0 ? (_loc_6) : (_loc_8);
                    }
                    else
                    {
                        _loc_12 = _loc_11.compare(_loc_9) < 0 ? (_loc_7) : (_loc_6);
                    }
                }
                _loc_14 = _a[_loc_12];
                _a[_loc_12] = _a[param1];
                while (_loc_4 < _loc_5)
                {
                    
                    do
                    {
                        
                        _loc_5--;
                        if (_loc_14.compare(_a[_loc_5]) < 0)
                        {
                        }
                    }while (_loc_4 < _loc_5)
                    if (_loc_5 != _loc_4)
                    {
                        _a[_loc_4] = _a[_loc_5];
                        _loc_4++;
                    }
                    do
                    {
                        
                        _loc_4++;
                        if (_loc_14.compare(_a[_loc_4]) > 0)
                        {
                        }
                    }while (_loc_4 < _loc_5)
                    if (_loc_5 != _loc_4)
                    {
                        _a[_loc_5] = _a[_loc_4];
                        _loc_5--;
                    }
                }
                _a[_loc_4] = _loc_14;
                _quickSortComparable(param1, _loc_4 - param1);
                _quickSortComparable((_loc_4 + 1), _loc_3 - _loc_4);
            }
            return;
        }// end function

        public function _quickSort(param1:int, param2:int, param3:Function) : void
        {
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as Object;
            var _loc_12:* = null as Object;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:* = null as Object;
            var _loc_4:* = param1 + param2 - 1;
            var _loc_5:* = param1;
            var _loc_6:* = _loc_4;
            if (param2 > 1)
            {
                _loc_7 = param1;
                _loc_8 = _loc_7 + (param2 >> 1);
                _loc_9 = _loc_7 + param2 - 1;
                _loc_10 = _a[_loc_7];
                _loc_11 = _a[_loc_8];
                _loc_12 = _a[_loc_9];
                _loc_14 = this.param3(_loc_10, _loc_12);
                if (_loc_14 < 0)
                {
                }
                if (this.param3(_loc_10, _loc_11) < 0)
                {
                    _loc_13 = this.param3(_loc_11, _loc_12) < 0 ? (_loc_8) : (_loc_9);
                }
                else
                {
                    if (this.param3(_loc_11, _loc_10) < 0)
                    {
                    }
                    if (this.param3(_loc_11, _loc_12) < 0)
                    {
                        _loc_13 = _loc_14 < 0 ? (_loc_7) : (_loc_9);
                    }
                    else
                    {
                        _loc_13 = this.param3(_loc_12, _loc_10) < 0 ? (_loc_8) : (_loc_7);
                    }
                }
                _loc_15 = _a[_loc_13];
                _a[_loc_13] = _a[param1];
                while (_loc_5 < _loc_6)
                {
                    
                    do
                    {
                        
                        _loc_6--;
                        if (this.param3(_loc_15, _a[_loc_6]) < 0)
                        {
                        }
                    }while (_loc_5 < _loc_6)
                    if (_loc_6 != _loc_5)
                    {
                        _a[_loc_5] = _a[_loc_6];
                        _loc_5++;
                    }
                    do
                    {
                        
                        _loc_5++;
                        if (this.param3(_loc_15, _a[_loc_5]) > 0)
                        {
                        }
                    }while (_loc_5 < _loc_6)
                    if (_loc_6 != _loc_5)
                    {
                        _a[_loc_6] = _a[_loc_5];
                        _loc_6--;
                    }
                }
                _a[_loc_5] = _loc_15;
                _quickSort(param1, _loc_5 - param1, param3);
                _quickSort((_loc_5 + 1), _loc_4 - _loc_5, param3);
            }
            return;
        }// end function

        public function _insertionSortComparable() : void
        {
            var _loc_3:int = 0;
            var _loc_4:* = null as Object;
            var _loc_5:int = 0;
            var _loc_6:* = null as Object;
            var _loc_1:int = 1;
            var _loc_2:* = _size;
            while (_loc_1 < _loc_2)
            {
                
                _loc_1++;
                _loc_3 = _loc_1;
                _loc_4 = _a[_loc_3];
                _loc_5 = _loc_3;
                while (_loc_5 > 0)
                {
                    
                    _loc_6 = _a[(_loc_5 - 1)];
                    if (_loc_6.compare(_loc_4) > 0)
                    {
                        _a[_loc_5] = _loc_6;
                        _loc_5--;
                        continue;
                    }
                    break;
                }
                _a[_loc_5] = _loc_4;
            }
            return;
        }// end function

        public function _insertionSort(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_7:* = null as Object;
            var _loc_2:int = 1;
            var _loc_3:* = _size;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = _a[_loc_4];
                _loc_6 = _loc_4;
                while (_loc_6 > 0)
                {
                    
                    _loc_7 = _a[(_loc_6 - 1)];
                    if (this.param1(_loc_7, _loc_5) > 0)
                    {
                        _a[_loc_6] = _loc_7;
                        _loc_6--;
                        continue;
                    }
                    break;
                }
                _a[_loc_6] = _loc_5;
            }
            return;
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

        public function __cpy(param1:int, param2:int) : void
        {
            _a[param1] = _a[param2];
            return;
        }// end function

    }
}
