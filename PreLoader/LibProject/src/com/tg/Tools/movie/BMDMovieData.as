package com.tg.Tools.movie
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 位图动画数据类 
	 * @author ww
	 * 
	 */
	public class BMDMovieData
	{
		public function BMDMovieData()
		{
			mainOffSet=new Point();
			
		}
		/**
		 * 帧序列 
		 */
		public var frames:Vector.<BitmapData>;
		/**
		 * 帧偏移 
		 */
		public var offSets:Vector.<Point>;
		/**
		 * 主偏移 
		 */
		public var mainOffSet:Point;
		/**
		 * 帧数 
		 */
		public var frameCount:int;
		/**
		 * 是否可以清除数据
		 */
		public var candispose:Boolean=false;
		public function getFrameOffset(frame:int):Array
		{
			var rst:Array;
			if(frame<0) return[0,0];
			if(frame>=offSets.length) return[0,0];
			return [offSets[frame].x+mainOffSet.x,offSets[frame].y+mainOffSet.y];
			
		}
		
		public function dispose():void
		{
			if(!candispose) return;
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