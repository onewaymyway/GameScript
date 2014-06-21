package com.junkbyte.console.vos
{
    import flash.utils.*;

    public class WeakRef extends Object
    {
        private var _val:Object;
        private var _strong:Boolean;

        public function WeakRef(ref, strong:Boolean = false)
        {
            this._strong = strong;
            this.reference = ref;
            return;
        }// end function

        public function get reference()
        {
            var _loc_1:* = undefined;
            if (this._strong)
            {
                return this._val;
            }
            for (_loc_1 in this._val)
            {
                
                return _loc_1;
            }
            return null;
        }// end function

        public function set reference(ref) : void
        {
            if (this._strong)
            {
                this._val = ref;
            }
            else
            {
                this._val = new Dictionary(true);
                this._val[ref] = null;
            }
            return;
        }// end function

        public function get strong() : Boolean
        {
            return this._strong;
        }// end function

    }
}
