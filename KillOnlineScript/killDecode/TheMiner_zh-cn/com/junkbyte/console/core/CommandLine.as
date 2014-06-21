package com.junkbyte.console.core
{
    import CommandLine.as$245.*;
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class CommandLine extends ConsoleCore
    {
        private var _saved:WeakObject;
        private var _scope:Object;
        private var _prevScope:WeakRef;
        protected var _scopeStr:String = "";
        private var _slashCmds:Array;
        public var localCommands:Array;
        private static const DISABLED:String = "<b>Advanced CommandLine is disabled.</b>\nEnable by setting `Cc.config.commandLineAllowed = true;´\nType <b>/commands</b> for permitted commands.";
        private static const RESERVED:Array = [Executer.RETURNED, "base", "C"];

        public function CommandLine(m:Console)
        {
            var m:* = m;
            this.localCommands = new Array("filter", "filterexp");
            super(m);
            this._saved = new WeakObject();
            this._scope = m;
            this._slashCmds = new Array();
            this._prevScope = new WeakRef(m);
            this._saved.set("C", m);
            remoter.registerCallback("cmd", function (bytes:ByteArray) : void
            {
                run(bytes.readUTF());
                return;
            }// end function
            );
            remoter.registerCallback("scope", function (bytes:ByteArray) : void
            {
                handleScopeEvent(bytes.readUnsignedInt());
                return;
            }// end function
            );
            remoter.addEventListener(Event.CONNECT, this.sendCmdScope2Remote);
            this.addCLCmd("help", this.printHelp, "How to use command line");
            this.addCLCmd("save", this.saveCmd, "Save current scope as weak reference. (same as Cc.store(...))");
            this.addCLCmd("savestrong", this.saveStrongCmd, "Save current scope as strong reference");
            this.addCLCmd("saved", this.savedCmd, "Show a list of all saved references");
            this.addCLCmd("string", this.stringCmd, "Create String, useful to paste complex strings without worrying about \" or \'", false, null);
            this.addCLCmd("commands", this.cmdsCmd, "Show a list of all slash commands", true);
            this.addCLCmd("inspect", this.inspectCmd, "Inspect current scope");
            this.addCLCmd("explode", this.explodeCmd, "Explode current scope to its properties and values (similar to JSON)");
            this.addCLCmd("map", this.mapCmd, "Get display list map starting from current scope");
            this.addCLCmd("function", this.funCmd, "Create function. param is the commandline string to create as function. (experimental)");
            this.addCLCmd("autoscope", this.autoscopeCmd, "Toggle autoscoping.");
            this.addCLCmd("base", this.baseCmd, "Return to base scope");
            this.addCLCmd("/", this.prevCmd, "Return to previous scope");
            return;
        }// end function

        public function set base(obj:Object) : void
        {
            if (this.base)
            {
            }
            else
            {
                this._prevScope.reference = this._scope;
                this._scope = obj;
                this._scopeStr = LogReferences.ShortClassName(obj, false);
            }
            this._saved.set("base", obj);
            return;
        }// end function

        public function get base() : Object
        {
            return this._saved.get("base");
        }// end function

        public function handleScopeEvent(id:uint) : void
        {
            var _loc_2:* = console.refs.getRefById(id);
            if (_loc_2)
            {
                console.cl.setReturned(_loc_2, true, false);
            }
            else
            {
                console.report("Reference no longer exist.", -2);
            }
            return;
        }// end function

        public function store(n:String, obj:Object, strong:Boolean = false) : void
        {
            if (!n)
            {
                report("ERROR: Give a name to save.", 10);
                return;
            }
            if (obj is Function)
            {
                strong = true;
            }
            n = n.replace(/[^\w]*""[^\w]*/g, "");
            if (RESERVED.indexOf(n) >= 0)
            {
                report("ERROR: The name [" + n + "] is reserved", 10);
                return;
            }
            this._saved.set(n, obj, strong);
            return;
        }// end function

        public function getHintsFor(str:String, max:uint) : Array
        {
            var cmd:SlashCommand;
            var canadate:Array;
            var Y:String;
            var str:* = str;
            var max:* = max;
            var all:* = new Array();
            var _loc_4:int = 0;
            var _loc_5:* = this._slashCmds;
            while (_loc_5 in _loc_4)
            {
                
                cmd = _loc_5[_loc_4];
                if (!config.commandLineAllowed)
                {
                }
                if (cmd.allow)
                {
                    all.push(["/" + cmd.n + " ", cmd.d ? (cmd.d) : (null)]);
                }
            }
            if (config.commandLineAllowed)
            {
                var _loc_4:int = 0;
                var _loc_5:* = this._saved;
                while (_loc_5 in _loc_4)
                {
                    
                    Y = _loc_5[_loc_4];
                    all.push(["$" + Y, LogReferences.ShortClassName(this._saved.get(Y))]);
                }
                if (this._scope)
                {
                    all.push(["this", LogReferences.ShortClassName(this._scope)]);
                    all = all.concat(console.refs.getPossibleCalls(this._scope));
                }
            }
            str = str.toLowerCase();
            var hints:* = new Array();
            var _loc_4:int = 0;
            var _loc_5:* = all;
            while (_loc_5 in _loc_4)
            {
                
                canadate = _loc_5[_loc_4];
                if (canadate[0].toLowerCase().indexOf(str) == 0)
                {
                    hints.push(canadate);
                }
            }
            hints = hints.sort(function (a:Array, b:Array) : int
            {
                if (a[0].length < b[0].length)
                {
                    return -1;
                }
                if (a[0].length > b[0].length)
                {
                    return 1;
                }
                return 0;
            }// end function
            );
            if (max > 0)
            {
            }
            if (hints.length > max)
            {
                hints.splice(max);
                hints.push(["..."]);
            }
            return hints;
        }// end function

        public function get scopeString() : String
        {
            return config.commandLineAllowed ? (this._scopeStr) : ("");
        }// end function

        public function addCLCmd(n:String, callback:Function, desc:String, allow:Boolean = false, endOfArgsMarker:String = ";") : void
        {
            this._slashCmds.push(new SlashCommand(n, callback, desc, false, allow, endOfArgsMarker));
            return;
        }// end function

        public function addSlashCommand(n:String, callback:Function, desc:String = "", alwaysAvailable:Boolean = true, endOfArgsMarker:String = ";") : void
        {
            var _loc_6:* = this.getSlashCommandWithName(n);
            if (_loc_6 != null)
            {
                if (!_loc_6.user)
                {
                    throw new Error("Can not alter build-in slash command [" + n + "]");
                }
                this.removeSlashCommand(_loc_6);
            }
            this._slashCmds.push(new SlashCommand(n, callback, LogReferences.EscHTML(desc), true, alwaysAvailable, endOfArgsMarker));
            return;
        }// end function

        public function run(str:String, saves:Object = null, canThrowError:Boolean = false)
        {
            var exe:Executer;
            var X:String;
            var str:* = str;
            var saves:* = saves;
            var canThrowError:* = canThrowError;
            if (!str)
            {
                return;
            }
            str = str.replace(/\s*""\s*/, "");
            report("&gt; " + str, 4, false);
            var v:*;
            try
            {
                if (str.charAt(0) == "/")
                {
                    v = this.execCommand(str.substring(1));
                }
                else
                {
                    if (!config.commandLineAllowed)
                    {
                        report(DISABLED, 9);
                        return null;
                    }
                    exe = new Executer();
                    exe.addEventListener(Event.COMPLETE, this.onExecLineComplete, false, 0, true);
                    if (saves)
                    {
                        var _loc_5:int = 0;
                        var _loc_6:* = this._saved;
                        while (_loc_6 in _loc_5)
                        {
                            
                            X = _loc_6[_loc_5];
                            if (!saves[X])
                            {
                                saves[X] = this._saved[X];
                            }
                        }
                    }
                    else
                    {
                        saves = this._saved;
                    }
                    exe.setStored(saves);
                    exe.setReserved(RESERVED);
                    exe.autoScope = config.commandLineAutoScope;
                    v = exe.exec(this._scope, str);
                }
            }
            catch (e:Error)
            {
                reportError(e);
                if (canThrowError)
                {
                    throw e;
                }
            }
            return v;
        }// end function

        private function onExecLineComplete(event:Event) : void
        {
            var _loc_2:* = event.currentTarget as Executer;
            if (this._scope == _loc_2.scope)
            {
                this.setReturned(_loc_2.returned);
            }
            else if (_loc_2.scope == _loc_2.returned)
            {
                this.setReturned(_loc_2.scope, true);
            }
            else
            {
                this.setReturned(_loc_2.returned);
                this.setReturned(_loc_2.scope, true);
            }
            return;
        }// end function

        private function execCommand(str:String)
        {
            var result:*;
            var slashcmd:SlashCommand;
            var cmd:SlashCommand;
            var returned:*;
            var param:String;
            var restStr:String;
            var endInd:int;
            var str:* = str;
            if (str.search(/[^\s]""[^\s]/) < 0)
            {
                returned = this._saved.get(Executer.RETURNED);
                this.setReturned(returned, true);
                return returned;
            }
            var _loc_3:int = 0;
            var _loc_4:* = this._slashCmds;
            while (_loc_4 in _loc_3)
            {
                
                cmd = _loc_4[_loc_3];
                if (str.indexOf(cmd.n) == 0)
                {
                    if (str.length != cmd.n.length)
                    {
                    }
                }
                if (str.charAt(cmd.n.length) == " ")
                {
                    if (slashcmd != null)
                    {
                    }
                    if (slashcmd.n.length < cmd.n.length)
                    {
                        slashcmd = cmd;
                    }
                }
            }
            if (slashcmd != null)
            {
                try
                {
                    param = str.substring((slashcmd.n.length + 1));
                    if (!config.commandLineAllowed)
                    {
                    }
                    if (!slashcmd.allow)
                    {
                        report(DISABLED, 9);
                        return result;
                    }
                    if (slashcmd.endMarker)
                    {
                        endInd = param.indexOf(slashcmd.endMarker);
                        if (endInd >= 0)
                        {
                            restStr = param.substring(endInd + slashcmd.endMarker.length);
                            param = param.substring(0, endInd);
                        }
                    }
                    if (param.length == 0)
                    {
                        result = slashcmd.f();
                    }
                    else
                    {
                        result = slashcmd.f(param);
                    }
                    if (restStr)
                    {
                        result = this.run(restStr);
                    }
                }
                catch (err:Error)
                {
                    reportError(err);
                }
            }
            else
            {
                report("Undefined command <b>/commands</b> for list of all commands.", 10);
            }
            return result;
        }// end function

        public function setReturned(returned, changeScope:Boolean = false, say:Boolean = true) : void
        {
            if (!config.commandLineAllowed)
            {
                report(DISABLED, 9);
                return;
            }
            if (returned !== undefined)
            {
                this._saved.set(Executer.RETURNED, returned, true);
                if (changeScope)
                {
                }
                if (returned !== this._scope)
                {
                    this._prevScope.reference = this._scope;
                    this._scope = returned;
                    this._scopeStr = LogReferences.ShortClassName(this._scope, false);
                    this.sendCmdScope2Remote();
                    report("Changed to " + console.refs.makeRefTyped(returned), -1);
                }
                else if (say)
                {
                    report("Returned " + console.refs.makeString(returned), -1);
                }
            }
            else if (say)
            {
                report("Exec successful, undefined return.", -1);
            }
            return;
        }// end function

        public function sendCmdScope2Remote(event:Event = null) : void
        {
            var _loc_2:ByteArray = null;
            if (remoter.connected)
            {
                _loc_2 = new ByteArray();
                _loc_2.writeUTF(this._scopeStr);
                console.remoter.send("cls", _loc_2);
            }
            return;
        }// end function

        private function reportError(e:Error) : void
        {
            var _loc_10:String = null;
            var _loc_2:* = console.refs.makeString(e);
            var _loc_3:* = _loc_2.split(/\
n\s*""\n\s*/);
            var _loc_4:int = 10;
            var _loc_5:int = 0;
            var _loc_6:* = _loc_3.length;
            var _loc_7:Array = [];
            var _loc_8:* = new RegExp("\\s*at\\s+(" + Executer.CLASSES + "|" + getQualifiedClassName(this) + ")");
            var _loc_9:int = 0;
            while (_loc_9 < _loc_6)
            {
                
                _loc_10 = _loc_3[_loc_9];
                if (_loc_10.search(_loc_8) == 0)
                {
                    if (_loc_5 > 0)
                    {
                    }
                    if (_loc_9 > 0)
                    {
                        break;
                    }
                    _loc_5 = _loc_5 + 1;
                }
                _loc_7.push("<p" + _loc_4 + "> " + _loc_10 + "</p" + _loc_4 + ">");
                if (_loc_4 > 6)
                {
                    _loc_4 = _loc_4 - 1;
                }
                _loc_9 = _loc_9 + 1;
            }
            report(_loc_7.join("\n"), 9);
            return;
        }// end function

        private function getSlashCommandWithName(name:String) : SlashCommand
        {
            var _loc_2:SlashCommand = null;
            for each (_loc_2 in this._slashCmds)
            {
                
                if (_loc_2.n.indexOf(name) == 0)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        private function removeSlashCommand(cmd:SlashCommand) : void
        {
            var _loc_2:* = this._slashCmds.indexOf(cmd);
            if (_loc_2 >= 0)
            {
                this._slashCmds.splice(_loc_2, 1);
            }
            return;
        }// end function

        private function saveCmd(param:String = null) : void
        {
            this.store(param, this._scope, false);
            return;
        }// end function

        private function saveStrongCmd(param:String = null) : void
        {
            this.store(param, this._scope, true);
            return;
        }// end function

        private function savedCmd(... args) : void
        {
            var _loc_4:String = null;
            var _loc_5:WeakRef = null;
            report("Saved vars: ", -1);
            args = 0;
            var _loc_3:uint = 0;
            for (_loc_4 in this._saved)
            {
                
                _loc_5 = this._saved.getWeakRef(_loc_4);
                args = args + 1;
                if (_loc_5.reference == null)
                {
                    _loc_3 = _loc_3 + 1;
                }
                report((_loc_5.strong ? ("strong") : ("weak")) + " <b>$" + _loc_4 + "</b> = " + console.refs.makeString(_loc_5.reference), -2);
            }
            report("Found " + args + " item(s), " + _loc_3 + " empty.", -1);
            return;
        }// end function

        private function stringCmd(param:String) : void
        {
            report("String with " + param.length + " chars entered. Use /save <i>(name)</i> to save.", -2);
            this.setReturned(param, true);
            return;
        }// end function

        private function cmdsCmd(... args) : void
        {
            var _loc_4:SlashCommand = null;
            args = [];
            var _loc_3:Array = [];
            for each (_loc_4 in this._slashCmds)
            {
                
                if (!config.commandLineAllowed)
                {
                }
                if (_loc_4.allow)
                {
                    if (_loc_4.user)
                    {
                        _loc_3.push(_loc_4);
                        continue;
                    }
                    args.push(_loc_4);
                }
            }
            args = args.sortOn("n");
            report("Built-in commands:" + (!config.commandLineAllowed ? (" (limited permission)") : ("")), 4);
            for each (_loc_4 in args)
            {
                
                report("<b>/" + _loc_4.n + "</b> <p-1>" + _loc_4.d + "</p-1>", -2);
            }
            if (_loc_3.length)
            {
                _loc_3 = _loc_3.sortOn("n");
                report("User commands:", 4);
                for each (_loc_4 in _loc_3)
                {
                    
                    report("<b>/" + _loc_4.n + "</b> <p-1>" + _loc_4.d + "</p-1>", -2);
                }
            }
            return;
        }// end function

        private function inspectCmd(... args) : void
        {
            console.refs.focus(this._scope);
            return;
        }// end function

        private function explodeCmd(param:String = "0") : void
        {
            var _loc_2:* = int(param);
            console.explodech(console.panels.mainPanel.reportChannel, this._scope, _loc_2 <= 0 ? (3) : (_loc_2));
            return;
        }// end function

        private function mapCmd(param:String = "0") : void
        {
            console.mapch(console.panels.mainPanel.reportChannel, this._scope as DisplayObjectContainer, int(param));
            return;
        }// end function

        private function funCmd(param:String = "") : void
        {
            var _loc_2:* = new FakeFunction(this.run, param);
            report("Function created. Use /savestrong <i>(name)</i> to save.", -2);
            this.setReturned(_loc_2.exec, true);
            return;
        }// end function

        private function autoscopeCmd(... args) : void
        {
            config.commandLineAutoScope = !config.commandLineAutoScope;
            report("Auto-scoping <b>" + (config.commandLineAutoScope ? ("enabled") : ("disabled")) + "</b>.", 10);
            return;
        }// end function

        private function baseCmd(... args) : void
        {
            this.setReturned(this.base, true);
            return;
        }// end function

        private function prevCmd(... args) : void
        {
            this.setReturned(this._prevScope.reference, true);
            return;
        }// end function

        private function printHelp(... args) : void
        {
            report("____Command Line Help___", 10);
            report("/filter (text) = filter/search logs for matching text", 5);
            report("/commands to see all slash commands", 5);
            report("Press up/down arrow keys to recall previous line", 2);
            report("__Examples:", 10);
            report("<b>stage.stageWidth</b>", 5);
            report("<b>stage.scaleMode = flash.display.StageScaleMode.NO_SCALE</b>", 5);
            report("<b>stage.frameRate = 12</b>", 5);
            report("__________", 10);
            return;
        }// end function

    }
}
