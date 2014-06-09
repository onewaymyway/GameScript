package com.tg.window
{
	import com.tg.StageUtil;
	import com.tg.Tools.UserStateSensor;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	public class Window extends Sprite
	{
		private static var createrId:int = 0;
		
		private var _height:Number;
		private var _width:Number;
		
		private var _id:String;
		private var _windowName:String;
		private var _type:int;
		private var _shown:Boolean;
		
		private var container:DisplayObjectContainer;
		private var panelContent:DisplayObject;
		private var dragDropArea:Sprite;
		
		public var beforeShow:Function;
		public var afterShow:Function;
		
		public var beforeHide:Function;
		public var afterHide:Function;
		/** 窗口被关闭回调 */
		private var closeFun:Function;
		
		
		/** 窗口关闭时的消失目标点，基于window layer(WindowWrapper.layer)，null则居中消失 */
		public var hidePoint:Point;
		
		public function Window(owner:DisplayObjectContainer, 
							   content:DisplayObject, dragDrop:Sprite)
		{
			Window.createrId++;
			
			dragDrop.buttonMode = true;
			
			this._id = Window.createrId.toString();
			this._shown = false;
			
			this.container = owner;
			this.panelContent = content;
			this.dragDropArea = dragDrop;
			
			addChild(content);
			
			// 对于滚动面板组件，通过此处强行设置高宽
			var winComp:IWindowComp = content as IWindowComp;
			if(winComp == null)
			{
				_height = content.height;
				_width = content.width;
			}
			else
			{
				_height = winComp.windowHeight;
				_width = winComp.windowWidth;
			}
			
			if(dragDrop.parent == null)
				addChild(dragDrop);
		}
		
		
		//////////////////////
		// ---------- 父窗口名
		//////////////////////
		
		private var _parentNameList:Array = new Array();
		public function get parentNameList():Array
		{
			return _parentNameList;
		}
		public function addParentName(parentName:String):void
		{
			if(parentName == null)
				return;
			
			for each(var tmp:String in _parentNameList)
			{
				if(tmp == parentName)
					return;
			}
			
			_parentNameList.push(parentName);
		}
		public function removeParentName(parentName:String):void
		{
			if(parentName == null)
				return;
			
			for(var i:int = 0; i < _parentNameList.length; i++)
			{
				var tmp:String = _parentNameList[i];
				if(tmp == parentName)
				{
					_parentNameList.splice(i, 1);
					return;
				}
			}
		}
		private var clickBool:Boolean = false;
		private var clickBool2:Boolean = false;
		
		//////////////////////
		// ---------- 
		//////////////////////
		/**
		 * 
		 * @param relocate
		 * @param force
		 * @param closeed 是否关闭其他窗口
		 * 
		 */		
		public function show(relocate:Boolean = true,force:Boolean=false,closeed:Boolean = true):void
		{
			//LoadMusic.Play("打开");
			
			if(this.shown&&(!force))
			{
				hide();
				return;
			}
			if(closeed)
				WindowWrapper.closeSpecialWindows();
			UserStateSensor.me.playerActive();
			// 显示之前，并受到结果控制
			if(relocate && beforeShow != null)
				beforeShow(this);
			
			_shown = true;
			
			if(!container.contains(this))
				container.addChild(this);
			
			dragDropArea.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			dragDropArea.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			dragDropArea.addEventListener(MouseEvent.MOUSE_OUT, mouseOUT);
			dragDropArea.addEventListener(MouseEvent.MOUSE_OVER, mouseOVER);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown1);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp1);
			
			
			moveToCenter();
			clickActived();
			
			// 显示之后
			if(relocate && afterShow != null)
				afterShow(this);
		}
		
		public function moveToCenter():void
		{
			this.x = (StageUtil.adjustedStageWidth - width) / 2;
			this.y = (StageUtil.adjustedStageHeight - height) / 2;
			
			if(width > StageUtil.adjustedStageWidth)
			{
				this.x = 0;	
			}
			if(height > StageUtil.adjustedStageHeight)
			{
				this.y = 0;	
			}
		}
		
		
		/**
		 * 隐藏窗口
		 * @param type	默认参数0，隐藏时显示渐变效果
		 */
		public function hide(widthEffect:Boolean = true, relocate:Boolean = true):void
		{
			if(!this.shown) 
				return;
			//LoadMusic.Play("打开");
			// 关闭之前，并受到结果控制
			if(relocate && beforeHide != null)
				beforeHide(this, widthEffect);
			
			_shown = false;
			
			if(container.contains(this))
				container.removeChild(this);
			
			dragDropArea.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_OUT, mouseOUT);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_OVER, mouseOVER);
			
			if(relocate && afterHide != null)
				afterHide(this, widthEffect);
			
			if(closeFun != null)
				closeFun();
			WindowWrapper.checkAllWindowState();
		}
		/** 窗口被关闭回调 */
		public function set onClose(fun:Function):void
		{
			this.closeFun = fun;
		}
		
		/**
		 * 回收销毁
		 */
		public function destroy():void
		{
			dragDropArea.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_OUT, mouseOUT);
			dragDropArea.removeEventListener(MouseEvent.MOUSE_OVER, mouseOVER);
			
			if(contains(panelContent))
				removeChild(panelContent);
			
			if(contains(dragDropArea))
				removeChild(dragDropArea);
			
			if(container.contains(this))
				container.removeChild(this);
			
			panelContent = null;
			dragDropArea = null;
			container = null;
		}
		
		// event listeners
		
		private function clickActived(ev:MouseEvent = null):void
		{
			var childIndex:int = container.getChildIndex(this);
			if(childIndex < container.numChildren - 1)
			{
				container.swapChildrenAt(childIndex, container.numChildren - 1);
			}
		}
		/***************2222222222222222222222222222222222222222222222222222222222222222222**********/
		private function mouseOUT(e:MouseEvent):void
		{
			
		}
		private function mouseOVER(e:MouseEvent):void
		{
			if(!clickBool && clickBool2 && dragDropArea.mouseEnabled)
			{
				dragDropArea.mouseEnabled = false;
			}
		}
		private function mouseDown1(e:MouseEvent):void
		{
			clickBool2 = true;
		}
		private function mouseUp1(e:MouseEvent):void
		{
			if(clickBool2)
			{
				clickBool2 = false;
				setTimeout(huifu,10);
			}
		}
		
		private function huifu():void
		{
			dragDropArea.mouseEnabled = true;
		}
		/***************22222222222222222222222222222222222222222222222222222222222222222222222222222222************/
		private function mouseDown(ev:MouseEvent = null):void
		{
			clickBool = true;
			clickActived();
			
			this.startDrag();
		}
		
		private function mouseUp(ev:MouseEvent = null):void
		{
			
//			if(!clickBool)
//			{
//				
//				dragDropArea.mouseEnabled = false;
//				return;
//			}
			clickBool = false;
			this.stopDrag();
		}
		
		// the methods below are bean's properties.
		
		override public function get height():Number
		{
			return _height;
		}
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get id():String
		{
			return _id;
		}
		public function get shown():Boolean
		{
			return _shown;
		}
		
		public function get windowName():String
		{
			return _windowName;
		}
		public function set windowName(value:String):void
		{
			_windowName = value;
		}
		
		public function get windowType():int
		{
			return _type;
		}
		public function set windowType(value:int):void
		{
			_type = value;
		}
		
	}
}