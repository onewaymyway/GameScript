package com.google.analytics.debug
{
    import com.google.analytics.*;
    import com.google.analytics.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class Layout extends Object implements ILayout
    {
        private var _display:DisplayObject;
        private var _debug:DebugConfiguration;
        private var _mainPanel:Panel;
        private var _hasWarning:Boolean;
        private var _hasInfo:Boolean;
        private var _hasDebug:Boolean;
        private var _hasGRAlert:Boolean;
        private var _infoQueue:Array;
        private var _maxCharPerLine:int = 85;
        private var _warningQueue:Array;
        private var _GRAlertQueue:Array;
        public var visualDebug:Debug;

        public function Layout(debug:DebugConfiguration, display:DisplayObject)
        {
            this._display = display;
            this._debug = debug;
            this._hasWarning = false;
            this._hasInfo = false;
            this._hasDebug = false;
            this._hasGRAlert = false;
            this._warningQueue = [];
            this._infoQueue = [];
            this._GRAlertQueue = [];
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:int = 10;
            var _loc_2:* = this._display.stage.stageWidth - _loc_1 * 2;
            var _loc_3:* = this._display.stage.stageHeight - _loc_1 * 2;
            var _loc_4:* = new Panel("analytics", _loc_2, _loc_3);
            _loc_4.alignement = Align.top;
            _loc_4.stickToEdge = false;
            _loc_4.title = "Google Analytics v" + GATracker.version;
            this._mainPanel = _loc_4;
            this.addToStage(_loc_4);
            this.bringToFront(_loc_4);
            if (this._debug.minimizedOnStart)
            {
                this._mainPanel.onToggle();
            }
            this.createVisualDebug();
            this._display.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey, false, 0, true);
            return;
        }// end function

        public function destroy() : void
        {
            this._mainPanel.close();
            this._debug.layout = null;
            return;
        }// end function

        private function onKey(event:KeyboardEvent = null) : void
        {
            switch(event.keyCode)
            {
                case this._debug.showHideKey:
                {
                    this._mainPanel.visible = !this._mainPanel.visible;
                    break;
                }
                case this._debug.destroyKey:
                {
                    this.destroy();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _clearInfo(event:Event) : void
        {
            this._hasInfo = false;
            if (this._infoQueue.length > 0)
            {
                this.createInfo(this._infoQueue.shift());
            }
            return;
        }// end function

        private function _clearWarning(event:Event) : void
        {
            this._hasWarning = false;
            if (this._warningQueue.length > 0)
            {
                this.createWarning(this._warningQueue.shift());
            }
            return;
        }// end function

        private function _clearGRAlert(event:Event) : void
        {
            this._hasGRAlert = false;
            if (this._GRAlertQueue.length > 0)
            {
                this.createGIFRequestAlert.apply(this, this._GRAlertQueue.shift());
            }
            return;
        }// end function

        private function _filterMaxChars(message:String, maxCharPerLine:int = 0) : String
        {
            var _loc_6:String = null;
            var _loc_3:String = "\n";
            var _loc_4:Array = [];
            var _loc_5:* = message.split(_loc_3);
            if (maxCharPerLine == 0)
            {
                maxCharPerLine = this._maxCharPerLine;
            }
            var _loc_7:int = 0;
            while (_loc_7 < _loc_5.length)
            {
                
                _loc_6 = _loc_5[_loc_7];
                while (_loc_6.length > maxCharPerLine)
                {
                    
                    _loc_4.push(_loc_6.substr(0, maxCharPerLine));
                    _loc_6 = _loc_6.substring(maxCharPerLine);
                }
                _loc_4.push(_loc_6);
                _loc_7 = _loc_7 + 1;
            }
            return _loc_4.join(_loc_3);
        }// end function

        public function addToStage(visual:DisplayObject) : void
        {
            this._display.stage.addChild(visual);
            return;
        }// end function

        public function addToPanel(name:String, visual:DisplayObject) : void
        {
            var _loc_4:Panel = null;
            var _loc_3:* = this._display.stage.getChildByName(name);
            if (_loc_3)
            {
                _loc_4 = _loc_3 as Panel;
                _loc_4.addData(visual);
            }
            else
            {
                trace("panel \"" + name + "\" not found");
            }
            return;
        }// end function

        public function bringToFront(visual:DisplayObject) : void
        {
            this._display.stage.setChildIndex(visual, (this._display.stage.numChildren - 1));
            return;
        }// end function

        public function isAvailable() : Boolean
        {
            return this._display.stage != null;
        }// end function

        public function createVisualDebug() : void
        {
            if (!this.visualDebug)
            {
                this.visualDebug = new Debug();
                this.visualDebug.alignement = Align.bottom;
                this.visualDebug.stickToEdge = true;
                this.addToPanel("analytics", this.visualDebug);
                this._hasDebug = true;
            }
            return;
        }// end function

        public function createPanel(name:String, width:uint, height:uint) : void
        {
            var _loc_4:* = new Panel(name, width, height);
            _loc_4.alignement = Align.center;
            _loc_4.stickToEdge = false;
            this.addToStage(_loc_4);
            this.bringToFront(_loc_4);
            return;
        }// end function

        public function createInfo(message:String) : void
        {
            if (!this._hasInfo)
            {
            }
            if (!this.isAvailable())
            {
                this._infoQueue.push(message);
                return;
            }
            message = this._filterMaxChars(message);
            this._hasInfo = true;
            var _loc_2:* = new Info(message, this._debug.infoTimeout);
            this.addToPanel("analytics", _loc_2);
            _loc_2.addEventListener(Event.REMOVED_FROM_STAGE, this._clearInfo, false, 0, true);
            if (this._hasDebug)
            {
                this.visualDebug.write(message);
            }
            return;
        }// end function

        public function createWarning(message:String) : void
        {
            if (!this._hasWarning)
            {
            }
            if (!this.isAvailable())
            {
                this._warningQueue.push(message);
                return;
            }
            message = this._filterMaxChars(message);
            this._hasWarning = true;
            var _loc_2:* = new Warning(message, this._debug.warningTimeout);
            this.addToPanel("analytics", _loc_2);
            _loc_2.addEventListener(Event.REMOVED_FROM_STAGE, this._clearWarning, false, 0, true);
            if (this._hasDebug)
            {
                this.visualDebug.writeBold(message);
            }
            return;
        }// end function

        public function createAlert(message:String) : void
        {
            message = this._filterMaxChars(message);
            var _loc_2:* = new Alert(message, [new AlertAction("Close", "close", "close")]);
            this.addToPanel("analytics", _loc_2);
            if (this._hasDebug)
            {
                this.visualDebug.writeBold(message);
            }
            return;
        }// end function

        public function createFailureAlert(message:String) : void
        {
            var _loc_2:AlertAction = null;
            if (this._debug.verbose)
            {
                message = this._filterMaxChars(message);
                _loc_2 = new AlertAction("Close", "close", "close");
            }
            else
            {
                _loc_2 = new AlertAction("X", "close", "close");
            }
            var _loc_3:* = new FailureAlert(this._debug, message, [_loc_2]);
            this.addToPanel("analytics", _loc_3);
            if (this._hasDebug)
            {
                if (this._debug.verbose)
                {
                    message = message.split("\n").join("");
                    message = this._filterMaxChars(message, 66);
                }
                this.visualDebug.writeBold(message);
            }
            return;
        }// end function

        public function createSuccessAlert(message:String) : void
        {
            var _loc_2:AlertAction = null;
            if (this._debug.verbose)
            {
                message = this._filterMaxChars(message);
                _loc_2 = new AlertAction("Close", "close", "close");
            }
            else
            {
                _loc_2 = new AlertAction("X", "close", "close");
            }
            var _loc_3:* = new SuccessAlert(this._debug, message, [_loc_2]);
            this.addToPanel("analytics", _loc_3);
            if (this._hasDebug)
            {
                if (this._debug.verbose)
                {
                    message = message.split("\n").join("");
                    message = this._filterMaxChars(message, 66);
                }
                this.visualDebug.writeBold(message);
            }
            return;
        }// end function

        public function createGIFRequestAlert(message:String, request:URLRequest, ref:GIFRequest) : void
        {
            var message:* = message;
            var request:* = request;
            var ref:* = ref;
            if (this._hasGRAlert)
            {
                this._GRAlertQueue.push([message, request, ref]);
                return;
            }
            this._hasGRAlert = true;
            var f:* = function () : void
            {
                ref.sendRequest(request);
                return;
            }// end function
            ;
            message = this._filterMaxChars(message);
            var gra:* = new GIFRequestAlert(message, [new AlertAction("OK", "ok", f), new AlertAction("Cancel", "cancel", "close")]);
            this.addToPanel("analytics", gra);
            gra.addEventListener(Event.REMOVED_FROM_STAGE, this._clearGRAlert, false, 0, true);
            if (this._hasDebug)
            {
                if (this._debug.verbose)
                {
                    message = message.split("\n").join("");
                    message = this._filterMaxChars(message, 66);
                }
                this.visualDebug.write(message);
            }
            return;
        }// end function

    }
}
