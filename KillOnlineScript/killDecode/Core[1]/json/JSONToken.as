package json
{

    public class JSONToken extends Object
    {
        private var _value:Object;
        private var _type:int;

        public function JSONToken(param1:int = -1, param2:Object = null)
        {
            _type = param1;
            _value = param2;
            return;
        }// end function

        public function get value() : Object
        {
            return _value;
        }// end function

        public function get type() : int
        {
            return _type;
        }// end function

        public function set type(param1:int) : void
        {
            _type = param1;
            return;
        }// end function

        public function set value(param1:Object) : void
        {
            _value = param1;
            return;
        }// end function

    }
}
