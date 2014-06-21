package com.sociodox.theminer.manager
{
    import __AS3__.vec.*;
    import com.sociodox.theminer.data.*;

    public class UserEventManager extends Object
    {
        private var mUserEvents:Vector.<UserEventEntry>;

        public function UserEventManager()
        {
            this.mUserEvents = new Vector.<UserEventEntry>;
            return;
        }// end function

        public function GetUserEvents() : Vector.<UserEventEntry>
        {
            return this.mUserEvents;
        }// end function

        public function OnSharedEvent(aEvent) : void
        {
            var _loc_2:* = new UserEventEntry();
            if (aEvent.hasOwnProperty("Name"))
            {
                _loc_2.Name = aEvent["Name"];
            }
            else
            {
                _loc_2.Name = "-";
            }
            if (aEvent.hasOwnProperty("Info"))
            {
                _loc_2.Info = aEvent["Info"];
            }
            else
            {
                _loc_2.Info = "-";
            }
            if (aEvent.hasOwnProperty("Value1"))
            {
                _loc_2.Value1 = aEvent["Value1"];
            }
            else
            {
                _loc_2.Value1 = "-";
            }
            if (aEvent.hasOwnProperty("Value2"))
            {
                _loc_2.Value2 = aEvent["Value2"];
            }
            else
            {
                _loc_2.Value2 = "-";
            }
            if (aEvent.hasOwnProperty("StatusLabel"))
            {
                _loc_2.StatusLabel = aEvent["StatusLabel"];
            }
            else
            {
                _loc_2.StatusLabel = "-";
            }
            if (aEvent.hasOwnProperty("StatusProgress"))
            {
                _loc_2.StatusProgress = aEvent["StatusProgress"];
            }
            else
            {
                _loc_2.StatusProgress = -1;
            }
            if (aEvent.hasOwnProperty("StatusColor"))
            {
                _loc_2.StatusColor = aEvent["StatusColor"];
            }
            else
            {
                _loc_2.StatusColor = 0;
            }
            if (aEvent.hasOwnProperty("Priority"))
            {
                _loc_2.Priority = aEvent["Priority"];
            }
            else
            {
                _loc_2.Priority = 0;
            }
            if (aEvent.hasOwnProperty("Visible"))
            {
                _loc_2.Visible = aEvent["Visible"];
            }
            else
            {
                _loc_2.Visible = true;
            }
            if (aEvent.hasOwnProperty("IsError"))
            {
                _loc_2.IsError = aEvent["IsError"];
            }
            else
            {
                _loc_2.IsError = false;
            }
            this.mUserEvents.push(_loc_2);
            aEvent.stopPropagation();
            aEvent.stopImmediatePropagation();
            return;
        }// end function

        public function AddCustomUserEvent(aEventName:String = null, aEventInfo:String = null, aEventValue1:String = null, aEventValue2:String = null, aStatusBarLabel:String = null, aStatusBarProgress:Number = -1, aStatusBarColor:uint = 4.27819e+009, aEventSortPriority:int = 0, aEventVisible:Boolean = true, aError:Boolean = false) : UserEventEntry
        {
            var _loc_11:* = new UserEventEntry();
            if (aEventName)
            {
                _loc_11.Name = aEventName;
            }
            else
            {
                _loc_11.Name = null;
            }
            if (aEventInfo)
            {
                _loc_11.Info = aEventInfo;
            }
            else
            {
                _loc_11.Info = null;
            }
            _loc_11.StatusColor = aStatusBarColor;
            if (aStatusBarLabel)
            {
                _loc_11.StatusLabel = aStatusBarLabel;
            }
            else
            {
                _loc_11.StatusLabel = null;
            }
            _loc_11.StatusProgress = aStatusBarProgress;
            if (aEventValue1)
            {
                _loc_11.Value1 = aEventValue1;
            }
            else
            {
                _loc_11.Value1 = null;
            }
            if (aEventValue2)
            {
                _loc_11.Value2 = aEventValue2;
            }
            else
            {
                _loc_11.Value2 = null;
            }
            _loc_11.Priority = aEventSortPriority;
            _loc_11.Visible = aEventVisible;
            _loc_11.IsError = aError;
            if (!aEventName)
            {
            }
            if (!aEventInfo)
            {
            }
            if (aStatusBarProgress == -1)
            {
            }
            if (!aEventValue1)
            {
            }
            if (aEventValue2)
            {
                this.mUserEvents.push(_loc_11);
                return _loc_11;
            }
            return null;
        }// end function

    }
}
