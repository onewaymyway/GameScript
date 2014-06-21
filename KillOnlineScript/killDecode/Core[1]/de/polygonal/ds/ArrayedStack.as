package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class ArrayedStack extends Object implements Stack
    {
        public var maxSize:int;
        public var key:int;
        public var _top:int;
        public var _a:Array;

        public function ArrayedStack(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Array;
            if (Boot.skip_constructor)
            {
                return;
            }
            if (param1 > 0)
            {
                if (param2 != -1)
                {
                }
                _loc_3 = new Array(param1);
                _a = _loc_3;
            }
            else
            {
                _a = [];
            }
            _top = 0;
            maxSize = -1;
            var _loc_4:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_4;
            return;
        }// end function

        public function walk(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_2:int = 0;
            var _loc_3:* = _top;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[_loc_4] = this.param1(_a[_loc_4], _loc_4);
            }
            return;
        }// end function

        public function top() : Object
        {
            return _a[(_top - 1)];
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{ArrayedStack, size: %d}", [_top]);
        }// end function

        public function toDA() : DA
        {
            var _loc_3:int = 0;
            var _loc_1:* = new DA(_top);
            var _loc_2:* = _top;
            while (_loc_2 > 0)
            {
                
                _loc_3 = _loc_1._size;
                _loc_2--;
                _loc_1._a[_loc_3] = _a[_loc_2];
                if (_loc_3 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_2:* = new Array(_top);
            var _loc_1:* = _loc_2;
            var _loc_3:* = _top;
            var _loc_4:int = 0;
            while (_loc_3 > 0)
            {
                
                _loc_4++;
                _loc_3--;
                _loc_1[_loc_4] = _a[_loc_3];
            }
            return _loc_1;
        }// end function

        public function swp(param1:int, param2:int) : void
        {
            var _loc_3:* = _a[param1];
            _a[param1] = _a[param2];
            _a[param2] = _loc_3;
            return;
        }// end function

        public function size() : int
        {
            return _top;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_2:* = _top;
            if (param1 == null)
            {
                _loc_3 = Math;
                while (_loc_2 > 1)
                {
                    
                    _loc_2--;
                    _loc_4 = _loc_3.random() * _loc_2;
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
                    
                    _loc_4++;
                    _loc_2--;
                    _loc_6 = param1._a[_loc_4] * _loc_2;
                    _loc_5 = _a[_loc_2];
                    _a[_loc_2] = _a[_loc_6];
                    _a[_loc_6] = _loc_5;
                }
            }
            return;
        }// end function

        public function set(param1:int, param2:Object) : void
        {
            _a[param1] = param2;
            return;
        }// end function

        public function rotRight(param1:int) : void
        {
            var _loc_2:* = _top - param1;
            var _loc_3:* = _top - 1;
            var _loc_4:* = _a[_loc_2];
            while (_loc_2 < _loc_3)
            {
                
                _a[_loc_2] = _a[(_loc_2 + 1)];
                _loc_2++;
            }
            _a[(_top - 1)] = _loc_4;
            return;
        }// end function

        public function rotLeft(param1:int) : void
        {
            var _loc_2:* = _top - 1;
            var _loc_3:* = _top - param1;
            var _loc_4:* = _a[_loc_2];
            while (_loc_2 > _loc_3)
            {
                
                _a[_loc_2] = _a[(_loc_2 - 1)];
                _loc_2--;
            }
            _a[_top - param1] = _loc_4;
            return;
        }// end function

        public function reserve(param1:int) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (_top == param1)
            {
                return;
            }
            var _loc_2:* = _a;
            var _loc_3:* = new Array(param1);
            _a = _loc_3;
            if (_top < param1)
            {
                _loc_4 = 0;
                _loc_5 = _top;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _a[_loc_6] = _loc_2[_loc_6];
                }
            }
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_2:* = param1;
            if (_top == 0)
            {
                return false;
            }
            var _loc_3:Object = null;
            var _loc_4:Boolean = false;
            while (_top > 0)
            {
                
                _loc_4 = false;
                _loc_5 = 0;
                _loc_6 = _top;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    if (_a[_loc_7] == _loc_2)
                    {
                        _loc_8 = _top - 1;
                        _loc_9 = _loc_7;
                        while (_loc_9 < _loc_8)
                        {
                            
                            _loc_9++;
                            _a[_loc_9] = _a[_loc_9];
                        }
                        --_top;
                        _a[--_top] = _loc_3;
                        _loc_4 = true;
                        break;
                    }
                }
                if (!_loc_4)
                {
                    break;
                }
            }
            return _loc_4;
        }// end function

        public function push(param1:Object) : void
        {
            var _loc_2:* = param1;
            var _loc_3:* = _top;
            (_top + 1);
            _a[_loc_3] = _loc_2;
            return;
        }// end function

        public function pop() : Object
        {
            --_top;
            return _a[--_top];
        }// end function

        public function pack() : void
        {
            var _loc_5:int = 0;
            if (_a.length == _top)
            {
                return;
            }
            var _loc_1:* = _a;
            var _loc_2:* = new Array(_top);
            _a = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _top;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5] = _loc_1[_loc_5];
            }
            _loc_3 = _top;
            _loc_4 = _loc_1.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_loc_5] = null;
            }
            return;
        }// end function

        public function iterator() : Itr
        {
            return new ArrayedStackIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _top == 0;
        }// end function

        public function get(param1:int) : Object
        {
            return _a[param1];
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
                if (maxSize != -1)
                {
                }
            }
            else
            {
                param2 = _top;
            }
            var _loc_3:int = 0;
            while (_loc_3 < param2)
            {
                
                _loc_3++;
                _loc_4 = _loc_3;
                _a[_loc_4] = param1;
            }
            _top = param2;
            return;
        }// end function

        public function exchange() : void
        {
            var _loc_1:* = _top - 1;
            var _loc_2:* = _loc_1 - 1;
            var _loc_3:* = _a[_loc_1];
            _a[_loc_1] = _a[_loc_2];
            _a[_loc_2] = _loc_3;
            return;
        }// end function

        public function dup() : void
        {
            _a[_top] = _a[(_top - 1)];
            (_top + 1);
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:Object = null;
            _a[_top] = _loc_1;
            return;
        }// end function

        public function cpy(param1:int, param2:int) : void
        {
            _a[param1] = _a[param2];
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_2:* = param1;
            var _loc_3:int = 0;
            var _loc_4:* = _top;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                if (_a[_loc_5] == _loc_2)
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
            var _loc_4:* = new ArrayedStack(_top, maxSize);
            if (_top == 0)
            {
                return _loc_4;
            }
            var _loc_5:* = _loc_4._a;
            if (param1)
            {
                _loc_6 = 0;
                _loc_7 = _top;
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
                _loc_7 = _top;
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
                _loc_7 = _top;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    _loc_5[_loc_8] = this._loc_3(_a[_loc_8]);
                }
            }
            _loc_4._top = _top;
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
                    _a[_loc_5] = null;
                }
            }
            _top = 0;
            return;
        }// end function

        public function assign(param1:Class, param2:Array = , param3:int = 0) : void
        {
            var _loc_5:int = 0;
            if (param3 > 0)
            {
            }
            else
            {
                param3 = _top;
            }
            var _loc_4:int = 0;
            while (_loc_4 < param3)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _a[_loc_5] = Instance.create(param1, param2);
            }
            _top = param3;
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
