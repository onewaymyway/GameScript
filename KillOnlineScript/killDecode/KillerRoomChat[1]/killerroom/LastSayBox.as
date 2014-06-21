package killerroom
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class LastSayBox extends MovieClip
    {
        public var drag_mc:MovieClip;
        private var _maxH:uint = 0;
        public var bg:MovieClip;
        private var timer:Timer;
        public var S:uint = 0;
        private var facade:Object;
        public var bg_btn:SimpleButton;
        public var saytxt:TextField;
        public var send_btn:SimpleButton;
        private var timei:uint = 65;
        public var time_txt:TextField;

        public function LastSayBox()
        {
            timer = new Timer(1000);
            this.visible = false;
            facade = MyFacade.getInstance();
            this.send_btn.addEventListener(MouseEvent.CLICK, onClick);
            this.saytxt.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            timer.addEventListener(TimerEvent.TIMER, timerhandler);
            this.x = 368;
            this.y = 426;
            return;
        }// end function

        public function SendChatMsg() : void
        {
            var _loc_1:* = new Object();
            this.saytxt.text = StringUtil.trim(this.saytxt.text);
            if (this.saytxt.text != "")
            {
                _loc_1.Msg = this.saytxt.text;
            }
            else
            {
                _loc_1.Msg = "无语";
            }
            _loc_1.Act = "LastSay";
            _loc_1.cmd = "GameCmd_Act";
            facade.sendNotification(GameEvents.NETCALL, _loc_1);
            this.saytxt.text = "";
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == 13)
            {
                SendChatMsg();
            }
            return;
        }// end function

        private function timerCompleteHandler(event:TimerEvent) : void
        {
            SendChatMsg();
            return;
        }// end function

        public function start() : void
        {
            timei = 65;
            timer.start();
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            switch(event.currentTarget.name)
            {
                case "send_btn":
                {
                    SendChatMsg();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function timerhandler(event:TimerEvent) : void
        {
            var _loc_3:* = timei - 1;
            timei = _loc_3;
            if (timei < 60)
            {
                this.visible = true;
            }
            if (timei <= 0)
            {
                timei = 0;
                this.saytxt.text = "无语";
                SendChatMsg();
                timer.stop();
            }
            this.time_txt.text = "(" + timei + ")";
            return;
        }// end function

        public function close() : void
        {
            this.visible = false;
            timer.stop();
            return;
        }// end function

    }
}
