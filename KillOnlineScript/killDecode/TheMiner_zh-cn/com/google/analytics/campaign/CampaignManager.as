package com.google.analytics.campaign
{
    import com.google.analytics.core.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.utils.*;
    import com.google.analytics.v4.*;

    public class CampaignManager extends Object
    {
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _buffer:Buffer;
        private var _domainHash:Number;
        private var _referrer:String;
        private var _timeStamp:Number;
        public static const trackingDelimiter:String = "|";

        public function CampaignManager(config:Configuration, debug:DebugConfiguration, buffer:Buffer, domainHash:Number, referrer:String, timeStamp:Number)
        {
            this._config = config;
            this._debug = debug;
            this._buffer = buffer;
            this._domainHash = domainHash;
            this._referrer = referrer;
            this._timeStamp = timeStamp;
            return;
        }// end function

        public function getCampaignInformation(search:String, noSessionInformation:Boolean) : CampaignInfo
        {
            var _loc_4:CampaignTracker = null;
            var _loc_8:CampaignTracker = null;
            var _loc_9:int = 0;
            var _loc_3:* = new CampaignInfo();
            var _loc_5:Boolean = false;
            var _loc_6:Boolean = false;
            var _loc_7:int = 0;
            if (this._config.allowLinker)
            {
            }
            if (this._buffer.isGenuine())
            {
                if (!this._buffer.hasUTMZ())
                {
                    return _loc_3;
                }
            }
            _loc_4 = this.getTrackerFromSearchString(search);
            if (this.isValid(_loc_4))
            {
                _loc_6 = this.hasNoOverride(search);
                if (_loc_6)
                {
                }
                if (!this._buffer.hasUTMZ())
                {
                    return _loc_3;
                }
            }
            if (!this.isValid(_loc_4))
            {
                _loc_4 = this.getOrganicCampaign();
                if (!this._buffer.hasUTMZ())
                {
                }
                if (this.isIgnoredKeyword(_loc_4))
                {
                    return _loc_3;
                }
            }
            if (!this.isValid(_loc_4))
            {
            }
            if (noSessionInformation)
            {
                _loc_4 = this.getReferrerCampaign();
                if (!this._buffer.hasUTMZ())
                {
                }
                if (this.isIgnoredReferral(_loc_4))
                {
                    return _loc_3;
                }
            }
            if (!this.isValid(_loc_4))
            {
                if (!this._buffer.hasUTMZ())
                {
                }
                if (noSessionInformation)
                {
                    _loc_4 = this.getDirectCampaign();
                }
            }
            if (!this.isValid(_loc_4))
            {
                return _loc_3;
            }
            if (this._buffer.hasUTMZ())
            {
                this._buffer.hasUTMZ();
            }
            if (!this._buffer.utmz.isEmpty())
            {
                _loc_8 = new CampaignTracker();
                _loc_8.fromTrackerString(this._buffer.utmz.campaignTracking);
                _loc_5 = _loc_8.toTrackerString() == _loc_4.toTrackerString();
                _loc_7 = this._buffer.utmz.responseCount;
            }
            if (_loc_5)
            {
            }
            if (noSessionInformation)
            {
                _loc_9 = this._buffer.utma.sessionCount;
                _loc_7 = _loc_7 + 1;
                if (_loc_9 == 0)
                {
                    _loc_9 = 1;
                }
                this._buffer.utmz.domainHash = this._domainHash;
                this._buffer.utmz.campaignCreation = this._timeStamp;
                this._buffer.utmz.campaignSessions = _loc_9;
                this._buffer.utmz.responseCount = _loc_7;
                this._buffer.utmz.campaignTracking = _loc_4.toTrackerString();
                this._debug.info(this._buffer.utmz.toString(), VisualDebugMode.geek);
                _loc_3 = new CampaignInfo(false, true);
            }
            else
            {
                _loc_3 = new CampaignInfo(false, false);
            }
            return _loc_3;
        }// end function

        public function getOrganicCampaign() : CampaignTracker
        {
            var _loc_1:CampaignTracker = null;
            var _loc_4:Array = null;
            var _loc_5:OrganicReferrer = null;
            var _loc_6:String = null;
            if (!isInvalidReferrer(this._referrer))
            {
                isInvalidReferrer(this._referrer);
            }
            if (isFromGoogleCSE(this._referrer, this._config))
            {
                return _loc_1;
            }
            var _loc_2:* = new URL(this._referrer);
            var _loc_3:String = "";
            if (_loc_2.hostName != "")
            {
                if (_loc_2.hostName.indexOf(".") > -1)
                {
                    _loc_4 = _loc_2.hostName.split(".");
                    switch(_loc_4.length)
                    {
                        case 2:
                        {
                            _loc_3 = _loc_4[0];
                            break;
                        }
                        case 3:
                        {
                            _loc_3 = _loc_4[1];
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            if (this._config.organic.match(_loc_3))
            {
                _loc_5 = this._config.organic.getReferrerByName(_loc_3);
                _loc_6 = this._config.organic.getKeywordValue(_loc_5, _loc_2.search);
                _loc_1 = new CampaignTracker();
                _loc_1.source = _loc_5.engine;
                _loc_1.name = "(organic)";
                _loc_1.medium = "organic";
                _loc_1.term = _loc_6;
            }
            return _loc_1;
        }// end function

        public function getReferrerCampaign() : CampaignTracker
        {
            var _loc_1:CampaignTracker = null;
            if (!isInvalidReferrer(this._referrer))
            {
                isInvalidReferrer(this._referrer);
            }
            if (isFromGoogleCSE(this._referrer, this._config))
            {
                return _loc_1;
            }
            var _loc_2:* = new URL(this._referrer);
            var _loc_3:* = _loc_2.hostName;
            var _loc_4:* = _loc_2.path;
            if (_loc_3.indexOf("www.") == 0)
            {
                _loc_3 = _loc_3.substr(4);
            }
            _loc_1 = new CampaignTracker();
            _loc_1.source = _loc_3;
            _loc_1.name = "(referral)";
            _loc_1.medium = "referral";
            _loc_1.content = _loc_4;
            return _loc_1;
        }// end function

        public function getDirectCampaign() : CampaignTracker
        {
            var _loc_1:* = new CampaignTracker();
            _loc_1.source = "(direct)";
            _loc_1.name = "(direct)";
            _loc_1.medium = "(none)";
            return _loc_1;
        }// end function

        public function hasNoOverride(search:String) : Boolean
        {
            var _loc_2:* = this._config.campaignKey;
            if (search == "")
            {
                return false;
            }
            var _loc_3:* = new Variables(search);
            var _loc_4:String = "";
            if (_loc_3.hasOwnProperty(_loc_2.UCNO))
            {
                _loc_4 = _loc_3[_loc_2.UCNO];
                switch(_loc_4)
                {
                    case "1":
                    {
                        return true;
                    }
                    case "":
                    case "0":
                    {
                    }
                    default:
                    {
                        return false;
                        break;
                    }
                }
            }
            return false;
        }// end function

        public function isIgnoredKeyword(tracker:CampaignTracker) : Boolean
        {
            if (tracker)
            {
            }
            if (tracker.medium == "organic")
            {
                return this._config.organic.isIgnoredKeyword(tracker.term);
            }
            return false;
        }// end function

        public function isIgnoredReferral(tracker:CampaignTracker) : Boolean
        {
            if (tracker)
            {
            }
            if (tracker.medium == "referral")
            {
                return this._config.organic.isIgnoredReferral(tracker.source);
            }
            return false;
        }// end function

        public function isValid(tracker:CampaignTracker) : Boolean
        {
            if (tracker)
            {
            }
            if (tracker.isValid())
            {
                return true;
            }
            return false;
        }// end function

        public function getTrackerFromSearchString(search:String) : CampaignTracker
        {
            var _loc_2:* = this.getOrganicCampaign();
            var _loc_3:* = new CampaignTracker();
            var _loc_4:* = this._config.campaignKey;
            if (search == "")
            {
                return _loc_3;
            }
            var _loc_5:* = new Variables(search);
            if (_loc_5.hasOwnProperty(_loc_4.UCID))
            {
                _loc_3.id = _loc_5[_loc_4.UCID];
            }
            if (_loc_5.hasOwnProperty(_loc_4.UCSR))
            {
                _loc_3.source = _loc_5[_loc_4.UCSR];
            }
            if (_loc_5.hasOwnProperty(_loc_4.UGCLID))
            {
                _loc_3.clickId = _loc_5[_loc_4.UGCLID];
            }
            if (_loc_5.hasOwnProperty(_loc_4.UCCN))
            {
                _loc_3.name = _loc_5[_loc_4.UCCN];
            }
            else
            {
                _loc_3.name = "(not set)";
            }
            if (_loc_5.hasOwnProperty(_loc_4.UCMD))
            {
                _loc_3.medium = _loc_5[_loc_4.UCMD];
            }
            else
            {
                _loc_3.medium = "(not set)";
            }
            if (_loc_5.hasOwnProperty(_loc_4.UCTR))
            {
                _loc_3.term = _loc_5[_loc_4.UCTR];
            }
            else
            {
                if (_loc_2)
                {
                }
                if (_loc_2.term != "")
                {
                    _loc_3.term = _loc_2.term;
                }
            }
            if (_loc_5.hasOwnProperty(_loc_4.UCCT))
            {
                _loc_3.content = _loc_5[_loc_4.UCCT];
            }
            return _loc_3;
        }// end function

        public static function isInvalidReferrer(referrer:String) : Boolean
        {
            var _loc_2:URL = null;
            if (referrer != "")
            {
            }
            if (referrer != "-")
            {
            }
            if (referrer == "0")
            {
                return true;
            }
            if (referrer.indexOf("://") > -1)
            {
                _loc_2 = new URL(referrer);
                if (_loc_2.protocol != Protocols.file)
                {
                }
                if (_loc_2.protocol == Protocols.none)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public static function isFromGoogleCSE(referrer:String, config:Configuration) : Boolean
        {
            var _loc_3:* = new URL(referrer);
            if (_loc_3.hostName.indexOf(config.google) > -1)
            {
                if (_loc_3.search.indexOf(config.googleSearchParam + "=") > -1)
                {
                    if (_loc_3.path == "/" + config.googleCsePath)
                    {
                        return true;
                    }
                }
            }
            return false;
        }// end function

    }
}
