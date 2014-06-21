package 
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class set_form extends Sprite
    {
        public var psw_txt:TextField;
        public var isip_chickBox:MovieClip;
        public var close_btn:SimpleButton;
        public var close2_btn:SimpleButton;
        public var save_btn:SimpleButton;
        public var game_select:MovieClip;
        public var score_chickBox:MovieClip;
        public var bg_select:MovieClip;
        public var roomName_txt:TextField;
        public var count_select:MovieClip;

        public function set_form()
        {
            __setProp_count_select_set_form_txt_0();
            __setProp_isip_chickBox_set_form_txt_0();
            __setProp_bg_select_set_form_txt_0();
            __setProp_game_select_set_form_txt_0();
            __setProp_score_chickBox_set_form_txt_0();
            return;
        }// end function

        function __setProp_bg_select_set_form_txt_0()
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
            bg_select.labelArr = ["默认"];
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

        function __setProp_isip_chickBox_set_form_txt_0()
        {
            try
            {
                isip_chickBox["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            isip_chickBox.labeltxt = "禁止相同IP进入(防作弊)";
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

        function __setProp_count_select_set_form_txt_0()
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
            count_select.labelArr = ["20人(4警4匪)", "15人(3警3匪)", "12人(2警2匪)", "8人(1警1匪)"];
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

        function __setProp_score_chickBox_set_form_txt_0()
        {
            try
            {
                score_chickBox["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            score_chickBox.labeltxt = "开启双倍积分(每轮消耗200VIP值)";
            score_chickBox.chickData = "true";
            score_chickBox.unchickData = "false";
            score_chickBox.def = false;
            try
            {
                score_chickBox["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_game_select_set_form_txt_0()
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
            game_select.labelArr = ["杀人游戏"];
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

    }
}
