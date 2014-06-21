package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import flash.system.*;
    import flash.utils.*;

    public class MemoryMonitor extends ConsoleCore
    {
        private var _namesList:Object;
        private var _objectsList:Dictionary;
        private var _count:uint;

        public function MemoryMonitor(m:Console)
        {
            super(m);
            this._namesList = new Object();
            this._objectsList = new Dictionary(true);
            console.remoter.registerCallback("gc", this.gc);
            return;
        }// end function

        public function watch(obj:Object, n:String) : String
        {
            var _loc_3:* = getQualifiedClassName(obj);
            if (!n)
            {
                n = _loc_3 + "@" + getTimer();
            }
            if (this._objectsList[obj])
            {
                if (this._namesList[this._objectsList[obj]])
                {
                    this.unwatch(this._objectsList[obj]);
                }
            }
            if (this._namesList[n])
            {
                if (this._objectsList[obj] == n)
                {
                    var _loc_4:String = this;
                    var _loc_5:* = this._count - 1;
                    _loc_4._count = _loc_5;
                }
                else
                {
                    n = n + "@" + getTimer() + "_" + Math.floor(Math.random() * 100);
                }
            }
            this._namesList[n] = true;
            var _loc_4:String = this;
            var _loc_5:* = this._count + 1;
            _loc_4._count = _loc_5;
            this._objectsList[obj] = n;
            return n;
        }// end function

        public function unwatch(n:String) : void
        {
            var _loc_2:Object = null;
            for (_loc_2 in this._objectsList)
            {
                
                if (this._objectsList[_loc_2] == n)
                {
                    delete this._objectsList[_loc_2];
                }
            }
            if (this._namesList[n])
            {
                delete this._namesList[n];
                var _loc_3:String = this;
                var _loc_4:* = this._count - 1;
                _loc_3._count = _loc_4;
            }
            return;
        }// end function

        public function update() : void
        {
            var _loc_3:Object = null;
            var _loc_4:String = null;
            if (this._count == 0)
            {
                return;
            }
            var _loc_1:* = new Array();
            var _loc_2:* = new Object();
            for (_loc_3 in this._objectsList)
            {
                
                _loc_2[this._objectsList[_loc_3]] = true;
            }
            for (_loc_4 in this._namesList)
            {
                
                if (!_loc_2[_loc_4])
                {
                    _loc_1.push(_loc_4);
                    delete this._namesList[_loc_4];
                    var _loc_7:String = this;
                    var _loc_8:* = this._count - 1;
                    _loc_7._count = _loc_8;
                }
            }
            if (_loc_1.length)
            {
                report("<b>GARBAGE COLLECTED " + _loc_1.length + " item(s): </b>" + _loc_1.join(", "), -2);
            }
            return;
        }// end function

        public function get count() : uint
        {
            return this._count;
        }// end function

        public function gc() : void
        {
            var _loc_1:Boolean = false;
            try
            {
                if (System["gc"] != null)
                {
                    var _loc_3:* = System;
                    _loc_3.System["gc"]();
                    _loc_1 = true;
                }
            }
            catch (e:Error)
            {
            }
            var _loc_2:* = "Manual garbage collection " + (_loc_1 ? ("successful.") : ("FAILED. You need debugger version of flash player."));
            report(_loc_2, _loc_1 ? (-1) : (10));
            return;
        }// end function

    }
}
