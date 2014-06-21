package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;

    public class GraphingPanel extends ConsolePanel
    {
        private var _group:GraphGroup;
        private var _interest:GraphInterest;
        private var _menuString:String;
        protected var _bm:Bitmap;
        protected var _bmd:BitmapData;
        protected var lowestValue:Number;
        protected var highestValue:Number;
        protected var lastValues:Object;
        private var lowTxt:TextField;
        private var highTxt:TextField;
        private var lineRect:Rectangle;

        public function GraphingPanel(m:Console, group:GraphGroup)
        {
            var _loc_3:TextFormat = null;
            this.lastValues = new Object();
            this.lineRect = new Rectangle(0, 0, 1);
            super(m);
            this._group = group;
            name = group.name;
            registerDragger(bg);
            minWidth = 32;
            minHeight = 26;
            _loc_3 = new TextFormat();
            var _loc_4:* = style.styleSheet.getStyle("low");
            _loc_3.font = _loc_4.fontFamily;
            _loc_3.size = _loc_4.fontSize;
            _loc_3.color = style.lowColor;
            this._bm = new Bitmap();
            this._bm.name = "graph";
            this._bm.y = style.menuFontSize - 2;
            addChild(this._bm);
            this.lowTxt = new TextField();
            this.lowTxt.name = "lowestField";
            this.lowTxt.defaultTextFormat = _loc_3;
            this.lowTxt.mouseEnabled = false;
            this.lowTxt.height = style.menuFontSize + 2;
            addChild(this.lowTxt);
            this.highTxt = new TextField();
            this.highTxt.name = "highestField";
            this.highTxt.defaultTextFormat = _loc_3;
            this.highTxt.mouseEnabled = false;
            this.highTxt.height = style.menuFontSize + 2;
            this.highTxt.y = style.menuFontSize - 4;
            addChild(this.highTxt);
            txtField = makeTF("menuField");
            txtField.height = style.menuFontSize + 4;
            txtField.y = -3;
            registerTFRoller(txtField, this.onMenuRollOver, this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
            this.setMenuString();
            this._group.onUpdate.add(this.onGroupUpdate);
            var _loc_5:* = group.rect;
            var _loc_6:* = Math.max(minWidth, _loc_5.width);
            var _loc_7:* = Math.max(minHeight, _loc_5.height);
            var _loc_8:* = console.panels.mainPanel;
            x = _loc_8.x + _loc_5.x;
            y = _loc_8.y + _loc_5.y;
            if (group.alignRight)
            {
                x = _loc_8.x + _loc_8.width - x;
            }
            init(_loc_6, _loc_7, true);
            return;
        }// end function

        public function get group() : GraphGroup
        {
            return this._group;
        }// end function

        public function reset() : void
        {
            var _loc_1:* = NaN;
            this.highestValue = NaN;
            this.lowestValue = _loc_1;
            this.lastValues = new Object();
            return;
        }// end function

        protected function setMenuString() : void
        {
            var _loc_2:String = null;
            this._menuString = "<menu>";
            var _loc_1:* = this._group.menus.concat("R", "X");
            for each (_loc_2 in _loc_1)
            {
                
                this._menuString = this._menuString + (" <a href=\"event:" + _loc_2 + "\">" + _loc_2 + "</a>");
            }
            this._menuString = this._menuString + "</menu></low></r>";
            return;
        }// end function

        override public function set height(n:Number) : void
        {
            super.height = n;
            this.lowTxt.y = n - style.menuFontSize;
            this.resizeBMD();
            return;
        }// end function

        override public function set width(n:Number) : void
        {
            super.width = n;
            this.lowTxt.width = n;
            this.highTxt.width = n;
            txtField.width = n;
            txtField.scrollH = txtField.maxScrollH;
            this.resizeBMD();
            return;
        }// end function

        private function resizeBMD() : void
        {
            var _loc_4:Matrix = null;
            var _loc_1:* = width;
            var _loc_2:* = height - style.menuFontSize + 2;
            if (this._bmd != null)
            {
            }
            if (this._bmd.width == _loc_1)
            {
            }
            if (this._bmd.height == _loc_2)
            {
                return;
            }
            var _loc_3:* = this._bmd;
            this._bmd = new BitmapData(_loc_1, _loc_2, true, 0);
            if (_loc_3 != null)
            {
                _loc_4 = new Matrix(1, 0, 0, this._bmd.height / _loc_3.height);
                _loc_4.tx = this._bmd.width - _loc_3.width;
                this._bmd.draw(_loc_3, _loc_4, null, null, null, true);
                _loc_3.dispose();
            }
            this._bm.bitmapData = this._bmd;
            return;
        }// end function

        protected function onGroupUpdate(values:Array) : void
        {
            var _loc_4:GraphInterest = null;
            var _loc_9:Number = NaN;
            var _loc_2:* = this._group.interests;
            var _loc_3:Boolean = false;
            var _loc_5:* = isNaN(this._group.fixedMin) ? (this.lowestValue) : (this._group.fixedMin);
            var _loc_6:* = isNaN(this._group.fixedMax) ? (this.highestValue) : (this._group.fixedMax);
            var _loc_7:* = _loc_2.length;
            var _loc_8:uint = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_4 = _loc_2[_loc_8];
                _loc_9 = values[_loc_8];
                if (isNaN(this._group.fixedMin))
                {
                    isNaN(this._group.fixedMin);
                    if (!isNaN(_loc_5))
                    {
                        isNaN(_loc_5);
                    }
                }
                if (_loc_9 < _loc_5)
                {
                    _loc_5 = _loc_9;
                }
                if (isNaN(this._group.fixedMax))
                {
                    isNaN(this._group.fixedMax);
                    if (!isNaN(_loc_6))
                    {
                        isNaN(_loc_6);
                    }
                }
                if (_loc_9 > _loc_6)
                {
                    _loc_6 = _loc_9;
                }
                _loc_8 = _loc_8 + 1;
            }
            this.updateKeyText(values);
            if (this.lowestValue == _loc_5)
            {
            }
            if (this.highestValue != _loc_6)
            {
                this.scaleBitmapData(_loc_5, _loc_6);
                if (this.group.inverted)
                {
                    this.highTxt.text = this.makeValueString(_loc_5);
                    this.lowTxt.text = this.makeValueString(_loc_6);
                }
                else
                {
                    this.lowTxt.text = this.makeValueString(_loc_5);
                    this.highTxt.text = this.makeValueString(_loc_6);
                }
            }
            this.pushBMD(values);
            return;
        }// end function

        protected function pushBMD(values:Array) : void
        {
            var _loc_7:GraphInterest = null;
            var _loc_8:Number = NaN;
            var _loc_9:int = 0;
            var _loc_10:Number = NaN;
            var _loc_11:uint = 0;
            var _loc_12:int = 0;
            var _loc_13:Number = NaN;
            var _loc_2:* = this.highestValue - this.lowestValue;
            var _loc_3:* = this._bmd.width - 1;
            var _loc_4:* = this._bmd.height;
            this._bmd.lock();
            this._bmd.scroll(-1, 0);
            this._bmd.fillRect(new Rectangle(_loc_3, 0, 1, this._bmd.height), 0);
            var _loc_5:* = this._group.interests;
            var _loc_6:* = _loc_5.length - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_7 = _loc_5[_loc_6];
                _loc_8 = values[_loc_6];
                _loc_9 = this.getPixelValue(_loc_8);
                _loc_10 = this.lastValues[_loc_6];
                _loc_11 = _loc_7.col + 4278190080;
                if (isNaN(_loc_10) == false)
                {
                    this.lineRect.x = _loc_3;
                    _loc_12 = this.getPixelValue(_loc_10);
                    if (_loc_9 < _loc_12)
                    {
                        _loc_13 = (_loc_12 - _loc_9) * 0.5;
                        this.lineRect.y = _loc_9;
                        this.lineRect.height = _loc_13;
                        this._bmd.fillRect(this.lineRect, _loc_11);
                        var _loc_14:* = this.lineRect;
                        var _loc_15:* = this.lineRect.x - 1;
                        _loc_14.x = _loc_15;
                        this.lineRect.y = _loc_9 + _loc_13;
                        this._bmd.fillRect(this.lineRect, _loc_11);
                    }
                    else
                    {
                    }
                    _loc_13 = (_loc_9 - _loc_12) * 0.5;
                    this.lineRect.y = _loc_12 + _loc_13;
                    this.lineRect.height = _loc_13;
                    this._bmd.fillRect(this.lineRect, _loc_11);
                    var _loc_14:* = this.lineRect;
                    var _loc_15:* = this.lineRect.x - 1;
                    _loc_14.x = _loc_15;
                    this.lineRect.y = _loc_12;
                    this._bmd.fillRect(this.lineRect, _loc_11);
                }
                this._bmd.setPixel32(_loc_3, _loc_9, _loc_11);
                this.lastValues[_loc_6] = _loc_8;
                _loc_6 = _loc_6 - 1;
            }
            this._bmd.unlock();
            return;
        }// end function

        protected function getPixelValue(value:Number) : Number
        {
            if (this.highestValue == this.lowestValue)
            {
                return this._bmd.height * 0.5;
            }
            value = (value - this.lowestValue) / (this.highestValue - this.lowestValue) * this._bmd.height;
            if (!this._group.inverted)
            {
                value = this._bmd.height - value;
            }
            if (value < 0)
            {
                value = 0;
            }
            if (value >= this._bmd.height)
            {
                value = this._bmd.height - 1;
            }
            return value;
        }// end function

        protected function scaleBitmapData(newLow:Number, newHigh:Number) : void
        {
            var _loc_3:* = this._bmd.clone();
            this._bmd.fillRect(this._bmd.rect, 0);
            var _loc_4:* = newHigh - newLow;
            if (_loc_4 == 0)
            {
                this.lowestValue = newLow;
                this.highestValue = newHigh;
                return;
            }
            var _loc_5:* = _loc_4 / this._bmd.height;
            var _loc_6:* = _loc_5 * 0.5;
            newHigh = newHigh + _loc_5;
            newLow = newLow - _loc_5;
            if (!isNaN(this._group.fixedMax))
            {
            }
            if (newHigh > this._group.fixedMax)
            {
                newHigh = this._group.fixedMax;
            }
            if (!isNaN(this._group.fixedMin))
            {
            }
            if (newLow < this._group.fixedMin)
            {
                newLow = this._group.fixedMin;
            }
            _loc_4 = newHigh - newLow;
            var _loc_7:* = this.highestValue - this.lowestValue;
            var _loc_8:* = new Matrix();
            if (this._group.inverted)
            {
                _loc_8.ty = (this.lowestValue - newLow) / _loc_7 * this._bmd.height;
            }
            else
            {
                _loc_8.ty = (newHigh - this.highestValue) / _loc_7 * this._bmd.height;
            }
            _loc_8.scale(1, _loc_7 / _loc_4);
            this._bmd.draw(_loc_3, _loc_8, null, null, null, true);
            _loc_3.dispose();
            this.lowestValue = newLow;
            this.highestValue = newHigh;
            return;
        }// end function

        public function updateKeyText(values:Array) : void
        {
            var _loc_5:GraphInterest = null;
            var _loc_2:String = "<r><low>";
            var _loc_3:* = this._group.interests.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = this._group.interests[_loc_4];
                _loc_2 = _loc_2 + ("<font color=\'#" + _loc_5.col.toString(16) + "\'>" + this.makeValueString(values[_loc_4]) + _loc_5.key + "</font> ");
                _loc_4 = _loc_4 + 1;
            }
            txtField.htmlText = _loc_2 + this._menuString;
            txtField.scrollH = txtField.maxScrollH;
            return;
        }// end function

        private function makeValueString(value:Number) : String
        {
            var _loc_2:* = this._group.numberDisplayPrecision;
            if (_loc_2 != 0)
            {
            }
            if (value == 0)
            {
                return String(value);
            }
            return value.toPrecision(_loc_2);
        }// end function

        protected function linkHandler(event:TextEvent) : void
        {
            TextField(event.currentTarget).setSelection(0, 0);
            if (event.text == "R")
            {
                this.reset();
            }
            else if (event.text == "X")
            {
                this._group.close();
            }
            this._group.onMenu.apply(event.text);
            event.stopPropagation();
            return;
        }// end function

        protected function onMenuRollOver(event:TextEvent) : void
        {
            var _loc_2:* = event.text ? (event.text.replace("event:", "")) : (null);
            if (_loc_2 == "G")
            {
                _loc_2 = "Garbage collect::Requires debugger version of flash player";
            }
            else
            {
                _loc_2 = null;
            }
            console.panels.tooltip(_loc_2, this);
            return;
        }// end function

    }
}
