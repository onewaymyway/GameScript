﻿package org.puremvc.as3.interfaces
{

    public interface INotifier
    {

        public function INotifier();

        function sendNotification(param1:String, param2:Object = null, param3:String = null) : void;

    }
}
