package Core
{
    import Core.controller.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.system.*;
    import flash.utils.*;
    import org.puremvc.as3.patterns.facade.*;
    import uas.*;

    public class MyFacade extends Facade implements IFacade
    {
        public static var Main:Sprite;
        private static var _instance:MyFacade;
        public static var STARTUP:String = "STARTUP";
        public static var NETCALL:String = "NETCALL";

        public function MyFacade()
        {
            return;
        }// end function

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(GameEvents.REFRESH_WEB, ReFreshCommand);
            registerCommand(NETCALL, NetCommand);
            registerCommand(GameEvents.ADMIN_NETCALL, AdminNetCommand);
            registerCommand(GameEvents.JS_TO_AS_COMMAND, JsToAsCommand);
            registerCommand(GameEvents.LOGINEVENT.LOGIN, LoginCommand);
            registerCommand(GameEvents.LOGINEVENT.LOGINOUT, LoginOutCommand);
            registerCommand(GameEvents.CLOSE_CLINET, CloseClientCommand);
            registerCommand(STARTUP, InitCommand);
            ExternalInterface.addCallback("ReloadMyInfo", this.ReloadMyInfo);
            ExternalInterface.addCallback("closevideo", this.CloseVideo);
            ExternalInterface.addCallback("JsCmd", this.JsToAsCmd);
            return;
        }// end function

        private function ReloadMyInfo() : void
        {
            var _loc_1:* = new Object();
            _loc_1.cmd = "ReloadMyInfo";
            sendNotification(GameEvents.NETCALL, _loc_1);
            return;
        }// end function

        private function CloseVideo() : void
        {
            var _loc_1:* = new Object();
            _loc_1.cmd = "VoiceCmd_Close";
            sendNotification(GameEvents.NETCALL, _loc_1);
            return;
        }// end function

        private function JsToAsCmd(param1:Boolean, param2:Object) : void
        {
            if (param1)
            {
                if (Resource.JC.indexOf(String(param2.cmd)) > -1)
                {
                    this.sendNotification(NETCALL, param2);
                }
            }
            else
            {
                this.sendNotification(GameEvents.JS_TO_AS_COMMAND, param2);
            }
            return;
        }// end function

        public function LoadBaseView(param1:Sprite) : void
        {
            MainData.MainStage = param1.stage as Stage;
            Main = param1;
            var _loc_2:* = new LoadSwfToMc();
            _loc_2.load(Resource.LoadingPath + Resource.GetFileNameV(Resource.LoadingPath), Main["frameOBJ" + 2]);
            _loc_2.addEventListener("complete", this.complatehandler);
            return;
        }// end function

        private function complatehandler(event:Event) : void
        {
            new BaseViewLoad(Main);
            return;
        }// end function

        public function startup() : void
        {
            MainView.ALT = new alt_mc();
            MainView.DRAG = new ViewDrag();
            sendNotification(STARTUP, Main);
            return;
        }// end function

        private function viewerMemory() : void
        {
            var _loc_1:* = new Timer(3000);
            _loc_1.addEventListener(TimerEvent.TIMER, this.viewerMemoryTimerHandler);
            _loc_1.start();
            return;
        }// end function

        private function viewerMemoryTimerHandler(event:Event) : void
        {
            trace("NOW_totalMemory-" + System.totalMemory / 1024 / 1024 + "M" + MainData.newUserTaskData.nowId);
            return;
        }// end function

        public static function getInstance() : MyFacade
        {
            if (_instance == null)
            {
                _instance = new MyFacade;
            }
            return _instance as MyFacade;
        }// end function

    }
}
