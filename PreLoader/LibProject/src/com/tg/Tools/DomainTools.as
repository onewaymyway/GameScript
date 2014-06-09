package com.tg.Tools
{
	import com.tools.ClassTools;
	
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

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
		public  function addDomain(domain:ApplicationDomain,doMainName:String="domain"):void
		{
			if(!domain) return;
			if(domainDic[domain]) return;
			domainDic[domain]=doMainName;
		}
		private var loaderInfoDic:Dictionary=new Dictionary();
		private var domainDic:Dictionary=new Dictionary();
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
			trace("===================================================");
			
			if(!domainDic[loaderInfo.applicationDomain])
			{
				domainDic[loaderInfo.applicationDomain]=turl;
				trace("ooooooooooooooooooooooooooooooooooooooooo");
				trace("new domain Added");
				trace("ooooooooooooooooooooooooooooooooooooooooo");
			}else
			{
				trace("ooooooooooooooooooooooooooooooooooooooooo");
				trace("oldDomain");
				trace("ooooooooooooooooooooooooooooooooooooooooo");
			}
			
		}
		
		private var classDic:Dictionary=new Dictionary();
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
				throw new Error("clName un find:"+clName);
			}
			return classDic[clName];
		}
	}
}