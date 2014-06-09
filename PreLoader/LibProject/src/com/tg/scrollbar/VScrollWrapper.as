package com.tg.scrollbar
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;

	public class VScrollWrapper
	{
		public function VScrollWrapper()
		{
			
		}
		
		
		/**
		 * 包装滚动控制组件
		 * 
		 * @param maskRect		滚动区域，相对于容器的起始位置(0, 0)
		 * @param speed			滚动速度
		 * @param upButton		滚动条向上按钮
		 * @param downButton	滚动条向下按钮
		 * @param scrollSlider	滚动条滑块
		 * @param sliderIcon	滚动条滑块上的图标
		 * 
		 * @return 				滚动条控制对象
		 */
		public static function wrap(maskRect:Rectangle, speed:int=5, 
									upComp:InteractiveObject = null, downComp:InteractiveObject = null, 
									slideComp:InteractiveObject=null, slideAxis:DisplayObject=null, slideIcon:DisplayObject=null):VScroll
		{
			var scroll:VScroll = new VScroll(maskRect, upComp, downComp, slideComp, slideAxis, slideIcon);
			scroll.speed = speed;
			return scroll;
		}
		
		
		/**
		 * 创建默认的滚动条，使用系统默认皮肤
		 * @param axisHeight
		 * @return 
		 * 
		 */
		public static function createDefault(axisHeight:int):VScrollBar
		{
			return null;
		}
		
		
		
		/**
		 * 注册纵向滚动条默认外观，用于构建默认纵向滚动条组件
		 * @param xx
		 */
		public static function initialize(xx:*):void
		{
			
		}
	}
}