package com.smartfoxserver.v2.util
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.requests.*;
    import flash.events.*;
    import flash.utils.*;

    public class LagMonitor extends EventDispatcher
    {
        private var _lastReqTime:int;
        private var _valueQueue:Array;
        private var _interval:int;
        private var _queueSize:int;
        private var _thread:Timer;
        private var _sfs:SmartFox;

        public function LagMonitor(param1:SmartFox, param2:int = 2, param3:int = 10)
        {
            this._sfs = param1;
            this._valueQueue = [];
            this._interval = param2;
            this._queueSize = param3;
            this._thread = new Timer(param2 * 1000);
            this._thread.addEventListener(TimerEvent.TIMER, this.threadRunner);
            return;
        }// end function

        public function start() : void
        {
            if (this.isRunning)
            {
                return;
            }
            this._thread.start();
            return;
        }// end function

        public function stop() : void
        {
            if (!this.isRunning)
            {
                return;
            }
            this._thread.stop();
            return;
        }// end function

        public function destroy() : void
        {
            this.stop();
            this._thread.removeEventListener(TimerEvent.TIMER, this.threadRunner);
            this._thread = null;
            this._sfs = null;
            return;
        }// end function

        public function get isRunning() : Boolean
        {
            return this._thread.running;
        }// end function

        public function onPingPong() : int
        {
            var _loc_1:* = getTimer() - this._lastReqTime;
            if (this._valueQueue.length >= this._queueSize)
            {
                this._valueQueue.shift();
            }
            this._valueQueue.push(_loc_1);
            return this.averagePingTime;
        }// end function

        public function get lastPingTime() : int
        {
            if (this._valueQueue.length > 0)
            {
                return this._valueQueue[(this._valueQueue.length - 1)];
            }
            return 0;
        }// end function

        public function get averagePingTime() : int
        {
            var _loc_2:int = 0;
            if (this._valueQueue.length == 0)
            {
                return 0;
            }
            var _loc_1:int = 0;
            for each (_loc_2 in this._valueQueue)
            {
                
                _loc_1 = _loc_1 + _loc_2;
            }
            return _loc_1 / this._valueQueue.length;
        }// end function

        private function threadRunner(event:Event) : void
        {
            this._lastReqTime = getTimer();
            this._sfs.send(new PingPongRequest());
            return;
        }// end function

    }
}
