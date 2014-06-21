package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class RoomList_mc extends MovieClip
    {
        public var listBox_mc:MovieClip;
        public var newUserTask_list:MovieClip;
        public var masks_mc:mask_mc;
        public var addroom_btn:SimpleButton;
        public var area1_btn:menu_g_btn;
        public var scorll_mc:MovieClip;
        public var area3_btn:menu_g_btn;
        public var area2_btn:menu_g_btn;
        public var areaName_txt:TextField;
        public var refresh_btn:SimpleButton;

        public function RoomList_mc()
        {
            __setProp_scorll_mc_RoomList_mc_scorll_0();
            __setProp_area1_btn_RoomList_mc_btns_0();
            __setProp_area2_btn_RoomList_mc_btns_0();
            __setProp_area3_btn_RoomList_mc_btns_0();
            return;
        }// end function

        function __setProp_area2_btn_RoomList_mc_btns_0()
        {
            try
            {
                area2_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            area2_btn.btn_label = "杀手区";
            try
            {
                area2_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_scorll_mc_RoomList_mc_scorll_0()
        {
            try
            {
                scorll_mc["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            scorll_mc.objName = "listBox_mc";
            scorll_mc.objmarkName = "masks_mc";
            scorll_mc.ah = 0;
            scorll_mc.delta = 110;
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

        function __setProp_area3_btn_RoomList_mc_btns_0()
        {
            try
            {
                area3_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            area3_btn.btn_label = "竞技场";
            try
            {
                area3_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_area1_btn_RoomList_mc_btns_0()
        {
            try
            {
                area1_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            area1_btn.btn_label = "新手区";
            try
            {
                area1_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
