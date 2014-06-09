package com.tg.display
{

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class TitleBar extends Sprite
	{
		private var titleBmp:Bitmap;
		private var titleBgBmp:Bitmap;
		private var leftFigureBmp:Bitmap;
		private var rightFigureBmp:Bitmap;
		private var titleBarBg:Bitmap;
		
		private var maxW:int;
		
		public function TitleBar()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			titleBmp = getChildAt(4) as Bitmap;
			titleBgBmp = getChildAt(3) as Bitmap;
			leftFigureBmp = getChildAt(2) as Bitmap;
			rightFigureBmp = getChildAt(1) as Bitmap;
			titleBarBg = getChildAt(0) as Bitmap;
			onResize();
		}
		
		private function setToCenter(tar:DisplayObject):void
		{
			tar.x = (maxW - tar.width) >> 1;
		}

		private function setToLeft(tar:DisplayObject):void
		{
			tar.x = 0;
		}

		private function setToRight(tar:DisplayObject):void
		{
			tar.x = maxW - tar.width;
		}

		private function onResize(e:Event=null):void
		{
			if (stage.stageWidth < 500)
				maxW = 500;
			else if (stage.stageWidth > 1500)
				maxW = 1500;
			else
				maxW = stage.stageWidth;
			
			setToCenter(titleBarBg);
			setToCenter(titleBgBmp);
			setToCenter(titleBmp);
			setToLeft(leftFigureBmp);
			setToRight(rightFigureBmp);
		}
		
		private function onAdded(e:Event):void
		{
			this.stage.addEventListener(Event.RESIZE,onResize);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			init();
		}
		
		private function onRemove(e:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE,onResize);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
	}

}