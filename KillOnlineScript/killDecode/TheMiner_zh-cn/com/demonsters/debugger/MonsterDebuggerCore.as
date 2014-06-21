package com.demonsters.debugger
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    class MonsterDebuggerCore extends Object
    {
        private static const MONITOR_UPDATE:int = 1000;
        private static const HIGHLITE_COLOR:uint = 3381759;
        private static var _monitorTimer:Timer;
        private static var _monitorSprite:Sprite;
        private static var _monitorTime:Number;
        private static var _monitorStart:Number;
        private static var _monitorFrames:int;
        private static var _base:Object = null;
        private static var _stage:Stage = null;
        private static var _plugins:Object = {};
        private static var _highlight:Sprite;
        private static var _highlightInfo:TextField;
        private static var _highlightTarget:DisplayObject;
        private static var _highlightMouse:Boolean;
        private static var _highlightUpdate:Boolean;
        static const ID:String = "com.demonsters.debugger.core";

        function MonsterDebuggerCore()
        {
            return;
        }// end function

        static function initialize() : void
        {
            _monitorTime = new Date().time;
            _monitorStart = new Date().time;
            _monitorFrames = 0;
            _monitorTimer = new Timer(MONITOR_UPDATE);
            _monitorTimer.addEventListener(TimerEvent.TIMER, monitorTimerCallback, false, 0, true);
            _monitorTimer.start();
            if (_base.hasOwnProperty("stage"))
            {
                _base.hasOwnProperty("stage");
            }
            if (_base["stage"] != null)
            {
            }
            if (_base["stage"] is Stage)
            {
                _stage = _base["stage"] as Stage;
            }
            _monitorSprite = new Sprite();
            _monitorSprite.addEventListener(Event.ENTER_FRAME, frameHandler, false, 0, true);
            var _loc_1:* = new TextFormat();
            _loc_1.font = "Arial";
            _loc_1.color = 16777215;
            _loc_1.size = 11;
            _loc_1.leftMargin = 5;
            _loc_1.rightMargin = 5;
            _highlightInfo = new TextField();
            _highlightInfo.embedFonts = false;
            _highlightInfo.autoSize = TextFieldAutoSize.LEFT;
            _highlightInfo.mouseWheelEnabled = false;
            _highlightInfo.mouseEnabled = false;
            _highlightInfo.condenseWhite = false;
            _highlightInfo.embedFonts = false;
            _highlightInfo.multiline = false;
            _highlightInfo.selectable = false;
            _highlightInfo.wordWrap = false;
            _highlightInfo.defaultTextFormat = _loc_1;
            _highlightInfo.text = "";
            _highlight = new Sprite();
            _highlightMouse = false;
            _highlightTarget = null;
            _highlightUpdate = false;
            return;
        }// end function

        static function get base()
        {
            return _base;
        }// end function

        static function set base(value) : void
        {
            _base = value;
            return;
        }// end function

        static function hasPlugin(id:String) : Boolean
        {
            return id in _plugins;
        }// end function

        static function registerPlugin(id:String, target:MonsterDebuggerPlugin) : void
        {
            if (id in _plugins)
            {
                return;
            }
            _plugins[id] = target;
            return;
        }// end function

        static function unregisterPlugin(id:String) : void
        {
            if (id in _plugins)
            {
                _plugins[id] = null;
            }
            return;
        }// end function

        static function trace(caller, object, person:String = "", label:String = "", color:uint = 0, depth:int = 5) : void
        {
            var _loc_7:XML = null;
            var _loc_8:Object = null;
            if (MonsterDebugger.enabled)
            {
                _loc_7 = XML(MonsterDebuggerUtils.parse(object, "", 1, depth, false));
                _loc_8 = {command:MonsterDebuggerConstants.COMMAND_TRACE, memory:MonsterDebuggerUtils.getMemory(), date:new Date(), target:String(caller), reference:MonsterDebuggerUtils.getReferenceID(caller), xml:_loc_7, person:person, label:label, color:color};
                send(_loc_8);
            }
            return;
        }// end function

        static function snapshot(caller, object:DisplayObject, person:String = "", label:String = "") : void
        {
            var _loc_5:BitmapData = null;
            var _loc_6:ByteArray = null;
            var _loc_7:Object = null;
            if (MonsterDebugger.enabled)
            {
                _loc_5 = MonsterDebuggerUtils.snapshot(object);
                if (_loc_5 != null)
                {
                    _loc_6 = _loc_5.getPixels(new Rectangle(0, 0, _loc_5.width, _loc_5.height));
                    _loc_7 = {command:MonsterDebuggerConstants.COMMAND_SNAPSHOT, memory:MonsterDebuggerUtils.getMemory(), date:new Date(), target:String(caller), reference:MonsterDebuggerUtils.getReferenceID(caller), bytes:_loc_6, width:_loc_5.width, height:_loc_5.height, person:person, label:label};
                    send(_loc_7);
                }
            }
            return;
        }// end function

        static function breakpoint(caller, id:String = "breakpoint") : void
        {
            var _loc_3:XML = null;
            var _loc_4:Object = null;
            if (MonsterDebugger.enabled)
            {
            }
            if (MonsterDebuggerConnection.connected)
            {
                _loc_3 = MonsterDebuggerUtils.stackTrace();
                _loc_4 = {command:MonsterDebuggerConstants.COMMAND_PAUSE, memory:MonsterDebuggerUtils.getMemory(), date:new Date(), target:String(caller), reference:MonsterDebuggerUtils.getReferenceID(caller), stack:_loc_3, id:id};
                send(_loc_4);
                MonsterDebuggerUtils.pause();
            }
            return;
        }// end function

        static function inspect(object) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:XML = null;
            if (MonsterDebugger.enabled)
            {
                _base = object;
                _loc_2 = MonsterDebuggerUtils.getObject(_base, "", 0);
                if (_loc_2 != null)
                {
                    _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, "", 1, 2, true));
                    send({command:MonsterDebuggerConstants.COMMAND_BASE, xml:_loc_3});
                }
            }
            return;
        }// end function

        static function clear() : void
        {
            if (MonsterDebugger.enabled)
            {
                send({command:MonsterDebuggerConstants.COMMAND_CLEAR_TRACES});
            }
            return;
        }// end function

        static function sendInformation() : void
        {
            var _loc_8:* = undefined;
            var _loc_9:String = null;
            var _loc_10:String = null;
            var _loc_11:* = undefined;
            var _loc_12:XML = null;
            var _loc_13:Namespace = null;
            var _loc_14:String = null;
            var _loc_15:* = undefined;
            var _loc_16:int = 0;
            var _loc_1:* = Capabilities.playerType;
            var _loc_2:* = Capabilities.version;
            var _loc_3:* = Capabilities.isDebugger;
            var _loc_4:Boolean = false;
            var _loc_5:String = "";
            var _loc_6:String = "";
            try
            {
                _loc_8 = getDefinitionByName("mx.core::UIComponent");
                if (_loc_8 != null)
                {
                    _loc_4 = true;
                }
            }
            catch (e1:Error)
            {
            }
            if (_base is DisplayObject)
            {
            }
            if (_base.hasOwnProperty("loaderInfo"))
            {
                if (DisplayObject(_base).loaderInfo != null)
                {
                    _loc_6 = unescape(DisplayObject(_base).loaderInfo.url);
                }
            }
            if (_base.hasOwnProperty("stage"))
            {
                if (_base["stage"] != null)
                {
                }
                if (_base["stage"] is Stage)
                {
                    _loc_6 = unescape(Stage(_base["stage"]).loaderInfo.url);
                }
            }
            if (_loc_1 != "ActiveX")
            {
            }
            if (_loc_1 == "PlugIn")
            {
                if (ExternalInterface.available)
                {
                    try
                    {
                        _loc_9 = ExternalInterface.call("window.location.href.toString");
                        _loc_10 = ExternalInterface.call("window.document.title.toString");
                        if (_loc_9 != null)
                        {
                            _loc_6 = _loc_9;
                        }
                        if (_loc_10 != null)
                        {
                            _loc_5 = _loc_10;
                        }
                    }
                    catch (e2:Error)
                    {
                    }
                }
            }
            if (_loc_1 == "Desktop")
            {
                try
                {
                    _loc_11 = getDefinitionByName("flash.desktop::NativeApplication");
                    if (_loc_11 != null)
                    {
                        _loc_12 = _loc_11["nativeApplication"]["applicationDescriptor"];
                        _loc_13 = _loc_12.namespace();
                        _loc_14 = _loc_13::filename;
                        _loc_15 = getDefinitionByName("flash.filesystem::File");
                        if (Capabilities.os.toLowerCase().indexOf("windows") != -1)
                        {
                            _loc_14 = _loc_14 + ".exe";
                            var _loc_17:* = _loc_15["applicationDirectory"];
                            _loc_6 = _loc_17._loc_15["applicationDirectory"]["resolvePath"](_loc_14)["nativePath"];
                        }
                        else if (Capabilities.os.toLowerCase().indexOf("mac") != -1)
                        {
                            _loc_14 = _loc_14 + ".app";
                            var _loc_17:* = _loc_15["applicationDirectory"];
                            _loc_6 = _loc_17._loc_15["applicationDirectory"]["resolvePath"](_loc_14)["nativePath"];
                        }
                    }
                }
                catch (e3:Error)
                {
                }
            }
            if (_loc_5 == "")
            {
            }
            if (_loc_6 != "")
            {
                _loc_16 = Math.max(_loc_6.lastIndexOf("\\"), _loc_6.lastIndexOf("/"));
                if (_loc_16 != -1)
                {
                    _loc_5 = _loc_6.substring((_loc_16 + 1), _loc_6.lastIndexOf("."));
                }
                else
                {
                    _loc_5 = _loc_6;
                }
            }
            if (_loc_5 == "")
            {
                _loc_5 = "Application";
            }
            var _loc_7:Object = {command:MonsterDebuggerConstants.COMMAND_INFO, debuggerVersion:MonsterDebugger.VERSION, playerType:_loc_1, playerVersion:_loc_2, isDebugger:_loc_3, isFlex:_loc_4, fileLocation:_loc_6, fileTitle:_loc_5};
            send(_loc_7, true);
            MonsterDebuggerConnection.processQueue();
            return;
        }// end function

        static function handle(item:MonsterDebuggerData) : void
        {
            if (MonsterDebugger.enabled)
            {
                if (item.id != null)
                {
                }
                if (item.id == "")
                {
                    return;
                }
                if (item.id == MonsterDebuggerCore.ID)
                {
                    handleInternal(item);
                }
                else
                {
                    if (item.id in _plugins)
                    {
                    }
                    if (_plugins[item.id] != null)
                    {
                        MonsterDebuggerPlugin(_plugins[item.id]).handle(item);
                    }
                }
            }
            return;
        }// end function

        private static function handleInternal(item:MonsterDebuggerData) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:XML = null;
            var _loc_4:Function = null;
            var _loc_5:DisplayObject = null;
            var _loc_6:BitmapData = null;
            var _loc_7:ByteArray = null;
            switch(item.data["command"])
            {
                case MonsterDebuggerConstants.COMMAND_HELLO:
                {
                    sendInformation();
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_BASE:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, "", 0);
                    if (_loc_2 != null)
                    {
                        _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, "", 1, 2, true));
                        send({command:MonsterDebuggerConstants.COMMAND_BASE, xml:_loc_3});
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_INSPECT:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                        _base = _loc_2;
                        _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, "", 1, 2, true));
                        send({command:MonsterDebuggerConstants.COMMAND_BASE, xml:_loc_3});
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_GET_OBJECT:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                        _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, item.data["target"], 1, 2, true));
                        send({command:MonsterDebuggerConstants.COMMAND_GET_OBJECT, xml:_loc_3});
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_GET_PROPERTIES:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                        _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, item.data["target"], 1, 1, false));
                        send({command:MonsterDebuggerConstants.COMMAND_GET_PROPERTIES, xml:_loc_3});
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_GET_FUNCTIONS:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                        _loc_3 = XML(MonsterDebuggerUtils.parseFunctions(_loc_2, item.data["target"]));
                        send({command:MonsterDebuggerConstants.COMMAND_GET_FUNCTIONS, xml:_loc_3});
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_SET_PROPERTY:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 1);
                    if (_loc_2 != null)
                    {
                        try
                        {
                            _loc_2[item.data["name"]] = item.data["value"];
                            send({command:MonsterDebuggerConstants.COMMAND_SET_PROPERTY, target:item.data["target"], value:_loc_2[item.data["name"]]});
                        }
                        catch (e1:Error)
                        {
                        }
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_GET_PREVIEW:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                    }
                    if (MonsterDebuggerUtils.isDisplayObject(_loc_2))
                    {
                        _loc_5 = _loc_2 as DisplayObject;
                        _loc_6 = MonsterDebuggerUtils.snapshot(_loc_5, new Rectangle(0, 0, 300, 300));
                        if (_loc_6 != null)
                        {
                            _loc_7 = _loc_6.getPixels(new Rectangle(0, 0, _loc_6.width, _loc_6.height));
                            send({command:MonsterDebuggerConstants.COMMAND_GET_PREVIEW, bytes:_loc_7, width:_loc_6.width, height:_loc_6.height});
                        }
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_CALL_METHOD:
                {
                    _loc_4 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_4 != null)
                    {
                    }
                    if (_loc_4 is Function)
                    {
                        if (item.data["returnType"] == MonsterDebuggerConstants.TYPE_VOID)
                        {
                            _loc_4.apply(null, item.data["arguments"]);
                        }
                        else
                        {
                            try
                            {
                                _loc_2 = _loc_4.apply(null, item.data["arguments"]);
                                _loc_3 = XML(MonsterDebuggerUtils.parse(_loc_2, "", 1, 5, false));
                                send({command:MonsterDebuggerConstants.COMMAND_CALL_METHOD, id:item.data["id"], xml:_loc_3});
                            }
                            catch (e2:Error)
                            {
                            }
                        }
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_PAUSE:
                {
                    MonsterDebuggerUtils.pause();
                    send({command:MonsterDebuggerConstants.COMMAND_PAUSE});
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_RESUME:
                {
                    MonsterDebuggerUtils.resume();
                    send({command:MonsterDebuggerConstants.COMMAND_RESUME});
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_HIGHLIGHT:
                {
                    _loc_2 = MonsterDebuggerUtils.getObject(_base, item.data["target"], 0);
                    if (_loc_2 != null)
                    {
                    }
                    if (MonsterDebuggerUtils.isDisplayObject(_loc_2))
                    {
                        if (DisplayObject(_loc_2).stage != null)
                        {
                        }
                        if (DisplayObject(_loc_2).stage is Stage)
                        {
                            _stage = _loc_2["stage"];
                        }
                        if (_stage != null)
                        {
                            highlightClear();
                            send({command:MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
                            _highlight.removeEventListener(MouseEvent.CLICK, highlightClicked);
                            _highlight.mouseEnabled = false;
                            _highlightTarget = DisplayObject(_loc_2);
                            _highlightMouse = false;
                            _highlightUpdate = true;
                        }
                    }
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_START_HIGHLIGHT:
                {
                    highlightClear();
                    _highlight.addEventListener(MouseEvent.CLICK, highlightClicked, false, 0, true);
                    _highlight.mouseEnabled = true;
                    _highlightTarget = null;
                    _highlightMouse = true;
                    _highlightUpdate = true;
                    send({command:MonsterDebuggerConstants.COMMAND_START_HIGHLIGHT});
                    break;
                }
                case MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT:
                {
                    highlightClear();
                    _highlight.removeEventListener(MouseEvent.CLICK, highlightClicked);
                    _highlight.mouseEnabled = false;
                    _highlightTarget = null;
                    _highlightMouse = false;
                    _highlightUpdate = false;
                    send({command:MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private static function monitorTimerCallback(event:TimerEvent) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:Object = null;
            if (MonsterDebugger.enabled)
            {
                _loc_2 = new Date().time;
                _loc_3 = _loc_2 - _monitorTime;
                _loc_4 = _monitorFrames / _loc_3 * 1000;
                _loc_5 = 0;
                if (_stage == null)
                {
                    if (_base.hasOwnProperty("stage"))
                    {
                        _base.hasOwnProperty("stage");
                    }
                    if (_base["stage"] != null)
                    {
                    }
                    if (_base["stage"] is Stage)
                    {
                        _stage = Stage(_base["stage"]);
                    }
                }
                if (_stage != null)
                {
                    _loc_5 = _stage.frameRate;
                }
                _monitorFrames = 0;
                _monitorTime = _loc_2;
                if (MonsterDebuggerConnection.connected)
                {
                    _loc_6 = {command:MonsterDebuggerConstants.COMMAND_MONITOR, memory:MonsterDebuggerUtils.getMemory(), fps:_loc_4, fpsMovie:_loc_5, time:_loc_2};
                    send(_loc_6);
                }
            }
            return;
        }// end function

        private static function frameHandler(event:Event) : void
        {
            if (MonsterDebugger.enabled)
            {
                var _loc_3:* = _monitorFrames + 1;
                _monitorFrames = _loc_3;
                if (_highlightUpdate)
                {
                    highlightUpdate();
                }
            }
            return;
        }// end function

        private static function highlightClicked(event:MouseEvent) : void
        {
            event.preventDefault();
            event.stopImmediatePropagation();
            highlightClear();
            _highlightTarget = MonsterDebuggerUtils.getObjectUnderPoint(_stage, new Point(_stage.mouseX, _stage.mouseY));
            _highlightMouse = false;
            _highlight.removeEventListener(MouseEvent.CLICK, highlightClicked);
            _highlight.mouseEnabled = false;
            if (_highlightTarget != null)
            {
                inspect(_highlightTarget);
                highlightDraw(false);
            }
            send({command:MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
            return;
        }// end function

        private static function highlightUpdate() : void
        {
            var _loc_1:* = undefined;
            highlightClear();
            if (_highlightMouse)
            {
                if (_base.hasOwnProperty("stage"))
                {
                    _base.hasOwnProperty("stage");
                }
                if (_base["stage"] != null)
                {
                }
                if (_base["stage"] is Stage)
                {
                    _stage = _base["stage"] as Stage;
                }
                if (Capabilities.playerType == "Desktop")
                {
                    _loc_1 = getDefinitionByName("flash.desktop::NativeApplication");
                    if (_loc_1 != null)
                    {
                    }
                    if (_loc_1["nativeApplication"]["activeWindow"] != null)
                    {
                        _stage = _loc_1["nativeApplication"]["activeWindow"]["stage"];
                    }
                }
                if (_stage == null)
                {
                    _highlight.removeEventListener(MouseEvent.CLICK, highlightClicked);
                    _highlight.mouseEnabled = false;
                    _highlightTarget = null;
                    _highlightMouse = false;
                    _highlightUpdate = false;
                    return;
                }
                _highlightTarget = MonsterDebuggerUtils.getObjectUnderPoint(_stage, new Point(_stage.mouseX, _stage.mouseY));
                if (_highlightTarget != null)
                {
                    highlightDraw(true);
                }
                return;
            }
            if (_highlightTarget != null)
            {
                if (_highlightTarget.stage != null)
                {
                }
                if (_highlightTarget.parent == null)
                {
                    _highlight.removeEventListener(MouseEvent.CLICK, highlightClicked);
                    _highlight.mouseEnabled = false;
                    _highlightTarget = null;
                    _highlightMouse = false;
                    _highlightUpdate = false;
                    return;
                }
                highlightDraw(false);
            }
            return;
        }// end function

        private static function highlightDraw(fill:Boolean) : void
        {
            if (_highlightTarget == null)
            {
                return;
            }
            var _loc_2:* = _highlightTarget.getBounds(_stage);
            if (_highlightTarget is Stage)
            {
                _loc_2.x = 0;
                _loc_2.y = 0;
                _loc_2.width = _highlightTarget["stageWidth"];
                _loc_2.height = _highlightTarget["stageHeight"];
            }
            else
            {
                _loc_2.x = int(_loc_2.x + 0.5);
                _loc_2.y = int(_loc_2.y + 0.5);
                _loc_2.width = int(_loc_2.width + 0.5);
                _loc_2.height = int(_loc_2.height + 0.5);
            }
            var _loc_3:* = _loc_2.clone();
            _loc_3.x = _loc_3.x + 2;
            _loc_3.y = _loc_3.y + 2;
            _loc_3.width = _loc_3.width - 4;
            _loc_3.height = _loc_3.height - 4;
            if (_loc_3.width < 0)
            {
                _loc_3.width = 0;
            }
            if (_loc_3.height < 0)
            {
                _loc_3.height = 0;
            }
            _highlight.graphics.clear();
            _highlight.graphics.beginFill(HIGHLITE_COLOR, 1);
            _highlight.graphics.drawRect(_loc_2.x, _loc_2.y, _loc_2.width, _loc_2.height);
            _highlight.graphics.drawRect(_loc_3.x, _loc_3.y, _loc_3.width, _loc_3.height);
            if (fill)
            {
                _highlight.graphics.beginFill(HIGHLITE_COLOR, 0.25);
                _highlight.graphics.drawRect(_loc_3.x, _loc_3.y, _loc_3.width, _loc_3.height);
            }
            if (_highlightTarget.name != null)
            {
                _highlightInfo.text = String(_highlightTarget.name) + " - " + String(MonsterDebuggerDescribeType.get(_highlightTarget).@name);
            }
            else
            {
                _highlightInfo.text = String(MonsterDebuggerDescribeType.get(_highlightTarget).@name);
            }
            var _loc_4:* = new Rectangle(_loc_2.x, _loc_2.y - (_highlightInfo.textHeight + 3), _highlightInfo.textWidth + 15, _highlightInfo.textHeight + 5);
            if (_loc_4.y < 0)
            {
                _loc_4.y = _loc_2.y + _loc_2.height;
            }
            if (_loc_4.y + _loc_4.height > _stage.stageHeight)
            {
                _loc_4.y = _stage.stageHeight - _loc_4.height;
            }
            if (_loc_4.x < 0)
            {
                _loc_4.x = 0;
            }
            if (_loc_4.x + _loc_4.width > _stage.stageWidth)
            {
                _loc_4.x = _stage.stageWidth - _loc_4.width;
            }
            _highlight.graphics.beginFill(HIGHLITE_COLOR, 1);
            _highlight.graphics.drawRect(_loc_4.x, _loc_4.y, _loc_4.width, _loc_4.height);
            _highlight.graphics.endFill();
            _highlightInfo.x = _loc_4.x;
            _highlightInfo.y = _loc_4.y;
            try
            {
                _stage.addChild(_highlight);
                _stage.addChild(_highlightInfo);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private static function highlightClear() : void
        {
            if (_highlight != null)
            {
            }
            if (_highlight.parent != null)
            {
                _highlight.parent.removeChild(_highlight);
                _highlight.graphics.clear();
                _highlight.x = 0;
                _highlight.y = 0;
            }
            if (_highlightInfo != null)
            {
            }
            if (_highlightInfo.parent != null)
            {
                _highlightInfo.parent.removeChild(_highlightInfo);
                _highlightInfo.x = 0;
                _highlightInfo.y = 0;
            }
            return;
        }// end function

        private static function send(data:Object, direct:Boolean = false) : void
        {
            if (MonsterDebugger.enabled)
            {
                MonsterDebuggerConnection.send(MonsterDebuggerCore.ID, data, direct);
            }
            return;
        }// end function

    }
}
