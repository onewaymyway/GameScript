package com.junkbyte.console.vos
{
    import com.junkbyte.console.core.*;
    import flash.geom.*;
    import flash.utils.*;

    public class GraphGroup extends Object
    {
        public var name:String;
        public var freq:int = 0;
        public var fixedMin:Number;
        public var fixedMax:Number;
        public var inverted:Boolean;
        public var interests:Array;
        public var menus:Array;
        public var numberDisplayPrecision:uint = 4;
        public var alignRight:Boolean;
        public var rect:Rectangle;
        protected var _updateArgs:Array;
        protected var sinceLastUpdate:uint;
        protected var _onUpdate:CcCallbackDispatcher;
        protected var _onClose:CcCallbackDispatcher;
        protected var _onMenu:CcCallbackDispatcher;

        public function GraphGroup(n:String)
        {
            this.interests = [];
            this.menus = [];
            this.rect = new Rectangle(0, 0, 80, 40);
            this._updateArgs = new Array();
            this._onUpdate = new CcCallbackDispatcher();
            this._onClose = new CcCallbackDispatcher();
            this._onMenu = new CcCallbackDispatcher();
            this.name = n;
            return;
        }// end function

        public function tick(timeDelta:uint) : void
        {
            this.sinceLastUpdate = this.sinceLastUpdate + timeDelta;
            if (this.sinceLastUpdate >= this.freq)
            {
                this.update();
            }
            return;
        }// end function

        public function update() : void
        {
            this.sinceLastUpdate = 0;
            this.dispatchUpdates();
            return;
        }// end function

        protected function dispatchUpdates() : void
        {
            var _loc_2:GraphInterest = null;
            var _loc_3:Number = NaN;
            var _loc_1:* = this.interests.length - 1;
            while (_loc_1 >= 0)
            {
                
                _loc_2 = this.interests[_loc_1];
                _loc_3 = _loc_2.getCurrentValue();
                this._updateArgs[_loc_1] = _loc_3;
                _loc_1 = _loc_1 - 1;
            }
            this.applyUpdateDispather(this._updateArgs);
            return;
        }// end function

        function applyUpdateDispather(args:Array) : void
        {
            this._onUpdate.apply(args);
            return;
        }// end function

        public function close() : void
        {
            this._onClose.apply(this);
            this._onUpdate.clear();
            this._onClose.clear();
            this._onMenu.clear();
            return;
        }// end function

        public function get onUpdate() : CcCallbackDispatcher
        {
            return this._onUpdate;
        }// end function

        public function get onClose() : CcCallbackDispatcher
        {
            return this._onClose;
        }// end function

        public function get onMenu() : CcCallbackDispatcher
        {
            return this._onMenu;
        }// end function

        public function writeToBytes(bytes:ByteArray) : void
        {
            var _loc_2:GraphInterest = null;
            var _loc_3:String = null;
            bytes.writeUTF(this.name);
            bytes.writeDouble(this.fixedMin);
            bytes.writeDouble(this.fixedMax);
            bytes.writeBoolean(this.inverted);
            bytes.writeBoolean(this.alignRight);
            bytes.writeFloat(this.rect.x);
            bytes.writeFloat(this.rect.y);
            bytes.writeFloat(this.rect.width);
            bytes.writeFloat(this.rect.height);
            bytes.writeShort(this.numberDisplayPrecision);
            bytes.writeShort(this.interests.length);
            for each (_loc_2 in this.interests)
            {
                
                _loc_2.writeToBytes(bytes);
            }
            bytes.writeShort(this.menus.length);
            for each (_loc_3 in this.menus)
            {
                
                bytes.writeUTF(_loc_3);
            }
            return;
        }// end function

        public static function FromBytes(bytes:ByteArray) : GraphGroup
        {
            var _loc_2:* = new GraphGroup(bytes.readUTF());
            _loc_2.fixedMin = bytes.readDouble();
            _loc_2.fixedMax = bytes.readDouble();
            _loc_2.inverted = bytes.readBoolean();
            _loc_2.alignRight = bytes.readBoolean();
            var _loc_3:* = _loc_2.rect;
            _loc_3.x = bytes.readFloat();
            _loc_3.y = bytes.readFloat();
            _loc_3.width = bytes.readFloat();
            _loc_3.height = bytes.readFloat();
            _loc_2.numberDisplayPrecision = bytes.readShort();
            var _loc_4:* = bytes.readShort();
            while (_loc_4 > 0)
            {
                
                _loc_2.interests.push(GraphInterest.FromBytes(bytes));
                _loc_4 = _loc_4 - 1;
            }
            _loc_4 = bytes.readShort();
            while (_loc_4 > 0)
            {
                
                _loc_2.menus.push(bytes.readUTF());
                _loc_4 = _loc_4 - 1;
            }
            return _loc_2;
        }// end function

    }
}
