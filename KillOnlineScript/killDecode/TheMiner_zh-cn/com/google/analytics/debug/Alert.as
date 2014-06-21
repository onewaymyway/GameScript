package com.google.analytics.debug
{
    import flash.events.*;

    public class Alert extends Label
    {
        private var _actions:Array;
        public var autoClose:Boolean = true;
        public var actionOnNextLine:Boolean = true;

        public function Alert(text:String, actions:Array, tag:String = "uiAlert", color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false, actionOnNextLine:Boolean = true)
        {
            if (color == 0)
            {
                color = Style.alertColor;
            }
            if (alignement == null)
            {
                alignement = Align.center;
            }
            super(text, tag, color, alignement, stickToEdge);
            this.selectable = true;
            super.mouseChildren = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.useHandCursor = true;
            this.actionOnNextLine = actionOnNextLine;
            this._actions = [];
            var _loc_8:int = 0;
            while (_loc_8 < actions.length)
            {
                
                actions[_loc_8].container = this;
                this._actions.push(actions[_loc_8]);
                _loc_8 = _loc_8 + 1;
            }
            return;
        }// end function

        private function _defineActions() : void
        {
            var _loc_3:AlertAction = null;
            var _loc_1:String = "";
            if (this.actionOnNextLine)
            {
                _loc_1 = _loc_1 + "\n";
            }
            else
            {
                _loc_1 = _loc_1 + " |";
            }
            _loc_1 = _loc_1 + " ";
            var _loc_2:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < this._actions.length)
            {
                
                _loc_3 = this._actions[_loc_4];
                _loc_2.push("<a href=\"event:" + _loc_3.activator + "\">" + _loc_3.name + "</a>");
                _loc_4 = _loc_4 + 1;
            }
            _loc_1 = _loc_1 + _loc_2.join(" | ");
            appendText(_loc_1, "uiAlertAction");
            return;
        }// end function

        protected function isValidAction(action:String) : Boolean
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._actions.length)
            {
                
                if (action == this._actions[_loc_2].activator)
                {
                    return true;
                }
                _loc_2 = _loc_2 + 1;
            }
            return false;
        }// end function

        protected function getAction(name:String) : AlertAction
        {
            var _loc_2:int = 0;
            while (_loc_2 < this._actions.length)
            {
                
                if (name == this._actions[_loc_2].activator)
                {
                    return this._actions[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return null;
        }// end function

        protected function spaces(num:int) : String
        {
            var _loc_2:String = "";
            var _loc_3:String = "          ";
            var _loc_4:int = 0;
            while (_loc_4 < (num + 1))
            {
                
                _loc_2 = _loc_2 + _loc_3;
                _loc_4 = _loc_4 + 1;
            }
            return _loc_2;
        }// end function

        override protected function layout() : void
        {
            super.layout();
            this._defineActions();
            return;
        }// end function

        public function close() : void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            }
            return;
        }// end function

        override public function onLink(event:TextEvent) : void
        {
            var _loc_2:AlertAction = null;
            if (this.isValidAction(event.text))
            {
                _loc_2 = this.getAction(event.text);
                if (_loc_2)
                {
                    _loc_2.execute();
                }
            }
            if (this.autoClose)
            {
                this.close();
            }
            return;
        }// end function

    }
}
