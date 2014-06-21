package org.puremvc.as3.patterns.proxy
{
    import org.puremvc.as3.patterns.observer.*;

    public class Proxy extends Notifier implements IProxy, INotifier
    {
        protected var data:Object;
        protected var proxyName:String;
        public static var NAME:String = "Proxy";

        public function Proxy(param1:String = null, param2:Object = null)
        {
            this.proxyName = param1 != null ? (param1) : (NAME);
            if (param2 != null)
            {
                setData(param2);
            }
            return;
        }// end function

        public function getData() : Object
        {
            return data;
        }// end function

        public function setData(param1:Object) : void
        {
            this.data = param1;
            return;
        }// end function

        public function onRegister() : void
        {
            return;
        }// end function

        public function getProxyName() : String
        {
            return proxyName;
        }// end function

        public function onRemove() : void
        {
            return;
        }// end function

    }
}
