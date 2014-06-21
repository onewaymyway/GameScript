package com.junkbyte.console.vos
{
    import com.junkbyte.console.*;

    public class GraphFPSGroup extends GraphGroup
    {
        public var maxLag:uint = 60;
        private var _console:Console;
        private var _historyLength:uint;
        private var _history:Array;
        private var _historyIndex:uint;
        private var _historyTotal:Number = 0;
        public static const NAME:String = "consoleFPSGraph";

        public function GraphFPSGroup(console:Console, historyLength:uint = 5)
        {
            this._history = new Array();
            this._console = console;
            this._historyLength = historyLength;
            super(NAME);
            var _loc_3:uint = 0;
            while (_loc_3 < historyLength)
            {
                
                this._history.push(0);
                _loc_3 = _loc_3 + 1;
            }
            rect.x = 170;
            rect.y = 15;
            alignRight = true;
            var _loc_4:* = new GraphInterest("fps");
            _loc_4.col = 16724787;
            interests.push(_loc_4);
            _updateArgs.length = 1;
            freq = 200;
            fixedMin = 0;
            numberDisplayPrecision = 2;
            return;
        }// end function

        override public function tick(timeDelta:uint) : void
        {
            var _loc_3:uint = 0;
            if (timeDelta == 0)
            {
                return;
            }
            var _loc_2:* = 1000 / timeDelta;
            if (this._console.stage)
            {
                fixedMax = this._console.stage.frameRate;
                _loc_3 = fixedMax / _loc_2 / this._historyLength;
                if (_loc_3 > this.maxLag)
                {
                    _loc_3 = this.maxLag;
                }
            }
            if (_loc_3 == 0)
            {
                _loc_3 = 1;
            }
            while (_loc_3 > 0)
            {
                
                this.dispatchFPS(_loc_2);
                _loc_3 = _loc_3 - 1;
            }
            return;
        }// end function

        private function dispatchFPS(fps:Number) : void
        {
            this._historyTotal = this._historyTotal - this._history[this._historyIndex];
            this._historyTotal = this._historyTotal + fps;
            this._history[this._historyIndex] = fps;
            var _loc_2:String = this;
            var _loc_3:* = this._historyIndex + 1;
            _loc_2._historyIndex = _loc_3;
            if (this._historyIndex >= this._historyLength)
            {
                this._historyIndex = 0;
            }
            fps = this._historyTotal / this._historyLength;
            if (fps > fixedMax)
            {
                fps = fixedMax;
            }
            _updateArgs[0] = Math.round(fps);
            applyUpdateDispather(_updateArgs);
            return;
        }// end function

    }
}
