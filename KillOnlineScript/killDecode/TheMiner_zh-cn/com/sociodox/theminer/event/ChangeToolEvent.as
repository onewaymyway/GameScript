package com.sociodox.theminer.event
{
    import flash.events.*;

    public class ChangeToolEvent extends Event
    {
        public var mTool:Class;
        public static const CHANGE_TOOL_EVENT:String = "ChangeToolEvent";

        public function ChangeToolEvent(newTool:Class)
        {
            this.mTool = newTool;
            super(CHANGE_TOOL_EVENT, true, false);
            return;
        }// end function

    }
}
