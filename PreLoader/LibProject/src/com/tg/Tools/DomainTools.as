package com.tg.Tools
{
	import com.tools.ClassTools;
	import com.tools.DebugTools;
	
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * applicationDomain 管理类 
	 * @author ww
	 * 
	 * 主要用于便捷的从所有加载的文件中获取类定义
	 * 
	 */
	public class DomainTools
	{
		public function DomainTools()
		{
		}
		private static var _instance:DomainTools;
		
		public static function get me():DomainTools
		{
			if(!_instance) _instance=new DomainTools;
			return _instance;
		}
		
		private var classDicO:Object={};
		/**
		 * 添加applicationDomain 
		 * @param domain
		 * @param doMainName
		 * 
		 */
		public  function addDomain(domain:ApplicationDomain,doMainName:String="domain"):void
		{
			if(!domain) return;
			if(domainDic[domain]) 
			{
				trace("ooooooooooooooooooooooooooooooooooooooooo");
				trace("oldDomain");
				trace("ooooooooooooooooooooooooooooooooooooooooo");
				return;
			}
			domainDic[domain]=doMainName;
			trace("ooooooooooooooooooooooooooooooooooooooooo");
			trace("new domain Added");
			trace("ooooooooooooooooooooooooooooooooooooooooo");
			return;
			var i:int;
			var len:int;
			var defineStr:String;
			defineStr=ClassTools.getDomainDefines(domain);
//			defineStr=StringToolsLib.getReplace(defineStr,"::",".");
			var classList:Array;
			classList=defineStr.split("\n");
			len=classList.length;
			var tClassName:String;
			var tClass:*;
			for(i=0;i<len;i++)
			{
			   tClassName=classList[i];
//			   tClass=domain.getDefinition(tClassName);
			   if(domain.hasDefinition(tClassName))
			   {
				   tClass=domain.getDefinition(tClassName);
				   if(tClass!=null)
				   {
					   if(!classDicO.hasOwnProperty(tClassName))
					   {
						   classDicO[tClassName]=tClass;
					   }
				   }
			   }else
			   {
				   trace("domain.parentDomain.:"+domain.parentDomain.hasDefinition(tClassName));
				   var sName:String;
				   sName=StringToolsLib.getLastValue(tClassName,".");
				   trace("currentdomain:"+ApplicationDomain.currentDomain.hasDefinition(tClassName));
				   trace("domain:"+domain.hasDefinition(sName));
				   trace("class un find:"+tClassName);
			   }
			}
		}
		/**
		 * loaderInfo库
		 */
		private var loaderInfoDic:Dictionary=new Dictionary();
		/**
		 * applicationDomain库
		 */
		private var domainDic:Dictionary=new Dictionary();
		/**
		 * 添加新的loaderInfo 
		 * @param loaderInfo
		 * 
		 */
		public function addNewLoaderInfo(loaderInfo:LoaderInfo):void
		{
			if(!loaderInfo) return;
			if(!loaderInfo.url) return;
			var turl:String;
			turl=StringToolsLib.getPreValue(loaderInfo.url,"?");
			if(turl.indexOf(".swf")<0) return;
			if(loaderInfoDic[turl]) return;
			loaderInfoDic[turl]=loaderInfo;
			trace("===================================================");
			trace("PreLoader : File loaded:"+ loaderInfo.url+ "Class:"+ getQualifiedClassName(loaderInfo.content));
			
			
			trace("loader defines:\n"+ClassTools.getLoaderDefines(loaderInfo));
			DebugTools.debugTrace("AddClass:"+ClassTools.getLoaderDefines(loaderInfo),"Defines");
			trace("===================================================");
			
			
			addDomain(loaderInfo.applicationDomain,turl);
//			if(!domainDic[loaderInfo.applicationDomain])
//			{
//				domainDic[loaderInfo.applicationDomain]=turl;
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//				trace("new domain Added");
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//			}else
//			{
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//				trace("oldDomain");
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//			}
			
		}
		
		/**
		 * 类定义库 
		 */
		private var classDic:Dictionary=new Dictionary();
		/**
		 * 获取类定义 
		 * @param clName
		 * @return 
		 * 
		 */
		public function getDefine(clName:String):*
		{
			if(!classDic[clName])
			{
				var tDomain:ApplicationDomain;
				var key:*;
				trace("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
				trace("尝试查询类："+clName);
				for(key in domainDic)
				{
					tDomain=key as ApplicationDomain;
					if(!tDomain) continue;
					trace("当前查询Domain:\n"+domainDic[key]);
					var defines:String;
					defines=ClassTools.getDomainDefines(tDomain);
					if(tDomain.hasDefinition(clName))
					{
						classDic[clName]=tDomain.getDefinition(clName);
						trace("找到类定义："+domainDic[key]);
						break;
					}else
					{
						trace("未找到类定义："+domainDic[key]);
						if(tDomain.parentDomain)
						{
							tDomain=tDomain.parentDomain;
							if(tDomain.hasDefinition(clName))
							{
								classDic[clName]=tDomain.getDefinition(clName);
								trace("在parentDomain找到类定义："+domainDic[key]);
								break;
							}else
							{
								trace("未在parentDomain找到类定义：");
							}
						}
					}
					
				}
			}
			trace("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
			if(!classDic[clName])
			{
				trace("clName un find:classDic");
				if(classDicO[clName])
				{
					classDic[clName]=classDicO[clName];
				}else
				{
					throw new Error("clName un find:"+clName);
				}
				
			}
			return classDic[clName];
		}
	}
}