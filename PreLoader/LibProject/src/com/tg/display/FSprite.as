package com.tg.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	/**
	 * 显示类的基类
	 * <br/>
	 * 实现垃圾回收
	 * <br/>
	 * 实现精确点击——空白区域不支持鼠标事件
	 * 
	 */
	public class FSprite extends Sprite
	{
		/**添加事件的存放*/
		private var _functions:Object;
		/**是否需要精确点击*/
		private var _exactClick:Boolean = false;
		/**临时缓存数据*/
		private var _cacheData:Object;

		/**Class
		 * this.constructor
		 * */ /**
		 * 构造方法
		 */
		public function FSprite()
		{
			_functions = new Object();
			super();
		}

		/**
		 * 重写系统的addEventListener
		 * @param type				事件类型
		 * @param listener			时间执行方法
		 * @param useCapture		是否在冒泡阶段捕获
		 * @param priority			事件执行顺序
		 * @param useWeakReference	是否为弱引用
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (_functions[type] == undefined)
				_functions[type] = [];
			_functions[type].push(listener);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			return;
		}

		/**
		 * 重写系统的 removeEventListener
		 * @param type				事件类型
		 * @param listener			事件执行方法
		 * @param useCapture		是否在冒泡阶段捕获
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_functions[type] != undefined)
			{
				var index:int = _functions[type].indexOf(listener);
				if (index != -1)
				{
					_functions[type].splice(index, 1);
				}
			}
			super.removeEventListener(type, listener, useCapture);
			return;
		}

		/**
		 * 移除该对象所有时间监听
		 */
		public function removeAllEventListener():void
		{
			for (var type:*in _functions)
			{
				for each (var fun:Function in _functions[type])
					super.removeEventListener(type, fun);
			}
			return;
		}

		/**
		 * 根据名称移除显示对象 并返回该对象
		 * @p	name	显示对象名称
		 * */
		public function removeChildByName(name:String):DisplayObject
		{
			try
			{
				var dis:DisplayObject = getChildByName(name);
				if (dis)
					return removeChild(dis);
			}
			catch (e:Error)
			{
			}
			return null;
		}

		/**
		 * 清理该对象内的所有资源。并释放。
		 */
		public function clean():void
		{
			cacheData = null;
			removeAllEventListener();
			_functions = null;
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:* = getChildAt(i);
				if (child is FSprite)
				{
					child.clean();
				}
				else if (child is Bitmap)
				{
					if (child.bitmapData)
						child.bitmapData.dispose();
				}
				this.removeChildAt(i);
			}
			return;
		}

		/**
		 * 获得当前类是否是精确点击对象
		 * @return boolean
		 */
		public function get exactClick():Boolean
		{
			return this._exactClick;
		}

		/**
		 * 设置当前对象为精确对象。空白区域不会支持鼠标事件。对webgame有相当大的作用。
		 * @param value
		 */
		public function set exactClick(value:Boolean):void
		{
			this._exactClick = value;
			_openOrCloseExactClick();
		}

		private function _openOrCloseExactClick():void
		{
			if (_exactClick)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, _over);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, _over);
			}
		}

		private function _over(e:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, _enterFrame);
			e.stopPropagation();
		}

		private function _enterFrame(e:Event):void
		{
			if (this.mouseX < -width || mouseX > width || this.mouseY < -height || this.mouseY > height)
			{
				this.removeEventListener(Event.ENTER_FRAME, _enterFrame);
				this.mouseEnabled = true;
				this.mouseChildren = true;
				return;
			}

			if (checkClick(this))
			{
				this.mouseEnabled = true;
				this.mouseChildren = true;
			}
			else
			{
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}

		}

		private var matrix:Matrix = new Matrix();

		private var bmd:BitmapData = new BitmapData(1, 1);

		private function checkClick(target:FSprite):Boolean
		{
			if (!stage)
			{
				removeEventListener(Event.ENTER_FRAME, _enterFrame);
				return true;
			}
			matrix.tx = -target.mouseX;
			matrix.ty = -target.mouseY;
			bmd.setPixel32(0, 0, 0);
			bmd.draw(target, matrix);

			if (bmd.getPixel32(0, 0) == 0)
//				if (target.hitTestPoint(stage.mouseX, stage.mouseY, true))
					return false;
			return true;
		}

		/**
		 * 获得缓存数据 
		 * @return 
		 */
		public function get cacheData():Object 
		{
			return _cacheData;
		}
		
		/**
		 * 设置零时缓存对象
		 * @param value
		 */
		public function set cacheData(value:Object):void
		{
			_cacheData = value;
		}
	}
}