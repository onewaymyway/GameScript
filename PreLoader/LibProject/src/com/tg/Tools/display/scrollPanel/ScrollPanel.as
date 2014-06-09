package com.tg.Tools.display.scrollPanel
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.Tools.display.scrollbar.ScrollBar;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 带滚动条的显示区域面板
	 * @author luli & ww
	 * 
	 * 使用样例
	 * 
//    	**
//		 * 滚动区域组件
//		 *
		private var scrollPanel:ScrollPanel;
		
//		**
//		 * 要滚动的容器
//		 *
		private var container:Sprite;
		 * 
		 * 
 		container=new Sprite;
		this.addChild(container);

		//初始化滚动区域组件
		scrollPanel=new ScrollPanel(
			163,//滚动区域宽
			151,//滚动区域高
			scrollSource//滚动条使用的UI资源MovieClip
		);
		//滚动区域的x坐标
		scrollPanel.x=startX;
		//滚动区域的y坐标
		scrollPanel.y=startY;

		this.addChild(scrollPanel);
		 * 
		 * 
			//设置滚动区域要滚动的内容
			scrollPanel.setContent(container);
			 * 
			 * 
	 */
	public class ScrollPanel extends Sprite
	{
		//==========================================================================
		//  Constructor
		//==========================================================================
//		/**
//		 * 创建一个带滚动条显示区域的面板
//		 * @param width 面板宽度
//		 * @param height 面板高度
//		 * @param type 面板样式类型,目前只有两种Slider.THICK_SKIN  Slider.THIN_SKIN
//		 */
		/**
		 *  
		 * 创建一个带滚动条显示区域的面板
		 * @param width 面板宽度
		 * @param height 面板高度
		 * @param sourceUI 滚动条使用的UI资源
		 * 需包含以下元素
		 * upButton：simpleButton 向上按钮
		 * downButton：simpleButton 向下按钮
		 * thumb：MovieClip 拖动块
		 * sliderBack：MovieClip 滚动条背景
		 * 
		 * 
		 */
		public function ScrollPanel(width:Number, height:Number, sourceUI:MovieClip)
		{
			this.sourceUI=sourceUI;
//			_type = type;
			_width = width;
			_height = height;
			build();
		}
		//==========================================================================
		//  Variables
		//==========================================================================
		private var sourceUI:MovieClip;
		/**
		 * 滚动条
		 */
		public var vscrollBar:ScrollBar;
		/**
		 * 被遮罩对象容器
		 */
		private var contentContainer:Sprite;
		/**
		 * 遮罩
		 */
		private var contentMask:Sprite;
		/**
		 * 透明背景层，做鼠标热区使用
		 */
		private var back:Sprite;
		/**
		 * 显示内容和面板的上边距
		 */
		private var padding_top:uint = 0;
		/**
		 * 显示内容和面板的右边距
		 */
		private var padding_right:uint = 0;
		/**
		 * 显示内容和面板的下边距
		 */
		private var padding_bottom:uint = 0;
		/**
		 * 显示内容和面板的左边距
		 */
		private var padding_left:uint = 0;
		//==========================================================================
		//  Overridden properties: DisplayObject
		//==========================================================================
		//----------------------------------
		//  width
		//----------------------------------
		private var _width:Number;
		/**
		 * 获取面板宽度，包含padding，包含滚动条宽度
		 */
		override public function get width():Number
		{
			return _width;
		}
		/**
		 * 设置面板的宽度，包含padding，包含滚动条宽度
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
		 * 获取面板的高度，包含padding
		 */
		override public function get height():Number
		{
			return _height;
		}
		/**
		 * 设置面板的高度，包含padding
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
		 * 获取面板类型,目前只有两种Slider.THICK_SKIN  Slider.THIN_SKIN
		 */
		public function get type():String
		{
			return _type;
		}
		//----------------------------------
		//  content
		//----------------------------------
		private var _content:DisplayObject;
		/**
		 * 获取被遮罩的内容对象
		 */
		public function get content():DisplayObject
		{
			return _content;
		}
		//----------------------------------
		//  step
		//----------------------------------
		/**
		 * 设置方向箭头每次移动的距离，默认一次移动遮罩区域的一屏
		 * @param value 移动步长，单位像素
		 */
		public function set step(value:Number):void
		{
			// 把像素值转化为scrollBar内部的步长值
			vscrollBar.stepValue = value / (contentContainer.height - contentMask.height);
		}
		//----------------------------------
		//  padding
		//----------------------------------
		/**
		 * 设置显示内容与面板的上、右、下、左四方向边距
		 * @param value 四方向边距以数组形式传入
		 */
		public function set padding(value:Array):void
		{
			padding_top = value[0];
			padding_right = value[1];
			padding_bottom = value[2];
			padding_left = value[3];
			validate();
		}
		//----------------------------------
		//  scrollBarWidth
		//----------------------------------
		/**
		 * 返回滚动条宽度
		 */
		public function get scrollBarWidth():Number
		{
			return vscrollBar.width;
		}
		//----------------------------------
		//  contentAreaWidth
		//----------------------------------
		/**
		 * 返回内容区域最大宽度，不包含滚动条宽度，内容区域左右间距
		 */
		public function get contentAreaWidth():Number
		{
			return _width - vscrollBar.width - padding_left - padding_right;
		}
		//----------------------------------
		//  contentAreaHeight
		//----------------------------------
		/**
		 * 返回内容区域最大高度，不包含内容区域上下间距
		 */
		public function get contentAreaHeight():Number
		{
			return _height - padding_top - padding_bottom;
		}
		//----------------------------------
		//  contentScrollDistanceY
		//----------------------------------
		/**
		 * 获取内容区域Y轴方向当前的滚动距离
		 */
		public function get contentScrollDistanceY():Number 
		{
			return padding_top - contentContainer.y;
		}
		//==========================================================================
		//  Public methods
		//==========================================================================
		/**
		 * 设置目标遮罩区域的内容对象
		 * @param content 遮罩区域的可视对象 
		 * @param keepPosition 是否保持内容区域当前显示位置，设为false会自动定位到顶端
		 */
		public function setContent(content:DisplayObject, keepPosition:Boolean = true):void
		{
			var prevContentScrollDistanceY:Number = contentScrollDistanceY;
			_content = content;
			cleanContent();
			addContent(_content);
			validate();
			if(keepPosition)
			{
				scrollToPosition(prevContentScrollDistanceY);
			}
		}
		/**
		 * 内容滚动到最顶端
		 */
		public function scrollToTop():void
		{
			vscrollBar.value = 0;
		}
		/**
		 * 内容滚动到最底端
		 */
		public function scrollToBottom():void
		{
			vscrollBar.value = 1;
		}
		/**
		 * 内容滚动到指定的位置
		 */
		public function scrollToPosition(value:Number):void
		{
			if(!needScroll()) value = 0;
			contentContainer.y = -value + padding_top;
			var v:Number = value / (contentContainer.height - contentAreaHeight);
			// TODO 浮点数误差 Slider的formatValue是否要取消
			vscrollBar.value = v;
		}
		/**
		 * 销毁
		 */
		public function destroy():void
		{
			removeHandlers();
			vscrollBar.destory();
		}
		//==========================================================================
		//  Private methods
		//==========================================================================
		/**
		 * 初始化创建
		 */
		private function build():void
		{
			createBack();
			createContentContainer();
			createScrollBar();
			createMask();
			addHandlers();
			validate();
		}
		/**
		 * 创建内容容器
		 */
		private function createContentContainer():void
		{
			contentContainer = new Sprite();
			addChild(contentContainer);
		}
		/**
		 * 创建可伸缩的滚动条
		 */
		private function createScrollBar():void
		{
			vscrollBar = new ScrollBar(this.sourceUI);
			vscrollBar.x = width - vscrollBar.width;
			vscrollBar.height = height;
			vscrollBar.enable = false;
			addChild(vscrollBar);
			trace("vscrollBar from scrollPanel createScrollBar:"+vscrollBar);
		}
		/**
		 * 创建遮罩
		 */
		private function createMask():void
		{
			contentMask = new Sprite();
			var g:Graphics = contentMask.graphics;
			g.clear();
			g.beginFill(0xff6600);
			g.drawRect(0, 0, width - vscrollBar.width, height);
			g.endFill();
			addChild(contentMask);
			contentContainer.mask = contentMask;
		}
		/**
		 * 创建透明背景，固定热区
		 */
		private function createBack():void
		{
			back = new Sprite();
			back.graphics.beginFill(0xff0000, 0);
			back.graphics.drawRect(0, 0, 100, 100);
			back.graphics.endFill();
			addChild(back);
		}
		/**
		 * 添加被遮罩可视对象到面板中
		 */
		private function addContent(content:DisplayObject):void
		{
			contentContainer.addChild(content);
		}
		/**
		 * 清除被遮罩区域的内容
		 */
		private function cleanContent():void
		{
			DisplayUtil.clean(contentContainer);
		}
		/**
		 * 当前内容高度是否需要显示滚动条
		 */
		private function needScroll():Boolean
		{
			return contentAreaHeight < contentContainer.height;
		}
		/**
		 * 滚动机制生效
		 */
		private function validate():void
		{
			back.height = _height;
			back.width = _width;
			contentContainer.x =  padding_left;
			contentContainer.y =  padding_top;
			contentMask.width = _width;
			contentMask.height = _height;
			if(!needScroll())
			{
				vscrollBar.enable = false;
				vscrollBar.visible = false;
				return;
			}
			vscrollBar.enable = true;
			vscrollBar.visible = true;
			vscrollBar.thumbScale = contentAreaHeight / contentContainer.height;
			vscrollBar.height = _height;
			vscrollBar.x = width - vscrollBar.width;
			// 默认一次滚动1/3屏
			step = contentAreaHeight / 3;
			vscrollBar.value = 0;
		}
		/**
		 * 事件绑定
		 */
		private function addHandlers():void
		{
			vscrollBar.addEventListener(Event.CHANGE, scrollChangeHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, panel_mouseWheelHandler);
		}
		/**
		 * 取消事件绑定
		 */
		private function removeHandlers():void 
		{
			vscrollBar.removeEventListener(Event.CHANGE, scrollChangeHandler);
			removeEventListener(MouseEvent.MOUSE_WHEEL, panel_mouseWheelHandler);
		}
		//==========================================================================
		//  Event handlers
		//==========================================================================
		/**
		 * 滚动条事件回调
		 */
		private function scrollChangeHandler(event:Event):void
		{
			if(contentContainer.height > contentAreaHeight)
			{
				contentContainer.y = padding_top - (contentContainer.height - contentAreaHeight) * vscrollBar.value;
			}
		}
		/**
		 * 面板上鼠标滚轮事件回调
		 */
		private function panel_mouseWheelHandler(event:MouseEvent):void
		{
			if(event.delta < 0)
			{
				vscrollBar.value += vscrollBar.stepValue;
			}
			else
			{
				vscrollBar.value -= vscrollBar.stepValue;
			}
		}
	}
}
