package com.smartfoxserver.v2.controllers
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.bitswarm.*;
    import com.smartfoxserver.v2.core.*;
    import com.smartfoxserver.v2.entities.data.*;

    public class ExtensionController extends BaseController
    {
        private var sfs:SmartFox;
        private var bitSwarm:BitSwarmClient;
        public static const KEY_CMD:String = "c";
        public static const KEY_PARAMS:String = "p";

        public function ExtensionController(param1:BitSwarmClient)
        {
            this.bitSwarm = param1;
            this.sfs = param1.sfs;
            return;
        }// end function

        override public function handleMessage(param1:IMessage) : void
        {
            if (this.sfs.debug)
            {
                log.info(param1);
            }
            var _loc_2:* = param1.content;
            var _loc_3:Object = {};
            _loc_3.cmd = _loc_2.getUtfString(KEY_CMD);
            _loc_3.params = _loc_2.getSFSObject(KEY_PARAMS);
            if (param1.isUDP)
            {
                _loc_3.packetId = param1.packetId;
            }
            this.sfs.dispatchEvent(new SFSEvent(SFSEvent.EXTENSION_RESPONSE, _loc_3));
            return;
        }// end function

    }
}
