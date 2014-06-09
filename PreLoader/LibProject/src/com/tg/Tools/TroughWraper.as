package com.tg.Tools
{
	import com.tg.Tools.changeEffect.NumChangeEffectTool;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * 经验条控制类
	 * @author ww
	 * 
	 */
	public class TroughWraper
	{
		public function TroughWraper()
		{
		}
		/**
		 * 遮罩
		 */
		public var mask:DisplayObject;
		/**
		 * 经验条
		 */
		public var trough:DisplayObject;
		
		/**
		 * 是否是特殊类型
		 */
		private var isSpecial:Boolean;
		/**
		 * 设置经验条控制 
		 * @param content
		 * @param special 
		 *   false：
		 * 
		 */
		public function setContent(content:MovieClip,special:Boolean=false):void
		{
			isSpecial=special;
			if(special)
			{
				mask=content.mask1;
				trough=content.trough;
				if(mask)
				mask.visible=false;
			}else
			{
				mask=content.mask;
				trough=content.trough;
				if(trough)
				{
					trough.mask=mask;
				}
			}

//			setPercent(59);
		}
		
		private var tPercent:int=100;
		public var changeEffect:Boolean=true;
		public function setPercent(percent:int):void
		{
			if(percent>100) percent=100;
			if(percent<0) percent=0;
			if(percent!=tPercent)
			{
				if(changeEffect)
				NumChangeEffectTool.changeNotice(trough);
				
			}
			tPercent=percent;
			if(isSpecial)
			{
				trough.width=TroughTools.getWidth(percent*mask.width*0.01);
			}else
			{
				mask.width=TroughTools.getWidth(percent*trough.width*0.01);
			}
			
		}
		
		public static function wrapeTrough(content:MovieClip,special:Boolean=false):TroughWraper
		{
			var rst:TroughWraper;
			rst=new TroughWraper();
			rst.setContent(content,special);
			return rst;
		}
	}
}