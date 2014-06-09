package com.tg.component
{
	import com.tg.display.PublicSkin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 *通用滚动条 
	 * @author Hdz
	 * 
	 */
	public class ScrollBar extends Sprite
	{
		/** 向下按钮 */		
		private var _DownBtn:Sprite;
		/** 滚动按钮 */
		private var _ScrollBtn:Sprite; 
		/** 向上按钮 */
		private var _UpBtn:Sprite;
		/**背景*/
		private var _ListBack:Sprite;
		/**图标*/
		private var _icon:Sprite;
		
		private var _filterColor:ColorMatrixFilter;
		
		private var _filters:Array;
		
		private var _target:Sprite;
		
		private var _targetBool:Boolean=false;
		
		private var _firstBool:Boolean=false;
		
		private var _showWidth:Number=0;
		
		private var _mainHeight:Number=0;
		
		private var _targetY:Number;
		
		private var _showHeight:Number=0;
		
		private var _speed:int=5;
		
		private var _maskX:int=0;
		
		private var _rectBool:Boolean=false;
		
		private var _visibleScrollbar:Boolean=true;
		
		private var _isMove:Boolean=false;
		
		private var _loadThisBool:Boolean=false;
		
		private var _maskY:int=0;
		
		private var _wheel:Sprite;
		
		private var _wheelBool:Boolean=false;
		
		private var ratio:Number=0;
		
		private var _isLostUp:Boolean=false;
		
		private var _move:Number=0;
		
		private var _movePoint:Number=0;
		
		private var _rect:Sprite;
		
		private var _showBottomFirst:Boolean=false;
		/**选中滤镜*/
		public var firl1:GlowFilter = new GlowFilter(0x900A13,.5,15,15,2,2,true);
	
		/**
		 *  初始化滚动条 
		 * @param viewRect  可视区域 注意x=0,y=0
		 * @param speed     滚动速度  默认是5
		 * @param type    滚动条皮肤类型 默认都是1
		 * 
		 */	
		public function ScrollBar(viewRect:Rectangle,speed:int = 5,type:int = 1)
		{
			this._speed = speed;
			var b1:*,b2:*,b3:*,b4:*,b5:*
			switch(type)
			{
				case 1:
					b1 = PublicSkin.instance.getSkin("scrollUpBtn");
					b2 = PublicSkin.instance.getSkin("scrollBtn");
					b3 = PublicSkin.instance.getSkin("scrollDoenBtn");
					b4 = PublicSkin.instance.getSkin("ScrollIcon");
					b5 = PublicSkin.instance.getSkin("scrollBj");
					
					setSkin(b1,b2,b3,b4,b5);
					break;
			}
			
			
			
			this._showWidth = viewRect.width;
			this._showHeight = viewRect.height
			this._filterColor = new ColorMatrixFilter([0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0.2, 0.2, 0.2, 0, 0, 0, 0, 0, 1, 1]);
			this._filters = new Array();
			this._filters.push(this._filterColor);
	
		}
		/**
		 * 设置滚动目标 
		 * @param arg1
		 * 
		 */		
		public function set target(arg1:DisplayObject):void
		{
			if(arg1 as TextField)
			{
				throw(new Error("暂不支持文本！"))
			}
			else
			{
				if (this._target != arg1) 
				{
					if (this._target != null) 
					{
						this.clear();
					}
				}
				if (arg1 == null) 
				{
					this.scrollUpClear();
				}
				this._target = arg1 as Sprite;
				if (this._target == null && this._firstBool) 
				{
					this.close();
					return;
				}
				if (this._target == null) 
				{
					return;
				}

				this._targetBool = true;
			}
		}
		/**
		 * 更新滚动条。添加或者删除新对象后调用此方法，不用一直调用  
		 * 
		 * @param type   1、向下滚动到底 2、保持 3、向上到顶
		 * 
		 */				
		public function update(type:int = 3):void
		{
			if (this._target != null)
			{
				this.clear();
			}
			
			this._mainHeight = this._target.height;
			
			if (this._firstBool == false) 
			{
				this._targetY = this._target.y;
				this._firstBool = true;
			}
			this.startList();
			
			if(type == 1)
			{
				this._showBottomFirst = false;
//				liveY = this._move;
				this._ScrollBtn.y = this._move;
				this.scrollMove();
			}
			else if(type == 2){
				
			}
			else
			{
				this._showBottomFirst = false;
//				liveY = 0
				this._ScrollBtn.y = 0;
				this._ScrollBtn.x = 1;
				this.scrollMove();
			}
			
//			liveY = this._move;
			_icon.x = this._ScrollBtn.x + _ScrollBtn.width/2 - _icon.width/2;
			_icon.y = this._ScrollBtn.y + _ScrollBtn.height/2 - _icon.height/2;
		}
		
		private function setSkin(upBtn:DisplayObject,scrollBtn:DisplayObject,downBtn:DisplayObject,icon:DisplayObject,_back:DisplayObject):void
		{
			var bit4:Bitmap;
			if(upBtn)
			{
				_UpBtn = new Sprite();
				var bit2:Bitmap = new Bitmap();
				bit2.bitmapData = new BitmapData(upBtn.width,upBtn.height,true,0);
				bit2.bitmapData.draw(upBtn);
				
				this._UpBtn.addChild(bit2);
				_UpBtn.y = - _UpBtn.height
					this.addChild(this._UpBtn);
				_UpBtn.buttonMode = true;
			}
			
			if(downBtn)
			{
				_DownBtn = new Sprite();
				var bit3:Bitmap = new Bitmap();
				bit3.bitmapData = new BitmapData(downBtn.width,downBtn.height,true,0);
				bit3.bitmapData.draw(downBtn);
				this._DownBtn.addChild(bit3);
				
				this.addChild(this._DownBtn);
				_DownBtn.buttonMode = true;
			}
			if(scrollBtn)
			{
				_ScrollBtn = new Sprite();
//				var bit1:Bitmap = new Bitmap();
//				bit1.bitmapData = new BitmapData(scrollBtn.width,scrollBtn.height,true,0);
//				bit1.bitmapData.draw(scrollBtn);
				this._ScrollBtn.addChild(scrollBtn);
				
				this.addChild(this._ScrollBtn);
				_ScrollBtn.buttonMode = true;
			}
			if(icon)
			{
				_icon = new Sprite();
				bit4 = new Bitmap();
				bit4.bitmapData = new BitmapData(icon.width,icon.height,true,0);
				bit4.bitmapData.draw(icon);
				this._icon.addChild(bit4);
				
				_icon.mouseEnabled = false;
				_icon.mouseChildren = false;
				_icon.visible = false;
				this.addChild(this._icon);
			}
			
			if(_back)
			{
				_ListBack = new Sprite();
				this._ListBack.addChild(_back);
				this.addChildAt(this._ListBack,0);
				_ListBack.y = 1;
			}
		}
		private function set visibleScrollbar(arg1:Boolean):void
		{
			this._visibleScrollbar = arg1;
		}
		private function createMask():void
		{
			this.clearMask();
			
			this._maskX = this._target.x;
			
			
			this._maskY = this._targetY;
			
			this._rect = new Sprite();
			this._rect.graphics.beginFill(0);
			this._rect.graphics.drawRect(this._maskX - 1, this._maskY, this._showWidth + 2, this._showHeight);
			this._rect.graphics.endFill();
			this._rect.mouseEnabled = false;
			this._target.parent.addChild(this._rect);
			this._target.mask = this._rect;
			this._rectBool = true;
		}
		
		private function createWheel():void
		{
			this.clearWheel();
			this._wheel = new Sprite();
			this._wheel.graphics.beginFill(0);
			this._wheel.graphics.drawRect(0, 0, this._target.width, this._mainHeight);
			this._wheel.graphics.endFill();
			this._target.addChildAt(this._wheel, 0);
			this._target.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onScrollWheel);
			this._wheel.alpha = 0;
			this._wheelBool = true;
		}
		
		private function clearMask():void
		{
			if (this._target && this._target.parent && this._rectBool) 
			{
				this._target.mask = null;
				this._target.parent.removeChild(this._rect);
				this._rect = null;
				this._rectBool = false;
			}
		}
		
		private function clearWheel():void
		{
			if (this._target && this._wheelBool && this._wheel.parent) 
			{
				this._wheel.parent.removeChild(this._wheel);
				this._target.removeEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onScrollWheel);
				this._wheel = null;
				this._wheelBool = false;
			}
		}
		
		
		
		private function startList():void
		{
			if (this._targetBool == false)
			{
				return;
			}
			this.clear();
			this.loadScrollbar();
			this.scrollbarLive();
			this.scrollbarSize();
			if (this.ratio >= 1) 
			{
				this.renderData();
				this.hideBtn(false);
				this._DownBtn.filters = this._filters;
				this._UpBtn.filters = this._filters;
				this._ListBack.visible = this._visibleScrollbar;
				this._DownBtn.visible = this._visibleScrollbar;
				this._UpBtn.visible = this._visibleScrollbar;
				this._showBottomFirst = true;
			}
			else 
			{
				this.createMask();
				this.createWheel();
				this.hideBtn(true);
				this._DownBtn.filters = null;
				this._UpBtn.filters = null;
				this._ListBack.visible = true;
				this._DownBtn.visible = true;
				this._UpBtn.visible = true;
				this.scrollMove();
			}
		}
		
		private function hideBtn(bool:Boolean):void
		{
			this._ScrollBtn.visible = bool;
			this._icon.visible = bool;		
		}
		private function loadScrollbar():void
		{
			if (this._loadThisBool == false) 
			{
				this._target.parent.addChild(this);
				this.eventListener();
				this._loadThisBool = true;
			}
		}
		private function removeScrollbar():void
		{
			if (this._loadThisBool && this.parent) 
			{
				this.parent.removeChild(this);
				this._loadThisBool = false;
			}
		}
		
		private function scrollbarLive():void
		{
			this.x = this._target.x + this._showWidth;
			this.y = this._targetY + this._UpBtn.height;
		}
		
		private function scrollbarSize():void
		{
			this._ListBack.height = this._showHeight - this._DownBtn.height * 2;
			this._DownBtn.y = this._ListBack.height;
			if(this._mainHeight <= _showHeight)
			{
				this.ratio = 1;
			}
			else
			{
				this.ratio = this._showHeight / this._mainHeight;
			}
			
			this._ScrollBtn.height = this._ListBack.height * this.ratio;
			this._move = this._ListBack.height - this._ScrollBtn.height;
			if (this._move <= 0) 
			{
				this._movePoint = 0;
			}
			else 
			{
				this._movePoint = this._move / (this._mainHeight  - this._showHeight);
			}
			this.range();
		}
		private function range():void
		{
			if (this._ScrollBtn.y > this._move) 
			{
				this._ScrollBtn.y = this._move;
			}
			if (this._ScrollBtn.y < 0 || this.ratio >= 1) 
			{
				this._ScrollBtn.y = 0;
			}
			this.scrollMove();
		}
		
		private function eventListener():void
		{
			this._ScrollBtn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onScrollDown);
			this.addEventListener(MouseEvent.MOUSE_DOWN,moueHandel);
			this.addEventListener(MouseEvent.MOUSE_UP,moueHandel);
		}
		
		private function removeListener():void
		{
			this._ScrollBtn.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onScrollDown);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,moueHandel);
			this.removeEventListener(MouseEvent.MOUSE_UP,moueHandel);
		}
		public function moueHandel(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if(e.target == _UpBtn)
					{
						this.upMove();
						_UpBtn.filters = [firl1];
					}
					if(e.target == _DownBtn)
					{
						this.downMove();
						_DownBtn.filters = [firl1];
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(e.target == _UpBtn)
					{
						_UpBtn.filters = [];
					}
					if(e.target == _DownBtn)
					{
						_DownBtn.filters = [];
					}
					break;
			}
		}
		private function onScrollWheel(arg1:flash.events.MouseEvent):void
		{
			if (arg1.delta > 0) 
			{
				this.upMove();
			}
			else 
			{
				this.downMove();
			}
		}
		private function onScrollDown(arg1:flash.events.MouseEvent):void
		{
			this._showBottomFirst = false;
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onScrollUp, false, 0, true);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onScrollMove, false, 0, true);
			this._ScrollBtn.startDrag(false, new Rectangle(0, 0, 0, this._move));
			this._isMove = true;
			this._ScrollBtn.filters = [firl1];
			this._ScrollBtn.x = _UpBtn.x;
		}
		
		private function set showHeight(arg1:Number):void
		{
			this._showHeight = arg1;
			this.startList();
		}
		
		private function onScrollUp(arg1:flash.events.MouseEvent):void
		{
			this.scrollUpClear();
			this._ScrollBtn.filters = [];
		}
		
		private function onScrollMove(arg1:flash.events.MouseEvent):void
		{
			this._isLostUp = false;
			this.scrollMove();
		}
		
		private function set speed(arg1:int):void
		{
			this._speed = arg1;
		}
		
		
		private function set liveY(_y:Number):void
		{
			this._ScrollBtn.y = _y;
			this._ScrollBtn.x = _UpBtn.x;
			this.scrollMove();
		}
		
		/**
		 *向上滚动一次 
		 * 
		 */		
		private function upMove():void
		{
			this._showBottomFirst = false;
			if (this._ScrollBtn.y - this._speed < 0) 
			{
				this._ScrollBtn.y = 0;
			}
			else 
			{
				this._ScrollBtn.y = this._ScrollBtn.y - this._speed;
			}
			this._ScrollBtn.x = _UpBtn.x;
			this.scrollMove();
		}
		/***向下滚动一次*/
		private function downMove():void
		{
			this._showBottomFirst = false;
			if (this._ScrollBtn.y + this._speed > this._move) 
			{
				this._ScrollBtn.y = this._move;
			}
			else 
			{
				this._ScrollBtn.y = this._ScrollBtn.y + this._speed;
			}
			this._ScrollBtn.x = _UpBtn.x;
			this.scrollMove()
		}
		private function scrollMove():void
		{
			if (stage == null) 
			{
				return;
			}
			if (this._movePoint <= 0) 
			{
				this._target.y = this._targetY;
			}
			else 
			{
				this._target.y = -this._ScrollBtn.y / this._movePoint + this._targetY;
			}
			this._ScrollBtn.x = _UpBtn.x;
			_icon.x = this._ScrollBtn.x + _ScrollBtn.width/2 - _icon.width/2;
			_icon.y = this._ScrollBtn.y + _ScrollBtn.height/2 - _icon.height/2;
		}
		/** 关闭本类 */
		private function close():void
		{
			if (this._isMove) 
			{
				this.scrollUpClear();
			}
			this._firstBool = false;
			this._showBottomFirst = true;
			this.clear();
			this.removeListener();
			this.removeScrollbar();
			this._target = null;
		}
		
		/** 清除所有对象 */
		private function clear():void
		{
			this.clearMask();
			this.clearWheel();
		}
		
		private function renderData():void
		{
			this._ScrollBtn.x = _UpBtn.x;
			this._ScrollBtn.y = 0;
			this.scrollMove();
		}
		private function scrollUpClear():void
		{
			this._ScrollBtn.x = _UpBtn.x;
			this._ScrollBtn.stopDrag();
			if (stage == null) 
			{
				return;
			}
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onScrollUp);
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onScrollMove);
			this._isMove = false;
		}
	}
}