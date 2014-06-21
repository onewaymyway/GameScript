package com.demonsters.debugger
{

    interface IMonsterDebuggerConnection
    {

        function IMonsterDebuggerConnection();

        function set address(value:String) : void;

        function set onConnect(value:Function) : void;

        function get connected() : Boolean;

        function processQueue() : void;

        function send(id:String, data:Object, direct:Boolean = false) : void;

        function connect() : void;

    }
}
