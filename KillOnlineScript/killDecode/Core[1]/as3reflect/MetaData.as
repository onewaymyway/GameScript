package as3reflect
{

    public class MetaData extends Object
    {
        private var _arguments:Array;
        private var _name:String;
        public static const TRANSIENT:String = "Transient";
        public static const BINDABLE:String = "Bindable";

        public function MetaData(param1:String, param2:Array = null)
        {
            _name = param1;
            _arguments = param2 == null ? ([]) : (param2);
            return;
        }// end function

        public function hasArgumentWithKey(param1:String) : Boolean
        {
            return getArgument(param1) != null;
        }// end function

        public function getArgument(param1:String) : MetaDataArgument
        {
            var _loc_2:MetaDataArgument = null;
            var _loc_3:int = 0;
            while (_loc_3 < _arguments.length)
            {
                
                if (_arguments[_loc_3].key == param1)
                {
                    _loc_2 = _arguments[_loc_3];
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function get arguments() : Array
        {
            return _arguments;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function toString() : String
        {
            return "[MetaData(" + name + ", " + arguments + ")]";
        }// end function

    }
}
