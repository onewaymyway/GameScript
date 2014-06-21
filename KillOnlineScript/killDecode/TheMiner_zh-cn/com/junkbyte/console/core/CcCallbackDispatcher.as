package com.junkbyte.console.core
{

    public class CcCallbackDispatcher extends Object
    {
        private var _list:Array;

        public function CcCallbackDispatcher()
        {
            this._list = new Array();
            return;
        }// end function

        public function add(callback:Function) : void
        {
            this.remove(callback);
            this._list.push(callback);
            return;
        }// end function

        public function remove(callback:Function) : void
        {
            var _loc_2:* = this._list.indexOf(callback);
            if (_loc_2 >= 0)
            {
                this._list.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function apply(param:Object) : void
        {
            var _loc_2:* = this._list.length;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                var _loc_4:* = this._list;
                _loc_4.this._list[_loc_3](param);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function clear() : void
        {
            this._list.splice(0, this._list.length);
            return;
        }// end function

    }
}
