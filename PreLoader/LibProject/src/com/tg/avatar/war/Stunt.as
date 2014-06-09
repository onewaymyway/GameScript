package com.tg.avatar.war
{
	import com.tg.avatar.war.Movie;
	import com.tg.avatar.war.data.RoleDataFormat;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

    public class Stunt extends Movie
    {
		//type, minWidth, minHeight, maxWidth, maxHeight, clipOffset, regPoint, 
		public static const BengJing:Array = [382, 277, 4584, 277, new Point(0, 0), new Point(200, -144), new Point(-200, -144)];

		private var _speed:int = 1;
		
		protected var _defaultFrameRate:Number = 0;
		protected var _bmd:BitmapData;
		
		protected var _defaultFace:String = "right";
		protected var _face:String = "right";
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
        public function Stunt(bmd:BitmapData, frameRate:Number = 0) : void
        {
            super(14);
			
			this._bmd = bmd;
			this._defaultFrameRate = frameRate;
			
            _face = Stunt.RIGHT;
			
			setDataFormat(Stunt.STUNT, 
				BengJing[0], BengJing[1], BengJing[2], BengJing[3],
				BengJing[4], false ? BengJing[5] : BengJing[6],
				2);
			
			
			
            this.changeFace(false);
        }
		
		public function setDataFormat(actionSign:String, 
										 minWidth:Number, minHeight:Number, 
										 maxWidth:int, maxHeight:int, 
										 clipOffset:Point = null, regPoint:Point = null, 
										 action:int = 0, frameRate:Number = 12, 
										 interval:int = 0, frames:Array = null) : void
		{
			if (!this["_" + actionSign + "DF"])
			{
				this["_" + actionSign + "DF"] = new RoleDataFormat();
			}
			
			var format:RoleDataFormat = this["_" + actionSign + "DF"];
			format.smallWidth = minWidth;
			format.smallHeight = minHeight;
			format.bigWidth = maxWidth;
			format.bigHeight = maxHeight;
			format.offset = clipOffset || new Point(0, 0);
			format.regPoint = regPoint || new Point(0, 0);
			
			format.targetActionFrame = action;
			format.frameRate = frameRate * this._speed;
			
			format.frameInterval = interval;
//			format.frames = frames;
			
			this.defaultRegPoint=regPoint || new Point(0, 0);
		}
		private var defaultRegPoint:Point;
		public static const STUNT:String = "stunt";		// 绝技
		protected var _stuntDF:RoleDataFormat;
		
		public function stunt(triggerCallback:Function) : void
		{
			if (!this._stuntDF)
				return;
			this.motion(Stunt.STUNT, this._stuntDF, triggerCallback);
		}
		
		
		// 动作控制
		protected var _actionType:String = "stand";
		private var _stopFrame:int = 1;
		protected var _faceChanged:Boolean = false;
		
		protected function motion(action:String, format:RoleDataFormat, func:Function) : void
		{
			if (this._actionType == action)
			{
				play();
				return;
			}
			
			this._actionType = action;
			this.trigger(func, format.targetActionFrame);
			
			format.isFilpH = _faceChanged;
			
			_frameInterval = format.frameInterval;
			_frameRate = format.frameRate || _defaultFrameRate;
			
			analyze0(this._bmd, format);
			
			this.updateStopFrame();
			this.startPlay();
		}
		
		private var _targetActionFrame:int = 0;
		private var _currentActionFrame:int = 0;
		private function trigger(fun:Function, frame:int = 0) : void
		{
			frame = frame || this._targetActionFrame;
			removeFrameAction(this._currentActionFrame);
			
			if(fun != null && frame > 0)
			{
				addFrameAction(frame, fun);
			}
			
			this._currentActionFrame = frame;
		}
		
		public function changeFace(change:Boolean) : void
		{
			this._faceChanged = change;
			this._face = change ? (this._defaultFace == Stunt.LEFT ? (Stunt.RIGHT) : (Stunt.LEFT)) : (this._defaultFace);
			_stuntDF.regPoint.x=change? defaultRegPoint.x:-defaultRegPoint.x;
			isFilpH=change;
		}
		
		private function updateStopFrame() : void
		{
			if (this._stopFrame == 0)
				return;
			
			addFrameAction(this._stopFrame, function () : void
			{
				stop();
				if(_stopHandler != null)
					_stopHandler(_actionType);
			});
		}
		public function startPlay() : void
		{
			gotoAndPlay(2);
		}
		
		private var _stopHandler:Function;
		public function set stopHandler(value:Function) : void
		{
			this._stopHandler = value;
		}
		
		public function set stopFrame(value:int) : void
		{
			removeFrameAction(this._stopFrame);
			this._stopFrame = value;
			this.updateStopFrame();
		}
		
		public function get face() : String
		{
			return this._face;
		}
		public function set face(value:String) : void
		{
			this.changeFace(value != this._face);
		}
    }
}
