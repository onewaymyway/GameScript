package Core.controller
{
    import Core.*;
    import Core.model.*;
    import Core.view.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class InitCommand extends SimpleCommand implements ICommand
    {

        public function InitCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = param1.getBody() as Object;
            facade.registerProxy(new NetProxy());
            facade.registerMediator(new ScenceLoaderMediator(_loc_2.frameOBJ5));
            facade.registerMediator(new PlusMediator(_loc_2.frameOBJ4));
            facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.LinesBoxPath);
            return;
        }// end function

    }
}
