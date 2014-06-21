package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class ConsolePanel extends Sprite
    {
        private var _snaps:Array;
        private var _dragOffset:Point;
        private var _resizeTxt:TextField;
        protected var console:Console;
        protected var bg:Sprite;
        protected var scaler:Sprite;
        protected var txtField:TextField;
        protected var minWidth:int = 18;
        protected var minHeight:int = 18;
        private var _movedFrom:Point;
        public var moveable:Boolean = true;
        public static const DRAGGING_STARTED:String = "draggingStarted";
        public static const DRAGGING_ENDED:String = "draggingEnded";
        public static const SCALING_STARTED:String = "scalingStarted";
        public static const SCALING_ENDED:String = "scalingEnded";
        public static const VISIBLITY_CHANGED:String = "visibilityChanged";
        private static const TEXT_ROLL:String = "TEXT_ROLL";

        public function ConsolePanel(m:Console)
        {
            this.console = m;
            this.bg = new Sprite();
            this.bg.name = "background";
            addChild(this.bg);
            return;
        }// end function

        protected function get config() : ConsoleConfig
        {
            return this.console.config;
        }// end function

        protected function get style() : ConsoleStyle
        {
            return this.console.config.style;
        }// end function

        protected function init(w:Number, h:Number, resizable:Boolean = false, col:Number = -1, a:Number = -1, rounding:int = -1) : void
        {
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(col >= 0 ? (col) : (this.style.backgroundColor), a >= 0 ? (a) : (this.style.backgroundAlpha));
            if (rounding < 0)
            {
                rounding = this.style.roundBorder;
            }
            if (rounding <= 0)
            {
                this.bg.graphics.drawRect(0, 0, 100, 100);
            }
            else
            {
                this.bg.graphics.drawRoundRect(0, 0, rounding + 10, rounding + 10, rounding, rounding);
                this.bg.scale9Grid = new Rectangle(rounding * 0.5, rounding * 0.5, 10, 10);
            }
            this.scalable = resizable;
            this.width = w;
            this.height = h;
            return;
        }// end function

        public function close() : void
        {
            this.stopDragging();
            this.console.panels.tooltip();
            if (parent)
            {
                parent.removeChild(this);
            }
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }// end function

        override public function set visible(b:Boolean) : void
        {
            super.visible = b;
            dispatchEvent(new Event(VISIBLITY_CHANGED));
            return;
        }// end function

        override public function set width(n:Number) : void
        {
            if (n < this.minWidth)
            {
                n = this.minWidth;
            }
            if (this.scaler)
            {
                this.scaler.x = n;
            }
            this.bg.width = n;
            return;
        }// end function

        override public function set height(n:Number) : void
        {
            if (n < this.minHeight)
            {
                n = this.minHeight;
            }
            if (this.scaler)
            {
                this.scaler.y = n;
            }
            this.bg.height = n;
            return;
        }// end function

        override public function get width() : Number
        {
            return this.bg.width;
        }// end function

        override public function get height() : Number
        {
            return this.bg.height;
        }// end function

        public function registerSnaps(X:Array, Y:Array) : void
        {
            this._snaps = [X, Y];
            return;
        }// end function

        protected function registerDragger(mc:DisplayObject, dereg:Boolean = false) : void
        {
            if (dereg)
            {
                mc.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDraggerMouseDown);
            }
            else
            {
                mc.addEventListener(MouseEvent.MOUSE_DOWN, this.onDraggerMouseDown, false, 0, true);
            }
            return;
        }// end function

        private function onDraggerMouseDown(event:MouseEvent) : void
        {
            if (stage)
            {
            }
            if (!this.moveable)
            {
                return;
            }
            this._resizeTxt = this.makeTF("positioningField", true);
            this._resizeTxt.mouseEnabled = false;
            this._resizeTxt.autoSize = TextFieldAutoSize.LEFT;
            addChild(this._resizeTxt);
            this.updateDragText();
            this._movedFrom = new Point(x, y);
            this._dragOffset = new Point(mouseX, mouseY);
            this._snaps = [[], []];
            dispatchEvent(new Event(DRAGGING_STARTED));
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onDraggerMouseUp, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onDraggerMouseMove, false, 0, true);
            return;
        }// end function

        private function onDraggerMouseMove(event:MouseEvent = null) : void
        {
            if (this.style.panelSnapping == 0)
            {
                return;
            }
            var _loc_2:* = this.returnSnappedFor(parent.mouseX - this._dragOffset.x, parent.mouseY - this._dragOffset.y);
            x = _loc_2.x;
            y = _loc_2.y;
            this.updateDragText();
            return;
        }// end function

        private function updateDragText() : void
        {
            this._resizeTxt.text = "<low>" + x + "," + y + "</low>";
            return;
        }// end function

        private function onDraggerMouseUp(event:MouseEvent) : void
        {
            this.stopDragging();
            return;
        }// end function

        private function stopDragging() : void
        {
            this._snaps = null;
            if (stage)
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, this.onDraggerMouseUp);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onDraggerMouseMove);
            }
            if (this._resizeTxt)
            {
            }
            if (this._resizeTxt.parent)
            {
                this._resizeTxt.parent.removeChild(this._resizeTxt);
            }
            this._resizeTxt = null;
            dispatchEvent(new Event(DRAGGING_ENDED));
            return;
        }// end function

        public function moveBackSafePosition() : void
        {
            if (this._movedFrom != null)
            {
                if (x + this.width >= 10)
                {
                    if (stage)
                    {
                    }
                }
                if (stage.stageWidth >= x + 10)
                {
                }
                if (y + this.height >= 10)
                {
                    if (stage)
                    {
                    }
                }
                if (stage.stageHeight < y + 20)
                {
                    x = this._movedFrom.x;
                    y = this._movedFrom.y;
                }
                this._movedFrom = null;
            }
            return;
        }// end function

        public function get scalable() : Boolean
        {
            return this.scaler ? (true) : (false);
        }// end function

        public function set scalable(b:Boolean) : void
        {
            var _loc_2:uint = 0;
            if (b)
            {
            }
            if (!this.scaler)
            {
                _loc_2 = 8 + this.style.controlSize * 0.5;
                this.scaler = new Sprite();
                this.scaler.name = "scaler";
                this.scaler.graphics.beginFill(0, 0);
                this.scaler.graphics.drawRect((-_loc_2) * 1.5, (-_loc_2) * 1.5, _loc_2 * 1.5, _loc_2 * 1.5);
                this.scaler.graphics.endFill();
                this.scaler.graphics.beginFill(this.style.controlColor, this.style.backgroundAlpha);
                this.scaler.graphics.moveTo(0, 0);
                this.scaler.graphics.lineTo(-_loc_2, 0);
                this.scaler.graphics.lineTo(0, -_loc_2);
                this.scaler.graphics.endFill();
                this.scaler.buttonMode = true;
                this.scaler.doubleClickEnabled = true;
                this.scaler.addEventListener(MouseEvent.MOUSE_DOWN, this.onScalerMouseDown, false, 0, true);
                addChildAt(this.scaler, (getChildIndex(this.bg) + 1));
            }
            else
            {
                if (!b)
                {
                }
                if (this.scaler)
                {
                    if (contains(this.scaler))
                    {
                        removeChild(this.scaler);
                    }
                    this.scaler = null;
                }
            }
            return;
        }// end function

        private function onScalerMouseDown(event:Event) : void
        {
            this._resizeTxt = this.makeTF("resizingField", true);
            this._resizeTxt.mouseEnabled = false;
            this._resizeTxt.autoSize = TextFieldAutoSize.RIGHT;
            this._resizeTxt.x = -4;
            this._resizeTxt.y = -17;
            this.scaler.addChild(this._resizeTxt);
            this.updateScaleText();
            this._dragOffset = new Point(this.scaler.mouseX, this.scaler.mouseY);
            this._snaps = [[], []];
            this.scaler.stage.addEventListener(MouseEvent.MOUSE_UP, this.onScalerMouseUp, false, 0, true);
            this.scaler.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.updateScale, false, 0, true);
            dispatchEvent(new Event(SCALING_STARTED));
            return;
        }// end function

        private function updateScale(event:Event = null) : void
        {
            var _loc_2:* = this.returnSnappedFor(x + mouseX - this._dragOffset.x, y + mouseY - this._dragOffset.x);
            _loc_2.x = _loc_2.x - x;
            _loc_2.y = _loc_2.y - y;
            this.width = _loc_2.x < this.minWidth ? (this.minWidth) : (_loc_2.x);
            this.height = _loc_2.y < this.minHeight ? (this.minHeight) : (_loc_2.y);
            this.updateScaleText();
            return;
        }// end function

        private function updateScaleText() : void
        {
            this._resizeTxt.text = "<low>" + this.width + "," + this.height + "</low>";
            return;
        }// end function

        public function stopScaling() : void
        {
            this.onScalerMouseUp(null);
            return;
        }// end function

        private function onScalerMouseUp(event:Event) : void
        {
            this.scaler.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onScalerMouseUp);
            this.scaler.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateScale);
            this.updateScale();
            this._snaps = null;
            if (this._resizeTxt)
            {
            }
            if (this._resizeTxt.parent)
            {
                this._resizeTxt.parent.removeChild(this._resizeTxt);
            }
            this._resizeTxt = null;
            dispatchEvent(new Event(SCALING_ENDED));
            return;
        }// end function

        public function makeTF(n:String, back:Boolean = false) : TextField
        {
            var _loc_3:* = new TextField();
            _loc_3.name = n;
            _loc_3.styleSheet = this.style.styleSheet;
            if (back)
            {
                _loc_3.background = true;
                _loc_3.backgroundColor = this.style.backgroundColor;
            }
            return _loc_3;
        }// end function

        private function returnSnappedFor(X:Number, Y:Number) : Point
        {
            return new Point(this.getSnapOf(X, true), this.getSnapOf(Y, false));
        }// end function

        private function getSnapOf(v:Number, isX:Boolean) : Number
        {
            var _loc_6:Number = NaN;
            var _loc_3:* = v + this.width;
            var _loc_4:* = this._snaps[isX ? (0) : (1)];
            var _loc_5:* = this.style.panelSnapping;
            for each (_loc_6 in _loc_4)
            {
                
                if (Math.abs(_loc_6 - v) < _loc_5)
                {
                    return _loc_6;
                }
                if (Math.abs(_loc_6 - _loc_3) < _loc_5)
                {
                    return _loc_6 - this.width;
                }
            }
            return v;
        }// end function

        protected function registerTFRoller(field:TextField, overhandle:Function, linkHandler:Function = null) : void
        {
            field.addEventListener(MouseEvent.MOUSE_MOVE, onTextFieldMouseMove, false, 0, true);
            field.addEventListener(MouseEvent.ROLL_OUT, onTextFieldMouseOut, false, 0, true);
            field.addEventListener(TEXT_ROLL, overhandle, false, 0, true);
            if (linkHandler != null)
            {
                field.addEventListener(TextEvent.LINK, linkHandler, false, 0, true);
            }
            return;
        }// end function

        private static function onTextFieldMouseOut(event:MouseEvent) : void
        {
            TextField(event.currentTarget).dispatchEvent(new TextEvent(TEXT_ROLL));
            return;
        }// end function

        private static function onTextFieldMouseMove(event:MouseEvent) : void
        {
            var index:int;
            var scrollH:Number;
            var w:Number;
            var X:XML;
            var txtformat:XML;
            var e:* = event;
            var field:* = e.currentTarget as TextField;
            if (field.scrollH > 0)
            {
                scrollH = field.scrollH;
                w = field.width;
                field.width = w + scrollH;
                index = field.getCharIndexAtPoint(field.mouseX + scrollH, field.mouseY);
                field.width = w;
                field.scrollH = scrollH;
            }
            else
            {
                index = field.getCharIndexAtPoint(field.mouseX, field.mouseY);
            }
            var url:String;
            if (index > 0)
            {
                try
                {
                    X = new XML(field.getXMLText(index, (index + 1)));
                    if (X.hasOwnProperty("textformat"))
                    {
                        txtformat = X["textformat"][0] as XML;
                        if (txtformat)
                        {
                            url = txtformat.@url;
                        }
                    }
                }
                catch (err:Error)
                {
                    url;
                }
            }
            field.dispatchEvent(new TextEvent(TEXT_ROLL, false, false, url));
            return;
        }// end function

    }
}
