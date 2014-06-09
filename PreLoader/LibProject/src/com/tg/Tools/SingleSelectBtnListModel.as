package com.tg.Tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 单选按钮组控制类 
	 * @author ww
	 * 
	 */
	public class SingleSelectBtnListModel
	{
		public function SingleSelectBtnListModel()
		{
		}
		/**
		 * 要管理的对象列表 
		 */
		private var btnList:Array=[];
		
		/**
		 * 是否锁定 
		 */
		private var _isLock:Boolean=false;
		
		/**
		 * 当按钮被点击选中时的回调 
		 */
		public var selectFun:Function;
		
		/**
		 * 当前选中的元素 
		 */
		public var selectItem:*;
		
		/**
		 * 当前选中元素的ID 
		 */
		public var selectID:int;
		
		/**
		 * 控制的面板列表 
		 */
		private var panelList:Array=[];
		/**
		 * 向按钮组中添加按钮,默认选中第一个添加的按钮
		 * @param btn
		 * 
		 */
		public function addBtn(btn:*):void
		{
			btnList.push(btn);
			var tItem:EventDispatcher;
			tItem=btn as EventDispatcher;
			if(tItem)
			tItem.addEventListener(MouseEvent.MOUSE_DOWN,BtnClick,false,0,true);
			

			setSelectByID(0);
			
			
			trace("BtnList addBtn:"+btn.name);
		}
		/**
		 * 设置要管理的对象列表 
		 * @param arr
		 * 
		 */
		public function setBtnList(arr:Array):void
		{
			clearBtns();
			btnList=arr;
			var i:int;
			var len:int;
			var tItem:EventDispatcher;
			len=btnList.length;
			for(i=0;i<len;i++)
			{
				tItem=btnList[i] as EventDispatcher;
				if(tItem)
				{
					tItem.addEventListener(MouseEvent.MOUSE_DOWN,BtnClick);
				}
				
			}
			setSelectByID(0);
		}
		
		/**
		 * 设置要控制的面板列表 
		 * @param arr
		 * 
		 */
		public function setPanelList(arr:Array):void
		{
			panelList=arr;
		}
		/**
		 * 清空按钮 
		 * 
		 */
		public function clearBtns():void
		{
			var i:int;
			var len:int;
			var tItem:EventDispatcher;
			len=btnList.length;
			for(i=0;i<len;i++)
			{
				tItem=btnList[i] as EventDispatcher;
				if(tItem)
				{
					tItem.removeEventListener(MouseEvent.MOUSE_DOWN,BtnClick);
				}
				FocusManagerW.setSelect(btnList[i],false);
			}
			btnList=[];
			blockList=[];
		}
		/**
		 * 按钮点击 
		 * @param evt
		 * 
		 */
		private function BtnClick(evt:MouseEvent):void
		{
			if(_isLock)
			{
				return;
			}
			if(isBlock(evt.currentTarget))
			{
				FocusManagerW.setSelect(evt.currentTarget,false);
				return;
			}
			setSelectByItem(evt.currentTarget);
			updateState();
			noticeSelect();
		}
		
		/**
		 * 要屏蔽的按钮列表 
		 */
		private var blockList:Array=[];
		/**
		 * 设置要屏蔽的按钮列表 
		 * @param btnList
		 * 
		 */
		public function setBlockBtnList(btnList:Array):void
		{
			blockList=btnList;
		}
		
		/**
		 * 判断按钮是否被屏蔽 
		 * @param dis
		 * @return 
		 * 
		 */
		public function isBlock(dis:*):Boolean
		{
			var i:int;
			var len:int;
			if(!blockList) return false;
			len=blockList.length;
			for(i=0;i<len;i++)
			{
				if(dis==blockList[i])
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 如果有控制显示列表则更显显示对象状态 
		 * 
		 */
		private function updateState():void
		{
			var tDis:DisplayObject;
			if(!panelList) return;
			
			var i:int;
			var len:int;
			len=panelList.length;
			for(i=0;i<len;i++)
			{
				tDis=panelList[i];
				if(!tDis) continue;
				if(i==selectID)
				{
					tDis.visible=true;
				}else
				{
					tDis.visible=false;
				}
			}
			
			
		}
		/**
		 * 通知选中 
		 * 
		 */
		private function noticeSelect():void
		{
			
			if(selectFun != null && selectFun.length == 1)
			{
				selectFun(selectItem);
			}
		}
		/**
		 * 设置是否锁定 
		 * @param isLock
		 * 
		 */
		public function set Lock(isLock:Boolean):void
		{
			this._isLock=isLock;
			var i:int;
			var len:int;
			
			var tCt:DisplayObjectContainer;

			len=btnList.length;
			for(i=0;i<len;i++)
			{
				tCt=btnList[i] as DisplayObjectContainer;
				if(!tCt) continue;
				tCt.mouseChildren=!isLock;
				tCt.mouseEnabled=!isLock;
			}

			
		}
		/**
		 * 选中指定名字的按钮
		 * @param tName
		 * @param ifNotice 是否通知回调
		 * 
		 */
		public function setSelectByName(tName:String,ifNotice:Boolean=false):int
		{
			selectID=FocusManagerW.setSelectByName(tName,btnList);
			selectItem=getItemByID(selectID);
			if(ifNotice)
			{
				noticeSelect();
			}
			updateState();
			return selectID;
		}
		
		/**
		 * 选中指定id的按钮
		 * @param tID
		 * @param ifNotice 是否通知回调
		 * 
		 */
		public function setSelectByID(tID:int,ifNotice:Boolean=false):*
		{
			selectID=tID;
			selectItem=FocusManagerW.setSelectById(tID,btnList);
			if(ifNotice)
			{
				noticeSelect();
			}
			updateState();
			return selectItem;
		}
		
		/**
		 * 选中指定按钮 
		 * @param item
		 * @param ifNotice 是否通知回调
		 * @return 
		 * 
		 */
		public function setSelectByItem(item:*,ifNotice:Boolean=false):int
		{
			selectID=FocusManagerW.setSelectByItem(item,btnList);
			selectItem=getItemByID(selectID);
			if(ifNotice)
			{
				noticeSelect();
			}
			updateState();
			return selectID;
		}
		/**
		 * 根据ID获取Item 
		 * @param id
		 * @return 
		 * 
		 */
		public function getItemByID(id:int):*
		{
			return btnList[id];
		}
		
	}
}