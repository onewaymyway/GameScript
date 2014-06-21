package uas
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class LoadSwfsrc extends EventDispatcher
    {
        private var request:URLRequest;
        private var loader:Loader;
        private var picPath:String;
        private var toMC:Object;
        public var swfsrc:Object;
        public var i:Number;
        private var loadTimes:uint = 0;
        public var loadedBtyes:uint = 0;
        public var totalBtyes:uint = 0;
        public var classMc:Array;
        private var className:Array;
        private var App:ApplicationDomain;
        public var onLoad:Function;

        public function LoadSwfsrc(param1:ApplicationDomain = null) : void
        {
            this.classMc = new Array();
            this.onLoad = function (param1) : void
            {
                return;
            }// end function
            ;
            this.App = param1;
            this.request = new URLRequest();
            this.loader = new Loader();
            return;
        }// end function

        public function load(param1:String) : void
        {
            this.picPath = param1;
            this.initView();
            return;
        }// end function

        private function initView() : void
        {
            this.request.url = this.picPath;
            try
            {
                if (this.App)
                {
                    this.loader.load(this.request, new LoaderContext(false, this.App));
                }
                else
                {
                    this.loader.load(this.request, new LoaderContext(false, ApplicationDomain.currentDomain));
                }
                var _loc_2:String = this;
                var _loc_3:* = this.loadTimes + 1;
                _loc_2.loadTimes = _loc_3;
            }
            catch (err:Error)
            {
                trace("load err:" + err);
            }
            this.configureListeners(this.loader.contentLoaderInfo);
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
            dispatchEvent(new Event("complete"));
            return;
        }// end function

        private function progressHandler(event:ProgressEvent) : void
        {
            this.loadedBtyes = event.bytesLoaded;
            this.totalBtyes = event.bytesTotal;
            dispatchEvent(new Event("progress"));
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            if (this.loadTimes < 3)
            {
                this.initView();
            }
            else
            {
                dispatchEvent(new Event("err"));
            }
            trace("error:" + event);
            return;
        }// end function

    }
}
