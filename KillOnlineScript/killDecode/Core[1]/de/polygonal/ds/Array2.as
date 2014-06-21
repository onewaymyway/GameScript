package de.polygonal.ds
{
    import de.polygonal.core.fmt.*;
    import de.polygonal.core.util.*;
    import flash.*;

    public class Array2 extends Object implements Collection
    {
        public var key:int;
        public var _w:int;
        public var _h:int;
        public var _a:Array;

        public function Array2(param1:int = 0, param2:int = 0) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            _w = param1;
            _h = param2;
            var _loc_3:* = new Array(_w * _h);
            _a = _loc_3;
            var _loc_4:* = HashKey._counter;
            (HashKey._counter + 1);
            key = _loc_4;
            return;
        }// end function

        public function walk(param1:Function) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_2:int = 0;
            var _loc_3:* = _h;
            while (_loc_2 < _loc_3)
            {
                
                _loc_2++;
                _loc_4 = _loc_2;
                _loc_5 = 0;
                _loc_6 = _w;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_5++;
                    _loc_7 = _loc_5;
                    _loc_8 = _loc_4 * _w + _loc_7;
                    _a[_loc_8] = this.param1(_a[_loc_8], _loc_7, _loc_4);
                }
            }
            return;
        }// end function

        public function transpose() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:* = null as Object;
            var _loc_10:* = null as Array;
            if (_w == _h)
            {
                _loc_1 = 0;
                _loc_2 = _h;
                while (_loc_1 < _loc_2)
                {
                    
                    _loc_1++;
                    _loc_3 = _loc_1;
                    _loc_4 = _loc_3 + 1;
                    _loc_5 = _w;
                    while (_loc_4 < _loc_5)
                    {
                        
                        _loc_4++;
                        _loc_6 = _loc_4;
                        _loc_7 = _loc_3 * _w + _loc_6;
                        _loc_8 = _loc_6 * _w + _loc_3;
                        _loc_9 = _a[_loc_7];
                        _a[_loc_7] = _a[_loc_8];
                        _a[_loc_8] = _loc_9;
                    }
                }
            }
            else
            {
                _loc_10 = [];
                _loc_1 = 0;
                _loc_2 = _h;
                while (_loc_1 < _loc_2)
                {
                    
                    _loc_1++;
                    _loc_3 = _loc_1;
                    _loc_4 = 0;
                    _loc_5 = _w;
                    while (_loc_4 < _loc_5)
                    {
                        
                        _loc_4++;
                        _loc_6 = _loc_4;
                        _loc_10[_loc_6 * _h + _loc_3] = _a[_loc_3 * _w + _loc_6];
                    }
                }
                _a = _loc_10;
                _w = _w ^ _h;
                _h = _h ^ _w;
                _w = _w ^ _h;
            }
            return;
        }// end function

        public function toString() : String
        {
            return Sprintf.format("{Array2, %dx%d}", [_w, _h]);
        }// end function

        public function toDA() : DA
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_1:* = new DA(_w * _h);
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h;
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
            var _loc_2:* = new Array(_w * _h);
            var _loc_1:* = _loc_2;
            var _loc_3:int = 0;
            var _loc_4:* = _w * _h;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_1[_loc_5] = _a[_loc_5];
            }
            return _loc_1;
        }// end function

        public function swap(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:* = param2 * _w + param1;
            var _loc_6:* = param4 * _w + param3;
            var _loc_7:* = _a[_loc_5];
            _a[_loc_5] = _a[_loc_6];
            _a[_loc_6] = _loc_7;
            return;
        }// end function

        public function size() : int
        {
            return _w * _h;
        }// end function

        public function shuffle(param1:DA = ) : void
        {
            var _loc_3:* = null as Class;
            var _loc_4:int = 0;
            var _loc_5:* = null as Object;
            var _loc_6:int = 0;
            var _loc_2:* = _w * _h;
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

        public function shiftW() : void
        {
            var _loc_1:* = null as Object;
            var _loc_2:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = _h;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _loc_2 = _loc_5 * _w;
                _loc_1 = _a[_loc_2];
                _loc_6 = 1;
                _loc_7 = _w;
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_6++;
                    _loc_8 = _loc_6;
                    _a[_loc_2 + _loc_8 - 1] = _a[_loc_2 + _loc_8];
                }
                _a[_loc_2 + _w - 1] = _loc_1;
            }
            return;
        }// end function

        public function shiftS() : void
        {
            var _loc_1:* = null as Object;
            var _loc_3:int = 0;
            var _loc_8:int = 0;
            var _loc_5:* = --_h * _w;
            var _loc_6:int = 0;
            var _loc_7:* = _w;
            while (_loc_6 < _loc_7)
            {
                
                _loc_6++;
                _loc_8 = _loc_6;
                _loc_1 = _a[_loc_5 + _loc_8];
                _loc_3 = _h - 1;
                do
                {
                    
                    _a[(_loc_3 + 1) * _w + _loc_8] = _a[_loc_3 * _w + _loc_8];
                    _loc_3--;
                }while (_loc_3 > 0)
                _a[_loc_8] = _loc_1;
            }
            return;
        }// end function

        public function shiftN() : void
        {
            var _loc_1:* = null as Object;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_2:* = _h - 1;
            var _loc_3:* = (_h - 1) * _w;
            var _loc_4:int = 0;
            var _loc_5:* = _w;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_1 = _a[_loc_6];
                _loc_7 = 0;
                while (_loc_7 < _loc_2)
                {
                    
                    _loc_7++;
                    _loc_8 = _loc_7;
                    _a[_loc_8 * _w + _loc_6] = _a[(_loc_8 + 1) * _w + _loc_6];
                }
                _a[_loc_3 + _loc_6] = _loc_1;
            }
            return;
        }// end function

        public function shiftE() : void
        {
            var _loc_1:* = null as Object;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_6:int = 0;
            var _loc_4:int = 0;
            var _loc_5:* = _h;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _loc_3 = _loc_6 * _w;
                _loc_1 = _a[_loc_3 + _w - 1];
                _loc_2 = _w - 1;
                do
                {
                    
                    _a[_loc_3 + _loc_2 + 1] = _a[_loc_3 + _loc_2];
                    _loc_2--;
                }while (_loc_2 > 0)
                _a[_loc_3] = _loc_1;
            }
            return;
        }// end function

        public function setW(param1:int) : void
        {
            resize(param1, _h);
            return;
        }// end function

        public function setRow(param1:int, param2:Array) : void
        {
            var _loc_6:int = 0;
            var _loc_3:* = param1 * _w;
            var _loc_4:int = 0;
            var _loc_5:* = _w;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                _a[_loc_3 + _loc_6] = param2[_loc_6];
            }
            return;
        }// end function

        public function setH(param1:int) : void
        {
            resize(_w, param1);
            return;
        }// end function

        public function setCol(param1:int, param2:Array) : void
        {
            var _loc_5:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = _h;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5 * _w + param1] = param2[_loc_5];
            }
            return;
        }// end function

        public function setAtIndex(param1:int, param2:Object) : void
        {
            _a[param1 / _w * _w + param1 % _w] = param2;
            return;
        }// end function

        public function set(param1:int, param2:int, param3:Object) : void
        {
            _a[param2 * _w + param1] = param3;
            return;
        }// end function

        public function resize(param1:int, param2:int) : void
        {
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            if (param1 == _w)
            {
            }
            if (param2 == _h)
            {
                return;
            }
            var _loc_3:* = _a;
            var _loc_4:* = new Array(param1 * param2);
            _a = new Array(param1 * param2);
            var _loc_5:* = param1 < _w ? (param1) : (_w);
            var _loc_6:* = param2 < _h ? (param2) : (_h);
            var _loc_7:int = 0;
            while (_loc_7 < _loc_6)
            {
                
                _loc_7++;
                _loc_8 = _loc_7;
                _loc_9 = _loc_8 * param1;
                _loc_10 = _loc_8 * _w;
                _loc_11 = 0;
                while (_loc_11 < _loc_5)
                {
                    
                    _loc_11++;
                    _loc_12 = _loc_11;
                    _a[_loc_9 + _loc_12] = _loc_3[_loc_10 + _loc_12];
                }
            }
            _w = param1;
            _h = param2;
            return;
        }// end function

        public function remove(param1:Object) : Boolean
        {
            var _loc_6:int = 0;
            var _loc_2:* = param1;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:* = _w * _h;
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

        public function prependRow(param1:Array) : void
        {
            (_h + 1);
            var _loc_2:* = _w * _h;
            do
            {
                
                _a[_loc_2] = _a[_loc_2 - _w];
                _loc_2--;
            }while (_loc_2 > _w)
            _loc_2++;
            do
            {
                
                _a[_loc_2] = param1[_loc_2];
                _loc_2--;
            }while (_loc_2 > 0)
            return;
        }// end function

        public function prependCol(param1:Array) : void
        {
            var _loc_2:* = _w * _h + _h;
            var _loc_3:* = _h - 1;
            var _loc_4:* = _h;
            var _loc_5:int = 0;
            var _loc_6:* = _loc_2;
            do
            {
                
                _loc_5++;
                if (_loc_5 > _w)
                {
                    _loc_5 = 0;
                    _loc_4--;
                    _loc_3--;
                    _a[_loc_6] = param1[_loc_3];
                }
                else
                {
                    _a[_loc_6] = _a[_loc_6 - _loc_4];
                }
                _loc_6--;
            }while (_loc_6 > 0)
            (_w + 1);
            return;
        }// end function

        public function iterator() : Itr
        {
            return new Array2Iterator(this);
        }// end function

        public function isEmpty() : Boolean
        {
            return false;
        }// end function

        public function indexToCell(param1:int, param2:Array2Cell) : Array2Cell
        {
            param2.y = param1 / _w;
            param2.x = param1 % _w;
            return param2;
        }// end function

        public function indexOf(param1:Object) : int
        {
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h;
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

        public function getRow(param1:int, param2:Array) : Array
        {
            var _loc_6:int = 0;
            var _loc_3:* = param1 * _w;
            var _loc_4:int = 0;
            var _loc_5:* = _w;
            while (_loc_4 < _loc_5)
            {
                
                _loc_4++;
                _loc_6 = _loc_4;
                param2[_loc_6] = _a[_loc_3 + _loc_6];
            }
            return param2;
        }// end function

        public function getIndex(param1:int, param2:int) : int
        {
            return param2 * _w + param1;
        }// end function

        public function getH() : int
        {
            return _h;
        }// end function

        public function getCol(param1:int, param2:Array) : Array
        {
            var _loc_5:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = _h;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                param2[_loc_5] = _a[_loc_5 * _w + param1];
            }
            return param2;
        }// end function

        public function getAtIndex(param1:int) : Object
        {
            return _a[param1 / _w * _w + param1 % _w];
        }// end function

        public function getArray() : Array
        {
            return _a;
        }// end function

        public function get(param1:int, param2:int) : Object
        {
            return _a[param2 * _w + param1];
        }// end function

        public function free() : void
        {
            var _loc_4:int = 0;
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            var _loc_3:* = _w * _h;
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
            var _loc_3:* = _w * _h;
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
            var _loc_4:* = _w * _h;
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
            var _loc_4:* = new Array2(_w, _h);
            if (param1)
            {
                _loc_5 = 0;
                _loc_6 = _w * _h;
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
                _loc_6 = _w * _h;
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
                _loc_6 = _w * _h;
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
                _a[_loc_5] = _loc_2;
            }
            return;
        }// end function

        public function cellToIndex(param1:Array2Cell) : int
        {
            return param1.y * _w + param1.x;
        }// end function

        public function cellOf(param1:Object, param2:Array2Cell) : Array2Cell
        {
            var _loc_4:int = 0;
            var _loc_5:* = _w * _h;
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
                param2.y = _loc_3 / _w;
            }
            param2.x = _loc_3 % _w;
            return param2;
        }// end function

        public function assign(param1:Class, param2:Array = ) : void
        {
            var _loc_5:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = _w * _h;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5] = Instance.create(param1, param2);
            }
            return;
        }// end function

        public function appendRow(param1:Array) : void
        {
            var _loc_5:int = 0;
            var _loc_3:* = _h;
            (_h + 1);
            var _loc_2:* = _w * _loc_3;
            _loc_3 = 0;
            var _loc_4:* = _w;
            while (_loc_3 < _loc_4)
            {
                
                _loc_3++;
                _loc_5 = _loc_3;
                _a[_loc_5 + _loc_2] = param1[_loc_5];
            }
            return;
        }// end function

        public function appendCol(param1:Array) : void
        {
            var _loc_2:* = _w * _h + _h;
            var _loc_3:* = _h - 1;
            var _loc_4:* = _h;
            var _loc_5:* = _w;
            var _loc_6:* = _loc_2;
            do
            {
                
                _loc_5++;
                if (_loc_5 > _w)
                {
                    _loc_5 = 0;
                    _loc_4--;
                    _loc_3--;
                    _a[_loc_6] = param1[_loc_3];
                }
                else
                {
                    _a[_loc_6] = _a[_loc_6 - _loc_4];
                }
                _loc_6--;
            }while (_loc_6 > 0)
            (_w + 1);
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
