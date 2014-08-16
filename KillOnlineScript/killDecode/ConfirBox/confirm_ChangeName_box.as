package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class confirm_ChangeName_box extends Sprite
    {
        public var drag_mc:MovieClip;
        public var chk_btn:SimpleButton;
        public var isdelfas_chickBox:MovieClip;
        public var close_btn:SimpleButton;
        public var close2_btn:SimpleButton;
        public var ok_btn:SimpleButton;
        public var name_txt:TextField;

        public function confirm_ChangeName_box()
        {
            __setProp_isdelfas_chickBox_confirm_ChangeName_box_();
            return;
        }// end function

        function __setProp_isdelfas_chickBox_confirm_ChangeName_box_()
        {
            try
            {
                isdelfas_chickBox["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            isdelfas_chickBox.labeltxt = "清空我的好友（并将我从好友列表中删除）";
            isdelfas_chickBox.chickData = "true";
            isdelfas_chickBox.unchickData = "false";
            isdelfas_chickBox.def = false;
            try
            {
                isdelfas_chickBox["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
