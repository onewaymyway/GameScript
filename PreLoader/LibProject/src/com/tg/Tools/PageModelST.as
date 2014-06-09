package com.tg.Tools
{
	import flash.display.DisplayObject;
	/**
	 * 
	 * @author ww
	 * 分页显示封装类
	 * 
	 * 使用范例
	 * 
	 private var pageModel:PageModel;
	 * 
	 * 
	 pageModel=new PageModel;
//	 * 每页显示的条目数
	 pageModel.nPerPage=pageCount;	
//	 * item显示的容器
	 pageModel.itemContainer=_unionSystemView;
//	 * item起始X坐标
	 pageModel.startX=UnionSystemNameList.UnionSystemView_Item_UnionInfor_x;
//	 * item起始y坐标
	 pageModel.startY=UnionSystemNameList.UnionSystemView_Item_UnionInfor_y ;
//	 * item y坐标间距
	 pageModel.dY=UnionSystemNameList.UnionManageView_Item_UnionInfor_Vertical_distance_number;
//	 * item 带有的名字标示符
	 pageModel.itemFlag="UnionInfor_item";
//	 * item创建函数
//	 * function(itemInfor:*,index:int):DisplayObject 
	 pageModel.itemCreater=createAItem;
//	 * 显示页面信息函数
//	 * function(tPage:int,MaxPage:int):void 
	 pageModel.pageInforFun=freshPageInfor;
	 * 
	 * 
//	 * 设置item列表
	 pageModel.itemList=_groupArr;
	 * 
	 * 
	 * 
	 * 
	 */
	public class PageModelST
	{
		/**
		 * 每页显示条数
		 */		
		public var nPerPage:int;
		/**
		 *  
		 */		
		public var _itemList:Array;
		/**
		 * 最大页数 
		 */		
		public var maxPage:int;
		/**
		 * 当前页码 
		 */		
		public var tPage:int;

		/**
		 * item创建函数
		 * @param itemInfor
		 * @param i
		 * @return 
		 * private function createAItem(itemInfor:*,index:int):DisplayObject 
		 */		
		public var itemCreater:Function;
		/**
		 * 显示页面信息函数
		 * 刷新页面信息 
		 * @param tPage
		 * @param maxPage
		 * private function freshPageInfor(tPage:int,MaxPage:int):void 
		 */		
		public var pageInforFun:Function;
		
		/**
		 * 列表清理函数 
		 */
		public var clearFun:Function;
//		/**
//		 * item标示符 
//		 */		
//		public var itemFlag:String="myPageItem";
		
		
		public function PageModel():void
		{
			nPerPage=10;
			itemCreater=null;
		}
		/**
		 * 获取最大页数 
		 * @param nPerPage 每页条数
		 * @param itemCount 总共条数
		 * @return 
		 * 
		 */		
		public static function getMaxPage(nPerPage:int,itemCount:int):int
		{
			if(itemCount==0) return 1;
			if(nPerPage==0) return 999;
			var rst:int;
			rst=int(itemCount/nPerPage);
			if(rst*nPerPage<itemCount) rst++;
			if(rst<1)rst=1;
			return rst;
		}
		
		/**
		 * 根据Item的序号获取所在的页数 
		 * @param nPerPage
		 * @param index
		 * @return 
		 * 
		 */
		public static function getPageByIndex(nPerPage:int,index:int):int
		{
			if(nPerPage==0) return 999;
			var rst:int;
			rst=int(index/nPerPage);
//			if(rst*nPerPage<index) rst++;
//			if(rst<1)rst=1;
			return rst;
		}
		/**
		 * 设置要显示的列表 
		 * @param items
		 * 
		 */		
		public function set itemList(items:Array):void
		{
			if(!items) 
			{
				items=[];
			}
			_itemList=items;
			tPage=-1;
			maxPage=getMaxPage(nPerPage,_itemList.length);
			trace("itemList:maxPage:"+maxPage);
		}
		/**
		 * 显示下一页 
		 * 
		 */		
		public function goNext():void
		{
			gotoPage(tPage+1);
		}
		/**
		 * 显示上一页 
		 * 
		 */		
		public function goPre():void
		{
			gotoPage(tPage-1);
		}
		/**
		 * 显示第一页 
		 * 
		 */		
		public function goFirst():void
		{
			gotoPage(1);
		}
		/**
		 * 显示最后一页 
		 * 
		 */		
		public function goEnd():void
		{
			gotoPage(maxPage);
		}
		/**
		 * 跳转到某一页 
		 * @param page
		 * 
		 */		
		public function gotoPage(page:int):void
		{
			trace("gotoPage:"+page+" max:"+maxPage);
			if(page<=0||page>maxPage) return;
			if(page==tPage) return;
			tPage=page;
			showPage();
		}
		/**
		 * 显示页面 
		 * 
		 */		
		private function showPage():void
		{
			var i:int;
			var tempNum:int = 0;
			var len:int;
			var item:DisplayObject;
			var tIndex:int;
			
			if(itemCreater == null) 
				return;
			
			trace("showPage");
			clearPage();

			for(i = (tPage -1)*nPerPage;i<_itemList.length;i++)
			{
				if(tempNum>=nPerPage) break;
				tIndex=i%nPerPage;
				item=itemCreater(_itemList[i],tIndex);
				tempNum ++;			
				
			}
			
			if(pageInforFun != null)
			{
				pageInforFun(tPage,maxPage);
			}
		}
		
		/**
		 * 清除界面 
		 * 
		 */
		private function clearPage():void
		{
//			var i:int;
//			for(i=0;i<nPerPage;i++)
//			{
//				
//			}
			
			if(clearFun != null)
				clearFun();
		}
	}
}