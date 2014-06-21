package com.google.analytics.core
{
    import com.google.analytics.v4.*;
    import flash.errors.*;

    public class TrackerCache extends Object implements GoogleAnalyticsAPI
    {
        private var _ar:Array;
        public var tracker:GoogleAnalyticsAPI;
        public static var CACHE_THROW_ERROR:Boolean;

        public function TrackerCache(tracker:GoogleAnalyticsAPI = null)
        {
            this.tracker = tracker;
            this._ar = [];
            return;
        }// end function

        public function clear() : void
        {
            this._ar = [];
            return;
        }// end function

        public function element()
        {
            return this._ar[0];
        }// end function

        public function enqueue(name:String, ... args) : Boolean
        {
            if (name == null)
            {
                return false;
            }
            this._ar.push({name:name, args:args});
            return true;
        }// end function

        public function flush() : void
        {
            var _loc_1:Object = null;
            var _loc_2:String = null;
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (this.tracker == null)
            {
                return;
            }
            if (this.size() > 0)
            {
                _loc_4 = this._ar.length;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_1 = this._ar.shift();
                    _loc_2 = _loc_1.name as String;
                    _loc_3 = _loc_1.args as Array;
                    if (_loc_2 != null)
                    {
                    }
                    if (_loc_2 in this.tracker)
                    {
                        (this.tracker[_loc_2] as Function).apply(this.tracker, _loc_3);
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            return;
        }// end function

        public function isEmpty() : Boolean
        {
            return this._ar.length == 0;
        }// end function

        public function size() : uint
        {
            return this._ar.length;
        }// end function

        public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
        {
            this.enqueue("addIgnoredOrganic", newIgnoredOrganicKeyword);
            return;
        }// end function

        public function addIgnoredRef(newIgnoredReferrer:String) : void
        {
            this.enqueue("addIgnoredRef", newIgnoredReferrer);
            return;
        }// end function

        public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
        {
            this.enqueue("addItem", item, sku, name, category, price, quantity);
            return;
        }// end function

        public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
        {
            this.enqueue("addOrganic", newOrganicEngine, newOrganicKeyword);
            return;
        }// end function

        public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : void
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'addTrans\' method for the moment.");
            }
            return;
        }// end function

        public function clearIgnoredOrganic() : void
        {
            this.enqueue("clearIgnoredOrganic");
            return;
        }// end function

        public function clearIgnoredRef() : void
        {
            this.enqueue("clearIgnoredRef");
            return;
        }// end function

        public function clearOrganic() : void
        {
            this.enqueue("clearOrganic");
            return;
        }// end function

        public function createEventTracker(objName:String) : EventTracker
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'createEventTracker\' method for the moment.");
            }
            return null;
        }// end function

        public function cookiePathCopy(newPath:String) : void
        {
            this.enqueue("cookiePathCopy", newPath);
            return;
        }// end function

        public function getAccount() : String
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getAccount\' method for the moment.");
            }
            return "";
        }// end function

        public function getClientInfo() : Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getClientInfo\' method for the moment.");
            }
            return false;
        }// end function

        public function getDetectFlash() : Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getDetectFlash\' method for the moment.");
            }
            return false;
        }// end function

        public function getDetectTitle() : Boolean
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getDetectTitle\' method for the moment.");
            }
            return false;
        }// end function

        public function getLocalGifPath() : String
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getLocalGifPath\' method for the moment.");
            }
            return "";
        }// end function

        public function getServiceMode() : ServerOperationMode
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getServiceMode\' method for the moment.");
            }
            return null;
        }// end function

        public function getVersion() : String
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getVersion\' method for the moment.");
            }
            return "";
        }// end function

        public function resetSession() : void
        {
            this.enqueue("resetSession");
            return;
        }// end function

        public function getLinkerUrl(url:String = "", useHash:Boolean = false) : String
        {
            if (CACHE_THROW_ERROR)
            {
                throw new IllegalOperationError("The tracker is not ready and you can use the \'getLinkerUrl\' method for the moment.");
            }
            return "";
        }// end function

        public function link(targetUrl:String, useHash:Boolean = false) : void
        {
            this.enqueue("link", targetUrl, useHash);
            return;
        }// end function

        public function linkByPost(formObject:Object, useHash:Boolean = false) : void
        {
            this.enqueue("linkByPost", formObject, useHash);
            return;
        }// end function

        public function setAllowAnchor(enable:Boolean) : void
        {
            this.enqueue("setAllowAnchor", enable);
            return;
        }// end function

        public function setAllowHash(enable:Boolean) : void
        {
            this.enqueue("setAllowHash", enable);
            return;
        }// end function

        public function setAllowLinker(enable:Boolean) : void
        {
            this.enqueue("setAllowLinker", enable);
            return;
        }// end function

        public function setCampContentKey(newCampContentKey:String) : void
        {
            this.enqueue("setCampContentKey", newCampContentKey);
            return;
        }// end function

        public function setCampMediumKey(newCampMedKey:String) : void
        {
            this.enqueue("setCampMediumKey", newCampMedKey);
            return;
        }// end function

        public function setCampNameKey(newCampNameKey:String) : void
        {
            this.enqueue("setCampNameKey", newCampNameKey);
            return;
        }// end function

        public function setCampNOKey(newCampNOKey:String) : void
        {
            this.enqueue("setCampNOKey", newCampNOKey);
            return;
        }// end function

        public function setCampSourceKey(newCampSrcKey:String) : void
        {
            this.enqueue("setCampSourceKey", newCampSrcKey);
            return;
        }// end function

        public function setCampTermKey(newCampTermKey:String) : void
        {
            this.enqueue("setCampTermKey", newCampTermKey);
            return;
        }// end function

        public function setCampaignTrack(enable:Boolean) : void
        {
            this.enqueue("setCampaignTrack", enable);
            return;
        }// end function

        public function setClientInfo(enable:Boolean) : void
        {
            this.enqueue("setClientInfo", enable);
            return;
        }// end function

        public function setCookieTimeout(newDefaultTimeout:int) : void
        {
            this.enqueue("setCookieTimeout", newDefaultTimeout);
            return;
        }// end function

        public function setCookiePath(newCookiePath:String) : void
        {
            this.enqueue("setCookiePath", newCookiePath);
            return;
        }// end function

        public function setDetectFlash(enable:Boolean) : void
        {
            this.enqueue("setDetectFlash", enable);
            return;
        }// end function

        public function setDetectTitle(enable:Boolean) : void
        {
            this.enqueue("setDetectTitle", enable);
            return;
        }// end function

        public function setDomainName(newDomainName:String) : void
        {
            this.enqueue("setDomainName", newDomainName);
            return;
        }// end function

        public function setLocalGifPath(newLocalGifPath:String) : void
        {
            this.enqueue("setLocalGifPath", newLocalGifPath);
            return;
        }// end function

        public function setLocalRemoteServerMode() : void
        {
            this.enqueue("setLocalRemoteServerMode");
            return;
        }// end function

        public function setLocalServerMode() : void
        {
            this.enqueue("setLocalServerMode");
            return;
        }// end function

        public function setRemoteServerMode() : void
        {
            this.enqueue("setRemoteServerMode");
            return;
        }// end function

        public function setSampleRate(newRate:Number) : void
        {
            this.enqueue("setSampleRate", newRate);
            return;
        }// end function

        public function setSessionTimeout(newTimeout:int) : void
        {
            this.enqueue("setSessionTimeout", newTimeout);
            return;
        }// end function

        public function setVar(newVal:String) : void
        {
            this.enqueue("setVar", newVal);
            return;
        }// end function

        public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
        {
            this.enqueue("trackEvent", category, action, label, value);
            return true;
        }// end function

        public function trackPageview(pageURL:String = "") : void
        {
            this.enqueue("trackPageview", pageURL);
            return;
        }// end function

        public function trackTrans() : void
        {
            this.enqueue("trackTrans");
            return;
        }// end function

    }
}
