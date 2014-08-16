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

        public function TweenLite($target:Object, $duration:Number, $vars:Object)
        {
            var _loc_4:* = undefined;
            if ($target == null)
            {
                return;
            }
            if ($vars.overwrite != false)
            {
            }
            if ($target == null)
            {
            }
            if (_all[$target] == undefined)
            {
                delete _all[$target];
                _all[$target] = new Dictionary();
            }
            _all[$target][this] = this;
            this.vars = $vars;
            if (!$duration)
            {
            }
            this.duration = 0.001;
            if (!$vars.delay)
            {
            }
            this.delay = 0;
            if ($duration == 0)
            {
            }
            this._active = this.delay == 0;
            this.target = $target;
            this._isDisplayObject = $target is DisplayObject;
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
            if (this.vars.runBackwards == true)
            {
            }
            if (this.vars.renderOnStart == true)
            {
            }
            if (this._active)
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
                if (_loc_4 != null)
                {
                }
                if (this.vars.runBackwards == true)
                {
                }
                if (this._isDisplayObject)
                {
                    this.target.visible = Boolean(_loc_4);
                }
            }
            if (!_listening)
            {
            }
            if (!this._active)
            {
                _timer.addEventListener("timer", killGarbage);
                _timer.start();
                _listening = true;
            }
            return;
        }// end function

        public function initTweenVals($hrp:Boolean = false, $reservedProps:String = "") : void
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_6:Array = null;
            var _loc_7:ColorTransform = null;
            var _loc_8:ColorTransform = null;
            var _loc_9:Object = null;
            var _loc_5:* = this.vars;
            if (_loc_5.isTV == true)
            {
                _loc_5 = _loc_5.exposedProps;
            }
            if (this.target is Array)
            {
                if (!this.vars.endArray)
                {
                }
                _loc_6 = [];
                _loc_4 = 0;
                while (_loc_4 < _loc_6.length)
                {
                    
                    if (this.target[_loc_4] != _loc_6[_loc_4])
                    {
                    }
                    if (this.target[_loc_4] != undefined)
                    {
                        this.tweens[this.tweens.length] = {o:this.target, p:_loc_4.toString(), s:this.target[_loc_4], c:_loc_6[_loc_4] - this.target[_loc_4]};
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            else
            {
                if (typeof(_loc_5.tint) == "undefined")
                {
                }
                if (this.vars.removeTint == true)
                {
                }
                if (this._isDisplayObject)
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
                    if (this.vars.removeTint != true)
                    {
                        if (_loc_5.tint != null)
                        {
                        }
                        if (_loc_5.tint == "")
                        {
                        }
                    }
                    if (_loc_5.tint == 0)
                    {
                        _loc_8.color = _loc_5.tint;
                    }
                    this.addSubTween(tintProxy, {progress:0}, {progress:1}, {target:this.target, color:_loc_7, endColor:_loc_8});
                }
                if (_loc_5.frame != null)
                {
                }
                if (this._isDisplayObject)
                {
                    this.addSubTween(frameProxy, {frame:this.target.currentFrame}, {frame:_loc_5.frame}, {target:this.target});
                }
                if (!isNaN(this.vars.volume))
                {
                }
                if (this.target.hasOwnProperty("soundTransform"))
                {
                    this.addSubTween(volumeProxy, this.target.soundTransform, {volume:this.vars.volume}, {target:this.target});
                }
                for (_loc_3 in _loc_5)
                {
                    
                    if (_loc_3 != "ease")
                    {
                    }
                    if (_loc_3 != "delay")
                    {
                    }
                    if (_loc_3 != "overwrite")
                    {
                    }
                    if (_loc_3 != "onComplete")
                    {
                    }
                    if (_loc_3 != "onCompleteParams")
                    {
                    }
                    if (_loc_3 != "runBackwards")
                    {
                    }
                    if (_loc_3 != "visible")
                    {
                    }
                    if (_loc_3 != "persist")
                    {
                    }
                    if (_loc_3 != "onUpdate")
                    {
                    }
                    if (_loc_3 != "onUpdateParams")
                    {
                    }
                    if (_loc_3 != "autoAlpha")
                    {
                    }
                    if (_loc_3 != "onStart")
                    {
                    }
                    if (_loc_3 != "onStartParams")
                    {
                    }
                    if (_loc_3 != "renderOnStart")
                    {
                    }
                    if (_loc_3 != "proxiedEase")
                    {
                    }
                    if (_loc_3 != "easeParams")
                    {
                        if ($hrp)
                        {
                        }
                    }
                    if ($reservedProps.indexOf(" " + _loc_3 + " ") != -1)
                    {
                        continue;
                    }
                    if (this._isDisplayObject)
                    {
                        if (_loc_3 != "tint")
                        {
                        }
                        if (_loc_3 != "removeTint")
                        {
                        }
                    }
                    if (_loc_3 != "frame")
                    {
                        if (_loc_3 == "volume")
                        {
                        }
                    }
                    if (!this.target.hasOwnProperty("soundTransform"))
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
                    _loc_9.s = _loc_9.s + _loc_9.c;
                    _loc_9.c = _loc_9.c * -1;
                    _loc_4 = _loc_4 - 1;
                }
            }
            if (_loc_5.visible == true)
            {
            }
            if (this._isDisplayObject)
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

        protected function addSubTween($proxy:Function, $target:Object, $props:Object, $info:Object = null) : void
        {
            var _loc_6:String = null;
            var _loc_5:Object = {proxy:$proxy, target:$target, info:$info};
            this._subTweens[this._subTweens.length] = _loc_5;
            for (_loc_6 in $props)
            {
                
                if (typeof($props[_loc_6]) == "number")
                {
                    this.tweens[this.tweens.length] = {o:$target, p:_loc_6, s:$target[_loc_6], c:$props[_loc_6] - $target[_loc_6], sub:_loc_5};
                    continue;
                }
                this.tweens[this.tweens.length] = {o:$target, p:_loc_6, s:$target[_loc_6], c:Number($props[_loc_6]), sub:_loc_5};
            }
            this._hst = true;
            return;
        }// end function

        public function render($t:uint) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            var _loc_2:* = ($t - this.startTime) / 1000;
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

        public function complete($skipRender:Boolean = false) : void
        {
            if (!$skipRender)
            {
                if (!this._initted)
                {
                    this.initTweenVals();
                }
                this.startTime = _curTime - this.duration * 1000;
                this.render(_curTime);
                return;
            }
            if (this.vars.visible != undefined)
            {
            }
            if (this._isDisplayObject)
            {
                if (!isNaN(this.vars.autoAlpha))
                {
                }
                if (this.target.alpha == 0)
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

        protected function easeProxy($t:Number, $b:Number, $c:Number, $d:Number) : Number
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
                else
                {
                    if (this.vars.visible != undefined)
                    {
                    }
                    if (this._isDisplayObject)
                    {
                        this.target.visible = true;
                    }
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

        public static function to($target:Object, $duration:Number, $vars:Object) : TweenLite
        {
            return new TweenLite($target, $duration, $vars);
        }// end function

        public static function from($target:Object, $duration:Number, $vars:Object) : TweenLite
        {
            $vars.runBackwards = true;
            return new TweenLite($target, $duration, $vars);
        }// end function

        public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null) : TweenLite
        {
            return new TweenLite($onComplete, 0, {delay:$delay, onComplete:$onComplete, onCompleteParams:$onCompleteParams, overwrite:false});
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
                        
                        if (_loc_4[_loc_5] != undefined)
                        {
                        }
                        if (_loc_4[_loc_5].active)
                        {
                            _loc_4[_loc_5].render(_loc_2);
                        }
                    }
                }
            }
            return;
        }// end function

        public static function removeTween($t:TweenLite = null) : void
        {
            if ($t != null)
            {
            }
            if (_all[$t.target] != undefined)
            {
                delete _all[$t.target][$t];
            }
            return;
        }// end function

        public static function killTweensOf($tg:Object = null, $complete:Boolean = false) : void
        {
            var _loc_3:Object = null;
            var _loc_4:* = undefined;
            if ($tg != null)
            {
            }
            if (_all[$tg] != undefined)
            {
                if ($complete)
                {
                    _loc_3 = _all[$tg];
                    for (_loc_4 in _loc_3)
                    {
                        
                        _loc_3[_loc_4].complete(false);
                    }
                }
                delete _all[$tg];
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

        public static function easeOut($t:Number, $b:Number, $c:Number, $d:Number) : Number
        {
            var _loc_5:* = $t / $d;
            $t = $t / $d;
            return (-$c) * _loc_5 * ($t - 2) + $b;
        }// end function

        public static function tintProxy($o:Object) : void
        {
            var _loc_2:* = $o.target.progress;
            var _loc_3:* = 1 - _loc_2;
            var _loc_4:* = $o.info.color;
            var _loc_5:* = $o.info.endColor;
            $o.info.target.transform.colorTransform = new ColorTransform(_loc_4.redMultiplier * _loc_3 + _loc_5.redMultiplier * _loc_2, _loc_4.greenMultiplier * _loc_3 + _loc_5.greenMultiplier * _loc_2, _loc_4.blueMultiplier * _loc_3 + _loc_5.blueMultiplier * _loc_2, _loc_4.alphaMultiplier * _loc_3 + _loc_5.alphaMultiplier * _loc_2, _loc_4.redOffset * _loc_3 + _loc_5.redOffset * _loc_2, _loc_4.greenOffset * _loc_3 + _loc_5.greenOffset * _loc_2, _loc_4.blueOffset * _loc_3 + _loc_5.blueOffset * _loc_2, _loc_4.alphaOffset * _loc_3 + _loc_5.alphaOffset * _loc_2);
            return;
        }// end function

        public static function frameProxy($o:Object) : void
        {
            $o.info.target.gotoAndStop(Math.round($o.target.frame));
            return;
        }// end function

        public static function volumeProxy($o:Object) : void
        {
            $o.info.target.soundTransform = $o.target;
            return;
        }// end function

    }
}
