package uas
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class LoadPic extends EventDispatcher
    {
        private var loader:Loader;
        private var lc:LoaderContext;
        private var toMc:Object;
        public var bytesLoaded:uint = 0;
        public var bytesTotal:uint = 0;
        public var data:Object;
        private var isAutoRemove:Boolean = true;
        private var W:int = 0;
        private var H:int = 0;
        public static var COMPLETE:String = "LoadPic_COMPLETE";
        public static var PROGRESS:String = "LoadPic_PROGRESS";
        public static var ERROR:String = "LoadPic_ERROR";

        public function LoadPic(param1:Boolean = true) : void
        {
            this.loader = new Loader();
            this.lc = new LoaderContext(true);
            this.isAutoRemove = param1;
            this.configureListeners(this.loader.contentLoaderInfo);
            return;
        }// end function

        public function load(param1:String, param2:Object = null, param3:int = 0, param4:int = 0) : void
        {
            this.W = param3;
            this.H = param4;
            this.toMc = param2;
            if (param2 && this.isAutoRemove)
            {
                param2.addEventListener(Event.REMOVED_FROM_STAGE, this.mcRemoveHandler);
            }
            this.loader.load(new URLRequest(param1), this.lc);
            return;
        }// end function

        private function mcRemoveHandler(event:Event) : void
        {
            this.loader.unload();
            return;
        }// end function

        private function configureListeners(param1:IEventDispatcher) : void
        {
            param1.addEventListener(Event.COMPLETE, this.completeHandler);
            param1.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
            param1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            if (this.toMc)
            {
                this.toMc.addChild(this.loader);
            }
            if (this.W != 0)
            {
                this.toMc.width = this.W;
            }
            if (this.H != 0)
            {
                this.toMc.height = this.H;
            }
            this.data = this.loader;
            dispatchEvent(new Event(COMPLETE));
            return;
        }// end function

        private function progressHandler(event:ProgressEvent) : void
        {
            this.bytesLoaded = event.bytesLoaded;
            this.bytesTotal = event.bytesTotal;
            dispatchEvent(new Event(PROGRESS));
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            dispatchEvent(new Event(ERROR));
            trace("error:" + event);
            return;
        }// end function

    }
}
