package com.google.analytics.debug
{
    import flash.events.*;
    import flash.utils.*;

    public class Info extends Label
    {
        private var _timer:Timer;

        public function Info(text:String = "", timeout:uint = 3000)
        {
            super(text, "uiInfo", Style.infoColor, Align.top, true);
            if (timeout > 0)
            {
                this._timer = new Timer(timeout, 1);
                this._timer.start();
                this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onComplete, false, 0, true);
            }
            return;
        }// end function

        public function close() : void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            }
            return;
        }// end function

        override public function onLink(event:TextEvent) : void
        {
            switch(event.text)
            {
                case "hide":
                {
                    this.close();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onComplete(event:TimerEvent) : void
        {
            this.close();
            return;
        }// end function

    }
}
