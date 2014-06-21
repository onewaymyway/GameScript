package Core.so
{
    import Core.*;
    import flash.events.*;

    dynamic public class SO extends EventDispatcher
    {
        public var name:String = "";
        private var myFacade:MyFacade;
        public var data:Object;

        public function SO(param1:String)
        {
            this.myFacade = MyFacade.getInstance();
            this.name = param1;
            return;
        }// end function

        public function connect(param1:Object = null) : void
        {
            this.data = new Object();
            var _loc_2:Object = {cmd:"SOCmd_Sync", Type:"connect", Name:this.name};
            this.myFacade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function close() : void
        {
            this.data = null;
            var _loc_1:Object = {cmd:"SOCmd_Sync", Type:"close", Name:this.name};
            this.myFacade.sendNotification(GameEvents.NETCALL, _loc_1);
            return;
        }// end function

    }
}
