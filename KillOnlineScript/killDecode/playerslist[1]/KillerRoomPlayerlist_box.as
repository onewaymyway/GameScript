package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class KillerRoomPlayerlist_box extends MovieClip
    {
        public var scorll_mc:MovieClip;
        public var count_txt:TextField;
        public var drag_mc:MovieClip;
        public var lists:MovieClip;
        public var close_btn:SimpleButton;
        public var mask_mc:MovieClip;
        public var close2_btn:SimpleButton;
        public var refresh_btn:SimpleButton;

        public function KillerRoomPlayerlist_box()
        {
            __setProp_scorll_mc_KillerRoomPlayerlist_box_scroll_1();
            return;
        }// end function

        function __setProp_scorll_mc_KillerRoomPlayerlist_box_scroll_1()
        {
            try
            {
                scorll_mc["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            scorll_mc.objName = "lists";
            scorll_mc.objmarkName = "mask_mc";
            scorll_mc.ah = 0;
            scorll_mc.delta = 30;
            scorll_mc.toWhere = "top";
            try
            {
                scorll_mc["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
