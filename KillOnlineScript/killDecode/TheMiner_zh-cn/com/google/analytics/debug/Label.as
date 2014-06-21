package com.google.analytics.debug
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Label extends UISprite
    {
        private var _background:Shape;
        private var _textField:TextField;
        private var _text:String;
        private var _tag:String;
        private var _color:uint;
        protected var selectable:Boolean;
        public var stickToEdge:Boolean;
        public static var count:uint = 0;

        public function Label(text:String = "", tag:String = "uiLabel", color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
        {
            this.name = "Label" + count++;
            this.selectable = false;
            this._background = new Shape();
            this._textField = new TextField();
            this._text = text;
            this._tag = tag;
            if (alignement == null)
            {
                alignement = Align.none;
            }
            this.alignement = alignement;
            this.stickToEdge = stickToEdge;
            if (color == 0)
            {
                color = Style.backgroundColor;
            }
            this._color = color;
            this._textField.addEventListener(TextEvent.LINK, this.onLink);
            return;
        }// end function

        override protected function layout() : void
        {
            this._textField.type = TextFieldType.DYNAMIC;
            this._textField.autoSize = TextFieldAutoSize.LEFT;
            this._textField.background = false;
            this._textField.selectable = this.selectable;
            this._textField.multiline = true;
            this._textField.styleSheet = Style.sheet;
            this.text = this._text;
            addChild(this._background);
            addChild(this._textField);
            return;
        }// end function

        override protected function dispose() : void
        {
            this._textField.removeEventListener(TextEvent.LINK, this.onLink);
            super.dispose();
            return;
        }// end function

        private function _draw() : void
        {
            var _loc_1:* = this._background.graphics;
            _loc_1.clear();
            _loc_1.beginFill(this._color);
            var _loc_2:* = this._textField.width;
            var _loc_3:* = this._textField.height;
            if (forcedWidth > 0)
            {
                _loc_2 = forcedWidth;
            }
            Background.drawRounded(this, _loc_1, _loc_2, _loc_3);
            _loc_1.endFill();
            return;
        }// end function

        public function get tag() : String
        {
            return this._tag;
        }// end function

        public function set tag(value:String) : void
        {
            this._tag = value;
            this.text = "";
            return;
        }// end function

        public function get text() : String
        {
            return this._textField.text;
        }// end function

        public function set text(value:String) : void
        {
            if (value == "")
            {
                value = this._text;
            }
            this._textField.htmlText = "<span class=\"" + this.tag + "\">" + value + "</span>";
            this._text = value;
            this._draw();
            resize();
            return;
        }// end function

        public function appendText(value:String, newtag:String = "") : void
        {
            if (value == "")
            {
                return;
            }
            if (newtag == "")
            {
                newtag = this.tag;
            }
            this._textField.htmlText = this._textField.htmlText + ("<span class=\"" + newtag + "\">" + value + "</span>");
            this._text = this._text + value;
            this._draw();
            resize();
            return;
        }// end function

        public function onLink(event:TextEvent) : void
        {
            return;
        }// end function

    }
}
