package com.google.analytics.core
{
    import com.google.analytics.v4.*;

    public class EventTracker extends Object
    {
        private var _parent:GoogleAnalyticsAPI;
        public var name:String;

        public function EventTracker(name:String, parent:GoogleAnalyticsAPI)
        {
            this.name = name;
            this._parent = parent;
            return;
        }// end function

        public function trackEvent(action:String, label:String = null, value:Number = NaN) : Boolean
        {
            return this._parent.trackEvent(this.name, action, label, value);
        }// end function

    }
}
