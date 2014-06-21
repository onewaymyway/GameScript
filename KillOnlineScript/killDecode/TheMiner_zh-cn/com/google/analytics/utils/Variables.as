package com.google.analytics.utils
{
    import flash.net.*;

    dynamic public class Variables extends Object
    {
        public var URIencode:Boolean;
        public var pre:Array;
        public var post:Array;
        public var sort:Boolean = true;

        public function Variables(source:String = null, pre:Array = null, post:Array = null)
        {
            this.pre = [];
            this.post = [];
            if (source)
            {
                this.decode(source);
            }
            if (pre)
            {
                this.pre = pre;
            }
            if (post)
            {
                this.post = post;
            }
            return;
        }// end function

        private function _join(vars:Variables) : void
        {
            var _loc_2:String = null;
            if (!vars)
            {
                return;
            }
            for (_loc_2 in vars)
            {
                
                this[_loc_2] = vars[_loc_2];
            }
            return;
        }// end function

        public function decode(source:String) : void
        {
            var _loc_2:Array = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:Array = null;
            if (source == "")
            {
                return;
            }
            if (source.charAt(0) == "?")
            {
                source = source.substr(1, source.length);
            }
            if (source.indexOf("&") > -1)
            {
                _loc_2 = source.split("&");
            }
            else
            {
                _loc_2 = [source];
            }
            var _loc_7:int = 0;
            while (_loc_7 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_7];
                if (_loc_3.indexOf("=") > -1)
                {
                    _loc_6 = _loc_3.split("=");
                    _loc_4 = _loc_6[0];
                    _loc_5 = decodeURI(_loc_6[1]);
                    this[_loc_4] = _loc_5;
                }
                _loc_7 = _loc_7 + 1;
            }
            return;
        }// end function

        public function join(... args) : void
        {
            args = args.length;
            var _loc_3:int = 0;
            while (_loc_3 < args)
            {
                
                if (!(args[_loc_3] is Variables))
                {
                }
                else
                {
                    this._join(args[_loc_3]);
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function toString() : String
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_1:Array = [];
            for (_loc_3 in this)
            {
                
                _loc_2 = this[_loc_3];
                if (this.URIencode)
                {
                    _loc_2 = encodeURI(_loc_2);
                }
                _loc_1.push(_loc_3 + "=" + _loc_2);
            }
            if (this.sort)
            {
                _loc_1.sort();
            }
            if (this.pre.length > 0)
            {
                this.pre.reverse();
                _loc_5 = 0;
                while (_loc_5 < this.pre.length)
                {
                    
                    _loc_7 = this.pre[_loc_5];
                    _loc_6 = 0;
                    while (_loc_6 < _loc_1.length)
                    {
                        
                        _loc_4 = _loc_1[_loc_6];
                        if (_loc_4.indexOf(_loc_7) == 0)
                        {
                            _loc_1.unshift(_loc_1.splice(_loc_6, 1)[0]);
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                    _loc_5 = _loc_5 + 1;
                }
                this.pre.reverse();
            }
            if (this.post.length > 0)
            {
                _loc_5 = 0;
                while (_loc_5 < this.post.length)
                {
                    
                    _loc_8 = this.post[_loc_5];
                    _loc_6 = 0;
                    while (_loc_6 < _loc_1.length)
                    {
                        
                        _loc_4 = _loc_1[_loc_6];
                        if (_loc_4.indexOf(_loc_8) == 0)
                        {
                            _loc_1.push(_loc_1.splice(_loc_6, 1)[0]);
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            return _loc_1.join("&");
        }// end function

        public function toURLVariables() : URLVariables
        {
            var _loc_2:String = null;
            var _loc_1:* = new URLVariables();
            for (_loc_2 in this)
            {
                
                _loc_1[_loc_2] = this[_loc_2];
            }
            return _loc_1;
        }// end function

    }
}
