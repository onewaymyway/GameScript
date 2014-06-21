package 
{
    import flash.display.*;

    dynamic public class friend_Box extends MovieClip
    {
        public var family_btn:f_menu_g_btn;
        public var drag_mc:MovieClip;
        public var mask_mc:MovieClip;
        public var list_title_bar:MovieClip;
        public var add_frame:MovieClip;
        public var set_frame:MovieClip;
        public var lists:MovieClip;
        public var close2_btn:SimpleButton;
        public var close_btn:SimpleButton;
        public var scorll_mc:MovieClip;
        public var black_btn:f_menu_g_btn;
        public var reload_btn:SimpleButton;
        public var loading_mc:MovieClip;
        public var friend_btn:f_menu_g_btn;
        public var add_btn:f_menu_g_btn;
        public var set_btn:f_menu_g_btn;

        public function friend_Box()
        {
            __setProp_friend_btn_friend_box_btns_0();
            __setProp_family_btn_friend_box_btns_0();
            __setProp_set_btn_friend_box_btns_0();
            __setProp_add_btn_friend_box_btns_0();
            __setProp_black_btn_friend_box_btns_0();
            __setProp_scorll_mc_friend_box_scroll_0();
            return;
        }// end function

        function __setProp_family_btn_friend_box_btns_0()
        {
            try
            {
                family_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            family_btn.btn_label = "家<br><br>族";
            try
            {
                family_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_set_btn_friend_box_btns_0()
        {
            try
            {
                set_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            set_btn.btn_label = "设<br><br>置";
            try
            {
                set_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_add_btn_friend_box_btns_0()
        {
            try
            {
                add_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            add_btn.btn_label = "加好友";
            try
            {
                add_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_black_btn_friend_box_btns_0()
        {
            try
            {
                black_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            black_btn.btn_label = "黑名单";
            try
            {
                black_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_scorll_mc_friend_box_scroll_0()
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

        function __setProp_friend_btn_friend_box_btns_0()
        {
            try
            {
                friend_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            friend_btn.btn_label = "好<br><br>友";
            try
            {
                friend_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
