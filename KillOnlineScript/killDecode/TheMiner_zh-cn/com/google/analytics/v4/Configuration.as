package com.google.analytics.v4
{
    import com.google.analytics.campaign.*;
    import com.google.analytics.core.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.utils.*;

    public class Configuration extends Object
    {
        private var _debug:DebugConfiguration;
        private var _version:String = "4.3as";
        private var _sampleRate:Number = 1;
        private var _trackingLimitPerSession:int = 500;
        private var _domain:Domain;
        private var _organic:Organic;
        public var googleCsePath:String = "cse";
        public var googleSearchParam:String = "q";
        public var google:String = "google";
        private var _cookieName:String = "analytics";
        public var allowDomainHash:Boolean = true;
        public var allowAnchor:Boolean = false;
        public var allowLinker:Boolean = false;
        public var hasSiteOverlay:Boolean = false;
        public var tokenRate:Number = 0.2;
        public var conversionTimeout:Number;
        public var sessionTimeout:Number;
        public var idleLoop:Number = 30;
        public var idleTimeout:Number = 60;
        public var maxOutboundLinkExamined:Number = 1000;
        public var tokenCliff:int = 10;
        public var bucketCapacity:Number = 10;
        public var detectClientInfo:Boolean = true;
        public var detectFlash:Boolean = true;
        public var detectTitle:Boolean = true;
        public var campaignKey:CampaignKey;
        public var campaignTracking:Boolean = true;
        public var isTrackOutboundSubdomains:Boolean = false;
        public var serverMode:ServerOperationMode;
        public var localGIFpath:String = "/__utm.gif";
        public var remoteGIFpath:String = "http://www.google-analytics.com/__utm.gif";
        public var secureRemoteGIFpath:String = "https://ssl.google-analytics.com/__utm.gif";
        public var cookiePath:String = "/";
        public var transactionFieldDelim:String = "|";
        public var domainName:String = "";
        public var allowLocalTracking:Boolean = true;

        public function Configuration(debug:DebugConfiguration = null)
        {
            this._organic = new Organic();
            this.conversionTimeout = Timespan.sixmonths;
            this.sessionTimeout = Timespan.thirtyminutes;
            this.campaignKey = new CampaignKey();
            this.serverMode = ServerOperationMode.remote;
            this._debug = debug;
            this._domain = new Domain(DomainNameMode.auto, "", this._debug);
            this.serverMode = ServerOperationMode.remote;
            this._initOrganicSources();
            return;
        }// end function

        private function _initOrganicSources() : void
        {
            this.addOrganicSource(this.google, this.googleSearchParam);
            this.addOrganicSource("yahoo", "p");
            this.addOrganicSource("msn", "q");
            this.addOrganicSource("aol", "query");
            this.addOrganicSource("aol", "encquery");
            this.addOrganicSource("lycos", "query");
            this.addOrganicSource("ask", "q");
            this.addOrganicSource("altavista", "q");
            this.addOrganicSource("netscape", "query");
            this.addOrganicSource("cnn", "query");
            this.addOrganicSource("looksmart", "qt");
            this.addOrganicSource("about", "terms");
            this.addOrganicSource("mamma", "query");
            this.addOrganicSource("alltheweb", "q");
            this.addOrganicSource("gigablast", "q");
            this.addOrganicSource("voila", "rdata");
            this.addOrganicSource("virgilio", "qs");
            this.addOrganicSource("live", "q");
            this.addOrganicSource("baidu", "wd");
            this.addOrganicSource("alice", "qs");
            this.addOrganicSource("yandex", "text");
            this.addOrganicSource("najdi", "q");
            this.addOrganicSource("aol", "q");
            this.addOrganicSource("club-internet", "q");
            this.addOrganicSource("mama", "query");
            this.addOrganicSource("seznam", "q");
            this.addOrganicSource("search", "q");
            this.addOrganicSource("wp", "szukaj");
            this.addOrganicSource("onet", "qt");
            this.addOrganicSource("netsprint", "q");
            this.addOrganicSource("google.interia", "q");
            this.addOrganicSource("szukacz", "q");
            this.addOrganicSource("yam", "k");
            this.addOrganicSource("pchome", "q");
            this.addOrganicSource("kvasir", "searchExpr");
            this.addOrganicSource("sesam", "q");
            this.addOrganicSource("ozu", "q");
            this.addOrganicSource("terra", "query");
            this.addOrganicSource("nostrum", "query");
            this.addOrganicSource("mynet", "q");
            this.addOrganicSource("ekolay", "q");
            this.addOrganicSource("search.ilse", "search_for");
            return;
        }// end function

        public function get cookieName() : String
        {
            return this._cookieName;
        }// end function

        public function get version() : String
        {
            return this._version;
        }// end function

        public function get domain() : Domain
        {
            return this._domain;
        }// end function

        public function get organic() : Organic
        {
            return this._organic;
        }// end function

        public function get sampleRate() : Number
        {
            return this._sampleRate;
        }// end function

        public function set sampleRate(value:Number) : void
        {
            if (value <= 0)
            {
                value = 0.1;
            }
            if (value > 1)
            {
                value = 1;
            }
            value = Number(value.toFixed(2));
            this._sampleRate = value;
            return;
        }// end function

        public function get trackingLimitPerSession() : int
        {
            return this._trackingLimitPerSession;
        }// end function

        public function addOrganicSource(engine:String, keyword:String) : void
        {
            var engine:* = engine;
            var keyword:* = keyword;
            try
            {
                this._organic.addSource(engine, keyword);
            }
            catch (e:Error)
            {
                if (_debug)
                {
                }
                if (_debug.active)
                {
                    _debug.warning(e.message);
                }
            }
            return;
        }// end function

    }
}
