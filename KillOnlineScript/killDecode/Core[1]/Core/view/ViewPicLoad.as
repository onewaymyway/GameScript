package Core.view
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class ViewPicLoad extends Object
    {
        public static var context:LoaderContext = new LoaderContext();
        public static var loadI:uint = 0;
        public static var loader:Loader = null;
        public static var picsArr:Array = new Array();
        public static var errTimes:uint = 0;
        public static var isLoading:Boolean = false;

        public function ViewPicLoad()
        {
            return;
        }// end function

        public static function load(param1:String, param2:Object) : void
        {
            if (param1 != null && param1 != "null" && param1 != "")
            {
                picsArr.push({url:param1, mc:param2});
            }
            if (!isLoading)
            {
                goLoad();
            }
            return;
        }// end function

        public static function configureListeners(param1:IEventDispatcher) : void
        {
            param1.addEventListener(Event.COMPLETE, completeHandler);
            param1.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
            return;
        }// end function

        public static function reconfigureListeners(param1:IEventDispatcher) : void
        {
            param1.removeEventListener(Event.COMPLETE, completeHandler);
            param1.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
            return;
        }// end function

        public static function goLoad() : void
        {
            if (picsArr.length > 0)
            {
                isLoading = true;
                if (loader == null)
                {
                    loader = new Loader();
                    configureListeners(loader.contentLoaderInfo);
                }
                loader.load(new URLRequest(picsArr[0].url), context);
            }
            else
            {
                loader = null;
                isLoading = false;
            }
            return;
        }// end function

        public static function completeHandler(event:Event) : void
        {
            if (event.target.content is AVM1Movie)
            {
                reconfigureListeners(loader.contentLoaderInfo);
                picsArr[0].mc.addChild(loader);
                loader = null;
            }
            else
            {
                picsArr[0].mc.addChild(loader.content);
            }
            picsArr.shift();
            goLoad();
            return;
        }// end function

        public static function ioErrorHandler(event:Event) : void
        {
            var _loc_3:* = errTimes + 1;
            errTimes = _loc_3;
            if (errTimes < 3)
            {
                errTimes = 0;
                picsArr.shift();
            }
            goLoad();
            return;
        }// end function

        public static function securityHandler(event:Event) : void
        {
            trace(event);
            return;
        }// end function

        context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
        context.checkPolicyFile = true;
        context.securityDomain = SecurityDomain.currentDomain;
    }
}
