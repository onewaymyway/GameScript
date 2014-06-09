package com.tg.Tools.dataStruct
{
	import com.tg.Tools.FunctionTools;

	public class FunDes
	{
		public function FunDes()
		{
			count=1;
		}
		public var fun:Function;
		public var param:Array;
		public var time:Number;
		public var sign:int;
		public var count:int;
		public var dTime:int;
		public function callBack():void
		{

			FunctionTools.callFunction(fun,param);


			count--;
			if(count>0)
			{
				time+=dTime*1000;
			}else
			{
				clear();
			}
			
		}
		
		public function clear():void
		{
			fun=null;
			param=null;
		}
	}
}