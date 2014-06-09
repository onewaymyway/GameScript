package com.tg.component
{
	import flash.display.Sprite;
	
	public class CheckBox extends Sprite
	{
		private var _checked:Boolean;
		
		public function CheckBox()
		{
			super();
		}
		
		public function reset():void
		{
			trace("unrealized method com.tg.component.CheckBox :: reset");
		}
		
		public function get checked():Boolean
		{
			trace("unrealized method com.tg.component.CheckBox :: get checked");
			return false;
		}
	}
}