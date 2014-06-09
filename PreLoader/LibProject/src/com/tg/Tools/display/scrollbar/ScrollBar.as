package com.tg.Tools.display.scrollbar
{
	
	import com.tg.Tools.display.interfaces.IScrollSlider;
	import com.tg.Tools.display.scrollslider.VScrollSlider;
	import com.tg.Tools.display.slider.Slider;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 带上下箭头、滑块控制的滑动条
	 * @author luli&ww
	 */
	public class ScrollBar extends Sprite
	{
		//==========================================================================
		//  Class constants
		//==========================================================================
		/**
		 * 当鼠标按在上下箭头上不动时，触发上下滑动的时间间隔，单位毫秒
		 */
		private static const UPDATA_DELAY_TIME:int = 150;
		//==========================================================================
		//  Constructor
		//==========================================================================
		/**
		 * 创建滑动条
		 * @param type 滑动条样式类型,目前只有两种Slider.THICK_SKIN  Slider.THIN_SKIN
		 */
		public function ScrollBar(sourceUI:MovieClip)
		{
			this.sourceUI=sourceUI;
			parseSkin();
			createSlider();
			initSetting();
			build();
		}
		//==========================================================================
		//  Variables
		//==========================================================================
		/**
		 * 控制自动上下移动的定时器
		 */
		private var sliderUpTimer:Timer;
		private var sliderDownTimer:Timer;
		/**
		 * 滑动条UI默认高宽
		 */
		protected var defaultWidth:Number;
		protected var defaultHeight:Number;
		/**
		 * 上下箭头
		 */
		protected var downButton:SimpleButton;
		protected var upButton:SimpleButton;
		/**
		 * 不带箭头的滑动条
		 */
		protected var slider:IScrollSlider;
		
		private var sourceUI:MovieClip;
		//==========================================================================
		//  Overridden properties: DisplayObject
		//==========================================================================
		//----------------------------------
		//  width
		//----------------------------------
		private var _width:Number;
		/**
		 * 获取滑动条宽度
		 */
		override public function get width():Number
		{
			return _width;
		}
		/**
		 * 设置滑动条宽度
		 */
		override public function set width(value:Number):void
		{
			_width = value;
			validate();
		}
		//----------------------------------
		//  height
		//----------------------------------
		private var _height:Number;
		/**
		 * 获取滑动条高度
		 */
		override public function get height():Number
		{
			return _height;
		}
		/**
		 * 设置滑动条高度
		 */
		override public function set height(value:Number):void
		{
			_height = value;
			validate();
		}
		//==========================================================================
		//  Properties
		//==========================================================================
		//----------------------------------
		//  type
		//----------------------------------
		private var _type:String;
		/**
		 * 获取滑动条样式类型
		 */
		public function get type():String 
		{
		  return _type;
		}
		//----------------------------------
		//  value
		//----------------------------------
		/**
		 * 获取当前滑动条滑动的值，区间为[0,1]
		 */
		public function get value():Number
		{
			return slider.value;
		}
		/**
		 * 设置当前滑动条滑动的值，区间为[0,1]
		 */
		public function set value(value:Number):void
		{
			slider.value = value;
		}
		//----------------------------------
		//  thumbScale
		//----------------------------------
		/**
		 * 获取滑动条滑块高度缩放比例
		 */
		public function get thumbScale():Number
		{
			return slider.thumbScale;
		}
		/**
		 * 设置滑动条滑块高度缩放比例，区间为[0,1]
		 */
		public function set thumbScale(value:Number):void
		{
			slider.thumbScale = value;
		}
		//----------------------------------
		//  stepValue
		//----------------------------------
		private var _stepValue:Number = 0.1;
		/**
		 * 获取滑动步长
		 */
		public function get stepValue():Number
		{
			return _stepValue;
		}
		/**
		 * 设置滑动步长，区间[0,1]，例如设置为0.1，那么每次滑动滑动条最大滑动区域高度的0.1倍
		 * @param value 步长值，区间[0,1]
		 */
		public function set stepValue(value:Number):void
		{
			_stepValue = value;
		}
		//----------------------------------
		//  enable
		//----------------------------------
		/**
		 * 获取滑动条的可用状态
		 */
		public function get enable():Boolean
		{
			return Slider(slider).enable;
		}
		/**
		 * 设置滑动条的可用状态
		 */
		public function set enable(value:Boolean):void
		{
			mouseChildren = value;
			mouseEnabled = value;
			Slider(slider).enable = value;
			upButton.mouseEnabled = downButton.mouseEnabled = value;
		}
		//==========================================================================
		//  Public methods
		//==========================================================================
		/**
		 * 销毁
		 */
		public function destory():void
		{
			removeHandlers();
			slider.destory();
		}
		//==========================================================================
		//  Protected methods
		//==========================================================================
		/**
		 * 根据不同type设置不同的组件皮肤
		 */
		protected function parseSkin():void
		{
//			var assetName:String;
//			if(type == Slider.THICK_SKIN)
//			{
//				assetName = "VSlider_ThickSkin";
//			}
//			else if(type == Slider.THIN_SKIN)
//			{
//				assetName = "VSlider_ThinSkin";
//			}
//			var sourceUI:MovieClip = ZHLoader.getInstance().getMovieClipByName(assetName);
			upButton = sourceUI.getChildByName("upButton") as SimpleButton ;
			downButton = sourceUI.getChildByName("downButton") as SimpleButton ;
			
			trace("upButton:"+upButton);
			trace("downButton:"+downButton);
		}
		/**
		 * 初始化滑动条默认高宽
		 */
		protected function initSetting():void
		{
			trace("slider from initSetting:"+slider);
			trace("DisplayObject(slider):"+DisplayObject(slider));
			
			defaultWidth = Math.max(DisplayObject(slider).width, upButton.width);
			defaultHeight = 100;
		}
		/**
		 * 创建
		 */
		protected function build():void
		{
			_width = defaultWidth;
			_height = defaultHeight;
			createOptionButton();
			validate();
			createUpdateTimer();
			addHandlers();
		}
		/**
		 * 组合创建一个滑动条
		 */
		protected function createSlider():void
		{
			slider = new VScrollSlider(sourceUI);
			addChild(DisplayObject(slider));
			trace("addSlider:"+slider);
		}
		/**
		 * 给上下箭头、滑动条布局
		 */
		protected function layout():void
		{
			var slider:DisplayObject = DisplayObject(slider);
			slider.y = upButton.height;
			slider.height = height - upButton.height - downButton.height;
			downButton.y = height - downButton.height;
			// 居中
			upButton.x = (_width - upButton.width) / 2;
			downButton.x = (_width - downButton.width) / 2;
			slider.x = (_width - slider.width) / 2;
		}
		//==========================================================================
		//  Private methods
		//==========================================================================
		/**
		 * 创建上下箭头
		 */
		private function createOptionButton():void
		{
			upButton.x = downButton.x = 0;
			upButton.y = downButton.y = 0;
			addChild(upButton);
			addChild(downButton);
		}
		/**
		 * 向上滑动滑动条一个步长
		 */
		private function sliderUp():void
		{
			slider.value -= stepValue;
		}
		/**
		 * 向下滑动滑动条一个步长
		 */
		private function sliderDown():void
		{
			slider.value += stepValue;
		}
		/**
		 * 滑动条机制生效
		 */
		private function validate():void
		{
			layout();
		}
		/**
		 * 创建定时器
		 */
		private function createUpdateTimer():void
		{
			sliderUpTimer = new Timer(UPDATA_DELAY_TIME);
			sliderDownTimer = new Timer(UPDATA_DELAY_TIME);
		}
		/**
		 * 事件绑定
		 */
		private function addHandlers():void
		{
			downButton.addEventListener(MouseEvent.MOUSE_DOWN, silderDownHandler);
			upButton.addEventListener(MouseEvent.MOUSE_DOWN, sliderUpHandler);
			sliderUpTimer.addEventListener(TimerEvent.TIMER, sliderUpRepeatHandler);
			sliderDownTimer.addEventListener(TimerEvent.TIMER, sliderDownRepeatHandler);
			DisplayObject(slider).addEventListener(Event.CHANGE, sliderChangeHandler);
		}
		/**
		 * 取消事件绑定
		 */
		private function removeHandlers():void
		{
			downButton.removeEventListener(MouseEvent.MOUSE_DOWN, silderDownHandler);
			upButton.removeEventListener(MouseEvent.MOUSE_DOWN, sliderUpHandler);
			sliderUpTimer.removeEventListener(TimerEvent.TIMER, sliderUpRepeatHandler);
			sliderDownTimer.removeEventListener(TimerEvent.TIMER, sliderDownRepeatHandler);
			DisplayObject(slider).removeEventListener(Event.CHANGE, sliderChangeHandler);
		}
		/**
		 * 鼠标弹起回调
		 */
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			sliderUpTimer.stop();
			sliderDownTimer.stop();
		}
		/**
		 * 按下向上箭头回调
		 */
		private function sliderUpHandler(event:MouseEvent):void
		{
			sliderUp();
			sliderUpTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		/**
		 * 按下向下箭头回调
		 */
		private function silderDownHandler(event:MouseEvent):void
		{
			sliderDown();
			sliderDownTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		/**
		 * 持续按下向上箭头，定时器出发的回调
		 */
		private function sliderUpRepeatHandler(event:TimerEvent):void
		{
			sliderUp();
		}
		/**
		 * 持续按下向下箭头，定时器出发的回调
		 */
		private function sliderDownRepeatHandler(event:TimerEvent):void
		{
			sliderDown();
		}
		/**
		 * 滑动条的值改变回调
		 */
		private function sliderChangeHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
