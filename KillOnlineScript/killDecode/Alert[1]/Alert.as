package 
{
    import Alert.*;
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import view.*;

    public class Alert extends Sprite
    {
        private var myFacade:MyFacade;

        public function Alert()
        {
            this.myFacade = MyFacade.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.register);
            return;
        }// end function

        public function register(event:Event) : void
        {
            this.myFacade.registerMediator(new AlertMainMediator(this));
            return;
        }// end function

    }
}
