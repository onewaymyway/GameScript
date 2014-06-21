package Core.view
{
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ScenceLoaderMediator extends Mediator
    {
        private var scence:Object;
        private var container:Sprite;
        private var loader:Loader;
        public static const NAME:String = "ScenceLoaderMediator";
        public static const LOAD:String = "Core_ScenceLoaderMediator_LOAD";

        public function ScenceLoaderMediator(param1:Object = null)
        {
            super(NAME, param1);
            return;
        }// end function

        override public function onRegister() : void
        {
            this.container = new Sprite();
            this.scence = new Object();
            this.getViewComponent().addChild(this.container);
            return;
        }// end function

        override public function onRemove() : void
        {
            this.clearContainer();
            this.getViewComponent().removeChild(this.container);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [LOAD];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:String = null;
            switch(param1.getName())
            {
                case LOAD:
                {
                    this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_PROMPTTITLE, "");
                    this.sendNotification(PlusMediator.CLOSEALL);
                    _loc_2 = param1.getBody() as String;
                    _loc_2 = _loc_2 + Resource.GetFileNameV(_loc_2);
                    if (this.scence[_loc_2])
                    {
                        this.addToContainer(this.scence[_loc_2]);
                    }
                    else
                    {
                        this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"读取场景资料..."});
                        if (this.loader == null)
                        {
                            this.loader = new Loader();
                            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadComplete);
                            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.loadProgressHandler);
                        }
                        this.loader.load(new URLRequest(_loc_2), new LoaderContext(false, ApplicationDomain.currentDomain));
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function loadProgressHandler(event:ProgressEvent) : void
        {
            var _loc_2:* = event.bytesLoaded / event.bytesTotal;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"读取场景资料...", p:"1/1", bar:_loc_2});
            return;
        }// end function

        private function loadComplete(event:Event) : void
        {
            var _loc_2:* = Resource.HTTP + Matlab.GetFileName(event.target.url);
            this.scence[_loc_2] = event.target.content;
            this.clearContainer();
            this.container.addChild(this.scence[_loc_2] as DisplayObject);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loadComplete);
            this.loader = null;
            return;
        }// end function

        private function addToContainer(param1:Object) : void
        {
            this.clearContainer();
            this.container.addChild(param1 as DisplayObject);
            param1.register();
            return;
        }// end function

        private function clearContainer() : void
        {
            var _loc_1:Object = null;
            while (this.container.numChildren > 0)
            {
                
                _loc_1 = this.container.getChildAt(0);
                _loc_1.remove();
                this.container.removeChildAt(0);
            }
            CleanMenory.clean();
            return;
        }// end function

    }
}
