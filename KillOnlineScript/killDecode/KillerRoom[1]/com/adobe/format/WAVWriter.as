package com.adobe.format
{
    import flash.utils.*;

    public class WAVWriter extends Object
    {
        private var tempValueSum:Number = 0;
        private var tempValueCount:int = 0;
        public var samplingRate:Number = 44100;
        public var sampleBitRate:int = 16;
        public var numOfChannels:int = 2;
        private var compressionCode:int = 1;

        public function WAVWriter()
        {
            return;
        }// end function

        private function header(param1:IDataOutput, param2:Number) : void
        {
            param1.writeUTFBytes("RIFF");
            param1.writeUnsignedInt(param2);
            param1.writeUTFBytes("WAVE");
            param1.writeUTFBytes("fmt ");
            param1.writeUnsignedInt(16);
            param1.writeShort(this.compressionCode);
            param1.writeShort(this.numOfChannels);
            param1.writeUnsignedInt(this.samplingRate);
            param1.writeUnsignedInt(this.samplingRate * this.numOfChannels * this.sampleBitRate / 8);
            param1.writeShort(this.numOfChannels * this.sampleBitRate / 8);
            param1.writeShort(this.sampleBitRate);
            return;
        }// end function

        public function processSamples(param1:IDataOutput, param2:ByteArray, param3:int, param4:int = 1) : void
        {
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:int = 0;
            var _loc_17:int = 0;
            var _loc_18:Number = NaN;
            var _loc_19:int = 0;
            var _loc_20:int = 0;
            if (!param2 || param2.bytesAvailable <= 0)
            {
                throw new Error("No audio data");
            }
            var _loc_5:* = Math.pow(2, this.sampleBitRate) / 2 - 1;
            var _loc_6:* = this.samplingRate / param3;
            var _loc_7:* = param2.length / 4 * _loc_6 * this.sampleBitRate / 8;
            var _loc_8:* = 32 + 8 + _loc_7;
            param1.endian = Endian.LITTLE_ENDIAN;
            this.header(param1, _loc_8);
            param1.writeUTFBytes("data");
            param1.writeUnsignedInt(_loc_7);
            param2.position = 0;
            var _loc_9:* = new ByteArray();
            new ByteArray().endian = Endian.LITTLE_ENDIAN;
            while (param2.bytesAvailable > 0)
            {
                
                _loc_9.clear();
                _loc_10 = Math.min(param2.bytesAvailable / 4, 8192);
                _loc_11 = _loc_10;
                _loc_12 = 100;
                _loc_13 = (_loc_6 - Math.floor(_loc_6)) * _loc_12;
                _loc_14 = Math.ceil(_loc_6);
                _loc_15 = Math.floor(_loc_6);
                _loc_16 = 0;
                _loc_17 = this.numOfChannels - param4;
                _loc_18 = 0;
                _loc_19 = 0;
                while (_loc_19 < _loc_11)
                {
                    
                    _loc_18 = param2.readFloat();
                    if (_loc_18 > 1 || _loc_18 < -1)
                    {
                        throw new Error("Audio samples not in float format");
                    }
                    if (this.sampleBitRate == 8)
                    {
                        _loc_18 = _loc_5 * _loc_18 + _loc_5;
                    }
                    else
                    {
                        _loc_18 = _loc_5 * _loc_18;
                    }
                    _loc_16 = _loc_13 > 0 && _loc_19 % _loc_12 < _loc_13 ? (_loc_14) : (_loc_15);
                    _loc_20 = 0;
                    while (_loc_20 < _loc_16)
                    {
                        
                        this.writeCorrectBits(_loc_9, _loc_18, _loc_17);
                        _loc_20++;
                    }
                    _loc_19 = _loc_19 + 4;
                }
                param1.writeBytes(_loc_9);
            }
            return;
        }// end function

        private function writeCorrectBits(param1:ByteArray, param2:Number, param3:int) : void
        {
            if (param3 < 0)
            {
                if (this.tempValueCount + param3 == 1)
                {
                    param2 = int(this.tempValueSum / this.tempValueCount);
                    this.tempValueSum = 0;
                    this.tempValueCount = 0;
                    param3 = 1;
                }
                else
                {
                    this.tempValueSum = this.tempValueSum + param2;
                    var _loc_5:String = this;
                    var _loc_6:* = this.tempValueCount + 1;
                    _loc_5.tempValueCount = _loc_6;
                    return;
                }
            }
            else
            {
                param3++;
            }
            var _loc_4:int = 0;
            while (_loc_4 < param3)
            {
                
                if (this.sampleBitRate == 8)
                {
                    param1.writeByte(param2);
                }
                else if (this.sampleBitRate == 16)
                {
                    param1.writeShort(param2);
                }
                else if (this.sampleBitRate == 24)
                {
                    param1.writeByte(param2 & 255);
                    param1.writeByte(param2 >>> 8 & 255);
                    param1.writeByte(param2 >>> 16 & 255);
                }
                else if (this.sampleBitRate == 32)
                {
                    param1.writeInt(param2);
                }
                else
                {
                    throw new Error("Sample bit rate not supported");
                }
                _loc_4++;
            }
            return;
        }// end function

    }
}
