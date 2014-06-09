package com.tg.datapage
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class DataPage
	{
		public var prevEnable:DisplayObject;	// 上一页
		public var nextEnable:DisplayObject;	// 下一页
		
		public var pageToTotal:TextField;		// 当前页/总页
		
		public var prevDisable:DisplayObject;	// 上一页按钮禁用状态
		public var nextDisable:DisplayObject;	// 下一页按钮禁用状态
		
		private var _currentPage:int;
		/** 当前页码，1代表第一页，其实编码为1 */
		public function get currentPage():int
		{return _currentPage;}
		
		private var _totalPage:int;
		/** 总页码，最小编码为1 */
		public function get totalPage():int
		{return _totalPage;}
		
		private var _currentPageCount:int;
		/** 当前页码对应条目数 */
		public function get currentPageCount():int
		{return _currentPageCount;}
		
		/** 用户操作换页时的，回调函数 */
		public var pageChangeHandler:Function;
		
		
		private var _totalCount:int;
		private var _countPerPage:int;
		
		public function DataPage(totalCount:int, countPerPage:int, 
								 previousButton:*, nextButton:*, 
								 pageNumberText:TextField = null, 
								 previousDisable:* = null, nextDisable:* = null)
		{
			prevEnable = previousButton as DisplayObject;
			nextEnable = nextButton as DisplayObject;
			pageToTotal = pageNumberText;
			prevDisable = previousDisable;
			nextDisable = nextDisable;
			
			if(prevEnable != null)
			{
				prevEnable.addEventListener(MouseEvent.CLICK, prevBtnClick);
			}
			if(nextEnable != null)
			{
				nextEnable.addEventListener(MouseEvent.CLICK, nextBtnClick);
			}
			
			_totalCount = totalCount;
			_countPerPage = countPerPage;
			
			// 页号
			_currentPage = 1;
			
			if(totalCount == 0)
				_totalPage = 1;
			else
				_totalPage = Math.ceil(totalCount / countPerPage);
			
			updateComp();
		}
		
		public function destroy():void
		{
			if(pageChangeHandler != null)
			{
				pageChangeHandler = null;
			}
			
			if(prevEnable != null)
			{
				prevEnable.removeEventListener(MouseEvent.CLICK, prevBtnClick);
			}
			if(nextEnable != null)
			{
				nextEnable.removeEventListener(MouseEvent.CLICK, nextBtnClick);
			}
			
			
		}
		
		
		////////////////////////////
		// ---------- 前一页按钮点击
		////////////////////////////
		
		private function prevBtnClick(ev:MouseEvent = null):void
		{
			if(_currentPage <= 1)
				return;
			
			_currentPage--;
			updateComp();
			
			if(pageChangeHandler != null)
				pageChangeHandler();
		}
		
		
		////////////////////////////
		// ---------- 后一页按钮点击
		////////////////////////////
		
		private function nextBtnClick(ev:MouseEvent = null):void
		{
			if(_currentPage >= _totalPage)
				return;
			
			_currentPage++;
			updateComp();
			
			if(pageChangeHandler != null)
				pageChangeHandler();
		}
		
		
		private function updateComp():void
		{
			// 前一页
			if(_currentPage <= 1)
			{
				if(prevEnable != null)
					prevEnable.visible = false;
				if(prevDisable != null)
					prevDisable.visible = true;
			}
			else
			{
				if(prevEnable != null)
					prevEnable.visible = true;
				if(prevDisable != null)
					prevDisable.visible = false;
			}
			
			// 后一页
			if(_currentPage >= _totalPage)
			{
				if(nextEnable != null)
					nextEnable.visible = false;
				if(nextDisable != null)
					nextDisable.visible = true;;
			}
			else
			{
				if(nextEnable != null)
					nextEnable.visible = true;
				if(nextDisable != null)
					nextDisable.visible = false;;
			}
			
			pageToTotal.text = _currentPage + "/" + _totalPage;
			
			// 更新当前页码对应条目数
			if(_currentPage < _totalPage)
				_currentPageCount = _countPerPage;
			else
				_currentPageCount = _totalCount - _countPerPage * (_totalPage - 1);
		}
	}
}