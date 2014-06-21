package com.google.analytics
{
    import com.google.analytics.core.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.events.*;
    import com.google.analytics.external.*;
    import com.google.analytics.utils.*;
    import com.google.analytics.v4.*;
    import flash.display.*;
    import flash.events.*;

    public class GATracker extends Object implements AnalyticsTracker
    {
        private var _ready:Boolean = false;
        private var _display:DisplayObject;
        private var _eventDispatcher:EventDispatcher;
        private var _tracker:GoogleAnalyticsAPI;
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _env:Environment;
        private var _buffer:Buffer;
        private var _gifRequest:GIFRequest;
        private var _jsproxy:JavascriptProxy;
        private var _dom:HTMLDOM;
        private var _adSense:AdSenseGlobals;
        private var _idleTimer:IdleTimer;
        private var _ecom:Ecommerce;
        private var _account:String;
        private var _mode:String;
        private var _visualDebug:Boolean;
        public static var autobuild:Boolean = true;
        public static var version:Version = API.version;

        public function GATracker(display:DisplayObject, account:String, mode:String = "AS3", visualDebug:Boolean = false, config:Configuration = null, debug:DebugConfiguration = null)
        {
            this._display = display;
            this._eventDispatcher = new EventDispatcher(this);
            this._tracker = new TrackerCache();
            this.account = account;
            this.mode = mode;
            this.visualDebug = visualDebug;
            if (!debug)
            {
                this.debug = new DebugConfiguration();
            }
            if (!config)
            {
                this.config = new Configuration(debug);
            }
            else
            {
                this.config = config;
            }
            if (autobuild)
            {
                this._factory();
            }
            return;
        }// end function

        private function _factory() : void
        {
            var _loc_1:GoogleAnalyticsAPI = null;
            this._jsproxy = new JavascriptProxy(this.debug);
            if (this.visualDebug)
            {
                this.debug.layout = new Layout(this.debug, this._display);
                this.debug.active = this.visualDebug;
            }
            var _loc_2:* = this._tracker as TrackerCache;
            switch(this.mode)
            {
                case TrackerMode.BRIDGE:
                {
                    _loc_1 = this._bridgeFactory();
                    break;
                }
                case TrackerMode.AS3:
                {
                }
                default:
                {
                    _loc_1 = this._trackerFactory();
                    break;
                }
            }
            if (!_loc_2.isEmpty())
            {
                _loc_2.tracker = _loc_1;
                _loc_2.flush();
            }
            this._tracker = _loc_1;
            this._ready = true;
            this.dispatchEvent(new AnalyticsEvent(AnalyticsEvent.READY, this));
            return;
        }// end function

        private function _trackerFactory() : GoogleAnalyticsAPI
        {
            this.debug.info("GATracker (AS3) v" + version + "\naccount: " + this.account);
            this._adSense = new AdSenseGlobals(this.debug);
            this._dom = new HTMLDOM(this.debug);
            this._dom.cacheProperties();
            this._env = new Environment("", "", "", this.debug, this._dom);
            this._buffer = new Buffer(this.config, this.debug, false);
            this._gifRequest = new GIFRequest(this.config, this.debug, this._buffer, this._env);
            this._ecom = new Ecommerce(this._debug);
            this._env.url = this._display.stage.loaderInfo.url;
            return new Tracker(this.account, this.config, this.debug, this._env, this._buffer, this._gifRequest, this._adSense, this._ecom);
        }// end function

        private function _bridgeFactory() : GoogleAnalyticsAPI
        {
            this.debug.info("GATracker (Bridge) v" + version + "\naccount: " + this.account);
            return new Bridge(this.account, this._debug, this._jsproxy);
        }// end function

        public function get account() : String
        {
            return this._account;
        }// end function

        public function set account(value:String) : void
        {
            this._account = value;
            return;
        }// end function

        public function get config() : Configuration
        {
            return this._config;
        }// end function

        public function set config(value:Configuration) : void
        {
            this._config = value;
            return;
        }// end function

        public function get debug() : DebugConfiguration
        {
            return this._debug;
        }// end function

        public function set debug(value:DebugConfiguration) : void
        {
            this._debug = value;
            return;
        }// end function

        public function isReady() : Boolean
        {
            return this._ready;
        }// end function

        public function get mode() : String
        {
            return this._mode;
        }// end function

        public function set mode(value:String) : void
        {
            this._mode = value;
            return;
        }// end function

        public function get visualDebug() : Boolean
        {
            return this._visualDebug;
        }// end function

        public function set visualDebug(value:Boolean) : void
        {
            this._visualDebug = value;
            return;
        }// end function

        public function build() : void
        {
            if (!this.isReady())
            {
                this._factory();
            }
            return;
        }// end function

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
        {
            this._eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
            return;
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._eventDispatcher.dispatchEvent(event);
        }// end function

        public function hasEventListener(type:String) : Boolean
        {
            return this._eventDispatcher.hasEventListener(type);
        }// end function

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
        {
            this._eventDispatcher.removeEventListener(type, listener, useCapture);
            return;
        }// end function

        public function willTrigger(type:String) : Boolean
        {
            return this._eventDispatcher.willTrigger(type);
        }// end function

        public function getAccount() : String
        {
            return this._tracker.getAccount();
        }// end function

        public function getVersion() : String
        {
            return this._tracker.getVersion();
        }// end function

        public function resetSession() : void
        {
            this._tracker.resetSession();
            return;
        }// end function

        public function setSampleRate(newRate:Number) : void
        {
            this._tracker.setSampleRate(newRate);
            return;
        }// end function

        public function setSessionTimeout(newTimeout:int) : void
        {
            this._tracker.setSessionTimeout(newTimeout);
            return;
        }// end function

        public function setVar(newVal:String) : void
        {
            this._tracker.setVar(newVal);
            return;
        }// end function

        public function trackPageview(pageURL:String = "") : void
        {
            this._tracker.trackPageview(pageURL);
            return;
        }// end function

        public function setAllowAnchor(enable:Boolean) : void
        {
            this._tracker.setAllowAnchor(enable);
            return;
        }// end function

        public function setCampContentKey(newCampContentKey:String) : void
        {
            this._tracker.setCampContentKey(newCampContentKey);
            return;
        }// end function

        public function setCampMediumKey(newCampMedKey:String) : void
        {
            this._tracker.setCampMediumKey(newCampMedKey);
            return;
        }// end function

        public function setCampNameKey(newCampNameKey:String) : void
        {
            this._tracker.setCampNameKey(newCampNameKey);
            return;
        }// end function

        public function setCampNOKey(newCampNOKey:String) : void
        {
            this._tracker.setCampNOKey(newCampNOKey);
            return;
        }// end function

        public function setCampSourceKey(newCampSrcKey:String) : void
        {
            this._tracker.setCampSourceKey(newCampSrcKey);
            return;
        }// end function

        public function setCampTermKey(newCampTermKey:String) : void
        {
            this._tracker.setCampTermKey(newCampTermKey);
            return;
        }// end function

        public function setCampaignTrack(enable:Boolean) : void
        {
            this._tracker.setCampaignTrack(enable);
            return;
        }// end function

        public function setCookieTimeout(newDefaultTimeout:int) : void
        {
            this._tracker.setCookieTimeout(newDefaultTimeout);
            return;
        }// end function

        public function cookiePathCopy(newPath:String) : void
        {
            this._tracker.cookiePathCopy(newPath);
            return;
        }// end function

        public function getLinkerUrl(url:String = "", useHash:Boolean = false) : String
        {
            return this._tracker.getLinkerUrl(url, useHash);
        }// end function

        public function link(targetUrl:String, useHash:Boolean = false) : void
        {
            this._tracker.link(targetUrl, useHash);
            return;
        }// end function

        public function linkByPost(formObject:Object, useHash:Boolean = false) : void
        {
            this._tracker.linkByPost(formObject, useHash);
            return;
        }// end function

        public function setAllowHash(enable:Boolean) : void
        {
            this._tracker.setAllowHash(enable);
            return;
        }// end function

        public function setAllowLinker(enable:Boolean) : void
        {
            this._tracker.setAllowLinker(enable);
            return;
        }// end function

        public function setCookiePath(newCookiePath:String) : void
        {
            this._tracker.setCookiePath(newCookiePath);
            return;
        }// end function

        public function setDomainName(newDomainName:String) : void
        {
            this._tracker.setDomainName(newDomainName);
            return;
        }// end function

        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
        {
            this._tracker.addItem(item, sku, name, category, price, quantity);
            return;
        }// end function

        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : void
        {
            this._tracker.addTrans(orderId, affiliation, total, tax, shipping, city, state, country);
            return;
        }// end function

        public function trackTrans() : void
        {
            this._tracker.trackTrans();
            return;
        }// end function

        public function createEventTracker(objName:String) : EventTracker
        {
            return this._tracker.createEventTracker(objName);
        }// end function

        public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
        {
            return this._tracker.trackEvent(category, action, label, value);
        }// end function

        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
        {
            this._tracker.addIgnoredOrganic(newIgnoredOrganicKeyword);
            return;
        }// end function

        public function addIgnoredRef(newIgnoredReferrer:String) : void
        {
            this._tracker.addIgnoredRef(newIgnoredReferrer);
            return;
        }// end function

        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
        {
            this._tracker.addOrganic(newOrganicEngine, newOrganicKeyword);
            return;
        }// end function

        public function clearIgnoredOrganic() : void
        {
            this._tracker.clearIgnoredOrganic();
            return;
        }// end function

        public function clearIgnoredRef() : void
        {
            this._tracker.clearIgnoredRef();
            return;
        }// end function

        public function clearOrganic() : void
        {
            this._tracker.clearOrganic();
            return;
        }// end function

        public function getClientInfo() : Boolean
        {
            return this._tracker.getClientInfo();
        }// end function

        public function getDetectFlash() : Boolean
        {
            return this._tracker.getDetectFlash();
        }// end function

        public function getDetectTitle() : Boolean
        {
            return this._tracker.getDetectTitle();
        }// end function

        public function setClientInfo(enable:Boolean) : void
        {
            this._tracker.setClientInfo(enable);
            return;
        }// end function

        public function setDetectFlash(enable:Boolean) : void
        {
            this._tracker.setDetectFlash(enable);
            return;
        }// end function

        public function setDetectTitle(enable:Boolean) : void
        {
            this._tracker.setDetectTitle(enable);
            return;
        }// end function

        public function getLocalGifPath() : String
        {
            return this._tracker.getLocalGifPath();
        }// end function

        public function getServiceMode() : ServerOperationMode
        {
            return this._tracker.getServiceMode();
        }// end function

        public function setLocalGifPath(newLocalGifPath:String) : void
        {
            this._tracker.setLocalGifPath(newLocalGifPath);
            return;
        }// end function

        public function setLocalRemoteServerMode() : void
        {
            this._tracker.setLocalRemoteServerMode();
            return;
        }// end function

        public function setLocalServerMode() : void
        {
            this._tracker.setLocalServerMode();
            return;
        }// end function

        public function setRemoteServerMode() : void
        {
            this._tracker.setRemoteServerMode();
            return;
        }// end function

    }
}
