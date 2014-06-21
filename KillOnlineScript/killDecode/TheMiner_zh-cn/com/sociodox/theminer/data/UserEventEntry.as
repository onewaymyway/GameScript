package com.sociodox.theminer.data
{
    import flash.events.*;

    public class UserEventEntry extends Event
    {
        public var Name:String = "";
        public var Info:String = "";
        public var StatusColor:uint = 4.28714e+009;
        public var StatusLabel:String = "";
        public var StatusProgress:Number = -1;
        public var Value1:String;
        public var Value2:String;
        public var Id:int = 0;
        public var Priority:int = 0;
        public var Visible:Boolean = true;
        public var IsError:Boolean = false;
        public static const USER_EVENT:String = "TheMinerUserEvent";
        private static var GLOBAL_ID:int = 0;

        public function UserEventEntry()
        {
            super(USER_EVENT, false, true);
            this.Id = GLOBAL_ID + 1;
            return;
        }// end function

        public function Set(aEventName:String = null, aEventInfo:String = null, aEventValue1:String = null, aEventValue2:String = null, aStatusBarLabel:String = null, aStatusBarProgress:Number = -1, aStatusBarColor:uint = 4.28714e+009, aEventSortPriority:int = 0, aEventVisible:Boolean = true) : void
        {
            if (aEventName)
            {
                this.Name = aEventName;
            }
            else
            {
                this.Name = "-";
            }
            if (aEventInfo)
            {
                this.Info = aEventInfo;
            }
            else
            {
                this.Info = "-";
            }
            this.StatusColor = aStatusBarColor;
            if (aStatusBarLabel)
            {
                this.StatusLabel = aStatusBarLabel;
            }
            else
            {
                this.StatusLabel = "-";
            }
            this.StatusProgress = aStatusBarProgress;
            if (aEventValue1)
            {
                this.Value1 = aEventValue1;
            }
            else
            {
                this.Value1 = "-";
            }
            if (aEventValue2)
            {
                this.Value2 = aEventValue2;
            }
            else
            {
                this.Value2 = "-";
            }
            this.Priority = aEventSortPriority;
            this.Visible = aEventVisible;
            return;
        }// end function

    }
}
