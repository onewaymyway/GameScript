package com.google.analytics.v4
{
    import com.google.analytics.core.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.external.*;

    public class Bridge extends Object implements GoogleAnalyticsAPI
    {
        private var _account:String;
        private var _debug:DebugConfiguration;
        private var _proxy:JavascriptProxy;
        private var _hasGATracker:Boolean = false;
        private var _jsContainer:String = "_GATracker";
        private static var _checkGAJS_js:XML = <script>r
n            <![CDATA[r
n                function()r
n                {r
n                    if( _gat && _gat._getTracker )r
n                    {r
n                        return true;r
n                    }r
n                    return false;r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function()
                {
                    if( _gat && _gat._getTracker )
                    {
                        return true;
                    }
                    return false;
                }
            ]]>
        </script>;
        private static var _checkValidTrackingObject_js:XML = <script>r
n            <![CDATA[r
n                function(acct)r
n                {r
n                    if( _GATracker[acct] && (_GATracker[acct]._getAccount) )r
n                    {r
n                        return true ;r
n                    }r
n                    elser
n                    {r
n                        return false;r
n                    }r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function(acct)
                {
                    if( _GATracker[acct] && (_GATracker[acct]._getAccount) )
                    {
                        return true ;
                    }
                    else
                    {
                        return false;
                    }
                }
            ]]>
        </script>;
        private static var _createTrackingObject_js:XML = <script>r
n            <![CDATA[r
n                function( acct )r
n                {r
n                    _GATracker[acct] = _gat._getTracker(acct);r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function( acct )
                {
                    _GATracker[acct] = _gat._getTracker(acct);
                }
            ]]>
        </script>;
        private static var _injectTrackingObject_js:XML = <script>r
n            <![CDATA[r
n                function()r
n                {r
n                    try r
n                    {r
n                        _GATrackerr
n                    }r
n                    catch(e) r
n                    {r
n                        _GATracker = {};r
n                    }r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function()
                {
                    try 
                    {
                        _GATracker
                    }
                    catch(e) 
                    {
                        _GATracker = {};
                    }
                }
            ]]>
        </script>;
        private static var _linkTrackingObject_js:XML = <script>r
n            <![CDATA[r
n                function( container , target )r
n                {r
n                    var targets ;r
n                    var name ;r
n                    if( target.indexOf(""."") > 0 )r
n                    {r
n                        targets = target.split(""."");r
n                        name    = targets.pop();r
n                    }r
n                    elser
n                    {r
n                        targets = [];r
n                        name    = target;r
n                    }r
n                    var ref   = window;r
n                    var depth = targets.length;r
n                    for( var j = 0 ; j < depth ; j++ )r
n                    {r
n                        ref = ref[ targets[j] ] ;r
n                    }r
n                    window[container][target] = ref[name] ;r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function( container , target )
                {
                    var targets ;
                    var name ;
                    if( target.indexOf(".") > 0 )
                    {
                        targets = target.split(".");
                        name    = targets.pop();
                    }
                    else
                    {
                        targets = [];
                        name    = target;
                    }
                    var ref   = window;
                    var depth = targets.length;
                    for( var j = 0 ; j < depth ; j++ )
                    {
                        ref = ref[ targets[j] ] ;
                    }
                    window[container][target] = ref[name] ;
                }
            ]]>
        </script>;

        public function Bridge(account:String, debug:DebugConfiguration, jsproxy:JavascriptProxy)
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            this._account = account;
            this._debug = debug;
            this._proxy = jsproxy;
            if (!this._checkGAJS())
            {
                _loc_4 = "";
                _loc_4 = _loc_4 + "ga.js not found, be sure to check if\n";
                _loc_4 = _loc_4 + "<script src=\"http://www.google-analytics.com/ga.js\"></script>\n";
                _loc_4 = _loc_4 + "is included in the HTML.";
                this._debug.warning(_loc_4);
                throw new Error(_loc_4);
            }
            if (!this._hasGATracker)
            {
                if (this._debug.javascript)
                {
                }
                if (this._debug.verbose)
                {
                    _loc_5 = "";
                    _loc_5 = _loc_5 + "The Google Analytics tracking code was not found on the container page\n";
                    _loc_5 = _loc_5 + "we create it";
                    this._debug.info(_loc_5, VisualDebugMode.advanced);
                }
                this._injectTrackingObject();
            }
            if (Utils.validateAccount(account))
            {
                this._createTrackingObject(account);
            }
            else if (this._checkTrackingObject(account))
            {
                this._linkTrackingObject(account);
            }
            else
            {
                _loc_6 = "";
                _loc_6 = _loc_6 + ("JS Object \"" + account + "\" doesn\'t exist in DOM\n");
                _loc_6 = _loc_6 + "Bridge object not created.";
                this._debug.warning(_loc_6);
                throw new Error(_loc_6);
            }
            return;
        }// end function

        private function _call(functionName:String, ... args)
        {
            args.unshift("window." + this._jsContainer + "[\"" + this._account + "\"]." + functionName);
            return this._proxy.call.apply(this._proxy, args);
        }// end function

        private function _checkGAJS() : Boolean
        {
            return this._proxy.call(_checkGAJS_js);
        }// end function

        private function _checkTrackingObject(account:String) : Boolean
        {
            var _loc_2:* = this._proxy.hasProperty(account);
            var _loc_3:* = this._proxy.hasProperty(account + "._getAccount");
            if (_loc_2)
            {
            }
            return _loc_3;
        }// end function

        private function _checkValidTrackingObject(account:String) : Boolean
        {
            return this._proxy.call(_checkValidTrackingObject_js, account);
        }// end function

        private function _createTrackingObject(account:String) : void
        {
            this._proxy.call(_createTrackingObject_js, account);
            return;
        }// end function

        public function hasGAJS() : Boolean
        {
            return this._checkGAJS();
        }// end function

        public function hasTrackingAccount(account:String) : Boolean
        {
            if (Utils.validateAccount(account))
            {
                return this._checkValidTrackingObject(account);
            }
            return this._checkTrackingObject(account);
        }// end function

        private function _injectTrackingObject() : void
        {
            this._proxy.executeBlock(_injectTrackingObject_js);
            this._hasGATracker = true;
            return;
        }// end function

        private function _linkTrackingObject(path:String) : void
        {
            this._proxy.call(_linkTrackingObject_js, this._jsContainer, path);
            return;
        }// end function

        public function getAccount() : String
        {
            this._debug.info("getAccount()");
            return this._call("_getAccount");
        }// end function

        public function getVersion() : String
        {
            this._debug.info("getVersion()");
            return this._call("_getVersion");
        }// end function

        public function resetSession() : void
        {
            this._debug.warning("resetSession() not implemented");
            return;
        }// end function

        public function setSampleRate(newRate:Number) : void
        {
            this._debug.info("setSampleRate( " + newRate + " )");
            this._call("_setSampleRate", newRate);
            return;
        }// end function

        public function setSessionTimeout(newTimeout:int) : void
        {
            this._debug.info("setSessionTimeout( " + newTimeout + " )");
            this._call("_setSessionTimeout", newTimeout);
            return;
        }// end function

        public function setVar(newVal:String) : void
        {
            this._debug.info("setVar( " + newVal + " )");
            this._call("_setVar", newVal);
            return;
        }// end function

        public function trackPageview(pageURL:String = "") : void
        {
            this._debug.info("trackPageview( " + pageURL + " )");
            this._call("_trackPageview", pageURL);
            return;
        }// end function

        public function setAllowAnchor(enable:Boolean) : void
        {
            this._debug.info("setAllowAnchor( " + enable + " )");
            this._call("_setAllowAnchor", enable);
            return;
        }// end function

        public function setCampContentKey(newCampContentKey:String) : void
        {
            this._debug.info("setCampContentKey( " + newCampContentKey + " )");
            this._call("_setCampContentKey", newCampContentKey);
            return;
        }// end function

        public function setCampMediumKey(newCampMedKey:String) : void
        {
            this._debug.info("setCampMediumKey( " + newCampMedKey + " )");
            this._call("_setCampMediumKey", newCampMedKey);
            return;
        }// end function

        public function setCampNameKey(newCampNameKey:String) : void
        {
            this._debug.info("setCampNameKey( " + newCampNameKey + " )");
            this._call("_setCampNameKey", newCampNameKey);
            return;
        }// end function

        public function setCampNOKey(newCampNOKey:String) : void
        {
            this._debug.info("setCampNOKey( " + newCampNOKey + " )");
            this._call("_setCampNOKey", newCampNOKey);
            return;
        }// end function

        public function setCampSourceKey(newCampSrcKey:String) : void
        {
            this._debug.info("setCampSourceKey( " + newCampSrcKey + " )");
            this._call("_setCampSourceKey", newCampSrcKey);
            return;
        }// end function

        public function setCampTermKey(newCampTermKey:String) : void
        {
            this._debug.info("setCampTermKey( " + newCampTermKey + " )");
            this._call("_setCampTermKey", newCampTermKey);
            return;
        }// end function

        public function setCampaignTrack(enable:Boolean) : void
        {
            this._debug.info("setCampaignTrack( " + enable + " )");
            this._call("_setCampaignTrack", enable);
            return;
        }// end function

        public function setCookieTimeout(newDefaultTimeout:int) : void
        {
            this._debug.info("setCookieTimeout( " + newDefaultTimeout + " )");
            this._call("_setCookieTimeout", newDefaultTimeout);
            return;
        }// end function

        public function cookiePathCopy(newPath:String) : void
        {
            this._debug.info("cookiePathCopy( " + newPath + " )");
            this._call("_cookiePathCopy", newPath);
            return;
        }// end function

        public function getLinkerUrl(url:String = "", useHash:Boolean = false) : String
        {
            this._debug.info("getLinkerUrl(" + url + ", " + useHash + ")");
            return this._call("_getLinkerUrl", url, useHash);
        }// end function

        public function link(targetUrl:String, useHash:Boolean = false) : void
        {
            this._debug.info("link( " + targetUrl + ", " + useHash + " )");
            this._call("_link", targetUrl, useHash);
            return;
        }// end function

        public function linkByPost(formObject:Object, useHash:Boolean = false) : void
        {
            this._debug.warning("linkByPost( " + formObject + ", " + useHash + " ) not implemented");
            return;
        }// end function

        public function setAllowHash(enable:Boolean) : void
        {
            this._debug.info("setAllowHash( " + enable + " )");
            this._call("_setAllowHash", enable);
            return;
        }// end function

        public function setAllowLinker(enable:Boolean) : void
        {
            this._debug.info("setAllowLinker( " + enable + " )");
            this._call("_setAllowLinker", enable);
            return;
        }// end function

        public function setCookiePath(newCookiePath:String) : void
        {
            this._debug.info("setCookiePath( " + newCookiePath + " )");
            this._call("_setCookiePath", newCookiePath);
            return;
        }// end function

        public function setDomainName(newDomainName:String) : void
        {
            this._debug.info("setDomainName( " + newDomainName + " )");
            this._call("_setDomainName", newDomainName);
            return;
        }// end function

        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
        {
            this._debug.info("addItem( " + [item, sku, name, category, price, quantity].join(", ") + " )");
            this._call("_addItem", item, sku, name, category, price, quantity);
            return;
        }// end function

        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : void
        {
            this._debug.info("addTrans( " + [orderId, affiliation, total, tax, shipping, city, state, country].join(", ") + " )");
            this._call("_addTrans", orderId, affiliation, total, tax, shipping, city, state, country);
            return;
        }// end function

        public function trackTrans() : void
        {
            this._debug.info("trackTrans()");
            this._call("_trackTrans");
            return;
        }// end function

        public function createEventTracker(objName:String) : EventTracker
        {
            this._debug.info("createEventTracker( " + objName + " )");
            return new EventTracker(objName, this);
        }// end function

        public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
        {
            var _loc_5:int = 2;
            if (label)
            {
            }
            if (label != "")
            {
                _loc_5 = 3;
            }
            if (_loc_5 == 3)
            {
            }
            if (!isNaN(value))
            {
                _loc_5 = 4;
            }
            switch(_loc_5)
            {
                case 4:
                {
                    this._debug.info("trackEvent( " + [category, action, label, value].join(", ") + " )");
                    return this._call("_trackEvent", category, action, label, value);
                }
                case 3:
                {
                    this._debug.info("trackEvent( " + [category, action, label].join(", ") + " )");
                    return this._call("_trackEvent", category, action, label);
                }
                case 2:
                {
                }
                default:
                {
                    this._debug.info("trackEvent( " + [category, action].join(", ") + " )");
                    return this._call("_trackEvent", category, action);
                    break;
                }
            }
        }// end function

        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
        {
            this._debug.info("addIgnoredOrganic( " + newIgnoredOrganicKeyword + " )");
            this._call("_addIgnoredOrganic", newIgnoredOrganicKeyword);
            return;
        }// end function

        public function addIgnoredRef(newIgnoredReferrer:String) : void
        {
            this._debug.info("addIgnoredRef( " + newIgnoredReferrer + " )");
            this._call("_addIgnoredRef", newIgnoredReferrer);
            return;
        }// end function

        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
        {
            this._debug.info("addOrganic( " + [newOrganicEngine, newOrganicKeyword].join(", ") + " )");
            this._call("_addOrganic", newOrganicEngine);
            return;
        }// end function

        public function clearIgnoredOrganic() : void
        {
            this._debug.info("clearIgnoredOrganic()");
            this._call("_clearIgnoreOrganic");
            return;
        }// end function

        public function clearIgnoredRef() : void
        {
            this._debug.info("clearIgnoredRef()");
            this._call("_clearIgnoreRef");
            return;
        }// end function

        public function clearOrganic() : void
        {
            this._debug.info("clearOrganic()");
            this._call("_clearOrganic");
            return;
        }// end function

        public function getClientInfo() : Boolean
        {
            this._debug.info("getClientInfo()");
            return this._call("_getClientInfo");
        }// end function

        public function getDetectFlash() : Boolean
        {
            this._debug.info("getDetectFlash()");
            return this._call("_getDetectFlash");
        }// end function

        public function getDetectTitle() : Boolean
        {
            this._debug.info("getDetectTitle()");
            return this._call("_getDetectTitle");
        }// end function

        public function setClientInfo(enable:Boolean) : void
        {
            this._debug.info("setClientInfo( " + enable + " )");
            this._call("_setClientInfo", enable);
            return;
        }// end function

        public function setDetectFlash(enable:Boolean) : void
        {
            this._debug.info("setDetectFlash( " + enable + " )");
            this._call("_setDetectFlash", enable);
            return;
        }// end function

        public function setDetectTitle(enable:Boolean) : void
        {
            this._debug.info("setDetectTitle( " + enable + " )");
            this._call("_setDetectTitle", enable);
            return;
        }// end function

        public function getLocalGifPath() : String
        {
            this._debug.info("getLocalGifPath()");
            return this._call("_getLocalGifPath");
        }// end function

        public function getServiceMode() : ServerOperationMode
        {
            this._debug.info("getServiceMode()");
            return this._call("_getServiceMode");
        }// end function

        public function setLocalGifPath(newLocalGifPath:String) : void
        {
            this._debug.info("setLocalGifPath( " + newLocalGifPath + " )");
            this._call("_setLocalGifPath", newLocalGifPath);
            return;
        }// end function

        public function setLocalRemoteServerMode() : void
        {
            this._debug.info("setLocalRemoteServerMode()");
            this._call("_setLocalRemoteServerMode");
            return;
        }// end function

        public function setLocalServerMode() : void
        {
            this._debug.info("setLocalServerMode()");
            this._call("_setLocalServerMode");
            return;
        }// end function

        public function setRemoteServerMode() : void
        {
            this._debug.info("setRemoteServerMode()");
            this._call("_setRemoteServerMode");
            return;
        }// end function

    }
}
