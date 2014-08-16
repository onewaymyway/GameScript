package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class confirm_delFriend_box extends MovieClip
    {
        public var drag_mc:MovieClip;
        public var title_txt:TextField;
        public var isBoth_cb:MovieClip;
        public var close_btn:SimpleButton;
        public var cancel_btn:SimpleButton;
        public var msg_txt:TextField;
        public var confirm_btn:SimpleButton;

        public function confirm_delFriend_box()
        {
            __setProp_isBoth_cb_confirm_delFriend_box_();
            return;
        }// end function

        function __setProp_isBoth_cb_confirm_delFriend_box_()
        {
            try
            {
                isBoth_cb["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            isBoth_cb.labeltxt = "将我从他的列表中删除";
            isBoth_cb.chickData = "true";
            isBoth_cb.unchickData = "false";
            isBoth_cb.def = false;
            try
            {
                isBoth_cb["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
