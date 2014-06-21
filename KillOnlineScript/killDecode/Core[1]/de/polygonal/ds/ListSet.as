package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class ListSet extends Object implements Set
    {
        public var key:int;
        public var _a:DA;

        public function ListSet() : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _a = new DA();
            var _loc_1:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_1;
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{ListSet, size: %d}", [size()]);
        }// end function

        public function toDA() : DA
        {
            return _a.toDA();
        }// end function

        public function toArray() : Array
        {
            return _a.toArray();
        }// end function

        public function size() : int
        {
            return _a._size;
        }// end function

        public function set(param1:Object) : Boolean
        {
            var _loc_3:* = null as DA;
            var _loc_5:int = 0;
            var _loc_7:int = 0;
            var _loc_2:* = param1;
            _loc_3 = _a;
            var _loc_4:Boolean = false;
            _loc_5 = 0;
            var _loc_6:* = _loc_3._size;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                if (_loc_3._a[_loc_7] == _loc_2)
                {
                    _loc_4 = true;
                    break;
                }
            }
            if (_loc_4)
            {
                return false;
            }
            else
            {
                _loc_3 = _a;
                _loc_5 = _loc_3._size;
                _loc_3._a[_loc_5] = _loc_2;
            }
            (_loc_3._size + 1);
            return true;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_2:* = param1;
            return _a.remove(_loc_2);
        }// end function

        public function merge(param1:Set, param2:Boolean, param3:Object = ) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null as Object;
            if (param2)
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    set(_loc_5);
                    ;
                }
            }
            else if (param3 != null)
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    set(this.param3(_loc_5));
                    ;
                }
            }
            else
            {
                _loc_4 = param1.iterator();
                
                if (_loc_4.hasNext())
                {
                    _loc_5 = _loc_4.next();
                    set(_loc_5.clone());
                    ;
                }
            }
            return;
        }// end function

        public function iterator() : Itr
        {
            return _a.iterator();
        }// end function

        public function isEmpty() : Boolean
        {
            return _a._size == 0;
        }// end function

        public function has(param1:Object) : Boolean
        {
            var _loc_7:int = 0;
            var _loc_2:* = param1;
            var _loc_3:* = _a;
            var _loc_4:Boolean = false;
            var _loc_5:int = 0;
            var _loc_6:* = _loc_3._size;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                if (_loc_3._a[_loc_7] == _loc_2)
                {
                    _loc_4 = true;
                    break;
                }
            }
            return _loc_4;
        }// end function

        public function free() : void
        {
            _a.free();
            _a = null;
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_7:int = 0;
            var _loc_2:* = param1;
            var _loc_3:* = _a;
            var _loc_4:Boolean = false;
            var _loc_5:int = 0;
            var _loc_6:* = _loc_3._size;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                if (_loc_3._a[_loc_7] == _loc_2)
                {
                    _loc_4 = true;
                    break;
                }
            }
            return _loc_4;
        }// end function

        public function clone(param1:Boolean, param2:Object = ) : Collection
        {
            var _loc_3:* = param2;
            var _loc_4:* = Instance.createEmpty(ListSet);
            var _loc_5:* = HashKey._counter;
            (HashKey._counter + 1);
            Instance.createEmpty(ListSet).key = _loc_5;
            _loc_4._a = _a.clone(param1, _loc_3);
            return _loc_4;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = _a;
            if (param1)
            {
                _loc_3 = null;
                _loc_4 = 0;
                _loc_5 = _loc_2._a.length;
                while (_loc_4 < _loc_5)
                {
                    
                    _loc_4++;
                    _loc_6 = _loc_4;
                    _loc_2._a[_loc_6] = _loc_3;
                }
            }
            _loc_2._size = 0;
            return;
        }// end function

    }
}
