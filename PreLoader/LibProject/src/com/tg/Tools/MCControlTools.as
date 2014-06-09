package com.tg.Tools
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;

	/**
	 * mc播放控制类 
	 * @author ww
	 * 
	 */
	public class MCControlTools
	{
		public function MCControlTools()
		{
		}
		
		/**
		 * 播放一个MC中的所有MC
		 * @param MCContainer
		 * 
		 */
	    public static  function playAllMC(MCContainer:DisplayObjectContainer,isPlay:Boolean=true):void
		{
			if(!MCContainer) return;
			var tMC:MovieClip;
			var num:int;
			num=MCContainer.numChildren;
			var i:int;
			var tChild:*;
			for(i=0;i<num;i++)
			{
				tChild=MCContainer.getChildAt(i);
				if(tChild&&(tChild is MovieClip))
				{
					tMC=tChild as MovieClip;
					if(isPlay)
					{
						tMC.gotoAndPlay(1);
					}
					else
					{
						tMC.gotoAndStop(1);
					}
					
				}
			}
		}
		
		/**
		 * 从任意位置开始播放，然后在某帧停止 
		 * @param mc 
		 * @param stopFrame 要挺的帧
		 * @param callBack 完成后的回调
		 * @param rate 帧率
		 * @param round 完整播放多少次
		 * 
		 */
		public static function playRandomAndStopAt(mc:MovieClip,stopFrame:int,callBack:Function=null,rate:int=24,round:int=1):void
		{
			var i:int;
			var dTime:int;
			dTime=1000/rate;
			var tFrame:int;
			var total:int;
			total=mc.totalFrames;
			i=total*Math.random();
			mc.gotoAndStop(1);
//			trace("mc.totalFrames:"+mc.totalFrames);
			stopFrame+=round*mc.totalFrames;
			playMC();
			function playMC():void
			{
				i++;
				
				if((i<=stopFrame)/*&&(i<mc.totalFrames)*/)
				{
					tFrame=((i-1)%total)+1;
					mc.gotoAndStop(tFrame);
					setTimeout(playMC,dTime);
				}else
				{
					mc=null;
					if(callBack!=null)
					{
						callBack();
						callBack=null;
					}
				}
			}
		}
		
		/**
		 * 从第一帧开始播放并停止在某一帧 
		 * @param mc
		 * @param stopFrame
		 * @param callBack
		 * @param rate
		 * @param round
		 * 
		 */
		public static function playAndStopAt(mc:MovieClip,stopFrame:int,callBack:Function=null,rate:int=24,round:int=0):void
		{
			var i:int=0;
			var dTime:int;
			dTime=1000/rate;
			var tFrame:int;
			mc.gotoAndStop(1);
			var total:int;
			total=mc.totalFrames;
//			trace("mc.totalFrames:"+mc.totalFrames);
			stopFrame+=round*mc.totalFrames;
			playMC();
			function playMC():void
			{
				i++;
				
				if((i<=stopFrame)&&(i<mc.totalFrames))
				{
					tFrame=((i-1)%total)+1;
					mc.gotoAndStop(tFrame);
					setTimeout(playMC,dTime);
				}else
				{
					mc=null;
					if(callBack!=null)
					{
						callBack();
						callBack=null;
					}
				}
			}
		}
		
		public static function addMCEndFun(mc:MovieClip,backFun:Function):void
		{
			mc.addFrameScript(mc.totalFrames-1,backFun);
		}
	}
}