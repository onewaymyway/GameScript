package com.tg.avatar.war
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class WarRoleData
	{
		public function WarRoleData()
		{
		}
		
		public var standbyBmd:BitmapData;
		public var attackBmd:BitmapData;
		public var attackedBmd:BitmapData;
		public var stuntBmd:BitmapData;
		public var dieBmd:BitmapData;
		
		public var dataDes:Object;
		public var sign:String;
		
		public var isAnalysed:Boolean=false;
		
		public function analyse():void
		{
			if(isAnalysed) return;
		}
		

	}
}