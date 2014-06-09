package com.tg.Tools
{
	import com.tg.StageUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * 播放mc特效类
	 * @author ww
	 * 
	 */
	public class MCEffectPlayTools
	{
		public function MCEffectPlayTools()
		{
		}
		
		public static var defaultParent:DisplayObjectContainer;
		
		/**
		 * 播放MC特效
		 * 播放完之后自动从父容器删除 
		 * @param mc 要播放的MC
		 * @param backFun 播放完成后的回调
		 * @param parent 要播放MC的父容器，默认在游戏effect层
		 * @param dx MC的x坐标偏移
		 * @param dy MC的y坐标偏移
		 * 
		 */
		public static function playMCEffect(mc:MovieClip,backFun:Function=null,parent:DisplayObjectContainer=null,dx:Number=0,dy:Number=0,autoRemove:Boolean=true):void
		{
			
			if(parent==null)
			{
				parent=defaultParent;
			}
			
			mc.gotoAndStop(1);
			parent.addChild(mc);
			StageUtil.setDisVCenterK(mc);
			StageUtil.setDisHCenter(mc,150);
			mc.x+=dx;
	        mc.y+=dy;	
			trace("playMovieEffect");
			mc.addFrameScript(mc.totalFrames-1,function () : void
			{
				mc.stop();
				if(autoRemove)
				{
					DisplayUtil.selfRemove(mc);
				}
			
				if(backFun!=null)
				{
					backFun();
					backFun=null;
				}
				mc=null;
			});
			
			mc.gotoAndPlay(1);
		}
		
		public static function playMCEffectDefault(mc:MovieClip,backFun:Function=null,ifMove:Boolean=true):void
		{
			mc.gotoAndStop(1);
			DisplayUtil.setMouseEnable(mc,false);
			mc.addFrameScript(mc.totalFrames-1,function () : void
			{
				mc.stop();
				if(ifMove)
				DisplayUtil.selfRemove(mc);
				if(backFun!=null)
				{
					backFun();
					backFun=null;
				}
				mc=null;
			});
			
			mc.gotoAndPlay(1);
		}
		
		public static function addEffect(mc:MovieClip,x:Number=99599,y:Number=99599):void
		{
			defaultParent.addChild(mc);
			DisplayUtil.setMouseEnable(mc,false);
			if(x==99599)
			{
				StageUtil.setDisVCenterK(mc);
			}else
			{
				mc.x=x;
			}
			if(y==99599)
			{
				StageUtil.setDisHCenter(mc,200);
			}else
			{
				mc.y=y;
			}
		}
	}
}