package com.tg
{
	import flash.net.LocalConnection;

	public class GC
	{
		public function GC()
		{
			
		}
		
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect("1");
				new LocalConnection().connect("1");
			}
			catch(e:Error)
			{
				
			}
		}
	}
}