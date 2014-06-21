package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import flash.*;
    import flash.utils.*;

    public class HashMap extends Object implements Map
    {
        public var maxSize:int;
        public var key:int;
        public var _weak:Boolean;
        public var _size:int;
        public var _map:Dictionary;

        public function HashMap(param1:Boolean = false, param2:int = -1) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            var _loc_3:* = param1;
            _weak = param1;
            _map = new Dictionary(_loc_3);
            _size = 0;
            var _loc_4:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_4;
            maxSize = -1;
            return;
        }// end function

        public function toValSet() : Set
        {
            var _loc_6:* = null as Object;
            var _loc_1:* = new ListSet();
            var _loc_4:int = 0;
            var _loc_3:Array = [];
            var _loc_5:* = _map;
            while (_loc_5 in _loc_4)
            {
                
                _loc_3.push(_loc_5[_loc_4]);
            }
            var _loc_2:* = _loc_3;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_6 = _loc_2[_loc_4];
                _loc_4++;
                _loc_1.set(_map[_loc_6]);
            }
            return _loc_1;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{HashMap, size: %d}", [_size]);
        }// end function

        public function toKeySet() : Set
        {
            var _loc_6:* = null as Object;
            var _loc_1:* = new ListSet();
            var _loc_4:int = 0;
            var _loc_3:Array = [];
            var _loc_5:* = _map;
            while (_loc_5 in _loc_4)
            {
                
                _loc_3.push(_loc_5[_loc_4]);
            }
            var _loc_2:* = _loc_3;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_6 = _loc_2[_loc_4];
                _loc_4++;
                _loc_1.set(_loc_6);
            }
            return _loc_1;
        }// end function

        public function toKeyDA() : DA
        {
            return ArrayConvert.toDA(toKeyArray());
        }// end function

        public function toKeyArray() : Array
        {
            var _loc_2:int = 0;
            var _loc_1:Array = [];
            var _loc_3:* = _map;
            while (_loc_3 in _loc_2)
            {
                
                _loc_1.push(_loc_3[_loc_2]);
            }
            return _loc_1;
        }// end function

        public function toDA() : DA
        {
            var _loc_3:* = null as Object;
            var _loc_4:int = 0;
            var _loc_1:* = new DA(_size);
            var _loc_2:* = iterator();
            
            if (_loc_2.hasNext())
            {
                _loc_3 = _loc_2.next();
                _loc_4 = _loc_1._size;
                _loc_1._a[_loc_4] = _loc_3;
                if (_loc_4 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
                ;
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_4:* = null as Object;
            var _loc_2:* = new Array(_size);
            var _loc_1:* = _loc_2;
            var _loc_3:* = iterator();
            
            if (_loc_3.hasNext())
            {
                _loc_4 = _loc_3.next();
                _loc_1.push(_loc_4);
                ;
            }
            return _loc_1;
        }// end function

        public function size() : int
        {
            return _size;
        }// end function

        public function set(param1:Object, param2:Object) : Boolean
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = _map[_loc_3];
            if (_map[_loc_3] != null)
            {
                return false;
            }
            else
            {
                _map[_loc_3] = _loc_4;
            }
            (_size + 1);
            return true;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_5:* = null as Array;
            var _loc_6:* = null as Array;
            var _loc_7:int = 0;
            var _loc_8:* = null;
            var _loc_9:* = null as Object;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            _loc_7 = 0;
            _loc_6 = [];
            _loc_8 = _map;
            while (_loc_8 in _loc_7)
            {
                
                _loc_6.push(_loc_8[_loc_7]);
            }
            _loc_5 = _loc_6;
            _loc_7 = 0;
            while (_loc_7 < _loc_5.length)
            {
                
                _loc_9 = _loc_5[_loc_7];
                _loc_7++;
                if (_map[_loc_9] == _loc_2)
                {
                    _loc_4 = true;
                    break;
                }
            }
            if (_loc_4)
            {
                _loc_7 = 0;
                _loc_6 = [];
                _loc_8 = _map;
                while (_loc_8 in _loc_7)
                {
                    
                    _loc_6.push(_loc_8[_loc_7]);
                }
                _loc_5 = _loc_6;
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length)
                {
                    
                    _loc_9 = _loc_5[_loc_7];
                    _loc_7++;
                    if (_map[_loc_9] == _loc_2)
                    {
                        delete _map[_loc_9];
                        (_size - 1);
                        _loc_3 = true;
                    }
                }
            }
            return _loc_3;
        }// end function

        public function remap(param1:Object, param2:Object) : Boolean
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = _map[_loc_3];
            if (_map[_loc_3] != null)
            {
                _map[_loc_3] = _loc_4;
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        public function keys() : Itr
        {
            return new HashMapKeyIterator(this);
        }// end function

        public function iterator() : Itr
        {
            return new HashMapValIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _size == 0;
        }// end function

        public function hasKey(param1:Object) : Boolean
        {
            var _loc_2:* = param1;
            var _loc_3:* = _map[_loc_2];
            return _loc_3 != null;
        }// end function

        public function has(param1:Object) : Boolean
        {
            var _loc_8:* = null as Object;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_6:int = 0;
            var _loc_5:Array = [];
            var _loc_7:* = _map;
            while (_loc_7 in _loc_6)
            {
                
                _loc_5.push(_loc_7[_loc_6]);
            }
            var _loc_4:* = _loc_5;
            _loc_6 = 0;
            while (_loc_6 < _loc_4.length)
            {
                
                _loc_8 = _loc_4[_loc_6];
                _loc_6++;
                if (_map[_loc_8] == _loc_2)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function get(param1:Object) : Object
        {
            var _loc_2:* = param1;
            return _map[_loc_2];
        }// end function

        public function free() : void
        {
            var _loc_1:* = null as Array;
            var _loc_2:* = null as Array;
            var _loc_3:int = 0;
            var _loc_4:* = null;
            var _loc_5:* = null as Object;
            if (!_weak)
            {
                _loc_3 = 0;
                _loc_2 = [];
                _loc_4 = _map;
                while (_loc_4 in _loc_3)
                {
                    
                    _loc_2.push(_loc_4[_loc_3]);
                }
                _loc_1 = _loc_2;
                _loc_3 = 0;
                while (_loc_3 < _loc_1.length)
                {
                    
                    _loc_5 = _loc_1[_loc_3];
                    _loc_3++;
                    delete _map[_loc_5];
                }
            }
            _map = null;
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_8:* = null as Object;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_6:int = 0;
            var _loc_5:Array = [];
            var _loc_7:* = _map;
            while (_loc_7 in _loc_6)
            {
                
                _loc_5.push(_loc_7[_loc_6]);
            }
            var _loc_4:* = _loc_5;
            _loc_6 = 0;
            while (_loc_6 < _loc_4.length)
            {
                
                _loc_8 = _loc_4[_loc_6];
                _loc_6++;
                if (_map[_loc_8] == _loc_2)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function clr(param1:Object) : Boolean
        {
            var _loc_2:* = param1;
            if (_map[_loc_2] != null)
            {
                delete _map[_loc_2];
                (_size - 1);
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_7:int = 0;
            var _loc_9:* = null as Object;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new HashMap(_weak, maxSize);
            _loc_7 = 0;
            var _loc_6:Array = [];
            var _loc_8:* = _map;
            while (_loc_8 in _loc_7)
            {
                
                _loc_6.push(_loc_8[_loc_7]);
            }
            var _loc_5:* = _loc_6;
            if (param1)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length)
                {
                    
                    _loc_9 = _loc_5[_loc_7];
                    _loc_7++;
                    _loc_10 = _loc_4._map[_loc_9];
                    if (_loc_10 != null)
                    {
                        continue;
                    }
                    _loc_4._map[_loc_9] = _map[_loc_9];
                    (_loc_4._size + 1);
                }
            }
            else if (_loc_3 == null)
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length)
                {
                    
                    _loc_9 = _loc_5[_loc_7];
                    _loc_7++;
                    _loc_11 = _map[_loc_9];
                    _loc_10 = _loc_4._map[_loc_9];
                    if (_loc_10 != null)
                    {
                        continue;
                    }
                    _loc_4._map[_loc_9] = _map[_loc_9];
                    (_loc_4._size + 1);
                }
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length)
                {
                    
                    _loc_9 = _loc_5[_loc_7];
                    _loc_7++;
                    _loc_10 = _loc_4._map[_loc_9];
                    if (_loc_10 != null)
                    {
                        continue;
                    }
                    _loc_4._map[_loc_9] = this._loc_3(_map[_loc_9]);
                    (_loc_4._size + 1);
                }
            }
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_6:* = null as Object;
            var _loc_4:int = 0;
            var _loc_3:Array = [];
            var _loc_5:* = _map;
            while (_loc_5 in _loc_4)
            {
                
                _loc_3.push(_loc_5[_loc_4]);
            }
            var _loc_2:* = _loc_3;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_6 = _loc_2[_loc_4];
                _loc_4++;
                delete _map[_loc_6];
            }
            _size = 0;
            return;
        }// end function

    }
}
