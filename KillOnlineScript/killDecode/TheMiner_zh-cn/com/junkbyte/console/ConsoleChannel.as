package com.junkbyte.console
{
    import flash.display.*;

    public class ConsoleChannel extends Object
    {
        private var _c:Object;
        private var _name:String;
        public var enabled:Boolean = true;
        public static const GLOBAL_CHANNEL:String = " * ";
        public static const DEFAULT_CHANNEL:String = "-";
        public static const CONSOLE_CHANNEL:String = "C";
        public static const FILTER_CHANNEL:String = "~";

        public function ConsoleChannel(n, c:Console = null)
        {
            this._name = Console.MakeChannelName(n);
            if (this._name == ConsoleChannel.GLOBAL_CHANNEL)
            {
                this._name = ConsoleChannel.DEFAULT_CHANNEL;
            }
            this._c = c ? (c) : (Cc);
            return;
        }// end function

        public function add(str, priority:Number = 2, isRepeating:Boolean = false) : void
        {
            if (this.enabled)
            {
                this._c.ch(this._name, str, priority, isRepeating);
            }
            return;
        }// end function

        public function log(... args) : void
        {
            this.multiadd(this._c.logch, args);
            return;
        }// end function

        public function info(... args) : void
        {
            this.multiadd(this._c.infoch, args);
            return;
        }// end function

        public function debug(... args) : void
        {
            this.multiadd(this._c.debugch, args);
            return;
        }// end function

        public function warn(... args) : void
        {
            this.multiadd(this._c.warnch, args);
            return;
        }// end function

        public function error(... args) : void
        {
            this.multiadd(this._c.errorch, args);
            return;
        }// end function

        public function fatal(... args) : void
        {
            this.multiadd(this._c.fatalch, args);
            return;
        }// end function

        private function multiadd(f:Function, args:Array) : void
        {
            if (this.enabled)
            {
                f.apply(null, new Array(this._name).concat(args));
            }
            return;
        }// end function

        public function stack(str, depth:int = -1, priority:Number = 5) : void
        {
            if (this.enabled)
            {
                this._c.stackch(this.name, str, depth, priority);
            }
            return;
        }// end function

        public function explode(obj:Object, depth:int = 3) : void
        {
            this._c.explodech(this.name, obj, depth);
            return;
        }// end function

        public function map(base:DisplayObjectContainer, maxstep:uint = 0) : void
        {
            this._c.mapch(this.name, base, maxstep);
            return;
        }// end function

        public function inspect(obj:Object, detail:Boolean = true) : void
        {
            this._c.inspectch(this.name, obj, detail);
            return;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function clear() : void
        {
            this._c.clear(this._name);
            return;
        }// end function

        public function toString() : String
        {
            return "[ConsoleChannel " + this.name + "]";
        }// end function

    }
}
