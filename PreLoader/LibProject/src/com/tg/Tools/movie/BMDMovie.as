package com.tg.Tools.movie
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 位图动画播放类
	 * @author ww
	 * 
	 */
	public class BMDMovie extends Sprite
	{
		public function BMDMovie(autoDispose:Boolean=true)
		{
			super();
			bmd=new Bitmap(new BitmapData(1,1),"auto",true);
			this.addChild(bmd);
			tFrame=0;
			if (autoDispose)
				addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this._timer = new Timer(1);
			_timer.delay=1000/frameRate;
			_timer.addEventListener(TimerEvent.TIMER, this.onEnterFrameHandler, false, 0, true);
		}
		/**
		 * 当前帧内容 
		 */
		public var bmd:Bitmap;
		/**
		 * 数据 
		 */
		public var data:BMDMovieData;
		/**
		 * 当前帧 
		 */
		public var tFrame:int;
		/**
		 * 帧率 
		 */
		public var frameRate:int=24;
		/**
		 * 播放周期 单位ms
		 */
		public var tTime:Number=-1;
		
		/**回调*/
		public var backFun:Function = new Function();
		
		/**
		 * 独立计时器 
		 */
		private var _timer:Timer;
		public function setFrameRate(rate:int=24):void
		{
			frameRate=rate;
			if(_timer)
			_timer.delay=1000/frameRate;
		}
		/**
		 * 设置播放周期 
		 * @param cTime
		 * 
		 */
		public function setCTime(cTime:Number):void
		{
			this.tTime=cTime;
			updateFrameRate();

		}
		/**
		 * 设置数据 
		 * @param tData
		 * 
		 */
		public function setData(tData:BMDMovieData):void
		{
			data=tData;
			updateFrameRate();
			pass();
			backFun();
		}
		/**
		 * 更播放速度
		 * 
		 */
		public function updateFrameRate():void
		{
			if(_timer&&data&&tTime>0)
			{
				_timer.delay=tTime/(data.frameCount);
			}
		}
		private function onEnterFrameHandler(event:TimerEvent) : void
		{
			pass();
		}
		public function play():void
		{
			if(_timer)
			_timer.start();
		}
		public function pass():void
		{
			if(!data) return;
			try
			{			
				tFrame++;
				tFrame=tFrame%data.frameCount;
				bmd.bitmapData=data.frames[tFrame];
				var tOffs:Array;
				tOffs=data.getFrameOffset(tFrame);
				bmd.x=tOffs[0];
				bmd.y=tOffs[1];
				
			}catch(e:*)
			{
				
			}

			
		}
		private function onRemoveFromStage(evt:Event):void
		{
			if(_timer)
			{
				_timer.stop();
			}
			dispose();
		}
		/**
		 * 清理资源 
		 * 
		 */
		public function dispose():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, this.onEnterFrameHandler);
				_timer.stop();
				_timer=null;
			}
			if(data)
			{
				data.dispose();
			}
			

			data=null;
		}
	}
}