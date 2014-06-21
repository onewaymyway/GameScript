package com.junkbyte.console
{
    import com.junkbyte.console.core.*;
    import com.junkbyte.console.view.*;
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Console extends Sprite
    {
        protected var _config:ConsoleConfig;
        protected var _panels:PanelsManager;
        protected var _cl:CommandLine;
        protected var _kb:KeyBinder;
        protected var _refs:LogReferences;
        protected var _mm:MemoryMonitor;
        protected var _graphing:Graphing;
        protected var _remoter:Remoting;
        protected var _tools:ConsoleTools;
        protected var _logs:Logs;
        private var _topTries:int = 50;
        private var _paused:Boolean;
        private var _rollerKey:KeyBind;
        private var _so:SharedObject;
        private var _soData:Object;
        private var _lastTime:uint;
        public static const VERSION:Number = 2.7;
        public static const VERSION_STAGE:String = "ALPHA";
        public static const BUILD:int = 613;
        public static const BUILD_DATE:String = "2012/05/24 23:15";

        public function Console(password:String = "", config:ConsoleConfig = null)
        {
            var password:* = password;
            var config:* = config;
            this._soData = {};
            name = "Console";
            if (config == null)
            {
                config = new ConsoleConfig();
            }
            this._config = config;
            if (password)
            {
                this._config.keystrokePassword = password;
            }
            this._config.style.updateStyleSheet();
            this.initModules();
            this.cl.addCLCmd("remotingSocket", function (str:String = "") : void
            {
                var _loc_2:* = str.split(/\s+|\:""\s+|\:/);
                remotingSocket(_loc_2[0], _loc_2[1]);
                return;
            }// end function
            , "Connect to socket remote. /remotingSocket ip port");
            if (this._config.sharedObjectName)
            {
                try
                {
                    this._so = SharedObject.getLocal(this._config.sharedObjectName, this._config.sharedObjectPath);
                    this._soData = this._so.data;
                }
                catch (e:Error)
                {
                }
            }
            if (password)
            {
                this.visible = false;
            }
            this.report("<b>Console v" + VERSION + VERSION_STAGE + "</b> build " + BUILD + ". " + Capabilities.playerType + " " + Capabilities.version + ".", -2);
            this._lastTime = getTimer();
            addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            return;
        }// end function

        protected function initModules() : void
        {
            this._remoter = new Remoting(this);
            this._logs = new Logs(this);
            this._refs = new LogReferences(this);
            this._cl = new CommandLine(this);
            this._tools = new ConsoleTools(this);
            this._graphing = new Graphing(this);
            this._mm = new MemoryMonitor(this);
            this._kb = new KeyBinder(this);
            this._panels = new PanelsManager(this);
            return;
        }// end function

        private function stageAddedHandle(event:Event = null) : void
        {
            if (this._cl.base == null)
            {
                this._cl.base = parent;
            }
            if (loaderInfo)
            {
                this.listenUncaughtErrors(loaderInfo);
            }
            removeEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            addEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            stage.addEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler, false, 0, true);
            return;
        }// end function

        private function stageRemovedHandle(event:Event = null) : void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle);
            stage.removeEventListener(Event.MOUSE_LEAVE, this.onStageMouseLeave);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._kb.keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this._kb.keyUpHandler);
            return;
        }// end function

        private function onStageMouseLeave(event:Event) : void
        {
            this._panels.tooltip(null);
            return;
        }// end function

        public function listenUncaughtErrors(loaderinfo:LoaderInfo) : void
        {
            var _loc_2:IEventDispatcher = null;
            try
            {
                _loc_2 = loaderinfo["uncaughtErrorEvents"];
                if (_loc_2)
                {
                    _loc_2.addEventListener("uncaughtError", this.uncaughtErrorHandle, false, 0, true);
                }
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function uncaughtErrorHandle(event:Event) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = event.hasOwnProperty("error") ? (event["error"]) : (event);
            if (_loc_2 is Error)
            {
                _loc_3 = this._refs.makeString(_loc_2);
            }
            else if (_loc_2 is ErrorEvent)
            {
                _loc_3 = ErrorEvent(_loc_2).text;
            }
            if (!_loc_3)
            {
                _loc_3 = String(_loc_2);
            }
            this.report(_loc_3, ConsoleLevel.FATAL, false);
            return;
        }// end function

        public function addGraph(name:String, obj:Object, property:String, color:Number = -1, key:String = null, rect:Rectangle = null, inverse:Boolean = false) : GraphGroup
        {
            return this._graphing.add(name, obj, property, color, key, rect, inverse);
        }// end function

        public function addGraphGroup(group:GraphGroup) : void
        {
            return this._graphing.addGroup(group);
        }// end function

        public function fixGraphRange(name:String, min:Number = NaN, max:Number = NaN) : void
        {
            this._graphing.fixRange(name, min, max);
            return;
        }// end function

        public function removeGraph(name:String, obj:Object = null, property:String = null) : void
        {
            this._graphing.remove(name, obj, property);
            return;
        }// end function

        public function bindKey(key:KeyBind, callback:Function, args:Array = null) : void
        {
            if (key)
            {
                this._kb.bindKey(key, callback, args);
            }
            return;
        }// end function

        public function addMenu(key:String, callback:Function, args:Array = null, rollover:String = null) : void
        {
            this.panels.mainPanel.addMenu(key, callback, args, rollover);
            return;
        }// end function

        public function get displayRoller() : Boolean
        {
            return this._panels.displayRoller;
        }// end function

        public function set displayRoller(b:Boolean) : void
        {
            this._panels.displayRoller = b;
            return;
        }// end function

        public function setRollerCaptureKey(char:String, shift:Boolean = false, ctrl:Boolean = false, alt:Boolean = false) : void
        {
            if (this._rollerKey)
            {
                this.bindKey(this._rollerKey, null);
                this._rollerKey = null;
            }
            if (char)
            {
            }
            if (char.length == 1)
            {
                this._rollerKey = new KeyBind(char, shift, ctrl, alt);
                this.bindKey(this._rollerKey, this.onRollerCaptureKey);
            }
            return;
        }// end function

        public function get rollerCaptureKey() : KeyBind
        {
            return this._rollerKey;
        }// end function

        private function onRollerCaptureKey() : void
        {
            if (this.displayRoller)
            {
                this.report("Display Roller Capture:<br/>" + RollerPanel(this._panels.getPanel(RollerPanel.NAME)).getMapString(true), -1);
            }
            return;
        }// end function

        public function get fpsMonitor() : Boolean
        {
            return this._graphing.fpsMonitor;
        }// end function

        public function set fpsMonitor(b:Boolean) : void
        {
            this._graphing.fpsMonitor = b;
            return;
        }// end function

        public function get memoryMonitor() : Boolean
        {
            return this._graphing.memoryMonitor;
        }// end function

        public function set memoryMonitor(b:Boolean) : void
        {
            this._graphing.memoryMonitor = b;
            return;
        }// end function

        public function watch(object:Object, name:String = null) : String
        {
            return this._mm.watch(object, name);
        }// end function

        public function unwatch(name:String) : void
        {
            this._mm.unwatch(name);
            return;
        }// end function

        public function gc() : void
        {
            this._mm.gc();
            return;
        }// end function

        public function store(name:String, obj:Object, strong:Boolean = false) : void
        {
            this._cl.store(name, obj, strong);
            return;
        }// end function

        public function map(container:DisplayObjectContainer, maxstep:uint = 0) : void
        {
            this._tools.map(container, maxstep, ConsoleChannel.DEFAULT_CHANNEL);
            return;
        }// end function

        public function mapch(channel, container:DisplayObjectContainer, maxstep:uint = 0) : void
        {
            this._tools.map(container, maxstep, MakeChannelName(channel));
            return;
        }// end function

        public function inspect(obj:Object, showInherit:Boolean = true) : void
        {
            this._refs.inspect(obj, showInherit, ConsoleChannel.DEFAULT_CHANNEL);
            return;
        }// end function

        public function inspectch(channel, obj:Object, showInherit:Boolean = true) : void
        {
            this._refs.inspect(obj, showInherit, MakeChannelName(channel));
            return;
        }// end function

        public function explode(obj:Object, depth:int = 3) : void
        {
            this.addLine(new Array(this._tools.explode(obj, depth)), 1, null, false, true);
            return;
        }// end function

        public function explodech(channel, obj:Object, depth:int = 3) : void
        {
            this.addLine(new Array(this._tools.explode(obj, depth)), 1, channel, false, true);
            return;
        }// end function

        public function get paused() : Boolean
        {
            return this._paused;
        }// end function

        public function set paused(newV:Boolean) : void
        {
            if (this._paused == newV)
            {
                return;
            }
            if (newV)
            {
                this.report("Paused", 10);
            }
            else
            {
                this.report("Resumed", -1);
            }
            this._paused = newV;
            this._panels.mainPanel.setPaused(newV);
            return;
        }// end function

        override public function get width() : Number
        {
            return this._panels.mainPanel.width;
        }// end function

        override public function set width(newW:Number) : void
        {
            this._panels.mainPanel.width = newW;
            return;
        }// end function

        override public function set height(newW:Number) : void
        {
            this._panels.mainPanel.height = newW;
            return;
        }// end function

        override public function get height() : Number
        {
            return this._panels.mainPanel.height;
        }// end function

        override public function get x() : Number
        {
            return this._panels.mainPanel.x;
        }// end function

        override public function set x(newW:Number) : void
        {
            this._panels.mainPanel.x = newW;
            return;
        }// end function

        override public function set y(newW:Number) : void
        {
            this._panels.mainPanel.y = newW;
            return;
        }// end function

        override public function get y() : Number
        {
            return this._panels.mainPanel.y;
        }// end function

        override public function set visible(v:Boolean) : void
        {
            super.visible = v;
            if (v)
            {
                this._panels.mainPanel.visible = true;
            }
            return;
        }// end function

        private function _onEnterFrame(event:Event) : void
        {
            var _loc_2:* = getTimer();
            this._logs.update(_loc_2);
            var _loc_3:* = _loc_2 - this._lastTime;
            this._lastTime = _loc_2;
            this._refs.update(_loc_2);
            this._mm.update();
            this._graphing.update(_loc_3);
            this._remoter.update();
            if (visible)
            {
            }
            if (parent)
            {
                if (this.config.alwaysOnTop)
                {
                }
                if (this._topTries > 0)
                {
                }
                if (parent.numChildren > (parent.getChildIndex(this) + 1))
                {
                    var _loc_4:String = this;
                    var _loc_5:* = this._topTries - 1;
                    _loc_4._topTries = _loc_5;
                    parent.addChild(this);
                    this.report("Moved console on top (alwaysOnTop enabled), " + this._topTries + " attempts left.", -1);
                }
                this._panels.update(this._paused, this._logs.hasNewLog);
                this._logs.hasNewLog = false;
            }
            return;
        }// end function

        public function get remoting() : Boolean
        {
            return this._remoter.remoting;
        }// end function

        public function set remoting(b:Boolean) : void
        {
            this._remoter.remoting = b;
            return;
        }// end function

        public function remotingSocket(host:String, port:int) : void
        {
            this._remoter.remotingSocket(host, port);
            return;
        }// end function

        public function setViewingChannels(... args) : void
        {
            this._panels.mainPanel.setViewingChannels.apply(this, args);
            return;
        }// end function

        public function setIgnoredChannels(... args) : void
        {
            this._panels.mainPanel.setIgnoredChannels.apply(this, args);
            return;
        }// end function

        public function set minimumPriority(level:uint) : void
        {
            this._panels.mainPanel.priority = level;
            return;
        }// end function

        public function report(obj, priority:int = 0, skipSafe:Boolean = true, channel:String = null) : void
        {
            if (!channel)
            {
                channel = this._panels.mainPanel.reportChannel;
            }
            this.addLine([obj], priority, channel, false, skipSafe, 0);
            return;
        }// end function

        public function addLine(strings:Array, priority:int = 0, channel = null, isRepeating:Boolean = false, html:Boolean = false, stacks:int = -1) : void
        {
            var _loc_7:String = "";
            var _loc_8:* = strings.length;
            var _loc_9:int = 0;
            while (_loc_9 < _loc_8)
            {
                
                _loc_7 = _loc_7 + ((_loc_9 ? (" ") : ("")) + this._refs.makeString(strings[_loc_9], null, html));
                _loc_9 = _loc_9 + 1;
            }
            if (priority >= this._config.autoStackPriority)
            {
            }
            if (stacks < 0)
            {
                stacks = this._config.defaultStackDepth;
            }
            if (!html)
            {
            }
            if (stacks > 0)
            {
                _loc_7 = _loc_7 + this._tools.getStack(stacks, priority);
            }
            this._logs.add(new Log(_loc_7, MakeChannelName(channel), priority, isRepeating, html));
            return;
        }// end function

        public function set commandLine(b:Boolean) : void
        {
            this._panels.mainPanel.commandLine = b;
            return;
        }// end function

        public function get commandLine() : Boolean
        {
            return this._panels.mainPanel.commandLine;
        }// end function

        public function addSlashCommand(name:String, callback:Function, desc:String = "", alwaysAvailable:Boolean = true, endOfArgsMarker:String = ";") : void
        {
            this._cl.addSlashCommand(name, callback, desc, alwaysAvailable, endOfArgsMarker);
            return;
        }// end function

        public function add(string, priority:int = 2, isRepeating:Boolean = false) : void
        {
            this.addLine([string], priority, ConsoleChannel.DEFAULT_CHANNEL, isRepeating);
            return;
        }// end function

        public function stack(string, depth:int = -1, priority:int = 5) : void
        {
            this.addLine([string], priority, ConsoleChannel.DEFAULT_CHANNEL, false, false, depth >= 0 ? (depth) : (this._config.defaultStackDepth));
            return;
        }// end function

        public function stackch(channel, string, depth:int = -1, priority:int = 5) : void
        {
            this.addLine([string], priority, channel, false, false, depth >= 0 ? (depth) : (this._config.defaultStackDepth));
            return;
        }// end function

        public function log(... args) : void
        {
            this.addLine(args, ConsoleLevel.LOG);
            return;
        }// end function

        public function info(... args) : void
        {
            this.addLine(args, ConsoleLevel.INFO);
            return;
        }// end function

        public function debug(... args) : void
        {
            this.addLine(args, ConsoleLevel.DEBUG);
            return;
        }// end function

        public function warn(... args) : void
        {
            this.addLine(args, ConsoleLevel.WARN);
            return;
        }// end function

        public function error(... args) : void
        {
            this.addLine(args, ConsoleLevel.ERROR);
            return;
        }// end function

        public function fatal(... args) : void
        {
            this.addLine(args, ConsoleLevel.FATAL);
            return;
        }// end function

        public function ch(channel, string, priority:int = 2, isRepeating:Boolean = false) : void
        {
            this.addLine([string], priority, channel, isRepeating);
            return;
        }// end function

        public function logch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.LOG, channel);
            return;
        }// end function

        public function infoch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.INFO, channel);
            return;
        }// end function

        public function debugch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.DEBUG, channel);
            return;
        }// end function

        public function warnch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.WARN, channel);
            return;
        }// end function

        public function errorch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.ERROR, channel);
            return;
        }// end function

        public function fatalch(channel, ... args) : void
        {
            this.addLine(args, ConsoleLevel.FATAL, channel);
            return;
        }// end function

        public function addCh(channel, strings:Array, priority:int = 2, isRepeating:Boolean = false) : void
        {
            this.addLine(strings, priority, channel, isRepeating);
            return;
        }// end function

        public function addHTML(... args) : void
        {
            this.addLine(args, 2, ConsoleChannel.DEFAULT_CHANNEL, false, this.testHTML(args));
            return;
        }// end function

        public function addHTMLch(channel, priority:int, ... args) : void
        {
            this.addLine(args, priority, channel, false, this.testHTML(args));
            return;
        }// end function

        private function testHTML(args:Array) : Boolean
        {
            var args:* = args;
            try
            {
                new XML("<p>" + args.join("") + "</p>");
            }
            catch (err:Error)
            {
                return false;
            }
            return true;
        }// end function

        public function clear(channel:String = null) : void
        {
            this._logs.clear(channel);
            if (!this._paused)
            {
                this._panels.mainPanel.updateToBottom();
            }
            this._panels.updateMenu();
            return;
        }// end function

        public function getAllLog(splitter:String = "\r\n") : String
        {
            return this._logs.getLogsAsString(splitter);
        }// end function

        public function get config() : ConsoleConfig
        {
            return this._config;
        }// end function

        public function get panels() : PanelsManager
        {
            return this._panels;
        }// end function

        public function get cl() : CommandLine
        {
            return this._cl;
        }// end function

        public function get remoter() : Remoting
        {
            return this._remoter;
        }// end function

        public function get graphing() : Graphing
        {
            return this._graphing;
        }// end function

        public function get refs() : LogReferences
        {
            return this._refs;
        }// end function

        public function get logs() : Logs
        {
            return this._logs;
        }// end function

        public function get so() : Object
        {
            return this._soData;
        }// end function

        public function updateSO(key:String = null) : void
        {
            if (this._so)
            {
                if (key)
                {
                    this._so.setDirty(key);
                }
                else
                {
                    this._so.clear();
                }
            }
            return;
        }// end function

        public static function MakeChannelName(obj) : String
        {
            if (obj is String)
            {
                return obj as String;
            }
            if (obj)
            {
                return LogReferences.ShortClassName(obj);
            }
            return ConsoleChannel.DEFAULT_CHANNEL;
        }// end function

    }
}
