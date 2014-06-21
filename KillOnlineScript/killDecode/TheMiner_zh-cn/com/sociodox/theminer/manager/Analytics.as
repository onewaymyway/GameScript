package com.sociodox.theminer.manager
{
    import com.google.analytics.*;
    import com.google.analytics.core.*;
    import com.sociodox.theminer.window.*;
    import flash.sampler.*;

    public class Analytics extends Object
    {
        private static var AnalyticTracker:AnalyticsTracker;

        public function Analytics()
        {
            return;
        }// end function

        public static function Init() : void
        {
            return;
        }// end function

        public static function Report(aString:String) : void
        {
            var _loc_2:Boolean = false;
            _loc_2 = Configuration.IsSamplingRequired();
            if (_loc_2)
            {
                pauseSampling();
            }
            if (Configuration.ANALYTICS_ENABLED)
            {
                if (AnalyticTracker == null)
                {
                }
                if (Stage2D != null)
                {
                    AnalyticTracker = new GATracker(Stage2D, "UA-16424556-5", "AS3", false);
                    AnalyticTracker.setSampleRate(100);
                    AnalyticTracker.setDomainName(new Domain(DomainNameMode.custom, "theminer.sociodox.com").name);
                    AnalyticTracker.setDetectTitle(false);
                    AnalyticTracker.setClientInfo(false);
                    AnalyticTracker.setCampaignTrack(false);
                    AnalyticTracker.config.detectTitle = false;
                    AnalyticTracker.config.idleTimeout = 999999;
                    AnalyticTracker.config.detectTitle = false;
                }
                if (AnalyticTracker)
                {
                    AnalyticTracker.trackPageview(aString);
                }
            }
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public static function Track(category:String, action:String, label:String = null, value:Number = NaN) : void
        {
            var _loc_5:Boolean = false;
            _loc_5 = Configuration.IsSamplingRequired();
            if (_loc_5)
            {
                pauseSampling();
            }
            if (Configuration.ANALYTICS_ENABLED)
            {
                if (AnalyticTracker == null)
                {
                }
                if (Stage2D != null)
                {
                    AnalyticTracker = new GATracker(Stage2D, "UA-16424556-5", "AS3", false);
                    AnalyticTracker.setSampleRate(100);
                    AnalyticTracker.setDomainName(new Domain(DomainNameMode.custom, "theminer.sociodox.com").name);
                    AnalyticTracker.setDetectTitle(false);
                    AnalyticTracker.setClientInfo(false);
                    AnalyticTracker.setCampaignTrack(false);
                    AnalyticTracker.config.detectTitle = false;
                    AnalyticTracker.config.idleTimeout = 999999;
                    AnalyticTracker.config.detectTitle = false;
                }
                if (AnalyticTracker)
                {
                    AnalyticTracker.trackEvent(category, action, label, value);
                }
            }
            if (_loc_5)
            {
                startSampling();
            }
            return;
        }// end function

    }
}
