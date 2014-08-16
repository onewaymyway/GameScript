package uas
{
    import flash.net.*;

    public class OpenWin extends Object
    {

        public function OpenWin()
        {
            return;
        }// end function

        public static function open(url:String) : void
        {
            navigateToURL(new URLRequest(url), "_blank");
            return;
        }// end function

    }
}
