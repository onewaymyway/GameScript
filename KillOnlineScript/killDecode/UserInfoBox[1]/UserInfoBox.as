package 
{
    import Core.*;
    import UserInfoBox.*;
    import flash.display.*;
    import flash.events.*;
    import view.*;

    public class UserInfoBox extends Sprite
    {
        private var myFacade:MyFacade;

        public function UserInfoBox()
        {
            this.myFacade = MyFacade.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event) : void
        {
            var _loc_2:UserInfoBoxMediator = null;
            if (this.myFacade.hasMediator(UserInfoBoxMediator.NAME))
            {
                _loc_2 = this.myFacade.retrieveMediator(UserInfoBoxMediator.NAME) as UserInfoBoxMediator;
            }
            else
            {
                this.myFacade.registerMediator(new UserInfoBoxMediator(this.parent));
            }
            return;
        }// end function

        public function register() : void
        {
            return;
        }// end function

        public function remove() : void
        {
            if (this.myFacade.hasMediator(UserInfoBoxMediator.NAME))
            {
                this.myFacade.removeMediator(UserInfoBoxMediator.NAME);
            }
            return;
        }// end function

    }
}
