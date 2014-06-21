package com.google.analytics.debug
{
    import flash.display.*;
    import flash.events.*;

    public class Panel extends UISprite
    {
        private var _name:String;
        private var _backgroundColor:uint;
        private var _borderColor:uint;
        private var _colapsed:Boolean;
        private var _savedW:uint;
        private var _savedH:uint;
        private var _background:Shape;
        private var _data:UISprite;
        private var _title:Label;
        private var _border:Shape;
        private var _mask:Sprite;
        protected var baseAlpha:Number;
        private var _stickToEdge:Boolean;

        public function Panel(name:String, width:uint, height:uint, backgroundColor:uint = 0, borderColor:uint = 0, baseAlpha:Number = 0.3, alignement:Align = null, stickToEdge:Boolean = false)
        {
            this._name = name;
            this.name = name;
            this.mouseEnabled = false;
            this._colapsed = false;
            forcedWidth = width;
            forcedHeight = height;
            this.baseAlpha = baseAlpha;
            this._background = new Shape();
            this._data = new UISprite();
            this._data.forcedWidth = width;
            this._data.forcedHeight = height;
            this._data.mouseEnabled = false;
            this._title = new Label(name, "uiLabel", 16777215, Align.topLeft, stickToEdge);
            this._title.buttonMode = true;
            this._title.margin.top = 0.6;
            this._title.margin.left = 0.6;
            this._title.addEventListener(MouseEvent.CLICK, this.onToggle);
            this._title.mouseChildren = false;
            this._border = new Shape();
            this._mask = new Sprite();
            this._mask.useHandCursor = false;
            this._mask.mouseEnabled = false;
            this._mask.mouseChildren = false;
            if (alignement == null)
            {
                alignement = Align.none;
            }
            this.alignement = alignement;
            this.stickToEdge = stickToEdge;
            if (backgroundColor == 0)
            {
                backgroundColor = Style.backgroundColor;
            }
            this._backgroundColor = backgroundColor;
            if (borderColor == 0)
            {
                borderColor = Style.borderColor;
            }
            this._borderColor = borderColor;
            return;
        }// end function

        public function addData(child:DisplayObject) : void
        {
            this._data.addChild(child);
            return;
        }// end function

        override protected function layout() : void
        {
            this._update();
            addChild(this._background);
            addChild(this._data);
            addChild(this._title);
            addChild(this._border);
            addChild(this._mask);
            mask = this._mask;
            return;
        }// end function

        override protected function dispose() : void
        {
            this._title.removeEventListener(MouseEvent.CLICK, this.onToggle);
            super.dispose();
            return;
        }// end function

        private function _update() : void
        {
            this._draw();
            if (this.baseAlpha < 1)
            {
                this._background.alpha = this.baseAlpha;
                this._border.alpha = this.baseAlpha;
            }
            return;
        }// end function

        private function _draw() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:uint = 0;
            if (this._savedW)
            {
            }
            if (this._savedH)
            {
                forcedWidth = this._savedW;
                forcedHeight = this._savedH;
            }
            if (!this._colapsed)
            {
                _loc_1 = forcedWidth;
                _loc_2 = forcedHeight;
            }
            else
            {
                _loc_1 = this._title.width;
                _loc_2 = this._title.height;
                this._savedW = forcedWidth;
                this._savedH = forcedHeight;
                forcedWidth = _loc_1;
                forcedHeight = _loc_2;
            }
            var _loc_3:* = this._background.graphics;
            _loc_3.clear();
            _loc_3.beginFill(this._backgroundColor);
            Background.drawRounded(this, _loc_3, _loc_1, _loc_2);
            _loc_3.endFill();
            var _loc_4:* = this._data.graphics;
            _loc_4.clear();
            _loc_4.beginFill(this._backgroundColor, 0);
            Background.drawRounded(this, _loc_4, _loc_1, _loc_2);
            _loc_4.endFill();
            var _loc_5:* = this._border.graphics;
            _loc_5.clear();
            _loc_5.lineStyle(0.1, this._borderColor);
            Background.drawRounded(this, _loc_5, _loc_1, _loc_2);
            _loc_5.endFill();
            var _loc_6:* = this._mask.graphics;
            _loc_6.clear();
            _loc_6.beginFill(this._backgroundColor);
            Background.drawRounded(this, _loc_6, (_loc_1 + 1), (_loc_2 + 1));
            _loc_6.endFill();
            return;
        }// end function

        public function onToggle(event:MouseEvent = null) : void
        {
            if (this._colapsed)
            {
                this._data.visible = true;
            }
            else
            {
                this._data.visible = false;
            }
            this._colapsed = !this._colapsed;
            this._update();
            resize();
            return;
        }// end function

        public function get stickToEdge() : Boolean
        {
            return this._stickToEdge;
        }// end function

        public function set stickToEdge(value:Boolean) : void
        {
            this._stickToEdge = value;
            this._title.stickToEdge = value;
            return;
        }// end function

        public function get title() : String
        {
            return this._title.text;
        }// end function

        public function set title(value:String) : void
        {
            this._title.text = value;
            return;
        }// end function

        public function close() : void
        {
            this.dispose();
            if (parent != null)
            {
                parent.removeChild(this);
            }
            return;
        }// end function

    }
}
