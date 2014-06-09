package com.tg.Tools
{
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.setTimeout;

	public class MouseTools
	{
		public function MouseTools()
		{
		}
		
		public static function ToArrow():void
		{
			Mouse.cursor=MouseCursor.ARROW;
		}
	
		public static function ToHand():void
		{
			Mouse.cursor=MouseCursor.HAND;
		}
		
		public static function ToAuto():void
		{
			Mouse.cursor=MouseCursor.AUTO;
		}
		
		public static function backToAuto(delay:int=5000):void
		{
			setTimeout(ToAuto,delay);
		}
		
		
	}
}