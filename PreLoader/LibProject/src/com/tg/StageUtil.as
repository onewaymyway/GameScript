package com.tg
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class StageUtil
	{
		// v1
		// 根据孙晓婕屏幕大小和启用浏览器后，剩余显示区域，推导出如下结论
		// 通常情况下，全屏时，其可用显示区域为1023 * 639（QQ截图后，得出）
		// 因此加入部分省略和考虑部分工具条、插件会额外占用显示空间
		// 特此约定《说唐》显示最小区域为1000 * 600
		// 根据项目初始时得出的结论，《说唐》显示最大区域为1500 * 900
		
		// v2
		// 根据浏览器特点和各个游戏平台特点，修改最小区域为980 * 560
		// 如37wan
		
		// ----- 舞台高宽常量
		/** 主舞台最小宽度 */
		//public static const minStageWidth:int = 1000;
		public static const minStageWidth:int = 980;
		/** 主舞台最小高度 */
		//public static const minStageHeight:int = 600;
		public static const minStageHeight:int = 560;
		/** 主舞台最大宽度 */
		public static const maxStageWidth:int = 1500;
		/** 主舞台最大高度 */
		public static const maxStageHeight:int = 900;
		
		// ----- 舞台
		private static var _stage:Stage;
		
		
		/**
		 * 初始注册函数
		 * @param stage	主舞台
		 * @param type	模式
		 */
		public static function regist(stage:Stage, type:String = "debug"):void
		{
			StageUtil._stage = stage;
			StageUtil.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
		}
		
		private static function resize(ev:Event):void
		{

		}
		
		// the methods below are bean's properties.
		
		/** 主舞台 */
		public static function get stage():Stage
		{
			return _stage;
		}
		
		/** 主舞台宽度 */
		public static function get stageWidth():int
		{
			return _stage.stageWidth;
		}
		
		/** 主舞台高度 */
		public static function get stageHeight():int
		{
			return _stage.stageHeight;
		}
		
		public static function get adjustedStageWidth():int
		{
			var value:int = _stage.stageWidth;
			
			if(value > maxStageWidth)
			{value = maxStageWidth;}
			else if(value < minStageWidth)
			{value = minStageWidth;}
			
			return value;
		}
		public static function get adjustedStageHeight():int
		{
			var value:int = _stage.stageHeight;
			
			if(value > maxStageHeight)
			{value = maxStageHeight;}
			else if(value < minStageHeight)
			{value = minStageHeight}
			
			return value;
		}
		
		public static function get offsetX():int
		{
			if(_stage.stageWidth > maxStageWidth) 
				return (_stage.stageWidth - maxStageWidth) / 2;
			else 
				return 0;
		}
		
		public static function get offsetY():int
		{
			if(_stage.stageHeight > maxStageHeight)
				return (_stage.stageHeight - maxStageHeight) / 2;
			else
				return 0;
		}
		
		/**
		 * 将显示对象移到屏幕右侧边缘 
		 * @param dis
		 * @param d 右侧边距
		 * 
		 */
		public static function setDisRight(dis:DisplayObject,d:Number=10):void
		{
//		        dis.x=adjustedStageWidth-dis.width-d;
				setDisGlobalX(dis,adjustedStageWidth-dis.width-d);
		}
		/**
		 * 将显示对象移到屏幕右侧边缘 
		 * @param dis
		 * @param d 右侧边距
		 * 
		 */
		public static function setDisRightK(dis:DisplayObject,d:Number=10):void
		{
			//		        dis.x=adjustedStageWidth-dis.width-d;
			var rec:Rectangle;
			rec=dis.getBounds(dis);
			setDisGlobalX(dis,adjustedStageWidth-rec.width-d-rec.x);
		}
		/**
		 * 将显示对象移到屏幕左侧边缘 
		 * @param dis
		 * @param d 左侧边距
		 * 
		 */
		public static function setDisLeft(dis:DisplayObject,d:Number=10):void
		{
			//		        dis.x=adjustedStageWidth-dis.width-d;
			setDisGlobalX(dis,d);
		}

		/**
		 * 设置对象在程序显示区域的x坐标
		 * @param dis
		 * @param x
		 * 
		 */
		public static function setDisGlobalX(dis:DisplayObject,x:Number):void
		{
			var tParent:DisplayObjectContainer;
			var tPoint:Point;
			tPoint=new Point;
			if(dis) tParent=dis.parent;
			tPoint.x=x;
			if(tParent)
			{
				
				tPoint=tParent.globalToLocal(tPoint);
			}
			dis.x=tPoint.x+offsetX;
//			trace("offsetX:"+offsetX);
		}
		
		/**
		 * 设置对象在程序显示区域的y坐标
		 * @param dis
		 * @param y
		 * 
		 */
		public static function setDisGlobalY(dis:DisplayObject,y:Number):void
		{
			var tParent:DisplayObjectContainer;
			var tPoint:Point;
			tPoint=new Point;
			if(dis) tParent=dis.parent;
			tPoint.y=y;
			if(tParent)
			{				
				tPoint=tParent.globalToLocal(tPoint);
			}
			dis.y=tPoint.y+offsetY;
//			trace("offsetY:"+offsetY);
		}
		/**
		 * 将显示对象移到屏幕下方边缘 
		 * @param dis
		 * @param dy 下侧边距
		 * 
		 */
		public static function setDisBottom(dis:DisplayObject,d:Number=20):void
		{
//			dis.y=adjustedStageHeight-dis.height-d;	
			setDisGlobalY(dis,adjustedStageHeight-dis.height-d);
		}
		
		public static function setDisBottomK(dis:DisplayObject,d:Number=0):void
		{
			//			dis.x=(adjustedStageWidth-dis.width)*0.5-d;
			var rec:Rectangle;
			rec=dis.getBounds(dis);
			
			setDisGlobalX(dis,adjustedStageHeight-rec.height-d-rec.x);
			//			trace("setDisVCenter: setDisVCenter:"+dis.width +" adjustedStageWidth:"+adjustedStageWidth + "offsetX："+offsetX);
		}
		/**
		 * 将显示对象移到屏幕上方边缘 
		 * @param dis
		 * @param dy 上侧边距
		 * 
		 */
		public static function setDisTop(dis:DisplayObject,d:Number=20):void
		{
			setDisGlobalY(dis,d);
		}
		/**
		 * 将对象移到屏幕水平中央
		 * @param dis
		 * @param d 离中心边距
		 * 
		 */
		public static function setDisVCenter(dis:DisplayObject,d:Number=0):void
		{
//			dis.x=(adjustedStageWidth-dis.width)*0.5-d;
			setDisGlobalX(dis,(adjustedStageWidth-dis.width)*0.5-d);
//			trace("setDisVCenter: setDisVCenter:"+dis.width +" adjustedStageWidth:"+adjustedStageWidth + "offsetX："+offsetX);
		}
		/**
		 * 将对象移到屏幕水平中央
		 * @param dis
		 * @param d 离中心边距
		 * 
		 */
		public static function setDisVCenterK(dis:DisplayObject,d:Number=0):void
		{
			//			dis.x=(adjustedStageWidth-dis.width)*0.5-d;
			var rec:Rectangle;
			rec=dis.getBounds(dis);
			
			setDisGlobalX(dis,(adjustedStageWidth-rec.width)*0.5-d-rec.x);
			//			trace("setDisVCenter: setDisVCenter:"+dis.width +" adjustedStageWidth:"+adjustedStageWidth + "offsetX："+offsetX);
		}
		
		/**
		 * 将对象移到屏幕垂直中央
		 * @param dis
		 * @param d 离中心边距
		 * 
		 */
		public static function setDisHCenter(dis:DisplayObject,d:Number=0):void
		{
//			dis.y=(adjustedStageHeight-dis.height)*0.5-d;
			setDisGlobalY(dis,(adjustedStageHeight-dis.height)*0.5-d);
		}
		public static function setDisHCenterK(dis:DisplayObject,d:Number=0):void
		{
			var rec:Rectangle;
			rec=dis.getBounds(dis);
			setDisGlobalY(dis,(adjustedStageHeight-rec.height)*0.5-d-rec.y);
		}
	}
}