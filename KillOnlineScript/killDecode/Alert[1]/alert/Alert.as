package alert
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Alert extends MovieClip
    {
        public var Arr:Object;
        public var ok_btn:SimpleButton;
        private var thisObj:Object;
        public var msg_txt:TextField;

        public function Alert()
        {
            thisObj = this;
            ok_btn.addEventListener("click", okClick);
            return;
        }// end function

        private function okClick(event:Event) : void
        {
            this.dispatchEvent(new Event("OK"));
            return;
        }// end function

    }
}
