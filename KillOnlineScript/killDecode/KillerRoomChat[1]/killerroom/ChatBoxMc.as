package killerroom
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class ChatBoxMc extends Sprite
    {
        private var txtColors:Array;
        private var msg:String = "";
        public var _bg:MovieClip;
        private var timer:Timer;
        private var colorI:uint = 0;
        var msgTxt:TextField;
        public var msg_txt:TextField;
        private var msgTitle:String = "";

        public function ChatBoxMc()
        {
            msgTxt = msg_txt;
            this.addEventListener(Event.REMOVED_FROM_STAGE, removeStagehandler);
            timer = new Timer(500);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            return;
        }// end function

        public function setMobileValue(param1:Object, param2:int)
        {
            msgTxt.wordWrap = false;
            msgTxt.autoSize = "left";
            msgTxt.htmlText = String(param1.UserName);
            var _loc_3:* = new mobile_log();
            if (String(param1.Device).indexOf("iPhone") > -1)
            {
                _loc_3.gotoAndStop("iphone");
            }
            else if (String(param1.Device).indexOf("android") > -1)
            {
                _loc_3.gotoAndStop("android");
            }
            _loc_3.x = msgTxt.width - 2;
            this.addChild(_loc_3);
            msgTxt.htmlText = String(param1.UserName) + "   " + "<font color=\'" + param1.Color + "\'> : " + param1.Msg + "</font> ";
            msgTxt.width = param2;
            msgTxt.autoSize = TextFieldAutoSize.LEFT;
            msgTxt.wordWrap = true;
            msgTxt.mouseWheelEnabled = false;
            return;
        }// end function

        private function removeStagehandler(event:Event) : void
        {
            this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStagehandler);
            if (timer.hasEventListener(TimerEvent.TIMER))
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
            }
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var _loc_3:* = colorI + 1;
            colorI = _loc_3;
            if (colorI >= txtColors.length)
            {
                colorI = 0;
            }
            msgTxt.htmlText = msgTitle + "<font color=\'" + txtColors[colorI] + "\'>" + msg + "</font>";
            return;
        }// end function

        public function setValue(param1:Object, param2:int)
        {
            var _loc_3:String = null;
            if (param1 is String)
            {
                msgTxt.htmlText = String(param1);
            }
            else if (param1.Msg)
            {
                if (param1.bg)
                {
                    ViewPicLoad.load(param1.bg + "_chat.swf", _bg);
                    msgTxt.x = 25;
                }
                msgTitle = param1.MsgTitle;
                msg = param1.Msg;
                txtColors = param1.MsgColors;
                _loc_3 = param1.MsgTitle + "<font color=\'" + param1.MsgColors[colorI] + "\'>" + param1.Msg + "</font>";
                msgTxt.htmlText = _loc_3;
                if (param1.MsgColors.length > 1)
                {
                    timer.start();
                }
            }
            msgTxt.width = param2;
            msgTxt.autoSize = TextFieldAutoSize.LEFT;
            msgTxt.wordWrap = true;
            msgTxt.mouseWheelEnabled = false;
            return;
        }// end function

    }
}
