package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import flash.display.*;
    import flash.utils.*;

    public class ConsoleTools extends ConsoleCore
    {

        public function ConsoleTools(console:Console)
        {
            super(console);
            return;
        }// end function

        public function map(base:DisplayObjectContainer, maxstep:uint = 0, ch:String = null) : void
        {
            var _loc_5:Boolean = false;
            var _loc_9:DisplayObject = null;
            var _loc_10:String = null;
            var _loc_11:DisplayObjectContainer = null;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:DisplayObject = null;
            var _loc_15:uint = 0;
            var _loc_16:String = null;
            if (!base)
            {
                report("Not a DisplayObjectContainer.", 10, true, ch);
                return;
            }
            var _loc_4:int = 0;
            var _loc_6:int = 0;
            var _loc_7:DisplayObject = null;
            var _loc_8:* = new Array();
            _loc_8.push(base);
            while (_loc_6 < _loc_8.length)
            {
                
                _loc_9 = _loc_8[_loc_6];
                _loc_6 = _loc_6 + 1;
                if (_loc_9 is DisplayObjectContainer)
                {
                    _loc_11 = _loc_9 as DisplayObjectContainer;
                    _loc_12 = _loc_11.numChildren;
                    _loc_13 = 0;
                    while (_loc_13 < _loc_12)
                    {
                        
                        _loc_14 = _loc_11.getChildAt(_loc_13);
                        _loc_8.splice(_loc_6 + _loc_13, 0, _loc_14);
                        _loc_13 = _loc_13 + 1;
                    }
                }
                if (_loc_7)
                {
                    if (_loc_7 is DisplayObjectContainer)
                    {
                    }
                    if ((_loc_7 as DisplayObjectContainer).contains(_loc_9))
                    {
                        _loc_4 = _loc_4 + 1;
                    }
                    else
                    {
                        while (_loc_7)
                        {
                            
                            _loc_7 = _loc_7.parent;
                            if (_loc_7 is DisplayObjectContainer)
                            {
                                if (_loc_4 > 0)
                                {
                                    _loc_4 = _loc_4 - 1;
                                }
                                if ((_loc_7 as DisplayObjectContainer).contains(_loc_9))
                                {
                                    _loc_4 = _loc_4 + 1;
                                    break;
                                }
                            }
                        }
                    }
                }
                _loc_10 = "";
                _loc_13 = 0;
                while (_loc_13 < _loc_4)
                {
                    
                    _loc_10 = _loc_10 + (_loc_13 == (_loc_4 - 1) ? (" ∟ ") : (" - "));
                    _loc_13 = _loc_13 + 1;
                }
                if (maxstep > 0)
                {
                }
                if (_loc_4 <= maxstep)
                {
                    _loc_5 = false;
                    _loc_15 = console.refs.setLogRef(_loc_9);
                    _loc_16 = _loc_9.name;
                    if (_loc_15)
                    {
                        _loc_16 = "<a href=\'event:cl_" + _loc_15 + "\'>" + _loc_16 + "</a>";
                    }
                    if (_loc_9 is DisplayObjectContainer)
                    {
                        _loc_16 = "<b>" + _loc_16 + "</b>";
                    }
                    else
                    {
                        _loc_16 = "<i>" + _loc_16 + "</i>";
                    }
                    _loc_10 = _loc_10 + (_loc_16 + " " + console.refs.makeRefTyped(_loc_9));
                    report(_loc_10, _loc_9 is DisplayObjectContainer ? (5) : (2), true, ch);
                }
                else if (!_loc_5)
                {
                    _loc_5 = true;
                    report(_loc_10 + "...", 5, true, ch);
                }
                _loc_7 = _loc_9;
            }
            report(base.name + ":" + console.refs.makeRefTyped(base) + " has " + (_loc_8.length - 1) + " children/sub-children.", 9, true, ch);
            if (config.commandLineAllowed)
            {
                report("Click on the child display\'s name to set scope.", -2, true, ch);
            }
            return;
        }// end function

        public function explode(obj:Object, depth:int = 3, p:int = 9) : String
        {
            var _loc_6:XMLList = null;
            var _loc_7:String = null;
            var _loc_9:XML = null;
            var _loc_10:XML = null;
            var _loc_11:String = null;
            var _loc_4:* = typeof(obj);
            if (obj == null)
            {
                return "<p-2>" + obj + "</p-2>";
            }
            if (obj is String)
            {
                return "\"" + LogReferences.EscHTML(obj as String) + "\"";
            }
            if (_loc_4 == "object")
            {
            }
            if (depth != 0)
            {
            }
            if (obj is ByteArray)
            {
                return console.refs.makeString(obj);
            }
            if (p < 0)
            {
                p = 0;
            }
            var _loc_5:* = describeType(obj);
            var _loc_8:Array = [];
            _loc_6 = _loc_5["accessor"];
            for each (_loc_9 in _loc_6)
            {
                
                _loc_7 = _loc_9.@name;
                if (_loc_9.@access != "writeonly")
                {
                    try
                    {
                        _loc_8.push(this.stepExp(obj, _loc_7, depth, p));
                    }
                    catch (e:Error)
                    {
                    }
                    continue;
                }
                _loc_8.push(_loc_7);
            }
            _loc_6 = _loc_5["variable"];
            for each (_loc_10 in _loc_6)
            {
                
                _loc_7 = _loc_10.@name;
                _loc_8.push(this.stepExp(obj, _loc_7, depth, p));
            }
            try
            {
                for (_loc_11 in obj)
                {
                    
                    _loc_8.push(this.stepExp(obj, _loc_11, depth, p));
                }
            }
            catch (e:Error)
            {
            }
            return "<p" + p + ">{" + LogReferences.ShortClassName(obj) + "</p" + p + "> " + _loc_8.join(", ") + "<p" + p + ">}</p" + p + ">";
        }// end function

        private function stepExp(o, n:String, d:int, p:int) : String
        {
            return n + ":" + this.explode(o[n], (d - 1), (p - 1));
        }// end function

        public function getStack(depth:int, priority:int) : String
        {
            var _loc_3:* = new Error();
            var _loc_4:* = _loc_3.hasOwnProperty("getStackTrace") ? (_loc_3.getStackTrace()) : (null);
            if (!_loc_4)
            {
                return "";
            }
            var _loc_5:String = "";
            var _loc_6:* = _loc_4.split(/\
n\sat\s""\n\sat\s/);
            var _loc_7:* = _loc_6.length;
            var _loc_8:* = config.stackTraceIgnoreExpression;
            var _loc_9:Boolean = false;
            var _loc_10:int = 2;
            while (_loc_10 < _loc_7)
            {
                
                if (!_loc_9)
                {
                }
                if (_loc_6[_loc_10].search(_loc_8) != 0)
                {
                    _loc_9 = true;
                }
                if (_loc_9)
                {
                    _loc_5 = _loc_5 + ("\n<p" + priority + "> @ " + _loc_6[_loc_10] + "</p" + priority + ">");
                    if (priority > 0)
                    {
                        priority = priority - 1;
                    }
                    depth = depth - 1;
                    if (depth <= 0)
                    {
                        break;
                    }
                }
                _loc_10 = _loc_10 + 1;
            }
            return _loc_5;
        }// end function

    }
}
