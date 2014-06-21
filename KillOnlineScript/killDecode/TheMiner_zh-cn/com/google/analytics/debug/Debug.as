package com.google.analytics.debug
{
    import flash.events.*;
    import flash.ui.*;

    public class Debug extends Label
    {
        private var _lines:Array;
        private var _linediff:int = 0;
        private var _preferredForcedWidth:uint = 540;
        public var maxLines:uint = 16;
        public static var count:uint;

        public function Debug(color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
        {
            if (alignement == null)
            {
                alignement = Align.bottom;
            }
            super("", "uiLabel", color, alignement, stickToEdge);
            this.name = "Debug" + count++;
            this._lines = [];
            selectable = true;
            addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            return;
        }// end function

        override public function get forcedWidth() : uint
        {
            if (this.parent)
            {
                if (UISprite(this.parent).forcedWidth > this._preferredForcedWidth)
                {
                    return this._preferredForcedWidth;
                }
                return UISprite(this.parent).forcedWidth;
            }
            else
            {
                return super.forcedWidth;
            }
        }// end function

        override protected function dispose() : void
        {
            removeEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            super.dispose();
            return;
        }// end function

        private function onKey(event:KeyboardEvent = null) : void
        {
            var _loc_2:Array = null;
            switch(event.keyCode)
            {
                case Keyboard.DOWN:
                {
                    _loc_2 = this._getLinesToDisplay(1);
                    break;
                }
                case Keyboard.UP:
                {
                    _loc_2 = this._getLinesToDisplay(-1);
                    break;
                }
                default:
                {
                    _loc_2 = null;
                    break;
                }
            }
            if (_loc_2 == null)
            {
                return;
            }
            text = _loc_2.join("\n");
            return;
        }// end function

        private function _getLinesToDisplay(direction:int = 0) : Array
        {
            var _loc_2:Array = null;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            if ((this._lines.length - 1) > this.maxLines)
            {
                if (this._linediff <= 0)
                {
                    this._linediff = this._linediff + direction;
                }
                else
                {
                    if (this._linediff > 0)
                    {
                    }
                    if (direction < 0)
                    {
                        this._linediff = this._linediff + direction;
                    }
                }
                _loc_3 = this._lines.length - this.maxLines + this._linediff;
                _loc_4 = _loc_3 + this.maxLines;
                _loc_2 = this._lines.slice(_loc_3, _loc_4);
            }
            else
            {
                _loc_2 = this._lines;
            }
            return _loc_2;
        }// end function

        public function close() : void
        {
            this.dispose();
            return;
        }// end function

        public function write(message:String, bold:Boolean = false) : void
        {
            var _loc_3:Array = null;
            if (message.indexOf("") > -1)
            {
                _loc_3 = message.split("\n");
            }
            else
            {
                _loc_3 = [message];
            }
            var _loc_4:String = "";
            var _loc_5:String = "";
            if (bold)
            {
                _loc_4 = "<b>";
                _loc_5 = "</b>";
            }
            var _loc_6:int = 0;
            while (_loc_6 < _loc_3.length)
            {
                
                this._lines.push(_loc_4 + _loc_3[_loc_6] + _loc_5);
                _loc_6 = _loc_6 + 1;
            }
            var _loc_7:* = this._getLinesToDisplay();
            text = _loc_7.join("\n");
            return;
        }// end function

        public function writeBold(message:String) : void
        {
            this.write(message, true);
            return;
        }// end function

    }
}
