package alert
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Confirm extends MovieClip
    {
        public var cancel_btn:SimpleButton;
        public var Arr:Object;
        public var ok_btn:SimpleButton;
        private var funcObj:Object;
        private var thisObj:Object;
        public var msg_txt:TextField;

        public function Confirm()
        {
            thisObj = this;
            ok_btn.addEventListener("click", okClick);
            cancel_btn.addEventListener("click", cancelClick);
            return;
        }// end function

        private function okClick(event:Event)
        {
            this.dispatchEvent(new Event("OK"));
            return;
        }// end function

        private function cancelClick(event:Event)
        {
            this.dispatchEvent(new Event("CANCEL"));
            return;
        }// end function

    }
}
