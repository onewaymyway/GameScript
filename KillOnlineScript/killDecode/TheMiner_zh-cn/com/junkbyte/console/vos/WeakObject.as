package com.junkbyte.console.vos
{
    import flash.utils.*;

    dynamic public class WeakObject extends Proxy
    {
        private var _item:Array;
        private var _dir:Object;

        public function WeakObject()
        {
            this._dir = new Object();
            return;
        }// end function

        public function set(n:String, obj:Object, strong:Boolean = false) : void
        {
            if (obj == null)
            {
                delete this._dir[n];
            }
            else
            {
                this._dir[n] = new WeakRef(obj, strong);
            }
            return;
        }// end function

        public function get(n:String)
        {
            var _loc_2:* = this.getWeakRef(n);
            return _loc_2 ? (_loc_2.reference) : (undefined);
        }// end function

        public function getWeakRef(n:String) : WeakRef
        {
            return this._dir[n] as WeakRef;
        }// end function

        override function getProperty(n)
        {
            return this.get(n);
        }// end function

        override function callProperty(n, ... args)
        {
            args = this.get(n);
            return args.apply(this, args);
        }// end function

        override function setProperty(n, v) : void
        {
            this.set(n, v);
            return;
        }// end function

        override function nextName(index:int) : String
        {
            return this._item[(index - 1)];
        }// end function

        override function nextValue(index:int)
        {
            return this[this.nextName(index)];
        }// end function

        override function nextNameIndex(index:int) : int
        {
            var _loc_2:* = undefined;
            if (index == 0)
            {
                this._item = new Array();
                for (_loc_2 in this._dir)
                {
                    
                    this._item.push(_loc_2);
                }
            }
            if (index < this._item.length)
            {
                return (index + 1);
            }
            return 0;
        }// end function

        override function deleteProperty(name) : Boolean
        {
            return delete this._dir[name];
        }// end function

        public function toString() : String
        {
            return "[WeakObject]";
        }// end function

    }
}
