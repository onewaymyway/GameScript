package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class confirm_CreateRoom_box extends MovieClip
    {
        public var drag_mc:MovieClip;
        public var psw_txt:TextField;
        public var isip_chickBox:MovieClip;
        public var close_btn:SimpleButton;
        public var game_select:MovieClip;
        public var count_select:MovieClip;
        public var area_select:MovieClip;
        public var bg_select:MovieClip;
        public var roomName_txt:TextField;
        public var ok_btn:SimpleButton;

        public function confirm_CreateRoom_box()
        {
            __setProp_count_select_confirm_CreateRoom_box_();
            __setProp_isip_chickBox_confirm_CreateRoom_box_();
            __setProp_bg_select_confirm_CreateRoom_box_();
            __setProp_game_select_confirm_CreateRoom_box_();
            __setProp_area_select_confirm_CreateRoom_box_();
            return;
        }// end function

        function __setProp_count_select_confirm_CreateRoom_box_()
        {
            try
            {
                count_select["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            count_select.def = 0;
            count_select.maskH = 100;
            count_select.labelArr = ["20��(4��4��)", "15��(3��3��)", "12��(2��2��)", "8��(1��1��)"];
            count_select.dataArr = [20, 15, 12, 8];
            try
            {
                count_select["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_game_select_confirm_CreateRoom_box_()
        {
            try
            {
                game_select["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            game_select.def = 0;
            game_select.maskH = 120;
            game_select.labelArr = ["ɱ����Ϸ"];
            game_select.dataArr = [0];
            try
            {
                game_select["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_area_select_confirm_CreateRoom_box_()
        {
            try
            {
                area_select["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            area_select.def = 0;
            area_select.maskH = 100;
            area_select.labelArr = ["������", "ɱ����"];
            area_select.dataArr = [1000, 2000];
            try
            {
                area_select["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_bg_select_confirm_CreateRoom_box_()
        {
            try
            {
                bg_select["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            bg_select.def = 0;
            bg_select.maskH = 120;
            bg_select.labelArr = ["Ĭ��"];
            bg_select.dataArr = ["bg/bg"];
            try
            {
                bg_select["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_isip_chickBox_confirm_CreateRoom_box_()
        {
            try
            {
                isip_chickBox["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            isip_chickBox.labeltxt = "��ֹ��ͬIP���뷿��(�������Ƽ�)";
            isip_chickBox.chickData = "true";
            isip_chickBox.unchickData = "false";
            isip_chickBox.def = true;
            try
            {
                isip_chickBox["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
