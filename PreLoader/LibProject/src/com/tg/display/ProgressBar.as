package com.tg.display
{
	import com.tg.Tools.changeEffect.NumChangeEffectTool;
	
	import flash.display.Sprite;
	
	public class ProgressBar extends Sprite
	{
		private var tgBar:Sprite;
		private var tgTourgh:Sprite;
		
		private var _tvalue:int = 0;
		
		private var _minValue:int = 0;
		
		private var _maxValue:int = 100;
		
		private var fullW:int;
		
		public function ProgressBar()
		{
			super();
			tgBar = getChildByName("bar") as Sprite;
			tgTourgh = getChildByName("trough") as Sprite;
			fullW = tgBar.width;
		}
		
		
		public function get value():int
		{
			return _tvalue;
		}

		public function set value(pvalue:int):void
		{
			if(pvalue > _maxValue) _tvalue = _maxValue;
			if(pvalue < _minValue) _tvalue = _minValue;
			if(pvalue > 0 && _tvalue == pvalue)
			{
				return;
			}
			if (_minValue > _maxValue)
				return;
			NumChangeEffectTool.changeNotice(tgBar);
			_tvalue = pvalue;
			tgBar.width = fullW * _tvalue / (_maxValue - _minValue);
		}

		public function get minValue():int
		{
			return _minValue;
		}

		public function set minValue(value:int):void
		{
			_minValue = value;
		}

		public function get maxValue():int
		{
			return _maxValue;
		}

		public function set maxValue(value:int):void
		{
			_maxValue = value;
		}


	}
}