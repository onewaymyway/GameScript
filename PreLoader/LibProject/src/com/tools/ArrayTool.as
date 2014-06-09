package com.tools
{
	import flash.display.DisplayObject;

	/**
	 * Array操作相关的一些函数
	 * @author ww
	 * 
	 */
	public class ArrayTool
	{
		public function ArrayTool()
		{
		}
		
		/**
		 * 填充数组 到指定长度，超长不删
		 * @param oArr 目标数组
		 * @param len 目标长度
		 * @param data 填充的数据
		 * @param clone 是否使用深拷贝
		 * 
		 */
		public static function fillArray(oArr:Array,len:int,data:*,clone:Boolean=false):void
		{
			if(clone)
			{
				while(oArr.length<len)
				{
					oArr.push(ObjectTools.clone(data));
				}
			}else
			{
				while(oArr.length<len)
				{
					oArr.push(data);
				}
			}
			
		}
		

		/**
		 * 删除数组中的元素 
		 * @param oArr
		 * @param value
		 * 
		 */
		public static function deleteItemSimple(oArr:Array,value:*):void
		{
			var i:int;
			var len:int;
			len=oArr.length;
			for(i=len-1;i>=0;i--)
			{
				if(value==oArr[i])
				{
					oArr.splice(i,1);
				}
			}
		}
		
		/**
		 * 删除数组中的元素 
		 * @param oArr 数组
		 * @param sign 判断用的属性
		 * @param value 属性值
		 * @param autoClearFun 用于清理资源的函数，如果有则调用该函数
		 * 
		 */
		public static function deleteItem(oArr:Array,sign:String,value:*,autoClearFun:String=null):void
		{
			var i:int;
			var len:int;
			len=oArr.length;
			
			var tItem:*;
			if(autoClearFun==null)
			{
				for(i=len-1;i>=0;i--)
				{
					if(oArr[i][sign]==value)
					{
						oArr.splice(i,1);
					}
				}
			}else
			{
				for(i=len-1;i>=0;i--)
				{
					if(oArr[i][sign]==value)
					{
						tItem=oArr[i];
						oArr.splice(i,1);
						tItem[autoClearFun]();
					}
				}
			}

		}
		
		/**
		 * 获取数组中符合要求的元素个数
		 * @param oArr 
		 * @param sign 属性标示符
		 * @param value 属性值
		 * @return  元素个数
		 * 
		 */
		public static function findItemCount(oArr:Array,sign:String,value:*):int
		{
			var i:int;
			var len:int;
			len=oArr.length;
			var tItem:*;
			var rst:int;
			rst=0;
			for(i=0;i<len;i++)
			{
				tItem=oArr[i];
				if(tItem[sign]==value)
				{
					rst++;
				}
			}
			return rst;
		}
		/**
		 * 获取数组中某元素的个数
		 * @param oArr
		 * @param value 
		 * @return 
		 * 
		 */
		public static function findItemCountSimple(oArr:Array,value:*):int
		{
			var i:int;
			var len:int;
			len=oArr.length;
			var tItem:*;
			var rst:int;
			rst=0;
			for(i=0;i<len;i++)
			{
				tItem=oArr[i];
				if(tItem==value)
				{
					rst++;
				}
			}
			return rst;
		}
		/**
		 * 清空数组
		 * @param oArr
		 * @param autoClearFun 用于清理资源的函数
		 * 
		 */
		public static function delteItemAll(oArr:Array,autoClearFun:String):void
		{
			var i:int;
			var len:int;
			len=oArr.length;
			
			var tItem:*;
			if(autoClearFun==null)
			{
				oArr.splice(0,oArr.length);
			}else
			{
				for(i=len-1;i>=0;i--)
				{
						tItem=oArr[i];
						oArr.splice(i,1);
						tItem[autoClearFun]();

				}
			}
		}
		/**
		 * 根据判断函数删除数组中的元素
		 * 如果函数返回true则删除
		 * 资源清除由判断函数负责 
		 * @param oArr 数组
		 * @param fun 判断用的函数
		 * 
		 */
		public static function deleteItemByJudgeFun(oArr:Array,fun:Function):void
		{
			var i:int;
			var len:int;
			len=oArr.length;
			for(i=len-1;i>=0;i--)
			{
				if(fun(oArr[i]))
				{
					oArr.splice(i,1);
				}
			}
		}
		/**
		 * 合并两个数组
		 * @param oArr
		 * @param aArr
		 * 
		 */
		public static function addDistictArray(oArr:Array,aArr:Array):void
		{
			var i:int;
			var len :int;
			len=aArr.length;
			
			for(i=0;i<len;i++)
			{
				addDistictItem(oArr,aArr[i]);
			}
		}
		
		/**
		 * 向数组加入一个唯一的元素
		 * @param oArr
		 * @param item
		 * 
		 */
		public static function addDistictItem(oArr:Array,item:*):void
		{
			
//			DebugTools.traceObj(oArr,"before addDistinctItem arr:");
//			DebugTools.traceObj(item,"addDistinctItem item:");
			if(isDistict(oArr,item))
			{
				oArr.push(item);
			}
//			DebugTools.traceObj(oArr,"after addDistinctItem arr:");
		}
		/**
		 * 判断是否是新的 
		 * @param oArr
		 * @param item
		 * @return 
		 * 
		 */
		public static function isDistict(oArr:Array,item:*):Boolean
		{
			var i:int;
			var len :int;
			len=oArr.length;
			
			for(i=0;i<len;i++)
			{
				if(oArr[i]==item)
				{
					return false;
				}
				if(item is Object && (item as Object).hasOwnProperty("id"))
				{
					
					if(item.id==oArr[i].id)
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		/**
		 * 返回数组中的随机一个元素 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function getRandom(arr:Array):*
		{
			if(!arr) return null;
			var i:int;
			i=int(Math.random()*100000)%arr.length;
			return arr[i];
		}
		
		/**
		 * 返回随机布尔值 
		 * @return 
		 * 
		 */
		public static function getRandomBoolen():Boolean
		{
			var i:int;
			i=int(Math.random()*100000);
			return (i%2==1);
		}
		private static const monsterSighList:Array=["PiaoQiNan","PiaoQiNv","ShenWuNan","ShenWuNv","YuLinNan","YuLinNv"];
		
		/**
		 * 获取随机的Sign标志 
		 * 
		 */
		public static function getRandomSign():String
		{
			return getRandom(monsterSighList);
		}
		
		public static function getRandomDL(d:int):int
		{
			return -d+d*2*Math.random();
		}
		
		public static function getLineLen(aX:int,aY:int,bX:int,bY:int):int
		{
			return Math.pow((aX-bX)*(aX-bX)+(aY-bY)*(aY-bY),0.5);
		}
		
		public static function getDisLineLen(a:DisplayObject,b:DisplayObject):int
		{
			return getLineLen(a.x,a.y,b.x,b.y);
		}
	}
}