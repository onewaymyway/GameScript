package 
{
    import killerroom.*;

    dynamic public class killerRoomChatMsgBox extends ChatBox
    {

        public function killerRoomChatMsgBox()
        {
            __setProp_scroll_mc_killerRoomChatMsgBox_scorll_0();
            return;
        }// end function

        function __setProp_scroll_mc_killerRoomChatMsgBox_scorll_0()
        {
            try
            {
                scroll_mc["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            scroll_mc.objName = "lists";
            scroll_mc.objmarkName = "mask_mc";
            scroll_mc.ah = 0;
            scroll_mc.delta = 20;
            scroll_mc.toWhere = "bom";
            try
            {
                scroll_mc["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
