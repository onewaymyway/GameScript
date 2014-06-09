package com.tg.text
{
	//import com.tg.protocol.oObject;
	
	import flash.utils.describeType;

	public class Lang extends Object
	{
		
		public static function getKeys(object:Object) : Array
		{
			var keys:Array = [];
			for (var prop:Object in object)
			{
				keys.push(prop);
			}
			return keys;
		}
		
		public static function sprintf(templet:String, ... args) : String
		{
			var argsLen:int = args.length;
			var i:int = 1;
			while (i <= argsLen)
			{
				var reg:RegExp = new RegExp("\\$<" + i + ">");
				templet = templet.replace(reg, args[(i - 1)]);
				i++;
			}
			return templet;
		}
		
		public static function output(className:Class) : String
		{
			var repos:Object = {};
			
			// 
			var classDescribe:XML = describeType(className);
			var describeContent:XMLList = classDescribe.children();
			for each (var sub:XML in describeContent)
			{
				var name:String = sub.name();
				if (name == "constant" || name == "variable")
				{
					var nameValue:String = sub.attribute("name");
					repos[nameValue] = className[nameValue].replace(/\r|\n""\r|\n/g, "\\n");
				}
			}
			
			// 
			var keyArray:Array = getKeys(repos);
			keyArray.sort(Array.CASEINSENSITIVE);
			var keyArrayLen:int = keyArray.length;
			var result:String = "";
			var i:int = 0;
			while (i < keyArrayLen)
			{
				if (result != "")
					result = result + "\r\n";
				
				var value:String = keyArray[i];
				result = result + (value + " : " + repos[value]);
				i++;
			}
			
			return result;
		}
		
	}
}
