package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class RollerPanel extends ConsolePanel
    {
        private var _settingKey:Boolean;
        public static const NAME:String = "rollerPanel";

        public function RollerPanel(m:Console)
        {
            super(m);
            name = NAME;
            init(60, 100, false);
            txtField = makeTF("rollerPrints");
            txtField.multiline = true;
            txtField.autoSize = TextFieldAutoSize.LEFT;
            registerTFRoller(txtField, this.onMenuRollOver, this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
            addEventListener(Event.ENTER_FRAME, this._onFrame);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeListeners);
            return;
        }// end function

        private function removeListeners(event:Event = null) : void
        {
            removeEventListener(Event.ENTER_FRAME, this._onFrame);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.removeListeners);
            if (stage)
            {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            }
            return;
        }// end function

        private function _onFrame(event:Event) : void
        {
            if (!console.stage)
            {
                this.close();
                return;
            }
            if (this._settingKey)
            {
                txtField.htmlText = "<high><menu>Press a key to set [ <a href=\"event:cancel\"><b>cancel</b></a> ]</menu></high>";
            }
            else
            {
                txtField.htmlText = "<low>" + this.getMapString(false) + "</low>";
                txtField.autoSize = TextFieldAutoSize.LEFT;
                txtField.setSelection(0, 0);
            }
            width = txtField.width + 4;
            height = txtField.height;
            return;
        }// end function

        public function getMapString(dolink:Boolean) : String
        {
            var _loc_7:DisplayObject = null;
            var _loc_8:String = null;
            var _loc_9:Array = null;
            var _loc_10:DisplayObjectContainer = null;
            var _loc_11:uint = 0;
            var _loc_12:uint = 0;
            var _loc_13:DisplayObject = null;
            var _loc_14:uint = 0;
            var _loc_15:String = null;
            var _loc_16:uint = 0;
            var _loc_2:* = console.stage;
            var _loc_3:String = "";
            if (!dolink)
            {
                _loc_8 = console.rollerCaptureKey ? (console.rollerCaptureKey.key) : ("unassigned");
                _loc_3 = "<menu> <a href=\"event:close\"><b>X</b></a></menu> Capture key: <menu><a href=\"event:capture\">" + _loc_8 + "</a></menu><br/>";
            }
            var _loc_4:* = new Point(_loc_2.mouseX, _loc_2.mouseY);
            if (_loc_2.areInaccessibleObjectsUnderPoint(_loc_4))
            {
                _loc_3 = _loc_3 + "<p9>Inaccessible objects detected</p9><br/>";
            }
            var _loc_5:* = _loc_2.getObjectsUnderPoint(_loc_4);
            var _loc_6:* = new Dictionary(true);
            if (_loc_5.length == 0)
            {
                _loc_5.push(_loc_2);
            }
            for each (_loc_7 in _loc_5)
            {
                
                _loc_9 = new Array(_loc_7);
                _loc_10 = _loc_7.parent;
                while (_loc_10)
                {
                    
                    _loc_9.unshift(_loc_10);
                    _loc_10 = _loc_10.parent;
                }
                _loc_11 = _loc_9.length;
                _loc_12 = 0;
                while (_loc_12 < _loc_11)
                {
                    
                    _loc_13 = _loc_9[_loc_12];
                    if (_loc_6[_loc_13] == undefined)
                    {
                        _loc_6[_loc_13] = _loc_12;
                        _loc_14 = _loc_12;
                        while (_loc_14 > 0)
                        {
                            
                            _loc_3 = _loc_3 + (_loc_14 == 1 ? (" ∟") : (" -"));
                            _loc_14 = _loc_14 - 1;
                        }
                        _loc_15 = _loc_13.name;
                        if (dolink)
                        {
                        }
                        if (console.config.useObjectLinking)
                        {
                            _loc_16 = console.refs.setLogRef(_loc_13);
                            _loc_15 = "<a href=\'event:cl_" + _loc_16 + "\'>" + _loc_15 + "</a> " + console.refs.makeRefTyped(_loc_13);
                        }
                        else
                        {
                            _loc_15 = _loc_15 + " (" + LogReferences.ShortClassName(_loc_13) + ")";
                        }
                        if (_loc_13 == _loc_2)
                        {
                            _loc_16 = console.refs.setLogRef(_loc_2);
                            if (_loc_16)
                            {
                                _loc_3 = _loc_3 + ("<p3><a href=\'event:cl_" + _loc_16 + "\'><i>Stage</i></a> ");
                            }
                            else
                            {
                                _loc_3 = _loc_3 + "<p3><i>Stage</i> ";
                            }
                            _loc_3 = _loc_3 + ("[" + _loc_2.mouseX + "," + _loc_2.mouseY + "]</p3><br/>");
                        }
                        else if (_loc_12 == (_loc_11 - 1))
                        {
                            _loc_3 = _loc_3 + ("<p5>" + _loc_15 + "</p5><br/>");
                        }
                        else
                        {
                            _loc_3 = _loc_3 + ("<p2><i>" + _loc_15 + "</i></p2><br/>");
                        }
                    }
                    _loc_12 = _loc_12 + 1;
                }
            }
            return _loc_3;
        }// end function

        override public function close() : void
        {
            this.cancelCaptureKeySet();
            this.removeListeners();
            super.close();
            console.panels.updateMenu();
            return;
        }// end function

        private function onMenuRollOver(event:TextEvent) : void
        {
            var _loc_3:KeyBind = null;
            var _loc_2:* = event.text ? (event.text.replace("event:", "")) : ("");
            if (_loc_2 == "close")
            {
                _loc_2 = "Close";
            }
            else if (_loc_2 == "capture")
            {
                _loc_3 = console.rollerCaptureKey;
                if (_loc_3)
                {
                    _loc_2 = "Unassign key ::" + _loc_3.key;
                }
                else
                {
                    _loc_2 = "Assign key";
                }
            }
            else if (_loc_2 == "cancel")
            {
                _loc_2 = "Cancel assign key";
            }
            else
            {
                _loc_2 = null;
            }
            console.panels.tooltip(_loc_2, this);
            return;
        }// end function

        protected function linkHandler(event:TextEvent) : void
        {
            TextField(event.currentTarget).setSelection(0, 0);
            if (event.text == "close")
            {
                this.close();
            }
            else if (event.text == "capture")
            {
                if (console.rollerCaptureKey)
                {
                    console.setRollerCaptureKey(null);
                }
                else
                {
                    this._settingKey = true;
                    stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler, false, 0, true);
                }
                console.panels.tooltip(null);
            }
            else if (event.text == "cancel")
            {
                this.cancelCaptureKeySet();
                console.panels.tooltip(null);
            }
            event.stopPropagation();
            return;
        }// end function

        private function cancelCaptureKeySet() : void
        {
            this._settingKey = false;
            if (stage)
            {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            }
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (!event.charCode)
            {
                return;
            }
            var _loc_2:* = String.fromCharCode(event.charCode);
            this.cancelCaptureKeySet();
            console.setRollerCaptureKey(_loc_2, event.shiftKey, event.ctrlKey, event.altKey);
            console.panels.tooltip(null);
            return;
        }// end function

    }
}
