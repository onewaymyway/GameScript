package com.demonsters.debugger
{
    import flash.display.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;

    class MonsterDebuggerUtils extends Object
    {
        private static var _references:Dictionary = new Dictionary(true);
        private static var _reference:int = 0;

        function MonsterDebuggerUtils()
        {
            return;
        }// end function

        public static function snapshot(object:DisplayObject, rectangle:Rectangle = null) : BitmapData
        {
            var _loc_10:Matrix = null;
            var _loc_11:Rectangle = null;
            var _loc_12:Number = NaN;
            var _loc_13:BitmapData = null;
            if (object == null)
            {
                return null;
            }
            var _loc_3:* = object.visible;
            var _loc_4:* = object.alpha;
            var _loc_5:* = object.rotation;
            var _loc_6:* = object.scaleX;
            var _loc_7:* = object.scaleY;
            try
            {
                object.visible = true;
                object.alpha = 1;
                object.rotation = 0;
                object.scaleX = 1;
                object.scaleY = 1;
            }
            catch (e1:Error)
            {
            }
            var _loc_8:* = object.getBounds(object);
            _loc_8.x = int(_loc_8.x + 0.5);
            _loc_8.y = int(_loc_8.y + 0.5);
            _loc_8.width = int(_loc_8.width + 0.5);
            _loc_8.height = int(_loc_8.height + 0.5);
            if (object is Stage)
            {
                _loc_8.x = 0;
                _loc_8.y = 0;
                _loc_8.width = Stage(object).stageWidth;
                _loc_8.height = Stage(object).stageHeight;
            }
            var _loc_9:BitmapData = null;
            if (_loc_8.width > 0)
            {
            }
            if (_loc_8.height <= 0)
            {
                return null;
            }
            _loc_9 = new BitmapData(_loc_8.width, _loc_8.height, false, 16777215);
            _loc_10 = new Matrix();
            _loc_10.tx = -_loc_8.x;
            _loc_10.ty = -_loc_8.y;
            _loc_9.draw(object, _loc_10, null, null, null, false);
            try
            {
                object.visible = _loc_3;
                object.alpha = _loc_4;
                object.rotation = _loc_5;
                object.scaleX = _loc_6;
                object.scaleY = _loc_7;
            }
            catch (e2:Error)
            {
            }
            if (rectangle != null)
            {
                if (_loc_8.width <= rectangle.width)
                {
                }
                if (_loc_8.height <= rectangle.height)
                {
                    return _loc_9;
                }
                _loc_11 = _loc_8.clone();
                _loc_11.width = rectangle.width;
                _loc_11.height = rectangle.width * (_loc_8.height / _loc_8.width);
                if (_loc_11.height > rectangle.height)
                {
                    _loc_11 = _loc_8.clone();
                    _loc_11.width = rectangle.height * (_loc_8.width / _loc_8.height);
                    _loc_11.height = rectangle.height;
                }
                _loc_12 = _loc_11.width / _loc_8.width;
                _loc_13 = new BitmapData(_loc_11.width, _loc_11.height, false, 0);
                _loc_10 = new Matrix();
                _loc_10.scale(_loc_12, _loc_12);
                _loc_13.draw(_loc_9, _loc_10, null, null, null, true);
                return _loc_13;
            }
            return _loc_9;
        }// end function

        public static function getMemory() : uint
        {
            return System.totalMemory;
        }// end function

        public static function pause() : Boolean
        {
            try
            {
                System.pause();
                return true;
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

        public static function resume() : Boolean
        {
            try
            {
                System.resume();
                return true;
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

        public static function stackTrace() : XML
        {
            var childXML:XML;
            var stack:String;
            var lines:Array;
            var i:int;
            var s:String;
            var bracketIndex:int;
            var methodIndex:int;
            var classname:String;
            var method:String;
            var file:String;
            var line:String;
            var functionXML:XML;
            var rootXML:* = new XML("<root/>");
            childXML = new XML("<node/>");
            try
            {
                throw new Error();
            }
            catch (e:Error)
            {
                stack = e.getStackTrace();
                if (stack != null)
                {
                }
                if (stack == "")
                {
                    return new XML("<root><error>Stack unavailable</error></root>");
                }
                stack = stack.split("\t").join("");
                lines = stack.split("\n");
                if (lines.length <= 4)
                {
                    return new XML("<root><error>Stack to short</error></root>");
                }
                lines.shift();
                lines.shift();
                lines.shift();
                lines.shift();
                i;
                while (i < lines.length)
                {
                    
                    s = lines[i];
                    s = s.substring(3, s.length);
                    bracketIndex = s.indexOf("[");
                    methodIndex = s.indexOf("/");
                    if (bracketIndex == -1)
                    {
                        bracketIndex = s.length;
                    }
                    if (methodIndex == -1)
                    {
                        methodIndex = bracketIndex;
                    }
                    classname = MonsterDebuggerUtils.parseType(s.substring(0, methodIndex));
                    method;
                    file;
                    line;
                    if (methodIndex != s.length)
                    {
                    }
                    if (methodIndex != bracketIndex)
                    {
                        method = s.substring((methodIndex + 1), bracketIndex);
                    }
                    if (bracketIndex != s.length)
                    {
                        file = s.substring((bracketIndex + 1), s.lastIndexOf(":"));
                        line = s.substring((s.lastIndexOf(":") + 1), (s.length - 1));
                    }
                    functionXML = new XML("<node/>");
                    functionXML.@classname = classname;
                    functionXML.@method = method;
                    functionXML.@file = file;
                    functionXML.@line = line;
                    childXML.appendChild(functionXML);
                    i = (i + 1);
                }
            }
            rootXML.appendChild(childXML.children());
            return rootXML;
        }// end function

        public static function getReferenceID(target) : String
        {
            if (target in _references)
            {
                return _references[target];
            }
            var _loc_2:* = "#" + String(_reference);
            _references[target] = _loc_2;
            var _loc_4:* = _reference + 1;
            _reference = _loc_4;
            return _loc_2;
        }// end function

        public static function getReference(id:String)
        {
            var _loc_2:* = undefined;
            var _loc_3:String = null;
            if (id.charAt(0) != "#")
            {
                return null;
            }
            for (_loc_2 in _references)
            {
                
                _loc_3 = _references[_loc_2];
                if (_loc_3 == id)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public static function getObject(base, target:String = "", parent:int = 0)
        {
            var index:Number;
            var base:* = base;
            var target:* = target;
            var parent:* = parent;
            if (target != null)
            {
            }
            if (target == "")
            {
                return base;
            }
            if (target.charAt(0) == "#")
            {
                return getReference(target);
            }
            var object:* = base;
            var splitted:* = target.split(MonsterDebuggerConstants.DELIMITER);
            var i:int;
            while (i < splitted.length - parent)
            {
                
                if (splitted[i] != "")
                {
                    try
                    {
                        if (splitted[i] == "children()")
                        {
                            object = object.children();
                        }
                        else
                        {
                            if (object is DisplayObjectContainer)
                            {
                            }
                            if (splitted[i].indexOf("getChildAt(") == 0)
                            {
                                index = splitted[i].substring(11, splitted[i].indexOf(")", 11));
                                object = DisplayObjectContainer(object).getChildAt(index);
                            }
                            else
                            {
                                object = object[splitted[i]];
                            }
                        }
                    }
                    catch (e:Error)
                    {
                        break;
                    }
                }
                i = (i + 1);
            }
            return object;
        }// end function

        public static function parse(object, target:String = "", currentDepth:int = 1, maxDepth:int = 5, includeDisplayObjects:Boolean = true) : XML
        {
            var _loc_8:XML = null;
            var _loc_13:int = 0;
            var _loc_14:XML = null;
            var _loc_6:* = new XML("<root/>");
            var _loc_7:* = new XML("<node/>");
            var _loc_9:* = new XML();
            var _loc_10:String = "";
            var _loc_11:String = "";
            var _loc_12:Boolean = false;
            if (maxDepth != -1)
            {
            }
            if (currentDepth > maxDepth)
            {
                return _loc_6;
            }
            if (object == null)
            {
                _loc_8 = new XML("<node/>");
                _loc_8.@icon = MonsterDebuggerConstants.ICON_WARNING;
                _loc_8.@label = "Null object";
                _loc_8.@name = "Null object";
                _loc_8.@type = MonsterDebuggerConstants.TYPE_WARNING;
                _loc_7.appendChild(_loc_8);
                _loc_10 = "null";
            }
            else
            {
                _loc_9 = MonsterDebuggerDescribeType.get(object);
                _loc_10 = parseType(_loc_9.@name);
                _loc_11 = parseType(_loc_9.@base);
                _loc_12 = _loc_9.@isDynamic;
                if (object is Class)
                {
                    _loc_7.appendChild(parseClass(object, target, _loc_9, currentDepth, maxDepth, includeDisplayObjects).children());
                }
                else if (_loc_10 == MonsterDebuggerConstants.TYPE_XML)
                {
                    _loc_7.appendChild(parseXML(object, target + "." + "children()", currentDepth, maxDepth).children());
                }
                else if (_loc_10 == MonsterDebuggerConstants.TYPE_XMLLIST)
                {
                    _loc_8 = new XML("<node/>");
                    _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                    _loc_8.@type = MonsterDebuggerConstants.TYPE_UINT;
                    _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                    _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READONLY;
                    _loc_8.@target = target + "." + "length";
                    _loc_8.@label = "length" + " (" + MonsterDebuggerConstants.TYPE_UINT + ") = " + object.length();
                    _loc_8.@name = "length";
                    _loc_8.@value = object.length();
                    _loc_13 = 0;
                    while (_loc_13 < object.length())
                    {
                        
                        _loc_8.appendChild(parseXML(object[_loc_13], target + "." + String(_loc_13) + ".children()", currentDepth, maxDepth).children());
                        _loc_13 = _loc_13 + 1;
                    }
                    _loc_7.appendChild(_loc_8);
                }
                else
                {
                    if (_loc_10 != MonsterDebuggerConstants.TYPE_STRING)
                    {
                    }
                    if (_loc_10 != MonsterDebuggerConstants.TYPE_BOOLEAN)
                    {
                    }
                    if (_loc_10 != MonsterDebuggerConstants.TYPE_NUMBER)
                    {
                    }
                    if (_loc_10 != MonsterDebuggerConstants.TYPE_INT)
                    {
                    }
                    if (_loc_10 == MonsterDebuggerConstants.TYPE_UINT)
                    {
                        _loc_7.appendChild(parseBasics(object, target, _loc_10).children());
                    }
                    else
                    {
                        if (_loc_10 != MonsterDebuggerConstants.TYPE_ARRAY)
                        {
                        }
                        if (_loc_10.indexOf(MonsterDebuggerConstants.TYPE_VECTOR) == 0)
                        {
                            _loc_7.appendChild(parseArray(object, target, currentDepth, maxDepth).children());
                        }
                        else if (_loc_10 == MonsterDebuggerConstants.TYPE_OBJECT)
                        {
                            _loc_7.appendChild(parseObject(object, target, currentDepth, maxDepth, includeDisplayObjects).children());
                        }
                        else
                        {
                            _loc_7.appendChild(parseClass(object, target, _loc_9, currentDepth, maxDepth, includeDisplayObjects).children());
                        }
                    }
                }
            }
            if (currentDepth == 1)
            {
                _loc_14 = new XML("<node/>");
                _loc_14.@icon = MonsterDebuggerConstants.ICON_ROOT;
                _loc_14.@label = "(" + _loc_10 + ")";
                _loc_14.@type = _loc_10;
                _loc_14.@target = target;
                _loc_14.appendChild(_loc_7.children());
                _loc_6.appendChild(_loc_14);
            }
            else
            {
                _loc_6.appendChild(_loc_7.children());
            }
            return _loc_6;
        }// end function

        private static function parseBasics(object, target:String, type:String, currentDepth:int = 1, maxDepth:int = 5) : XML
        {
            var _loc_6:* = new XML("<root/>");
            var _loc_7:* = new XML("<node/>");
            var _loc_8:Boolean = false;
            var _loc_9:* = new XML();
            if (type == MonsterDebuggerConstants.TYPE_STRING)
            {
                try
                {
                    _loc_9 = new XML(object);
                    if (!_loc_9.hasSimpleContent())
                    {
                    }
                    _loc_8 = _loc_9.children().length() > 0;
                }
                catch (error:TypeError)
                {
                }
            }
            if (!_loc_8)
            {
                _loc_7.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                _loc_7.@label = "(" + type + ") = " + printValue(object, type);
                _loc_7.@name = "";
                _loc_7.@type = type;
                _loc_7.@value = printValue(object, type);
                _loc_7.@target = target;
            }
            else
            {
                _loc_7.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                _loc_7.@label = "(" + MonsterDebuggerConstants.TYPE_XML + ")";
                _loc_7.@name = "";
                _loc_7.@type = MonsterDebuggerConstants.TYPE_XML;
                _loc_7.@value = "";
                _loc_7.@target = target;
                _loc_7.appendChild(parseXML(_loc_9, target + "." + "children()", currentDepth, maxDepth).children());
            }
            _loc_6.appendChild(_loc_7);
            return _loc_6;
        }// end function

        private static function parseArray(object, target:String, currentDepth:int = 1, maxDepth:int = 5, includeDisplayObjects:Boolean = true) : XML
        {
            var _loc_7:XML = null;
            var _loc_8:XML = null;
            var _loc_16:* = undefined;
            var _loc_6:* = new XML("<root/>");
            var _loc_9:String = "";
            var _loc_10:String = "";
            var _loc_11:Boolean = false;
            var _loc_12:* = new XML();
            var _loc_13:int = 0;
            _loc_7 = new XML("<node/>");
            _loc_7.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
            _loc_7.@label = "length" + " (" + MonsterDebuggerConstants.TYPE_UINT + ") = " + object["length"];
            _loc_7.@name = "length";
            _loc_7.@type = MonsterDebuggerConstants.TYPE_UINT;
            _loc_7.@value = object["length"];
            _loc_7.@target = target + "." + "length";
            _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READONLY;
            var _loc_14:Array = [];
            var _loc_15:Boolean = true;
            for (_loc_16 in object)
            {
                
                if (!(_loc_16 is int))
                {
                    _loc_15 = false;
                }
                _loc_14.push(_loc_16);
            }
            if (_loc_15)
            {
                _loc_14.sort(Array.NUMERIC);
            }
            else
            {
                _loc_14.sort(Array.CASEINSENSITIVE);
            }
            _loc_13 = 0;
            while (_loc_13 < _loc_14.length)
            {
                
                _loc_9 = parseType(MonsterDebuggerDescribeType.get(object[_loc_14[_loc_13]]).@name);
                _loc_10 = target + "." + String(_loc_14[_loc_13]);
                if (_loc_9 != MonsterDebuggerConstants.TYPE_STRING)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_BOOLEAN)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_NUMBER)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_INT)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_UINT)
                {
                }
                if (_loc_9 == MonsterDebuggerConstants.TYPE_FUNCTION)
                {
                    _loc_11 = false;
                    _loc_12 = new XML();
                    if (_loc_9 == MonsterDebuggerConstants.TYPE_STRING)
                    {
                        try
                        {
                            _loc_12 = new XML(object[_loc_14[_loc_13]]);
                            if (!_loc_12.hasSimpleContent())
                            {
                            }
                            if (_loc_12.children().length() > 0)
                            {
                                _loc_11 = true;
                            }
                        }
                        catch (error:TypeError)
                        {
                        }
                    }
                    if (!_loc_11)
                    {
                        _loc_8 = new XML("<node/>");
                        _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                        _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_8.@label = "[" + _loc_14[_loc_13] + "] (" + _loc_9 + ") = " + printValue(object[_loc_14[_loc_13]], _loc_9);
                        _loc_8.@name = "[" + _loc_14[_loc_13] + "]";
                        _loc_8.@type = _loc_9;
                        _loc_8.@value = printValue(object[_loc_14[_loc_13]], _loc_9);
                        _loc_8.@target = _loc_10;
                        _loc_7.appendChild(_loc_8);
                    }
                    else
                    {
                        _loc_8 = new XML("<node/>");
                        _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                        _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_8.@label = "[" + _loc_14[_loc_13] + "] (" + _loc_9 + ")";
                        _loc_8.@name = "[" + _loc_14[_loc_13] + "]";
                        _loc_8.@type = _loc_9;
                        _loc_8.@value = "";
                        _loc_8.@target = _loc_10;
                        _loc_8.appendChild(parseXML(object[_loc_14[_loc_13]], _loc_10, (currentDepth + 1), maxDepth).children());
                        _loc_7.appendChild(_loc_8);
                    }
                }
                else
                {
                    _loc_8 = new XML("<node/>");
                    _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                    _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                    _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                    _loc_8.@label = "[" + _loc_14[_loc_13] + "] (" + _loc_9 + ")";
                    _loc_8.@name = "[" + _loc_14[_loc_13] + "]";
                    _loc_8.@type = _loc_9;
                    _loc_8.@value = "";
                    _loc_8.@target = _loc_10;
                    _loc_8.appendChild(parse(object[_loc_14[_loc_13]], _loc_10, (currentDepth + 1), maxDepth, includeDisplayObjects).children());
                    _loc_7.appendChild(_loc_8);
                }
                _loc_13 = _loc_13 + 1;
            }
            _loc_6.appendChild(_loc_7);
            return _loc_6;
        }// end function

        public static function parseXML(xml, target:String = "", currentDepth:int = 1, maxDepth:int = -1) : XML
        {
            var _loc_6:XML = null;
            var _loc_7:XML = null;
            var _loc_9:String = null;
            var _loc_5:* = new XML("<root/>");
            var _loc_8:int = 0;
            if (maxDepth != -1)
            {
            }
            if (currentDepth > maxDepth)
            {
                return _loc_5;
            }
            if (target.indexOf("@") != -1)
            {
                _loc_6 = new XML("<node/>");
                _loc_6.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
                _loc_6.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
                _loc_6.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                _loc_6.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                _loc_6.@label = xml;
                _loc_6.@name = "";
                _loc_6.@value = xml;
                _loc_6.@target = target;
                _loc_5.appendChild(_loc_6);
            }
            else
            {
                if ("name" in xml)
                {
                }
                if (xml.name() == null)
                {
                    _loc_6 = new XML("<node/>");
                    _loc_6.@icon = MonsterDebuggerConstants.ICON_XMLVALUE;
                    _loc_6.@type = MonsterDebuggerConstants.TYPE_XMLVALUE;
                    _loc_6.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                    _loc_6.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                    _loc_6.@label = "(" + MonsterDebuggerConstants.TYPE_XMLVALUE + ") = " + printValue(xml, MonsterDebuggerConstants.TYPE_XMLVALUE);
                    _loc_6.@name = "";
                    _loc_6.@value = printValue(xml, MonsterDebuggerConstants.TYPE_XMLVALUE);
                    _loc_6.@target = target;
                    _loc_5.appendChild(_loc_6);
                }
                else
                {
                    if ("hasSimpleContent" in xml)
                    {
                    }
                    if (xml.hasSimpleContent())
                    {
                        _loc_6 = new XML("<node/>");
                        _loc_6.@icon = MonsterDebuggerConstants.ICON_XMLNODE;
                        _loc_6.@type = MonsterDebuggerConstants.TYPE_XMLNODE;
                        _loc_6.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_6.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_6.@label = xml.name() + " (" + MonsterDebuggerConstants.TYPE_XMLNODE + ")";
                        _loc_6.@name = xml.name();
                        _loc_6.@value = "";
                        _loc_6.@target = target;
                        if (xml != "")
                        {
                            _loc_7 = new XML("<node/>");
                            _loc_7.@icon = MonsterDebuggerConstants.ICON_XMLVALUE;
                            _loc_7.@type = MonsterDebuggerConstants.TYPE_XMLVALUE;
                            _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                            _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                            _loc_7.@label = "(" + MonsterDebuggerConstants.TYPE_XMLVALUE + ") = " + printValue(xml, MonsterDebuggerConstants.TYPE_XMLVALUE);
                            _loc_7.@name = "";
                            _loc_7.@value = printValue(xml, MonsterDebuggerConstants.TYPE_XMLVALUE);
                            _loc_7.@target = target;
                            _loc_6.appendChild(_loc_7);
                        }
                        _loc_8 = 0;
                        while (_loc_8 < xml.attributes().length())
                        {
                            
                            _loc_7 = new XML("<node/>");
                            _loc_7.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
                            _loc_7.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
                            _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                            _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                            _loc_7.@label = "@" + xml.attributes()[_loc_8].name() + " (" + MonsterDebuggerConstants.TYPE_XMLATTRIBUTE + ") = " + xml.attributes()[_loc_8];
                            _loc_7.@name = "";
                            _loc_7.@value = xml.attributes()[_loc_8];
                            _loc_7.@target = target + "." + "@" + xml.attributes()[_loc_8].name();
                            _loc_6.appendChild(_loc_7);
                            _loc_8 = _loc_8 + 1;
                        }
                        _loc_5.appendChild(_loc_6);
                    }
                    else
                    {
                        _loc_6 = new XML("<node/>");
                        _loc_6.@icon = MonsterDebuggerConstants.ICON_XMLNODE;
                        _loc_6.@type = MonsterDebuggerConstants.TYPE_XMLNODE;
                        _loc_6.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_6.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_6.@label = xml.name() + " (" + MonsterDebuggerConstants.TYPE_XMLNODE + ")";
                        _loc_6.@name = xml.name();
                        _loc_6.@value = "";
                        _loc_6.@target = target;
                        _loc_8 = 0;
                        while (_loc_8 < xml.attributes().length())
                        {
                            
                            _loc_7 = new XML("<node/>");
                            _loc_7.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
                            _loc_7.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
                            _loc_7.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                            _loc_7.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                            _loc_7.@label = "@" + xml.attributes()[_loc_8].name() + " (" + MonsterDebuggerConstants.TYPE_XMLATTRIBUTE + ") = " + xml.attributes()[_loc_8];
                            _loc_7.@name = "";
                            _loc_7.@value = xml.attributes()[_loc_8];
                            _loc_7.@target = target + "." + "@" + xml.attributes()[_loc_8].name();
                            _loc_6.appendChild(_loc_7);
                            _loc_8 = _loc_8 + 1;
                        }
                        _loc_8 = 0;
                        while (_loc_8 < xml.children().length())
                        {
                            
                            _loc_9 = target + "." + "children()" + "." + _loc_8;
                            _loc_6.appendChild(parseXML(xml.children()[_loc_8], _loc_9, (currentDepth + 1), maxDepth).children());
                            _loc_8 = _loc_8 + 1;
                        }
                        _loc_5.appendChild(_loc_6);
                    }
                }
            }
            return _loc_5;
        }// end function

        private static function parseObject(object, target:String, currentDepth:int = 1, maxDepth:int = 5, includeDisplayObjects:Boolean = true) : XML
        {
            var _loc_8:XML = null;
            var _loc_16:* = undefined;
            var _loc_6:* = new XML("<root/>");
            var _loc_7:* = new XML("<node/>");
            var _loc_9:String = "";
            var _loc_10:String = "";
            var _loc_11:Boolean = false;
            var _loc_12:* = new XML();
            var _loc_13:int = 0;
            var _loc_14:Array = [];
            var _loc_15:Boolean = true;
            for (_loc_16 in object)
            {
                
                if (!(_loc_16 is int))
                {
                    _loc_15 = false;
                }
                _loc_14.push(_loc_16);
            }
            if (_loc_15)
            {
                _loc_14.sort(Array.NUMERIC);
            }
            else
            {
                _loc_14.sort(Array.CASEINSENSITIVE);
            }
            _loc_13 = 0;
            while (_loc_13 < _loc_14.length)
            {
                
                _loc_9 = parseType(MonsterDebuggerDescribeType.get(object[_loc_14[_loc_13]]).@name);
                _loc_10 = target + "." + _loc_14[_loc_13];
                if (_loc_9 != MonsterDebuggerConstants.TYPE_STRING)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_BOOLEAN)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_NUMBER)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_INT)
                {
                }
                if (_loc_9 != MonsterDebuggerConstants.TYPE_UINT)
                {
                }
                if (_loc_9 == MonsterDebuggerConstants.TYPE_FUNCTION)
                {
                    _loc_11 = false;
                    _loc_12 = new XML();
                    if (_loc_9 == MonsterDebuggerConstants.TYPE_STRING)
                    {
                        try
                        {
                            _loc_12 = new XML(object[_loc_14[_loc_13]]);
                            if (!_loc_12.hasSimpleContent())
                            {
                            }
                            if (_loc_12.children().length() > 0)
                            {
                                _loc_11 = true;
                            }
                        }
                        catch (error:TypeError)
                        {
                        }
                    }
                    if (!_loc_11)
                    {
                        _loc_8 = new XML("<node/>");
                        _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                        _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_8.@label = _loc_14[_loc_13] + " (" + _loc_9 + ") = " + printValue(object[_loc_14[_loc_13]], _loc_9);
                        _loc_8.@name = _loc_14[_loc_13];
                        _loc_8.@type = _loc_9;
                        _loc_8.@value = printValue(object[_loc_14[_loc_13]], _loc_9);
                        _loc_8.@target = _loc_10;
                        _loc_7.appendChild(_loc_8);
                    }
                    else
                    {
                        _loc_8 = new XML("<node/>");
                        _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                        _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        _loc_8.@label = _loc_14[_loc_13] + " (" + _loc_9 + ")";
                        _loc_8.@name = _loc_14[_loc_13];
                        _loc_8.@type = _loc_9;
                        _loc_8.@value = "";
                        _loc_8.@target = _loc_10;
                        _loc_8.appendChild(parseXML(object[_loc_14[_loc_13]], _loc_10, (currentDepth + 1), maxDepth).children());
                        _loc_7.appendChild(_loc_8);
                    }
                }
                else
                {
                    _loc_8 = new XML("<node/>");
                    _loc_8.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                    _loc_8.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                    _loc_8.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                    _loc_8.@label = _loc_14[_loc_13] + " (" + _loc_9 + ")";
                    _loc_8.@name = _loc_14[_loc_13];
                    _loc_8.@type = _loc_9;
                    _loc_8.@value = "";
                    _loc_8.@target = _loc_10;
                    _loc_8.appendChild(parse(object[_loc_14[_loc_13]], _loc_10, (currentDepth + 1), maxDepth, includeDisplayObjects).children());
                    _loc_7.appendChild(_loc_8);
                }
                _loc_13 = _loc_13 + 1;
            }
            _loc_6.appendChild(_loc_7.children());
            return _loc_6;
        }// end function

        private static function parseClass(object, target:String, description:XML, currentDepth:int = 1, maxDepth:int = 5, includeDisplayObjects:Boolean = true) : XML
        {
            var key:String;
            var itemsArrayLength:int;
            var item:*;
            var itemXML:XML;
            var itemAccess:String;
            var itemPermission:String;
            var itemIcon:String;
            var itemType:String;
            var itemName:String;
            var itemTarget:String;
            var isXMLString:XML;
            var i:int;
            var prop:*;
            var displayObject:DisplayObjectContainer;
            var displayObjects:Array;
            var child:DisplayObject;
            var object:* = object;
            var target:* = target;
            var description:* = description;
            var currentDepth:* = currentDepth;
            var maxDepth:* = maxDepth;
            var includeDisplayObjects:* = includeDisplayObjects;
            var rootXML:* = new XML("<root/>");
            var nodeXML:* = new XML("<node/>");
            var variables:* = description..variable;
            var accessors:* = description..accessor;
            var constants:* = description..constant;
            var isDynamic:* = description.@isDynamic;
            var variablesLength:* = variables.length();
            var accessorsLength:* = accessors.length();
            var constantsLength:* = constants.length();
            var childLength:int;
            var keys:Object;
            var itemsArray:Array;
            var isXML:Boolean;
            if (isDynamic)
            {
                var _loc_8:int = 0;
                var _loc_9:* = object;
                while (_loc_9 in _loc_8)
                {
                    
                    prop = _loc_9[_loc_8];
                    key = String(prop);
                    if (!keys.hasOwnProperty(key))
                    {
                        keys[key] = key;
                        itemName = key;
                        itemType = parseType(getQualifiedClassName(object[key]));
                        itemTarget = target + "." + key;
                        itemAccess = MonsterDebuggerConstants.ACCESS_VARIABLE;
                        itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
                        itemsArray[itemsArray.length] = {name:itemName, type:itemType, target:itemTarget, access:itemAccess, permission:itemPermission, icon:itemIcon};
                    }
                }
            }
            i;
            while (i < variablesLength)
            {
                
                key = variables[i].@name;
                if (!keys.hasOwnProperty(key))
                {
                    keys[key] = key;
                    itemName = key;
                    itemType = parseType(variables[i].@type);
                    itemTarget = target + "." + key;
                    itemAccess = MonsterDebuggerConstants.ACCESS_VARIABLE;
                    itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                    itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
                    itemsArray[itemsArray.length] = {name:itemName, type:itemType, target:itemTarget, access:itemAccess, permission:itemPermission, icon:itemIcon};
                }
                i = (i + 1);
            }
            i;
            while (i < accessorsLength)
            {
                
                key = accessors[i].@name;
                if (!keys.hasOwnProperty(key))
                {
                    keys[key] = key;
                    itemName = key;
                    itemType = parseType(accessors[i].@type);
                    itemTarget = target + "." + key;
                    itemAccess = MonsterDebuggerConstants.ACCESS_ACCESSOR;
                    itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                    itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
                    if (accessors[i].@access == MonsterDebuggerConstants.PERMISSION_READONLY)
                    {
                        itemPermission = MonsterDebuggerConstants.PERMISSION_READONLY;
                        itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_READONLY;
                    }
                    if (accessors[i].@access == MonsterDebuggerConstants.PERMISSION_WRITEONLY)
                    {
                        itemPermission = MonsterDebuggerConstants.PERMISSION_WRITEONLY;
                        itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_WRITEONLY;
                    }
                    itemsArray[itemsArray.length] = {name:itemName, type:itemType, target:itemTarget, access:itemAccess, permission:itemPermission, icon:itemIcon};
                }
                i = (i + 1);
            }
            i;
            while (i < constantsLength)
            {
                
                key = constants[i].@name;
                if (!keys.hasOwnProperty(key))
                {
                    keys[key] = key;
                    itemName = key;
                    itemType = parseType(constants[i].@type);
                    itemTarget = target + "." + key;
                    itemAccess = MonsterDebuggerConstants.ACCESS_CONSTANT;
                    itemPermission = MonsterDebuggerConstants.PERMISSION_READONLY;
                    itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_READONLY;
                    itemsArray[itemsArray.length] = {name:itemName, type:itemType, target:itemTarget, access:itemAccess, permission:itemPermission, icon:itemIcon};
                }
                i = (i + 1);
            }
            itemsArray.sortOn("name", Array.CASEINSENSITIVE);
            if (includeDisplayObjects)
            {
            }
            if (object is DisplayObjectContainer)
            {
                displayObject = DisplayObjectContainer(object);
                displayObjects;
                childLength = displayObject.numChildren;
                i;
                while (i < childLength)
                {
                    
                    child;
                    try
                    {
                        child = displayObject.getChildAt(i);
                    }
                    catch (e1:Error)
                    {
                    }
                    if (child != null)
                    {
                        itemXML = MonsterDebuggerDescribeType.get(child);
                        itemType = parseType(itemXML.@name);
                        itemName;
                        if (child.name != null)
                        {
                            itemName = itemName + (" - " + child.name);
                        }
                        itemTarget = target + "." + "getChildAt(" + i + ")";
                        itemAccess = MonsterDebuggerConstants.ACCESS_DISPLAY_OBJECT;
                        itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                        itemIcon = child is DisplayObjectContainer ? (MonsterDebuggerConstants.ICON_ROOT) : (MonsterDebuggerConstants.ICON_DISPLAY_OBJECT);
                        displayObjects[displayObjects.length] = {name:itemName, type:itemType, target:itemTarget, access:itemAccess, permission:itemPermission, icon:itemIcon, index:i};
                    }
                    i = (i + 1);
                }
                displayObjects.sortOn("name", Array.CASEINSENSITIVE);
                itemsArray = displayObjects.concat(itemsArray);
            }
            itemsArrayLength = itemsArray.length;
            i;
            while (i < itemsArrayLength)
            {
                
                itemType = itemsArray[i].type;
                itemName = itemsArray[i].name;
                itemTarget = itemsArray[i].target;
                itemPermission = itemsArray[i].permission;
                itemAccess = itemsArray[i].access;
                itemIcon = itemsArray[i].icon;
                try
                {
                    if (itemAccess == MonsterDebuggerConstants.ACCESS_DISPLAY_OBJECT)
                    {
                        item = DisplayObjectContainer(object).getChildAt(itemsArray[i].index);
                    }
                    else
                    {
                        item = object[itemName];
                    }
                }
                catch (e2:Error)
                {
                    item;
                }
                if (item != null)
                {
                }
                if (itemPermission != MonsterDebuggerConstants.PERMISSION_WRITEONLY)
                {
                    if (itemType != MonsterDebuggerConstants.TYPE_STRING)
                    {
                    }
                    if (itemType != MonsterDebuggerConstants.TYPE_BOOLEAN)
                    {
                    }
                    if (itemType != MonsterDebuggerConstants.TYPE_NUMBER)
                    {
                    }
                    if (itemType != MonsterDebuggerConstants.TYPE_INT)
                    {
                    }
                    if (itemType != MonsterDebuggerConstants.TYPE_UINT)
                    {
                    }
                    if (itemType == MonsterDebuggerConstants.TYPE_FUNCTION)
                    {
                        isXML;
                        isXMLString = new XML();
                        if (itemType == MonsterDebuggerConstants.TYPE_STRING)
                        {
                            try
                            {
                                isXMLString = new XML(item);
                                if (!isXMLString.hasSimpleContent())
                                {
                                }
                                isXML = isXMLString.children().length() > 0;
                            }
                            catch (error:TypeError)
                            {
                            }
                        }
                        if (!isXML)
                        {
                            nodeXML = new XML("<node/>");
                            nodeXML.@icon = itemIcon;
                            nodeXML.@label = itemName + " (" + itemType + ") = " + printValue(item, itemType);
                            nodeXML.@name = itemName;
                            nodeXML.@type = itemType;
                            nodeXML.@value = printValue(item, itemType);
                            nodeXML.@target = itemTarget;
                            nodeXML.@access = itemAccess;
                            nodeXML.@permission = itemPermission;
                            rootXML.appendChild(nodeXML);
                        }
                        else
                        {
                            nodeXML = new XML("<node/>");
                            nodeXML.@icon = itemIcon;
                            nodeXML.@label = itemName + " (" + itemType + ")";
                            nodeXML.@name = itemName;
                            nodeXML.@type = itemType;
                            nodeXML.@value = "";
                            nodeXML.@target = itemTarget;
                            nodeXML.@access = itemAccess;
                            nodeXML.@permission = itemPermission;
                            nodeXML.appendChild(parseXML(isXMLString, itemTarget + "." + "children()", currentDepth, maxDepth).children());
                            rootXML.appendChild(nodeXML);
                        }
                    }
                    else
                    {
                        nodeXML = new XML("<node/>");
                        nodeXML.@icon = itemIcon;
                        nodeXML.@label = itemName + " (" + itemType + ")";
                        nodeXML.@name = itemName;
                        nodeXML.@type = itemType;
                        nodeXML.@target = itemTarget;
                        nodeXML.@access = itemAccess;
                        nodeXML.@permission = itemPermission;
                        if (item != null)
                        {
                        }
                        if (itemType != MonsterDebuggerConstants.TYPE_BYTEARRAY)
                        {
                            nodeXML.appendChild(parse(item, itemTarget, (currentDepth + 1), maxDepth, includeDisplayObjects).children());
                        }
                        rootXML.appendChild(nodeXML);
                    }
                }
                i = (i + 1);
            }
            return rootXML;
        }// end function

        public static function parseFunctions(object, target:String = "") : XML
        {
            var _loc_6:XML = null;
            var _loc_10:String = null;
            var _loc_15:String = null;
            var _loc_16:XMLList = null;
            var _loc_17:int = 0;
            var _loc_18:Array = null;
            var _loc_19:String = null;
            var _loc_23:XML = null;
            var _loc_24:XML = null;
            var _loc_3:* = new XML("<root/>");
            var _loc_4:* = MonsterDebuggerDescribeType.get(object);
            var _loc_5:* = parseType(_loc_4.@name);
            var _loc_7:String = "";
            var _loc_8:String = "";
            var _loc_9:String = "";
            var _loc_11:Object = {};
            var _loc_12:* = _loc_4..method;
            var _loc_13:Array = [];
            var _loc_14:* = _loc_12.length();
            var _loc_20:Boolean = false;
            var _loc_21:int = 0;
            var _loc_22:int = 0;
            _loc_6 = new XML("<node/>");
            _loc_6.@icon = MonsterDebuggerConstants.ICON_DEFAULT;
            _loc_6.@label = "(" + _loc_5 + ")";
            _loc_6.@target = target;
            _loc_21 = 0;
            while (_loc_21 < _loc_14)
            {
                
                _loc_10 = _loc_12[_loc_21].@name;
                try
                {
                    if (!_loc_11.hasOwnProperty(_loc_10))
                    {
                        _loc_11[_loc_10] = _loc_10;
                        _loc_13[_loc_13.length] = {name:_loc_10, xml:_loc_12[_loc_21], access:MonsterDebuggerConstants.ACCESS_METHOD};
                    }
                }
                catch (e:Error)
                {
                }
                _loc_21 = _loc_21 + 1;
            }
            _loc_13.sortOn("name", Array.CASEINSENSITIVE);
            _loc_14 = _loc_13.length;
            _loc_21 = 0;
            while (_loc_21 < _loc_14)
            {
                
                _loc_7 = MonsterDebuggerConstants.TYPE_FUNCTION;
                _loc_8 = _loc_13[_loc_21].xml.@name;
                _loc_9 = target + MonsterDebuggerConstants.DELIMITER + _loc_8;
                _loc_15 = parseType(_loc_13[_loc_21].xml.@returnType);
                _loc_16 = _loc_13[_loc_21].xml..parameter;
                _loc_17 = _loc_16.length();
                _loc_18 = [];
                _loc_19 = "";
                _loc_20 = false;
                _loc_22 = 0;
                while (_loc_22 < _loc_17)
                {
                    
                    if (_loc_16[_loc_22].@optional == "true")
                    {
                    }
                    if (!_loc_20)
                    {
                        _loc_20 = true;
                        _loc_18[_loc_18.length] = "[";
                    }
                    _loc_18[_loc_18.length] = parseType(_loc_16[_loc_22].@type);
                    _loc_22 = _loc_22 + 1;
                }
                if (_loc_20)
                {
                    _loc_18[_loc_18.length] = "]";
                }
                _loc_19 = _loc_18.join(", ");
                _loc_19 = _loc_19.replace("[, ", "[");
                _loc_19 = _loc_19.replace(", ]", "]");
                _loc_23 = new XML("<node/>");
                _loc_23.@icon = MonsterDebuggerConstants.ICON_FUNCTION;
                _loc_23.@type = MonsterDebuggerConstants.TYPE_FUNCTION;
                _loc_23.@access = MonsterDebuggerConstants.ACCESS_METHOD;
                _loc_23.@label = _loc_8 + "(" + _loc_19 + "):" + _loc_15;
                _loc_23.@name = _loc_8;
                _loc_23.@target = _loc_9;
                _loc_23.@args = _loc_19;
                _loc_23.@returnType = _loc_15;
                _loc_22 = 0;
                while (_loc_22 < _loc_17)
                {
                    
                    _loc_24 = new XML("<node/>");
                    _loc_24.@type = parseType(_loc_16[_loc_22].@type);
                    _loc_24.@index = _loc_16[_loc_22].@index;
                    _loc_24.@optional = _loc_16[_loc_22].@optional;
                    _loc_23.appendChild(_loc_24);
                    _loc_22 = _loc_22 + 1;
                }
                _loc_6.appendChild(_loc_23);
                _loc_21 = _loc_21 + 1;
            }
            _loc_3.appendChild(_loc_6);
            return _loc_3;
        }// end function

        public static function parseType(type:String) : String
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            if (type.indexOf("::") != -1)
            {
                type = type.substring(type.indexOf("::") + 2, type.length);
            }
            if (type.indexOf("::") != -1)
            {
                _loc_2 = type.substring(0, (type.indexOf("<") + 1));
                _loc_3 = type.substring(type.indexOf("::") + 2, type.length);
                type = _loc_2 + _loc_3;
            }
            type = type.replace("()", "");
            type = type.replace(MonsterDebuggerConstants.TYPE_METHOD, MonsterDebuggerConstants.TYPE_FUNCTION);
            return type;
        }// end function

        public static function isDisplayObject(object) : Boolean
        {
            if (!(object is DisplayObject))
            {
            }
            return object is DisplayObjectContainer;
        }// end function

        public static function printValue(value, type:String) : String
        {
            if (type == MonsterDebuggerConstants.TYPE_BYTEARRAY)
            {
                return value["length"] + " bytes";
            }
            if (value == null)
            {
                return "null";
            }
            return String(value);
        }// end function

        public static function getObjectUnderPoint(container:DisplayObjectContainer, point:Point) : DisplayObject
        {
            var _loc_3:Array = null;
            var _loc_4:DisplayObject = null;
            var _loc_6:DisplayObject = null;
            if (container.areInaccessibleObjectsUnderPoint(point))
            {
                return container;
            }
            _loc_3 = container.getObjectsUnderPoint(point);
            _loc_3.reverse();
            if (_loc_3 != null)
            {
            }
            if (_loc_3.length == 0)
            {
                return container;
            }
            _loc_4 = _loc_3[0];
            _loc_3.length = 0;
            while (true)
            {
                
                _loc_3[_loc_3.length] = _loc_4;
                if (_loc_4.parent == null)
                {
                    break;
                }
                _loc_4 = _loc_4.parent;
            }
            _loc_3.reverse();
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                _loc_6 = _loc_3[_loc_5];
                if (_loc_6 is DisplayObjectContainer)
                {
                    _loc_4 = _loc_6;
                    if (!DisplayObjectContainer(_loc_6).mouseChildren)
                    {
                        break;
                    }
                }
                else
                {
                    break;
                }
                _loc_5 = _loc_5 + 1;
            }
            return _loc_4;
        }// end function

    }
}
