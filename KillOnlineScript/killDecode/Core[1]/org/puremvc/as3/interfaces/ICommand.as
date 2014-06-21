package org.puremvc.as3.interfaces
{

    public interface ICommand
    {

        public function ICommand();

        function execute(param1:INotification) : void;

    }
}
