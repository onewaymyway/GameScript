package com.tg.Tools
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class DoubleLoader
	{
		public function DoubleLoader()
		{
		}
		public static function load(url:String,backFun:Function=null):void  
		{   
			// 第一个Loader用于使用url加载文件   
			var loader1:Loader = new Loader();   
			loader1.contentLoaderInfo.addEventListener(Event.COMPLETE, loader1Complete);   
			loader1.load(new URLRequest(url));   
			function loader1Complete(event:Event):void  
			{   
				var loaderinfo:LoaderInfo = event.target as LoaderInfo;   
				// 第二个Loader用于加载第一个Loader加载进来的bytes   
				var loader2:Loader = new Loader();   
				loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, loader2Complete);   
				loader2.loadBytes(loaderinfo.bytes);   
			}   
			function loader2Complete(event:Event):void  
			{   
				// 在这里可以使用被加载进来的文件了   
				// event.target as DisplayObject  
				if(backFun)
				{
					backFun(event.target);
				}
			}
		}   
		
		
		
	}
}