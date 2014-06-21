package uas
{
    import flash.events.*;
    import flash.net.*;

    public class t extends Object
    {
        private static var __FlashTracer_DoNotBroadcast:Boolean = false;
        private static var __FlashTracer_DoNotTrace:Boolean = false;
        private static var _localConnection:LocalConnection = null;

        public function t()
        {
            return;
        }// end function

        public static function get DoNotBroadcast() : Boolean
        {
            return __FlashTracer_DoNotBroadcast;
        }// end function

        public static function set DoNotBroadcast(param1:Boolean) : void
        {
            __FlashTracer_DoNotBroadcast = param1;
            return;
        }// end function

        public static function get DoNotTrace() : Boolean
        {
            return __FlashTracer_DoNotTrace;
        }// end function

        public static function set DoNotTrace(param1:Boolean) : void
        {
            __FlashTracer_DoNotTrace = param1;
            return;
        }// end function

        public static function get stack() : String
        {
            var limiter:String;
            var stack:String;
            var frames:Array;
            var str:String;
            try
            {
                throw new Error();
            }
            catch (e:Error)
            {
                limiter;
                stack = e.getStackTrace();
                frames = stack.split("\n\tat");
                frames.shift();
                frames.shift();
                str = frames.join(limiter);
            }
            return str;
        }// end function

        public static function str(... args) : void
        {
            args = args.join(" | ");
            if (!__FlashTracer_DoNotTrace)
            {
                trace(args);
            }
            if (!__FlashTracer_DoNotBroadcast)
            {
                dispatch(args);
            }
            return;
        }// end function

        public static function lev(... args) : String
        {
            args = args.length > 0 ? (args[0]) : (null);
            var _loc_3:* = args.length > 1 ? (Number(args[1])) : (MAX_NUMBER_LEVELS);
            var _loc_4:String = "";
            if (isNaN(_loc_3))
            {
                _loc_4 = args[1];
                _loc_3 = MAX_NUMBER_LEVELS;
            }
            _loc_4 = _loc_4 + (args.length > 2 ? (args[2]) : (""));
            var _loc_5:Number = 3;
            while (_loc_5 < args.length)
            {
                
                _loc_4 = _loc_4 + (" | " + args[_loc_5]);
                _loc_5 = _loc_5 + 1;
            }
            var _loc_6:* = new Tracer(args, _loc_4, __FlashTracer_DoNotTrace, _loc_3);
            var _loc_7:* = new Tracer(args, _loc_4, __FlashTracer_DoNotTrace, _loc_3).getInfo();
            if (!__FlashTracer_DoNotBroadcast)
            {
                dispatch(_loc_7);
            }
            return _loc_7;
        }// end function

        public static function obj(... args) : String
        {
            args = args.length > 0 ? (args[0]) : (null);
            var _loc_3:* = args.length > 1 ? (args[1]) : ("");
            var _loc_4:Number = 2;
            while (_loc_4 < args.length)
            {
                
                _loc_3 = _loc_3 + (" | " + args[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            var _loc_5:* = new Tracer(args, _loc_3, __FlashTracer_DoNotTrace, MAX_NUMBER_LEVELS);
            var _loc_6:* = new Tracer(args, _loc_3, __FlashTracer_DoNotTrace, MAX_NUMBER_LEVELS).getInfo();
            if (!__FlashTracer_DoNotBroadcast)
            {
                dispatch(_loc_6);
            }
            return _loc_6;
        }// end function

        private static function dispatch(param1:String) : void
        {
            localConnection.send("__FlashTracer", "Add", param1);
            return;
        }// end function

        private static function get localConnection() : LocalConnection
        {
            if (_localConnection === null)
            {
                _localConnection = new LocalConnection();
                _localConnection.addEventListener(StatusEvent.STATUS, function (param1:Object) : void
            {
                return;
            }// end function
            );
            }
            return _localConnection;
        }// end function

        public static function objToString(param1:Object) : void
        {
            var _loc_2:String = null;
            trace("\n---------t-objToString");
            for (_loc_2 in param1)
            {
                
                trace(_loc_2 + "-" + param1[_loc_2]);
            }
            trace("------------t-objToString_end\n");
            return;
        }// end function

        public static function objToForVO(param1:Object) : void
        {
            var _loc_2:String = null;
            trace("\n---------t-objToForVO");
            for (_loc_2 in param1)
            {
                
                trace("public var " + _loc_2 + "=\'\'; //" + param1[_loc_2]);
            }
            trace("------------t-objToForVO-end\n");
            return;
        }// end function

    }
}

class Tracer extends Object
{
    private var _object:Object = null;
    private var _title:String;
    private var _supressTrace:Boolean;
    private var _allowedDepth:Number;
    private var _info:StringBuilder;
    private var _infoArray:Array;
    private var _indent:Number = 0;
    private var _prevIndent:Number = -1;
    private var _usedObjects:Array;
    public static const MAX_NUMBER_LEVELS:Number = 255;
    public static var indentCache:Object = new Object();
    private static const PRIMITIVES:Array = ["String", "Number", "Boolean", "Date", "int", "uint"];
    private static const INDENT_CHAR:String = "\t";

    function Tracer(param1:Object, param2:String = "", param3:Boolean = false, param4:Number = 255)
    {
        this._object = param1;
        this._title = param2;
        this._supressTrace = param3;
        this._allowedDepth = param4;
        this._info = new StringBuilder();
        this._usedObjects = new Array();
        this.parse(this._object);
        return;
    }// end function

    private function parse(param1:Object, param2:String = "", param3:Boolean = false) : void
    {
        if (isPrimitive(param1))
        {
            this.parseLiteral(param1, param2, param3);
        }
        else if (isCollectionObject(param1))
        {
            this.parseHierarchicalStructure(param1, param2, true, param3);
        }
        else if (hasProperties(param1))
        {
            this.parseHierarchicalStructure(param1, param2, false, param3);
        }
        else
        {
            this.parseLiteral(param1, param2, param3);
        }
        return;
    }// end function

    private function parseLiteral(param1:Object, param2:String, param3:Boolean = false) : void
    {
        if (param1 == null)
        {
            this.appendString(this.generatePropertyName(param2) + "null");
        }
        else
        {
            this.appendString(this.generatePropertyName(param2, param3) + objectToString(param1));
        }
        return;
    }// end function

    private function generatePropertyName(param1:String, param2:Boolean = false) : String
    {
        if (param1 == "")
        {
            return "";
        }
        if (param2)
        {
            return "/*" + param1 + "*/";
        }
        return param1 + ": ";
    }// end function

    private function getStartLimiter(param1:Boolean) : String
    {
        return param1 ? ("[") : ("{");
    }// end function

    private function getEndLimiter(param1:Boolean) : String
    {
        return param1 ? ("]") : ("}");
    }// end function

    private function addObjectToUsed(param1:Object) : void
    {
        this._usedObjects.push(param1);
        return;
    }// end function

    private function isUsed(param1:Object) : Boolean
    {
        var _loc_2:* = undefined;
        for each (_loc_2 in this._usedObjects)
        {
            
            if (param1 === _loc_2)
            {
                return true;
            }
        }
        return false;
    }// end function

    private function parseHierarchicalStructure(param1:Object, param2:String, param3:Boolean, param4:Boolean) : void
    {
        if (param1 == null)
        {
            this.parseLiteral(param1, param2);
            return;
        }
        this.appendString(this.generatePropertyName(param2, param4) + this.getStartLimiter(param3));
        var _loc_5:String = this;
        var _loc_6:* = this._indent + 1;
        _loc_5._indent = _loc_6;
        if (this._indent < this._allowedDepth)
        {
            if (!this.isUsed(param1))
            {
                this.addObjectToUsed(param1);
                if (param3)
                {
                    this.parseCollection(param1);
                }
                else
                {
                    this.parseProperties(param1);
                }
            }
            else
            {
                this.appendString("/*!!!-Recursion - call to already traced object \'" + param1 + "\' !!!*/");
            }
        }
        else
        {
            this.appendString("/*!!!-The maximum limit of " + this._indent + " levels to trace has been reached-!!!*/");
        }
        var _loc_5:String = this;
        var _loc_6:* = this._indent - 1;
        _loc_5._indent = _loc_6;
        this.appendString(this.getEndLimiter(param3));
        return;
    }// end function

    private function parseCollection(param1:Object) : void
    {
        var _loc_3:* = undefined;
        var _loc_2:Number = 0;
        for each (_loc_3 in param1)
        {
            
            this.parse(_loc_3, (_loc_2++).toString(), true);
        }
        if (_loc_2 === 0)
        {
            var _loc_4:String = this;
            var _loc_5:* = this._prevIndent + 1;
            _loc_4._prevIndent = _loc_5;
        }
        return;
    }// end function

    private function parseProperties(param1:Object) : void
    {
        var name:String;
        var xmlAccs:XML;
        var xmlVar:XML;
        var nameAttribute:String;
        var object:* = param1;
        var _loc_3:int = 0;
        var _loc_4:* = object;
        do
        {
            
            name = _loc_4[_loc_3];
            try
            {
                this.parse(object[name], name);
            }
            catch (e:Error)
            {
                this.appendString(nameAttribute + ": null /*!!!-" + e + "-!!!*/");
            }
        }while (_loc_4 in _loc_3)
        var _loc_3:int = 0;
        var _loc_4:* = describeType(object).accessor;
        do
        {
            
            xmlAccs = _loc_4[_loc_3];
            nameAttribute = xmlAccs.@name;
            try
            {
                if (object[nameAttribute] == null || object[nameAttribute] == undefined || !object[nameAttribute].propertyIsEnumerable())
                {
                    this.parse(object[nameAttribute], nameAttribute);
                }
            }
            catch (e:Error)
            {
                this.appendString(nameAttribute + ": null /*!!!-" + e + "-!!!*/");
            }
        }while (_loc_4 in _loc_3)
        var _loc_3:int = 0;
        var _loc_4:* = describeType(object).variable;
        do
        {
            
            xmlVar = _loc_4[_loc_3];
            try
            {
                if (object[xmlVar.@name] == null || object[xmlVar.@name] == undefined || !object[xmlVar.@name].propertyIsEnumerable())
                {
                    this.parse(object[xmlVar.@name], xmlVar.@name);
                }
            }
            catch (e:Error)
            {
                this.appendString(nameAttribute + ": null /*!!!-" + e + "-!!!*/");
            }
        }while (_loc_4 in _loc_3)
        return;
    }// end function

    private function traceInfo(param1:String) : void
    {
        trace(param1);
        return;
    }// end function

    private function appendString(param1:Object) : void
    {
        this._info.append(this.getIndent() + param1);
        return;
    }// end function

    private function getIndent() : String
    {
        var _loc_2:StringBuilder = null;
        var _loc_3:uint = 0;
        if (indentCache[this._indent] == undefined)
        {
            _loc_2 = new StringBuilder();
            _loc_3 = 0;
            while (_loc_3 < this._indent)
            {
                
                _loc_2.append(INDENT_CHAR);
                _loc_3 = _loc_3 + 1;
            }
            indentCache[this._indent] = "\n" + _loc_2.toString();
        }
        var _loc_1:* = this._prevIndent == this._indent;
        this._prevIndent = this._indent;
        return (_loc_1 ? (",") : ("")) + indentCache[this._indent];
    }// end function

    public function getInfo() : String
    {
        var _loc_1:* = this.infoToString();
        if (!this._supressTrace)
        {
            this.traceInfo(_loc_1);
        }
        return _loc_1;
    }// end function

    private function infoToString() : String
    {
        var _loc_1:* = new StringBuilder();
        _loc_1.append("-------------------------");
        if (this._title != null && this._title != "")
        {
            _loc_1.append("\n" + this._title);
        }
        _loc_1.append("\nObject type is: [" + getQualifiedClassName(this._object) + "]");
        _loc_1.append("\nObject content is: ");
        _loc_1.append(this._info.toString());
        _loc_1.append("\n-------------------------\n");
        return _loc_1.toString();
    }// end function

    private static function isPrimitive(param1:Object) : Boolean
    {
        var _loc_3:String = null;
        var _loc_2:* = getQualifiedClassName(param1);
        for each (_loc_3 in PRIMITIVES)
        {
            
            if (_loc_2 === _loc_3)
            {
                return true;
            }
        }
        return false;
    }// end function

    private static function isCollectionObject(param1:Object) : Boolean
    {
        return param1 is Array || param1 is IList;
    }// end function

    private static function hasProperties(param1:Object) : Boolean
    {
        var _loc_2:String = null;
        var _loc_3:XML = null;
        return true;
    }// end function

    private static function objectToString(param1:Object) : String
    {
        if (param1 is String)
        {
            return "\"" + param1.toString().split("\"").join("\\\"") + "\"";
        }
        if (param1 is Date)
        {
            return "Date.parse(\"" + param1 + "\")";
        }
        return param1.toString();
    }// end function

}

