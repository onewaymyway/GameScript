package com.tg.scrollbar
{
	import com.tg.StageUtil;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	public class VScroll
	{
		private var UpButton:InteractiveObject;		// 向上按钮 
		private var DownButton:InteractiveObject;	// 向下按钮
		private var SlideBlock:InteractiveObject;	// 滚动按钮
		private var SlideIcon:DisplayObject;		// 分割图标
		private var SlideAxis:DisplayObject;		// 滚动轴
		
		private var disableColor:ColorMatrixFilter = new ColorMatrixFilter(
			[
				0.2, 0.2, 0.2, 0, 0, 
				0.2, 0.2, 0.2, 0, 0, 
				0.2, 0.2, 0.2, 0, 0, 
				0,   0,   0,   1, 1
			]);
		private var disableFilters:Array;
		
		private var viewWidth:Number;
		private var viewHeight:Number=0;
		
		private var _speed:int=5;
		private var _alwaysShown:Boolean = true;
		
		private var wheel:Sprite;
		
		private var viewRatio:Number = 0;
		private var moveRange:Number=0;
		private var moveRatio:Number=0;
		
		private var slideBlockRegY:Number;
		
		
		/**选中滤镜*/
		public var firl1:GlowFilter = new GlowFilter(0x900A13, 0.5, 15, 15, 2, 2, true);
		
		
		/**
		 * 构造滚动控件
		 * @param viewRect  可视区域 注意x=0,y=0
		 * @param speed     滚动速度  默认是5
		 * @param upBtn     上方向按钮
		 * @param scrollBtn 中间拖动条
		 * @param downBtn   下方向按钮
		 * @param           滚动条中间图标
		 */
		public function VScroll(maskRect:Rectangle,
								upComp:InteractiveObject=null, downComp:InteractiveObject=null, 
								slideComp:InteractiveObject=null, 
								slideAxis:DisplayObject=null, 
								slideIcon:DisplayObject=null)
		{
			this._speed = 5;
			
			UpButton = upComp;
			DownButton = downComp;
			SlideBlock = slideComp;
			SlideAxis = slideAxis;
			SlideIcon = slideIcon;
			
			addListener();
			
			this.slideBlockRegY = SlideAxis.y;
			this.SlideBlock.y = this.slideBlockRegY;
			
			this.viewWidth = maskRect.width;
			this.viewHeight = maskRect.height;
			
			this.disableFilters = new Array();
			this.disableFilters.push(this.disableColor);
		}
		public function set speed(value:int):void
		{
			this._speed = value;
		}
		public function set alwaysShown(value:Boolean):void
		{
			this._alwaysShown = value;
		}
		
		
		//////////////////////////////
		// ---------- 设置滚动控制目标
		//////////////////////////////
		
		private var targetComp:Sprite;
		private var targetHeight:Number = 0;
		private var targetRegY:Number;
		private var targetRegisted:Boolean = false;
		
		
		/** 设置滚动目标 */		
		public function set target(value:Sprite):void
		{
			if (this.targetComp != value) 
			{
				this.targetRegisted = false;
				this.removeListener();
				
				this.clear();
			}
			
			this.targetComp = value;
		}
		
		/** 更新滚动条，添加或者删除新对象后调用此方法，不用一直调用 */		
		public function update():void
		{
			if(this.targetComp == null)
				return;
			
			if (this.targetRegisted == false) 
			{
				this.targetRegisted = true;
				
				this.targetHeight = this.targetComp.height;
				this.targetRegY = this.targetComp.y;
			}
			
			this.clear();
			
			// 可视区域比例
			if(this.targetHeight <= viewHeight)
				this.viewRatio = 1;
			else
				this.viewRatio = this.viewHeight / this.targetHeight;
			
			// 移动区域比例
			this.SlideBlock.height = this.SlideAxis.height * this.viewRatio;
			this.moveRange = this.SlideAxis.height - this.SlideBlock.height;
			if (this.moveRange <= 0) 
				this.moveRatio = 0;
			else 
				this.moveRatio = this.moveRange / (this.targetHeight - this.viewHeight);
			
			// 移动边界设定
			if (this.SlideBlock.y > this.slideBlockRegY + this.moveRange) 
				this.SlideBlock.y = this.slideBlockRegY + this.moveRange;
			
			if (this.SlideBlock.y < this.slideBlockRegY || this.viewRatio >= 1) 
				this.SlideBlock.y = this.slideBlockRegY;
			
			
			if (this.viewRatio >= 1) 
			{
				this.SlideBlock.y = this.slideBlockRegY;
				
				this.compActived(false);
				
				this.moveTarget(0);
			}
			else 
			{
				this.compActived(true);
				
				this.moveTarget(0);
			}
		}
		/** 滚动组件部分可视设定 */
		private function compActived(value:Boolean):void
		{
			if(value)
			{
				this.addMask();
				this.addWheel();
				this.addListener();
				
				this.DownButton.filters = null;
				this.UpButton.filters = null;
				
				this.SlideAxis.visible = true;
				this.DownButton.visible = true;
				this.UpButton.visible = true;
			}
			else
			{
				this.removeMask();
				this.removeWheel();
				this.removeListener();
				
				this.UpButton.filters = this.disableFilters;
				this.DownButton.filters = this.disableFilters;
				
				this.UpButton.visible = this._alwaysShown;
				this.DownButton.visible = this._alwaysShown;
				this.SlideAxis.visible = this._alwaysShown;
			}
			
			// 滑块和滑块上图标
			this.SlideBlock.visible = value;
			if(SlideIcon != null)
			{
				this.SlideIcon.visible = value;
			}
		}
		
		
		//////////////////////////
		// ---------- 目标对象遮罩
		//////////////////////////
		
		private var masker:Sprite;
		private function addMask():void
		{
			this.removeMask();
			
			this.masker = new Sprite();
			this.masker.graphics.beginFill(0);
			this.masker.graphics.drawRect(this.targetComp.x - 1, this.targetRegY, this.viewWidth + 2, this.viewHeight);
			this.masker.graphics.endFill();
			this.masker.mouseEnabled = false;
			
			this.targetComp.parent.addChild(this.masker);
			this.targetComp.mask = this.masker;
		}
		private function removeMask():void
		{
			if (targetComp != null && targetComp.parent != null && masker != null) 
			{
				this.targetComp.mask = null;
				this.targetComp.parent.removeChild(this.masker);
				this.masker = null;
			}
		}
		
		
		////////////////////////////
		// ---------- 鼠标滚轮感应区
		////////////////////////////
		
		private function addWheel():void
		{
			this.removeWheel();
			
			this.wheel = new Sprite();
			this.wheel.graphics.beginFill(0);
			this.wheel.graphics.drawRect(0, 0, this.targetComp.width, this.targetHeight);
			this.wheel.graphics.endFill();
			this.wheel.alpha = 0;
			
			this.targetComp.addChildAt(this.wheel, 0);
			this.targetComp.addEventListener(MouseEvent.MOUSE_WHEEL, this.onScrollWheel);
		}
		private function removeWheel():void
		{
			if (this.targetComp && this.wheel != null && this.wheel.parent) 
			{
				this.wheel.parent.removeChild(this.wheel);
				this.wheel = null;
				
				this.targetComp.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onScrollWheel);
			}
		}
		private function onScrollWheel(ev:MouseEvent):void
		{
			if (ev.delta > 0) 
				this.upMove();
			else 
				this.downMove();
		}
		
		
		////////////////////////////
		// ---------- 鼠标点击和拖动
		////////////////////////////
		
		private function addListener():void
		{
			this.UpButton.addEventListener(MouseEvent.CLICK, 			this.onUpBtn);
			this.DownButton.addEventListener(MouseEvent.CLICK, 			this.onDownBtn);
			this.SlideBlock.addEventListener(MouseEvent.MOUSE_DOWN, 	this.onScrollDown);
		}
		private function removeListener():void
		{
			this.UpButton.removeEventListener(MouseEvent.CLICK, 		this.onUpBtn);
			this.DownButton.removeEventListener(MouseEvent.CLICK, 		this.onDownBtn);
			this.SlideBlock.removeEventListener(MouseEvent.MOUSE_DOWN, 	this.onScrollDown);
			
			this.removeScrollListener();
		}
		private function removeScrollListener():void
		{
			StageUtil.stage.removeEventListener(MouseEvent.MOUSE_UP, 	this.onScrollUp);
			StageUtil.stage.removeEventListener(MouseEvent.MOUSE_MOVE, 	this.onScrollMove);
		}
		
		private var mouseOldY:Number;
		private function onScrollDown(ev:MouseEvent):void
		{
			//mouseOldY = mouseY;
			mouseOldY = StageUtil.stage.mouseY;
			StageUtil.stage.addEventListener(MouseEvent.MOUSE_UP, 	this.onScrollUp, 	false, 0, true);
			StageUtil.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onScrollMove, 	false, 0, true);
			
			SlideBlock.filters = [firl1];
		}
		private function onScrollUp(value:MouseEvent):void
		{
			this.removeScrollListener();
			this.SlideBlock.filters = [];
		}
		private function onScrollMove(ev:MouseEvent):void
		{
			var newMouseY:Number = StageUtil.stage.mouseY;
			var value:Number = newMouseY - mouseOldY;
			mouseOldY = newMouseY;
			
			this.moveTarget(value);
		}
		
		private function onUpBtn(e:MouseEvent):void
		{
			this.upMove();
		}
		private function onDownBtn(e:MouseEvent):void
		{
			this.downMove();
		}
		
		
		//////////////////////////
		// ---------- 移动目标对象
		//////////////////////////
		
//		public function set percent(value:int):void
//		{
//			this.SlideBlock.y = value;
//			this.moveTarget();
//		}
		
		/** 向上滚动一次 */		
		private function upMove():void
		{
			this.moveTarget(-_speed);
		}
		/** 向下滚动一次 */
		private function downMove():void
		{
			this.moveTarget(_speed)
		}
		
		private function moveTarget(value:Number):void
		{
			// 移动边界设定
			var targetY:Number = this.SlideBlock.y + value;
			if (targetY < this.slideBlockRegY)
				this.SlideBlock.y = this.slideBlockRegY;
			else if (targetY > this.slideBlockRegY + this.moveRange)
				this.SlideBlock.y = this.slideBlockRegY + this.moveRange;
			else
				this.SlideBlock.y = targetY;
			
			
			// 移动目标对象
			if (this.moveRatio <= 0) 
				this.targetComp.y = this.targetRegY;
			else 
				this.targetComp.y = + this.targetRegY + (this.slideBlockRegY - this.SlideBlock.y) / this.moveRatio;
			
			
			// 变更滑块图标位置
			if(SlideIcon != null)
			{
				SlideIcon.x = this.SlideBlock.x + SlideBlock.width/2 - SlideIcon.width / 2;
				SlideIcon.y = this.SlideBlock.y + SlideBlock.height/2 - SlideIcon.height / 2;
			}
		}
		
		/** 清除所有对象 */
		private function clear():void
		{
			this.removeMask();
			this.removeWheel();
		}
	}
}