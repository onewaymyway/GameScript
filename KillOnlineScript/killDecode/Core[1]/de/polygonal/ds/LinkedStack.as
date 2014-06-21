package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class LinkedStack extends Object implements Stack
    {
        public var maxSize:int;
        public var key:int;
        public var _top:int;
        public var _tailPool:LinkedStackNode;
        public var _reservedSize:int;
        public var _poolSize:int;
        public var _headPool:LinkedStackNode;
        public var _head:LinkedStackNode;

        public function LinkedStack(param1:int = 0, param2:int = -1) : void
        {
            var _loc_3:* = null as Object;
            var _loc_4:* = null as LinkedStackNode;
            if (Boot.skip_constructor)
            {
                return;
            }
            if (param1 > 0)
            {
                if (param2 != -1)
                {
                }
            }
            maxSize = -1;
            _reservedSize = param1;
            _top = 0;
            _poolSize = 0;
            if (param1 > 0)
            {
                _loc_3 = null;
                _loc_4 = new LinkedStackNode(_loc_3);
                _tailPool = _loc_4;
                _headPool = _loc_4;
            }
            var _loc_5:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_5;
            return;
        }// end function

        public function top() : Object
        {
            return _head.val;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{LinkedStack size: %d}", [_top]);
        }// end function

        public function toDA() : DA
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_1:* = new DA(_top);
            _loc_1.fill(null, _top);
            var _loc_2:Array = [];
            var _loc_3:* = _head;
            var _loc_4:int = 0;
            var _loc_5:* = _top;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_7 = _top - _loc_6 - 1;
                _loc_1._a[_loc_7] = _loc_3.val;
                if (_loc_7 >= _loc_1._size)
                {
                    (_loc_1._size + 1);
                }
                _loc_3 = _loc_3.next;
            }
            return _loc_1;
        }// end function

        public function toArray() : Array
        {
            var _loc_5:int = 0;
            var _loc_2:* = new Array(_top);
            var _loc_1:* = _loc_2;
            var _loc_3:* = _top;
            if (_loc_3 == -1)
            {
                _loc_3 = _loc_1.length;
            }
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_4++;
                _loc_5 = _loc_4;
                _loc_1[_loc_5] = null;
            }
            var _loc_6:* = _head;
            _loc_3 = 0;
            _loc_4 = _top;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_top - _loc_5 - 1] = _loc_6.val;
                _loc_6 = _loc_6.next;
            }
            return _loc_1;
        }// end function

        public function swp(param1:int, param2:int) : void
        {
            var _loc_3:* = _head;
            if (param1 < param2)
            {
                param1 = param1 ^ param2;
                param2 = param2 ^ param1;
                param1 = param1 ^ param2;
            }
            var _loc_4:* = _top - 1;
            while (_loc_4 > param1)
            {
                
                _loc_3 = _loc_3.next;
                _loc_4--;
            }
            var _loc_5:* = _loc_3;
            while (_loc_4 > param2)
            {
                
                _loc_3 = _loc_3.next;
                _loc_4--;
            }
            var _loc_6:* = _loc_5.val;
            _loc_5.val = _loc_3.val;
            _loc_3.val = _loc_6;
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
            var _loc_5:* = null as LinkedStackNode;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as Object;
            var _loc_9:* = null as LinkedStackNode;
            var _loc_10:int = 0;
            var _loc_2:* = _top;
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

        public function set(param1:int, param2:Object) : void
        {
            var _loc_3:* = _head;
            param1 = _top - param1;
            do
            {
                
                _loc_3 = _loc_3.next;
                param1--;
            }while (param1 > 0)
            _loc_3.val = param2;
            return;
        }// end function

        public function rotRight(param1:int) : void
        {
            var _loc_5:int = 0;
            var _loc_2:* = _head;
            var _loc_3:int = 0;
            var _loc_4:* = param1 - 2;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_2 = _loc_2.next;
            }
            var _loc_6:* = _loc_2.next;
            _loc_2.next = _loc_6.next;
            _loc_6.next = _head;
            _head = _loc_6;
            return;
        }// end function

        public function rotLeft(param1:int) : void
        {
            var _loc_6:int = 0;
            var _loc_2:* = _head;
            _head = _head.next;
            var _loc_3:* = _head;
            var _loc_4:int = 0;
            var _loc_5:* = param1 - 2;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_3 = _loc_3.next;
            }
            _loc_2.next = _loc_3.next;
            _loc_3.next = _loc_2;
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_7:* = null as LinkedStackNode;
            var _loc_8:* = null as Object;
            var _loc_9:* = null as LinkedStackNode;
            var _loc_10:* = null as Object;
            var _loc_11:* = null as LinkedStackNode;
            var _loc_2:* = param1;
            if (_top == 0)
            {
                return false;
            }
            var _loc_3:Boolean = false;
            var _loc_4:* = _head;
            var _loc_5:* = _head.next;
            var _loc_6:Object = null;
            while (_loc_5 != null)
            {
                
                if (_loc_5.val == _loc_2)
                {
                    _loc_3 = true;
                    _loc_7 = _loc_5.next;
                    _loc_4.next = _loc_7;
                    _loc_8 = _loc_5.val;
                    if (_reservedSize > 0)
                    {
                    }
                    if (_poolSize < _reservedSize)
                    {
                        _loc_9 = _loc_5;
                        _tailPool.next = _loc_9;
                        _tailPool = _loc_9;
                        _loc_10 = null;
                        _loc_5.next = null;
                        _loc_5.val = _loc_10;
                        (_poolSize + 1);
                    }
                    _loc_5 = _loc_7;
                    (_top - 1);
                    continue;
                }
                _loc_4 = _loc_5;
                _loc_5 = _loc_5.next;
            }
            if (_head.val == _loc_2)
            {
                _loc_3 = true;
                _loc_7 = _head.next;
                _loc_9 = _head;
                _loc_8 = _loc_9.val;
                if (_reservedSize > 0)
                {
                }
                if (_poolSize < _reservedSize)
                {
                    _loc_11 = _loc_9;
                    _tailPool.next = _loc_11;
                    _tailPool = _loc_11;
                    _loc_10 = null;
                    _loc_9.next = null;
                    _loc_9.val = _loc_10;
                    (_poolSize + 1);
                }
                _head = _loc_7;
                (_top - 1);
            }
            return _loc_3;
        }// end function

        public function push(param1:Object) : void
        {
            var _loc_4:* = null as LinkedStackNode;
            var _loc_2:* = param1;
            if (_reservedSize != 0)
            {
            }
            var _loc_3:* = _poolSize == 0 ? (new LinkedStackNode(_loc_2)) : (_loc_4 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_4.val = _loc_2, _loc_4);
            _loc_3.next = _head;
            _head = _loc_3;
            (_top + 1);
            return;
        }// end function

        public function pop() : Object
        {
            var _loc_3:* = null as LinkedStackNode;
            var _loc_4:* = null as Object;
            (_top - 1);
            var _loc_1:* = _head;
            _head = _head.next;
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
                _loc_1.next = null;
                _loc_1.val = _loc_4;
                (_poolSize + 1);
            }
            return _loc_2;
        }// end function

        public function iterator() : Itr
        {
            return new LinkedStackIterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return _top == 0;
        }// end function

        public function get(param1:int) : Object
        {
            var _loc_2:* = _head;
            param1 = _top - param1;
            do
            {
                
                _loc_2 = _loc_2.next;
                param1--;
            }while (param1 > 0)
            return _loc_2.val;
        }// end function

        public function free() : void
        {
            var _loc_3:* = null as LinkedStackNode;
            var _loc_4:* = null as LinkedStackNode;
            var _loc_1:Object = null;
            var _loc_2:* = _head;
            while (_loc_2 != null)
            {
                
                _loc_3 = _loc_2.next;
                _loc_2.next = null;
                _loc_2.val = _loc_1;
                _loc_2 = _loc_3;
            }
            _head = null;
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
                param2 = _top;
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

        public function exchange() : void
        {
            var _loc_1:* = _head.val;
            _head.val = _head.next.val;
            _head.next.val = _loc_1;
            return;
        }// end function

        public function dup() : void
        {
            var _loc_3:* = null as LinkedStackNode;
            var _loc_2:* = _head.val;
            if (_reservedSize != 0)
            {
            }
            var _loc_1:* = _poolSize == 0 ? (new LinkedStackNode(_loc_2)) : (_loc_3 = _headPool, _headPool = _headPool.next, _poolSize - 1, _loc_3.val = _loc_2, _loc_3);
            _loc_1.next = _head;
            _head = _loc_1;
            (_top + 1);
            return;
        }// end function

        public function cpy(param1:int, param2:int) : void
        {
            var _loc_3:* = _head;
            if (param1 < param2)
            {
                param1 = param1 ^ param2;
                param2 = param2 ^ param1;
                param1 = param1 ^ param2;
            }
            var _loc_4:* = _top - 1;
            while (_loc_4 > param1)
            {
                
                _loc_3 = _loc_3.next;
                _loc_4--;
            }
            var _loc_5:* = _loc_3.val;
            while (_loc_4 > param2)
            {
                
                _loc_3 = _loc_3.next;
                _loc_4--;
            }
            _loc_3.val = _loc_5;
            return;
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
            var _loc_6:* = null as LinkedStackNode;
            var _loc_7:* = null as LinkedStackNode;
            var _loc_8:* = null as LinkedStackNode;
            var _loc_9:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new LinkedStack(_reservedSize, maxSize);
            if (_top == 0)
            {
                return _loc_4;
            }
            var _loc_5:* = new LinkedStack(_reservedSize, maxSize);
            new LinkedStack(_reservedSize, maxSize)._top = _top;
            if (param1)
            {
                _loc_6 = _head;
                _loc_8 = new LinkedStackNode(_loc_6.val);
                _loc_5._head = _loc_8;
                _loc_7 = _loc_8;
                _loc_6 = _loc_6.next;
                while (_loc_6 != null)
                {
                    
                    _loc_8 = new LinkedStackNode(_loc_6.val);
                    _loc_7.next = _loc_8;
                    _loc_7 = _loc_8;
                    _loc_6 = _loc_6.next;
                }
            }
            else if (_loc_3 == null)
            {
                _loc_6 = _head;
                _loc_9 = _loc_6.val;
                _loc_8 = new LinkedStackNode(_loc_9.clone());
                _loc_5._head = _loc_8;
                _loc_7 = _loc_8;
                _loc_6 = _loc_6.next;
                while (_loc_6 != null)
                {
                    
                    _loc_9 = _loc_6.val;
                    _loc_8 = new LinkedStackNode(_loc_9.clone());
                    _loc_7.next = _loc_8;
                    _loc_7 = _loc_8;
                    _loc_6 = _loc_6.next;
                }
            }
            else
            {
                _loc_6 = _head;
                _loc_8 = new LinkedStackNode(this._loc_3(_loc_6.val));
                _loc_5._head = _loc_8;
                _loc_7 = _loc_8;
                _loc_6 = _loc_6.next;
                while (_loc_6 != null)
                {
                    
                    _loc_8 = new LinkedStackNode(this._loc_3(_loc_6.val));
                    _loc_7.next = _loc_8;
                    _loc_7 = _loc_8;
                    _loc_6 = _loc_6.next;
                }
            }
            return _loc_5;
        }// end function

        public function clear(param1:Boolean = false) : void
        {
            var _loc_2:* = null as LinkedStackNode;
            var _loc_3:* = null as LinkedStackNode;
            var _loc_4:* = null as Object;
            var _loc_5:* = null as LinkedStackNode;
            var _loc_6:* = null as Object;
            if (_top == 0)
            {
                return;
            }
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
                        _loc_2.next = null;
                        _loc_2.val = _loc_6;
                        (_poolSize + 1);
                    }
                    _loc_2 = _loc_3;
                }
            }
            _head.next = null;
            _head.val = null;
            _top = 0;
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
                param3 = _top;
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

        public function _putNode(param1:LinkedStackNode) : Object
        {
            var _loc_3:* = null as LinkedStackNode;
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
                param1.next = null;
                param1.val = _loc_4;
                (_poolSize + 1);
            }
            return _loc_2;
        }// end function

        public function _getNode(param1:Object) : LinkedStackNode
        {
            var _loc_2:* = null as LinkedStackNode;
            if (_reservedSize != 0)
            {
            }
            if (_poolSize == 0)
            {
                return new LinkedStackNode(param1);
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
