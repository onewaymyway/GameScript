package uas
{
    import flash.net.*;

    public class OpenWin extends Object
    {

        public function OpenWin()
        {
            return;
        }// end function

        public static function open(param1:String) : void
        {
            navigateToURL(new URLRequest(param1), "_blank");
            return;
        }// end function

    }
}
