package com.tg.Tools
{
	import com.tg.StageUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	/**
	 * 挡板工具
	 * @author ww
	 * 
	 */
	public class ShadeTools
	{
		public function ShadeTools()
		{

		   tShader=new Sprite();
		   bigRec=new Rectangle(-10,-10,StageUtil.maxStageWidth+20,StageUtil.maxStageHeight+20);
		   
		   StageUtil.stage.addEventListener(Event.RESIZE,resize);

		}
		public static const DefaultAlpha:Number=0.2;
		/**
		 * 显示挡板的容器 
		 */
		public static var tParent:DisplayObjectContainer;
		
		private static var instance:ShadeTools;
		
		private var bigRec:Rectangle;
		public static function me():ShadeTools
		{
			if(!instance) instance=new ShadeTools();
			return instance;
		}
		
		private var tShader:Sprite;
		
		private var tDis:DisplayObject;
		private var tD:Number;
		private var tAlpha:Number;
		/**
		 * 遮挡除了目标之外的其它区域
		 * @param dis 目标
		 * @param d 预留距离
		 * @param alpha 挡板透明度
		 * 
		 */
		public function shadeAllBut(dis:DisplayObject=null,d:Number=5,alpha:Number=DefaultAlpha):void
		{
			tDis=dis;
			tD=d;
			if(!tDis) 
			{
				clearShade();
				return;
			}
			tParent.addChild(tShader);
			var tPoint:Point;
			var tRec:Rectangle;

			tRec=dis.getBounds(tShader);

			tAlpha=alpha;
			tShader.graphics.clear();
			
			tShader.graphics.beginFill(0x000000,alpha);
			tShader.graphics.drawRect(bigRec.x,bigRec.y,bigRec.width,bigRec.height);
			tShader.graphics.drawRoundRect(tRec.x-tD,tRec.y-tD,tRec.width+2*tD,tRec.height+2*tD,20);
			tShader.graphics.endFill();
		}

		
		public var lockScreenFun:Function;
		/**
		 * 锁屏
		 * @param isLock
		 * 
		 */
		public function lockScreen(isLock:Boolean):void
		{
		    if(lockScreenFun!=null)
			{
				lockScreenFun(isLock);
			}	
		}
		/**
		 * 清除挡板
		 * 
		 */
		public function clearShade():void
		{
			DisplayUtil.selfRemove(tShader);
			tDis=null;
		}
		
		/**
		 * 更新挡板
		 * 
		 */
		public function update():void
		{
			if(!tDis)
			{
				clearShade();
				return;
			}
			setTimeout(shadeAllBut,500,tDis,tD,tAlpha);
		}
		/**
		 * 屏幕自适应
		 * @param evt
		 * 
		 */
		private function resize(evt:Event):void
		{
			update();
		}
	}
}