package fasForm5_fla
{
    import flash.display.*;
    import flash.text.*;

    dynamic public class fri_from_mc1_62 extends MovieClip
    {
        public var mood_mc:MovieClip;
        public var otherInfo_form:MovieClip;
        public var spyInfo_form:MovieClip;
        public var theName_txt:TextField;
        public var sex_mc:MovieClip;
        public var other_btn:userinfo_infoForm_menu_btn;
        public var killInfo_form:MovieClip;
        public var spy_btn:userinfo_infoForm_menu_btn;
        public var kill_btn:userinfo_infoForm_menu_btn;

        public function fri_from_mc1_62()
        {
            __setProp_kill_btn_fri_from_mc1_();
            __setProp_spy_btn_fri_from_mc1_();
            __setProp_other_btn_fri_from_mc1_();
            return;
        }// end function

        function __setProp_spy_btn_fri_from_mc1_()
        {
            try
            {
                spy_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            spy_btn.btn_label = "谁是卧底";
            try
            {
                spy_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_kill_btn_fri_from_mc1_()
        {
            try
            {
                kill_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            kill_btn.btn_label = "杀人游戏";
            try
            {
                kill_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_other_btn_fri_from_mc1_()
        {
            try
            {
                other_btn["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            other_btn.btn_label = "其它游戏";
            try
            {
                other_btn["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
