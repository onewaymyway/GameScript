package Core.model.data
{
    import Core.model.*;
    import Core.model.vo.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.util.*;
    import flash.display.*;
    import flash.utils.*;
    import uas.*;

    public class MainData extends Object
    {
        public static var newUserTaskData:NewUserTeskData = new NewUserTeskData();
        public static var MainStage:Stage;
        public static var NewsMsgObj:NewsMsgVO = new NewsMsgVO();
        public static var LabaBtnType:uint = 1;
        public static var LoginInfo:LoginVO = new LoginVO();
        public static var UserMsg_LB:Boolean = false;
        public static var UserNewTask_isLog:int = 0;
        public static var IsJustNowLogin:Boolean = true;
        public static var Lines1:Array;
        public static var LinesObj:Object = new Object();
        public static var LineGameLocks:Object = new Object();
        public static var IsShowSpeak:Boolean = true;
        public static var AdminViewerSOZ:uint = 0;
        public static var M:int = 0;
        public static var N:int = 111;
        public static var isLoginScenced:uint = 0;
        public static var isHallScenced:uint = 0;
        public static var isKillRoomScenced:uint = 0;
        public static var isPrivateChatOpen:uint = 0;
        public static var TaskListData:TasksListProxy = new TasksListProxy();

        public function MainData()
        {
            return;
        }// end function

        public static function getSWFUrl(param1:Object = null) : String
        {
            var _loc_2:String = "";
            if (param1 != null && MainData.LinesObj[param1])
            {
                _loc_2 = String(MainData.LinesObj[param1].Url);
            }
            else
            {
                _loc_2 = String(MainData.LinesObj[MainData.LoginInfo.Id].Url);
            }
            return _loc_2;
        }// end function

        public static function getGameArea(param1:Object = null) : int
        {
            var _loc_2:int = 0;
            if (param1 != null && MainData.LinesObj[param1])
            {
                _loc_2 = int(MainData.LinesObj[param1].GameArea);
            }
            else
            {
                _loc_2 = int(MainData.LinesObj[MainData.LoginInfo.Id].GameArea);
            }
            return _loc_2;
        }// end function

        public static function getLineName(param1:uint) : String
        {
            var _loc_2:String = "";
            if (MainData.LinesObj[param1])
            {
                _loc_2 = String(MainData.LinesObj[param1].Name);
            }
            else
            {
                _loc_2 = "未知" + param1;
            }
            return _loc_2;
        }// end function

        public static function getIsLineLock(param1:uint) : Boolean
        {
            var _loc_2:Boolean = false;
            if (MainData.LineGameLocks[param1])
            {
                _loc_2 = Boolean(MainData.LineGameLocks[param1]);
            }
            else
            {
                _loc_2 = false;
            }
            return _loc_2;
        }// end function

        public static function StrForSend(param1:String, param2:String, param3:String) : String
        {
            param2 = StrToNlen(param2, 8);
            param3 = StrToNlen(param3, 8);
            var _loc_4:* = StrToBAr(param2);
            var _loc_5:* = StrToBAr(param3);
            var _loc_6:* = new DESKey(_loc_4);
            var _loc_7:* = new CBCMode(_loc_6);
            new CBCMode(_loc_6).IV = _loc_5;
            var _loc_8:* = StrToBAr(param1);
            _loc_7.encrypt(_loc_8);
            return Base64.encodeByteArray(_loc_8);
        }// end function

        public static function StrForGet(param1:String, param2:String, param3:String) : String
        {
            param2 = StrToNlen(param2, 8);
            param3 = StrToNlen(param3, 8);
            var _loc_4:* = StrToBAr(param2);
            var _loc_5:* = StrToBAr(param3);
            var _loc_6:* = new DESKey(_loc_4);
            var _loc_7:* = new CBCMode(_loc_6);
            new CBCMode(_loc_6).IV = _loc_5;
            var _loc_8:* = Base64.decodeToByteArray(param1);
            _loc_7.decrypt(_loc_8);
            return BArToStr(_loc_8);
        }// end function

        public static function StrToNlen(param1:String, param2:uint) : String
        {
            var _loc_3:* = param1.length;
            var _loc_4:* = new Array();
            var _loc_5:uint = 0;
            while (_loc_5 < param2)
            {
                
                if (_loc_5 < _loc_3)
                {
                    _loc_4.push(param1.charAt(_loc_5));
                }
                else
                {
                    _loc_4.push("0");
                }
                _loc_5 = _loc_5 + 1;
            }
            return _loc_4.join("");
        }// end function

        public static function StrToBAr(param1:String) : ByteArray
        {
            var _loc_2:ByteArray = null;
            if (param1)
            {
                _loc_2 = new ByteArray();
                _loc_2.writeUTFBytes(param1);
            }
            return _loc_2;
        }// end function

        public static function BArToStr(param1:ByteArray) : String
        {
            var _loc_2:String = null;
            if (param1)
            {
                param1.position = 0;
                _loc_2 = param1.readUTFBytes(param1.length);
            }
            return _loc_2;
        }// end function

        public static function failConn(param1:String) : void
        {
            var _loc_2:* = new LoadURL();
            var _loc_3:* = "/User/LostConnects.ss?addr=" + escapeMultiByte(param1);
            _loc_2.load(_loc_3);
            return;
        }// end function

    }
}
