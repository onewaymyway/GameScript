package com.smartfoxserver.v2.entities.data
{

    public class SFSDataWrapper extends Object
    {
        private var _type:int;
        private var _data:Object;

        public function SFSDataWrapper(param1:int, param2)
        {
            this._type = param1;
            this._data = param2;
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function get data()
        {
            return this._data;
        }// end function

    }
}
