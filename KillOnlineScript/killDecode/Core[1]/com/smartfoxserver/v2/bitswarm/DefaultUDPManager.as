package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.logging.*;
    import flash.utils.*;

    public class DefaultUDPManager extends Object implements IUDPManager
    {
        private var _sfs:SmartFox;
        private var _log:Logger;

        public function DefaultUDPManager(param1:SmartFox)
        {
            this._sfs = param1;
            this._log = Logger.getInstance();
            return;
        }// end function

        public function initialize(param1:String, param2:int) : void
        {
            this.logUsageError();
            return;
        }// end function

        public function nextUdpPacketId() : Number
        {
            return -1;
        }// end function

        public function send(param1:ByteArray) : void
        {
            this.logUsageError();
            return;
        }// end function

        public function get inited() : Boolean
        {
            return false;
        }// end function

        public function set sfs(param1:SmartFox) : void
        {
            return;
        }// end function

        public function reset() : void
        {
            return;
        }// end function

        private function logUsageError() : void
        {
            if (this._sfs.udpAvailable)
            {
                this._log.warn("UDP protocol is not initialized yet. Pleas use the initUDP() method. If you have any doubts please refer to the documentation of initUDP()");
            }
            else
            {
                this._log.warn("You are not currently enabled to use UDP protocol. UDP is available only for Air 2 runtime and higher.");
            }
            return;
        }// end function

    }
}
