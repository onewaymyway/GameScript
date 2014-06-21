package model
{
    import Core.*;
    import Core.model.data.*;
    import controller.*;
    import flash.events.*;

    public class KillerRoomData extends Object
    {
        public static var UserPlayerID:uint = 0;
        public static var UserHost:uint = 0;
        public static var RoomInfo:Object = new Object();
        public static var GameInfo:Object = new Object();
        public static var isCanTool:Boolean = true;
        public static var isCanChat:Boolean = true;
        public static var isCanSetRoom:Boolean = true;
        public static var isCanReady:Boolean = true;
        public static var isCanStart:Boolean = true;
        public static var isCanVoteAct:Boolean = true;
        public static var isCanKillAct:Boolean = true;
        public static var isCanCheckAct:Boolean = true;
        public static var isDChat:Boolean = true;
        public static var isJChat:Boolean = true;
        public static var isSChat:Boolean = true;
        public static var isLastSay:Boolean = true;
        public static var isCanSpeaker:Boolean = true;
        public static var isBeGaged:Boolean = false;
        public static var mouseAct:String = "nothing";
        public static var beTooledpName:String = "";
        public static var beToolID:uint = 0;
        public static var RoomPlayerList:Object = new Object();
        public static var RoomUserList:Object = new Object();
        public static var votePlayerID:uint = 0;
        public static var killPlayerID:uint = 0;
        public static var checkPlayerID:uint = 0;
        public static var gameStates:uint = 0;
        public static var roomStates:uint = 0;
        public static var isKillGameType:Boolean = true;
        public static var isKillVoice:Boolean = false;
        public static var GameType:int = -1;
        public static var RoomSetInfoXml:XML;
        public static var GameType1:uint = 0;
        public static var isToolSeries:uint = 0;
        public static var toolSeriesNum:uint = 1;
        public static var toolsListData:Array = new Array();
        public static var seriesToolAct:KillerRoomSeriesToolActController = new KillerRoomSeriesToolActController();
        private static var firstGamePromptMsg:String = "";

        public function KillerRoomData()
        {
            return;
        }// end function

        public static function GetKillIden(param1:String) : String
        {
            var _loc_2:String = null;
            if (param1.length > 2)
            {
                _loc_2 = MainData.StrForGet(param1, UserData.UserInfo.UserId + "", UserData.UserInfo.web);
                param1 = int(_loc_2.substr(_loc_2.length - 2)) + "";
            }
            else
            {
                param1 = int(param1) + "";
            }
            return param1;
        }// end function

        public static function GetKillPlayerDo(param1:String) : int
        {
            var _loc_2:String = null;
            if (param1 != "undefined")
            {
                if (param1.length > 1)
                {
                    _loc_2 = MainData.StrForGet(param1, UserData.UserInfo.UserId + "", UserData.UserInfo.web);
                    param1 = int(_loc_2.substr((_loc_2.length - 1))) + "";
                }
                else
                {
                    param1 = int(param1) + "";
                }
            }
            else
            {
                param1 = "0";
            }
            return int(param1);
        }// end function

        public static function firstGamePrompt(param1:String, param2:int = -1) : Boolean
        {
            var s:* = param1;
            var site:* = param2;
            if (site > -1 && int(KillerRoomData.UserPlayerID) != site)
            {
                return false;
            }
            if (firstGamePromptMsg == s && s != "")
            {
                return false;
            }
            try
            {
                if (s == "" || UserData.UserSO.data["iden" + UserData.UserPlayerIden])
                {
                    MyFacade.getInstance().sendNotification(GameEvents.PlUSEVENT.NewUserTec_PROMPTTITLE, "");
                    return false;
                }
                else
                {
                    firstGamePromptMsg = s;
                    MyFacade.getInstance().sendNotification(GameEvents.PlUSEVENT.NewUserTec_PROMPTTITLE, s);
                    return true;
                }
            }
            catch (e:Event)
            {
            }
            return false;
        }// end function

    }
}
