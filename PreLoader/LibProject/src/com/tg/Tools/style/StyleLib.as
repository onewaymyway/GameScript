package com.tg.Tools.style
{
	
	import com.tg.html.HtmlText;
	
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;

	public class StyleLib
	{
		public function StyleLib()
		{
		}
		
		public static const matrix:Array=[
			0.3086, 0.6094, 0.0820, 0, 0, 
			0.3086, 0.6094, 0.0820, 0, 0, 
			0.3086, 0.6094, 0.0820, 0, 0, 
			0,      0,      0,      1, 0]; 
		
		/**
		 * 灰色滤镜，让滤镜对象变灰 
		 */
		public static const grayFilter:ColorMatrixFilter=new ColorMatrixFilter(matrix); 
		
		/**
		 * 高亮显示滤镜 
		 */
		public static const focusFilter:GlowFilter = new GlowFilter(0xffdf47,1,16,16,2,BitmapFilterQuality.MEDIUM);
		
		public static const black1TipFilter:GlowFilter=new GlowFilter(0x000000,1,2,2,64,BitmapFilterQuality.LOW);
		
		public static const MagicAlertTxtFormat:TextFormat=new TextFormat("宋体",20,0x00FFFF,true);
		
		/**通用字体黑色滤镜*/
		public static const COMMON_FILTER:Array = [new GlowFilter(0, 1, 2, 2, 10, 1)];
		
		public static function getGlowFilter(color:uint, blur:Number=16, strength:Number=64, quality:int=BitmapFilterQuality.MEDIUM, inner:Boolean=false, knockout:Boolean=true):GlowFilter
		{
			return new GlowFilter(color,1,blur,blur,strength,quality,inner,knockout);
		}

		
		public static const unClickTxtColor:uint=0x27408B;
		public static const clickedTxtColor:uint=0x8B2323;
		
		public static const nameColor:uint=0x009944;
		
		public static const nameHateColor:uint=0xFF0000;
		
		public static function getNameTxt(name:String):String
		{
			return HtmlText.format(name,nameColor);
		}
		
		public static function getHateNameTxt(name:String):String
		{
			return HtmlText.format(name,nameHateColor);
		}
	}
}