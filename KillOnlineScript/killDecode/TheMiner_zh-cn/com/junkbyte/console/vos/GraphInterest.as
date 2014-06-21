package com.junkbyte.console.vos
{
    import com.junkbyte.console.core.*;
    import flash.utils.*;

    public class GraphInterest extends Object
    {
        private var _ref:WeakRef;
        public var _prop:String;
        private var _getValueMethod:Function;
        private var useExec:Boolean;
        public var key:String;
        public var col:Number;

        public function GraphInterest(keystr:String = "", color:Number = 0) : void
        {
            this.col = color;
            this.key = keystr;
            return;
        }// end function

        public function setObject(object:Object, property:String) : Number
        {
            this._ref = new WeakRef(object);
            this._prop = property;
            this._getValueMethod = this.getAppropriateGetValueMethod();
            return this.getCurrentValue();
        }// end function

        public function setGetValueCallback(callback:Function) : void
        {
            if (callback == null)
            {
                this._getValueMethod = this.getAppropriateGetValueMethod();
            }
            else
            {
                this._getValueMethod = callback;
            }
            return;
        }// end function

        public function get obj() : Object
        {
            return this._ref != null ? (this._ref.reference) : (undefined);
        }// end function

        public function get prop() : String
        {
            return this._prop;
        }// end function

        public function getCurrentValue() : Number
        {
            return this._getValueMethod(this);
        }// end function

        private function getAppropriateGetValueMethod() : Function
        {
            if (this._prop.search(/[^\w\d]""[^\w\d]/) >= 0)
            {
                return this.executerValueCallback;
            }
            return this.defaultValueCallback;
        }// end function

        private function defaultValueCallback(graph:GraphInterest) : Number
        {
            return this.obj[this._prop];
        }// end function

        private function executerValueCallback(graph:GraphInterest) : Number
        {
            return Executer.Exec(this.obj, this._prop);
        }// end function

        public function writeToBytes(bytes:ByteArray) : void
        {
            bytes.writeUTF(this.key);
            bytes.writeUnsignedInt(this.col);
            return;
        }// end function

        public static function FromBytes(bytes:ByteArray) : GraphInterest
        {
            var _loc_2:* = new GraphInterest(bytes.readUTF(), bytes.readUnsignedInt());
            return _loc_2;
        }// end function

    }
}
