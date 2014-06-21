package killerRoomBtns_fla
{
    import flash.display.*;

    dynamic public class idenPMBtnTxt_23 extends MovieClip
    {

        public function idenPMBtnTxt_23()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            try
            {
                if (KillerRoomData.GameType == 15)
                {
                    gotoAndStop(2);
                }
                else
                {
                    gotoAndStop(3);
                }
            }
            catch (e)
            {
            }
            return;
        }// end function

    }
}
