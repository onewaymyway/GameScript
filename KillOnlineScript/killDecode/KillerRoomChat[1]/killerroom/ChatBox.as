package killerroom
{
    import flash.display.*;
    import flash.events.*;

    public class ChatBox extends MovieClip
    {
        private var _maxH:uint = 0;
        public var scroll_mc:MovieClip;
        public var mask_mc:MovieClip;
        public var S:uint = 0;
        public var lists:MovieClip;

        public function ChatBox()
        {
            lists.mask = mask_mc;
            return;
        }// end function

        public function addChatVoice(param1:Object) : void
        {
            var _loc_2:* = new chatBox_Voicemc();
            if (lists.numChildren > 0)
            {
                _loc_2.y = lists.getChildAt((lists.numChildren - 1)).y + lists.getChildAt((lists.numChildren - 1)).height;
            }
            _loc_2.setValue(param1);
            lists.addChild(_loc_2);
            Relist();
            return;
        }// end function

        public function cleanChat() : void
        {
            S = 0;
            mcFunc.removeAllMc(lists);
            scroll_mc.setToBottom();
            return;
        }// end function

        public function set maxH(param1:uint) : void
        {
            _maxH = param1;
            return;
        }// end function

        public function setValue(param1:Object) : void
        {
            cleanChat();
            var _loc_2:* = new chatBox_mc();
            _loc_2.setValue(param1, mask_mc.width);
            lists.addChild(_loc_2);
            Relist();
            return;
        }// end function

        public function Relist() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            if (_maxH > 0)
            {
                (S + 1);
                if (S > _maxH)
                {
                    S = _maxH;
                    lists.removeChildAt(0);
                    _loc_1 = lists.numChildren;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1)
                    {
                        
                        _loc_3 = lists.getChildAt(_loc_2);
                        if (_loc_2 == 0)
                        {
                            _loc_3.y = 0;
                        }
                        else
                        {
                            _loc_3.y = lists.getChildAt((_loc_2 - 1)).y + lists.getChildAt((_loc_2 - 1)).height;
                        }
                        _loc_2 = _loc_2 + 1;
                    }
                }
            }
            scroll_mc.tryToBottom();
            return;
        }// end function

        private function init(event:Event) : void
        {
            return;
        }// end function

        public function addChat(param1:Object) : void
        {
            var _loc_2:* = new chatBox_mc();
            if (lists.numChildren > 0)
            {
                _loc_2.y = lists.getChildAt((lists.numChildren - 1)).y + lists.getChildAt((lists.numChildren - 1)).height;
            }
            _loc_2.setValue(param1, mask_mc.width);
            lists.addChild(_loc_2);
            Relist();
            return;
        }// end function

        public function addMobileChat(param1:Object) : void
        {
            var _loc_2:* = new chatBox_mc();
            if (lists.numChildren > 0)
            {
                _loc_2.y = lists.getChildAt((lists.numChildren - 1)).y + lists.getChildAt((lists.numChildren - 1)).height;
            }
            _loc_2.setMobileValue(param1, mask_mc.width);
            lists.addChild(_loc_2);
            Relist();
            return;
        }// end function

    }
}
