package com.tools
{
	public class JSONTools
	{
		public function JSONTools()
		{
		}
		
		/**
		 * 返回对象的JSon字符串 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getJSONString(obj:Object):String
		{
			return JSON.stringify(obj)
		}
		
		/**
		 * 返回json字符串表示的对象 
		 * @param jsonString
		 * @return 
		 * 
		 */
		public static function getJSONObject(jsonString:String):Object
		{
			return JSON.parse(jsonString);
		}
	}
}