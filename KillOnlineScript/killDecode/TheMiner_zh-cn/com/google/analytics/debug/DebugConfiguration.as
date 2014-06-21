package com.google.analytics.debug
{
    import com.google.analytics.core.*;
    import flash.net.*;
    import flash.utils.*;

    public class DebugConfiguration extends Object
    {
        private var _active:Boolean = false;
        private var _verbose:Boolean = false;
        private var _visualInitialized:Boolean = false;
        private var _mode:VisualDebugMode;
        public var layout:ILayout;
        public var traceOutput:Boolean = false;
        public var javascript:Boolean = false;
        public var GIFRequests:Boolean = false;
        public var showInfos:Boolean = true;
        public var infoTimeout:Number = 1000;
        public var showWarnings:Boolean = true;
        public var warningTimeout:Number = 1500;
        public var minimizedOnStart:Boolean = false;
        public var showHideKey:Number = 32;
        public var destroyKey:Number = 8;

        public function DebugConfiguration()
        {
            this._mode = VisualDebugMode.basic;
            return;
        }// end function

        private function _initializeVisual() : void
        {
            if (this.layout)
            {
                this.layout.init();
                this._visualInitialized = true;
            }
            return;
        }// end function

        private function _destroyVisual() : void
        {
            if (this.layout)
            {
            }
            if (this._visualInitialized)
            {
                this.layout.destroy();
            }
            return;
        }// end function

        public function get mode()
        {
            return this._mode;
        }// end function

        public function set mode(value) : void
        {
            if (value is String)
            {
                switch(value)
                {
                    case "geek":
                    {
                        value = VisualDebugMode.geek;
                        break;
                    }
                    case "advanced":
                    {
                        value = VisualDebugMode.advanced;
                        break;
                    }
                    case "basic":
                    default:
                    {
                        value = VisualDebugMode.basic;
                        break;
                    }
                }
            }
            this._mode = value;
            return;
        }// end function

        protected function trace(message:String) : void
        {
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_2:Array = [];
            var _loc_3:String = "";
            var _loc_4:String = "";
            if (this.mode == VisualDebugMode.geek)
            {
                _loc_3 = getTimer() + " - ";
                _loc_4 = new Array(_loc_3.length).join(" ") + " ";
            }
            if (message.indexOf("\n") > -1)
            {
                _loc_7 = message.split("\n");
                _loc_8 = 0;
                while (_loc_8 < _loc_7.length)
                {
                    
                    if (_loc_7[_loc_8] == "")
                    {
                    }
                    else if (_loc_8 == 0)
                    {
                        _loc_2.push(_loc_3 + _loc_7[_loc_8]);
                    }
                    else
                    {
                        _loc_2.push(_loc_4 + _loc_7[_loc_8]);
                    }
                    _loc_8 = _loc_8 + 1;
                }
            }
            else
            {
                _loc_2.push(_loc_3 + message);
            }
            var _loc_5:* = _loc_2.length;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                _loc_6 = _loc_6 + 1;
            }
            return;
        }// end function

        public function get active() : Boolean
        {
            return this._active;
        }// end function

        public function set active(value:Boolean) : void
        {
            this._active = value;
            if (this._active)
            {
                this._initializeVisual();
            }
            else
            {
                this._destroyVisual();
            }
            return;
        }// end function

        public function get verbose() : Boolean
        {
            return this._verbose;
        }// end function

        public function set verbose(value:Boolean) : void
        {
            this._verbose = value;
            return;
        }// end function

        private function _filter(mode:VisualDebugMode = null) : Boolean
        {
            if (mode)
            {
            }
            return int(mode) >= int(this.mode);
        }// end function

        public function info(message:String, mode:VisualDebugMode = null) : void
        {
            if (this._filter(mode))
            {
                return;
            }
            if (this.layout)
            {
            }
            if (this.showInfos)
            {
                this.layout.createInfo(message);
            }
            if (this.traceOutput)
            {
            }
            return;
        }// end function

        public function warning(message:String, mode:VisualDebugMode = null) : void
        {
            if (this._filter(mode))
            {
                return;
            }
            if (this.layout)
            {
            }
            if (this.showWarnings)
            {
                this.layout.createWarning(message);
            }
            if (this.traceOutput)
            {
                this.trace("## " + message + " ##");
            }
            return;
        }// end function

        public function alert(message:String) : void
        {
            if (this.layout)
            {
                this.layout.createAlert(message);
            }
            if (this.traceOutput)
            {
                this.trace("!! " + message + " !!");
            }
            return;
        }// end function

        public function failure(message:String) : void
        {
            if (this.layout)
            {
                this.layout.createFailureAlert(message);
            }
            if (this.traceOutput)
            {
                this.trace("[-] " + message + " !!");
            }
            return;
        }// end function

        public function success(message:String) : void
        {
            if (this.layout)
            {
                this.layout.createSuccessAlert(message);
            }
            if (this.traceOutput)
            {
                this.trace("[+] " + message + " !!");
            }
            return;
        }// end function

        public function alertGifRequest(message:String, request:URLRequest, ref:GIFRequest) : void
        {
            if (this.layout)
            {
                this.layout.createGIFRequestAlert(message, request, ref);
            }
            if (this.traceOutput)
            {
                this.trace(">> " + message + " <<");
            }
            return;
        }// end function

    }
}
