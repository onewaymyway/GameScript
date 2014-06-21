package Core
{
    import flash.net.*;

    public class Resource extends Object
    {
        public static var so:SharedObject = SharedObject.getLocal("killeronline", "/", false);
        public static var userip:String = "SfTEM0OVzzl+kE4xW0dJZg==";
        public static var V:String = "0.0.0";
        public static var ChildV:Object = new Object();
        public static var JC:String = "";
        public static var ServerArea:String = "测试区";
        public static var uservalues:String = "+5hr3hGEfrA=";
        public static var CDN:Object = "";
        public static var HTTP:String = "/swf/";
        public static var HTTP2NAME:String = "test";
        public static var SysMsg:String = "欢迎";
        public static var Conns:String = "127.0.0.1:9933|127.0.0.1:9933";
        public static var VoiceServer:String = "121.61.118.147:1991";
        public static var LoadingPath:String = HTTP + "Loading.swf";
        public static var BaseLoadPathArr:Array = [{url:HTTP + "FgFrame.swf", ap:3}, {url:HTTP + "NewsList.swf", ap:3}, {url:HTTP + "NewUserTecFrame.swf", ap:1}, {url:HTTP + "Alert.swf", ap:1}, {url:HTTP + "UserInfoBox.swf", ap:4}, {url:HTTP + "ConfirmBox.swf", ap:4}, {url:HTTP + "GComps.swf", ap:-1}, {url:HTTP + "figures.swf", ap:-1}];
        public static var LinesBoxPath:String = HTTP + "LinesBox.swf";
        public static var CreatBoxPath:String = HTTP + "CreatBox.swf";
        public static var HallPath:String = HTTP + "Hall.swf";
        public static var KillerRoomPath:String = HTTP + "KillerRoom.swf";
        public static var RoomPath:String = HTTP + "Room.swf";
        public static var FriendPath:String = HTTP + "Friend.swf";
        public static var AlertPath:String = HTTP + "Alert.swf";
        public static var SkinListsPath:String = HTTP + "SkinList.swf";
        public static var FamilyPath:String = HTTP + "Family.swf";
        public static var MarryListsPath:String = HTTP + "MarryList.swf";
        public static var PlugPath:Object = {VoicePlusPath:{url:HTTP + "plus/VoicePlus.swf", x:722, y:527}, MallPlusPath:{url:HTTP + "plus/KillMall.swf", x:0, y:0}};
        public static var PlugGames:Array = new Array("killGame", {url:HTTP + "pluggame/LyingDicePlus.swf", x:0, y:0}, "killGame3.0", {url:HTTP + "plus/KillVoice.swf", x:700, y:450}, {url:HTTP + "plus/KillVoice.swf", x:700, y:450}, "killGame4.0", {url:HTTP + "pluggame/CowPlus.swf", x:0, y:0}, "PhotoRoom", {url:HTTP + "pluggame/LyingDicePlus.swf", x:0, y:0}, {url:HTTP + "plus/KillVoice.swf", x:700, y:450});
        public static var KeyWords:Array;
        public static var ADOpenPlugs:Array = [];
        public static var PromptMsgs:Array = [];
        public static var AdminPath:String = HTTP + "admin/";
        public static var AdminPassword:String = "";
        public static var AdminBoxPath:String = HTTP + "admin/AdminBox.swf";
        public static var AdminUserListPath:String = HTTP + "admin/AdminUserListBox.swf";
        public static var AdminSoViewerPath:String = HTTP + "admin/SoViewerTreeBox.swf";
        public static var AdminRoomUsersPath:String = HTTP + "admin/AdminRoomUserList.swf";

        public function Resource()
        {
            return;
        }// end function

        public static function ChangeHTTP(param1:String) : void
        {
            HTTP = param1;
            LoadingPath = HTTP + "Loading.swf";
            BaseLoadPathArr = [{url:HTTP + "FgFrame.swf", ap:3}, {url:HTTP + "NewsList.swf", ap:3}, {url:HTTP + "NewUserTecFrame.swf", ap:1}, {url:HTTP + "Alert.swf", ap:1}, {url:HTTP + "UserInfoBox.swf", ap:4}, {url:HTTP + "ConfirmBox.swf", ap:4}, {url:HTTP + "GComps.swf", ap:-1}, {url:HTTP + "figures.swf", ap:-1}];
            LinesBoxPath = HTTP + "LinesBox.swf";
            CreatBoxPath = HTTP + "CreatBox.swf";
            HallPath = HTTP + "Hall.swf";
            KillerRoomPath = HTTP + "KillerRoom.swf";
            RoomPath = HTTP + "Room.swf";
            FriendPath = HTTP + "Friend.swf";
            AlertPath = HTTP + "Alert.swf";
            SkinListsPath = HTTP + "SkinList.swf";
            FamilyPath = HTTP + "Family.swf";
            MarryListsPath = HTTP + "MarryList.swf";
            PlugPath = {VoicePlusPath:{url:HTTP + "plus/VoicePlus.swf", x:722, y:527}, MallPlusPath:{url:HTTP + "plus/KillMall.swf", x:0, y:0}};
            PlugGames = new Array("killGame", {url:HTTP + "pluggame/LyingDicePlus.swf", x:0, y:0}, "killGame3.0", {url:HTTP + "plus/KillVoice.swf", x:700, y:450}, {url:HTTP + "plus/KillVoice.swf", x:700, y:450}, "killGame4.0", {url:HTTP + "pluggame/CowPlus.swf", x:0, y:0}, "PhotoRoom", {url:HTTP + "pluggame/LyingDicePlus.swf", x:0, y:0}, {url:HTTP + "pluggame/SpyGame.swf", x:0, y:0}, {url:HTTP + "pluggame/SpyGame.swf", x:0, y:0}, "killGame5.0", {url:HTTP + "pluggame/Landlords.swf", x:0, y:0});
            AdminBoxPath = HTTP + "admin/AdminBox.swf";
            AdminUserListPath = HTTP + "admin/AdminUserListBox.swf";
            AdminSoViewerPath = HTTP + "admin/SoViewerTreeBox.swf";
            AdminRoomUsersPath = HTTP + "admin/AdminRoomUserList.swf";
            return;
        }// end function

        public static function GetFileNameV(param1:String) : String
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = "?";
            if (param1 != null)
            {
                if (param1.indexOf("/") > -1)
                {
                    _loc_2 = param1.substring((param1.lastIndexOf("/") + 1), param1.lastIndexOf("."));
                }
                else
                {
                    _loc_2 = param1.substring(0, param1.lastIndexOf("."));
                }
                if (param1.indexOf("?") > -1)
                {
                    _loc_4 = "&";
                }
                _loc_3 = _loc_4 + "v=" + V + "." + uint(ChildV[_loc_2]);
                return _loc_3;
            }
            return param1;
        }// end function

    }
}
