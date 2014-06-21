package com.tools
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoadTools
	{
		public function LoadTools()
		{
		}
		
		public static function loadTxt(url:String,backFun:Function=null):void
		{
			var ld:URLLoader=new URLLoader();
			ld.addEventListener(Event.COMPLETE,onloadFile);
			ld.load(new URLRequest(url));
			function onloadFile(e:Event):void{
				var tStr:String;
				var tLoader:URLLoader;
				tLoader=e.target as URLLoader;
				tStr=tLoader.data;
				tLoader.removeEventListener(Event.COMPLETE,onloadFile);
				tLoader=null;
				if(backFun!=null)
				{
					if(backFun.length==1)
					{
						backFun(tStr);
					}else
					{
						backFun();
						
					}
				}
				
			}
		}
	}
}