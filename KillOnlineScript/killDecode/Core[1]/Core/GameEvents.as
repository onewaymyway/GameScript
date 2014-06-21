package Core
{

    public class GameEvents extends Object
    {
        public static var PlUSEVENT:Object = {ACTION:"plusaction"};
        public static var LOGINEVENT:Object = {LOGIN:"clientlgoin", LOGINOUT:"clientloginout"};
        public static var ALERTEVENT:Object = new Object();
        public static var LOADINGEVENT:Object = new Object();
        public static var LINESBOXEVENT:Object = new Object();
        public static var HALLEVENT:Object = new Object();
        public static var ROOMEVENT:Object = new Object();
        public static var FRIENDEVENT:Object = new Object();
        public static var NEWSLISTEVENT:Object = new Object();
        public static var MENUEVENT:Object = new Object();
        public static var NETEVENT:Object = {NETCALL:"NETCALL"};
        public static var NETCALL:String = "NETCALL";
        public static var CONNECTION_LOST:String = "CONNECTION_LOST";
        public static var ADMIN_NETCALL:String = "ADMIN_NETCALL";
        public static var CLOSE_CLINET:String = "GAMEVETS_CLOSE_CLINET";
        public static var SEVER_KICK:String = "GAMEVETS_SEVER_KICK";
        public static var AS_TO_JS_COMMAND:String = "AS_TO_JS_COMMAND";
        public static var JS_TO_AS_COMMAND:String = "JS_TO_AS_COMMAND";
        public static var USERMSGCOMM:String = "USER_MSG_COMM";
        public static var USERMSG:String = "Core_USERMSG";
        public static var USERMSGLB:String = "Core_USERMSG_LB";
        public static var USER_NEW_TASK_LOG:String = "Core_USER_NEW_TASK_LOG";
        public static var USERINFO:String = "Core_USERINFO";
        public static var ENTER_ROOM:String = "ENTER_ROOM";
        public static var ENTER_HALL:String = "ENTER_HALL";
        public static var REFRESH_WEB:String = "REFRESH_WEB";

        public function GameEvents()
        {
            return;
        }// end function

    }
}
