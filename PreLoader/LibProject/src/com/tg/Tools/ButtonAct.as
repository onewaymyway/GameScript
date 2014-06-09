package com.tg.Tools
{
	import com.tg.Tools.style.StyleLib;
	import com.tools.ObjectTools;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * movieClip to Btn 
	 * 给movieclip添加Btn表现
	 * @author ww
	 * 
	 * 用法:
	 * 
	 * some:MovieClip;
	 * 
	 * new ButtonAct(some);
	 * 
	 */
	public class ButtonAct
	{
		private var tBtn:MovieClip;
		
		private var mouseOverFrame:int;
		private var mouseDownFrame:int;
		
		public static const grayFilterList:Array=[StyleLib.grayFilter];
		public function ButtonAct(btn:MovieClip)
		{
			this.tBtn=btn;
			tBtn.gotoAndStop(1);
			
			if(btn.totalFrames==2)
			{
				mouseDownFrame=1;
				mouseOverFrame=2;
			}else
			{
				mouseOverFrame=2;
				mouseDownFrame=3;
				
			}
			tBtn.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			tBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			tBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			tBtn.addEventListener(MouseEvent.MOUSE_OUT,mouseUp);
			btn.buttonMode=true;
		}
		
		private function mouseDown(evt:MouseEvent):void
		{
			tBtn.gotoAndStop(mouseDownFrame);
			
		}
		private function mouseUp(evt:MouseEvent):void
		{
			tBtn.gotoAndStop(1);
//			tBtn.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
//			tBtn.removeEventListener(MouseEvent.MOUSE_OUT,mouseUp);
		}
		
		private function mouseOver(evt:MouseEvent):void
		{
			tBtn.gotoAndStop(mouseOverFrame);
		}
		
		public static function setButtonAct(btn:MovieClip):void
		{
			btn.buttonMode=true;
		}
		
		public static function setButtonEnable(btn:*,enable:Boolean,mouseControl:Boolean=true):void
		{
			if(enable)
			{
				btn.filters=null;
			}else
			{
				btn.filters=grayFilterList;
			}
			if(!mouseControl) return;
			btn.mouseEnabled=enable;
			if(btn is DisplayObjectContainer)
			{
				(btn as DisplayObjectContainer).mouseChildren=false;
			}
		}
		public static function setButtonEnableSimple(btn:*,enable:Boolean):void
		{
			setButtonEnable(btn,enable,false);
		}
		public static function isButtonActive(btn:*):Boolean
		{
			if(btn.filters)
			{
//				if(btn.filters==grayFilterList)
				if(ObjectTools.ObjectEqual(btn.filters,grayFilterList))
				{
					return false;
				}
				else
				{
					return true;
				}
			}else
			{
			  return true;	
			}
		}
	}
}