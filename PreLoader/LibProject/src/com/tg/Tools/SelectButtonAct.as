package com.tg.Tools
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 选择按钮控制类
	 * @author ww
	 * 
	 * new SelectButtonAct(makeTabBtn);
	 * 
	 */
	public class SelectButtonAct
	{

		private var tBtn:MovieClip;
		/**
		 * 添加选择按钮控制 
		 * @param btn 3帧mc
		 *            第一帧普通
		 *            第二帧focus
		 *            第三帧select
		 * 
		 */
		public function SelectButtonAct(btn:MovieClip)
		{
			this.tBtn=btn;
			tBtn.gotoAndStop(1);
			tBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown/*,false,0,true*/);
			tBtn.addEventListener(MouseEvent.MOUSE_UP,mouseOut/*,false,0,true*/);
			tBtn.addEventListener(MouseEvent.MOUSE_OUT,mouseOut/*,false,0,true*/);
			tBtn.addEventListener(MouseEvent.MOUSE_OVER,mouseOver/*,false,0,true*/);
			btn.buttonMode=true;
		}
		
		private function mouseDown(evt:MouseEvent):void
		{
			tBtn.gotoAndStop(3);

		}
	
		private function mouseOver(evt:MouseEvent):void
		{
			if(tBtn.currentFrame==1)
			{
				tBtn.gotoAndStop(2);
			}
		}
		private function mouseOut(evt:MouseEvent):void
		{
			if(tBtn.currentFrame==2)
			{
				tBtn.gotoAndStop(1);
			}
		}
	}
}