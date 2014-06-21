package friend_list_mc_fla
{
    import flash.display.*;

    dynamic public class setFrame_13 extends MovieClip
    {
        public var set1_btn:set_menu_btn;
        public var set2_btn:set_menu_btn;
        public var set3_btn:set_menu_btn;

        public function setFrame_13()
        {
            __setProp_set1_btn_setFrame_();
            __setProp_set2_btn_setFrame_();
            __setProp_set3_btn_setFrame_();
            return;
        }// end function

        function __setProp_set2_btn_setFrame_()
        {
            try
            {
                set2_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            set2_btn.btn_label = "需要验证";
            try
            {
                set2_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_set3_btn_setFrame_()
        {
            try
            {
                set3_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            set3_btn.btn_label = "拒绝所有人";
            try
            {
                set3_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_set1_btn_setFrame_()
        {
            try
            {
                set1_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            set1_btn.btn_label = "允许任何人加我为好友";
            try
            {
                set1_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
