package 
{
    import hall.*;

    dynamic public class menu_g_btn extends MenuBtn
    {

        public function menu_g_btn()
        {
            addFrameScript(0, frame1, 1, frame2, 2, frame3, 3, frame4);
            return;
        }// end function

        function frame1()
        {
            label_txt.textColor = 0;
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            label_txt.textColor = 16777215;
            return;
        }// end function

        function frame3()
        {
            stop();
            label_txt.textColor = 16777215;
            return;
        }// end function

        function frame4()
        {
            stop();
            return;
        }// end function

    }
}
