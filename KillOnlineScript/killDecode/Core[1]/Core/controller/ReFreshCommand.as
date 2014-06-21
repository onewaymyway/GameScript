package Core.controller
{
    import Core.*;
    import flash.external.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class ReFreshCommand extends SimpleCommand implements ICommand
    {

        public function ReFreshCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            ExternalInterface.call("location.reload", true);
            var _loc_2:Object = {msg:"与服务器断开，请刷新面面", code:GameEvents.REFRESH_WEB, obj:null};
            sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            return;
        }// end function

    }
}
