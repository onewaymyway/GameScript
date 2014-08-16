package 
{
    import flash.display.*;

    dynamic public class TaskBox_MainMc extends MovieClip
    {
        public var day_btn:MovieClip;
        public var scorll_mc:MovieClip;
        public var drag_mc:MovieClip;
        public var newuser_btn:MovieClip;
        public var mask_mc:MovieClip;
        public var help_mc:MovieClip;
        public var close_btn:SimpleButton;
        public var up_btn:MovieClip;
        public var loading_mc:MovieClip;
        public var _list:MovieClip;
        public var help_btn:MovieClip;

        public function TaskBox_MainMc()
        {
            __setProp_scorll_mc_TaskBox_MainMc_();
            return;
        }// end function

        function __setProp_scorll_mc_TaskBox_MainMc_()
        {
            try
            {
                scorll_mc["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            scorll_mc.objName = "_list";
            scorll_mc.objmarkName = "mask_mc";
            scorll_mc.ah = 0;
            scorll_mc.delta = 55;
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
