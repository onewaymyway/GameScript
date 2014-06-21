package com.junkbyte.console.vos
{
    import com.junkbyte.console.*;
    import flash.system.*;

    public class GraphMemoryGroup extends GraphGroup
    {
        private var console:Console;
        public static const NAME:String = "consoleMemoryGraph";

        public function GraphMemoryGroup(console:Console)
        {
            super(NAME);
            this.console = console;
            rect.x = 90;
            rect.y = 15;
            alignRight = true;
            var _loc_2:* = new GraphInterest("mb");
            _loc_2.col = 6328575;
            _updateArgs.length = 1;
            interests.push(_loc_2);
            freq = 1000;
            menus.push("G");
            onMenu.add(this.onMenuClick);
            return;
        }// end function

        protected function onMenuClick(key:String) : void
        {
            if (key == "G")
            {
                this.console.gc();
            }
            return;
        }// end function

        override protected function dispatchUpdates() : void
        {
            _updateArgs[0] = Math.round(System.totalMemory / 10485.8) / 100;
            applyUpdateDispather(_updateArgs);
            return;
        }// end function

    }
}
