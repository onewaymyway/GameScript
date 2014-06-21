package org.puremvc.as3.patterns.observer
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.facade.*;

    public class Notifier extends Object implements INotifier
    {
        protected var facade:IFacade;

        public function Notifier()
        {
            facade = Facade.getInstance();
            return;
        }// end function

        public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
        {
            facade.sendNotification(param1, param2, param3);
            return;
        }// end function

    }
}
