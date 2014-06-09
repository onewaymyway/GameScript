package com.tg.Tools
{
	import com.tg.Trigger;
	
	import flash.text.TextField;

	/**
	 * 倒计时文本框控制类 
	 * @author ww
	 * 
	 */
	public class TimeCountWraper
	{
		public function TimeCountWraper()
		{
			prefix="倒计时：";
			suffix="";
			autoHide=true;
		}
		public static const Seconds:int=1;
		public static const MinutesSeconds:int=2;
		public static const HourMinutesSeconds:int=3;
		/**
		 * 当前剩余时间，单位秒
		 */
		public var tCount:int;
		public var type:int=HourMinutesSeconds;
		/**
		 * 倒计时文本前缀
		 */
		public var prefix:String;
		/**
		 * 倒计时文本后缀
		 */
		public var suffix:String;
		
		public var html:Boolean=true;
		/**
		 * 倒计时完成后回调
		 */
		private var tBackFun:Function;
		
		/**
		 * 是否倒计时结束后自动隐藏文本
		 */
		public var autoHide:Boolean;

		/**
		 * 要控制的文本框
		 */
		public var txt:TextField;
		/**
		 * 开始倒计时 
		 * @param time 倒计时时间
		 * @param backFun 倒计时结束回调函数
		 * 
		 */
		public function startCount(time:int,backFun:Function):void
		{
			
			this.tBackFun=backFun;
			if(time<=0) 
			{
				timeEnd();
				return;
			}
			tCount=time;
			start();
		}
		
		private function start():void
		{
			Trigger.removeSecondTrigger(timeH);
			if(txt)
			{
				txt.visible=true;
			}
			Trigger.addSecondTrigger(timeH);
		}
		/**
		 * 停止倒计时 
		 * 
		 */
		public function stop():void
		{
			Trigger.removeSecondTrigger(timeH);
		}
		/**
		 * 清理倒计时 
		 * 
		 */
		public function clear():void
		{
			stop();
			tBackFun=null;
		}
		private function timeH():void
		{
			tCount--;
			if(tCount<=0)
			{
				updateTxt();			
				timeEnd();
			}else
			{			
				updateTxt();
			}
		}
		private function updateTxt():void
		{
			if(txt)
			{
				var str:String;
				switch(type)
				{
					case Seconds:
//						txt.htmlText=prefix+tCount+suffix;
						str=prefix+tCount+suffix;
						break;
					case MinutesSeconds:
						//						txt.htmlText=prefix+tCount+suffix;
						str=prefix+StringToolsLib.secondsToStandardMS(tCount)+suffix;
						break;
					default:
//						txt.htmlText=prefix+StringToolsLib.secondsToStandard(tCount)+suffix;
						str=prefix+StringToolsLib.secondsToStandard(tCount)+suffix;
				}
//				txt.htmlText=prefix+StringToolsLib.secondsToStandard(tCount)+suffix;
				if(html)
				{
					txt.htmlText=str;
				}else
				{
					txt.text=str;
				}
			}
		}
		private function timeEnd():void
		{
			Trigger.removeSecondTrigger(timeH);
			if(txt&&autoHide) txt.visible=false;
			if(tBackFun!=null)
			{
				tBackFun();
				tBackFun=null;
			}
		}
		
		/**
		 * 添加倒计时文本控制 
		 * @param txt 要控制的倒计时文本框
		 * @param prefix 倒计时文本前缀
		 * @param sufix 倒计时文本后缀
		 * @return 控制类
		 * 
		 */
		public static function wrapTimeCount(txt:TextField,prefix:String="倒计时:",sufix:String="",type:int=HourMinutesSeconds):TimeCountWraper
		{
			var rst:TimeCountWraper;
			rst=new TimeCountWraper;
			rst.txt=txt;
			rst.prefix=prefix;
			rst.suffix=sufix;
			rst.type=type;
			return rst;
		}
	}
}