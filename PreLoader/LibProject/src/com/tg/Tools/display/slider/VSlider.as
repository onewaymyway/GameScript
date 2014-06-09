package com.tg.Tools.display.slider
{
	import flash.display.MovieClip;

	/**
	 * @author luli &ww
	 */
	public class VSlider extends Slider
	{
		//==========================================================================
		//  Constructor
		//==========================================================================
		public function VSlider(sourceUI:MovieClip)
		{
			super(sourceUI);
		}
		//==========================================================================
		//  Overridden methods
		// ==========================================================================
		override protected function initSetting():void
		{
			defaultWidth = backBar.width;
			defaultHeight = 100;
		}

	}
}
