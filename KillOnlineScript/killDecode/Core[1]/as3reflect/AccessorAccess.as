package as3reflect
{

    final public class AccessorAccess extends Object
    {
        private var _name:String;
        private static const READ_ONLY_VALUE:String = "readonly";
        private static const READ_WRITE_VALUE:String = "readwrite";
        public static const WRITE_ONLY:AccessorAccess = new AccessorAccess(WRITE_ONLY_VALUE);
        public static const READ_ONLY:AccessorAccess = new AccessorAccess(READ_ONLY_VALUE);
        public static const READ_WRITE:AccessorAccess = new AccessorAccess(READ_WRITE_VALUE);
        private static const WRITE_ONLY_VALUE:String = "writeonly";

        public function AccessorAccess(param1:String)
        {
            _name = param1;
            return;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public static function fromString(param1:String) : AccessorAccess
        {
            var _loc_2:AccessorAccess = null;
            switch(param1)
            {
                case READ_ONLY_VALUE:
                {
                    _loc_2 = READ_ONLY;
                    break;
                }
                case WRITE_ONLY_VALUE:
                {
                    _loc_2 = WRITE_ONLY;
                    break;
                }
                case READ_WRITE_VALUE:
                {
                    _loc_2 = READ_WRITE;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

    }
}
