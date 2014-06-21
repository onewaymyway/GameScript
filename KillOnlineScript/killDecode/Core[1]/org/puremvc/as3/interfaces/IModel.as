package org.puremvc.as3.interfaces
{

    public interface IModel
    {

        public function IModel();

        function retrieveProxy(param1:String) : IProxy;

        function disposeSome(param1:Function) : void;

        function hasProxy(param1:String) : Boolean;

        function removeProxy(param1:String) : IProxy;

        function registerProxy(param1:IProxy) : void;

        function dispose() : void;

    }
}
