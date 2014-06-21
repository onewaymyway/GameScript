package Core.controller
{
    import Core.*;

    public class ChatContrller extends Object
    {
        public static var ChatTime:Number = 0;

        public function ChatContrller()
        {
            return;
        }// end function

        public static function CanSendChat() : Boolean
        {
            if (ChatTime == 0)
            {
                ChatTime = new Date().getTime();
                return true;
            }
            var _loc_1:* = new Date().getTime();
            if (_loc_1 - ChatTime > 1000)
            {
                ChatTime = _loc_1;
                return true;
            }
            MyFacade.getInstance().sendNotification(GameEvents.ALERTEVENT.ALERTMSG, {msg:"别激动嘛，慢慢说!!"});
            return false;
        }// end function

        public static function ChkKeyWord(param1:String) : String
        {
            var _loc_4:String = null;
            var _loc_5:uint = 0;
            var _loc_2:* = param1;
            var _loc_3:uint = 0;
            while (_loc_3 < Resource.KeyWords.length)
            {
                
                _loc_4 = "";
                _loc_5 = 0;
                while (_loc_5 < Resource.KeyWords[_loc_3].length)
                {
                    
                    _loc_4 = _loc_4 + "*";
                    _loc_5 = _loc_5 + 1;
                }
                _loc_2 = _loc_2.split(Resource.KeyWords[_loc_3]).join(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

    }
}
