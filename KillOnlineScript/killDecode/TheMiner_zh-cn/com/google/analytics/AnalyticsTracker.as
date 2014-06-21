package com.google.analytics
{
    import com.google.analytics.debug.*;
    import com.google.analytics.v4.*;

    public interface AnalyticsTracker extends GoogleAnalyticsAPI, IEventDispatcher
    {

        public function AnalyticsTracker();

        function get account() : String;

        function set account(value:String) : void;

        function get config() : Configuration;

        function set config(value:Configuration) : void;

        function get debug() : DebugConfiguration;

        function set debug(value:DebugConfiguration) : void;

        function get mode() : String;

        function set mode(value:String) : void;

        function get visualDebug() : Boolean;

        function set visualDebug(value:Boolean) : void;

        function isReady() : Boolean;

    }
}
