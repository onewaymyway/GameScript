﻿package Core.controller
{
    import Core.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class KickClientCommand extends SimpleCommand implements ICommand
    {

        public function KickClientCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = param1.getBody() as Object;
            var _loc_3:* = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            _loc_3.kickClient(_loc_2);
            return;
        }// end function

    }
}
