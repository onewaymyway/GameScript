package com.tg.Tools
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class WebTools
	{
		public function WebTools()
		{
		}
		
		public static function openWeb(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request,"_blank"); 
		}
	}
}