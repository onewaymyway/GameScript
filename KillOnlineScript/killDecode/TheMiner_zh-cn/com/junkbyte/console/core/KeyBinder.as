package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import flash.events.*;
    import flash.text.*;

    public class KeyBinder extends ConsoleCore
    {
        private var _passInd:int;
        private var _binds:Object;
        private var _warns:uint;

        public function KeyBinder(console:Console)
        {
            this._binds = {};
            super(console);
            console.cl.addCLCmd("keybinds", this.printBinds, "List all keybinds used");
            return;
        }// end function

        public function bindKey(key:KeyBind, fun:Function, args:Array = null) : void
        {
            if (config.keystrokePassword)
            {
                if (!key.useKeyCode)
                {
                }
            }
            if (key.key.charAt(0) == config.keystrokePassword.charAt(0))
            {
                report("Error: KeyBind [" + key.key + "] is conflicting with Console password.", 9);
                return;
            }
            if (fun == null)
            {
                delete this._binds[key.key];
            }
            else
            {
                this._binds[key.key] = [fun, args];
            }
            return;
        }// end function

        public function keyDownHandler(event:KeyboardEvent) : void
        {
            this.handleKeyEvent(event, false);
            return;
        }// end function

        public function keyUpHandler(event:KeyboardEvent) : void
        {
            this.handleKeyEvent(event, true);
            return;
        }// end function

        private function handleKeyEvent(event:KeyboardEvent, isKeyUp:Boolean) : void
        {
            var _loc_4:KeyBind = null;
            var _loc_3:* = String.fromCharCode(event.charCode);
            if (isKeyUp)
            {
            }
            if (config.keystrokePassword != null)
            {
            }
            if (_loc_3)
            {
            }
            if (_loc_3 == config.keystrokePassword.substring(this._passInd, (this._passInd + 1)))
            {
                var _loc_5:String = this;
                var _loc_6:* = this._passInd + 1;
                _loc_5._passInd = _loc_6;
                if (this._passInd >= config.keystrokePassword.length)
                {
                    this._passInd = 0;
                    if (this.canTrigger())
                    {
                        if (console.visible)
                        {
                        }
                        if (!console.panels.mainPanel.visible)
                        {
                            console.panels.mainPanel.visible = true;
                        }
                        else
                        {
                            console.visible = !console.visible;
                        }
                        if (console.visible)
                        {
                        }
                        if (console.panels.mainPanel.visible)
                        {
                            console.panels.mainPanel.visible = true;
                            console.panels.mainPanel.moveBackSafePosition();
                        }
                    }
                    else if (this._warns < 3)
                    {
                        var _loc_5:String = this;
                        var _loc_6:* = this._warns + 1;
                        _loc_5._warns = _loc_6;
                        report("Password did not trigger because you have focus on an input TextField.", 8);
                    }
                }
            }
            else
            {
                if (isKeyUp)
                {
                    this._passInd = 0;
                }
                _loc_4 = new KeyBind(event.keyCode, event.shiftKey, event.ctrlKey, event.altKey, isKeyUp);
                this.tryRunKey(_loc_4.key);
                if (_loc_3)
                {
                    _loc_4 = new KeyBind(_loc_3, event.shiftKey, event.ctrlKey, event.altKey, isKeyUp);
                    this.tryRunKey(_loc_4.key);
                }
            }
            return;
        }// end function

        private function printBinds(... args) : void
        {
            var _loc_3:String = null;
            report("Key binds:", -2);
            args = 0;
            for (_loc_3 in this._binds)
            {
                
                args = args + 1;
                report(_loc_3, -2);
            }
            report("--- Found " + args, -2);
            return;
        }// end function

        private function tryRunKey(key:String) : void
        {
            var _loc_2:* = this._binds[key];
            if (config.keyBindsEnabled)
            {
            }
            if (_loc_2)
            {
                if (this.canTrigger())
                {
                    (_loc_2[0] as Function).apply(null, _loc_2[1]);
                }
                else if (this._warns < 3)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._warns + 1;
                    _loc_3._warns = _loc_4;
                    report("Key bind [" + key + "] did not trigger because you have focus on an input TextField.", 8);
                }
            }
            return;
        }// end function

        private function canTrigger() : Boolean
        {
            var _loc_1:TextField = null;
            try
            {
                if (console.stage)
                {
                }
                if (console.stage.focus is TextField)
                {
                    _loc_1 = console.stage.focus as TextField;
                    if (_loc_1.type == TextFieldType.INPUT)
                    {
                        return false;
                    }
                }
            }
            catch (err:Error)
            {
            }
            return true;
        }// end function

    }
}
