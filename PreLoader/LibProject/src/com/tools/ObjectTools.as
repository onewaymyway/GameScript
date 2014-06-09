package com.tools
{
	import flash.utils.ByteArray;

	/**
	 * 和object操作相关的函数
	 * @author ww
	 * 
	 */
	public class ObjectTools
	{
		public function ObjectTools()
		{
		}
		
		/**
		 * 深拷贝object 
		 * @param source 要拷贝的对象
		 * @return 拷贝的副本
		 * 
		 */
		public static function clone(source:Object):*
		{
			var oData:ByteArray=new ByteArray();
			oData.writeObject(source);
			oData.position=0;
			return (oData.readObject());
		}
		
		/**
		 * 从一个对象中拷贝属性到另一个对象 
		 * 只拷贝目标对象中原有的属性
		 * @param destObj 目标对象
		 * @param srcObj 数据对象
		 * 
		 */
		public static function copyValues(destObj:Object,srcObj:Object):void
		{
			var value:String;
			for(value in srcObj)
			{
				if(destObj.hasOwnProperty(value))
				{
					destObj[value]=srcObj[value];
				}
			}
		}
		/**
		 * 从一个对象中拷贝属性到另一个对象
		 * 如果目标对象中没有对应的属性就添加该属性
		 * @param destObj 目标对象
		 * @param srcObj 数据对象
		 * 
		 */
		public static function insertValues(destObj:Object,srcObj:Object):void
		{
			var value:String;
			for(value in srcObj)
			{
					destObj[value]=srcObj[value];
			}
		}
		/**
		 * 批量修改数组中的元素 
		 * @param objectList 对象的数组
		 * @param adaptFun  fun(object:Object) || fun(object:Object,index:int)
		 * 
		 */
		public static function adaptObjectList(objectList:Array,adaptFun:Function=null):void
		{
			if(null==adaptFun) return;
			var i:int;
			var len:int;
			len=objectList.length;
			var tObject:Object;
			for(i=0;i<len;i++)
			{
				tObject=objectList[i];
				if(!tObject) continue;
				switch(adaptFun.length)
				{
					case 1:
						adaptFun(tObject);
						break;
					case 2:
						adaptFun(tObject,i);
						break;
				}
				
			}
		}
		
		/**
		 * 根据object数组生成bean数组 
		 * @param objectList
		 * @param beanClass
		 * 
		 */
		public static function getBeanListFromObjectList(objectList:Array,beanClass:Class):Array
		{
			var i:int;
			var len:int;
			var beanList:Array;
			var tObject:Array;
			var tBean:*;
			beanList=[];
			len=objectList.length;
			for(i=0;i<len;i++)
			{
				tObject=objectList[i];
				tBean=new beanClass;
				copyValues(tBean,tObject);
				beanList.push(tBean);
			}
			return beanList;
		}
		
		/**
		 * 如果对象是数组就返回原对象，如果不是则返回以该对象为元素的数组
		 * @param data
		 * @return 
		 * 
		 */
		public static function getArrFromObject(data:Object):Array
		{
			if(!data) return [];
			if(data is Array) return data as Array;
			return [data];
		}
		
		public static function ObjectEqual(oA:Object,oB:Object):Boolean
		{
			var sA:String;
			sA=JSONTools.getJSONString(oA);
			var sB:String;
			sB=JSONTools.getJSONString(oB);
			return sA==sB;
		}
	}
}