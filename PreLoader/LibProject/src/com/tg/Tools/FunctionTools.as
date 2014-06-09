package com.tg.Tools
{
	/**
	 * 函数相关工具
	 * @author ww
	 * 
	 */
	public class FunctionTools
	{
		public function FunctionTools()
		{
		}
		
		/**
		 * 调用函数
		 * @param fun 函数
		 * @param param 参数
		 * 
		 */
		public static function callFunction(fun:Function=null,param:Array=null):void
		{
			if(fun==null) return;
			if(param)
			{
				fun.apply(callFunction,param);
			}else
			{
				fun();
			}
		}
		
		/**
		 * 不受加速工具影响的延时调用
		 * @param fun 函数
		 * @param delayTime 延迟时间，单位毫秒，回调时间只精确到秒
		 * @param param 参数
		 * @return 用于取消该延时调用的id
		 * 
		 */
		public static function delayCall(fun:Function=null,delayTime:int=1000,param:Array=null,count:int=1,dTime:int=5):int
		{
		  return  TimeTools.me.addDelay(fun,delayTime,param,count,dTime);	
		}
		
		/**
		 * 取消延迟调用
		 * @param sign
		 * 
		 */
		public static function cancelDelayCall(sign:int):void
		{
			TimeTools.me.cancelDelay(sign);
		}
		/**
		 * 取消所有延时调用 
		 * 
		 */
		public static function cancelAllDelayCall():void
		{
			TimeTools.me.cancelAll();
		}
		/**
		 * 取消延时调用 
		 * @param fun 函数
		 * 
		 */
		public static function cancelDelayByFun(fun:Function):void
		{
			TimeTools.me.cancelDelayByFun(fun);
		}
	}
}