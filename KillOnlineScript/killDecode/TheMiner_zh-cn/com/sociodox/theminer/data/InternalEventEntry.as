package com.sociodox.theminer.data
{

    public class InternalEventEntry extends Object
    {
        public var qName:String = null;
        public var mStack:String = null;
        public var mStackFrame:Array = null;
        public var entryCount:int;
        public var entryCountTotal:int;
        public var entryTime:int;
        public var entryTimeTotal:int;
        public var lastUpdateId:int = 0;
        public var needSkip:Boolean = false;
        private static const CHARACTER_ENTER:String = "\n";
        private static const CHARACTER_TAB:String = "\t";
        private static const CHARACTER_UNION:String = "-";

        public function InternalEventEntry()
        {
            return;
        }// end function

        public function SetStack(aStack:Array) : void
        {
            var _loc_3:int = 0;
            this.mStackFrame = aStack;
            this.mStack = "";
            var _loc_2:* = aStack.length - 1;
            while (_loc_2 >= 0)
            {
                
                this.mStack = this.mStack + (CHARACTER_UNION + aStack[_loc_2].name);
                if (_loc_2 > 0)
                {
                    this.mStack = this.mStack + CHARACTER_ENTER;
                    _loc_3 = aStack.length - 1;
                    while (_loc_3 >= _loc_2)
                    {
                        
                        this.mStack = this.mStack + CHARACTER_TAB;
                        _loc_3 = _loc_3 - 1;
                    }
                }
                _loc_2 = _loc_2 - 1;
            }
            return;
        }// end function

        public function Add(time:Number, id:int = 0) : void
        {
            this.lastUpdateId = id;
            var _loc_3:String = this;
            var _loc_4:* = this.entryCount + 1;
            _loc_3.entryCount = _loc_4;
            var _loc_3:String = this;
            var _loc_4:* = this.entryCountTotal + 1;
            _loc_3.entryCountTotal = _loc_4;
            this.entryTime = this.entryTime + time;
            this.entryTimeTotal = this.entryTimeTotal + time;
            return;
        }// end function

        public function AddParentTime(time:Number, id:int = 0) : void
        {
            this.lastUpdateId = id;
            this.entryTimeTotal = this.entryTimeTotal + time;
            return;
        }// end function

        public function Reset() : void
        {
            this.entryTime = 0;
            this.entryCount = 0;
            return;
        }// end function

        public function Clear() : void
        {
            this.entryCount = 0;
            this.entryCountTotal = 0;
            this.entryTime = 0;
            this.entryTimeTotal = 0;
            return;
        }// end function

    }
}
