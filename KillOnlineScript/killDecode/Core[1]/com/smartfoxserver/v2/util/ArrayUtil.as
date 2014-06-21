package com.smartfoxserver.v2.util
{

    public class ArrayUtil extends Object
    {

        public function ArrayUtil()
        {
            throw new Error("This class contains static methods only! Do not instaniate it");
        }// end function

        public static function removeElement(param1:Array, param2) : void
        {
            var _loc_3:* = param1.indexOf(param2);
            if (_loc_3 > -1)
            {
                param1.splice(_loc_3, 1);
            }
            return;
        }// end function

        public static function copy(param1:Array) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2[_loc_3] = param1[_loc_3];
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function objToArray(param1:Object) : Array
        {
            var _loc_3:* = undefined;
            var _loc_2:Array = [];
            for each (_loc_3 in param1)
            {
                
                _loc_2.push(_loc_3);
            }
            return _loc_2;
        }// end function

    }
}
