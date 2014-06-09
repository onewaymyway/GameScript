package com.tg.avatar.war
{
	import com.tg.avatar.war.data.MovieDataFormat;
	import com.tg.avatar.war.load.AnimationDataManager;
	import com.tools.DebugTools;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

    public class Movie extends Sprite
    {
		protected static var _bitmapList:Dictionary;
		
        protected var _frameInterval:int = 0;	// 动画间隔
        protected var _frameRate:Number = 0;	// 帧率
        protected var _defaultFrameAction:Function;	// 
        protected var _width:Number;			// 
        protected var _height:Number;			// 
        protected var _regPoint:Point;			// 
		protected var _defaultAction:Function;	// 
		
		protected var _frames:Vector.<BitmapData>;
		protected var _totalFrames:int = 0;
		protected var _currentFrame:int = 0;
		private var _stoped:Boolean = false;
		private var _loop:Boolean = true;
		private var _endFrameAction:Function;
		private var _mc:Bitmap;
		protected var _changedRegPoint:Point;
        
        private var _framesAction:Array;
        private var _timer:Timer;
        
        public function Movie(frameRate:Number = 0)
        {
            this._frames = Vector.<BitmapData>([]);
            this._regPoint = new Point(0, 0);
            this._changedRegPoint = this._regPoint;
            this._framesAction = [];
            this._frameRate = frameRate;
			
            this._mc = new Bitmap(null, "auto", true);
            addChild(this._mc);
        }
		
        public function clear() : void
        {
            this.stop();
            this.removeAllFrameAction();
			
			for (var k:* in _bitmapList)
			{
				delete _bitmapList[k];
			}
			_bitmapList = null;
			
			//WarResManager.me.clear();
		
			var currentFrameBmpd:*;
//			while(Boolean(currentFrameBmpd = _frames.pop() as BitmapData))
//				currentFrameBmpd.dispose();
			
//            this._frames = [];
            this.defaultFrameAction = null;
//			if(_mc&&_mc.bitmapData) _mc.bitmapData.dispose();
            this._mc = null;
			if(_timer)
			{
				_timer.stop();
				this._timer.removeEventListener(TimerEvent.TIMER, this.onEnterFrameHandler);
	            this._timer = null;
			}
        }

		// ---------- 调试测试，重心点
		private var regPointMC:Sprite;
        public function showRegPoint() : void
        {
            if (this.regPointMC == null)
            {
                this.regPointMC = new Sprite();
				regPointMC.graphics.lineStyle(1, 0xFF0000);
				regPointMC.graphics.drawCircle(0, 0, 10);
				regPointMC.graphics.moveTo(-15, 0);
				regPointMC.graphics.lineTo(15, 0);
				regPointMC.graphics.moveTo(0, -15);
				regPointMC.graphics.lineTo(0, 15);
				addChild(this.regPointMC);
            }
        }
        public function hideRegPoint() : void
        {
            if (this.regPointMC != null)
            {
                removeChild(this.regPointMC);
                this.regPointMC = null;
            }
        }
		
		/**
		 * 帧函数
		 * @param frame
		 * @param func
		 */
        public function addFrameAction(frame:int, callback:Function = null) : void
        {
            if (this._framesAction[frame])
                this.removeFrameAction(frame);
			
            if (callback != null)
            {
				var handler:Function = function (event:Event) : void
	            {
	                callback();
	            };
                addEventListener("mc_" + frame, handler, false, 0, true);
                this._framesAction[frame] = handler;
            }
        }

        public function removeFrameAction(frame:int) : void
        {
            if (this._framesAction[frame])
            {
                removeEventListener("mc_" + frame, this._framesAction[frame]);
                this._framesAction[frame] = undefined;
            }
        }
        
        public function removeAllFrameAction() : void
        {
            for (var frame:String in this._framesAction)
            {
                this.removeFrameAction(frame as int);
            }
        }

        public function setSize(width:int, height:int) : void
        {
            this._mc.width = width;
            this._mc.height = height;
        }

		protected function analyze0(bmd:BitmapData, format:MovieDataFormat) : void
        {
            this._changedRegPoint = format.regPoint;
			//this.regPoint = format.regPoint;
			
            this.isFilpH = format.isFilpH;
            this.isFilpV = format.isFilpV;
			
            if (format.frames != null)
            {
                this._width = format.smallWidth;
                this._height = format.smallHeight;
                this._frames = format.frames;
                this._totalFrames = this._frames.length;
                this._currentFrame = 0;
                return;
            }
			
            if (format.frameCount > 0)
			{
                this.analyze(bmd, 
					format.frameCount, 
					format.bigWidth, format.bigHeight, 
					format.offset.x, format.offset.y);
			}
            else
			{
                this.analyze(bmd, 
					format.smallWidth, format.smallHeight, 
					format.bigWidth, format.bigHeight, 
					format.offset.x, format.offset.y);
			}
        }

		protected function analyze1(bmd:BitmapData, param2:int, param3:int, param4:int, param5:Number = 0, param6:Number = 0) : void
        {
            this.analyze(bmd, (param3 / param2), param4, param3, param4, param5, param6);
        }

        protected function analyze(bmd:BitmapData, 
								perWidth:Number, perHeight:Number, totalWidth:int, totalHeight:int, 
								offsetX:Number = 0, offsetY:Number = 0) : void
        {
            this._width = perWidth;
            this._height = perHeight;
			
            var column:int = Math.floor(totalWidth / perWidth);
            var row:int = Math.floor(totalHeight / perHeight);			
			
            if (_bitmapList == null)
                _bitmapList = new Dictionary(true);
            if (!_bitmapList[bmd])
                _bitmapList[bmd] = {};
			
            var key:String = [offsetX, offsetY].join(",");
            if (_bitmapList[bmd][key])
            {
                this._frames = _bitmapList[bmd][key];
				trace("use preserved bmdframes");
            }
            else
            {
                this._frames = Vector.<BitmapData>([]);
				DebugTools.traceBMDSize(bmd.width,bmd.height);
				DebugTools.traceMemory("解析前");
				var r:int = 0;
                while (r < row)
                {
					var c:int = 0;
                    while (c < column)
					{
						var subBmd:BitmapData = new BitmapData(perWidth, perHeight, true, 0);
//						trace("bmd width:"+perWidth+" height:"+perHeight);
						DebugTools.traceBMDSize(perWidth,perHeight);
						var rect:Rectangle = new Rectangle(c * perWidth + offsetX, r * perHeight + offsetY, perWidth, perHeight);
						subBmd.copyPixels(bmd, rect, new Point());
//						DebugTools.traceMemory("解析中");
                        this._frames.push(subBmd);
						subBmd = null;
                        c++;
                    }
                    r++;
                }
                _bitmapList[bmd][key] = this._frames;
				DebugTools.traceMemory("解析后");
            }
			
            this._totalFrames = column * row;
            this._currentFrame = 0;
        }

		/**
		 * 播放
		 */
        public function play() : void
        {
            this.replay();
        }

		/**
		 * 停止
		 */
        public function stop() : void
        {
            if (this._timer)
                this._timer.stop();
			
            this._stoped = true;
        }
		
        public function gotoAndPlay(frame:int) : void
        {
            this._currentFrame = frame - 1;
            this.play();
        }

        public function gotoAndStop(frame:int) : void
        {
            this._currentFrame = frame - 1;
//			if(_frames.length<1) return;
            this._mc.bitmapData = this._frames[this._currentFrame];
			this.regPoint = this._changedRegPoint;
            this.stop();
        }

		private function replay() : void
		{
			if (this._timer)
			{
				this._timer.stop();
			}
			else
			{
				this._timer = new Timer(1);
				this._timer.addEventListener(TimerEvent.TIMER, this.onEnterFrameHandler, false, 0, true);
			}
			this._stoped = false;
			this._timer.delay = this._frameInterval || 1000 / this._frameRate;
			//this._timer.delay = 1000;
			this._timer.start();
		}

        private function onEnterFrameHandler(event:TimerEvent) : void
        {
//			if(this._frames.length<1) return;
            this._mc.bitmapData = this._frames[this._currentFrame++];
			
            if (this._regPoint.x != this._changedRegPoint.x || 
				this._regPoint.y != this._changedRegPoint.y)
			{
				this.regPoint = this._changedRegPoint;
			}
			
            if (this._defaultAction is Function)
                this._defaultAction();
            if (this._defaultFrameAction is Function)
                this._defaultFrameAction(this._currentFrame);
            if (this._framesAction[this._currentFrame])
                this.dispatch(this._currentFrame);
			
            if (this._currentFrame >= this._totalFrames)
            {
                this._currentFrame = 0;
                if (this._endFrameAction is Function)
                    this._endFrameAction();
                if (this._loop == false)
                    this.stop();
            }
        }
		
		private function dispatch(frame:int) : void
		{
			dispatchEvent(new Event("mc_" + frame));
		}

		// the methods below are bean's properties.
		
        public function get mc() : Bitmap
        {
            return this._mc;
        }

        public function set frameRate(value:Number) : void
        {
            this._frameRate = value;
            this.replay();
        }

        public function get frameRate() : Number
        {
            return this._frameRate;
        }

        public function get totalFrames() : int
        {
            return this._totalFrames;
        }

        public function get currentFrame() : int
        {
            return (this._currentFrame + 1);
        }

        public function get stoped() : Boolean
        {
            return this._stoped;
        }

        public function set loop(value:Boolean) : void
        {
            this._loop = value;
        }

        public function set defaultFrameAction(value:Function) : void
        {
            this._defaultFrameAction = value;
        }

        public function get defaultFrameAction() : Function
        {
            return this._defaultFrameAction;
        }

        public function set endFrameAction(value:Function) : void
        {
            this._endFrameAction = value;
        }

		/**
		 * 水平翻转
		 * @param value
		 */
        public function set isFilpH(value:Boolean) : void
        {
            var lor:int = 0;
            if (this._mc.scaleX < 0)
                lor = value ? (1) : (-1);
            else
                lor = value ? (-1) : (1);
            this._mc.scaleX = this._mc.scaleX * lor;
        }

		/**
		 * 垂直翻转
		 */
        public function set isFilpV(value:Boolean) : void
        {
            var data:int = 0;
            if (this._mc.scaleY < 0)
                data = value ? (1) : (-1);
            else
                data = value ? (-1) : (1);
            this._mc.scaleY = this._mc.scaleY * data;
        }

        public function set regPoint(value:Point) : void
        {
            _regPoint = value;
			_changedRegPoint = value;
			
            _mc.x = value.x;
            _mc.y = value.y;
        }

        /*public static function set bitmapList(value:Dictionary) : void
        {
            _bitmapList = value;
        }*/
    }
}
