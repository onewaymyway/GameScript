package com.game.display
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	
	public class TriggerSimpleButton extends SimpleButton
	{
		private var _selected:Boolean = false;
		private var _label:String= "";
		private var _upState:TriggerSimpleButtonState;
		private var _overState:TriggerSimpleButtonState;
		private var _downState:TriggerSimpleButtonState;
		
		public function TriggerSimpleButton()
		{
			super();
			addEventListener(MouseEvent.CLICK,onMouseClick);
			_upState = upState as TriggerSimpleButtonState;
			_overState = overState as TriggerSimpleButtonState;
			_downState = downState as TriggerSimpleButtonState;
		}
		
		
		protected function onMouseClick(e:MouseEvent):void
		{
			if (_selected)
				e.stopImmediatePropagation();
			else
				upState = _overState;
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
				upState = _overState;
				enabled = false;
			}
			else
			{
				upState = _upState;
				enabled = true;
			}
		}
		
		public function set label(value:String):void
		{
			_label = value;
			(_upState["__labelTxt"] as TextField).text = _label;
			(_overState["__labelTxt"] as TextField).text = _label;
			(_downState["__labelTxt"] as TextField).text = _label;
		}
		
		public function get label():String
		{
			return _label;
		}

	}
}