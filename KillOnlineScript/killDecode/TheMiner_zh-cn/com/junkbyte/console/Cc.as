package com.junkbyte.console
{
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class Cc extends Object
    {
        private static var _console:Console;
        private static var _config:ConsoleConfig;

        public function Cc()
        {
            return;
        }// end function

        public static function get config() : ConsoleConfig
        {
            if (!_config)
            {
                _config = new ConsoleConfig();
            }
            return _config;
        }// end function

        public static function start(container:DisplayObjectContainer, password:String = "") : void
        {
            if (_console)
            {
                _console.visible = true;
                if (container)
                {
                }
                if (!_console.parent)
                {
                    container.addChild(_console);
                }
            }
            else
            {
                _console = new Console(password, config);
                if (container)
                {
                    container.addChild(_console);
                }
            }
            return;
        }// end function

        public static function startOnStage(display:DisplayObject, password:String = "") : void
        {
            if (_console)
            {
                if (display)
                {
                }
                if (display.stage)
                {
                }
                if (_console.parent != display.stage)
                {
                    display.stage.addChild(_console);
                }
            }
            else
            {
                if (display)
                {
                }
                if (display.stage)
                {
                    start(display.stage, password);
                }
                else
                {
                    _console = new Console(password, config);
                    if (display)
                    {
                        display.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
                    }
                }
            }
            return;
        }// end function

        public static function add(string, priority:int = 2, isRepeating:Boolean = false) : void
        {
            if (_console)
            {
                _console.add(string, priority, isRepeating);
            }
            return;
        }// end function

        public static function ch(channel, string, priority:int = 2, isRepeating:Boolean = false) : void
        {
            if (_console)
            {
                _console.ch(channel, string, priority, isRepeating);
            }
            return;
        }// end function

        public static function log(... args) : void
        {
            if (_console)
            {
                _console.log.apply(null, args);
            }
            return;
        }// end function

        public static function info(... args) : void
        {
            if (_console)
            {
                _console.info.apply(null, args);
            }
            return;
        }// end function

        public static function debug(... args) : void
        {
            if (_console)
            {
                _console.debug.apply(null, args);
            }
            return;
        }// end function

        public static function warn(... args) : void
        {
            if (_console)
            {
                _console.warn.apply(null, args);
            }
            return;
        }// end function

        public static function error(... args) : void
        {
            if (_console)
            {
                _console.error.apply(null, args);
            }
            return;
        }// end function

        public static function fatal(... args) : void
        {
            if (_console)
            {
                _console.fatal.apply(null, args);
            }
            return;
        }// end function

        public static function logch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.LOG);
            }
            return;
        }// end function

        public static function infoch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.INFO);
            }
            return;
        }// end function

        public static function debugch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.DEBUG);
            }
            return;
        }// end function

        public static function warnch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.WARN);
            }
            return;
        }// end function

        public static function errorch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.ERROR);
            }
            return;
        }// end function

        public static function fatalch(channel, ... args) : void
        {
            if (_console)
            {
                _console.addCh(channel, args, ConsoleLevel.FATAL);
            }
            return;
        }// end function

        public static function stack(string, depth:int = -1, priority:int = 5) : void
        {
            if (_console)
            {
                _console.stack(string, depth, priority);
            }
            return;
        }// end function

        public static function stackch(channel, string, depth:int = -1, priority:int = 5) : void
        {
            if (_console)
            {
                _console.stackch(channel, string, depth, priority);
            }
            return;
        }// end function

        public static function inspect(obj:Object, showInherit:Boolean = true) : void
        {
            if (_console)
            {
                _console.inspect(obj, showInherit);
            }
            return;
        }// end function

        public static function inspectch(channel, obj:Object, showInherit:Boolean = true) : void
        {
            if (_console)
            {
                _console.inspectch(channel, obj, showInherit);
            }
            return;
        }// end function

        public static function explode(obj:Object, depth:int = 3) : void
        {
            if (_console)
            {
                _console.explode(obj, depth);
            }
            return;
        }// end function

        public static function explodech(channel, obj:Object, depth:int = 3) : void
        {
            if (_console)
            {
                _console.explodech(channel, obj, depth);
            }
            return;
        }// end function

        public static function addHTML(... args) : void
        {
            if (_console)
            {
                _console.addHTML.apply(null, args);
            }
            return;
        }// end function

        public static function addHTMLch(channel, priority:int, ... args) : void
        {
            if (_console)
            {
                _console.addHTMLch.apply(null, new Array(channel, priority).concat(args));
            }
            return;
        }// end function

        public static function map(container:DisplayObjectContainer, maxDepth:uint = 0) : void
        {
            if (_console)
            {
                _console.map(container, maxDepth);
            }
            return;
        }// end function

        public static function mapch(channel, container:DisplayObjectContainer, maxDepth:uint = 0) : void
        {
            if (_console)
            {
                _console.mapch(channel, container, maxDepth);
            }
            return;
        }// end function

        public static function clear(channel:String = null) : void
        {
            if (_console)
            {
                _console.clear(channel);
            }
            return;
        }// end function

        public static function bindKey(key:KeyBind, callback:Function = null, args:Array = null) : void
        {
            if (_console)
            {
                _console.bindKey(key, callback, args);
            }
            return;
        }// end function

        public static function addMenu(key:String, callback:Function, args:Array = null, rollover:String = null) : void
        {
            if (_console)
            {
                _console.addMenu(key, callback, args, rollover);
            }
            return;
        }// end function

        public static function listenUncaughtErrors(loaderinfo:LoaderInfo) : void
        {
            if (_console)
            {
                _console.listenUncaughtErrors(loaderinfo);
            }
            return;
        }// end function

        public static function store(name:String, obj:Object, useStrong:Boolean = false) : void
        {
            if (_console)
            {
                _console.store(name, obj, useStrong);
            }
            return;
        }// end function

        public static function addSlashCommand(name:String, callback:Function, description:String = "", alwaysAvailable:Boolean = true, endOfArgsMarker:String = ";") : void
        {
            if (_console)
            {
                _console.addSlashCommand(name, callback, description, alwaysAvailable, endOfArgsMarker);
            }
            return;
        }// end function

        public static function watch(obj:Object, name:String = null) : String
        {
            if (_console)
            {
                return _console.watch(obj, name);
            }
            return null;
        }// end function

        public static function unwatch(name:String) : void
        {
            if (_console)
            {
                _console.unwatch(name);
            }
            return;
        }// end function

        public static function addGraph(panelName:String, obj:Object, property:String, color:Number = -1, idKey:String = null, rectArea:Rectangle = null, inverse:Boolean = false) : GraphGroup
        {
            if (_console)
            {
                return _console.addGraph(panelName, obj, property, color, idKey, rectArea, inverse);
            }
            return null;
        }// end function

        public static function addGraphGroup(group:GraphGroup) : void
        {
            if (_console)
            {
                _console.addGraphGroup(group);
            }
            return;
        }// end function

        public static function fixGraphRange(panelName:String, min:Number = NaN, max:Number = NaN) : void
        {
            if (_console)
            {
                _console.fixGraphRange(panelName, min, max);
            }
            return;
        }// end function

        public static function removeGraph(panelName:String, obj:Object = null, property:String = null) : void
        {
            if (_console)
            {
                _console.removeGraph(panelName, obj, property);
            }
            return;
        }// end function

        public static function setViewingChannels(... args) : void
        {
            if (_console)
            {
                _console.setViewingChannels.apply(null, args);
            }
            return;
        }// end function

        public static function setIgnoredChannels(... args) : void
        {
            if (_console)
            {
                _console.setIgnoredChannels.apply(null, args);
            }
            return;
        }// end function

        public static function set minimumPriority(level:uint) : void
        {
            if (_console)
            {
                _console.minimumPriority = level;
            }
            return;
        }// end function

        public static function get width() : Number
        {
            if (_console)
            {
                return _console.width;
            }
            return 0;
        }// end function

        public static function set width(v:Number) : void
        {
            if (_console)
            {
                _console.width = v;
            }
            return;
        }// end function

        public static function get height() : Number
        {
            if (_console)
            {
                return _console.height;
            }
            return 0;
        }// end function

        public static function set height(v:Number) : void
        {
            if (_console)
            {
                _console.height = v;
            }
            return;
        }// end function

        public static function get x() : Number
        {
            if (_console)
            {
                return _console.x;
            }
            return 0;
        }// end function

        public static function set x(v:Number) : void
        {
            if (_console)
            {
                _console.x = v;
            }
            return;
        }// end function

        public static function get y() : Number
        {
            if (_console)
            {
                return _console.y;
            }
            return 0;
        }// end function

        public static function set y(v:Number) : void
        {
            if (_console)
            {
                _console.y = v;
            }
            return;
        }// end function

        public static function get visible() : Boolean
        {
            if (_console)
            {
                return _console.visible;
            }
            return false;
        }// end function

        public static function set visible(v:Boolean) : void
        {
            if (_console)
            {
                _console.visible = v;
            }
            return;
        }// end function

        public static function get fpsMonitor() : Boolean
        {
            if (_console)
            {
                return _console.fpsMonitor;
            }
            return false;
        }// end function

        public static function set fpsMonitor(v:Boolean) : void
        {
            if (_console)
            {
                _console.fpsMonitor = v;
            }
            return;
        }// end function

        public static function get memoryMonitor() : Boolean
        {
            if (_console)
            {
                return _console.memoryMonitor;
            }
            return false;
        }// end function

        public static function set memoryMonitor(v:Boolean) : void
        {
            if (_console)
            {
                _console.memoryMonitor = v;
            }
            return;
        }// end function

        public static function get commandLine() : Boolean
        {
            if (_console)
            {
                return _console.commandLine;
            }
            return false;
        }// end function

        public static function set commandLine(v:Boolean) : void
        {
            if (_console)
            {
                _console.commandLine = v;
            }
            return;
        }// end function

        public static function get displayRoller() : Boolean
        {
            if (_console)
            {
                return _console.displayRoller;
            }
            return false;
        }// end function

        public static function set displayRoller(v:Boolean) : void
        {
            if (_console)
            {
                _console.displayRoller = v;
            }
            return;
        }// end function

        public static function setRollerCaptureKey(character:String, ctrl:Boolean = false, alt:Boolean = false, shift:Boolean = false) : void
        {
            if (_console)
            {
                _console.setRollerCaptureKey(character, shift, ctrl, alt);
            }
            return;
        }// end function

        public static function get remoting() : Boolean
        {
            if (_console)
            {
                return _console.remoting;
            }
            return false;
        }// end function

        public static function set remoting(v:Boolean) : void
        {
            if (_console)
            {
                _console.remoting = v;
            }
            return;
        }// end function

        public static function remotingSocket(host:String, port:int) : void
        {
            if (_console)
            {
                _console.remotingSocket(host, port);
            }
            return;
        }// end function

        public static function remove() : void
        {
            if (_console)
            {
                if (_console.parent)
                {
                    _console.parent.removeChild(_console);
                }
            }
            return;
        }// end function

        public static function getAllLog(splitter:String = "\r\n") : String
        {
            if (_console)
            {
                return _console.getAllLog(splitter);
            }
            return "";
        }// end function

        public static function get instance() : Console
        {
            return _console;
        }// end function

        private static function addedToStageHandle(event:Event) : void
        {
            var _loc_2:* = event.currentTarget as DisplayObjectContainer;
            _loc_2.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
            if (_console)
            {
            }
            if (_console.parent == null)
            {
                _loc_2.stage.addChild(_console);
            }
            return;
        }// end function

    }
}
