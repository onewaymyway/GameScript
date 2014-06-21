package uas
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class LoadSwfToMc extends Sprite
    {
        private var request:URLRequest;
        private var loader:Loader;
        private var picPath:String;
        private var toMC:Object;
        private var toMC2:Object;
        private var MCOBJ:Object;
        public var i:Number;
        private var loadTimes:uint = 0;
        public var loadedBtyes:uint = 0;
        public var totalBtyes:uint = 0;
        private var App:ApplicationDomain;

        public function LoadSwfToMc(param1:ApplicationDomain = null) : void
        {
            this.App = param1;
            this.request = new URLRequest();
            this.loader = new Loader();
            return;
        }// end function

        public function load(param1:String, param2:Object) : void
        {
            this.toMC = param2;
            this.picPath = param1;
            this.initView();
            return;
        }// end function

        private function initView() : void
        {
            var _loc_1:LoaderContext = null;
            this.request.url = this.picPath;
            try
            {
                _loc_1 = new LoaderContext();
                if (this.App)
                {
                    _loc_1.applicationDomain = this.App;
                }
                else
                {
                    _loc_1.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                }
                _loc_1.checkPolicyFile = true;
                _loc_1.securityDomain = SecurityDomain.currentDomain;
                this.loader.load(this.request, _loc_1);
                var _loc_2:String = this;
                var _loc_3:* = this.loadTimes + 1;
                _loc_2.loadTimes = _loc_3;
            }
            catch (err:Error)
            {
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
            var _loc_2:* = this.loader.content;
            var _loc_3:* = this.toMC.addChild(_loc_2);
            dispatchEvent(new Event(Event.COMPLETE));
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
            return;
        }// end function

        private function objClone(param1:Object)
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeObject(param1);
            _loc_2.position = 0;
            trace("copyObj" + _loc_2.length);
            return _loc_2.readObject();
        }// end function

    }
}
