package controller
{
    import Core.*;
    import flash.events.*;
    import flash.utils.*;

    public class KillerRoomSeriesToolActController extends Object
    {
        private var facade:Object;
        private var _cmd:Object;
        private var actTimer:Timer;
        private var toolI:uint;

        public function KillerRoomSeriesToolActController()
        {
            this.facade = MyFacade.getInstance();
            return;
        }// end function

        public function start(param1:Object)
        {
            this.stop();
            this._cmd = param1;
            this.toolI = 0;
            var _loc_2:* = uint(param1.Num) - 1;
            if (_loc_2 > 0)
            {
                this.actTimer = new Timer(600, _loc_2);
                this.actTimer.addEventListener(TimerEvent.TIMER, this.timerHandler);
                this.actTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.completeHandler);
                this.actTimer.start();
            }
            var _loc_3:String = this;
            var _loc_4:* = this.toolI + 1;
            _loc_3.toolI = _loc_4;
            this._cmd.Num = String(this.toolI);
            this.facade.sendNotification(GameEvents.NETCALL, this._cmd);
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            if (this._cmd)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.toolI + 1;
                _loc_2.toolI = _loc_3;
                this._cmd.Num = String(this.toolI);
                this.facade.sendNotification(GameEvents.NETCALL, this._cmd);
            }
            else
            {
                this.stop();
            }
            return;
        }// end function

        private function completeHandler(event:TimerEvent) : void
        {
            this.stop();
            return;
        }// end function

        public function stop() : void
        {
            if (this.actTimer && this.actTimer.hasEventListener(TimerEvent.TIMER))
            {
                this.actTimer.stop();
                this.actTimer.removeEventListener(TimerEvent.TIMER, this.timerHandler);
                this.actTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.completeHandler);
                this.actTimer = null;
                this._cmd = null;
            }
            return;
        }// end function

        public function chickHaveStop(param1:uint) : void
        {
            if (this._cmd != null && param1 == uint(this._cmd.UserId))
            {
                this.stop();
            }
            return;
        }// end function

    }
}
