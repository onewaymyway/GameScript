package com.tg.Tools
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 两帧单选框控制类
	 * @author ww
	 * 
	 */
	public class SimpleSelectBtnAct
	{
		public function SimpleSelectBtnAct(mc:MovieClip)
		{
			_mc=mc;
			_mc.addEventListener(MouseEvent.CLICK,clicked,false,0,true);
			ButtonAct.setButtonAct(_mc);
			_id=1;
			update();
		}
		private var _mc:MovieClip;

		private var _id:int;
		
		private function clicked(evt:MouseEvent):void
		{
			_id=1-_id;
			update();
		}
		public var changeFun:Function;
		private function update():void
		{
			_mc.gotoAndStop(2-_id);
			
			
			if(changeFun!=null)
			{
				changeFun();
			}
		}
		
		public function get isSelect():Boolean
		{
			return (_id!=1);
		}
		
		public function set isSelect(select:Boolean):void
		{
			_id=select? 0:1;
			update();
		}
	}
}