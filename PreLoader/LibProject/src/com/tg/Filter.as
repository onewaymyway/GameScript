package com.tg
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class Filter
	{
		/** 颜色矩阵滤镜，不可用状态 */
		public static var filter1:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0.3, 0.3, 0.3, 0, 0, 0, 0, 0, 1, 1]);
		
		/** 发光滤镜，文本发光*/
		public static var filter2:GlowFilter = new GlowFilter(0, 1, 2, 2, 4, 1);
		
		/** 投影滤镜，*/
		public static var filter3:DropShadowFilter = new DropShadowFilter(4);
		
		/** 颜色矩阵滤镜， */
		public static var filter6:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 45, 0, 1, 0, 0, 45, 0, 0, 1, 0, 45, 0, 0, 0, 1, 0]);
		
		/** 投影滤镜，*/
		public static var dropFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0, 1, 2, 2, 10);
		
		/** 发光滤镜，*/
		public static var stroke:GlowFilter = new GlowFilter(0, 0.7, 2, 2, 17, 1, false, false);
	}
}
