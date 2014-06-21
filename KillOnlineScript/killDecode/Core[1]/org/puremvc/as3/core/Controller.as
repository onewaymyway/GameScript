package org.puremvc.as3.core
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.observer.*;

    public class Controller extends Object implements IController
    {
        protected var commandMap:Array;
        protected var view:IView;
        protected const SINGLETON_MSG:String = "Controller Singleton already constructed!";
        static var instance:IController;

        public function Controller()
        {
            if (instance != null)
            {
                throw Error(SINGLETON_MSG);
            }
            instance = this;
            commandMap = new Array();
            initializeController();
            return;
        }// end function

        public function removeCommand(param1:String) : void
        {
            if (hasCommand(param1))
            {
                view.removeObserver(param1, this);
                commandMap[param1] = null;
            }
            return;
        }// end function

        public function registerCommand(param1:String, param2:Class) : void
        {
            if (commandMap[param1] == null)
            {
                view.registerObserver(param1, new Observer(executeCommand, this));
            }
            commandMap[param1] = param2;
            return;
        }// end function

        protected function initializeController() : void
        {
            view = View.getInstance();
            return;
        }// end function

        public function hasCommand(param1:String) : Boolean
        {
            return commandMap[param1] != null;
        }// end function

        public function executeCommand(param1:INotification) : void
        {
            var _loc_2:* = commandMap[param1.getName()];
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = new _loc_2;
            _loc_3.execute(param1);
            return;
        }// end function

        public static function getInstance() : IController
        {
            if (instance == null)
            {
                instance = new Controller;
            }
            return instance;
        }// end function

    }
}
