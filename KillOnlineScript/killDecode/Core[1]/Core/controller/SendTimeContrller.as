package Core.controller
{
    import Core.*;

    public class SendTimeContrller extends Object
    {
        public static var ChatTime:Number = 0;
        public static var FaceTime:Number = 0;
        public static var ToolTime:Number = 0;

        public function SendTimeContrller()
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

        public static function CanSendFace() : Boolean
        {
            if (FaceTime == 0)
            {
                FaceTime = new Date().getTime();
                return true;
            }
            var _loc_1:* = new Date().getTime();
            if (_loc_1 - FaceTime > 1000)
            {
                FaceTime = _loc_1;
                return true;
            }
            return false;
        }// end function

        public static function CanShowTool() : Boolean
        {
            if (ToolTime == 0)
            {
                return true;
            }
            var _loc_1:* = new Date().getTime();
            if (_loc_1 - ToolTime > 500)
            {
                return true;
            }
            return false;
        }// end function

        public static function CanSendTool() : Boolean
        {
            if (ToolTime == 0)
            {
                ToolTime = new Date().getTime();
                return true;
            }
            var _loc_1:* = new Date().getTime();
            if (_loc_1 - ToolTime > 500)
            {
                ToolTime = _loc_1;
                return true;
            }
            return false;
        }// end function

    }
}
