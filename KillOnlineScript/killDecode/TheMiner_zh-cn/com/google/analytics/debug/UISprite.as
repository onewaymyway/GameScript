package com.google.analytics.debug
{
    import flash.display.*;
    import flash.events.*;

    public class UISprite extends Sprite
    {
        private var _forcedWidth:uint;
        private var _forcedHeight:uint;
        protected var alignTarget:DisplayObject;
        protected var listenResize:Boolean;
        public var alignement:Align;
        public var margin:Margin;

        public function UISprite(alignTarget:DisplayObject = null)
        {
            this.listenResize = false;
            this.alignement = Align.none;
            this.alignTarget = alignTarget;
            this.margin = new Margin();
            addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this._onRemovedFromStage);
            return;
        }// end function

        private function _onAddedToStage(event:Event) : void
        {
            this.layout();
            this.resize();
            return;
        }// end function

        private function _onRemovedFromStage(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, this._onRemovedFromStage);
            this.dispose();
            return;
        }// end function

        protected function layout() : void
        {
            return;
        }// end function

        protected function dispose() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:int = 0;
            while (_loc_2 < numChildren)
            {
                
                _loc_1 = getChildAt(_loc_2);
                if (_loc_1)
                {
                    removeChild(_loc_1);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        protected function onResize(event:Event) : void
        {
            this.resize();
            return;
        }// end function

        public function get forcedWidth() : uint
        {
            if (this._forcedWidth)
            {
                return this._forcedWidth;
            }
            return width;
        }// end function

        public function set forcedWidth(value:uint) : void
        {
            this._forcedWidth = value;
            return;
        }// end function

        public function get forcedHeight() : uint
        {
            if (this._forcedHeight)
            {
                return this._forcedHeight;
            }
            return height;
        }// end function

        public function set forcedHeight(value:uint) : void
        {
            this._forcedHeight = value;
            return;
        }// end function

        public function alignTo(alignement:Align, target:DisplayObject = null) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:UISprite = null;
            if (target == null)
            {
                if (parent is Stage)
                {
                    target = this.stage;
                }
                else
                {
                    target = parent;
                }
            }
            if (target == this.stage)
            {
                if (this.stage == null)
                {
                    return;
                }
                _loc_3 = this.stage.stageHeight;
                _loc_4 = this.stage.stageWidth;
                _loc_5 = 0;
                _loc_6 = 0;
            }
            else
            {
                _loc_7 = target as UISprite;
                if (_loc_7.forcedHeight)
                {
                    _loc_3 = _loc_7.forcedHeight;
                }
                else
                {
                    _loc_3 = _loc_7.height;
                }
                if (_loc_7.forcedWidth)
                {
                    _loc_4 = _loc_7.forcedWidth;
                }
                else
                {
                    _loc_4 = _loc_7.width;
                }
                _loc_5 = 0;
                _loc_6 = 0;
            }
            switch(alignement)
            {
                case Align.top:
                {
                    x = _loc_4 / 2 - this.forcedWidth / 2;
                    y = _loc_6 + this.margin.top;
                    break;
                }
                case Align.bottom:
                {
                    x = _loc_4 / 2 - this.forcedWidth / 2;
                    y = _loc_6 + _loc_3 - this.forcedHeight - this.margin.bottom;
                    break;
                }
                case Align.left:
                {
                    x = _loc_5 + this.margin.left;
                    y = _loc_3 / 2 - this.forcedHeight / 2;
                    break;
                }
                case Align.right:
                {
                    x = _loc_5 + _loc_4 - this.forcedWidth - this.margin.right;
                    y = _loc_3 / 2 - this.forcedHeight / 2;
                    break;
                }
                case Align.center:
                {
                    x = _loc_4 / 2 - this.forcedWidth / 2;
                    y = _loc_3 / 2 - this.forcedHeight / 2;
                    break;
                }
                case Align.topLeft:
                {
                    x = _loc_5 + this.margin.left;
                    y = _loc_6 + this.margin.top;
                    break;
                }
                case Align.topRight:
                {
                    x = _loc_5 + _loc_4 - this.forcedWidth - this.margin.right;
                    y = _loc_6 + this.margin.top;
                    break;
                }
                case Align.bottomLeft:
                {
                    x = _loc_5 + this.margin.left;
                    y = _loc_6 + _loc_3 - this.forcedHeight - this.margin.bottom;
                    break;
                }
                case Align.bottomRight:
                {
                    x = _loc_5 + _loc_4 - this.forcedWidth - this.margin.right;
                    y = _loc_6 + _loc_3 - this.forcedHeight - this.margin.bottom;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (!this.listenResize)
            {
            }
            if (alignement != Align.none)
            {
                target.addEventListener(Event.RESIZE, this.onResize, false, 0, true);
                this.listenResize = true;
            }
            this.alignement = alignement;
            this.alignTarget = target;
            return;
        }// end function

        public function resize() : void
        {
            if (this.alignement != Align.none)
            {
                this.alignTo(this.alignement, this.alignTarget);
            }
            return;
        }// end function

    }
}
