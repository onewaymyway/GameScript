package com.tg.Tools
{
	import flash.utils.Dictionary;

	/**
	 * 限时调用工具
	 * @author ww
	 * 
	 */
	public class FunLimitCallTool
	{
		public function FunLimitCallTool()
		{
			funDic=new Dictionary(false);
			preTimeDic={};
			dTimeDic={};
			tMaxFunID=1;
		}
		
		/**
		 * 要管理的函数表
		 */
		private var funDic:Dictionary;
		/**
		 * 标示符最后调用时间表
		 */
		private var preTimeDic:Object;
		/**
		 * 标示符时间限制表
		 */
		private var dTimeDic:Object;
		/**
		 * 当前最大标示符
		 */
		private var tMaxFunID:int;
		private static var instance:FunLimitCallTool;
		public static function get me():FunLimitCallTool
		{
		   if(!instance) instance=new FunLimitCallTool;
		   return instance;
		}
		/**
		 * 添加限时调用函数 
		 * @param fun
		 * @param dTime 限时（秒）
		 * @return 
		 * 
		 */
		public function addFun(fun:Function,dTime:int=10):int
		{
			if(funDic[fun]) return funDic[fun];
			var tID:int;
			tID=getNew();
			funDic[fun]=tID;
			dTimeDic[tID]=dTime;
			
			return tID;
		}
		
		/**
		 * 添加限时标志
		 * 添加此标志之后可根据该标志查询
		 * @param dTime
		 * @return 
		 * 
		 */
		public function addSign(dTime:int=10):int
		{
			var tID:int;
			tID=getNew();
			dTimeDic[tID]=dTime;
			return tID;
			
		}
		/**
		 * 移除限制 
		 * @param fun
		 * 
		 */
		public function removeFun(fun:Function):void
		{
			delete funDic[fun];
		}
		
		/**
		 * 获取一个新的ID 
		 * @return 
		 * 
		 */
		private function getNew():int
		{
			tMaxFunID++;
			return tMaxFunID;
		}
		/**
		 * 根据标示符查询函数 
		 * @param funID
		 * @return 
		 * 
		 */
		private function getFun(funID:int):Function
		{
			var tFun:*;
			for(tFun in funDic)
			{
				if(funDic[tFun]==funID)
				{
					return tFun;
				}
			}
			return null;
		}
		/**
		 * 根据标示符调用函数 
		 * @param funID
		 * 
		 */
		public function callFunByID(funID:int):void
		{
			var tFun:Function;
			tFun=getFun(funID);
			if(tFun==null) return;
			if(canCall(funID))
			{
//				var tTime:Date;
//				tTime=new Date;
//				preTimeDic[funID]=tTime.time;
				
				updateCallTime(funID);
				tFun();
			}else
			{
				MagicAlert.showMagicAlertStr("不要太着急了哦");
			}
		}
		
		/**
		 * 更新标示符最后调用时间 
		 * @param funID
		 * 
		 */
		public function updateCallTime(funID:int):void
		{
			var tTime:Date;
			tTime=new Date;
			preTimeDic[funID]=tTime.time;
		}
		
		/**
		 * 调用被管理的函数 
		 * @param fun
		 * 
		 */
		public function callFun(fun:Function):void
		{
			var funID:int;
			funID=funDic[fun];
			if(funID>0)
			{
				return callFunByID(funID);
			}
		}
		
		/**
		 * 标示符是否可调用 
		 * @param funID
		 * @return 
		 * 
		 */
		public function canCall(funID:int):Boolean
		{
			var preTime:Number;
			preTime=preTimeDic[funID]?preTimeDic[funID]:0;
			var tTime:Date;
			tTime=new Date;
			return (tTime.time-preTime)>1000*int(dTimeDic[funID]);
		}
		/**
		 * 函数当前是否可调用 
		 * @param fun
		 * @return 
		 * 
		 */
		public function canCallFun(fun:Function):Boolean
		{
			var funID:int;
			funID=funDic[fun];
			if(funID>0)
			{
				return canCall(funID);
			}
			return false;
		}
	}
}