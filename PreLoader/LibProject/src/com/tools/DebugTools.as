package com.tools
{
	import com.tg.Tools.DebugToolScreen;
	import com.tg.Tools.StringToolsLib;
	import com.tg.Tools.TimeTools;
	
	import flash.system.System;

	/**
	 *  
	 * @author ww
	 * 
	 */	
	public class DebugTools
	{
		public function DebugTools()
		{
		}
		/**
		 * trace obj 对象的jsong 
		 * @param obj
		 * @param objName
		 * 
		 */
		public static function traceObj(obj:Object,objName:String="obj"):void
		{
//			return;
			trace("-----------------------------");
			trace("trace obj begin:"+objName);
			//trace(JSONTools.getJSONString(obj));
			trace(JSON.stringify(obj));
			trace("trace obj end:"+objName);
			trace("-----------------------------");
		}
		
		private static var preMem:Number=0;
		public static function traceMemory(comment:String="当前内存"):void
		{
			
			trace("-----------------------------");
			trace("trace Memroy :"+comment);
			trace("trace Memroy begin:");
			trace("mem:" + (System.totalMemory / 1024 / 1024).toFixed(2) + "MB");
			trace("memD:" + ((System.totalMemory-preMem) / 1024 / 1024).toFixed(2) + "MB");
			trace("trace Memroy end:");
			trace("-----------------------------");
			preMem=System.totalMemory;
		}
		
		private static const sizeP:Number=4/(1024*1024);
		public static function traceBMDSize(width:int,height:int):void
		{
			trace("bmd width:"+width+" height:"+height);
			trace("bmdSize:"+(width*height*sizeP).toFixed(2)+"MB");
		}
		
		private static var preTime:Number=0;
		public static function traceTime(msg:String="timeTrace"):void
		{
			var tTime:Number;
			tTime=TimeTools.getTimeNow();
			trace("-----------------------------");
			trace("time:"+msg);
			trace(StringToolsLib.secondsToStandardMS(tTime)+" d:"+(tTime-preTime));
			trace("-----------------------------");
			preTime=tTime;
		}
		/**
		 * 调试信息打印
		 * @param str 信息
		 * @param msgType 信息类型
		 * @param dataO 额外数据
		 * 
		 */
		public static function debugTrace(str:String,msgType:String="default",dataO:Object=null):void
		{
			DebugToolScreen.debugOut(str,msgType,dataO);
		}
	}
}