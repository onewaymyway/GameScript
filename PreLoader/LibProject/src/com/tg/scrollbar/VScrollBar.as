package com.tg.scrollbar
{
	import flash.display.Sprite;
	
	public class VScrollBar extends Sprite
	{
		private var _scroll:VScroll;
		
		public function VScrollBar()
		{
			super();
		}
		
		public function get scroll():VScroll
		{
			return _scroll;
		}
		public function set scroll(value:VScroll):void
		{
			_scroll = value;
		}
	}
}