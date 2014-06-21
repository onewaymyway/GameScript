package killerroom
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ChatBoxVoiceMc extends Sprite
    {
        private var voiceUrl:String = "";
        public var voice_btn:MovieClip;
        public var msg_txt:TextField;
        private var isPlayed:Boolean = false;

        public function ChatBoxVoiceMc()
        {
            voice_btn.buttonMode = true;
            voice_btn.useHandCursor = true;
            voice_btn.mouseChildren = false;
            voice_btn.addEventListener(MouseEvent.CLICK, voiceHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removeStagehandler);
            voice_btn.playing_mc.gotoAndStop(1);
            return;
        }// end function

        public function stopVoice() : void
        {
            isPlayed = true;
            voice_btn.isPlayed_log.visible = false;
            voice_btn.playing_mc.gotoAndStop(1);
            return;
        }// end function

        public function setValue(param1:Object)
        {
            var _loc_4:mobile_log = null;
            voiceUrl = param1.Url;
            voice_btn.time_txt.text = String(param1.Times);
            var _loc_2:* = param1.UserName;
            msg_txt.autoSize = TextFieldAutoSize.LEFT;
            msg_txt.mouseWheelEnabled = false;
            msg_txt.htmlText = String(_loc_2);
            if (param1.Device)
            {
                _loc_4 = new mobile_log();
                if (String(param1.Device).indexOf("iPhone") > -1)
                {
                    _loc_4.gotoAndStop("iphone");
                }
                else if (String(param1.Device).indexOf("android") > -1)
                {
                    _loc_4.gotoAndStop("android");
                }
                _loc_4.x = msg_txt.width - 2;
                this.addChild(_loc_4);
                msg_txt.htmlText = String(param1.UserName) + "    " + "<font color=\'#99FF00\'>:</font> ";
            }
            else
            {
                msg_txt.htmlText = String(param1.UserName) + "<font color=\'#99FF00\'>:</font> ";
            }
            voice_btn.x = msg_txt.width + 10;
            var _loc_3:* = new KillerRoomCharVoicesVo();
            _loc_3.url = param1.Url;
            _loc_3.target = this;
            KillerRoomCharVoicesController.sharedController().addVoice(_loc_3);
            return;
        }// end function

        private function removeStagehandler(event:Event) : void
        {
            this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStagehandler);
            return;
        }// end function

        private function voiceHandler(event:MouseEvent) : void
        {
            var _loc_2:* = new KillerRoomCharVoicesVo();
            _loc_2.url = voiceUrl;
            _loc_2.target = this;
            KillerRoomCharVoicesController.sharedController().play(_loc_2);
            isPlayed = true;
            voice_btn.isPlayed_log.visible = false;
            return;
        }// end function

        public function playVoice() : void
        {
            isPlayed = true;
            voice_btn.isPlayed_log.visible = false;
            voice_btn.playing_mc.play();
            return;
        }// end function

    }
}
