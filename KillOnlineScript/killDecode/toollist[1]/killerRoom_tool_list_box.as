package 
{
    import flash.display.*;

    dynamic public class killerRoom_tool_list_box extends MovieClip
    {
        public var drag_mc:MovieClip;
        public var buyLog_btn:SimpleButton;
        public var mask_mc:MovieClip;
        public var lists:MovieClip;
        public var class1_btn:f_menu_g_btn;
        public var close2_btn:SimpleButton;
        public var close_btn:SimpleButton;
        public var class2_btn:f_menu_g_btn;
        public var scorll_mc:MovieClip;
        public var buy_btn:SimpleButton;
        public var toolgoon_num:MovieClip;
        public var class3_btn:f_menu_g_btn;
        public var toolgoon_chick:MovieClip;
        public var reset_btn:SimpleButton;
        public var loading_mc:MovieClip;
        public var gobuy_btn:SimpleButton;

        public function killerRoom_tool_list_box()
        {
            __setProp_toolgoon_chick_killerRoom_tool_list_box_();
            __setProp_class1_btn_killerRoom_tool_list_box_menu_0();
            __setProp_class2_btn_killerRoom_tool_list_box_menu_0();
            __setProp_class3_btn_killerRoom_tool_list_box_menu_0();
            __setProp_scorll_mc_killerRoom_tool_list_box_();
            return;
        }// end function

        function __setProp_class1_btn_killerRoom_tool_list_box_menu_0()
        {
            try
            {
                class1_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            class1_btn.btn_label = "整蛊卡";
            try
            {
                class1_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_class3_btn_killerRoom_tool_list_box_menu_0()
        {
            try
            {
                class3_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            class3_btn.btn_label = "功能卡";
            try
            {
                class3_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_class2_btn_killerRoom_tool_list_box_menu_0()
        {
            try
            {
                class2_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            class2_btn.btn_label = "讨好卡";
            try
            {
                class2_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_toolgoon_chick_killerRoom_tool_list_box_()
        {
            try
            {
                toolgoon_chick["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            toolgoon_chick.labeltxt = "连续使用道具";
            toolgoon_chick.chickData = "1";
            toolgoon_chick.unchickData = "0";
            toolgoon_chick.def = false;
            try
            {
                toolgoon_chick["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_scorll_mc_killerRoom_tool_list_box_()
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
