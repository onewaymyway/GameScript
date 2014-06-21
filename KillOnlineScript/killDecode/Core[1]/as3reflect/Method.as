package as3reflect
{
    import flash.utils.*;

    public class Method extends MetaDataContainer
    {
        private var _declaringType:Type;
        private var _parameters:Array;
        private var _name:String;
        private var _returnType:Type;
        private var _isStatic:Boolean;

        public function Method(param1:Type, param2:String, param3:Boolean, param4:Array, param5, param6:Array = null)
        {
            super(param6);
            _declaringType = param1;
            _name = param2;
            _isStatic = param3;
            _parameters = param4;
            _returnType = param5;
            return;
        }// end function

        public function get declaringType() : Type
        {
            return _declaringType;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function toString() : String
        {
            return "[Method(name:\'" + name + "\', isStatic:" + isStatic + ")]";
        }// end function

        public function get returnType() : Type
        {
            return _returnType;
        }// end function

        public function invoke(param1, param2:Array)
        {
            var _loc_3:* = undefined;
            if (param1 is Proxy)
            {
            }
            else
            {
                _loc_3 = param1[name].apply(param1, param2);
            }
            return _loc_3;
        }// end function

        public function get parameters() : Array
        {
            return _parameters;
        }// end function

        public function get fullName() : String
        {
            var _loc_3:Parameter = null;
            var _loc_1:String = "public ";
            if (isStatic)
            {
                _loc_1 = _loc_1 + "static ";
            }
            _loc_1 = _loc_1 + (name + "(");
            var _loc_2:int = 0;
            while (_loc_2 < parameters.length)
            {
                
                _loc_3 = parameters[_loc_2] as Parameter;
                _loc_1 = _loc_1 + _loc_3.type.name;
                _loc_1 = _loc_1 + (_loc_2 < (parameters.length - 1) ? (", ") : (""));
                _loc_2++;
            }
            _loc_1 = _loc_1 + ("):" + returnType.name);
            return _loc_1;
        }// end function

        public function get isStatic() : Boolean
        {
            return _isStatic;
        }// end function

    }
}
