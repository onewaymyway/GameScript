package confirmbox
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class iHonorOnlineChild extends Sprite
    {
        public var vip_log:MovieClip;
        private var timer:Timer;
        private var thisObj:Object;
        public var honor_bg:MovieClip;
        public var honor_txt:TextField;

        public function iHonorOnlineChild()
        {
            thisObj = this;
            timer = new Timer(3000, 1);
            this.alpha = 0;
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
            this.addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        private function timerCompleteHandler(event:TimerEvent) : void
        {
            thisObj.honor_txt.visible = false;
            TweenLite.to(this, 0.5, {alpha:0, onComplete:TweenLiteCompleteHandler});
            return;
        }// end function

        private function init(event:Event) : void
        {
            TweenLite.to(this, 0.5, {alpha:1});
            timer.start();
            return;
        }// end function

        private function TweenLiteCompleteHandler() : void
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            }
            return;
        }// end function

    }
}
