package com.tg.tip
{
	import flash.geom.Point;

	public class MouseTip
	{
		public static const EXTEND_RIGHT:int = 1;
		public static const EXTEND_LEFT:int = 2;
		
		public var contentList:Array;
		public var position:Point;
		public var topBase:Boolean;
		
		/** 多提示面板显示，延展方向 */
		public var toward:int;
		
		// 侦听鼠标行为
		/** 鼠标滑入 */
		public var mouseOver:Function;
		/** 鼠标滑出 */
		public var mouseOut:Function;
		/** 鼠标滑动 */
		public var mouseMove:Function;
		
		public function MouseTip(contentList:Array, position:Point, topBase:Boolean)
		{
			this.contentList = contentList;
			this.position = position;
			this.topBase = topBase;
			
			toward = EXTEND_RIGHT;
		}
	}
}