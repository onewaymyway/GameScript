package com.tg.Tools
{
	import com.tg.file.File;
	
	import flash.utils.Dictionary;

	public class SWFResLoadTools
	{
		
		/**
		 * 默认放置资源路径 
		 */
		public static const Res_Path:String="asset/res/";
		/**
		 * 资源默认类名前缀 
		 */
		public static const ClassPreFix:String="com.tg.st.SwfRes.";
		
		
		
		public function SWFResLoadTools(fileName:String,className:String,callBack:Function)
		{
			this.fileName=fileName;
			this.className=className;
			this.callBack=callBack;
		}
		
		/**
		 * 已加载文件缓存 
		 */
		public static var fileDic:Dictionary=new Dictionary();
		/**
		 * 获取swf中的资源
		 * @param fileName 除.swf之外的完整路径
		 * @param className 完整的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getRes(fileName:String,className:String,callBack:Function,progressFun:Function=null):void
		{
			if(!fileDic[fileName])
			{
				var tLoad:SWFResLoadTools;
				tLoad=new SWFResLoadTools(fileName,className,callBack);
				tLoad.load();
			}else
			{
				var tFile:File;
				tFile=fileDic[fileName];
				tFile.onProgress=progressFun;
				var claz:Class;
				claz=tFile.getClassByName(className);			
				var mc:*;
				mc=new claz();
				callBack(mc);
			}
		}
		


		/**
		 * 获取默认资源文件夹中默认类包里的资源 
		 * @param fileName 除.swf之外的文件名
		 * @param className 简单的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getResSS(fileName:String,className:String,callBack:Function,progressFun:Function=null):void
		{
			getRes(Res_Path+fileName,ClassPreFix+className,callBack,progressFun);
		}
		
		/**
		 * 获取默认资源文件夹中类资源 
		 * @param fileName 除.swf之外的文件名
		 * @param className 完整的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getResSN(fileName:String,className:String,callBack:Function,progressFun:Function=null):void
		{
			getRes(Res_Path+fileName,className,callBack,progressFun);
		}
		
		
		/**
		 * 获取已预加载的swf中的资源
		 * @param fileName 除.swf之外的完整路径
		 * @param className 完整的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getSure(fileName:String,className:String):*
		{
			var tFile:File;
			tFile=fileDic[fileName];
			var claz:Class;
			claz=tFile.getClassByName(className);			
			var mc:*;
			mc=new claz();
			return mc;
		}
		/**
		 * 获取已预加载的默认资源文件夹中默认类包里的资源 
		 * @param fileName 除.swf之外的文件名
		 * @param className 简单的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getSureSS(fileName:String,className:String):*
		{
			return getSure(Res_Path+fileName,ClassPreFix+className);
		}
		/**
		 * 获取已预加载的默认资源文件夹中类资源 
		 * @param fileName 除.swf之外的文件名
		 * @param className 完整的类名
		 * @param callBack
		 * @param progressFun
		 * 
		 */
		public static function getSureSN(fileName:String,className:String):*
		{
			return getSure(Res_Path+fileName,className);
		}
		
		
		
		private var fileName:String;
		private var className:String;
		private var callBack:Function;
		
		public function load():void
		{
			File.loadList([fileName+".swf"],myFileLoaded);
		}
		private  function myFileLoaded(fileList:Array):void
		{
			
			var tFile:File;
			tFile=fileList[0];
			fileDic[fileName]=tFile;
			tFile.onProgress=null;
			var claz:Class;
			claz=tFile.getClassByName(className);
			
			var mc:*;
			mc=new claz()
			callBack(mc);
		}
	}
}