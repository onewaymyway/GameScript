package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.core.*;
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;

    public class MainPanel extends ConsolePanel
    {
        private var _traceField:TextField;
        private var _cmdPrefx:TextField;
        private var _cmdField:TextField;
        private var _hintField:TextField;
        private var _cmdBG:Shape;
        private var _bottomLine:Shape;
        private var _mini:Boolean;
        private var _shift:Boolean;
        private var _ctrl:Boolean;
        private var _alt:Boolean;
        private var _scroll:Sprite;
        private var _scroller:Sprite;
        private var _scrolldelay:uint;
        private var _scrolldir:int;
        private var _scrolling:Boolean;
        private var _scrollHeight:Number;
        private var _selectionStart:int;
        private var _selectionEnd:int;
        private var _viewingChannels:Array;
        private var _ignoredChannels:Array;
        private var _extraMenus:Object;
        private var _cmdsInd:int = -1;
        private var _priority:uint;
        private var _filterText:String;
        private var _filterRegExp:RegExp;
        private var _clScope:String = "";
        private var _needUpdateMenu:Boolean;
        private var _needUpdateTrace:Boolean;
        private var _lockScrollUpdate:Boolean;
        private var _atBottom:Boolean = true;
        private var _enteringLogin:Boolean;
        private var _hint:String;
        private var _cmdsHistory:Array;
        public static const NAME:String = "mainPanel";
        private static const CL_HISTORY:String = "clhistory";
        private static const VIEWING_CH_HISTORY:String = "viewingChannels";
        private static const IGNORED_CH_HISTORY:String = "ignoredChannels";
        private static const PRIORITY_HISTORY:String = "priority";

        public function MainPanel(m:Console)
        {
            this._extraMenus = new Object();
            super(m);
            var _loc_2:* = style.menuFontSize;
            console.cl.addCLCmd("filter", this.setFilterText, "Filter console logs to matching string. When done, click on the * (global channel) at top.", true);
            console.cl.addCLCmd("filterexp", this.setFilterRegExp, "Filter console logs to matching regular expression", true);
            console.cl.addCLCmd("clearhistory", this.clearCommandLineHistory, "Clear history of commands you have entered.", true);
            name = NAME;
            minWidth = 50;
            minHeight = 18;
            this._traceField = makeTF("traceField");
            this._traceField.wordWrap = true;
            this._traceField.multiline = true;
            this._traceField.y = _loc_2;
            this._traceField.addEventListener(Event.SCROLL, this.onTraceScroll);
            addChild(this._traceField);
            txtField = makeTF("menuField");
            txtField.wordWrap = true;
            txtField.multiline = true;
            txtField.autoSize = TextFieldAutoSize.RIGHT;
            txtField.height = _loc_2 + 6;
            txtField.y = -2;
            registerTFRoller(txtField, this.onMenuRollOver);
            addChild(txtField);
            this._cmdBG = new Shape();
            this._cmdBG.name = "commandBackground";
            this._cmdBG.graphics.beginFill(style.commandLineColor, 0.1);
            this._cmdBG.graphics.drawRoundRect(0, 0, 100, 18, _loc_2, _loc_2);
            this._cmdBG.scale9Grid = new Rectangle(9, 9, 80, 1);
            addChild(this._cmdBG);
            var _loc_3:* = new TextFormat(style.menuFont, style.menuFontSize, style.highColor);
            this._cmdField = new TextField();
            this._cmdField.name = "commandField";
            this._cmdField.type = TextFieldType.INPUT;
            this._cmdField.x = 40;
            this._cmdField.height = _loc_2 + 6;
            this._cmdField.addEventListener(KeyboardEvent.KEY_DOWN, this.commandKeyDown);
            this._cmdField.addEventListener(KeyboardEvent.KEY_UP, this.commandKeyUp);
            this._cmdField.addEventListener(FocusEvent.FOCUS_IN, this.updateCmdHint);
            this._cmdField.addEventListener(FocusEvent.FOCUS_OUT, this.onCmdFocusOut);
            this._cmdField.defaultTextFormat = _loc_3;
            addChild(this._cmdField);
            this._hintField = makeTF("hintField", true);
            this._hintField.mouseEnabled = false;
            this._hintField.x = this._cmdField.x;
            this._hintField.autoSize = TextFieldAutoSize.LEFT;
            addChild(this._hintField);
            this.setHints();
            _loc_3.color = style.commandLineColor;
            this._cmdPrefx = new TextField();
            this._cmdPrefx.name = "commandPrefx";
            this._cmdPrefx.type = TextFieldType.DYNAMIC;
            this._cmdPrefx.x = 2;
            this._cmdPrefx.height = _loc_2 + 6;
            this._cmdPrefx.selectable = false;
            this._cmdPrefx.defaultTextFormat = _loc_3;
            this._cmdPrefx.addEventListener(MouseEvent.MOUSE_DOWN, this.onCmdPrefMouseDown);
            this._cmdPrefx.addEventListener(MouseEvent.MOUSE_MOVE, this.onCmdPrefRollOverOut);
            this._cmdPrefx.addEventListener(MouseEvent.ROLL_OUT, this.onCmdPrefRollOverOut);
            addChild(this._cmdPrefx);
            this._bottomLine = new Shape();
            this._bottomLine.name = "blinkLine";
            this._bottomLine.alpha = 0.2;
            addChild(this._bottomLine);
            this._scroll = new Sprite();
            this._scroll.name = "scroller";
            this._scroll.tabEnabled = false;
            this._scroll.y = _loc_2 + 4;
            this._scroll.buttonMode = true;
            this._scroll.addEventListener(MouseEvent.MOUSE_DOWN, this.onScrollbarDown, false, 0, true);
            this._scroller = new Sprite();
            this._scroller.name = "scrollbar";
            this._scroller.tabEnabled = false;
            this._scroller.y = style.controlSize;
            this._scroller.graphics.beginFill(style.controlColor, 1);
            this._scroller.graphics.drawRect(-style.controlSize, 0, style.controlSize, 30);
            this._scroller.graphics.beginFill(0, 0);
            this._scroller.graphics.drawRect((-style.controlSize) * 2, 0, style.controlSize * 2, 30);
            this._scroller.graphics.endFill();
            this._scroller.addEventListener(MouseEvent.MOUSE_DOWN, this.onScrollerDown, false, 0, true);
            this._scroll.addChild(this._scroller);
            addChild(this._scroll);
            this._cmdField.visible = false;
            this._cmdPrefx.visible = false;
            this._cmdBG.visible = false;
            this.updateCLScope("");
            init(640, 100, true);
            registerDragger(txtField);
            if (console.so[CL_HISTORY] is Array)
            {
                this._cmdsHistory = console.so[CL_HISTORY];
            }
            else
            {
                var _loc_4:* = new Array();
                this._cmdsHistory = new Array();
                console.so[CL_HISTORY] = _loc_4;
            }
            if (config.rememberFilterSettings)
            {
            }
            if (console.so[VIEWING_CH_HISTORY] is Array)
            {
                this._viewingChannels = console.so[VIEWING_CH_HISTORY];
            }
            else
            {
                var _loc_4:* = new Array();
                this._viewingChannels = new Array();
                console.so[VIEWING_CH_HISTORY] = _loc_4;
            }
            if (config.rememberFilterSettings)
            {
            }
            if (console.so[IGNORED_CH_HISTORY] is Array)
            {
                this._ignoredChannels = console.so[IGNORED_CH_HISTORY];
            }
            if (this._viewingChannels.length <= 0)
            {
            }
            if (this._ignoredChannels == null)
            {
                var _loc_4:* = new Array();
                this._ignoredChannels = new Array();
                console.so[IGNORED_CH_HISTORY] = _loc_4;
            }
            if (config.rememberFilterSettings)
            {
            }
            if (console.so[PRIORITY_HISTORY] is uint)
            {
                this._priority = console.so[PRIORITY_HISTORY];
            }
            addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel, false, 0, true);
            addEventListener(TextEvent.LINK, this.linkHandler, false, 0, true);
            addEventListener(Event.ADDED_TO_STAGE, this.stageAddedHandle, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, this.stageRemovedHandle, false, 0, true);
            return;
        }// end function

        public function addMenu(key:String, f:Function, args:Array, rollover:String) : void
        {
            if (key)
            {
                key = key.replace(/[^\w\-]*""[^\w\-]*/g, "");
                if (f == null)
                {
                    delete this._extraMenus[key];
                }
                else
                {
                    this._extraMenus[key] = new Array(f, args, rollover);
                }
                this._needUpdateMenu = true;
            }
            else
            {
                console.report("ERROR: Invalid add menu params.", 9);
            }
            return;
        }// end function

        private function stageAddedHandle(event:Event = null) : void
        {
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onStageMouseDown, true, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler, false, 0, true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
            return;
        }// end function

        private function stageRemovedHandle(event:Event = null) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onStageMouseDown, true);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            return;
        }// end function

        private function onStageMouseDown(event:MouseEvent) : void
        {
            this._shift = event.shiftKey;
            this._ctrl = event.ctrlKey;
            this._alt = event.altKey;
            return;
        }// end function

        private function onMouseWheel(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            if (this._shift)
            {
                _loc_2 = console.config.style.traceFontSize + (event.delta > 0 ? (1) : (-1));
                if (_loc_2 > 10)
                {
                }
                if (_loc_2 < 20)
                {
                    console.config.style.traceFontSize = _loc_2;
                    console.config.style.updateStyleSheet();
                    this.updateToBottom();
                    event.stopPropagation();
                }
            }
            return;
        }// end function

        private function onCmdPrefRollOverOut(event:MouseEvent) : void
        {
            console.panels.tooltip(event.type == MouseEvent.MOUSE_MOVE ? ("Current scope::(CommandLine)") : (""), this);
            return;
        }// end function

        private function onCmdPrefMouseDown(event:MouseEvent) : void
        {
            try
            {
                stage.focus = this._cmdField;
                this.setCLSelectionAtEnd();
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.SHIFT)
            {
                this._shift = true;
            }
            if (event.keyCode == Keyboard.CONTROL)
            {
                this._ctrl = true;
            }
            if (event.keyCode == 18)
            {
                this._alt = true;
            }
            return;
        }// end function

        private function keyUpHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.SHIFT)
            {
                this._shift = false;
            }
            else if (event.keyCode == Keyboard.CONTROL)
            {
                this._ctrl = false;
            }
            else if (event.keyCode == 18)
            {
                this._alt = false;
            }
            if (event.keyCode != Keyboard.TAB)
            {
            }
            if (event.keyCode == Keyboard.ENTER)
            {
            }
            if (parent.visible)
            {
            }
            if (visible)
            {
            }
            if (this._cmdField.visible)
            {
                try
                {
                    stage.focus = this._cmdField;
                    this.setCLSelectionAtEnd();
                }
                catch (err:Error)
                {
                }
            }
            return;
        }// end function

        public function requestLogin(on:Boolean = true) : void
        {
            var _loc_2:* = new ColorTransform();
            if (on)
            {
                console.commandLine = true;
                console.report("//", -2);
                console.report("// <b>Enter remoting password</b> in CommandLine below...", -2);
                this.updateCLScope("Password");
                _loc_2.color = style.controlColor;
                this._cmdBG.transform.colorTransform = _loc_2;
                this._traceField.transform.colorTransform = new ColorTransform(0.7, 0.7, 0.7);
            }
            else
            {
                this.updateCLScope("");
                this._cmdBG.transform.colorTransform = _loc_2;
                this._traceField.transform.colorTransform = _loc_2;
            }
            this._cmdField.displayAsPassword = on;
            this._enteringLogin = on;
            return;
        }// end function

        public function update(changed:Boolean) : void
        {
            if (this._bottomLine.alpha > 0)
            {
                this._bottomLine.alpha = this._bottomLine.alpha - 0.25;
            }
            if (style.showCommandLineScope)
            {
                if (this._clScope != console.cl.scopeString)
                {
                    this._clScope = console.cl.scopeString;
                    this.updateCLScope(this._clScope);
                }
            }
            else if (this._clScope != null)
            {
                this._clScope = "";
                this.updateCLScope("");
            }
            if (changed)
            {
                this._bottomLine.alpha = 1;
                this._needUpdateMenu = true;
                this._needUpdateTrace = true;
            }
            if (this._needUpdateTrace)
            {
                this._needUpdateTrace = false;
                this._updateTraces(true);
            }
            if (this._needUpdateMenu)
            {
                this._needUpdateMenu = false;
                this._updateMenu();
            }
            return;
        }// end function

        public function updateToBottom() : void
        {
            this._atBottom = true;
            this._needUpdateTrace = true;
            return;
        }// end function

        private function _updateTraces(onlyBottom:Boolean = false) : void
        {
            if (this._atBottom)
            {
                this.updateBottom();
            }
            else if (!onlyBottom)
            {
                this.updateFull();
            }
            if (this._selectionStart != this._selectionEnd)
            {
                if (this._atBottom)
                {
                    this._traceField.setSelection(this._traceField.text.length - this._selectionStart, this._traceField.text.length - this._selectionEnd);
                }
                else
                {
                    this._traceField.setSelection(this._traceField.text.length - this._selectionEnd, this._traceField.text.length - this._selectionStart);
                }
                this._selectionEnd = -1;
                this._selectionStart = -1;
            }
            return;
        }// end function

        private function updateFull() : void
        {
            var _loc_1:String = "";
            var _loc_2:* = console.logs.first;
            var _loc_3:* = this._viewingChannels.length != 1;
            if (this._priority == 0)
            {
            }
            var _loc_4:* = this._viewingChannels.length == 0;
            while (_loc_2)
            {
                
                if (!_loc_4)
                {
                }
                if (this.lineShouldShow(_loc_2))
                {
                    _loc_1 = _loc_1 + this.makeLine(_loc_2, _loc_3);
                }
                _loc_2 = _loc_2.next;
            }
            this._lockScrollUpdate = true;
            this._traceField.htmlText = "<logs>" + _loc_1 + "</logs>";
            this._lockScrollUpdate = false;
            this.updateScroller();
            return;
        }// end function

        public function setPaused(b:Boolean) : void
        {
            if (b)
            {
            }
            if (this._atBottom)
            {
                this._atBottom = false;
                this._updateTraces();
                this._traceField.scrollV = this._traceField.maxScrollV;
            }
            else if (!b)
            {
                this._atBottom = true;
                this.updateBottom();
            }
            this.updateMenu();
            return;
        }// end function

        private function updateBottom() : void
        {
            var _loc_6:int = 0;
            var _loc_1:String = "";
            var _loc_2:* = Math.round(this._traceField.height / style.traceFontSize);
            var _loc_3:* = Math.round(this._traceField.width * 5 / style.traceFontSize);
            var _loc_4:* = console.logs.last;
            var _loc_5:* = this._viewingChannels.length != 1;
            while (_loc_4)
            {
                
                if (this.lineShouldShow(_loc_4))
                {
                    _loc_6 = Math.ceil(_loc_4.text.length / _loc_3);
                    if (!_loc_4.html)
                    {
                    }
                    if (_loc_2 >= _loc_6)
                    {
                        _loc_1 = this.makeLine(_loc_4, _loc_5) + _loc_1;
                    }
                    else
                    {
                        _loc_4 = _loc_4.clone();
                        _loc_4.text = _loc_4.text.substring(Math.max(0, _loc_4.text.length - _loc_3 * _loc_2));
                        _loc_1 = this.makeLine(_loc_4, _loc_5) + _loc_1;
                        break;
                    }
                    _loc_2 = _loc_2 - _loc_6;
                    if (_loc_2 <= 0)
                    {
                        break;
                    }
                }
                _loc_4 = _loc_4.prev;
            }
            this._lockScrollUpdate = true;
            this._traceField.htmlText = "<logs>" + _loc_1 + "</logs>";
            this._traceField.scrollV = this._traceField.maxScrollV;
            this._lockScrollUpdate = false;
            this.updateScroller();
            return;
        }// end function

        private function lineShouldShow(line:Log) : Boolean
        {
            if (this._priority != 0)
            {
            }
            if (line.priority >= this._priority)
            {
                if (!this.chShouldShow(line.ch))
                {
                    this.chShouldShow(line.ch);
                    if (this._filterText)
                    {
                    }
                    if (this._viewingChannels.indexOf(ConsoleChannel.FILTER_CHANNEL) >= 0)
                    {
                    }
                }
                if (line.text.toLowerCase().indexOf(this._filterText) < 0)
                {
                    if (this._filterRegExp)
                    {
                    }
                    if (this._viewingChannels.indexOf(ConsoleChannel.FILTER_CHANNEL) >= 0)
                    {
                    }
                }
            }
            return line.text.search(this._filterRegExp) >= 0;
        }// end function

        private function chShouldShow(ch:String) : Boolean
        {
            if (this._viewingChannels.length != 0)
            {
            }
            if (this._viewingChannels.indexOf(ch) >= 0)
            {
                if (this._ignoredChannels.length != 0)
                {
                }
            }
            return this._ignoredChannels.indexOf(ch) < 0;
        }// end function

        public function get reportChannel() : String
        {
            return this._viewingChannels.length == 1 ? (this._viewingChannels[0]) : (ConsoleChannel.CONSOLE_CHANNEL);
        }// end function

        public function setViewingChannels(... args) : void
        {
            var _loc_3:Object = null;
            var _loc_4:String = null;
            args = new Array();
            for each (_loc_3 in args)
            {
                
                args.push(Console.MakeChannelName(_loc_3));
            }
            if (this._viewingChannels[0] == LogReferences.INSPECTING_CHANNEL)
            {
                if (args)
                {
                }
            }
            if (args[0] != this._viewingChannels[0])
            {
                console.refs.exitFocus();
            }
            this._ignoredChannels.splice(0);
            this._viewingChannels.splice(0);
            if (args.indexOf(ConsoleChannel.GLOBAL_CHANNEL) < 0)
            {
            }
            if (args.indexOf(null) < 0)
            {
                for each (_loc_4 in args)
                {
                    
                    if (_loc_4)
                    {
                        this._viewingChannels.push(_loc_4);
                    }
                }
            }
            this.updateToBottom();
            console.panels.updateMenu();
            return;
        }// end function

        public function get viewingChannels() : Array
        {
            return this._viewingChannels;
        }// end function

        public function setIgnoredChannels(... args) : void
        {
            var _loc_3:Object = null;
            var _loc_4:String = null;
            args = new Array();
            for each (_loc_3 in args)
            {
                
                args.push(Console.MakeChannelName(_loc_3));
            }
            if (this._viewingChannels[0] == LogReferences.INSPECTING_CHANNEL)
            {
                console.refs.exitFocus();
            }
            this._ignoredChannels.splice(0);
            this._viewingChannels.splice(0);
            if (args.indexOf(ConsoleChannel.GLOBAL_CHANNEL) < 0)
            {
            }
            if (args.indexOf(null) < 0)
            {
                for each (_loc_4 in args)
                {
                    
                    if (_loc_4)
                    {
                        this._ignoredChannels.push(_loc_4);
                    }
                }
            }
            this.updateToBottom();
            console.panels.updateMenu();
            return;
        }// end function

        public function get ignoredChannels() : Array
        {
            return this._ignoredChannels;
        }// end function

        private function setFilterText(str:String = "") : void
        {
            if (str)
            {
                this._filterRegExp = null;
                this._filterText = LogReferences.EscHTML(str.toLowerCase());
                this.startFilter();
            }
            else
            {
                this.endFilter();
            }
            return;
        }// end function

        private function setFilterRegExp(expstr:String = "") : void
        {
            if (expstr)
            {
                this._filterText = null;
                this._filterRegExp = new RegExp(LogReferences.EscHTML(expstr), "gi");
                this.startFilter();
            }
            else
            {
                this.endFilter();
            }
            return;
        }// end function

        private function startFilter() : void
        {
            console.clear(ConsoleChannel.FILTER_CHANNEL);
            console.logs.addChannel(ConsoleChannel.FILTER_CHANNEL);
            this.setViewingChannels(ConsoleChannel.FILTER_CHANNEL);
            return;
        }// end function

        private function endFilter() : void
        {
            this._filterRegExp = null;
            this._filterText = null;
            if (this._viewingChannels.length == 1)
            {
            }
            if (this._viewingChannels[0] == ConsoleChannel.FILTER_CHANNEL)
            {
                this.setViewingChannels(ConsoleChannel.GLOBAL_CHANNEL);
            }
            return;
        }// end function

        private function makeLine(line:Log, showch:Boolean) : String
        {
            var _loc_3:String = "<p>";
            if (showch)
            {
                _loc_3 = _loc_3 + line.chStr;
            }
            if (config.showLineNumber)
            {
                _loc_3 = _loc_3 + line.lineStr;
            }
            if (config.showTimestamp)
            {
                _loc_3 = _loc_3 + line.timeStr;
            }
            var _loc_4:* = "p" + line.priority;
            return _loc_3 + "<" + _loc_4 + ">" + this.addFilterText(line.text) + "</" + _loc_4 + "></p>";
        }// end function

        private function addFilterText(txt:String) : String
        {
            var _loc_2:Object = null;
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            if (this._filterRegExp)
            {
                this._filterRegExp.lastIndex = 0;
                _loc_2 = this._filterRegExp.exec(txt);
                while (_loc_2 != null)
                {
                    
                    _loc_3 = _loc_2.index;
                    _loc_4 = _loc_2[0];
                    if (_loc_4.search("<|>") >= 0)
                    {
                        this._filterRegExp.lastIndex = this._filterRegExp.lastIndex - (_loc_4.length - _loc_4.search("<|>"));
                    }
                    else if (txt.lastIndexOf("<", _loc_3) <= txt.lastIndexOf(">", _loc_3))
                    {
                        txt = txt.substring(0, _loc_3) + "<u>" + txt.substring(_loc_3, _loc_3 + _loc_4.length) + "</u>" + txt.substring(_loc_3 + _loc_4.length);
                        this._filterRegExp.lastIndex = this._filterRegExp.lastIndex + 7;
                    }
                    _loc_2 = this._filterRegExp.exec(txt);
                }
            }
            else if (this._filterText)
            {
                _loc_5 = txt.toLowerCase();
                _loc_6 = _loc_5.lastIndexOf(this._filterText);
                while (_loc_6 >= 0)
                {
                    
                    txt = txt.substring(0, _loc_6) + "<u>" + txt.substring(_loc_6, _loc_6 + this._filterText.length) + "</u>" + txt.substring(_loc_6 + this._filterText.length);
                    _loc_6 = _loc_5.lastIndexOf(this._filterText, _loc_6 - 2);
                }
            }
            return txt;
        }// end function

        private function onTraceScroll(event:Event = null) : void
        {
            var _loc_3:int = 0;
            if (!this._lockScrollUpdate)
            {
            }
            if (this._shift)
            {
                return;
            }
            var _loc_2:* = this._traceField.scrollV >= this._traceField.maxScrollV;
            if (!console.paused)
            {
            }
            if (this._atBottom != _loc_2)
            {
                _loc_3 = this._traceField.maxScrollV - this._traceField.scrollV;
                this._selectionStart = this._traceField.text.length - this._traceField.selectionBeginIndex;
                this._selectionEnd = this._traceField.text.length - this._traceField.selectionEndIndex;
                this._atBottom = _loc_2;
                this._updateTraces();
                this._traceField.scrollV = this._traceField.maxScrollV - _loc_3;
            }
            this.updateScroller();
            return;
        }// end function

        private function updateScroller() : void
        {
            if (this._traceField.maxScrollV <= 1)
            {
                this._scroll.visible = false;
            }
            else
            {
                this._scroll.visible = true;
                if (this._atBottom)
                {
                    this.scrollPercent = 1;
                }
                else
                {
                    this.scrollPercent = (this._traceField.scrollV - 1) / (this._traceField.maxScrollV - 1);
                }
            }
            return;
        }// end function

        private function onScrollbarDown(event:MouseEvent) : void
        {
            if (this._scroller.visible)
            {
            }
            if (this._scroller.mouseY <= 0)
            {
                if (!this._scroller.visible)
                {
                }
            }
            if (this._scroll.mouseY > this._scrollHeight / 2)
            {
                this._scrolldir = 3;
            }
            else
            {
                this._scrolldir = -3;
            }
            this._traceField.scrollV = this._traceField.scrollV + this._scrolldir;
            this._scrolldelay = 0;
            addEventListener(Event.ENTER_FRAME, this.onScrollBarFrame, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onScrollBarUp, false, 0, true);
            return;
        }// end function

        private function onScrollBarFrame(event:Event) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._scrolldelay + 1;
            _loc_2._scrolldelay = _loc_3;
            if (this._scrolldelay > 10)
            {
                this._scrolldelay = 9;
                if (this._scrolldir < 0)
                {
                }
                if (this._scroller.y <= this._scroll.mouseY)
                {
                    if (this._scrolldir > 0)
                    {
                    }
                }
                if (this._scroller.y + this._scroller.height < this._scroll.mouseY)
                {
                    this._traceField.scrollV = this._traceField.scrollV + this._scrolldir;
                }
            }
            return;
        }// end function

        private function onScrollBarUp(event:Event) : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onScrollBarFrame);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onScrollBarUp);
            return;
        }// end function

        private function get scrollPercent() : Number
        {
            return (this._scroller.y - style.controlSize) / (this._scrollHeight - 30 - style.controlSize * 2);
        }// end function

        private function set scrollPercent(per:Number) : void
        {
            this._scroller.y = style.controlSize + (this._scrollHeight - 30 - style.controlSize * 2) * per;
            return;
        }// end function

        private function onScrollerDown(event:MouseEvent) : void
        {
            var _loc_2:Number = NaN;
            this._scrolling = true;
            if (!console.paused)
            {
            }
            if (this._atBottom)
            {
                this._atBottom = false;
                _loc_2 = this.scrollPercent;
                this._updateTraces();
                this.scrollPercent = _loc_2;
            }
            this._scroller.startDrag(false, new Rectangle(0, style.controlSize, 0, this._scrollHeight - 30 - style.controlSize * 2));
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onScrollerMove, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onScrollerUp, false, 0, true);
            event.stopPropagation();
            return;
        }// end function

        private function onScrollerMove(event:MouseEvent) : void
        {
            this._lockScrollUpdate = true;
            this._traceField.scrollV = Math.round(this.scrollPercent * (this._traceField.maxScrollV - 1) + 1);
            this._lockScrollUpdate = false;
            return;
        }// end function

        private function onScrollerUp(event:MouseEvent) : void
        {
            this._scroller.stopDrag();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onScrollerMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.onScrollerUp);
            this._scrolling = false;
            this.onTraceScroll();
            return;
        }// end function

        override public function set width(n:Number) : void
        {
            this._lockScrollUpdate = true;
            super.width = n;
            this._traceField.width = n - 4;
            txtField.width = n - 6;
            this._cmdField.width = width - 15 - this._cmdField.x;
            this._cmdBG.width = n;
            this._bottomLine.graphics.clear();
            this._bottomLine.graphics.lineStyle(1, style.controlColor);
            this._bottomLine.graphics.moveTo(10, -1);
            this._bottomLine.graphics.lineTo(n - 10, -1);
            this._scroll.x = n;
            this._atBottom = true;
            this.updateCLSize();
            this._needUpdateMenu = true;
            this._needUpdateTrace = true;
            this._lockScrollUpdate = false;
            return;
        }// end function

        override public function set height(n:Number) : void
        {
            this._lockScrollUpdate = true;
            var _loc_2:* = style.menuFontSize;
            var _loc_3:* = _loc_2 + 6 + style.traceFontSize;
            if (height != n)
            {
                this._mini = n < (this._cmdField.visible ? (_loc_3 + _loc_2 + 4) : (_loc_3));
            }
            super.height = n;
            if (!this._mini)
            {
            }
            var _loc_4:* = !style.topMenu;
            this.updateTraceFHeight();
            this._traceField.y = _loc_4 ? (0) : (_loc_2);
            this._traceField.height = n - (this._cmdField.visible ? (_loc_2 + 4) : (0)) - (_loc_4 ? (0) : (_loc_2));
            var _loc_5:* = n - (_loc_2 + 6);
            this._cmdField.y = _loc_5;
            this._cmdPrefx.y = _loc_5;
            this._hintField.y = this._cmdField.y - this._hintField.height;
            this._cmdBG.y = _loc_5;
            this._bottomLine.y = this._cmdField.visible ? (_loc_5) : (n);
            this._scroll.y = _loc_4 ? (6) : (_loc_2 + 4);
            var _loc_6:* = style.controlSize;
            this._scrollHeight = this._bottomLine.y - (this._cmdField.visible ? (0) : (_loc_6 * 2)) - this._scroll.y;
            this._scroller.visible = this._scrollHeight > 40;
            this._scroll.graphics.clear();
            if (this._scrollHeight >= 10)
            {
                this._scroll.graphics.beginFill(style.controlColor, 0.7);
                this._scroll.graphics.drawRect(-_loc_6, 0, _loc_6, _loc_6);
                this._scroll.graphics.drawRect(-_loc_6, this._scrollHeight - _loc_6, _loc_6, _loc_6);
                this._scroll.graphics.beginFill(style.controlColor, 0.25);
                this._scroll.graphics.drawRect(-_loc_6, _loc_6, _loc_6, this._scrollHeight - _loc_6 * 2);
                this._scroll.graphics.beginFill(0, 0);
                this._scroll.graphics.drawRect((-_loc_6) * 2, _loc_6 * 2, _loc_6 * 2, this._scrollHeight - _loc_6 * 2);
                this._scroll.graphics.endFill();
            }
            this._atBottom = true;
            this._needUpdateTrace = true;
            this._lockScrollUpdate = false;
            return;
        }// end function

        private function updateTraceFHeight() : void
        {
            if (!this._mini)
            {
            }
            var _loc_1:* = !style.topMenu;
            this._traceField.y = _loc_1 ? (0) : (txtField.y + txtField.height - 6);
            this._traceField.height = Math.max(0, height - (this._cmdField.visible ? (style.menuFontSize + 4) : (0)) - this._traceField.y);
            return;
        }// end function

        public function updateMenu(instant:Boolean = false) : void
        {
            if (instant)
            {
                this._updateMenu();
            }
            else
            {
                this._needUpdateMenu = true;
            }
            return;
        }// end function

        private function _updateMenu() : void
        {
            var _loc_2:Boolean = false;
            var _loc_1:String = "<r><high>";
            if (!this._mini)
            {
            }
            if (!style.topMenu)
            {
                _loc_1 = _loc_1 + "<menu><b> <a href=\"event:show\">‹</a>";
            }
            else
            {
                if (!console.panels.channelsPanel)
                {
                    _loc_1 = _loc_1 + this.getChannelsLink(true);
                }
                _loc_1 = _loc_1 + "<menu> <b>";
                if (_loc_2)
                {
                    _loc_1 = _loc_1 + "¦ ";
                }
                _loc_1 = _loc_1 + " ¦</b>";
                _loc_1 = _loc_1 + " <a href=\"event:copy\">Sv</a>";
                _loc_1 = _loc_1 + this.doActive(" <a href=\"event:pause\">P</a>", console.paused);
                _loc_1 = _loc_1 + " <a href=\"event:clear\">C</a>";
            }
            _loc_1 = _loc_1 + " </b></menu></high></r>";
            txtField.htmlText = _loc_1;
            txtField.scrollH = txtField.maxScrollH;
            this.updateTraceFHeight();
            return;
        }// end function

        public function getChannelsLink(limited:Boolean = false) : String
        {
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_2:String = "<chs>";
            var _loc_3:* = console.logs.getChannels();
            var _loc_4:* = _loc_3.length;
            if (limited)
            {
            }
            if (_loc_4 > style.maxChannelsInMenu)
            {
                _loc_4 = style.maxChannelsInMenu;
            }
            if (this._viewingChannels.length <= 0)
            {
            }
            var _loc_5:* = this._ignoredChannels.length > 0;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_7 = _loc_3[_loc_6];
                if (!_loc_5)
                {
                }
                if (_loc_6 != 0)
                {
                    if (_loc_5)
                    {
                    }
                    if (_loc_6 != 0)
                    {
                    }
                }
                _loc_8 = this.chShouldShow(_loc_7) ? ("<ch><b>" + _loc_7 + "</b></ch>") : (_loc_7);
                _loc_2 = _loc_2 + ("<a href=\"event:channel_" + _loc_7 + "\">[" + _loc_8 + "]</a> ");
                _loc_6 = _loc_6 + 1;
            }
            _loc_2 = _loc_2 + "</chs> ";
            return _loc_2;
        }// end function

        private function doActive(str:String, b:Boolean) : String
        {
            if (b)
            {
                return "<menuHi>" + str + "</menuHi>";
            }
            return str;
        }// end function

        public function onMenuRollOver(event:TextEvent, src:ConsolePanel = null) : void
        {
            var _loc_4:Array = null;
            var _loc_5:Object = null;
            if (src == null)
            {
                src = this;
            }
            var _loc_3:* = event.text ? (event.text.replace("event:", "")) : ("");
            if (_loc_3 == "channel_" + ConsoleChannel.GLOBAL_CHANNEL)
            {
                _loc_3 = "View all channels";
            }
            else if (_loc_3 == "channel_" + ConsoleChannel.DEFAULT_CHANNEL)
            {
                _loc_3 = "Default channel::Logs with no channel";
            }
            else if (_loc_3 == "channel_" + ConsoleChannel.CONSOLE_CHANNEL)
            {
                _loc_3 = "Console\'s channel::Logs generated from Console";
            }
            else if (_loc_3 == "channel_" + ConsoleChannel.FILTER_CHANNEL)
            {
                _loc_3 = this._filterRegExp ? (String(this._filterRegExp)) : (this._filterText);
                _loc_3 = "Filtering channel" + "::*" + _loc_3 + "*";
            }
            else if (_loc_3 == "channel_" + LogReferences.INSPECTING_CHANNEL)
            {
                _loc_3 = "Inspecting channel";
            }
            else if (_loc_3.indexOf("channel_") == 0)
            {
                _loc_3 = "Change channel::shift: select multiple\nctrl: ignore channel";
            }
            else if (_loc_3 == "pause")
            {
                if (console.paused)
                {
                    _loc_3 = "Resume updates";
                }
                else
                {
                    _loc_3 = "Pause updates";
                }
            }
            else
            {
                if (_loc_3 == "close")
                {
                }
                if (src == this)
                {
                    _loc_3 = "Close::Type password to show again";
                }
                else if (_loc_3.indexOf("external_") == 0)
                {
                    _loc_4 = this._extraMenus[_loc_3.substring(9)];
                    if (_loc_4)
                    {
                        _loc_3 = _loc_4[2];
                    }
                }
                else
                {
                    _loc_5 = {fps:"Frames Per Second", mm:"Memory Monitor", roller:"Display Roller::Map the display list under your mouse", command:"Command Line", copy:"Save to clipboard::shift: no channel name\nctrl: use viewing filters\nalt: save to file", clear:"Clear log", priority:"Priority filter::shift: previous priority\n(skips unused priorites)", channels:"Expand channels", close:"Close"};
                    _loc_3 = _loc_5[_loc_3];
                }
            }
            console.panels.tooltip(_loc_3, src);
            return;
        }// end function

        protected function linkHandler(event:TextEvent) : void
        {
            var str:String;
            var file:FileReference;
            var ind:int;
            var menu:Array;
            var e:* = event;
            txtField.setSelection(0, 0);
            stopDrag();
            var t:* = e.text;
            if (t == "pause")
            {
                if (console.paused)
                {
                    console.paused = false;
                }
                else
                {
                    console.paused = true;
                }
                console.panels.tooltip(null);
            }
            else if (t == "hide")
            {
                console.panels.tooltip();
                this._mini = true;
                console.config.style.topMenu = false;
                this.height = height;
                this.updateMenu();
            }
            else if (t == "show")
            {
                console.panels.tooltip();
                this._mini = false;
                console.config.style.topMenu = true;
                this.height = height;
                this.updateMenu();
            }
            else if (t == "close")
            {
                console.panels.tooltip();
                visible = false;
                dispatchEvent(new Event(Event.CLOSE));
            }
            else if (t == "channels")
            {
                console.panels.channelsPanel = !console.panels.channelsPanel;
            }
            else if (t == "fps")
            {
                console.fpsMonitor = !console.fpsMonitor;
            }
            else if (t == "priority")
            {
                this.incPriority(this._shift);
            }
            else if (t == "mm")
            {
                console.memoryMonitor = !console.memoryMonitor;
            }
            else if (t == "roller")
            {
                console.displayRoller = !console.displayRoller;
            }
            else if (t == "command")
            {
                this.commandLine = !this.commandLine;
            }
            else if (t == "copy")
            {
                str = console.logs.getLogsAsString("\r\n", !this._shift, this._ctrl ? (this.lineShouldShow) : (null));
                if (this._alt)
                {
                    file = new FileReference();
                    try
                    {
                        var _loc_3:* = file;
                        _loc_3.file["save"](str, "log.txt");
                    }
                    catch (err:Error)
                    {
                        console.report("Save to file is not supported in your flash player.", 8);
                    }
                }
                else
                {
                    System.setClipboard(str);
                    console.report("Copied log to clipboard.", -1);
                }
            }
            else if (t == "clear")
            {
                console.clear();
            }
            else if (t == "settings")
            {
                console.report("A new window should open in browser. If not, try searching for \'Flash Player Global Security Settings panel\' online :)", -1);
                Security.showSettings(SecurityPanel.SETTINGS_MANAGER);
            }
            else if (t.indexOf("ref") == 0)
            {
                console.refs.handleRefEvent(t);
            }
            else if (t.indexOf("channel_") == 0)
            {
                this.onChannelPressed(t.substring(8));
            }
            else if (t.indexOf("cl_") == 0)
            {
                ind = t.indexOf("_", 3);
                console.cl.handleScopeEvent(uint(t.substring(3, ind < 0 ? (t.length) : (ind))));
                if (ind >= 0)
                {
                    this._cmdField.text = t.substring((ind + 1));
                }
            }
            else if (t.indexOf("external_") == 0)
            {
                menu = this._extraMenus[t.substring(9)];
                if (menu)
                {
                    menu[0].apply(null, menu[1]);
                }
            }
            txtField.setSelection(0, 0);
            e.stopPropagation();
            return;
        }// end function

        public function onChannelPressed(chn:String) : void
        {
            var _loc_2:Array = null;
            if (this._ctrl)
            {
            }
            if (chn != ConsoleChannel.GLOBAL_CHANNEL)
            {
                _loc_2 = this.toggleCHList(this._ignoredChannels, chn);
                this.setIgnoredChannels.apply(this, _loc_2);
            }
            else
            {
                if (this._shift)
                {
                }
                if (chn != ConsoleChannel.GLOBAL_CHANNEL)
                {
                }
                if (this._viewingChannels[0] != LogReferences.INSPECTING_CHANNEL)
                {
                    _loc_2 = this.toggleCHList(this._viewingChannels, chn);
                    this.setViewingChannels.apply(this, _loc_2);
                }
                else
                {
                    console.setViewingChannels(chn);
                }
            }
            return;
        }// end function

        private function toggleCHList(current:Array, chn:String) : Array
        {
            current = current.concat();
            var _loc_3:* = current.indexOf(chn);
            if (_loc_3 >= 0)
            {
                current.splice(_loc_3, 1);
                if (current.length == 0)
                {
                    current.push(ConsoleChannel.GLOBAL_CHANNEL);
                }
            }
            else
            {
                current.push(chn);
            }
            return current;
        }// end function

        public function set priority(p:uint) : void
        {
            this._priority = p;
            console.so[PRIORITY_HISTORY] = this._priority;
            this.updateToBottom();
            this.updateMenu();
            return;
        }// end function

        public function get priority() : uint
        {
            return this._priority;
        }// end function

        private function incPriority(down:Boolean) : void
        {
            var _loc_3:uint = 0;
            var _loc_2:uint = 10;
            var _loc_4:* = console.logs.last;
            var _loc_5:* = this._priority;
            this._priority = 0;
            var _loc_6:uint = 32000;
            do
            {
                
                _loc_6 = _loc_6 - 1;
                if (this.lineShouldShow(_loc_4))
                {
                    if (_loc_4.priority > _loc_5)
                    {
                    }
                    if (_loc_2 > _loc_4.priority)
                    {
                        _loc_2 = _loc_4.priority;
                    }
                    if (_loc_4.priority < _loc_5)
                    {
                    }
                    if (_loc_3 < _loc_4.priority)
                    {
                        _loc_3 = _loc_4.priority;
                    }
                }
                _loc_4 = _loc_4.prev;
                if (_loc_4)
                {
                }
            }while (_loc_6 > 0)
            if (down)
            {
                if (_loc_3 == _loc_5)
                {
                    _loc_5 = 10;
                }
                else
                {
                    _loc_5 = _loc_3;
                }
            }
            else if (_loc_2 == _loc_5)
            {
                _loc_5 = 0;
            }
            else
            {
                _loc_5 = _loc_2;
            }
            this.priority = _loc_5;
            return;
        }// end function

        private function clearCommandLineHistory(... args) : void
        {
            this._cmdsInd = -1;
            console.updateSO();
            this._cmdsHistory = new Array();
            return;
        }// end function

        private function commandKeyDown(event:KeyboardEvent) : void
        {
            if (event.keyCode == Keyboard.TAB)
            {
                if (this._hint)
                {
                    this._cmdField.text = this._hint;
                    this.setCLSelectionAtEnd();
                    this.setHints();
                }
            }
            return;
        }// end function

        private function commandKeyUp(event:KeyboardEvent) : void
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            if (event.keyCode == Keyboard.ENTER)
            {
                this.updateToBottom();
                this.setHints();
                if (this._enteringLogin)
                {
                    console.remoter.login(this._cmdField.text);
                    this._cmdField.text = "";
                    this.requestLogin(false);
                }
                else
                {
                    _loc_2 = this._cmdField.text;
                    if (_loc_2.length > 2)
                    {
                        _loc_3 = this._cmdsHistory.indexOf(_loc_2);
                        while (_loc_3 >= 0)
                        {
                            
                            this._cmdsHistory.splice(_loc_3, 1);
                            _loc_3 = this._cmdsHistory.indexOf(_loc_2);
                        }
                        this._cmdsHistory.unshift(_loc_2);
                        this._cmdsInd = -1;
                        if (this._cmdsHistory.length > 20)
                        {
                            this._cmdsHistory.splice(20);
                        }
                        console.updateSO(CL_HISTORY);
                    }
                    this._cmdField.text = "";
                    if (config.commandLineInputPassThrough != null)
                    {
                        _loc_2 = config.commandLineInputPassThrough(_loc_2);
                    }
                    if (_loc_2)
                    {
                        console.cl.run(_loc_2);
                    }
                }
            }
            else if (event.keyCode == Keyboard.ESCAPE)
            {
                if (stage)
                {
                    stage.focus = null;
                }
            }
            else if (event.keyCode == Keyboard.UP)
            {
                this.setHints();
                if (this._cmdField.text)
                {
                }
                if (this._cmdsInd < 0)
                {
                    this._cmdsHistory.unshift(this._cmdField.text);
                    var _loc_4:String = this;
                    var _loc_5:* = this._cmdsInd + 1;
                    _loc_4._cmdsInd = _loc_5;
                }
                if (this._cmdsInd < (this._cmdsHistory.length - 1))
                {
                    var _loc_4:String = this;
                    var _loc_5:* = this._cmdsInd + 1;
                    _loc_4._cmdsInd = _loc_5;
                    this._cmdField.text = this._cmdsHistory[this._cmdsInd];
                    this.setCLSelectionAtEnd();
                }
                else
                {
                    this._cmdsInd = this._cmdsHistory.length;
                    this._cmdField.text = "";
                }
            }
            else if (event.keyCode == Keyboard.DOWN)
            {
                this.setHints();
                if (this._cmdsInd > 0)
                {
                    var _loc_4:String = this;
                    var _loc_5:* = this._cmdsInd - 1;
                    _loc_4._cmdsInd = _loc_5;
                    this._cmdField.text = this._cmdsHistory[this._cmdsInd];
                    this.setCLSelectionAtEnd();
                }
                else
                {
                    this._cmdsInd = -1;
                    this._cmdField.text = "";
                }
            }
            else if (event.keyCode == Keyboard.TAB)
            {
                this.setCLSelectionAtEnd();
            }
            else if (!this._enteringLogin)
            {
                this.updateCmdHint();
            }
            return;
        }// end function

        private function setCLSelectionAtEnd() : void
        {
            this._cmdField.setSelection(this._cmdField.text.length, this._cmdField.text.length);
            return;
        }// end function

        protected function updateCmdHint(event:Event = null) : void
        {
            var _loc_2:* = this._cmdField.text;
            if (_loc_2)
            {
            }
            if (config.commandLineAutoCompleteEnabled)
            {
                try
                {
                    this.setHints(console.cl.getHintsFor(_loc_2, 5));
                    return;
                }
                catch (err:Error)
                {
                }
            }
            this.setHints();
            return;
        }// end function

        private function onCmdFocusOut(event:Event) : void
        {
            this.setHints();
            return;
        }// end function

        private function setHints(hints:Array = null) : void
        {
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:Rectangle = null;
            var _loc_6:String = null;
            var _loc_7:Boolean = false;
            var _loc_8:int = 0;
            var _loc_2:* = this._cmdField.text;
            if (hints)
            {
            }
            if (hints.length)
            {
                this._hint = hints[0][0];
                if (hints.length > 1)
                {
                    _loc_6 = hints[1][0];
                    _loc_7 = false;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_6.length)
                    {
                        
                        if (_loc_6.charAt(_loc_8) == this._hint.charAt(_loc_8))
                        {
                            _loc_7 = true;
                        }
                        else
                        {
                            if (_loc_7)
                            {
                            }
                            if (_loc_2.length < _loc_8)
                            {
                                this._hint = this._hint.substring(0, _loc_8);
                            }
                            break;
                        }
                        _loc_8 = _loc_8 + 1;
                    }
                }
                _loc_3 = new Array();
                for each (_loc_4 in hints)
                {
                    
                    _loc_3.push("<p3>" + _loc_4[0] + "</p3> <p0>" + (_loc_4[1] ? (_loc_4[1]) : ("")) + "</p0>");
                }
                this._hintField.htmlText = "<p>" + _loc_3.reverse().join("\n") + "</p>";
                this._hintField.visible = true;
                _loc_5 = this._cmdField.getCharBoundaries((_loc_2.length - 1));
                if (!_loc_5)
                {
                    _loc_5 = new Rectangle();
                }
                this._hintField.x = this._cmdField.x + _loc_5.x + _loc_5.width + 30;
                this._hintField.y = height - this._hintField.height;
            }
            else
            {
                this._hintField.visible = false;
                this._hint = null;
            }
            return;
        }// end function

        public function updateCLScope(str:String) : void
        {
            if (this._enteringLogin)
            {
                this._enteringLogin = false;
                this.requestLogin(false);
            }
            this._cmdPrefx.autoSize = TextFieldAutoSize.LEFT;
            this._cmdPrefx.text = str;
            this.updateCLSize();
            return;
        }// end function

        private function updateCLSize() : void
        {
            var _loc_1:* = width - 48;
            if (this._cmdPrefx.width <= 120)
            {
            }
            if (this._cmdPrefx.width > _loc_1)
            {
                this._cmdPrefx.autoSize = TextFieldAutoSize.NONE;
                this._cmdPrefx.width = _loc_1 > 120 ? (120) : (_loc_1);
                this._cmdPrefx.scrollH = this._cmdPrefx.maxScrollH;
            }
            this._cmdField.x = this._cmdPrefx.width + 2;
            this._cmdField.width = width - 15 - this._cmdField.x;
            this._hintField.x = this._cmdField.x;
            return;
        }// end function

        public function set commandLine(b:Boolean) : void
        {
            if (b)
            {
                this._cmdField.visible = true;
                this._cmdPrefx.visible = true;
                this._cmdBG.visible = true;
            }
            else
            {
                this._cmdField.visible = false;
                this._cmdPrefx.visible = false;
                this._cmdBG.visible = false;
            }
            this._needUpdateMenu = true;
            this.height = height;
            return;
        }// end function

        public function get commandLine() : Boolean
        {
            return this._cmdField.visible;
        }// end function

    }
}
