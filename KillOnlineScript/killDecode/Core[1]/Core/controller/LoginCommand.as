package Core.controller
{
    import Core.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class LoginCommand extends SimpleCommand implements ICommand
    {

        public function LoginCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:NetProxy = null;
            _loc_2 = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            _loc_2.login();
            return;
        }// end function

    }
}
