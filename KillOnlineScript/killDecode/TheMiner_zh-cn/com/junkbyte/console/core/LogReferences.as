package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class LogReferences extends ConsoleCore
    {
        private var _refMap:WeakObject;
        private var _refRev:Dictionary;
        private var _refIndex:uint = 1;
        private var _dofull:Boolean;
        private var _current:Object;
        private var _history:Array;
        private var _hisIndex:uint;
        private var _prevBank:Array;
        private var _currentBank:Array;
        private var _lastWithdraw:uint;
        public static const INSPECTING_CHANNEL:String = "⌂";

        public function LogReferences(console:Console)
        {
            var console:* = console;
            this._refMap = new WeakObject();
            this._refRev = new Dictionary(true);
            this._prevBank = new Array();
            this._currentBank = new Array();
            super(console);
            remoter.registerCallback("ref", function (bytes:ByteArray) : void
            {
                handleString(bytes.readUTF());
                return;
            }// end function
            );
            remoter.registerCallback("focus", this.handleFocused);
            return;
        }// end function

        public function update(time:uint) : void
        {
            if (!this._currentBank.length)
            {
            }
            if (this._prevBank.length)
            {
                if (time > this._lastWithdraw + config.objectHardReferenceTimer * 1000)
                {
                    this._prevBank = this._currentBank;
                    this._currentBank = new Array();
                    this._lastWithdraw = time;
                }
            }
            return;
        }// end function

        public function setLogRef(o) : uint
        {
            var _loc_3:int = 0;
            if (!config.useObjectLinking)
            {
                return 0;
            }
            var _loc_2:* = this._refRev[o];
            if (!_loc_2)
            {
                _loc_2 = this._refIndex;
                this._refMap[_loc_2] = o;
                this._refRev[o] = _loc_2;
                if (config.objectHardReferenceTimer)
                {
                    this._currentBank.push(o);
                }
                var _loc_4:String = this;
                var _loc_5:* = this._refIndex + 1;
                _loc_4._refIndex = _loc_5;
                _loc_3 = _loc_2 - 50;
                while (_loc_3 >= 0)
                {
                    
                    if (this._refMap[_loc_3] === null)
                    {
                        delete this._refMap[_loc_3];
                    }
                    _loc_3 = _loc_3 - 50;
                }
            }
            return _loc_2;
        }// end function

        public function getRefId(o) : uint
        {
            return this._refRev[o];
        }// end function

        public function getRefById(ind:uint)
        {
            return this._refMap[ind];
        }// end function

        public function makeString(o, prop = null, html:Boolean = false, maxlen:int = -1) : String
        {
            var txt:String;
            var v:*;
            var err:Error;
            var stackstr:String;
            var str:String;
            var len:int;
            var hasmaxlen:Boolean;
            var i:int;
            var strpart:String;
            var add:String;
            var o:* = o;
            var prop:* = prop;
            var html:* = html;
            var maxlen:* = maxlen;
            try
            {
                v = prop ? (o[prop]) : (o);
            }
            catch (err:Error)
            {
                return "<p0><i>" + err.toString() + "</i></p0>";
            }
            if (v is Error)
            {
                err = v as Error;
                stackstr = err.hasOwnProperty("getStackTrace") ? (err.getStackTrace()) : (err.toString());
                if (stackstr)
                {
                    txt = stackstr;
                }
                txt = err.toString();
            }
            else
            {
                if (!(v is XML))
                {
                }
                if (v is XMLList)
                {
                    txt = this.shortenString(EscHTML(v.toXMLString()), maxlen, o, prop);
                }
                else if (v is QName)
                {
                    txt = String(v);
                }
                else
                {
                    if (!(v is Array))
                    {
                    }
                    if (getQualifiedClassName(v).indexOf("__AS3__.vec::Vector.") == 0)
                    {
                        str;
                        len = v.length;
                        hasmaxlen = maxlen >= 0;
                        i;
                        while (i < len)
                        {
                            
                            strpart = this.makeString(v[i], null, false, maxlen);
                            str = str + ((i ? (", ") : ("")) + strpart);
                            maxlen = maxlen - strpart.length;
                            if (hasmaxlen)
                            {
                            }
                            if (maxlen <= 0)
                            {
                            }
                            if (i < (len - 1))
                            {
                                str = str + (", " + this.genLinkString(o, prop, "..."));
                                break;
                            }
                            i = (i + 1);
                        }
                        return str + "]";
                    }
                    else
                    {
                        if (config.useObjectLinking)
                        {
                        }
                        if (v)
                        {
                        }
                        if (typeof(v) == "object")
                        {
                            add;
                            if (v is ByteArray)
                            {
                                add = " position:" + v.position + " length:" + v.length;
                            }
                            else
                            {
                                if (!(v is Date))
                                {
                                }
                                if (!(v is Rectangle))
                                {
                                }
                                if (!(v is Point))
                                {
                                }
                                if (!(v is Matrix))
                                {
                                }
                                if (v is Event)
                                {
                                    add = " " + String(v);
                                }
                                else
                                {
                                    if (v is DisplayObject)
                                    {
                                    }
                                    if (v.name)
                                    {
                                        add = " " + v.name;
                                    }
                                }
                            }
                            txt = "{" + this.genLinkString(o, prop, ShortClassName(v)) + EscHTML(add) + "}";
                        }
                        else
                        {
                            if (v is ByteArray)
                            {
                                txt = "[ByteArray position:" + ByteArray(v).position + " length:" + ByteArray(v).length + "]";
                            }
                            txt = String(v);
                            if (!html)
                            {
                                txt = this.shortenString(EscHTML(txt), maxlen, o, prop);
                            }
                        }
                    }
                }
            }
            if (!(v is String))
            {
                txt = "<type>" + txt + "</type>";
            }
            return txt;
        }// end function

        public function makeRefTyped(v) : String
        {
            if (v)
            {
            }
            if (typeof(v) == "object")
            {
            }
            if (!(v is QName))
            {
                return "{" + this.genLinkString(v, null, ShortClassName(v)) + "}";
            }
            return ShortClassName(v);
        }// end function

        private function genLinkString(o, prop, str:String) : String
        {
            if (prop)
            {
            }
            if (!(prop is String))
            {
                o = o[prop];
                prop = null;
            }
            var _loc_4:* = this.setLogRef(o);
            if (_loc_4)
            {
                return "<menu><a href=\'event:ref_" + _loc_4 + (prop ? ("_" + prop) : ("")) + "\'>" + str + "</a></menu>";
            }
            else
            {
                return str;
            }
        }// end function

        private function shortenString(str:String, maxlen:int, o, prop = null) : String
        {
            if (maxlen >= 0)
            {
            }
            if (str.length > maxlen)
            {
                str = str.substring(0, maxlen);
                return str + this.genLinkString(o, prop, " ...");
            }
            return str;
        }// end function

        private function historyInc(i:int) : void
        {
            this._hisIndex = this._hisIndex + i;
            var _loc_2:* = this._history[this._hisIndex];
            if (_loc_2)
            {
                this.focus(_loc_2, this._dofull);
            }
            return;
        }// end function

        public function handleRefEvent(str:String) : void
        {
            this.handleString(str);
            return;
        }// end function

        private function handleString(str:String) : void
        {
            var _loc_2:int = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:Object = null;
            if (str == "refexit")
            {
                this.exitFocus();
                console.setViewingChannels();
            }
            else if (str == "refprev")
            {
                this.historyInc(-2);
            }
            else if (str == "reffwd")
            {
                this.historyInc(0);
            }
            else if (str == "refi")
            {
                this.focus(this._current, !this._dofull);
            }
            else
            {
                _loc_2 = str.indexOf("_") + 1;
                if (_loc_2 > 0)
                {
                    _loc_4 = "";
                    _loc_5 = str.indexOf("_", _loc_2);
                    if (_loc_5 > 0)
                    {
                        _loc_3 = uint(str.substring(_loc_2, _loc_5));
                        _loc_4 = str.substring((_loc_5 + 1));
                    }
                    else
                    {
                        _loc_3 = uint(str.substring(_loc_2));
                    }
                    _loc_6 = this.getRefById(_loc_3);
                    if (_loc_4)
                    {
                        _loc_6 = _loc_6[_loc_4];
                    }
                    if (_loc_6)
                    {
                        if (str.indexOf("refe_") == 0)
                        {
                            console.explodech(console.panels.mainPanel.reportChannel, _loc_6);
                        }
                        else
                        {
                            this.focus(_loc_6, this._dofull);
                        }
                        return;
                    }
                }
                report("Reference no longer exist (garbage collected).", -2);
            }
            return;
        }// end function

        public function focus(o, full:Boolean = false) : void
        {
            if (remoter.connected)
            {
                remoter.send("focus");
            }
            console.clear(LogReferences.INSPECTING_CHANNEL);
            console.setViewingChannels(LogReferences.INSPECTING_CHANNEL);
            if (!this._history)
            {
                this._history = new Array();
            }
            if (this._current != o)
            {
                this._current = o;
                if (this._history.length <= this._hisIndex)
                {
                    this._history.push(o);
                }
                else
                {
                    this._history[this._hisIndex] = o;
                }
                var _loc_3:String = this;
                var _loc_4:* = this._hisIndex + 1;
                _loc_3._hisIndex = _loc_4;
            }
            this._dofull = full;
            this.inspect(o, this._dofull);
            return;
        }// end function

        private function handleFocused() : void
        {
            console.clear(LogReferences.INSPECTING_CHANNEL);
            console.setViewingChannels(LogReferences.INSPECTING_CHANNEL);
            return;
        }// end function

        public function exitFocus() : void
        {
            var _loc_1:ByteArray = null;
            this._current = null;
            this._dofull = false;
            this._history = null;
            this._hisIndex = 0;
            if (remoter.connected)
            {
                _loc_1 = new ByteArray();
                _loc_1.writeUTF("refexit");
                remoter.send("ref", _loc_1);
            }
            console.clear(LogReferences.INSPECTING_CHANNEL);
            return;
        }// end function

        public function inspect(obj, viewAll:Boolean = true, ch:String = null) : void
        {
            var menuStr:String;
            var nodes:XMLList;
            var constantX:XML;
            var hasstuff:Boolean;
            var isstatic:Boolean;
            var methodX:XML;
            var accessorX:XML;
            var variableX:XML;
            var extendX:XML;
            var implementX:XML;
            var metadataX:XML;
            var mn:XMLList;
            var en:String;
            var et:String;
            var disp:DisplayObject;
            var theParent:DisplayObjectContainer;
            var pr:DisplayObjectContainer;
            var indstr:String;
            var cont:DisplayObjectContainer;
            var clen:int;
            var ci:int;
            var child:DisplayObject;
            var params:Array;
            var mparamsList:XMLList;
            var paraX:XML;
            var access:String;
            var X:*;
            var obj:* = obj;
            var viewAll:* = viewAll;
            var ch:* = ch;
            if (!obj)
            {
                report(obj, -2, true, ch);
                return;
            }
            var refIndex:* = this.setLogRef(obj);
            var showInherit:String;
            if (!viewAll)
            {
                showInherit;
            }
            if (this._history)
            {
                menuStr;
                if (this._hisIndex > 1)
                {
                    menuStr = menuStr + " [<a href=\'event:refprev\'>previous</a>]";
                }
                if (this._history)
                {
                }
                if (this._hisIndex < this._history.length)
                {
                    menuStr = menuStr + " [<a href=\'event:reffwd\'>forward</a>]";
                }
                menuStr = menuStr + ("</b> || [<a href=\'event:ref_" + refIndex + "\'>refresh</a>]");
                menuStr = menuStr + ("</b> [<a href=\'event:refe_" + refIndex + "\'>explode</a>]");
                if (config.commandLineAllowed)
                {
                    menuStr = menuStr + (" [<a href=\'event:cl_" + refIndex + "\'>scope</a>]");
                }
                if (viewAll)
                {
                    menuStr = menuStr + " [<a href=\'event:refi\'>hide inherited</a>]";
                }
                else
                {
                    menuStr = menuStr + showInherit;
                }
                report(menuStr, -1, true, ch);
                report("", 1, true, ch);
            }
            var V:* = describeType(obj);
            var cls:* = obj is Class ? (obj) : (obj.constructor);
            var clsV:* = describeType(cls);
            var self:* = V.@name;
            var isClass:* = obj is Class;
            var st:* = isClass ? ("*") : ("");
            var str:* = "<b>{" + st + this.genLinkString(obj, null, EscHTML(self)) + st + "}</b>";
            var props:Array;
            if (V.@isStatic == "true")
            {
                props.push("<b>static</b>");
            }
            if (V.@isDynamic == "true")
            {
                props.push("dynamic");
            }
            if (V.@isFinal == "true")
            {
                props.push("final");
            }
            if (props.length > 0)
            {
                str = str + (" <p-1>" + props.join(" | ") + "</p-1>");
            }
            report(str, -2, true, ch);
            nodes = V.extendsClass;
            if (nodes.length())
            {
                props;
                var _loc_5:int = 0;
                var _loc_6:* = nodes;
                while (_loc_6 in _loc_5)
                {
                    
                    extendX = _loc_6[_loc_5];
                    st = extendX.@type.toString();
                    props.push(st.indexOf("*") < 0 ? (this.makeValue(getDefinitionByName(st))) : (EscHTML(st)));
                    if (!viewAll)
                    {
                        break;
                    }
                }
                report("<p10>Extends:</p10> " + props.join(" &gt; "), 1, true, ch);
            }
            nodes = V.implementsInterface;
            if (nodes.length())
            {
                props;
                var _loc_5:int = 0;
                var _loc_6:* = nodes;
                while (_loc_6 in _loc_5)
                {
                    
                    implementX = _loc_6[_loc_5];
                    props.push(this.makeValue(getDefinitionByName(implementX.@type.toString())));
                }
                report("<p10>Implements:</p10> " + props.join(", "), 1, true, ch);
            }
            report("", 1, true, ch);
            props;
            var _loc_6:int = 0;
            var _loc_7:* = V.metadata;
            var _loc_5:* = new XMLList("");
            for each (_loc_8 in _loc_7)
            {
                
                var _loc_9:* = _loc_8;
                with (_loc_8)
                {
                    if (@name == "Event")
                    {
                        _loc_5[_loc_6] = _loc_8;
                    }
                }
            }
            nodes = _loc_5;
            if (nodes.length())
            {
                var _loc_5:int = 0;
                var _loc_6:* = nodes;
                while (_loc_6 in _loc_5)
                {
                    
                    metadataX = _loc_6[_loc_5];
                    mn = metadataX.arg;
                    var _loc_8:int = 0;
                    var _loc_9:* = mn;
                    var _loc_7:* = new XMLList("");
                    for each (_loc_10 in _loc_9)
                    {
                        
                        var _loc_11:* = _loc_10;
                        with (_loc_10)
                        {
                            if (@key == "name")
                            {
                                _loc_7[_loc_8] = _loc_10;
                            }
                        }
                    }
                    en = _loc_7.@value;
                    var _loc_8:int = 0;
                    var _loc_9:* = mn;
                    var _loc_7:* = new XMLList("");
                    for each (_loc_10 in _loc_9)
                    {
                        
                        var _loc_11:* = _loc_10;
                        with (_loc_10)
                        {
                            if (@key == "type")
                            {
                                _loc_7[_loc_8] = _loc_10;
                            }
                        }
                    }
                    et = _loc_7.@value;
                    if (refIndex)
                    {
                        props.push("<a href=\'event:cl_" + refIndex + "_dispatchEvent(new " + et + "(\"" + en + "\"))\'>" + en + "</a><p0>(" + et + ")</p0>");
                        continue;
                    }
                    props.push(en + "<p0>(" + et + ")</p0>");
                }
                report("<p10>Events:</p10> " + props.join("<p-1>; </p-1>"), 1, true, ch);
                report("", 1, true, ch);
            }
            if (obj is DisplayObject)
            {
                disp = obj as DisplayObject;
                theParent = disp.parent;
                if (theParent)
                {
                    props = new Array("@" + theParent.getChildIndex(disp));
                    while (theParent)
                    {
                        
                        pr = theParent;
                        theParent = theParent.parent;
                        indstr = theParent ? ("@" + theParent.getChildIndex(pr)) : ("");
                        props.push("<b>" + pr.name + "</b>" + indstr + this.makeValue(pr));
                    }
                    report("<p10>Parents:</p10> " + props.join("<p-1> -> </p-1>") + "<br/>", 1, true, ch);
                }
            }
            if (obj is DisplayObjectContainer)
            {
                props;
                cont = obj as DisplayObjectContainer;
                clen = cont.numChildren;
                ci;
                while (ci < clen)
                {
                    
                    child = cont.getChildAt(ci);
                    props.push("<b>" + child.name + "</b>@" + ci + this.makeValue(child));
                    ci = (ci + 1);
                }
                if (clen)
                {
                    report("<p10>Children:</p10> " + props.join("<p-1>; </p-1>") + "<br/>", 1, true, ch);
                }
            }
            props;
            nodes = clsV..constant;
            var _loc_5:int = 0;
            var _loc_6:* = nodes;
            while (_loc_6 in _loc_5)
            {
                
                constantX = _loc_6[_loc_5];
                report(" const <p3>" + constantX.@name + "</p3>:" + constantX.@type + " = " + this.makeValue(cls, constantX.@name.toString()) + "</p0>", 1, true, ch);
            }
            if (nodes.length())
            {
                report("", 1, true, ch);
            }
            var inherit:uint;
            props;
            nodes = clsV..method;
            var _loc_5:int = 0;
            var _loc_6:* = nodes;
            while (_loc_6 in _loc_5)
            {
                
                methodX = _loc_6[_loc_5];
                if (!viewAll)
                {
                }
                if (self == methodX.@declaredBy)
                {
                    hasstuff;
                    isstatic = methodX.parent().name() != "factory";
                    str = " " + (isstatic ? ("static ") : ("")) + "function ";
                    params;
                    mparamsList = methodX.parameter;
                    var _loc_7:int = 0;
                    var _loc_8:* = mparamsList;
                    while (_loc_8 in _loc_7)
                    {
                        
                        paraX = _loc_8[_loc_7];
                        params.push(paraX.@optional == "true" ? ("<i>" + paraX.@type + "</i>") : (paraX.@type));
                    }
                    if (refIndex)
                    {
                        if (!isstatic)
                        {
                        }
                    }
                    if (!isClass)
                    {
                        str = str + ("<a href=\'event:cl_" + refIndex + "_" + methodX.@name + "()\'><p3>" + methodX.@name + "</p3></a>");
                    }
                    else
                    {
                        str = str + ("<p3>" + methodX.@name + "</p3>");
                    }
                    str = str + ("(" + params.join(", ") + "):" + methodX.@returnType);
                    report(str, 1, true, ch);
                    continue;
                }
                inherit = (inherit + 1);
            }
            if (inherit)
            {
                report("   \t + " + inherit + " inherited methods." + showInherit, 1, true, ch);
            }
            else if (hasstuff)
            {
                report("", 1, true, ch);
            }
            hasstuff;
            inherit;
            props;
            nodes = clsV..accessor;
            var _loc_5:int = 0;
            var _loc_6:* = nodes;
            while (_loc_6 in _loc_5)
            {
                
                accessorX = _loc_6[_loc_5];
                if (!viewAll)
                {
                }
                if (self == accessorX.@declaredBy)
                {
                    hasstuff;
                    isstatic = accessorX.parent().name() != "factory";
                    str;
                    if (isstatic)
                    {
                        str = str + "static ";
                    }
                    access = accessorX.@access;
                    if (access == "readonly")
                    {
                        str = str + "get";
                    }
                    else if (access == "writeonly")
                    {
                        str = str + "set";
                    }
                    else
                    {
                        str = str + "assign";
                    }
                    if (refIndex)
                    {
                        if (!isstatic)
                        {
                        }
                    }
                    if (!isClass)
                    {
                        str = str + (" <a href=\'event:cl_" + refIndex + "_" + accessorX.@name + "\'><p3>" + accessorX.@name + "</p3></a>:" + accessorX.@type);
                    }
                    else
                    {
                        str = str + (" <p3>" + accessorX.@name + "</p3>:" + accessorX.@type);
                    }
                    if (access != "writeonly")
                    {
                        if (!isstatic)
                        {
                        }
                    }
                    if (!isClass)
                    {
                        str = str + (" = " + this.makeValue(isstatic ? (cls) : (obj), accessorX.@name.toString()));
                    }
                    report(str, 1, true, ch);
                    continue;
                }
                inherit = (inherit + 1);
            }
            if (inherit)
            {
                report("   \t + " + inherit + " inherited accessors." + showInherit, 1, true, ch);
            }
            else if (hasstuff)
            {
                report("", 1, true, ch);
            }
            nodes = clsV..variable;
            var _loc_5:int = 0;
            var _loc_6:* = nodes;
            while (_loc_6 in _loc_5)
            {
                
                variableX = _loc_6[_loc_5];
                isstatic = variableX.parent().name() != "factory";
                str = isstatic ? (" static") : ("");
                if (refIndex)
                {
                    str = str + (" var <p3><a href=\'event:cl_" + refIndex + "_" + variableX.@name + " = \'>" + variableX.@name + "</a>");
                }
                else
                {
                    str = str + (" var <p3>" + variableX.@name);
                }
                str = str + ("</p3>:" + variableX.@type + " = " + this.makeValue(isstatic ? (cls) : (obj), variableX.@name.toString()));
                report(str, 1, true, ch);
            }
            try
            {
                props;
                var _loc_5:int = 0;
                var _loc_6:* = obj;
                while (_loc_6 in _loc_5)
                {
                    
                    X = _loc_6[_loc_5];
                    if (X is String)
                    {
                        if (refIndex)
                        {
                            str = "<a href=\'event:cl_" + refIndex + "_" + X + " = \'>" + X + "</a>";
                        }
                        else
                        {
                            str = X;
                        }
                        report(" dynamic var <p3>" + str + "</p3> = " + this.makeValue(obj, X), 1, true, ch);
                        continue;
                    }
                    report(" dictionary <p3>" + this.makeValue(X) + "</p3> = " + this.makeValue(obj, X), 1, true, ch);
                }
            }
            catch (e:Error)
            {
                report("Could not get dynamic values. " + e.message, 9, false, ch);
            }
            if (obj is String)
            {
                report("", 1, true, ch);
                report("String", 10, true, ch);
                report(EscHTML(obj), 1, true, ch);
            }
            else
            {
                if (!(obj is XML))
                {
                }
                if (obj is XMLList)
                {
                    report("", 1, true, ch);
                    report("XMLString", 10, true, ch);
                    report(EscHTML(obj.toXMLString()), 1, true, ch);
                }
            }
            if (menuStr)
            {
                report("", 1, true, ch);
                report(menuStr, -1, true, ch);
            }
            return;
        }// end function

        public function getPossibleCalls(obj) : Array
        {
            var _loc_5:XML = null;
            var _loc_6:XML = null;
            var _loc_7:XML = null;
            var _loc_8:Array = null;
            var _loc_9:XMLList = null;
            var _loc_10:XML = null;
            var _loc_2:* = new Array();
            var _loc_3:* = describeType(obj);
            var _loc_4:* = _loc_3.method;
            for each (_loc_5 in _loc_4)
            {
                
                _loc_8 = [];
                _loc_9 = _loc_5.parameter;
                for each (_loc_10 in _loc_9)
                {
                    
                    _loc_8.push(_loc_10.@optional == "true" ? ("<i>" + _loc_10.@type + "</i>") : (_loc_10.@type));
                }
                _loc_2.push([_loc_5.@name + "(", _loc_8.join(", ") + " ):" + _loc_5.@returnType]);
            }
            _loc_4 = _loc_3.accessor;
            for each (_loc_6 in _loc_4)
            {
                
                _loc_2.push([String(_loc_6.@name), String(_loc_6.@type)]);
            }
            _loc_4 = _loc_3.variable;
            for each (_loc_7 in _loc_4)
            {
                
                _loc_2.push([String(_loc_7.@name), String(_loc_7.@type)]);
            }
            return _loc_2;
        }// end function

        private function makeValue(obj, prop = null) : String
        {
            return this.makeString(obj, prop, false, config.useObjectLinking ? (100) : (-1));
        }// end function

        public static function EscHTML(str:String) : String
        {
            return str.replace(/<""</g, "&lt;").replace(/\>""\>/g, "&gt;").replace(/\;
        }// end function

        public static function ShortClassName(obj:Object, eschtml:Boolean = true) : String
        {
            var _loc_3:* = getQualifiedClassName(obj);
            var _loc_4:* = _loc_3.indexOf("::");
            var _loc_5:* = obj is Class ? ("*") : ("");
            _loc_3 = _loc_5 + _loc_3.substring(_loc_4 >= 0 ? (_loc_4 + 2) : (0)) + _loc_5;
            if (eschtml)
            {
                return EscHTML(_loc_3);
            }
            return _loc_3;
        }// end function

    }
}
