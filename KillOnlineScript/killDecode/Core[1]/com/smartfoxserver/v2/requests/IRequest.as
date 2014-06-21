package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.bitswarm.*;

    public interface IRequest
    {

        public function IRequest();

        function validate(param1:SmartFox) : void;

        function execute(param1:SmartFox) : void;

        function get targetController() : int;

        function set targetController(param1:int) : void;

        function get isEncrypted() : Boolean;

        function set isEncrypted(param1:Boolean) : void;

        function getMessage() : IMessage;

    }
}
