package Core.model.data
{
    import Core.*;
    import Core.model.vo.*;
    import flash.net.*;
    import uas.*;

    public class UserData extends Object
    {
        public static var UserInfo:UserVO = new UserVO();
        public static var UserRoom:uint = 0;
        public static var UserRoomPassword:String = "";
        public static var UserRoomPlayerType:String = "";
        public static var UserPlayerIden:uint = 0;
        public static var UserSO:SharedObject;
        public static var UserMsgs:Array = new Array();
        public static var MyRoomInfo:Object = null;

        public function UserData()
        {
            return;
        }// end function

        public static function updateInfo(param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_5:Object = null;
            if (param1)
            {
                for (_loc_2 in param1)
                {
                    
                    if (_loc_2 == "Integral" && UserData.UserInfo.Integral < 700 && param1[_loc_2] >= 700 && MainData.newUserTaskData.nowId != 1003)
                    {
                        if (UserData.UserSO && !UserData.UserSO.data["Integral700"])
                        {
                            _loc_3 = "你已解锁";
                            _loc_4 = -1;
                            _loc_3 = _loc_3 + "高手区,是否体验？";
                            _loc_5 = [GameEvents.PlUSEVENT.NewUserTec_ALERTGOTOLINE, {Msg:_loc_3, GameArea:_loc_4}];
                            MyFacade.getInstance().sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERT_FNISH, _loc_5);
                            UserData.UserSO.data["Integral700"] = 1;
                        }
                    }
                    UserData.UserInfo[_loc_2] = param1[_loc_2];
                }
            }
            return;
        }// end function

        public static function isToolFigure(param1:Object) : Boolean
        {
            var _loc_2:Date = null;
            var _loc_3:Date = null;
            if (param1.UserToolState && param1.UserToolState[10])
            {
                _loc_2 = DateStr.strToDateFormat(param1.UserToolState[10].endtime);
                _loc_3 = new Date();
                if (_loc_3 < _loc_2)
                {
                    return true;
                }
            }
            return false;
        }// end function

    }
}
