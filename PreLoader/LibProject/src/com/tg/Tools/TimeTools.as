package com.tg.Tools
{
	import com.tg.Trigger;
	import com.tg.Tools.dataStruct.FunDes;
	import com.tools.ArrayTool;

	/**
	 * 时间相关的工具 
	 * @author ww
	 * 
	 */
	public class TimeTools
	{
		
		public static const dayMS:int=24*60*60*1000;
		public function TimeTools()
		{
			timeDelayList=[];
		}
		
		/**
		 * 获取当前时间 
		 * @return 
		 * 
		 */
		public static function getTimeNow():Number
		{
			return (new Date()).time;
		}
		
		/**
		 * 当前时差 
		 */
		private static var tDTime:Number=0;
		/**
		 * 对时，计算本地时间与服务器时间的差值 
		 * @param time
		 * 
		 */
		public static function adaptTime(time:Number):void
		{
			tDTime=time-getTimeNow();
		}
		/**
		 * 获取消除时差后的时间 
		 * @return 
		 * 
		 */
		public static function getTimeAdapted():Number
		{
			return getTimeNow()+tDTime;
		}
		
		/**
		 * 获取下一个该时间的time 
		 * @param h 小时
		 * @param m 分钟
		 * @return 
		 * 
		 */
		public static function getNextTime(hour:int,minutes:int,seconds:int=0):Number
		{
			var rst:Date;
			rst=getDateAdapted();
			if((rst.hours*60+rst.minutes)<(hour*60+minutes))
			{
			}else
			{
				rst.time=rst.time+dayMS;
			}
			rst.hours=hour;
			rst.minutes=minutes;
			rst.seconds=seconds;
			return rst.time;
		}
		/**
		 * 获取消除时差后的当前Date 
		 * @return 
		 * 
		 */
		public static function getDateAdapted():Date
		{
			var rst:Date;
			rst=new Date();
			rst.time=getTimeAdapted();
			return rst;
		}
		
		/**
		 * 延时函数列表 
		 */
		private var timeDelayList:Array;
		
		private static var _instance:TimeTools;
		
		public static function get me():TimeTools
		{
			if(!_instance) _instance=new TimeTools;
			return _instance;
		}
		
		/**
		 * 不受加速工具影响的延时调用 
		 * @param callBack
		 * @param delay 延迟时间，单位毫秒，回调时间只精确到秒
		 * @param param 参数
		 * @return  用于取消该延时调用的id
		 * 
		 */
		public function addDelay(callBack:Function,delay:int,param:Array=null,count:int=1,dTime:int=5):int
		{

			return addDelayByTime(callBack,getTimeAdapted()+delay,param,count,dTime);
		}
		
		/**
		 * 设置定点执行函数 
		 * @param callBack
		 * @param time  执行时的time单位ms
		 * @param param
		 * @param count
		 * @param dTime
		 * @return 
		 * 
		 */
		public function addDelayByTime(callBack:Function,time:Number,param:Array=null,count:int=1,dTime:int=5):int
		{
			var tFun:FunDes;
			tFun=new FunDes();
			tFun.fun=callBack;
			tFun.time=time;
			tFun.param=param;
			tFun.sign=IDManager.me.getANewID();
			tFun.count=count;
			tFun.dTime=dTime;
			timeDelayList.push(tFun);
			Trigger.addSecondTrigger(tick);
			
			return tFun.sign;
		}
		
		/**
		 * 设置定时执行的函数 
		 * @param callBack
		 * @param hour 小时
		 * @param minutes 分钟
		 * @param param
		 * @param count
		 * @param dTime
		 * @return 
		 * 
		 */
		public function addNextTimeCall(callBack:Function,hour:int,minutes:int,param:Array=null,count:int=1,dTime:int=5):int
		{
			return addDelayByTime(callBack,getNextTime(hour,minutes),param,count,dTime);
		}
		
		/**
		 * 设置每日定时执行函数 
		 * @param callBack
		 * @param hour 小时
		 * @param minutes 分钟
		 * @param param
		 * @return 
		 * 
		 */
		public function addEveryDayTimeCall(callBack:Function,hour:int,minutes:int,seconds:int=0,param:Array=null):int
		{
			return addDelayByTime(callBack,getNextTime(hour,minutes,seconds),param,999,dayMS);
		}
		/**
		 * 取消延时调用 
		 * @param sign 添加延时调用时返回的ID
		 * 
		 */
		public function cancelDelay(sign:int):void
		{
			ArrayTool.deleteItem(timeDelayList,"sign",sign,"clear");
		}

		/**
		 * 取消所有延时调用 
		 * 
		 */
		public function cancelAll():void
		{
			Trigger.removeSecondTrigger(tick);
			ArrayTool.delteItemAll(timeDelayList,"clear");
		}
		
		/**
		 * 取消延时调用 
		 * @param fun 函数
		 * 
		 */
		public function cancelDelayByFun(fun:Function):void
		{
			ArrayTool.deleteItem(timeDelayList,"fun",fun,"clear");
		}
		
		/**
		 * 计时逻辑 
		 * 
		 */
		private function tick():void
		{
			tTime=getTimeAdapted();
			ArrayTool.deleteItemByJudgeFun(timeDelayList,dealDelayFun);
			if(timeDelayList.length<1)
			{
				Trigger.removeSecondTrigger(tick);
			}
		}
		
		
		/**
		 * 当前时间 
		 */
		private var tTime:Number;
		/**
		 * 处理当前的函数 
		 * @param tFun
		 * @return 
		 * 
		 */
		private function dealDelayFun(tFun:FunDes):Boolean
		{
			if(tFun.time>tTime) return false;
			tFun.callBack();
			if(tFun.count>0) return false;
			return true;
		}

		
		private static var preTimeDic:Object={};
		
		/**
		 * 根据标示符获取时间差 
		 * @param sign
		 * @return 
		 * 
		 */
		public static function getDTime(sign:String):Number
		{
			var tTime:Number;
			tTime=getTimeNow();
			var pTime:Number;
			pTime=0;
			if(preTimeDic.hasOwnProperty(sign))
			{
				pTime=preTimeDic[sign];
			}else
			{
				pTime=0;
			}
			preTimeDic[sign]=tTime;
			return tTime-pTime;
		}
	}
}