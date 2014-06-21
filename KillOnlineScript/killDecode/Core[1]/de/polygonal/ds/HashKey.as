package de.polygonal.ds
{

    public class HashKey extends Object
    {
        public static var _counter:int;

        public function HashKey() : void
        {
            return;
        }// end function

        public static function next() : int
        {
            var _loc_1:* = HashKey._counter;
            (HashKey._counter + 1);
            return _loc_1;
        }// end function

    }
}
