package com.google.analytics.v4
{
    import com.google.analytics.campaign.*;
    import com.google.analytics.core.*;
    import com.google.analytics.data.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.ecommerce.*;
    import com.google.analytics.external.*;
    import com.google.analytics.utils.*;
    import flash.net.*;

    public class Tracker extends Object implements GoogleAnalyticsAPI
    {
        private var _account:String;
        private var _domainHash:Number;
        private var _formatedReferrer:String;
        private var _timeStamp:Number;
        private var _hasInitData:Boolean = false;
        private var _isNewVisitor:Boolean = false;
        private var _noSessionInformation:Boolean = false;
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _info:Environment;
        private var _buffer:Buffer;
        private var _gifRequest:GIFRequest;
        private var _adSense:AdSenseGlobals;
        private var _browserInfo:BrowserInfo;
        private var _campaignInfo:CampaignInfo;
        private const EVENT_TRACKER_PROJECT_ID:int = 5;
        private const EVENT_TRACKER_OBJECT_NAME_KEY_NUM:int = 1;
        private const EVENT_TRACKER_TYPE_KEY_NUM:int = 2;
        private const EVENT_TRACKER_LABEL_KEY_NUM:int = 3;
        private const EVENT_TRACKER_VALUE_VALUE_NUM:int = 1;
        private var _campaign:CampaignManager;
        private var _eventTracker:X10;
        private var _x10Module:X10;
        private var _ecom:Ecommerce;

        public function Tracker(account:String, config:Configuration, debug:DebugConfiguration, info:Environment, buffer:Buffer, gifRequest:GIFRequest, adSense:AdSenseGlobals, ecom:Ecommerce)
        {
            var _loc_9:String = null;
            this._account = account;
            this._config = config;
            this._debug = debug;
            this._info = info;
            this._buffer = buffer;
            this._gifRequest = gifRequest;
            this._adSense = adSense;
            this._ecom = ecom;
            if (!Utils.validateAccount(account))
            {
                _loc_9 = "Account \"" + account + "\" is not valid.";
                this._debug.warning(_loc_9);
                throw new Error(_loc_9);
            }
            return;
        }// end function

        private function _initData() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            if (!this._hasInitData)
            {
                this._updateDomainName();
                this._domainHash = this._getDomainHash();
                this._timeStamp = Math.round(new Date().getTime() / 1000);
                if (this._debug.verbose)
                {
                    _loc_1 = "";
                    _loc_1 = _loc_1 + "_initData 0";
                    _loc_1 = _loc_1 + ("\ndomain name: " + this._config.domainName);
                    _loc_1 = _loc_1 + ("\ndomain hash: " + this._domainHash);
                    _loc_1 = _loc_1 + ("\ntimestamp:   " + this._timeStamp + " (" + new Date(this._timeStamp * 1000) + ")");
                    this._debug.info(_loc_1, VisualDebugMode.geek);
                }
            }
            if (this._doTracking())
            {
                this._handleCookie();
            }
            if (!this._hasInitData)
            {
                if (this._doTracking())
                {
                    this._formatedReferrer = this._formatReferrer();
                    this._browserInfo = new BrowserInfo(this._config, this._info);
                    this._debug.info("browserInfo: " + this._browserInfo.toURLString(), VisualDebugMode.advanced);
                    if (this._config.campaignTracking)
                    {
                        this._campaign = new CampaignManager(this._config, this._debug, this._buffer, this._domainHash, this._formatedReferrer, this._timeStamp);
                        this._campaignInfo = this._campaign.getCampaignInformation(this._info.locationSearch, this._noSessionInformation);
                        this._debug.info("campaignInfo: " + this._campaignInfo.toURLString(), VisualDebugMode.advanced);
                        this._debug.info("Search: " + this._info.locationSearch);
                        this._debug.info("CampaignTrackig: " + this._buffer.utmz.campaignTracking);
                    }
                }
                this._x10Module = new X10();
                this._eventTracker = new X10();
                this._hasInitData = true;
            }
            if (this._config.hasSiteOverlay)
            {
                this._debug.warning("Site Overlay is not supported");
            }
            if (this._debug.verbose)
            {
                _loc_2 = "";
                _loc_2 = _loc_2 + "_initData (misc)";
                _loc_2 = _loc_2 + ("\nflash version: " + this._info.flashVersion.toString(4));
                _loc_2 = _loc_2 + ("\nprotocol: " + this._info.protocol);
                _loc_2 = _loc_2 + ("\ndefault domain name (auto): \"" + this._info.domainName + "\"");
                _loc_2 = _loc_2 + ("\nlanguage: " + this._info.language);
                _loc_2 = _loc_2 + ("\ndomain hash: " + this._getDomainHash());
                _loc_2 = _loc_2 + ("\nuser-agent: " + this._info.userAgent);
                this._debug.info(_loc_2, VisualDebugMode.geek);
            }
            return;
        }// end function

        private function _handleCookie() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_4:String = null;
            if (this._config.allowLinker)
            {
            }
            this._buffer.createSO();
            if (this._buffer.hasUTMA())
            {
                this._buffer.hasUTMA();
            }
            if (!this._buffer.utma.isEmpty())
            {
                if (this._buffer.hasUTMB())
                {
                }
                if (!this._buffer.hasUTMC())
                {
                    this._buffer.updateUTMA(this._timeStamp);
                    this._noSessionInformation = true;
                }
                if (this._debug.verbose)
                {
                    this._debug.info("from cookie " + this._buffer.utma.toString(), VisualDebugMode.geek);
                }
            }
            else
            {
                this._debug.info("create a new utma", VisualDebugMode.advanced);
                this._buffer.utma.domainHash = this._domainHash;
                this._buffer.utma.sessionId = this._getUniqueSessionId();
                this._buffer.utma.firstTime = this._timeStamp;
                this._buffer.utma.lastTime = this._timeStamp;
                this._buffer.utma.currentTime = this._timeStamp;
                this._buffer.utma.sessionCount = 1;
                if (this._debug.verbose)
                {
                    this._debug.info(this._buffer.utma.toString(), VisualDebugMode.geek);
                }
                this._noSessionInformation = true;
                this._isNewVisitor = true;
            }
            if (this._adSense.gaGlobal)
            {
            }
            if (this._adSense.dh == String(this._domainHash))
            {
                if (this._adSense.sid)
                {
                    this._buffer.utma.currentTime = Number(this._adSense.sid);
                    if (this._debug.verbose)
                    {
                        _loc_1 = "";
                        _loc_1 = _loc_1 + "AdSense sid found\n";
                        _loc_1 = _loc_1 + ("Override currentTime(" + this._buffer.utma.currentTime + ") from AdSense sid(" + Number(this._adSense.sid) + ")");
                        this._debug.info(_loc_1, VisualDebugMode.geek);
                    }
                }
                if (this._isNewVisitor)
                {
                    if (this._adSense.sid)
                    {
                        this._buffer.utma.lastTime = Number(this._adSense.sid);
                        if (this._debug.verbose)
                        {
                            _loc_2 = "";
                            _loc_2 = _loc_2 + "AdSense sid found (new visitor)\n";
                            _loc_2 = _loc_2 + ("Override lastTime(" + this._buffer.utma.lastTime + ") from AdSense sid(" + Number(this._adSense.sid) + ")");
                            this._debug.info(_loc_2, VisualDebugMode.geek);
                        }
                    }
                    if (this._adSense.vid)
                    {
                        _loc_3 = this._adSense.vid.split(".");
                        this._buffer.utma.sessionId = Number(_loc_3[0]);
                        this._buffer.utma.firstTime = Number(_loc_3[1]);
                        if (this._debug.verbose)
                        {
                            _loc_4 = "";
                            _loc_4 = _loc_4 + "AdSense vid found (new visitor)\n";
                            _loc_4 = _loc_4 + ("Override sessionId(" + this._buffer.utma.sessionId + ") from AdSense vid(" + Number(_loc_3[0]) + ")\n");
                            _loc_4 = _loc_4 + ("Override firstTime(" + this._buffer.utma.firstTime + ") from AdSense vid(" + Number(_loc_3[1]) + ")");
                            this._debug.info(_loc_4, VisualDebugMode.geek);
                        }
                    }
                    if (this._debug.verbose)
                    {
                        this._debug.info("AdSense modified : " + this._buffer.utma.toString(), VisualDebugMode.geek);
                    }
                }
            }
            this._buffer.utmb.domainHash = this._domainHash;
            if (isNaN(this._buffer.utmb.trackCount))
            {
                this._buffer.utmb.trackCount = 0;
            }
            if (isNaN(this._buffer.utmb.token))
            {
                this._buffer.utmb.token = this._config.tokenCliff;
            }
            if (isNaN(this._buffer.utmb.lastTime))
            {
                this._buffer.utmb.lastTime = this._buffer.utma.currentTime;
            }
            this._buffer.utmc.domainHash = this._domainHash;
            if (this._debug.verbose)
            {
                this._debug.info(this._buffer.utmb.toString(), VisualDebugMode.advanced);
                this._debug.info(this._buffer.utmc.toString(), VisualDebugMode.advanced);
            }
            return;
        }// end function

        private function _isNotGoogleSearch() : Boolean
        {
            var _loc_1:* = this._config.domainName;
            var _loc_2:* = _loc_1.indexOf("www.google.") < 0;
            var _loc_3:* = _loc_1.indexOf(".google.") < 0;
            var _loc_4:* = _loc_1.indexOf("google.") < 0;
            var _loc_5:* = _loc_1.indexOf("google.org") > -1;
            if (!_loc_2)
            {
            }
            if (!_loc_3)
            {
            }
            if (!_loc_4)
            {
            }
            if (this._config.cookiePath == "/")
            {
            }
            return _loc_5;
        }// end function

        private function _doTracking() : Boolean
        {
            if (this._info.protocol != Protocols.file)
            {
            }
            if (this._info.protocol != Protocols.none)
            {
            }
            if (this._isNotGoogleSearch())
            {
                return true;
            }
            if (this._config.allowLocalTracking)
            {
                return true;
            }
            return false;
        }// end function

        private function _updateDomainName() : void
        {
            var _loc_1:String = null;
            if (this._config.domain.mode == DomainNameMode.auto)
            {
                _loc_1 = this._info.domainName;
                if (_loc_1.substring(0, 4) == "www.")
                {
                    _loc_1 = _loc_1.substring(4);
                }
                this._config.domain.name = _loc_1;
            }
            this._config.domainName = this._config.domain.name.toLowerCase();
            this._debug.info("domain name: " + this._config.domainName, VisualDebugMode.advanced);
            return;
        }// end function

        private function _formatReferrer() : String
        {
            var _loc_2:String = null;
            var _loc_3:URL = null;
            var _loc_4:URL = null;
            var _loc_1:* = this._info.referrer;
            if (_loc_1 != "")
            {
            }
            if (_loc_1 == "localhost")
            {
                _loc_1 = "-";
            }
            else
            {
                _loc_2 = this._info.domainName;
                _loc_3 = new URL(_loc_1);
                _loc_4 = new URL("http://" + _loc_2);
                if (_loc_3.hostName == _loc_2)
                {
                    return "-";
                }
                if (_loc_4.domain == _loc_3.domain)
                {
                    if (_loc_4.subDomain != _loc_3.subDomain)
                    {
                        _loc_1 = "0";
                    }
                }
                if (_loc_1.charAt(0) == "[")
                {
                }
                if (_loc_1.charAt((_loc_1.length - 1)))
                {
                    _loc_1 = "-";
                }
            }
            this._debug.info("formated referrer: " + _loc_1, VisualDebugMode.advanced);
            return _loc_1;
        }// end function

        private function _generateUserDataHash() : Number
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + this._info.appName;
            _loc_1 = _loc_1 + this._info.appVersion;
            _loc_1 = _loc_1 + this._info.language;
            _loc_1 = _loc_1 + this._info.platform;
            _loc_1 = _loc_1 + this._info.userAgent.toString();
            _loc_1 = _loc_1 + (this._info.screenWidth + "x" + this._info.screenHeight + this._info.screenColorDepth);
            _loc_1 = _loc_1 + this._info.referrer;
            return Utils.generateHash(_loc_1);
        }// end function

        private function _getUniqueSessionId() : Number
        {
            var _loc_1:* = (Utils.generate32bitRandom() ^ this._generateUserDataHash()) * 2147483647;
            this._debug.info("Session ID: " + _loc_1, VisualDebugMode.geek);
            return _loc_1;
        }// end function

        private function _getDomainHash() : Number
        {
            if (this._config.domainName)
            {
            }
            if (this._config.domainName != "")
            {
            }
            if (this._config.domain.mode == DomainNameMode.none)
            {
                this._config.domainName = "";
                return 1;
            }
            this._updateDomainName();
            if (this._config.allowDomainHash)
            {
                return Utils.generateHash(this._config.domainName);
            }
            return 1;
        }// end function

        private function _visitCode() : Number
        {
            if (this._debug.verbose)
            {
                this._debug.info("visitCode: " + this._buffer.utma.sessionId, VisualDebugMode.geek);
            }
            return this._buffer.utma.sessionId;
        }// end function

        private function _takeSample() : Boolean
        {
            if (this._debug.verbose)
            {
                this._debug.info("takeSample: (" + this._visitCode() % 10000 + ") < (" + this._config.sampleRate * 10000 + ")", VisualDebugMode.geek);
            }
            return this._visitCode() % 10000 < this._config.sampleRate * 10000;
        }// end function

        public function getAccount() : String
        {
            this._debug.info("getAccount()");
            return this._account;
        }// end function

        public function getVersion() : String
        {
            this._debug.info("getVersion()");
            return this._config.version;
        }// end function

        public function resetSession() : void
        {
            this._debug.info("resetSession()");
            this._buffer.resetCurrentSession();
            return;
        }// end function

        public function setSampleRate(newRate:Number) : void
        {
            if (newRate < 0)
            {
                this._debug.warning("sample rate can not be negative, ignoring value.");
            }
            else
            {
                this._config.sampleRate = newRate;
            }
            this._debug.info("setSampleRate( " + this._config.sampleRate + " )");
            return;
        }// end function

        public function setSessionTimeout(newTimeout:int) : void
        {
            this._config.sessionTimeout = newTimeout;
            this._debug.info("setSessionTimeout( " + this._config.sessionTimeout + " )");
            return;
        }// end function

        public function setVar(newVal:String) : void
        {
            var _loc_2:Variables = null;
            if (newVal != "")
            {
            }
            if (this._isNotGoogleSearch())
            {
                this._initData();
                this._buffer.utmv.domainHash = this._domainHash;
                this._buffer.utmv.value = encodeURI(newVal);
                if (this._debug.verbose)
                {
                    this._debug.info(this._buffer.utmv.toString(), VisualDebugMode.geek);
                }
                this._debug.info("setVar( " + newVal + " )");
                if (this._takeSample())
                {
                    _loc_2 = new Variables();
                    _loc_2.utmt = "var";
                    this._gifRequest.send(this._account, _loc_2);
                }
            }
            else
            {
                this._debug.warning("setVar \"" + newVal + "\" is ignored");
            }
            return;
        }// end function

        public function trackPageview(pageURL:String = "") : void
        {
            this._debug.info("trackPageview( " + pageURL + " )");
            if (this._doTracking())
            {
                this._initData();
                this._trackMetrics(pageURL);
                this._noSessionInformation = false;
            }
            else
            {
                this._debug.warning("trackPageview( " + pageURL + " ) failed");
            }
            return;
        }// end function

        private function _renderMetricsSearchVariables(pageURL:String = "") : Variables
        {
            var _loc_4:Variables = null;
            var _loc_2:* = new Variables();
            _loc_2.URIencode = true;
            var _loc_3:* = new DocumentInfo(this._config, this._info, this._formatedReferrer, pageURL, this._adSense);
            this._debug.info("docInfo: " + _loc_3.toURLString(), VisualDebugMode.geek);
            if (this._config.campaignTracking)
            {
                _loc_4 = this._campaignInfo.toVariables();
            }
            var _loc_5:* = this._browserInfo.toVariables();
            _loc_2.join(_loc_3.toVariables(), _loc_5, _loc_4);
            return _loc_2;
        }// end function

        private function _trackMetrics(pageURL:String = "") : void
        {
            var _loc_2:Variables = null;
            var _loc_3:Variables = null;
            var _loc_4:Variables = null;
            var _loc_5:EventInfo = null;
            if (this._takeSample())
            {
                _loc_2 = new Variables();
                _loc_2.URIencode = true;
                if (this._x10Module)
                {
                }
                if (this._x10Module.hasData())
                {
                    _loc_5 = new EventInfo(false, this._x10Module);
                    _loc_3 = _loc_5.toVariables();
                }
                _loc_4 = this._renderMetricsSearchVariables(pageURL);
                _loc_2.join(_loc_3, _loc_4);
                this._gifRequest.send(this._account, _loc_2);
            }
            return;
        }// end function

        public function setAllowAnchor(enable:Boolean) : void
        {
            this._config.allowAnchor = enable;
            this._debug.info("setAllowAnchor( " + this._config.allowAnchor + " )");
            return;
        }// end function

        public function setCampContentKey(newCampContentKey:String) : void
        {
            this._config.campaignKey.UCCT = newCampContentKey;
            var _loc_2:* = "setCampContentKey( " + this._config.campaignKey.UCCT + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCCT]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampMediumKey(newCampMedKey:String) : void
        {
            this._config.campaignKey.UCMD = newCampMedKey;
            var _loc_2:* = "setCampMediumKey( " + this._config.campaignKey.UCMD + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCMD]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampNameKey(newCampNameKey:String) : void
        {
            this._config.campaignKey.UCCN = newCampNameKey;
            var _loc_2:* = "setCampNameKey( " + this._config.campaignKey.UCCN + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCCN]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampNOKey(newCampNOKey:String) : void
        {
            this._config.campaignKey.UCNO = newCampNOKey;
            var _loc_2:* = "setCampNOKey( " + this._config.campaignKey.UCNO + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCNO]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampSourceKey(newCampSrcKey:String) : void
        {
            this._config.campaignKey.UCSR = newCampSrcKey;
            var _loc_2:* = "setCampSourceKey( " + this._config.campaignKey.UCSR + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCSR]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampTermKey(newCampTermKey:String) : void
        {
            this._config.campaignKey.UCTR = newCampTermKey;
            var _loc_2:* = "setCampTermKey( " + this._config.campaignKey.UCTR + " )";
            if (this._debug.mode == VisualDebugMode.geek)
            {
                this._debug.info(_loc_2 + " [UCTR]");
            }
            else
            {
                this._debug.info(_loc_2);
            }
            return;
        }// end function

        public function setCampaignTrack(enable:Boolean) : void
        {
            this._config.campaignTracking = enable;
            this._debug.info("setCampaignTrack( " + this._config.campaignTracking + " )");
            return;
        }// end function

        public function setCookieTimeout(newDefaultTimeout:int) : void
        {
            this._config.conversionTimeout = newDefaultTimeout;
            this._debug.info("setCookieTimeout( " + this._config.conversionTimeout + " )");
            return;
        }// end function

        public function cookiePathCopy(newPath:String) : void
        {
            this._debug.warning("cookiePathCopy( " + newPath + " ) not implemented");
            return;
        }// end function

        public function getLinkerUrl(targetUrl:String = "", useHash:Boolean = false) : String
        {
            this._initData();
            this._debug.info("getLinkerUrl( " + targetUrl + ", " + useHash.toString() + " )");
            return this._buffer.getLinkerUrl(targetUrl, useHash);
        }// end function

        public function link(targetUrl:String, useHash:Boolean = false) : void
        {
            var targetUrl:* = targetUrl;
            var useHash:* = useHash;
            this._initData();
            var out:* = this._buffer.getLinkerUrl(targetUrl, useHash);
            var request:* = new URLRequest(out);
            this._debug.info("link( " + [targetUrl, useHash].join(",") + " )");
            try
            {
                navigateToURL(request, "_top");
            }
            catch (e:Error)
            {
                _debug.warning("An error occured in link() msg: " + e.message);
            }
            return;
        }// end function

        public function linkByPost(formObject:Object, useHash:Boolean = false) : void
        {
            this._debug.warning("linkByPost not implemented in AS3 mode");
            return;
        }// end function

        public function setAllowHash(enable:Boolean) : void
        {
            this._config.allowDomainHash = enable;
            this._debug.info("setAllowHash( " + this._config.allowDomainHash + " )");
            return;
        }// end function

        public function setAllowLinker(enable:Boolean) : void
        {
            this._config.allowLinker = enable;
            this._debug.info("setAllowLinker( " + this._config.allowLinker + " )");
            return;
        }// end function

        public function setCookiePath(newCookiePath:String) : void
        {
            this._config.cookiePath = newCookiePath;
            this._debug.info("setCookiePath( " + this._config.cookiePath + " )");
            return;
        }// end function

        public function setDomainName(newDomainName:String) : void
        {
            if (newDomainName == "auto")
            {
                this._config.domain.mode = DomainNameMode.auto;
            }
            else if (newDomainName == "none")
            {
                this._config.domain.mode = DomainNameMode.none;
            }
            else
            {
                this._config.domain.mode = DomainNameMode.custom;
                this._config.domain.name = newDomainName;
            }
            this._updateDomainName();
            this._debug.info("setDomainName( " + this._config.domainName + " )");
            return;
        }// end function

        public function addItem(id:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
        {
            var _loc_7:Transaction = null;
            _loc_7 = this._ecom.getTransaction(id);
            if (_loc_7 == null)
            {
                _loc_7 = this._ecom.addTransaction(id, "", "", "", "", "", "", "");
            }
            _loc_7.addItem(sku, name, category, price.toString(), quantity.toString());
            if (this._debug.active)
            {
                this._debug.info("addItem( " + [id, sku, name, category, price, quantity].join(", ") + " )");
            }
            return;
        }// end function

        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : void
        {
            this._ecom.addTransaction(orderId, affiliation, total.toString(), tax.toString(), shipping.toString(), city, state, country);
            if (this._debug.active)
            {
                this._debug.info("addTrans( " + [orderId, affiliation, total, tax, shipping, city, state, country].join(", ") + " );");
            }
            return;
        }// end function

        public function trackTrans() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_4:Transaction = null;
            this._initData();
            var _loc_3:* = new Array();
            if (this._takeSample())
            {
                _loc_1 = 0;
                while (_loc_1 < this._ecom.getTransLength())
                {
                    
                    _loc_4 = this._ecom.getTransFromArray(_loc_1);
                    _loc_3.push(_loc_4.toGifParams());
                    _loc_2 = 0;
                    while (_loc_2 < _loc_4.getItemsLength())
                    {
                        
                        _loc_3.push(_loc_4.getItemFromArray(_loc_2).toGifParams());
                        _loc_2 = _loc_2 + 1;
                    }
                    _loc_1 = _loc_1 + 1;
                }
                _loc_1 = 0;
                while (_loc_1 < _loc_3.length)
                {
                    
                    this._gifRequest.send(this._account, _loc_3[_loc_1]);
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

        private function _sendXEvent(opt_xObj:X10 = null) : void
        {
            var _loc_2:Variables = null;
            var _loc_3:EventInfo = null;
            var _loc_4:Variables = null;
            var _loc_5:Variables = null;
            if (this._takeSample())
            {
                _loc_2 = new Variables();
                _loc_2.URIencode = true;
                _loc_3 = new EventInfo(true, this._x10Module, opt_xObj);
                _loc_4 = _loc_3.toVariables();
                _loc_5 = this._renderMetricsSearchVariables();
                _loc_2.join(_loc_4, _loc_5);
                this._gifRequest.send(this._account, _loc_2, false, true);
            }
            return;
        }// end function

        public function createEventTracker(objName:String) : EventTracker
        {
            this._debug.info("createEventTracker( " + objName + " )");
            return new EventTracker(objName, this);
        }// end function

        public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
        {
            this._initData();
            var _loc_5:Boolean = true;
            var _loc_6:int = 2;
            if (category != "")
            {
            }
            if (action != "")
            {
                this._eventTracker.clearKey(this.EVENT_TRACKER_PROJECT_ID);
                this._eventTracker.clearValue(this.EVENT_TRACKER_PROJECT_ID);
                _loc_5 = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID, this.EVENT_TRACKER_OBJECT_NAME_KEY_NUM, category);
                _loc_5 = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID, this.EVENT_TRACKER_TYPE_KEY_NUM, action);
                if (label)
                {
                    _loc_5 = this._eventTracker.setKey(this.EVENT_TRACKER_PROJECT_ID, this.EVENT_TRACKER_LABEL_KEY_NUM, label);
                    _loc_6 = 3;
                }
                if (!isNaN(value))
                {
                    _loc_5 = this._eventTracker.setValue(this.EVENT_TRACKER_PROJECT_ID, this.EVENT_TRACKER_VALUE_VALUE_NUM, value);
                    _loc_6 = 4;
                }
                if (_loc_5)
                {
                    this._debug.info("valid event tracking call\ncategory: " + category + "\naction: " + action, VisualDebugMode.geek);
                    this._sendXEvent(this._eventTracker);
                }
            }
            else
            {
                this._debug.warning("event tracking call is not valid, failed!\ncategory: " + category + "\naction: " + action, VisualDebugMode.geek);
                _loc_5 = false;
            }
            switch(_loc_6)
            {
                case 4:
                {
                    this._debug.info("trackEvent( " + [category, action, label, value].join(", ") + " )");
                    break;
                }
                case 3:
                {
                    this._debug.info("trackEvent( " + [category, action, label].join(", ") + " )");
                    break;
                }
                case 2:
                {
                }
                default:
                {
                    this._debug.info("trackEvent( " + [category, action].join(", ") + " )");
                    break;
                }
            }
            return _loc_5;
        }// end function

        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
        {
            this._debug.info("addIgnoredOrganic( " + newIgnoredOrganicKeyword + " )");
            this._config.organic.addIgnoredKeyword(newIgnoredOrganicKeyword);
            return;
        }// end function

        public function addIgnoredRef(newIgnoredReferrer:String) : void
        {
            this._debug.info("addIgnoredRef( " + newIgnoredReferrer + " )");
            this._config.organic.addIgnoredReferral(newIgnoredReferrer);
            return;
        }// end function

        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
        {
            this._debug.info("addOrganic( " + [newOrganicEngine, newOrganicKeyword].join(", ") + " )");
            this._config.organic.addSource(newOrganicEngine, newOrganicKeyword);
            return;
        }// end function

        public function clearIgnoredOrganic() : void
        {
            this._debug.info("clearIgnoredOrganic()");
            this._config.organic.clearIgnoredKeywords();
            return;
        }// end function

        public function clearIgnoredRef() : void
        {
            this._debug.info("clearIgnoredRef()");
            this._config.organic.clearIgnoredReferrals();
            return;
        }// end function

        public function clearOrganic() : void
        {
            this._debug.info("clearOrganic()");
            this._config.organic.clearEngines();
            return;
        }// end function

        public function getClientInfo() : Boolean
        {
            this._debug.info("getClientInfo()");
            return this._config.detectClientInfo;
        }// end function

        public function getDetectFlash() : Boolean
        {
            this._debug.info("getDetectFlash()");
            return this._config.detectFlash;
        }// end function

        public function getDetectTitle() : Boolean
        {
            this._debug.info("getDetectTitle()");
            return this._config.detectTitle;
        }// end function

        public function setClientInfo(enable:Boolean) : void
        {
            this._config.detectClientInfo = enable;
            this._debug.info("setClientInfo( " + this._config.detectClientInfo + " )");
            return;
        }// end function

        public function setDetectFlash(enable:Boolean) : void
        {
            this._config.detectFlash = enable;
            this._debug.info("setDetectFlash( " + this._config.detectFlash + " )");
            return;
        }// end function

        public function setDetectTitle(enable:Boolean) : void
        {
            this._config.detectTitle = enable;
            this._debug.info("setDetectTitle( " + this._config.detectTitle + " )");
            return;
        }// end function

        public function getLocalGifPath() : String
        {
            this._debug.info("getLocalGifPath()");
            return this._config.localGIFpath;
        }// end function

        public function getServiceMode() : ServerOperationMode
        {
            this._debug.info("getServiceMode()");
            return this._config.serverMode;
        }// end function

        public function setLocalGifPath(newLocalGifPath:String) : void
        {
            this._config.localGIFpath = newLocalGifPath;
            this._debug.info("setLocalGifPath( " + this._config.localGIFpath + " )");
            return;
        }// end function

        public function setLocalRemoteServerMode() : void
        {
            this._config.serverMode = ServerOperationMode.both;
            this._debug.info("setLocalRemoteServerMode()");
            return;
        }// end function

        public function setLocalServerMode() : void
        {
            this._config.serverMode = ServerOperationMode.local;
            this._debug.info("setLocalServerMode()");
            return;
        }// end function

        public function setRemoteServerMode() : void
        {
            this._config.serverMode = ServerOperationMode.remote;
            this._debug.info("setRemoteServerMode()");
            return;
        }// end function

    }
}
