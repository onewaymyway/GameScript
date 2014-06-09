package com.tg.text
{
	public class StringUtil
	{
		public static function trim(string:String):String
		{
			if(string == null)
				return "null";
			
			if(string.length == 0)
				return "";
			
			var left:int = 0;
			for(var i:int = 0; i < string.length; i++)
			{
				left = i;
				
				var charL:String = string.charAt(i);
				if(charL != " ")
					break;
			}
			
			if(left == string.length - 1)
			{
				return "";
			}
			
			var right:int = string.length - 1;
			for(var j:int = string.length - 1; j > left; j--)
			{
				right = j;
				
				var charR:String = string.charAt(j);
				if(charR != " ")
					break;
			}
			
			return string.substring(left, right + 1);
		}
		/**
		 * 格式化输出字符 
		 * @param str
		 * @param rest
		 * @return 
		 * 
		 */		
		public static function format(str:String,...rest):String
		{
			for (var i:int=0; i < rest.length; i++)
			{
				str = str.replace("{"+i+"}",rest[i]);
			}
			return str;
		}
	}
}