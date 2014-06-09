package com.tg.st.commonData
{

	public class CommonData
	{
		public function CommonData()
		{
		}
		
		
		/**
		 * GlobalData.getCoin
		 */
		public static var coinFun:Function;
		public static function get Coin():int
		{
			return coinFun();
		}
		
		public static var userRank:int;
		
		public static var userTitle:String="无";
		
		public static var playerBean:Object;
		public static var negot:int;
		public static var bound:int;
		public static var playerX:int;
		public static var playerY:int;
		
		public static var flagWarLimit:int=20;
		
		public static var inTownFun:Function;
		public static function get isInTown():Boolean
		{
			return inTownFun();
		}
	}
}