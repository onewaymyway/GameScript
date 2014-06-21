package com.demonsters.debugger
{
    import flash.display.*;

    public class MonsterDebugger extends Object
    {
        private static var _enabled:Boolean = true;
        private static var _initialized:Boolean = false;
        static const VERSION:Number = 3.01;
        public static var logger:Function;

        public function MonsterDebugger()
        {
            return;
        }// end function

        public static function initialize(base:Object, address:String = "127.0.0.1", onConnect:Function = null) : void
        {
            if (!_initialized)
            {
                _initialized = true;
                MonsterDebuggerCore.base = base;
                MonsterDebuggerCore.initialize();
                MonsterDebuggerConnection.initialize();
                MonsterDebuggerConnection.address = address;
                MonsterDebuggerConnection.onConnect = onConnect;
                MonsterDebuggerConnection.connect();
            }
            return;
        }// end function

        public static function get enabled() : Boolean
        {
            return _enabled;
        }// end function

        public static function set enabled(value:Boolean) : void
        {
            _enabled = value;
            return;
        }// end function

        public static function trace(caller, object, person:String = "", label:String = "", color:uint = 0, depth:int = 5) : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerCore.trace(caller, object, person, label, color, depth);
            }
            return;
        }// end function

        public static function log(... args) : void
        {
            args = new activation;
            var target:String;
            var stack:String;
            var lines:Array;
            var s:String;
            var bracketIndex:int;
            var methodIndex:int;
            var args:* = args;
            if (_initialized)
            {
            }
            if (_enabled)
            {
                if (length == 0)
                {
                    return;
                }
                target;
                try
                {
                    throw new Error();
                }
                catch (e:Error)
                {
                    stack = e.getStackTrace();
                    if (e != null)
                    {
                    }
                    if (e != "")
                    {
                        stack = e.split("\t").join("");
                        lines = e.split("\n");
                        if (e.length > 2)
                        {
                            e.shift();
                            e.shift();
                            s = e[0];
                            s = e.substring(3, e.length);
                            bracketIndex = e.indexOf("[");
                            methodIndex = e.indexOf("/");
                            if (e == -1)
                            {
                                bracketIndex = e.length;
                            }
                            if (e == -1)
                            {
                                methodIndex = e;
                            }
                            target = MonsterDebuggerUtils.parseType(e.substring(0, e));
                            if (e == "<anonymous>")
                            {
                                target;
                            }
                            if (e == "")
                            {
                                target;
                            }
                        }
                    }
                }
                if (length == 1)
                {
                    MonsterDebuggerCore.trace(, [0], "", "", 0, 5);
                }
                else
                {
                    MonsterDebuggerCore.trace(, , "", "", 0, 5);
                }
            }
            return;
        }// end function

        public static function snapshot(caller, object:DisplayObject, person:String = "", label:String = "") : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerCore.snapshot(caller, object, person, label);
            }
            return;
        }// end function

        public static function breakpoint(caller, id:String = "breakpoint") : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerCore.breakpoint(caller, id);
            }
            return;
        }// end function

        public static function inspect(object) : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerCore.inspect(object);
            }
            return;
        }// end function

        public static function clear() : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerCore.clear();
            }
            return;
        }// end function

        public static function hasPlugin(id:String) : Boolean
        {
            if (_initialized)
            {
                return MonsterDebuggerCore.hasPlugin(id);
            }
            return false;
        }// end function

        public static function registerPlugin(pluginClass:Class) : void
        {
            var _loc_2:MonsterDebuggerPlugin = null;
            if (_initialized)
            {
                _loc_2 = new pluginClass;
                MonsterDebuggerCore.registerPlugin(_loc_2.id, _loc_2);
            }
            return;
        }// end function

        public static function unregisterPlugin(id:String) : void
        {
            if (_initialized)
            {
                MonsterDebuggerCore.unregisterPlugin(id);
            }
            return;
        }// end function

        static function send(id:String, data:Object) : void
        {
            if (_initialized)
            {
            }
            if (_enabled)
            {
                MonsterDebuggerConnection.send(id, data, false);
            }
            return;
        }// end function

    }
}
