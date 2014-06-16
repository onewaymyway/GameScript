package com.tools
{
	import com.adobe.serialization.json.JSON;
	import com.tg.Tools.StringToolsLib;
	
	import flash.globalization.StringTools;

	public class JSONTools
	{
		public function JSONTools()
		{
		}
		
		public static function adaptForJSON(obj:Object):void
		{
			var kk:String;
			for(kk in obj)
			{
				if(obj[kk] is Number) continue;
				if(obj[kk] is String)
				{
					obj[kk]=StringToolsLib.getReplace(obj[kk],"\""," ");
				}else
				if(obj[kk] is Object)
				{
					adaptForJSON(obj[kk]);
				}
				
			}
		}
		/**
		 * 返回对象的JSon字符串 
		 * @param obj
		 * @return 
		 * 
		 */
		public static function getJSONString(obj:Object):String
		{
			return com.adobe.serialization.json.JSON.encode(obj);
		}
		
		/**
		 * 返回json字符串表示的对象 
		 * @param jsonString
		 * @return 
		 * 
		 */
		public static function getJSONObject(jsonString:String):Object
		{
			return com.adobe.serialization.json.JSON.decode(jsonString,false);
		}
	}
}0