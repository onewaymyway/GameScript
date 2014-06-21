package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class Array3 extends Object implements Collection
    {
        public var key:int;
        public var _w:int;
        public var _h:int;
        public var _d:int;
        public var _a:Array;

        public function Array3(param1:int = 0, param2:int = 0, param3:int = 0) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _w = param1;
            _h = param2;
            _d = param3;
            var _loc_4:* = new Array(_w * _h * _d);
            _a = new Array(_w * _h * _d);
            var _loc_5:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_5;
            return;
        }// end function

        public function walk(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_2:int = 0;
            var _loc_3:* = _d;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = 0;
                _loc_6 = _h;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_8 = 0;
                    _loc_9 = _w;
                    while (_loc_8 < _loc_9)
                    {
                        
                        _loc_8++;
                        _loc_10 = _loc_8;
                        _loc_11 = _loc_4 * _w * _h + _loc_7 * _w + _loc_10;
                        _a[_loc_11] = this.param1(_a[_loc_11], _loc_10, _loc_7, _loc_4);
                    }
                }
            }
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{Array3, %dx%dx%d}", [_w, _h, _d]);
        }// end function

        public function toDA() : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_1:* = new DA(_w * _h * _d);
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h * _d;
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
            var _loc_2:* = new Array(_w * _h * _d);
            var _loc_1:* = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _w * _h * _d;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_loc_5] = _a[_loc_5];
            }
            return _loc_1;
        }// end function

        public function swap(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
        {
            var _loc_7:* = param3 * _w * _h + param2 * _w + param1;
            var _loc_8:* = param6 * _w * _h + param5 * _w + param4;
            var _loc_9:* = _a[_loc_7];
            _a[_loc_7] = _a[_loc_8];
            _a[_loc_8] = _loc_9;
            return;
        }// end function

        public function size() : int
        {
            return _w * _h * _d;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_2:* = _w * _h * _d;
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

        public function setW(param1:int) : void
        {
            resize(param1, _h, _d);
            return;
        }// end function

        public function setRow(param1:int, param2:int, param3:Array) : void
        {
            var _loc_7:int = 0;
            var _loc_4:* = param1 * _w * _h + param2 * _w;
            var _loc_5:int = 0;
            var _loc_6:* = _w;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                _a[_loc_4 + _loc_7] = param3[_loc_7];
            }
            return;
        }// end function

        public function setPile(param1:int, param2:int, param3:Array) : void
        {
            var _loc_8:int = 0;
            var _loc_4:* = _w * _h;
            var _loc_5:* = param2 * _w + param1;
            var _loc_6:int = 0;
            var _loc_7:* = _d;
            while (_loc_6 < _loc_7)
            {
                
                _loc_6++;
                _loc_8 = _loc_6;
                _a[_loc_8 * _loc_4 + _loc_5] = param3[_loc_8];
            }
            return;
        }// end function

        public function setH(param1:int) : void
        {
            resize(_w, param1, _d);
            return;
        }// end function

        public function setD(param1:int) : void
        {
            resize(_w, _h, param1);
            return;
        }// end function

        public function setCol(param1:int, param2:int, param3:Array) : void
        {
            var _loc_7:int = 0;
            var _loc_4:* = param1 * _w * _h;
            var _loc_5:int = 0;
            var _loc_6:* = _h;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                _a[_loc_4 + (_loc_7 * _w + param2)] = param3[_loc_7];
            }
            return;
        }// end function

        public function set(param1:int, param2:int, param3:int, param4:Object) : void
        {
            _a[param3 * _w * _h + param2 * _w + param1] = param4;
            return;
        }// end function

        public function resize(param1:int, param2:int, param3:int) : void
        {
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:int = 0;
            var _loc_17:int = 0;
            var _loc_18:int = 0;
            if (param1 == _w)
            {
            }
            if (param2 == _h)
            {
            }
            if (param3 == _d)
            {
                return;
            }
            var _loc_4:* = _a;
            var _loc_5:* = new Array(param1 * param2 * param3);
            _a = new Array(param1 * param2 * param3);
            var _loc_6:* = param1 < _w ? (param1) : (_w);
            var _loc_7:* = param2 < _h ? (param2) : (_h);
            var _loc_8:* = param3 < _d ? (param3) : (_d);
            var _loc_9:int = 0;
            while (_loc_9 < _loc_8)
            {
                
                _loc_9++;
                _loc_10 = _loc_9;
                _loc_11 = _loc_10 * param1 * param2;
                _loc_12 = _loc_10 * _w * _h;
                _loc_13 = 0;
                while (_loc_13 < _loc_7)
                {
                    
                    _loc_13++;
                    _loc_14 = _loc_13;
                    _loc_15 = _loc_14 * param1;
                    _loc_16 = _loc_14 * _w;
                    _loc_17 = 0;
                    while (_loc_17 < _loc_6)
                    {
                        
                        _loc_17++;
                        _loc_18 = _loc_17;
                        _a[_loc_11 + _loc_15 + _loc_18] = _loc_4[_loc_12 + _loc_16 + _loc_18];
                    }
                }
            }
            _w = param1;
            _h = param2;
            _d = param3;
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:* = _w * _h * _d;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                if (_a[_loc_6] == _loc_2)
                {
                    _a[_loc_6] = null;
                    _loc_3 = true;
                }
            }
            return _loc_3;
        }// end function

        public function iterator() : Itr
        {
            return new Array3Iterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return false;
        }// end function

        public function indexToCell(param1:int, param2:Array3Cell) : Array3Cell
        {
            var _loc_3:* = _w * _h;
            var _loc_4:* = param1 % _loc_3;
            param2.z = param1 / _loc_3;
            param2.y = _loc_4 / _w;
            param2.x = _loc_4 % _w;
            return param2;
        }// end function

        public function indexOf(param1:Object) : int
        {
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h * _d;
            while (_loc_2 < _loc_3)
            {
                
                if (_a[_loc_2] == param1)
                {
                    break;
                }
                _loc_2++;
            }
            return _loc_2 == _loc_3 ? (-1) : (_loc_2);
            return;
        }// end function

        public function getW() : int
        {
            return _w;
        }// end function

        public function getRow(param1:int, param2:int, param3:Array) : Array
        {
            var _loc_7:int = 0;
            var _loc_4:* = param1 * _w * _h + param2 * _w;
            var _loc_5:int = 0;
            var _loc_6:* = _w;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                param3.push(_a[_loc_4 + _loc_7]);
            }
            return param3;
        }// end function

        public function getPile(param1:int, param2:int, param3:Array) : Array
        {
            var _loc_8:int = 0;
            var _loc_4:* = _w * _h;
            var _loc_5:* = param2 * _w + param1;
            var _loc_6:int = 0;
            var _loc_7:* = _d;
            while (_loc_6 < _loc_7)
            {
                
                _loc_6++;
                _loc_8 = _loc_6;
                param3.push(_a[_loc_8 * _loc_4 + _loc_5]);
            }
            return param3;
        }// end function

        public function getLayer(param1:int, param2:Array2) : Array2
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_3:* = param1 * _w * _h;
            var _loc_4:int = 0;
            var _loc_5:* = _w;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_7 = 0;
                _loc_8 = _h;
                while (_loc_7 < _loc_8)
                {
                    
                    _loc_7++;
                    _loc_9 = _loc_7;
                    param2._a[_loc_9 * param2._w + _loc_6] = _a[_loc_3 + _loc_9 * _w + _loc_6];
                }
            }
            return param2;
        }// end function

        public function getIndex(param1:int, param2:int, param3:int) : int
        {
            return param3 * _w * _h + param2 * _w + param1;
        }// end function

        public function getH() : int
        {
            return _h;
        }// end function

        public function getD() : int
        {
            return _d;
        }// end function

        public function getCol(param1:int, param2:int, param3:Array) : Array
        {
            var _loc_7:int = 0;
            var _loc_4:* = param1 * _w * _h;
            var _loc_5:int = 0;
            var _loc_6:* = _h;
            while (_loc_5 < _loc_6)
            {
                
                _loc_5++;
                _loc_7 = _loc_5;
                param3.push(_a[_loc_4 + (_loc_7 * _w + param2)]);
            }
            return param3;
        }// end function

        public function getArray() : Array
        {
            return _a;
        }// end function

        public function get(param1:int, param2:int, param3:int) : Object
        {
            return _a[param3 * _w * _h + param2 * _w + param1];
        }// end function

        public function free() : void
        {
            var _loc_4:int = 0;
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h * _d;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[_loc_4] = _loc_1;
            }
            _a = null;
            return;
        }// end function

        public function fill(param1:Object) : void
        {
            var _loc_4:int = 0;
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h * _d;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _a[_loc_4] = param1;
            }
            return;
        }// end function

        public function contains(param1:Object) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_2:* = param1;
            var _loc_3:int = 0;
            var _loc_4:* = _w * _h * _d;
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
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:* = null as Cloneable;
            var _loc_3:* = param2;
            var _loc_4:* = new Array3(_w, _h, _d);
            if (param1)
            {
                _loc_5 = 0;
                _loc_6 = _w * _h * _d;
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
                _loc_6 = _w * _h * _d;
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
                _loc_6 = _w * _h * _d;
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
            var _loc_5:int = 0;
            var _loc_2:Object = null;
            var _loc_3:int = 0;
            var _loc_4:* = _a.length;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5] = null;
            }
            return;
        }// end function

        public function cellToIndex(param1:Array3Cell) : int
        {
            return param1.z * _w * _h + param1.y * _w + param1.x;
        }// end function

        public function cellOf(param1:Object, param2:Array3Cell) : Array3Cell
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            _loc_4 = 0;
            _loc_5 = _w * _h * _d;
            while (_loc_4 < _loc_5)
            {
                
                if (_a[_loc_4] == param1)
                {
                    break;
                }
                _loc_4++;
            }
            var _loc_3:* = _loc_4 == _loc_5 ? (-1) : (_loc_4);
            if (_loc_3 == -1)
            {
                return null;
            }
            else
            {
                _loc_4 = _w * _h;
                _loc_5 = _loc_3 % _loc_4;
                param2.z = _loc_3 / _loc_4;
                param2.y = _loc_5 / _w;
            }
            param2.x = _loc_5 % _w;
            return param2;
        }// end function

        public function assign(param1:Class, param2:Array = ) : void
        {
            var _loc_5:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = _w * _h * _d;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5] = Instance.create(param1, param2);
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

    }
}
