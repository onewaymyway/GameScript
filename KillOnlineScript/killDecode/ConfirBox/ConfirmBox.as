package 
{
    import ConfirmBox.*;
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import view.*;

    public class ConfirmBox extends Sprite
    {
        private var myFacade:MyFacade;

        public function ConfirmBox()
        {
            this.myFacade = MyFacade.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event) : void
        {
            var _loc_2:ConfirmBoxMediator = null;
            if (this.myFacade.hasMediator(ConfirmBoxMediator.NAME))
            {
                _loc_2 = this.myFacade.retrieveMediator(ConfirmBoxMediator.NAME) as ConfirmBoxMediator;
            }
            else
            {
                this.myFacade.registerMediator(new ConfirmBoxMediator(this.parent));
                this.myFacade.registerMediator(new HonorOnlineBoxMediator(this.parent));
            }
            return;
        }// end function

        public function register() : void
        {
            return;
        }// end function

        public function remove() : void
        {
            if (this.myFacade.hasMediator(ConfirmBoxMediator.NAME))
            {
                this.myFacade.removeMediator(ConfirmBoxMediator.NAME);
            }
            return;
        }// end function

    }
}
