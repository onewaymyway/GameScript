package com.game.display
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class TriggerButton extends MovieClip
	{
		private var _selected:Boolean = false;
		
		private var isMouseDown:Boolean = false;
		
		private var isMouseOver:Boolean = false;
		
		public function TriggerButton()
		{
			super();
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			isMouseDown = false;
			reSetButtonState();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			isMouseDown = e.buttonDown;
			reSetButtonState();
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			isMouseOver = true;
			reSetButtonState();
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			isMouseOver = false;
			reSetButtonState();
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			if (_selected)
				e.stopImmediatePropagation();
		}
		
		private function reSetButtonState():void
		{
			if (_selected)
			{
				if (isMouseDown && isMouseOver)
				{
					gotoAndStop("selcover");
				}
				else if (isMouseDown && !isMouseOver)
				{
					gotoAndStop("selcdown");
				}
				else if (!isMouseDown && isMouseOver)
				{
					gotoAndStop("selcover");
				}
				else if (!isMouseDown && !isMouseOver)
				{
					gotoAndStop("selcup");
				}
			}
			else
			{
				if (isMouseDown && isMouseOver)
				{
					gotoAndStop("over");
				}
				else if (isMouseDown && !isMouseOver)
				{
					gotoAndStop("down");
				}
				else if (!isMouseDown && isMouseOver)
				{
					gotoAndStop("over");
				}
				else if (!isMouseDown && !isMouseOver)
				{
					gotoAndStop("up");
				}
			}
			
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if (_selected)
			{
				gotoAndStop("selcup");
			}
			else
			{
				gotoAndStop("up");
			}
		}

	}
}