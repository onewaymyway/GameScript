package com.junkbyte.console.vos
{
    import flash.utils.*;

    public class Log extends Object
    {
        public var line:uint;
        public var text:String;
        public var ch:String;
        public var priority:int;
        public var repeat:Boolean;
        public var html:Boolean;
        public var time:uint;
        public var timeStr:String;
        public var lineStr:String;
        public var chStr:String;
        public var next:Log;
        public var prev:Log;

        public function Log(txt:String, cc:String, pp:int, repeating:Boolean = false, ishtml:Boolean = false)
        {
            this.text = txt;
            this.ch = cc;
            this.priority = pp;
            this.repeat = repeating;
            this.html = ishtml;
            return;
        }// end function

        public function writeToBytes(bytes:ByteArray) : void
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(this.text);
            bytes.writeUnsignedInt(_loc_2.length);
            bytes.writeBytes(_loc_2);
            bytes.writeUTF(this.ch);
            bytes.writeInt(this.priority);
            bytes.writeBoolean(this.repeat);
            return;
        }// end function

        public function plainText() : String
        {
            return this.text.replace(/<.*?>""<.*?>/g, "").replace(/&lt;""&lt;/g, "<").replace(/&gt;""&gt;/g, ">");
        }// end function

        public function toString() : String
        {
            return "[" + this.ch + "] " + this.plainText();
        }// end function

        public function clone() : Log
        {
            var _loc_1:* = new Log(this.text, this.ch, this.priority, this.repeat, this.html);
            _loc_1.line = this.line;
            _loc_1.time = this.time;
            return _loc_1;
        }// end function

        public static function FromBytes(bytes:ByteArray) : Log
        {
            var _loc_2:* = bytes.readUTFBytes(bytes.readUnsignedInt());
            var _loc_3:* = bytes.readUTF();
            var _loc_4:* = bytes.readInt();
            var _loc_5:* = bytes.readBoolean();
            return new Log(_loc_2, _loc_3, _loc_4, _loc_5, true);
        }// end function

    }
}
