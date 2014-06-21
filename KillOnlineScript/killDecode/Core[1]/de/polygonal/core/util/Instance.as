package de.polygonal.core.util
{
    import flash.*;

    public class Instance extends Object
    {

        public function Instance() : void
        {
            return;
        }// end function

        public static function create(param1:Class, param2:Array = ) : Object
        {
            if (param2 == null)
            {
                return new param1;
            }
            else
            {
                switch(param2.length) branch count is:<14>[71, 78, 92, 113, 141, 176, 218, 267, 323, 386, 456, 533, 617, 708, 806] default offset is:<50>;
                Boot.lastError = new Error();
                throw "too many arguments";
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                ;
                return new param1(param2[0], param2[1], param2[2], param2[3], param2[4], param2[5], param2[6], param2[7], param2[8], param2[9], param2[10], param2[11], param2[12], param2[13]);
            }
            return;
        }// end function

        public static function createEmpty(param1:Class) : Object
        {
            var _loc_3:* = null as Object;
            var _loc_4:* = null;
            Boot.skip_constructor = true;
            _loc_3 = new param1;
            Boot.skip_constructor = false;
            return _loc_3;
            ;
            _loc_4 = null;
            Boot.skip_constructor = false;
            Boot.lastError = new Error();
            throw _loc_4;
            return null;
        }// end function

    }
}
