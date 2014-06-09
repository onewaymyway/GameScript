package com.tg.Tools
{
	import com.tg.Tools.Effect.IParamEffect;
	import com.tg.file.File;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * 播放swf动画特效类，swf中的特效类链接为Effect
	 * @author ww
	 * 
	 */
	public class SwfEffectPlayTools
	{
		public function SwfEffectPlayTools()
		{
		}
		
		/**
		 * 默认放置动画特效路径 
		 */
		public static const Effect_Path:String="avatar/effect/";
		
		/**
		 * 播放放在默认路径的动画特效资源 
		 * swf中的特效类链接为Effect
		 * @param effectName 动画名
		 * 
		 */
		public static function playSwfEffectS(effectName:String):void
		{
			playSwfEffect(Effect_Path+effectName+".swf");
		}
		/**
		 * 播放任意路径下的动画特效资源 
		 * swf中的特效类链接为Effect
		 * @param url
		 * 
		 */
		public static function playSwfEffect(url:String):void
		{
			File.loadList([url],fileLoaded);
		}
		
		private static function fileLoaded(fileList:Array):void
		{
			
			var tFile:File;
			tFile=fileList[0];
			var claz:Class;
			claz=tFile.getClassByName("Effect");
			
			var mc:MovieClip;
			mc=new claz() as MovieClip;
			if(mc)
			{
				MCEffectPlayTools.playMCEffect(mc);
			}
		}
		
		/**
		 * 播放带参数的特效 
		 * @param effectName
		 * @param data
		 * 
		 */
		public static function playSwfParamedEffect(effectName:String,data:Object):void
		{
			var playTool:SwfEffectPlayTools;
			playTool=new SwfEffectPlayTools();
			playTool.playSwfParamEffect(effectName,data);
		}
		
		private var fileName:String;
		private var param:Object;
		private var backFun:Function;
		public function playSwfParamEffect(effectName:String,data:Object):void
		{
			fileName=effectName;
			param=data;
			File.loadList([Effect_Path+fileName+".swf"],myFileLoaded);
		}
		
		private  function myFileLoaded(fileList:Array):void
		{
			
			var tFile:File;
			tFile=fileList[0];
			var claz:Class;
			claz=tFile.getClassByName("com.tg.st.Effect."+fileName);
			
//			var mc:MovieClip;
//			mc=new claz() as MovieClip;
			
			var mcI:IParamEffect;
			mcI=new claz()
			if(mcI)
			{
				mcI.playEffect(param,playEnd);
			}
		}
		
		private function playEnd():void
		{
			if(backFun!=null)
			{
				backFun();
			}
			backFun=null;
		}
		/**
		 * 播放自定义坐标和容器的特效 
		 * @param effectName 特效名
		 * @param dx 相对于默认排版的偏移坐标x
		 * @param dy 相对于默认排版的偏移坐标y
		 * @param backFun 播放完成后的回调
		 * @param target 要播放的容器 默认在特效层播放
		 * @param autoRemove 播放完之后是否自动移除，如不自动移除将停在最后一帧
		 * 
		 */
		public static function playSwfPosedEffect(effectName:String,dx:Number=0,dy:Number=0,backFun:Function=null,target:DisplayObjectContainer=null,autoRemove:Boolean=true):void
		{
			var playTool:SwfEffectPlayTools;
			playTool=new SwfEffectPlayTools();
			playTool.playSwfPosEffect(effectName,dx,dy,backFun,target,autoRemove);
		}
		public function playSwfPosEffect(effectName:String,dx:Number=0,dy:Number=0,backFun:Function=null,target:DisplayObjectContainer=null,autoRemove:Boolean=true):void
		{
			param={};
			param.dx=dx;
			param.dy=dy;
			param.target=target;
			param.autoRemove=autoRemove;
			this.backFun=backFun;
			File.loadList([Effect_Path+fileName+".swf"],posedFileLoaded);
		}
		private  function posedFileLoaded(fileList:Array):void
		{
			
			var tFile:File;
			tFile=fileList[0];
			var claz:Class;
			claz=tFile.getClassByName("Effect");
			
			var mc:MovieClip;
			mc=new claz() as MovieClip;
			if(mc)
			{
				MCEffectPlayTools.playMCEffect(mc,playEnd,param.target,param.dx,param.dy,param.autoRemove);
			}
		}
	}
}