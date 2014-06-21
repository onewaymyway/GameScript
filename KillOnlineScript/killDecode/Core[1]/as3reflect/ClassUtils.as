package as3reflect
{
    import as3reflect.errors.*;
    import flash.system.*;
    import flash.utils.*;

    public class ClassUtils extends Object
    {
        private static const PACKAGE_CLASS_SEPARATOR:String = "::";

        public function ClassUtils()
        {
            return;
        }// end function

        public static function getName(param1:Class) : String
        {
            return getNameFromFullyQualifiedName(getFullyQualifiedName(param1));
        }// end function

        public static function getImplementedInterfaces(param1:Class) : Array
        {
            var _loc_2:* = getFullyQualifiedImplementedInterfaceNames(param1);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_2[_loc_3] = getDefinitionByName(_loc_2[_loc_3]);
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function getNameFromFullyQualifiedName(param1:String) : String
        {
            var _loc_2:String = "";
            var _loc_3:* = param1.indexOf(PACKAGE_CLASS_SEPARATOR);
            if (_loc_3 == -1)
            {
                _loc_2 = param1;
            }
            else
            {
                _loc_2 = param1.substring(_loc_3 + PACKAGE_CLASS_SEPARATOR.length, param1.length);
            }
            return _loc_2;
        }// end function

        public static function getFullyQualifiedImplementedInterfaceNames(param1:Class, param2:Boolean = false) : Array
        {
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:String = null;
            var _loc_3:Array = [];
            var _loc_4:* = MetadataUtils.getFromObject(param1);
            var _loc_5:* = MetadataUtils.getFromObject(param1).factory.implementsInterface;
            if (MetadataUtils.getFromObject(param1).factory.implementsInterface)
            {
                _loc_6 = _loc_5.length();
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    _loc_8 = _loc_5[_loc_7].@type.toString();
                    if (param2)
                    {
                        _loc_8 = convertFullyQualifiedName(_loc_8);
                    }
                    _loc_3.push(_loc_8);
                    _loc_7++;
                }
            }
            return _loc_3;
        }// end function

        public static function isImplementationOf(param1:Class, param2:Class) : Boolean
        {
            var result:Boolean;
            var classDescription:XML;
            var clazz:* = param1;
            var interfaze:* = param2;
            if (clazz == null)
            {
                result;
            }
            else
            {
                classDescription = MetadataUtils.getFromObject(clazz);
                var _loc_5:int = 0;
                var _loc_6:* = classDescription.factory.implementsInterface;
                var _loc_4:* = new XMLList("");
                for each (_loc_7 in _loc_6)
                {
                    
                    var _loc_8:* = _loc_6[_loc_5];
                    with (_loc_6[_loc_5])
                    {
                        if (@type == getQualifiedClassName(interfaze))
                        {
                            _loc_4[_loc_5] = _loc_7;
                        }
                    }
                }
                result = _loc_4.length() != 0;
            }
            return result;
        }// end function

        public static function forInstance(param1, param2:ApplicationDomain = null) : Class
        {
            var _loc_3:* = getQualifiedClassName(param1);
            return forName(_loc_3, param2);
        }// end function

        public static function getFullyQualifiedSuperClassName(param1:Class, param2:Boolean = false) : String
        {
            var _loc_3:* = getQualifiedSuperclassName(param1);
            if (param2)
            {
                _loc_3 = convertFullyQualifiedName(_loc_3);
            }
            return _loc_3;
        }// end function

        public static function getFullyQualifiedName(param1:Class, param2:Boolean = false) : String
        {
            var _loc_3:* = getQualifiedClassName(param1);
            if (param2)
            {
                _loc_3 = convertFullyQualifiedName(_loc_3);
            }
            return _loc_3;
        }// end function

        public static function forName(param1:String, param2:ApplicationDomain = null) : Class
        {
            var result:Class;
            var name:* = param1;
            var applicationDomain:* = param2;
            if (!applicationDomain)
            {
                applicationDomain = ApplicationDomain.currentDomain;
            }
            while (!applicationDomain.hasDefinition(name))
            {
                
                if (applicationDomain.parentDomain)
                {
                    applicationDomain = applicationDomain.parentDomain;
                    continue;
                }
                break;
            }
            try
            {
                result = applicationDomain.getDefinition(name) as Class;
            }
            catch (e:ReferenceError)
            {
                throw new ClassNotFoundError("A class with the name \'" + name + "\' could not be found.");
            }
            return result;
        }// end function

        public static function newInstance(param1:Class, param2:Array = null)
        {
            var _loc_3:* = undefined;
            var _loc_4:* = param2 == null ? ([]) : (param2);
            switch(_loc_4.length)
            {
                case 1:
                {
                    _loc_3 = new param1(_loc_4[0]);
                    break;
                }
                case 2:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1]);
                    break;
                }
                case 3:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2]);
                    break;
                }
                case 4:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3]);
                    break;
                }
                case 5:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4]);
                    break;
                }
                case 6:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4], _loc_4[5]);
                    break;
                }
                case 7:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4], _loc_4[5], _loc_4[6]);
                    break;
                }
                case 8:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4], _loc_4[5], _loc_4[6], _loc_4[7]);
                    break;
                }
                case 9:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4], _loc_4[5], _loc_4[6], _loc_4[7], _loc_4[8]);
                    break;
                }
                case 10:
                {
                    _loc_3 = new param1(_loc_4[0], _loc_4[1], _loc_4[2], _loc_4[3], _loc_4[4], _loc_4[5], _loc_4[6], _loc_4[7], _loc_4[8], _loc_4[9]);
                    break;
                }
                default:
                {
                    _loc_3 = new param1;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public static function convertFullyQualifiedName(param1:String) : String
        {
            return param1.replace(PACKAGE_CLASS_SEPARATOR, ".");
        }// end function

        public static function isSubclassOf(param1:Class, param2:Class) : Boolean
        {
            var clazz:* = param1;
            var parentClass:* = param2;
            var classDescription:* = MetadataUtils.getFromObject(clazz);
            var parentName:* = getQualifiedClassName(parentClass);
            var _loc_5:int = 0;
            var _loc_6:* = classDescription.factory.extendsClass;
            var _loc_4:* = new XMLList("");
            for each (_loc_7 in _loc_6)
            {
                
                var _loc_8:* = _loc_6[_loc_5];
                with (_loc_6[_loc_5])
                {
                    if (@type == parentName)
                    {
                        _loc_4[_loc_5] = _loc_7;
                    }
                }
            }
            return _loc_4.length() != 0;
        }// end function

        public static function getSuperClass(param1:Class) : Class
        {
            var _loc_2:Class = null;
            var _loc_3:* = MetadataUtils.getFromObject(param1);
            var _loc_4:* = _loc_3.factory.extendsClass;
            if (_loc_3.factory.extendsClass.length() > 0)
            {
                _loc_2 = ClassUtils.forName(_loc_4[0].@type);
            }
            return _loc_2;
        }// end function

        public static function getImplementedInterfaceNames(param1:Class) : Array
        {
            var _loc_2:* = getFullyQualifiedImplementedInterfaceNames(param1);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_2[_loc_3] = getNameFromFullyQualifiedName(_loc_2[_loc_3]);
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function getSuperClassName(param1:Class) : String
        {
            var _loc_2:* = getFullyQualifiedSuperClassName(param1);
            var _loc_3:* = _loc_2.indexOf(PACKAGE_CLASS_SEPARATOR) + PACKAGE_CLASS_SEPARATOR.length;
            return _loc_2.substring(_loc_3, _loc_2.length);
        }// end function

    }
}
