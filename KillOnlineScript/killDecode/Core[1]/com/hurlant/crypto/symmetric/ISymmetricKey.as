package com.hurlant.crypto.symmetric
{
    import flash.utils.*;

    public interface ISymmetricKey
    {

        public function ISymmetricKey();

        function encrypt(param1:ByteArray, param2:uint = 0) : void;

        function dispose() : void;

        function getBlockSize() : uint;

        function toString() : String;

        function decrypt(param1:ByteArray, param2:uint = 0) : void;

    }
}
