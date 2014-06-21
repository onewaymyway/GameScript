package 
{
    import btnas.*;

    dynamic public class set_menu_btn extends MenuBtn
    {

        public function set_menu_btn()
        {
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4);
            return;
        }// end function

        function frame1()
        {
            stop();
            label_txt.textColor = 6710886;
            return;
        }// end function

        function frame2()
        {
            stop();
            label_txt.textColor = 0;
            return;
        }// end function

        function frame3()
        {
            stop();
            label_txt.textColor = 0;
            return;
        }// end function

        function frame4()
        {
            stop();
            label_txt.textColor = 0;
            return;
        }// end function

    }
}
