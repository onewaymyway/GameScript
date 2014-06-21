package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import flash.events.*;

    public class ConsoleCore extends EventDispatcher
    {
        protected var console:Console;
        protected var config:ConsoleConfig;

        public function ConsoleCore(c:Console)
        {
            this.console = c;
            this.config = this.console.config;
            return;
        }// end function

        protected function get remoter() : Remoting
        {
            return this.console.remoter;
        }// end function

        protected function report(obj = "", priority:int = 0, skipSafe:Boolean = true, ch:String = null) : void
        {
            this.console.report(obj, priority, skipSafe, ch);
            return;
        }// end function

    }
}
