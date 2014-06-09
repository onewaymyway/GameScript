package com.tg.Tools
{
	import com.tg.Tools.dataStruct.patterns.MovePattern;

	/**
	 * 用户行为探测类
	 * 用于用户行为分析
	 * @author ww
	 * 
	 */
	public class UserActionSensor
	{
		public function UserActionSensor()
		{
		}
		private static var _instance:UserActionSensor;
		
		public static function get me():UserActionSensor
		{
			if(!_instance) _instance=new UserActionSensor;
			return _instance;
		}
		
		/**
		 * 用户走动 
		 * @param pid
		 * @param x
		 * @param y
		 * 
		 */
		public function playerMove(pid:int,x:int,y:int):void
		{
			MovePattern.me.playerMove(pid,x,y);
		}
		
		public static var changeSignFun:Function;
		public function playerTryChange(pid:int,sign:String):void
		{
			if(changeSignFun!=null)
			{
				changeSignFun(sign,pid);
			}
		}
	}
}