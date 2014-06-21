package com.google.analytics.events
{
    import com.google.analytics.*;
    import flash.events.*;

    public class AnalyticsEvent extends Event
    {
        public var tracker:AnalyticsTracker;
        public static const READY:String = "ready";

        public function AnalyticsEvent(type:String, tracker:AnalyticsTracker, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.tracker = tracker;
            return;
        }// end function

        override public function clone() : Event
        {
            return new AnalyticsEvent(type, this.tracker, bubbles, cancelable);
        }// end function

    }
}
