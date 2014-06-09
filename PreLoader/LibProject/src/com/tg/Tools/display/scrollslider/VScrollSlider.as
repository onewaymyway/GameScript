package com.tg.Tools.display.scrollslider
{

	
	import com.tg.Tools.display.interfaces.IScrollSlider;
	import com.tg.Tools.display.slider.VSlider;
	
	import flash.display.MovieClip;

	/**
	 * 滑块大小可缩放的Slider，提供给ScrollBar使用
	 * @author luli &ww
	 */
	public class VScrollSlider extends VSlider implements IScrollSlider
	{
		//==========================================================================
		//  Constructor
		//==========================================================================
		public function VScrollSlider(sourceUI:MovieClip)
		{
			
			super(sourceUI);
			setParameter(0, 1, 0);
//			if(type == Slider.THIN_SKIN)
//			{
//				_thumbNeedResize = false;
//			}
		}
		
		//==========================================================================
		//  Properties
		//==========================================================================
		private var _thumbNeedResize:Boolean = true;
		/**
		 * 获取滑块是否允许缩放，比如THIN_SKIN类型的就不需要缩放
		 */
		public function get thumbNeedResize():Boolean
		{
			return _thumbNeedResize;
		}
		//----------------------------------
		//  thumbScale
		//----------------------------------
		private var _thumbScale:Number;
		/**
		 * 获取滑块高度缩放比例
		 */
		public function get thumbScale():Number
		{
			return _thumbScale;
		}
		/**
		 * 设置滑块高度缩放比例
		 * @param value 滑块高度缩放比例，区间[0,1]
		 */
		public function set thumbScale(value:Number):void
		{
			value = Math.max(0, Math.min(value, 1));
			_thumbScale = value;
			if(_thumbNeedResize)
			{
				resizeThumb();
			}
		}
		//----------------------------------
		//  thumbMinHeight
		//----------------------------------
		private var _thumbMinHeight:uint = 20;
		/**
		 * 获取滑块缩放最小高度
		 */
		public function get thumbMinHeight():uint
		{
			return _thumbMinHeight;
		}
		/**
		 * 设置滑块缩放最小高度
		 */
		public function set thumbMinHeight(value:uint):void
		{
			_thumbMinHeight = value;
		}
		//==========================================================================
		//  Private methods
		//==========================================================================
		/**
		 * 设置滑块缩放
		 */
		protected function resizeThumb():void
		{
			if(height <= thumb.height)
			{
				thumb.visible = false;
				return;
			}
			if(thumbScale)
			{
				thumb.height = Math.round(Math.max(_thumbMinHeight, height * thumbScale));
			}
		}
		
	}
}
