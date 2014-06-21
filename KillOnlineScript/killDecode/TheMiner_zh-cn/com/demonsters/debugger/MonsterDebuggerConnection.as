package com.demonsters.debugger
{

    class MonsterDebuggerConnection extends Object
    {
        private static var connector:IMonsterDebuggerConnection;

        function MonsterDebuggerConnection()
        {
            return;
        }// end function

        static function initialize() : void
        {
            connector = new MonsterDebuggerConnectionDefault();
            return;
        }// end function

        static function set address(value:String) : void
        {
            connector.com.demonsters.debugger:IMonsterDebuggerConnection::address = value;
            return;
        }// end function

        static function set onConnect(value:Function) : void
        {
            connector.com.demonsters.debugger:IMonsterDebuggerConnection::onConnect = value;
            return;
        }// end function

        static function get connected() : Boolean
        {
            return connector.com.demonsters.debugger:IMonsterDebuggerConnection::connected;
        }// end function

        static function processQueue() : void
        {
            connector.com.demonsters.debugger:IMonsterDebuggerConnection::processQueue();
            return;
        }// end function

        static function send(id:String, data:Object, direct:Boolean = false) : void
        {
            connector.com.demonsters.debugger:IMonsterDebuggerConnection::send(id, data, direct);
            return;
        }// end function

        static function connect() : void
        {
            connector.com.demonsters.debugger:IMonsterDebuggerConnection::connect();
            return;
        }// end function

    }
}
