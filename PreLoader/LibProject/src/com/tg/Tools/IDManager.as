package com.tg.Tools
{
	/**
	 * 获取唯一标示符的工具
	 * @author ww
	 * 
	 * 获取一个唯一的标示符
	 * 如果通过单例获取则获取到单例中的唯一标示符
	 * 如果通过实例获取则获取到实例中的唯一标示符
	 */
	public class IDManager
	{
		public function IDManager(startID:int=1)
		{
			maxID=startID;
		}
		
		private static var _instance:IDManager;
		
		public static function get me():IDManager
		{
			if(!_instance) _instance=new IDManager;
			return _instance;
		}
		
		
		/**
		 * 当前最大的ID; 
		 */
		private var maxID:int;
		/**
		 * 获取一个唯一的ID 
		 * @return 
		 * 
		 */
		public function getANewID():int
		{
			maxID++;
			return maxID;
		}
	}
}