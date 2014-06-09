package com.tg.avatar.war.load
{
	import flash.display.BitmapData;

	public final class AnimationData
	{
		public var direction:String;
		public var frameCount:int;
		public var frames:Vector.<BitmapData>;
		public var offsetX:int;
		public var offsetY:int;
		public var frameRate:int;
		public var targetFrame:int;
		
		public function AnimationData()
		{
		}
		
		public function dispose():void
		{
			if (!frames || frames.length == 0)
				return;
			for (var i:int = frames.length - 1; i >= 0 ; i--) 
			{
				frames[i].dispose();
				frames.splice(i,1);
			}
		}
	}
}