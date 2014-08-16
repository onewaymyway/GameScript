package 
{
    import Core.*;
    import Core.view.*;
    import Task.*;
    import flash.display.*;
    import flash.events.*;
    import taskbox.view.*;

    public class Task extends Sprite
    {
        private var myFacade:MyFacade;
        private var thisUrl:String;

        public function Task()
        {
            this.thisUrl = Resource.HTTP + "Task.swf";
            this.myFacade = MyFacade.getInstance();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            return;
        }// end function

        private function init(event:Event) : void
        {
            var _loc_2:MainMediator = null;
            if (this.myFacade.hasMediator(MainMediator.NAME))
            {
                _loc_2 = this.myFacade.retrieveMediator(MainMediator.NAME) as MainMediator;
                _loc_2.init();
            }
            else
            {
                this.myFacade.registerMediator(new MainMediator(this));
            }
            return;
        }// end function

        public function register() : void
        {
            return;
        }// end function

        public function remove() : void
        {
            if (this.myFacade.hasMediator(MainMediator.NAME))
            {
                this.myFacade.removeMediator(MainMediator.NAME);
            }
            this.myFacade.sendNotification(PlusMediator.CLOSE, {url:this.thisUrl});
            return;
        }// end function

        public function removeHandler(event:Event) : void
        {
            if (this.myFacade.hasMediator(MainMediator.NAME))
            {
                this.myFacade.removeMediator(MainMediator.NAME);
            }
            return;
        }// end function

    }
}
