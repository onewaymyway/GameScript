package btnas
{
    import flash.display.*;
    import flash.text.*;

    public class MenuBtn extends MovieClip
    {
        private var label:String;
        public var label_txt:TextField;

        public function MenuBtn()
        {
            return;
        }// end function

        public function set btn_label(param1:String) : void
        {
            label = param1;
            label_txt.htmlText = label;
            return;
        }// end function

    }
}
