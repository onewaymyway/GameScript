package com.smartfoxserver.v2.protocol.serialization
{
    import com.smartfoxserver.v2.entities.data.*;
    import flash.utils.*;

    public interface ISFSDataSerializer
    {

        public function ISFSDataSerializer();

        function object2binary(param1:ISFSObject) : ByteArray;

        function array2binary(param1:ISFSArray) : ByteArray;

        function binary2object(param1:ByteArray) : ISFSObject;

        function binary2array(param1:ByteArray) : ISFSArray;

    }
}
