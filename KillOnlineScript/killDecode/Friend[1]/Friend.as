package 
{
    import Core.*;
    import Core.view.*;
    import Friend.*;
    import flash.display.*;
    import flash.events.*;
    import view.*;

    public class Friend extends Sprite
    {
        private var myFacade:MyFacade;

        public function Friend()
        {
            this.myFacade = MyFacade.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            return;
        }// end function

        private function init(event:Event) : void
        {
            this.myFacade.registerMediator(new FriendMediator(this));
            return;
        }// end function

        public function register() : void
        {
            return;
        }// end function

        public function remove() : void
        {
            this.myFacade.sendNotification(PlusMediator.CLOSE, {url:Resource.FriendPath});
            return;
        }// end function

        public function removeHandler(event:Event) : void
        {
            if (this.myFacade.hasMediator(FriendMediator.NAME))
            {
                this.myFacade.removeMediator(FriendMediator.NAME);
            }
            return;
        }// end function

    }
}
