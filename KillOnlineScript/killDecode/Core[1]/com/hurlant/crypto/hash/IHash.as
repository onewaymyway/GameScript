package com.hurlant.crypto.hash
{
    import flash.utils.*;

    public interface IHash
    {

        public function IHash();

        function toString() : String;

        function getHashSize() : uint;

        function getInputSize() : uint;

        function hash(param1:ByteArray) : ByteArray;

    }
}
