package gs
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class TweenLite extends Object
    {
        public var duration:Number;
        public var vars:Object;
        public var delay:Number;
        public var startTime:int;
        public var initTime:int;
        public var tweens:Array;
        public var target:Object;
        protected var _active:Boolean;
        protected var _subTweens:Array;
        protected var _hst:Boolean;
        protected var _hasUpdate:Boolean;
        protected var _isDisplayObject:Boolean;
        protected var _initted:Boolean;
        public static var version:Number = 7.04;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        public static var defaultEase:Function = TweenLite.easeOut;
        static var _all:Dictionary = new Dictionary();
        static var _curTime:uint;
        private static var _classInitted:Boolean;
        private static var _sprite:Sprite = new Sprite();
        private static var _listening:Boolean;
        private static var _timer:Timer = new Timer(2000);

        public function TweenLite(param1:Object, param2:Number, param3:Object)
        {
            var _loc_4:* = undefined;
            if (param1 == null)
            {
                return;
            }
            if (param3.overwrite != false && param1 != null || _all[param1] == undefined)
            {
                delete _all[param1];
                _all[param1] = new Dictionary();
            }
            _all[param1][this] = this;
            this.vars = param3;
            this.duration = param2 || 0.001;
            this.delay = param3.delay || 0;
            this._active = param2 == 0 && this.delay == 0;
            this.target = param1;
            this._isDisplayObject = param1 is DisplayObject;
            if (!(this.vars.ease is Function))
            {
                this.vars.ease = defaultEase;
            }
            if (this.vars.easeParams != null)
            {
                this.vars.proxiedEase = this.vars.ease;
                this.vars.ease = this.easeProxy;
            }
            if (!isNaN(Number(this.vars.autoAlpha)))
            {
                this.vars.alpha = Number(this.vars.autoAlpha);
                this.vars.visible = this.vars.alpha > 0;
            }
            this.tweens = [];
            this._subTweens = [];
            var _loc_5:Boolean = false;
            this._initted = false;
            this._hst = _loc_5;
            if (!_classInitted)
            {
                _curTime = getTimer();
                _sprite.addEventListener(Event.ENTER_FRAME, executeAll);
                _classInitted = true;
            }
            this.initTime = _curTime;
            if (this.vars.runBackwards == true && this.vars.renderOnStart != true || this._active)
            {
                this.initTweenVals();
                this.startTime = _curTime;
                if (this._active)
                {
                    this.render((this.startTime + 1));
                }
                else
                {
                    this.render(this.startTime);
                }
                _loc_4 = this.vars.visible;
                if (this.vars.isTV == true)
                {
                    _loc_4 = this.vars.exposedProps.visible;
                }
                if (_loc_4 != null && this.vars.runBackwards == true && this._isDisplayObject)
                {
                    this.target.visible = Boolean(_loc_4);
                }
            }
            if (!_listening && !this._active)
            {
                _timer.addEventListener("timer", killGarbage);
                _timer.start();
                _listening = true;
            }
            return;
        }// end function

        public function initTweenVals(param1:Boolean = false, param2:String = "") : void
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_6:Array = null;
            var _loc_7:ColorTransform = null;
            var _loc_8:ColorTransform = null;
            var _loc_9:Object = null;
            var _loc_5:* = this.vars;
            if (this.vars.isTV == true)
            {
                _loc_5 = _loc_5.exposedProps;
            }
            if (this.target is Array)
            {
                _loc_6 = this.vars.endArray || [];
                _loc_4 = 0;
                while (_loc_4 < _loc_6.length)
                {
                    
                    if (this.target[_loc_4] != _loc_6[_loc_4] && this.target[_loc_4] != undefined)
                    {
                        this.tweens[this.tweens.length] = {o:this.target, p:_loc_4.toString(), s:this.target[_loc_4], c:_loc_6[_loc_4] - this.target[_loc_4]};
                    }
                    _loc_4++;
                }
            }
            else
            {
                if ((typeof(_loc_5.tint) != "undefined" || this.vars.removeTint == true) && this._isDisplayObject)
                {
                    _loc_7 = this.target.transform.colorTransform;
                    _loc_8 = new ColorTransform();
                    if (_loc_5.alpha != undefined)
                    {
                        _loc_8.alphaMultiplier = _loc_5.alpha;
                        delete _loc_5.alpha;
                    }
                    else
                    {
                        _loc_8.alphaMultiplier = this.target.alpha;
                    }
                    if (this.vars.removeTint != true && (_loc_5.tint != null && _loc_5.tint != "" || _loc_5.tint == 0))
                    {
                        _loc_8.color = _loc_5.tint;
                    }
                    this.addSubTween(tintProxy, {progress:0}, {progress:1}, {target:this.target, color:_loc_7, endColor:_loc_8});
                }
                if (_loc_5.frame != null && this._isDisplayObject)
                {
                    this.addSubTween(frameProxy, {frame:this.target.currentFrame}, {frame:_loc_5.frame}, {target:this.target});
                }
                if (!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform"))
                {
                    this.addSubTween(volumeProxy, this.target.soundTransform, {volume:this.vars.volume}, {target:this.target});
                }
                for (_loc_3 in _loc_5)
                {
                    
                    if (_loc_3 == "ease" || _loc_3 == "delay" || _loc_3 == "overwrite" || _loc_3 == "onComplete" || _loc_3 == "onCompleteParams" || _loc_3 == "runBackwards" || _loc_3 == "visible" || _loc_3 == "persist" || _loc_3 == "onUpdate" || _loc_3 == "onUpdateParams" || _loc_3 == "autoAlpha" || _loc_3 == "onStart" || _loc_3 == "onStartParams" || _loc_3 == "renderOnStart" || _loc_3 == "proxiedEase" || _loc_3 == "easeParams" || param1 && param2.indexOf(" " + _loc_3 + " ") != -1)
                    {
                        continue;
                    }
                    if (!(this._isDisplayObject && (_loc_3 == "tint" || _loc_3 == "removeTint" || _loc_3 == "frame")) && !(_loc_3 == "volume" && this.target.hasOwnProperty("soundTransform")))
                    {
                        if (typeof(_loc_5[_loc_3]) == "number")
                        {
                            this.tweens[this.tweens.length] = {o:this.target, p:_loc_3, s:this.target[_loc_3], c:_loc_5[_loc_3] - this.target[_loc_3]};
                            continue;
                        }
                        this.tweens[this.tweens.length] = {o:this.target, p:_loc_3, s:this.target[_loc_3], c:Number(_loc_5[_loc_3])};
                    }
                }
            }
            if (this.vars.runBackwards == true)
            {
                _loc_4 = this.tweens.length - 1;
                while (_loc_4 > -1)
                {
                    
                    _loc_9 = this.tweens[_loc_4];
                    this.tweens[_loc_4].s = _loc_9.s + _loc_9.c;
                    _loc_9.c = _loc_9.c * -1;
                    _loc_4 = _loc_4 - 1;
                }
            }
            if (_loc_5.visible == true && this._isDisplayObject)
            {
                this.target.visible = true;
            }
            if (this.vars.onUpdate != null)
            {
                this._hasUpdate = true;
            }
            this._initted = true;
            return;
        }// end function

        protected function addSubTween(param1:Function, param2:Object, param3:Object, param4:Object = null) : void
        {
            var _loc_6:String = null;
            var _loc_5:Object = {proxy:param1, target:param2, info:param4};
            this._subTweens[this._subTweens.length] = _loc_5;
            for (_loc_6 in param3)
            {
                
                if (typeof(param3[_loc_6]) == "number")
                {
                    this.tweens[this.tweens.length] = {o:param2, p:_loc_6, s:param2[_loc_6], c:param3[_loc_6] - param2[_loc_6], sub:_loc_5};
                    continue;
                }
                this.tweens[this.tweens.length] = {o:param2, p:_loc_6, s:param2[_loc_6], c:Number(param3[_loc_6]), sub:_loc_5};
            }
            this._hst = true;
            return;
        }// end function

        public function render(param1:uint) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            var _loc_2:* = (param1 - this.startTime) / 1000;
            if (_loc_2 >= this.duration)
            {
                _loc_2 = this.duration;
                _loc_3 = 1;
            }
            else
            {
                _loc_3 = this.vars.ease(_loc_2, 0, 1, this.duration);
            }
            _loc_5 = this.tweens.length - 1;
            while (_loc_5 > -1)
            {
                
                _loc_4 = this.tweens[_loc_5];
                _loc_4.o[_loc_4.p] = _loc_4.s + _loc_3 * _loc_4.c;
                _loc_5 = _loc_5 - 1;
            }
            if (this._hst)
            {
                _loc_5 = this._subTweens.length - 1;
                while (_loc_5 > -1)
                {
                    
                    this._subTweens[_loc_5].proxy(this._subTweens[_loc_5]);
                    _loc_5 = _loc_5 - 1;
                }
            }
            if (this._hasUpdate)
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            if (_loc_2 == this.duration)
            {
                this.complete(true);
            }
            return;
        }// end function

        public function complete(param1:Boolean = false) : void
        {
            if (!param1)
            {
                if (!this._initted)
                {
                    this.initTweenVals();
                }
                this.startTime = _curTime - this.duration * 1000;
                this.render(_curTime);
                return;
            }
            if (this.vars.visible != undefined && this._isDisplayObject)
            {
                if (!isNaN(this.vars.autoAlpha) && this.target.alpha == 0)
                {
                    this.target.visible = false;
                }
                else if (this.vars.runBackwards != true)
                {
                    this.target.visible = this.vars.visible;
                }
            }
            if (this.vars.persist != true)
            {
                removeTween(this);
            }
            if (this.vars.onComplete != null)
            {
                this.vars.onComplete.apply(null, this.vars.onCompleteParams);
            }
            return;
        }// end function

        protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
        }// end function

        public function get active() : Boolean
        {
            if (this._active)
            {
                return true;
            }
            if ((_curTime - this.initTime) / 1000 > this.delay)
            {
                this._active = true;
                this.startTime = this.initTime + this.delay * 1000;
                if (!this._initted)
                {
                    this.initTweenVals();
                }
                else if (this.vars.visible != undefined && this._isDisplayObject)
                {
                    this.target.visible = true;
                }
                if (this.vars.onStart != null)
                {
                    this.vars.onStart.apply(null, this.vars.onStartParams);
                }
                if (this.duration == 0.001)
                {
                    (this.startTime - 1);
                }
                return true;
            }
            else
            {
                return false;
            }
        }// end function

        public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
        {
            return new TweenLite(param1, param2, param3);
        }// end function

        public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
        {
            param3.runBackwards = true;
            return new TweenLite(param1, param2, param3);
        }// end function

        public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
        {
            return new TweenLite(param2, 0, {delay:param1, onComplete:param2, onCompleteParams:param3, overwrite:false});
        }// end function

        public static function executeAll(event:Event = null) : void
        {
            var _loc_3:Dictionary = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:* = getTimer();
            _curTime = getTimer();
            var _loc_2:* = _loc_6;
            if (_listening)
            {
                _loc_3 = _all;
                for each (_loc_4 in _loc_3)
                {
                    
                    for (_loc_5 in _loc_4)
                    {
                        
                        if (_loc_4[_loc_5] != undefined && _loc_4[_loc_5].active)
                        {
                            _loc_4[_loc_5].render(_loc_2);
                        }
                    }
                }
            }
            return;
        }// end function

        public static function removeTween(param1:TweenLite = null) : void
        {
            if (param1 != null && _all[param1.target] != undefined)
            {
                delete _all[param1.target][param1];
            }
            return;
        }// end function

        public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
        {
            var _loc_3:Object = null;
            var _loc_4:* = undefined;
            if (param1 != null && _all[param1] != undefined)
            {
                if (param2)
                {
                    _loc_3 = _all[param1];
                    for (_loc_4 in _loc_3)
                    {
                        
                        _loc_3[_loc_4].complete(false);
                    }
                }
                delete _all[param1];
            }
            return;
        }// end function

        public static function killGarbage(event:TimerEvent) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_2:uint = 0;
            for (_loc_4 in _all)
            {
                
                _loc_3 = false;
                for (_loc_5 in _all[_loc_4])
                {
                    
                    _loc_3 = true;
                    break;
                }
                if (!_loc_3)
                {
                    delete _all[_loc_4];
                    continue;
                }
                _loc_2 = _loc_2 + 1;
            }
            if (_loc_2 == 0)
            {
                _timer.removeEventListener("timer", killGarbage);
                _timer.stop();
                _listening = false;
            }
            return;
        }// end function

        public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return (-param3) * _loc_5 * (param1 - 2) + param2;
        }// end function

        public static function tintProxy(param1:Object) : void
        {
            var _loc_2:* = param1.target.progress;
            var _loc_3:* = 1 - _loc_2;
            var _loc_4:* = param1.info.color;
            var _loc_5:* = param1.info.endColor;
            param1.info.target.transform.colorTransform = new ColorTransform(_loc_4.redMultiplier * _loc_3 + _loc_5.redMultiplier * _loc_2, _loc_4.greenMultiplier * _loc_3 + _loc_5.greenMultiplier * _loc_2, _loc_4.blueMultiplier * _loc_3 + _loc_5.blueMultiplier * _loc_2, _loc_4.alphaMultiplier * _loc_3 + _loc_5.alphaMultiplier * _loc_2, _loc_4.redOffset * _loc_3 + _loc_5.redOffset * _loc_2, _loc_4.greenOffset * _loc_3 + _loc_5.greenOffset * _loc_2, _loc_4.blueOffset * _loc_3 + _loc_5.blueOffset * _loc_2, _loc_4.alphaOffset * _loc_3 + _loc_5.alphaOffset * _loc_2);
            return;
        }// end function

        public static function frameProxy(param1:Object) : void
        {
            param1.info.target.gotoAndStop(Math.round(param1.target.frame));
            return;
        }// end function

        public static function volumeProxy(param1:Object) : void
        {
            param1.info.target.soundTransform = param1.target;
            return;
        }// end function

    }
}
