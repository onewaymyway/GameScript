package com.tg.Tools.display.slider
{
	import com.tg.Tools.ButtonAct;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 滑块大小不可缩放的滑动条
	 * @author luli &ww
	 */
	public class Slider extends Sprite
	{
		//==========================================================================
    	//  Class constants
    	//==========================================================================
    	/**
    	 * 宽线条样式
    	 */
    	public static const THICK_SKIN:String = "ThickSkin";
		/**
		 * 细线条样式
		 */
    	public static const THIN_SKIN:String = "ThinSkin";
        //==========================================================================
        //  Constructor
        //==========================================================================
		public function Slider(sourceUI:MovieClip)
		{
			this.sourceUI=sourceUI;
			parseSkin();
			build();
		}
		private var sourceUI:MovieClip;
        //==========================================================================
        //  Variables
        //==========================================================================
        /**
         * 滑动条背景
         */
        protected var backBar:Sprite;
		/**
		 * 滑动块
		 */
        protected var thumb:*;
		/**
		 * 默认高宽
		 */
        protected var defaultWidth:Number;
        protected var defaultHeight:Number;
		/**
		 * 当前是否处于拖动滑块状态
		 */
        private var isDragging:Boolean = false;
        //==========================================================================
        //  Overridden properties: DisplayObject
        //==========================================================================
        //----------------------------------
        //  type
        //----------------------------------
        private var _type:String;
		/**
		 * 获取样式类型,目前只有两种Slider.THICK_SKIN  Slider.THIN_SKIN
		 */
        public function get type():String 
        {
          return _type;
        }
        //----------------------------------
        //  width
        //----------------------------------
		private var _width:Number;
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width = value;
			validate();
		}
        //----------------------------------
        //  height
        //----------------------------------
		private var _height:Number;
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height = value;
			validate();
		}
        //==========================================================================
        //  Properties
        //==========================================================================
        //----------------------------------
        //  min
        //----------------------------------
		private var _min:Number;
		/**
		 * 获取滑块滑动最小值
		 */
		public function get min():Number
		{
			return _min;
		}
		/**
		 * 设置滑块滑动最小值
		 */
		public function set min(value:Number):void
		{
			_min = value;
			validate();
		}
        //----------------------------------
        //  max
        //----------------------------------
		private var _max:Number;
		/**
		 * 获取滑块滑动最大值
		 */
		public function get max():Number
		{
			return _max;
		}
		/**
		 * 设置滑块滑动最大值
		 */
		public function set max(value:Number):void
		{
			_max = value;
			validate();
        }
        //----------------------------------
        //  value
        //----------------------------------
		private var _value:Number;
		/**
		 * 获取当前滑块滑动值
		 */
		public function get value():Number
		{
			return _value;
			//return formatValue(_value);
		}
		/**
		 * 设置当前滑块滑动值
		 */
		public function set value(value:Number):void
		{
			value = Math.max(min, Math.min(value, max));
			if(value != this.value)
			{
				_value = value;
				// 非拖动状态下才需要主动设置thumb的位置
				if(!isDragging)
				{
					setThumbPosition();
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
        //----------------------------------
        //  enable
        //----------------------------------
		private var _enable:Boolean;
		/**
		 * 获取启用/禁用状态
		 */
		public function get enable():Boolean
		{
			return _enable;
		}
		/**
		 * 获取启用/禁用状态
		 */
		public function set enable(value:Boolean):void
		{
			_enable = value;
			mouseChildren = _enable;
			mouseEnabled = _enable;
			thumb.visible = _enable;
		}
        //==========================================================================
        //  Public methods
        //==========================================================================
        /**
         * 设置Slider的数值
         * @param min Slider的最小值
         * @param max Slider的最大值
         * @param value Slider当前值
         */
		public function setParameter(min:Number, max:Number, value:Number):void
		{
			_min = min;
			_max = max;
			this.value = value;
		}
		/**
		 * 销毁
		 */
		public function destory():void
		{
			removeHandlers();
		}
        //==========================================================================
        //  Protected methods
        //==========================================================================
        /**
         * 解析样式
         */
		protected function parseSkin():void
		{
//			var assetName:String;
//			if(type == THICK_SKIN)
//			{
//				assetName = "VSlider_ThickSkin";
//			}
//			else if(type == THIN_SKIN)
//			{
//				assetName = "VSlider_ThinSkin";
//			}
//			var sourceUI:MovieClip = ZHLoader.getInstance().getMovieClipByName(assetName);
			backBar = sourceUI.getChildByName("sliderBack") as Sprite;
			thumb = sourceUI.getChildByName("thumb");
			
			if(thumb as MovieClip)
			new ButtonAct(thumb);
			trace("backBar:"+backBar);
			trace("thumb:"+thumb);
			initSetting();
		}
		/**
		 * 初始化设置
		 */
		protected function initSetting():void
		{
			defaultWidth = backBar.width;
			defaultHeight = 100;
		}
		/**
		 * 初始化创建
		 */
		protected function build():void
		{
			_width = defaultWidth;
			_height = defaultHeight;
			createBackbar();
			createThumb();
			addHandlers();
			setParameter(0, 100, 0);
		}
		/**
		 * 创建背景条
		 */
		protected function createBackbar():void
		{
			backBar.x = 0;
			addChildAt(backBar, 0);
		}
		/**
		 * 创建背滑块
		 */
		protected function createThumb():void
		{
			addChild(thumb);
			thumb.x = (_width - thumb.width) / 2 >> 0;
		}
		/**
		 * 滑动条机制生效
		 */
		protected function validate():void
		{
			resetBackBar();
			setThumbPosition();
		}
		/**
		 * 重设背景条尺寸
		 */
		protected function resetBackBar():void
		{
			backBar.width = _width;
			backBar.height = _height;
		}
		/**
		 * 设置滑块位置
		 */
		protected function setThumbPosition():void
		{
			thumb.y = Math.round((value - min) / (max - min) * (backBar.height - thumb.height));
		}
		/**
		 * 添加事件回调
		 */
		protected function addHandlers():void
		{
			backBar.addEventListener(MouseEvent.MOUSE_DOWN, backBar_mouseDownHandler);
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
		}
		/**
		 * 删除事件回调
		 */
		protected function removeHandlers():void
		{
			backBar.removeEventListener(MouseEvent.MOUSE_DOWN, backBar_mouseDownHandler);
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
		}
		/**
		 * 开始拖动滑块
		 */
		protected function startThumbDrag():void
		{
			thumb.startDrag(false, new Rectangle(thumb.x, 0, 0, height - thumb.height));
			isDragging = true;
		}
		/**
		 * 格式化当前滑块的值，保留到小数点后两位
		 */
		protected function formatValue(value:Number):Number
		{
			return Math.round(value * 100) / 100;
		}
		//==========================================================================
		//  Event handlers
		//==========================================================================
		/**
		 * 背景条鼠标按下事件回调
		 */
		protected function backBar_mouseDownHandler(event:MouseEvent):void
		{
			value = min + mouseY / (height - thumb.height) * (max - min);
		}
		/**
		 * 滑块鼠标按下事件回调
		 */
		protected function thumb_mouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			startThumbDrag();
		}
		/**
		 * 舞台鼠标移动事件回调
		 */
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			value = min + thumb.y / (height - thumb.height) * (max - min);
		}
		/**
		 * 舞台鼠标弹起事件回调
		 */
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stopDrag();
			isDragging = false;
		}
	}
}
