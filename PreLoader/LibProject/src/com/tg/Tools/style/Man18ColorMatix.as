package com.tg.Tools.style
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class Man18ColorMatix
	{
		public function Man18ColorMatix()
		{
		}
		/**
		 * 设置调色滤镜 
		 * @param dis 
		 * @param hue 0~360
		 * @param saturation -300~300
		 * @param contrast -200~500
		 * @param brightness -100~100
		 * 
		 */
		public static function setColorFilter(dis:DisplayObject,hue:Number,saturation:Number,contrast:Number,brightness:Number):void
		{
			var mat:ColorMatrix = new ColorMatrix();
			
			mat.adjustHue(hue);
			
			mat.adjustSaturation(saturation/100);
			
			trace("setColorFilter hue:"+hue);
			
			mat.adjustContrast(contrast/100);
			
			mat.adjustBrightness(255*brightness/100);
			
			var cm:ColorMatrixFilter = new ColorMatrixFilter(mat.matrix);
			dis.filters=[cm];
		}
		public static function getColorMatrix(hue:Number,saturation:Number,contrast:Number,brightness:Number):Array
		{
			var mat:ColorMatrix = new ColorMatrix();
			
			mat.adjustHue(hue);
			
			mat.adjustSaturation(saturation/100);
			
			trace("setColorFilter hue:"+hue);
			
			mat.adjustContrast(contrast/100);
			
			mat.adjustBrightness(255*brightness/100);
			return mat.matrix;
		}
		public static function tweenColorFilter(dis:DisplayObject,time:Number,param:Object):void
		{
			TweenMax.to(dis,time,{colorMatrixFilter:param});
		}
	}
}