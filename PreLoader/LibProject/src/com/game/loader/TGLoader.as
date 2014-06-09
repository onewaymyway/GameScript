package com.game.loader
{
	
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	public final class TGLoader extends BulkLoader
	{
		/*** 资源的版本号 */
		public static var version:Dictionary;
		
		/**
		 * 并发下载量 
		 */		
		public static var downNum:int = 2;
		
		protected static var os:Array = ["Windows XP","Windows Vista","Windows 7"];
		protected static var num:Array = [2,4,5]
		
		public function TGLoader(name:String=null, numConnections:int=BulkLoader.DEFAULT_NUM_CONNECTIONS, logLevel:int=BulkLoader.DEFAULT_LOG_LEVEL)
		{
			super(name, numConnections, logLevel);
		}
		
		public function getItem(key:String):LoadingItem
		{
			return super.get(key);
		}
		
		public static function getClass(key:String,clazzName:String,loader:BulkLoader):Class
		{
			var item:ImageItem = loader.get(key) as ImageItem;
			if (!item)
				return null;
			return item.getDefinitionByName(clazzName) as Class;
		}
		
		override public function add(url:*, props:Object=null):LoadingItem
		{
			if (version && version[url])
			{
				if (!props)
					props = {};
				props.weight = version[url].w / 1024;
				
				if(!props.hasOwnProperty("id"))
					props.id = url;
				
				return super.add(getUrl(url),props);
			}
			return super.add(url,props);
		}
		
		override public function start(withConnections:int=-1):void
		{
			withConnections = downNum;
			super.start(withConnections);
			if (!hasEventListener(BulkLoader.ERROR))
				addEventListener(BulkLoader.ERROR,onError);
		}
		
		public static function getUrl(turl:String,useCache:Boolean=true):String
		{
			if(!version||!version[turl])
			{
				trace("未被管理到的URL："+turl);
				return turl;
			}
			CONFIG::CDN{
				var tmpUrl:String = String(turl);
				var spliteIndex:int = tmpUrl.lastIndexOf('.');
				if (useCache)
					return tmpUrl.substring(0,spliteIndex) + "$" + version[turl].v + tmpUrl.substring(spliteIndex,tmpUrl.length)
				else
					return tmpUrl.substring(0,spliteIndex) + "$" + version[turl].v + tmpUrl.substring(spliteIndex,tmpUrl.length) + "?v=" + new Date().time;;
			}
			return turl;
		}
		
		public static function onIoError(e:IOErrorEvent):void
		{
			throw e;
		}
		
		
		private function onError(e:ErrorEvent):void
		{
			throw e;
		}
	}
}