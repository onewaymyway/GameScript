package com.google.analytics.core
{
    import com.google.analytics.data.*;
    import com.google.analytics.debug.*;
    import com.google.analytics.v4.*;
    import flash.events.*;
    import flash.net.*;

    dynamic public class Buffer extends Object
    {
        private var _config:Configuration;
        private var _debug:DebugConfiguration;
        private var _SO:SharedObject;
        private var _OBJ:Object;
        private var _data:Object;
        private var _volatile:Boolean;
        private var _utma:UTMA;
        private var _utmb:UTMB;
        private var _utmc:UTMC;
        private var _utmk:UTMK;
        private var _utmx:UTMX;
        private var _utmv:UTMV;
        private var _utmz:UTMZ;

        public function Buffer(config:Configuration, debug:DebugConfiguration, volatile:Boolean = false, data:Object = null)
        {
            var _loc_5:String = null;
            this._config = config;
            this._debug = debug;
            this._data = data;
            this._volatile = volatile;
            if (this._volatile)
            {
                this._OBJ = new Object();
                if (this._data)
                {
                    for (_loc_5 in this._data)
                    {
                        
                        this._OBJ[_loc_5] = this._data[_loc_5];
                    }
                }
            }
            return;
        }// end function

        private function _onFlushStatus(event:NetStatusEvent) : void
        {
            this._debug.info("User closed permission dialog...");
            switch(event.info.code)
            {
                case "SharedObject.Flush.Success":
                {
                    this._debug.info("User granted permission -- value saved.");
                    break;
                }
                case "SharedObject.Flush.Failed":
                {
                    this._debug.info("User denied permission -- value not saved.");
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._SO.removeEventListener(NetStatusEvent.NET_STATUS, this._onFlushStatus);
            return;
        }// end function

        private function _clearUTMA() : void
        {
            this._utma = null;
            if (!this.isVolatile())
            {
                this._SO.data.utma = null;
                delete this._SO.data.utma;
            }
            return;
        }// end function

        private function _clearUTMB() : void
        {
            this._utmb = null;
            if (!this.isVolatile())
            {
                if (this._SO != null)
                {
                }
                if (this._SO.data != null)
                {
                    this._SO.data.utmb = null;
                }
                delete this._SO.data.utmb;
            }
            return;
        }// end function

        private function _clearUTMC() : void
        {
            this._utmc = null;
            return;
        }// end function

        private function _clearUTMV() : void
        {
            this._utmv = null;
            if (!this.isVolatile())
            {
                this._SO.data.utmv = null;
                delete this._SO.data.utmv;
            }
            return;
        }// end function

        private function _clearUTMZ() : void
        {
            this._utmz = null;
            if (!this.isVolatile())
            {
                this._SO.data.utmz = null;
                delete this._SO.data.utmz;
            }
            return;
        }// end function

        private function _createUMTA() : void
        {
            this._utma = new UTMA();
            this._utma.proxy = this;
            return;
        }// end function

        private function _createUMTB() : void
        {
            this._utmb = new UTMB();
            this._utmb.proxy = this;
            return;
        }// end function

        private function _createUMTC() : void
        {
            this._utmc = new UTMC();
            return;
        }// end function

        private function _createUMTK() : void
        {
            this._utmk = new UTMK();
            this._utmk.proxy = this;
            return;
        }// end function

        private function _createUMTX() : void
        {
            this._utmx = new UTMX();
            this._utmx.proxy = this;
            return;
        }// end function

        private function _createUMTV() : void
        {
            this._utmv = new UTMV();
            this._utmv.proxy = this;
            return;
        }// end function

        private function _createUMTZ() : void
        {
            this._utmz = new UTMZ();
            this._utmz.proxy = this;
            return;
        }// end function

        public function createSO() : void
        {
            var saveSO:Boolean;
            UTMZ.defaultTimespan = this._config.conversionTimeout;
            UTMB.defaultTimespan = this._config.sessionTimeout;
            if (!this._volatile)
            {
                try
                {
                    this._SO = SharedObject.getLocal(this._config.cookieName, this._config.cookiePath);
                }
                catch (e:Error)
                {
                    if (_debug.active)
                    {
                        _debug.warning("Shared Object " + _config.cookieName + " failed to be set\nreason: " + e.message);
                    }
                }
                saveSO;
                if (this._SO.data.utma)
                {
                    if (!this.hasUTMA())
                    {
                        this._createUMTA();
                    }
                    this._utma.fromSharedObject(this._SO.data.utma);
                    if (this._debug.verbose)
                    {
                        this._debug.info("found: " + this._utma.toString(true), VisualDebugMode.geek);
                    }
                    if (this._utma.isExpired())
                    {
                        if (this._debug.verbose)
                        {
                            this._debug.warning("UTMA has expired", VisualDebugMode.advanced);
                        }
                        this._clearUTMA();
                        saveSO;
                    }
                }
                if (this._SO.data.utmb)
                {
                    if (!this.hasUTMB())
                    {
                        this._createUMTB();
                    }
                    this._utmb.fromSharedObject(this._SO.data.utmb);
                    if (this._debug.verbose)
                    {
                        this._debug.info("found: " + this._utmb.toString(true), VisualDebugMode.geek);
                    }
                    if (this._utmb.isExpired())
                    {
                        if (this._debug.verbose)
                        {
                            this._debug.warning("UTMB has expired", VisualDebugMode.advanced);
                        }
                        this._clearUTMB();
                        saveSO;
                    }
                }
                if (this._SO.data.utmc)
                {
                    delete this._SO.data.utmc;
                    saveSO;
                }
                if (this._SO.data.utmk)
                {
                    if (!this.hasUTMK())
                    {
                        this._createUMTK();
                    }
                    this._utmk.fromSharedObject(this._SO.data.utmk);
                    if (this._debug.verbose)
                    {
                        this._debug.info("found: " + this._utmk.toString(), VisualDebugMode.geek);
                    }
                }
                if (!this.hasUTMX())
                {
                    this._createUMTX();
                }
                if (this._SO.data.utmv)
                {
                    if (!this.hasUTMV())
                    {
                        this._createUMTV();
                    }
                    this._utmv.fromSharedObject(this._SO.data.utmv);
                    if (this._debug.verbose)
                    {
                        this._debug.info("found: " + this._utmv.toString(true), VisualDebugMode.geek);
                    }
                    if (this._utmv.isExpired())
                    {
                        if (this._debug.verbose)
                        {
                            this._debug.warning("UTMV has expired", VisualDebugMode.advanced);
                        }
                        this._clearUTMV();
                        saveSO;
                    }
                }
                if (this._SO.data.utmz)
                {
                    if (!this.hasUTMZ())
                    {
                        this._createUMTZ();
                    }
                    this._utmz.fromSharedObject(this._SO.data.utmz);
                    if (this._debug.verbose)
                    {
                        this._debug.info("found: " + this._utmz.toString(true), VisualDebugMode.geek);
                    }
                    if (this._utmz.isExpired())
                    {
                        if (this._debug.verbose)
                        {
                            this._debug.warning("UTMZ has expired", VisualDebugMode.advanced);
                        }
                        this._clearUTMZ();
                        saveSO;
                    }
                }
                if (saveSO)
                {
                    this.save();
                }
            }
            return;
        }// end function

        public function get utma() : UTMA
        {
            if (!this.hasUTMA())
            {
                this._createUMTA();
            }
            return this._utma;
        }// end function

        public function get utmb() : UTMB
        {
            if (!this.hasUTMB())
            {
                this._createUMTB();
            }
            return this._utmb;
        }// end function

        public function get utmc() : UTMC
        {
            if (!this.hasUTMC())
            {
                this._createUMTC();
            }
            return this._utmc;
        }// end function

        public function get utmk() : UTMK
        {
            if (!this.hasUTMK())
            {
                this._createUMTK();
            }
            return this._utmk;
        }// end function

        public function get utmx() : UTMX
        {
            if (!this.hasUTMX())
            {
                this._createUMTX();
            }
            return this._utmx;
        }// end function

        public function get utmv() : UTMV
        {
            if (!this.hasUTMV())
            {
                this._createUMTV();
            }
            return this._utmv;
        }// end function

        public function get utmz() : UTMZ
        {
            if (!this.hasUTMZ())
            {
                this._createUMTZ();
            }
            return this._utmz;
        }// end function

        public function hasUTMA() : Boolean
        {
            if (this._utma)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMB() : Boolean
        {
            if (this._utmb)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMC() : Boolean
        {
            if (this._utmc)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMK() : Boolean
        {
            if (this._utmk)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMV() : Boolean
        {
            if (this._utmv)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMX() : Boolean
        {
            if (this._utmx)
            {
                return true;
            }
            return false;
        }// end function

        public function hasUTMZ() : Boolean
        {
            if (this._utmz)
            {
                return true;
            }
            return false;
        }// end function

        public function update(name:String, value) : void
        {
            if (this.isVolatile())
            {
                this._OBJ[name] = value;
            }
            else
            {
                this._SO.data[name] = value;
            }
            return;
        }// end function

        public function clearCookies() : void
        {
            this.utma.reset();
            this.utmb.reset();
            this.utmc.reset();
            this.utmz.reset();
            this.utmv.reset();
            this.utmk.reset();
            return;
        }// end function

        public function generateCookiesHash() : Number
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + this.utma.valueOf();
            _loc_1 = _loc_1 + this.utmb.valueOf();
            _loc_1 = _loc_1 + this.utmc.valueOf();
            _loc_1 = _loc_1 + this.utmx.valueOf();
            _loc_1 = _loc_1 + this.utmz.valueOf();
            _loc_1 = _loc_1 + this.utmv.valueOf();
            return Utils.generateHash(_loc_1);
        }// end function

        public function toLinkerParams() : String
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + this.utma.toURLString();
            _loc_1 = _loc_1 + ("&" + this.utmb.toURLString());
            _loc_1 = _loc_1 + ("&" + this.utmc.toURLString());
            _loc_1 = _loc_1 + ("&" + this.utmx.toURLString());
            _loc_1 = _loc_1 + ("&" + this.utmz.toURLString());
            _loc_1 = _loc_1 + ("&" + this.utmv.toURLString());
            _loc_1 = _loc_1 + ("&__utmk=" + this.generateCookiesHash());
            return _loc_1;
        }// end function

        public function getLinkerUrl(targetUrl:String = "", useHash:Boolean = false) : String
        {
            var _loc_3:* = this.toLinkerParams();
            var _loc_4:* = targetUrl;
            var _loc_5:* = targetUrl.split("#");
            if (_loc_3)
            {
                if (useHash)
                {
                    if (_loc_5.length <= 1)
                    {
                        _loc_4 = _loc_4 + ("#" + _loc_3);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("&" + _loc_3);
                    }
                }
                else if (_loc_5.length <= 1)
                {
                    if (targetUrl.indexOf("?") > -1)
                    {
                        _loc_4 = _loc_4 + "&";
                    }
                    else
                    {
                        _loc_4 = _loc_4 + "?";
                    }
                    _loc_4 = _loc_4 + _loc_3;
                }
                else
                {
                    _loc_4 = _loc_5[0];
                    if (targetUrl.indexOf("?") > -1)
                    {
                        _loc_4 = _loc_4 + "&";
                    }
                    else
                    {
                        _loc_4 = _loc_4 + "?";
                    }
                    _loc_4 = _loc_4 + (_loc_3 + "#" + _loc_5[1]);
                }
            }
            return _loc_4;
        }// end function

        public function isVolatile() : Boolean
        {
            return this._volatile;
        }// end function

        public function isGenuine() : Boolean
        {
            if (!this.hasUTMK())
            {
                return true;
            }
            return this.utmk.hash == this.generateCookiesHash();
        }// end function

        public function updateUTMA(timestamp:Number) : void
        {
            if (this._debug.verbose)
            {
                this._debug.info("updateUTMA( " + timestamp + " )", VisualDebugMode.advanced);
            }
            if (!this.utma.isEmpty())
            {
                if (isNaN(this.utma.sessionCount))
                {
                    this.utma.sessionCount = 1;
                }
                else
                {
                    (this.utma.sessionCount + 1);
                }
                this.utma.lastTime = this.utma.currentTime;
                this.utma.currentTime = timestamp;
            }
            return;
        }// end function

        public function resetCurrentSession() : void
        {
            this._clearUTMB();
            this._clearUTMC();
            this.save();
            return;
        }// end function

        public function save() : void
        {
            var flushStatus:String;
            if (!this.isVolatile())
            {
                flushStatus;
                try
                {
                    flushStatus = this._SO.flush();
                }
                catch (e:Error)
                {
                    _debug.warning("Error...Could not write SharedObject to disk");
                }
                switch(flushStatus)
                {
                    case SharedObjectFlushStatus.PENDING:
                    {
                        this._debug.info("Requesting permission to save object...");
                        this._SO.addEventListener(NetStatusEvent.NET_STATUS, this._onFlushStatus);
                        break;
                    }
                    case SharedObjectFlushStatus.FLUSHED:
                    {
                        this._debug.info("Value flushed to disk.");
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

    }
}
