package killerroom
{
    import flash.display.*;
    import flash.events.*;

    public class SChatBox extends MovieClip
    {
        public var drag_mc:MovieClip;
        private var _maxH:uint = 0;
        public var S:uint = 0;
        public var l_l_btn:SimpleButton;
        private var facade:Object;
        public var chat_mc:MovieClip;

        public function SChatBox()
        {
            facade = MyFacade.getInstance();
            this.l_l_btn.addEventListener(MouseEvent.CLICK, onClick);
            this.chat_mc.send_btn.addEventListener(MouseEvent.CLICK, onClick);
            this.chat_mc.send_txt.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            this.x = 368;
            this.y = 426;
            return;
        }// end function

        public function cleanChat() : void
        {
            this.chat_mc.chatMsg_box.cleanChat();
            return;
        }// end function

        public function SendChatMsg() : void
        {
            var _loc_1:Object = null;
            this.chat_mc.send_txt.text = StringUtil.trim(this.chat_mc.send_txt.text);
            if (this.chat_mc.send_txt.text != "")
            {
                _loc_1 = new Object();
                _loc_1.Act = "SayToAllS";
                _loc_1.Msg = this.chat_mc.send_txt.text;
                _loc_1.cmd = "GameCmd_Act";
                facade.sendNotification(GameEvents.NETCALL, _loc_1);
                this.chat_mc.send_txt.text = "";
            }
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == 13)
            {
                SendChatMsg();
                if (this.chat_mc.send_txt.scrollH >= 2)
                {
                    this.chat_mc.send_txt.text = "";
                }
            }
            return;
        }// end function

        private function init(event:Event) : void
        {
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
                case "l_l_btn":
                {
                    if (this.chat_mc.visible)
                    {
                        this.chat_mc.visible = false;
                    }
                    else
                    {
                        this.chat_mc.visible = true;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function addChat(param1:Object) : void
        {
            this.chat_mc.chatMsg_box.addChat(param1);
            return;
        }// end function

    }
}
