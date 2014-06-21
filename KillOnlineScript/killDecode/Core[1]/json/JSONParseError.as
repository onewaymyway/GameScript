package json
{

    public class JSONParseError extends Error
    {
        private var _location:int;
        private var _text:String;

        public function JSONParseError(param1:String = "", param2:int = 0, param3:String = "")
        {
            super(param1);
            _location = param2;
            _text = param3;
            return;
        }// end function

        public function get location() : int
        {
            return _location;
        }// end function

        public function get text() : String
        {
            return _text;
        }// end function

    }
}
