package com.tools
{
	import com.tg.Tools.StringToolsLib;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ClassTools
	{
		public function ClassTools()
		{
		}
		
		/**
		 * 获取显示对象无路径类名 
		 * @param dis 显示对象
		 * @return 类名
		 * 
		 */
		public static function getClassName(dis:DisplayObject):String
		{
			var myName:String;
//			myName=getUnqualifiedClassName(dis);;
			//trace("className:"+myName);
			return myName;
		}
		/**
		 * 获取显示对象的全路径类名  
		 * @param dis 显示对象
		 * @return 类似 packaage::className 格式
		 * 
		 */
		public static function getFullClassName(dis:DisplayObject):String
		{
			var myName:String;
			myName=flash.utils.getQualifiedClassName(dis);
			//trace("classFullName:"+myName);
			//	myName=mx.utils.NameUtil.getUnqualifiedClassName(dis);
			//mx.utils.NameUtil.getUnqualifiedClassName(dis);
			
			//trace("classFullName:"+myName);
			return myName;
		}
		
		/**
		 * 根据对象返回对象的类 
		 * @param dis
		 * @return 
		 * 
		 */
		public static function getClass(dis:*):Class
		{
			var claz:Class;
			claz=(getDefinitionByName(getQualifiedClassName(dis)) as Class);
			return claz;
		}
		
		public static function copyObject(dis:*):*
		{
			var claz:Class;
			claz=(getDefinitionByName(getQualifiedClassName(dis)) as Class);
			return new claz();
		}
		public static function getDefines(dis:DisplayObject):String
		{
			var tDomain:ApplicationDomain;
			tDomain=dis.loaderInfo.applicationDomain;
			trace(tDomain["getQualifiedDefinitionNames"]());
			var rst:String;
			rst=tDomain["getQualifiedDefinitionNames"]();
			return StringToolsLib.getReplace(rst,",","\n");
//			trace(dis.loaderInfo.applicationDomain.parentDomain["getQualifiedDefinitionNames"]());
		}
		public static function getLoaderDefines(loader:LoaderInfo):String
		{
			var rst:String;
			if(!loader)
			{
				return "loader=null";
			}
			rst=loader.applicationDomain["getQualifiedDefinitionNames"]();
	    	return StringToolsLib.getReplace(rst,",","\n");;
		}
		
		public static function getDomainDefines(domain:ApplicationDomain):String
		{
			if(!domain) return "ApplicationDomain==null";
			var rst:String;
			rst=domain["getQualifiedDefinitionNames"]();
			return StringToolsLib.getReplace(rst,",","\n");;
		}
	}
}