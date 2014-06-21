package Core.view
{
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class URLoader extends EventDispatcher
    {

        public function URLoader()
        {
            return;
        }// end function

        public function load(param1:URLRequest) : void
        {
            var _loc_2:* = new URLLoader();
            _loc_2.dataFormat = URLLoaderDataFormat.BINARY;
            _loc_2.addEventListener(Event.COMPLETE, this.onLoaded0Handler);
            _loc_2.addEventListener(IOErrorEvent.IO_ERROR, this.onERR0Handler);
            _loc_2.load(new URLRequest(Resource.HTTP + "killerlib.swf"));
            return;
        }// end function

        private function onLoaded0Handler(event:Event) : void
        {
            var _loader:Loader;
            var loaderContext:LoaderContext;
            var e:* = event;
            var data:* = URLLoader(e.target).data as ByteArray;
            if (data is ByteArray)
            {
                try
                {
                    ByteArray(data).uncompress();
                    _loader = new Loader();
                    loaderContext = new LoaderContext();
                    loaderContext.applicationDomain = ApplicationDomain.currentDomain;
                    _loader.loadBytes(data, loaderContext);
                    _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.load0Complete);
                }
                catch (e:Error)
                {
                    this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                    trace("应用程序文件损坏#01" + e);
                }
            }
            return;
        }// end function

        private function onERR0Handler(event:Event) : void
        {
            this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            trace("应用程序文件损坏#01");
            return;
        }// end function

        private function load0Complete(event:Event) : void
        {
            this.dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

    }
}
