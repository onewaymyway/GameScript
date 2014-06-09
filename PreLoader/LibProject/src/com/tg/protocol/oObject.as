package com.tg.protocol
{
	
	public class oObject extends Object
	{
		public static function list(baseDataArray:Array, dstnObject:Object, properties:Array) : void
		{
			if (!baseDataArray || !properties)
				throw new Error("com.tg.protocol.oObject::list error. baseDataArray and properties must not be null.");
			
			for(var i:int = 0; i < properties.length; i++)
			{
				dstnObject[properties[i]] = baseDataArray[i];
			}
		}
		
		public static function getKeys(object:Object) : Array
		{
			var keys:Array = [];
			for (var prop:Object in object)
			{
				keys.push(prop);
			}
			return keys;
		}
		
		public static function getValues(object:Object) : Array
		{
			var result:Array = [];
			for (var prop:Object in object)
			{
				result.push(object[prop]);
			}
			return result;
		}
	}
}
