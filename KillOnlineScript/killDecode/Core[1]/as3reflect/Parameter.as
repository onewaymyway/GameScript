package as3reflect
{

    public class Parameter extends Object
    {
        private var _type:Type;
        private var _index:int;
        private var _isOptional:Boolean;

        public function Parameter(param1:int, param2:Type, param3:Boolean = false)
        {
            _index = param1;
            _type = param2;
            _isOptional = param3;
            return;
        }// end function

        public function get index() : int
        {
            return _index;
        }// end function

        public function get isOptional() : Boolean
        {
            return _isOptional;
        }// end function

        public function get type() : Type
        {
            return _type;
        }// end function

    }
}
