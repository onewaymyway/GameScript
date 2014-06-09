package com.tg.Tools
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 经验条控制类
	 * @author ww
	 * 
	 */
	public class TroughTools
	{
		public function TroughTools()
		{
		}
		
		/**
		 * 经验条最小显示宽度 
		 */
		public static const MinWidth:int=3;
		/**
		 * 获取合适的经验条宽度 
		 * @param tWidth
		 * @return 
		 * 
		 */
		public static function getWidth(tWidth:Number):Number
		{
			if(tWidth<0) tWidth=0;
			if((tWidth>0)&&(tWidth<MinWidth))
			{
				tWidth=MinWidth;
			}
			
			return tWidth;
		}
		
		/**
		 * 给经验条设置文本效果
		 * @param txt 显示百分比的文本框
		 * @param back 包含经验条的容器
		 * 
		 */
		public static function setThroughAct(txt:TextField,back:DisplayObject):void
		{
			var tWp:TroughTools;
			tWp=new TroughTools();
			tWp.setThrough(txt,back);
		}	

		
		private var txt:TextField;
		
		public function setThrough(txt:TextField,back:DisplayObject):void
		{
			this.txt=txt;
			txt.visible=false;
			txt.mouseEnabled=false;
			back.addEventListener(MouseEvent.MOUSE_OUT,mouseOut,false,0,true);
			back.addEventListener(MouseEvent.MOUSE_OVER,mouseOn,false,0,true);
		}

		
		private function mouseOn(evt:MouseEvent=null):void
		{
				txt.visible=true;	
		}
		
		private function mouseOut(evt:MouseEvent=null):void
		{

				txt.visible=false;
			
		}
	}
}