package as3reflect
{
    import flash.utils.*;

    public class Type extends MetaDataContainer
    {
        private var _class:Class;
        private var _accessors:Array;
        private var _isStatic:Boolean;
        private var _fullName:String;
        private var _isFinal:Boolean;
        private var _isDynamic:Boolean;
        private var _staticConstants:Array;
        private var _constants:Array;
        private var _fields:Array;
        private var _name:String;
        private var _methods:Array;
        private var _variables:Array;
        private var _staticVariables:Array;
        public static const UNTYPED:Type = new Type;
        public static const PRIVATE:Type = new Type;
        public static const VOID:Type = new Type;
        private static var _cache:Object = {};

        public function Type()
        {
            _methods = new Array();
            _accessors = new Array();
            _staticConstants = new Array();
            _constants = new Array();
            _staticVariables = new Array();
            _variables = new Array();
            _fields = new Array();
            return;
        }// end function

        public function get staticConstants() : Array
        {
            return _staticConstants;
        }// end function

        public function set staticConstants(param1:Array) : void
        {
            _staticConstants = param1;
            return;
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function get accessors() : Array
        {
            return _accessors;
        }// end function

        public function set name(param1:String) : void
        {
            _name = param1;
            return;
        }// end function

        public function set accessors(param1:Array) : void
        {
            _accessors = param1;
            return;
        }// end function

        public function set constants(param1:Array) : void
        {
            _constants = param1;
            return;
        }// end function

        public function get staticVariables() : Array
        {
            return _staticVariables;
        }// end function

        public function get methods() : Array
        {
            return _methods;
        }// end function

        public function get isDynamic() : Boolean
        {
            return _isDynamic;
        }// end function

        public function set clazz(param1:Class) : void
        {
            _class = param1;
            return;
        }// end function

        public function get isStatic() : Boolean
        {
            return _isStatic;
        }// end function

        public function get fullName() : String
        {
            return _fullName;
        }// end function

        public function get fields() : Array
        {
            return accessors.concat(staticConstants).concat(constants).concat(staticVariables).concat(variables);
        }// end function

        public function getField(param1:String) : Field
        {
            var _loc_2:Field = null;
            var _loc_3:Field = null;
            for each (_loc_3 in fields)
            {
                
                if (_loc_3.name == param1)
                {
                    _loc_2 = _loc_3;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function get constants() : Array
        {
            return _constants;
        }// end function

        public function set staticVariables(param1:Array) : void
        {
            _staticVariables = param1;
            return;
        }// end function

        public function getMethod(param1:String) : Method
        {
            var _loc_2:Method = null;
            var _loc_3:Method = null;
            for each (_loc_3 in methods)
            {
                
                if (_loc_3.name == param1)
                {
                    _loc_2 = _loc_3;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function get clazz() : Class
        {
            return _class;
        }// end function

        public function set methods(param1:Array) : void
        {
            _methods = param1;
            return;
        }// end function

        public function set isFinal(param1:Boolean) : void
        {
            _isFinal = param1;
            return;
        }// end function

        public function set isDynamic(param1:Boolean) : void
        {
            _isDynamic = param1;
            return;
        }// end function

        public function set variables(param1:Array) : void
        {
            _variables = param1;
            return;
        }// end function

        public function set isStatic(param1:Boolean) : void
        {
            _isStatic = param1;
            return;
        }// end function

        public function set fullName(param1:String) : void
        {
            _fullName = param1;
            return;
        }// end function

        public function get isFinal() : Boolean
        {
            return _isFinal;
        }// end function

        public function get variables() : Array
        {
            return _variables;
        }// end function

        public static function forName(param1:String) : Type
        {
            var result:Type;
            var name:* = param1;
            switch(name)
            {
                case "void":
                {
                    result = Type.VOID;
                    break;
                }
                case "*":
                {
                    result = Type.UNTYPED;
                    break;
                }
                default:
                {
                    try
                    {
                        result = Type.forClass(Class(getDefinitionByName(name)));
                    }
                    catch (e:ReferenceError)
                    {
                        trace("Type.forName error: " + e.message + " The class \'" + name + "\' is probably an internal class or it may not have been compiled.");
                    }
                    break;
                }
            }
            return result;
        }// end function

        public static function forInstance(param1) : Type
        {
            var _loc_2:Type = null;
            var _loc_3:* = ClassUtils.forInstance(param1);
            if (_loc_3 != null)
            {
                _loc_2 = Type.forClass(_loc_3);
            }
            return _loc_2;
        }// end function

        public static function forClass(param1:Class) : Type
        {
            var _loc_2:Type = null;
            var _loc_4:XML = null;
            var _loc_3:* = ClassUtils.getFullyQualifiedName(param1);
            if (_cache[_loc_3])
            {
                _loc_2 = _cache[_loc_3];
            }
            else
            {
                _loc_4 = describeType(param1);
                _loc_2 = new Type;
                _cache[_loc_3] = _loc_2;
                _loc_2.fullName = _loc_3;
                _loc_2.name = ClassUtils.getNameFromFullyQualifiedName(_loc_3);
                _loc_2.clazz = param1;
                _loc_2.isDynamic = _loc_4.@isDynamic;
                _loc_2.isFinal = _loc_4.@isFinal;
                _loc_2.isStatic = _loc_4.@isStatic;
                _loc_2.accessors = TypeXmlParser.parseAccessors(_loc_2, _loc_4);
                _loc_2.methods = TypeXmlParser.parseMethods(_loc_2, _loc_4);
                _loc_2.staticConstants = TypeXmlParser.parseMembers(Constant, _loc_4.constant, _loc_2, true);
                _loc_2.constants = TypeXmlParser.parseMembers(Constant, _loc_4.factory.constant, _loc_2, false);
                _loc_2.staticVariables = TypeXmlParser.parseMembers(Variable, _loc_4.variable, _loc_2, true);
                _loc_2.variables = TypeXmlParser.parseMembers(Variable, _loc_4.factory.variable, _loc_2, false);
                TypeXmlParser.parseMetaData(_loc_4.factory[0].metadata, _loc_2);
            }
            return _loc_2;
        }// end function

    }
}
