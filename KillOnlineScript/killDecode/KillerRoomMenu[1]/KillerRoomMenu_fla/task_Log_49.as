package KillerRoomMenu_fla
{
    import flash.display.*;
    import flash.events.*;

    dynamic public class task_Log_49 extends MovieClip
    {
        public var maxt:int;
        public var it:int;

        public function task_Log_49()
        {
            addFrameScript(0, frame1, 44, frame45);
            return;
        }// end function

        function frame1()
        {
            maxt = 250;
            it = 0;
            stop();
            this.visible = false;
            return;
        }// end function

        public function enterFrameHandler(event:Event) : void
        {
            var _loc_3:* = it + 1;
            it = _loc_3;
            if (it >= maxt)
            {
                this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                this.stop();
                this.visible = false;
            }
            return;
        }// end function

        public function showIt(param1:Boolean) : void
        {
            if (param1)
            {
                maxt = 250;
                it = 0;
                this.gotoAndPlay(2);
                this.visible = true;
                this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            }
            else
            {
                this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                this.stop();
                this.visible = false;
            }
            return;
        }// end function

        function frame45()
        {
            gotoAndPlay(2);
            return;
        }// end function

    }
}
