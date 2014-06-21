package org.puremvc.as3.patterns.mediator
{
    import flash.display.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.observer.*;

    public class Mediator extends Notifier implements IMediator, INotifier
    {
        protected var viewComponent:Object;
        protected var mediatorName:String;
        public static const NAME:String = "Mediator";

        public function Mediator(param1:String = null, param2:Object = null)
        {
            this.mediatorName = param1 != null ? (param1) : (NAME);
            this.viewComponent = param2;
            return;
        }// end function

        public function listNotificationInterests() : Array
        {
            return [];
        }// end function

        public function onRegister() : void
        {
            return;
        }// end function

        public function onRemove() : void
        {
            return;
        }// end function

        public function getViewComponent() : Object
        {
            return viewComponent;
        }// end function

        public function handleNotification(param1:INotification) : void
        {
            return;
        }// end function

        public function getMediatorName() : String
        {
            return mediatorName;
        }// end function

        protected function get main() : Sprite
        {
            return viewComponent as Sprite;
        }// end function

        public function setViewComponent(param1:Object) : void
        {
            this.viewComponent = param1;
            return;
        }// end function

    }
}
