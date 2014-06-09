package com.tg.Tools.dataStruct.patterns
{
	public class MovePattern
	{
		public function MovePattern()
		{
		}
		
		public var pInfos:Object={};
		
		
		
		
		
		private static var _instance:MovePattern;
		
		public static function get me():MovePattern
		{
			if(!_instance) _instance=new MovePattern;
			return _instance;
		}
		
		public function playerMove(pid:int,x:int,y:int):void
		{
			var tParttern:MovePatternDes;
			tParttern=getPlayerPattern(pid);
			tParttern.dealMove(x,y);
		}
		
		public function getPlayerPattern(pid:int):MovePatternDes
		{
			var rst:MovePatternDes;
			if(pInfos[pid])
			{
				rst=pInfos[pid];
			}else
			{
				rst=new MovePatternDes;
				rst.pid=pid;
				pInfos[pid]=rst;
			}
			return rst;
		}
	}
}