package com.tg.Tools.pageTools
{
	import com.tg.Tools.ButtonAct;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class PageNavigationModel
	{
		public function PageNavigationModel()
		{
		}
		public var startPage:int=0;
		public var endPage:int=0;
		
		private var nextBtn:DisplayObject;
		private var preBtn:DisplayObject;
		public function set NextBtn(btn:DisplayObject):void
		{
			btn.addEventListener(MouseEvent.CLICK,nextH,false,0,true);
			nextBtn=btn;
		}
		private function nextH(evt:MouseEvent):void
		{
			goPage(this.tPage+1);
		}
		
		public function set PreBtn(btn:DisplayObject):void
		{
			btn.addEventListener(MouseEvent.CLICK,preH,false,0,true);
			preBtn=btn;
		}
		
		private function preH(evt:MouseEvent):void
		{
			goPage(this.tPage-1);
		}
		public var tPage:int;
		public var pageHandler:Function;
		public function goPage(page:int):void
		{
			page= page<startPage? startPage:page;
			page= page >endPage?  endPage:page;
			mPage=page;
			if(pageHandler!=null)
			{
				pageHandler(page);
			}
		}
		
		private function set mPage(page:int):void
		{
			tPage=page;
			nextBtn.visible=true;
			preBtn.visible=true;
//			if(tPage==startPage) preBtn.visible=false;
//			if(tPage==endPage) nextBtn.visible=false;
			ButtonAct.setButtonEnable(preBtn,tPage>startPage);
			ButtonAct.setButtonEnable(nextBtn,tPage<endPage);
		}
		
		public function setState(state:int):void
		{
			preBtn.visible=true;
			nextBtn.visible=true;
			ButtonAct.setButtonEnable(preBtn,Boolean(state&1));
			ButtonAct.setButtonEnable(nextBtn,Boolean(state&2));
		}
	}
}