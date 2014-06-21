package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    dynamic public class inter_mc extends MovieClip
    {
        public var int_txt:TextField;
        public var frameI:Object;

        public function inter_mc()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            frameI = 0;
            return;
        }// end function

        public function enterFrameHandler(event:Event)
        {
            var _loc_3:* = frameI + 1;
            frameI = _loc_3;
            if (frameI < 10)
            {
                (int_txt.y - 1);
                int_txt.alpha = int_txt.alpha + 0.1;
            }
            else if (frameI > 24 * 1.2)
            {
                (int_txt.y - 1);
                int_txt.alpha = int_txt.alpha - 0.1;
            }
            else if (int_txt.alpha <= 0)
            {
                this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                this.parent.removeChild(this);
            }
            return;
        }// end function

        public function showInter(param1)
        {
            int_txt.alpha = 0;
            if (param1 > 0)
            {
                int_txt.htmlText = "<font color=\'#99CC00\'>+" + param1 + "</font>";
            }
            else if (param1 < 0)
            {
                int_txt.htmlText = "<font color=\'#FF0000\'>" + param1 + "</font>";
            }
            this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            return;
        }// end function

    }
}
