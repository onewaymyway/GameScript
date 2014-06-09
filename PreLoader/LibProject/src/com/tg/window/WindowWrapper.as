package com.tg.window
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.tg.StageUtil;
	import com.tg.Tools.UserStateSensor;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class WindowWrapper
	{
		public static const ROOT_WINDOW:int = 0;
		public static const CHILD_WINDOW:int = 1;
		public static const CHILDAll_WINDOW:int = 2;
		private static var layer:Sprite;
		private static var sameTypeOpen:Function;
		private static var leftSingle:Function;
		
		
		/**
		 * 初始化Window包装器	
		 * @param layer			window的父容器
		 * @param stage			系统舞台
		 * @param sameTypeOpen	同类别窗口打开回调
		 */
		public static function init(layer:Sprite, friendToFriend:Function, rootToChild:Function, leftSingle:Function):void
		{
			WindowWrapper.layer = layer;
			WindowWrapper.sameTypeOpen = rootToChild;
			WindowWrapper.leftSingle = leftSingle;
			
			repos = new Dictionary();
			//stage.addEventListener(Event.RESIZE, stageResize);
			
			hideTimer = new Timer(20);
			//hideTimer = new Timer(500);
			hideTimer.addEventListener(TimerEvent.TIMER, hideOnTimer);
			
			hideEffect = new Sprite();
			WindowWrapper.layer.addChild(hideEffect);
		}
		
		////////////////////////////
		// ---------- 包装、解除包装 
		////////////////////////////
		
		private static var repos:Dictionary;
		
		
		/**
		 * 包装显示对象为友好互斥Window组件
		 * @param windowPanel	待包装对象
		 * @param dragDrop		拖动窗体移动区域，flash.display.DisplayObject or flash.geom.Rectangle
		 * 
		 * @param windowName	窗体名称
		 * @param friendTtype	友好对象类别
		 */
		public static function wrap(windowPanel:DisplayObject, dragDrop:*, 
									windowName:String = "", windowType:int = ROOT_WINDOW):Window
		{
			if(ROOT_WINDOW != windowType && CHILD_WINDOW != windowType && CHILDAll_WINDOW != windowType) 
			{throw new Error("unknown window type");}
			
			var result:Window = createWindow(windowPanel, dragDrop);
			result.windowName = windowName;
			result.windowType = windowType;
			repos[result.id] = result;
			return result;
		}
		
		/**
		 * 解除window控制管理
		 */
		public static function unwrap(window:Window):void
		{
			repos[window.id] = null;
			delete repos[window.id];
			
			window.destroy();
		}
		/**
		 * 关闭所有窗口 
		 * 
		 */		
		public static function closeAllWindow(closeSpecial:Boolean=false):void
		{
			for(var key:* in repos)
			{
				try{
				var win:Window = repos[key];
				if(win.shown)
					win.hide();
				}catch(e:Error){}
				
			}
			if(closeNPCDialogFun!=null)
				closeNPCDialogFun();
			if(closeSpecial)
			{
				closeSpecialWindows(true);
			}
			
			UserStateSensor.me.allWindowClose();
		}
		
		public static var closeNPCDialogFun:Function;
		
		public static var specialWindowCloseFunDic:Dictionary=new Dictionary();
		
		public static function addSpecialWindowCloseFun(fun:Function):void
		{
			if(!specialWindowCloseFunDic[fun])
			{
				specialWindowCloseFunDic[fun]=true;
			}
		}
		public static function closeSpecialWindows(closeOther:Boolean=false):void
		{
			if(closeNPCDialogFun!=null)
				closeNPCDialogFun();
			var tFun:Function;
			var tKey:*;
			if(!closeOther) return;
			for(tKey in specialWindowCloseFunDic)
			{
				if(tKey is Function)
				{
					tFun=tKey;
					tFun();
				}
			} 
		}
		public static function checkAllWindowState():void
		{
			if(isAllHide())
			{
				UserStateSensor.me.allWindowClose();
			}
		}
		
		public static function isAllHide():Boolean
		{
			for(var key:* in repos)
			{
				try{
					var win:Window = repos[key];
					if(win.shown)
						return false;
				}catch(e:Error){}
				
			}
			return true;
		}
		/**
		 * 创建window
		 */
		private static function createWindow(windowPanel:DisplayObject, dragDrop:*):Window
		{
			var dragDropContent:Sprite = dragDrop as Sprite;
			if(dragDropContent == null)
			{
				var rect:Rectangle = dragDrop as Rectangle;
				if(rect == null)
				{throw new Error("\"dragDrop\" should be a DisplayObject or Rectangle instance");}
				
				dragDropContent = new Sprite();
				dragDropContent.graphics.beginFill(0x000000, 0);
				dragDropContent.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				dragDropContent.graphics.endFill();
				dragDropContent.buttonMode = true;
			}
			
			var window:Window = new Window(WindowWrapper.layer, windowPanel, dragDropContent);
			window.beforeShow = beforeWindowShow;
			window.beforeHide = beforeWindowHide;
			window.afterShow = afterWindowShow;
			window.afterHide = afterWindowHide;
			
			return window;
		}
		
		
		//////////////////////////
		// ---------- 舞台大小变化
		//////////////////////////
		
		private static function stageResize(ev:Event):void
		{
			
		}
		
		//////////////////////////////////////////
		// ---------- 新窗口打开、关闭前后，互斥、位置调整
		//////////////////////////////////////////
		
		private static function beforeWindowShow(win:Window):void
		{
			clearHideEffect();
		}
		private static function afterWindowShow(win:Window):void
		{
			// ----- 关闭多余部分
			
			if(win.windowType==CHILDAll_WINDOW) return;
			var hideHandler:Function = function (tar:Window):void
			{
				if(win.id != tar.id && tar.shown)
					tar.hide(false, false);
			}
			
			var otherId:String, otherWin:Window, parentName:String;
			var i:int, kept:Boolean;
			
			// 根窗口
			if(ROOT_WINDOW == win.windowType)
			{
				for(otherId in repos)
				{
					otherWin = repos[otherId] as Window;
					
					// 当前窗口没名称，则不能作为父窗口
					if(win.windowName == null)
					{
						hideHandler(otherWin);
						continue;
					}
					
					// 同类的根窗口关闭
					if(CHILD_WINDOW != otherWin.windowType)
					{
						hideHandler(otherWin);
						continue;
					}
					
					kept = false;
					for each(parentName in otherWin.parentNameList)
					{
						if(win.windowName == parentName)
						{
							kept = true;
							break;
						}
					}
					if(!kept)
					{
						hideHandler(otherWin);
						continue;
					}
				}
			}
			// 子窗口
			else if(CHILD_WINDOW == win.windowType)
			{
				for(otherId in repos)
				{
					otherWin = repos[otherId] as Window;
					
					// 没有名称的窗口，不能作为父窗口
					if(otherWin.windowName == null)
					{
						hideHandler(otherWin);
						continue;
					}
					
					// 非根窗口关闭
					if(ROOT_WINDOW != otherWin.windowType)
					{
						hideHandler(otherWin);
						continue;
					}
					
					// 自身的父窗口
					kept = false;
					for each(parentName in win.parentNameList)
					{
						if(otherWin.windowName == parentName)
						{
							kept = true;
							break;
						}
					}
					if(!kept)
					{
						hideHandler(otherWin);
						continue;
					}
				}
			}
			
			
			// ----- 寻找组合
			
			var rootWindow:Window, childrenWindowList:Array = new Array();
			for(var winId:String in repos)
			{
				var tmpwin:Window = repos[winId] as Window;
				// 没有名称的窗口，不能作为父窗口
				if(!tmpwin.shown)
				{
					continue;
				}
				if(tmpwin.windowName == null)
				{
					continue;
				}
				
				// 找出主窗体
				if(WindowWrapper.ROOT_WINDOW == tmpwin.windowType)
				{
					rootWindow = tmpwin;
					continue;
				}
				
				// 找出子窗体
				if(WindowWrapper.CHILD_WINDOW == tmpwin.windowType)
				{
					childrenWindowList.push(tmpwin);
					continue;
				}
			}
			
			
			// 多窗口组合
			if(rootWindow != null)
			{
				// 仅有父窗口，居中显示
				if(childrenWindowList.length == 0)
				{
					trace("only root window TODO");
				}
				// 父窗口、子窗口同时存在
				else
				{
					trace("sameTypeOpen TODO");
					if(sameTypeOpen != null && sameTypeOpen.length == 2)
					{
						sameTypeOpen(rootWindow, childrenWindowList);
					}
				}
			}
		}
		
		
		////////////////////////////
		// ---------- 窗口关闭时效果
		////////////////////////////
		
		private static var hideIndex:int;
		private static var hidePoint:Point;
		private static var hideEffect:Sprite;
		private static var hideTimer:Timer;
		private static var hideRate:Number = 0.15;
		
		private static function beforeWindowHide(win:Window, widthEffect:Boolean = false):void
		{
			if(win.windowType == ROOT_WINDOW)
			{
				// 关闭效果
				if(widthEffect)
				{
					//hideEffect.graphics.clear();
					while(hideEffect.numChildren)
					{
						hideEffect.removeChildAt(0);
					}
					
					var width:Number = win.width;
					var height:Number = win.height;
					
					hideIndex = WindowWrapper.layer.getChildIndex(win);
					hidePoint = win.hidePoint;
					if(hidePoint == null)
						hidePoint = new Point(StageUtil.adjustedStageWidth / 2, StageUtil.adjustedStageHeight / 2);
					
					var bmd:BitmapData = new BitmapData(width, height, true, 0xffffff);
					bmd.draw(win);
					
					//hideEffect.graphics.beginBitmapFill(bmd, null, false, false);
					//hideEffect.graphics.endFill();
					var bm:Bitmap = new Bitmap(bmd);
					bm.x = -bm.width / 2;
					bm.y = -bm.height / 2;
					hideEffect.addChild(bm);
					hideEffect.x = win.x+win.width/2;
					hideEffect.y = win.y+win.height/2;
					trace("-------------------------------------> " + hidePoint)
				}
			}
			else if(win.windowType == CHILD_WINDOW)
			{
				
			}
		}
		private static function afterWindowHide(win:Window, widthEffect:Boolean = false):void
		{
			if(win.windowType == ROOT_WINDOW)
			{
				if(widthEffect)
				{
					hideEffect.alpha = 1;
					hideEffect.scaleX = 1;
					hideEffect.scaleY = 1;
					
					hideEffect.visible = true;
					WindowWrapper.layer.removeChild(hideEffect);
					
					hideIndex -= 1;
					if(hideIndex < 0)
						hideIndex = 0;
					WindowWrapper.layer.addChildAt(hideEffect, hideIndex);
					
					hideTimer.start();
				}
				
				// 查找子窗口，如果子窗口有其他父窗口存在则不关闭
				var otherId:String, otherWin:Window, parentName:String;
				var otherId2:String, otherWin2:Window;
				var i:int, kept:Boolean;
				for(otherId in repos)
				{
					otherWin = repos[otherId] as Window;
					
					// 没有名称的窗口，不能作为父窗口
					if(otherWin.windowType != CHILD_WINDOW)
					{
						continue;
					}
					
					// 自身的子窗口
					kept = false;
					for each(parentName in otherWin.parentNameList)
					{
						// 需要寻找是否有其他父亲存在
						if(win.windowName == parentName)
						{
							continue;
						}
						
						var otherRoot:Array = findShownWindowByName(parentName);
						if(otherRoot.length > 0)
							kept = true;
					}
					
					if(!kept)
					{
						otherWin.hide(false);
					}
				}
			}
			else if(win.windowType == CHILD_WINDOW)
			{
				// 如果仅剩一个窗口，那么居中显示
				var shownList:Array = findShownWindow();
				if(shownList != null && shownList.length == 1)
				{
					var leftWin:Window = shownList[0];
					leftSingle(leftWin);
				}
			}
		}
		private static function findShownWindow():Array
		{
			var result:Array = new Array();
			
			var otherId:String, otherWin:Window;
			for(otherId in repos)
			{
				otherWin = repos[otherId] as Window;
				if(otherWin.shown)
					result.push(otherWin);
			}
			
			return result;
		}
		private static function findShownWindowByName(windowName:String):Array
		{
			var result:Array = new Array();
			
			var otherId:String, otherWin:Window;
			for(otherId in repos)
			{
				otherWin = repos[otherId] as Window;
				if(windowName == otherWin.windowName && otherWin.shown)
					result.push(otherWin);
			}
			
			return result;
		}
		
			
		private static function clearHideEffect():void
		{
			hideTimer.stop();
			hideEffect.visible = false;
		}
		/** 窗口缩放渐变实现 */
		private static function hideOnTimer(ev:Event):void
		{
			TweenLite.to(hideEffect,0.1, {x:hidePoint.x, y:hidePoint.y,ease:Linear.easeNone,scaleX:0,scaleY:0,alpha:0.5, onComplete:hitOver});
		}
		private static function hitOver():void
		{
			hideTimer.stop();
			hideEffect.visible = false;
		}
	}
}