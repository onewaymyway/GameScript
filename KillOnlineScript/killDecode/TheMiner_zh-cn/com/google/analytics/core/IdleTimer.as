package com.google.analytics.core
{
    import com.google.analytics.debug.*;
    import com.google.analytics.v4.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class IdleTimer extends Object
    {
        private var _loop:Timer;
        private var _session:Timer;
        private var _debug:DebugConfiguration;
        private var _stage:Stage;
        private var _buffer:Buffer;
        private var _lastMove:int;
        private var _inactivity:Number;

        public function IdleTimer(config:Configuration, debug:DebugConfiguration, display:DisplayObject, buffer:Buffer)
        {
            var _loc_5:* = config.idleLoop;
            var _loc_6:* = config.idleTimeout;
            var _loc_7:* = config.sessionTimeout;
            this._loop = new Timer(_loc_5 * 1000);
            this._session = new Timer(_loc_7 * 1000, 1);
            this._debug = debug;
            this._stage = display.stage;
            this._buffer = buffer;
            this._lastMove = getTimer();
            this._inactivity = _loc_6 * 1000;
            this._debug.info("delay: " + _loc_5 + "sec , inactivity: " + _loc_6 + "sec, sessionTimeout: " + _loc_7, VisualDebugMode.geek);
            this._loop.start();
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            this._lastMove = getTimer();
            if (this._session.running)
            {
                this._debug.info("session timer reset", VisualDebugMode.geek);
                this._session.reset();
            }
            return;
        }// end function

        public function checkForIdle(event:TimerEvent) : void
        {
            var _loc_2:* = getTimer();
            if (_loc_2 - this._lastMove >= this._inactivity)
            {
                if (!this._session.running)
                {
                    this._debug.info("session timer start", VisualDebugMode.geek);
                    this._session.start();
                }
            }
            return;
        }// end function

        public function endSession(event:TimerEvent) : void
        {
            this._session.removeEventListener(TimerEvent.TIMER_COMPLETE, this.endSession);
            this._debug.info("session timer end session", VisualDebugMode.geek);
            this._session.reset();
            this._buffer.resetCurrentSession();
            this._debug.info(this._buffer.utmb.toString(), VisualDebugMode.geek);
            this._debug.info(this._buffer.utmc.toString(), VisualDebugMode.geek);
            this._session.addEventListener(TimerEvent.TIMER_COMPLETE, this.endSession);
            return;
        }// end function

    }
}
