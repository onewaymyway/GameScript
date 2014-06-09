package com.tg.Tools.pageTools
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public dynamic class DataPageController extends MovieClip
	{
		public var prevBtn:SimpleButton;	// 上一页
		public var nextBtn:SimpleButton;	// 下一页
		public var pageToTotal:TextField;	// 当前页/总页
		
		private var _currentPage:int;
		/** 当前页码，1代表第一页 */
		public function get currentPage():int
		{return _currentPage;}
		
		private var _totalPage:int;
		/** 总页码 */
		public function get totalPage():int
		{return _totalPage;}
		
		private var _currentPageCount:int;
		/** 当前页码对应条目数 */
		public function get currentPageCount():int
		{return _currentPageCount;}
		
		private var _totalCount:int;
		private var _countPerPage:int;
		
		public var pageChangeHandler:Function;
		
		/**
		 * 
		 */
		public function DataPageController()
		{
			super();
			
			prevBtn.addEventListener(MouseEvent.CLICK, prevBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnClick);
		}

		public function init(totalCount:int, countPerPage:int):void
		{
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
		
		public function changeToPage(page:int):void
		{
			if(page < 1)
				_currentPage = 1;
			else if(page > _totalPage)
				_currentPage = _totalPage;
			else
				_currentPage = page;
			updateComp();
			
			if(pageChangeHandler != null)
				pageChangeHandler();
		}
		
		private function prevBtnClick(ev:MouseEvent = null):void
		{
			if(_currentPage <= 1)
				return;
			
			_currentPage--;
			updateComp();
			
			if(pageChangeHandler != null)
				pageChangeHandler();
		}
		
		private function nextBtnClick(ev:MouseEvent = null):void
		{
			if(_currentPage >= 1)
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
				prevBtn.enabled = false;
			else
				prevBtn.enabled = true;
			
			// 后一页
			if(_currentPage >= _totalPage)
				nextBtn.enabled = false;
			else
				nextBtn.enabled = true;
			
			pageToTotal.text = 1 + "/" + _totalPage;
			
			// 更新当前页码对应条目数
			if(_currentPage < _totalPage)
				_currentPageCount = _countPerPage;
			else
				_currentPageCount = _totalCount - _countPerPage * (_totalPage - 1);
		}
	}
}