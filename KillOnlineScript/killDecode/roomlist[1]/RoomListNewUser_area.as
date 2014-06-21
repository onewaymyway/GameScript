package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class RoomListNewUser_area extends MovieClip
    {
        public var _bg:MovieClip;
        public var title_txt:TextField;
        public var _list:MovieClip;

        public function RoomListNewUser_area()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            _bg.scale9Grid = new Rectangle(170, 60, 430, 30);
            return;
        }// end function

    }
}
