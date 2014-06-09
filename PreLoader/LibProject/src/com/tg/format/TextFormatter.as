package com.tg.format
{
	public class TextFormatter
	{
		public static const YEAR_MONTH_DAY:String = "yy-MM-dd hh:mm:ss";
		
		/**
		 * 格式化时间为日期
		 * @param 		time			毫秒，自1970年
		 * @param 		formatter		目标串格式方式
		 */
		public static function formatDate(time:Number, formatter:String = YEAR_MONTH_DAY):String
		{
			var date:Date = new Date();
			date.time = time;
			
			var result:String = date.fullYear + "-" + (date.month + 1)+ "-" + date.date + " "
				+ date.hours + ":" + date.minutes + ":" + date.seconds;//date.;
			
			return result;
		}
		
		/**
		 * 格式化时间为文本串
		 * @param 		time			毫秒数
		 * @param 		formatter		目标串格式方式
		 */
		public static function formatMileSecond(time:Number, formatter:String = YEAR_MONTH_DAY):String
		{
			var tmpTime:Number = time;
			
			// 秒
			tmpTime = tmpTime / 1000;
			var second:int = tmpTime % 60;
			
			// 分
			tmpTime = tmpTime / 60;
			var minute:int = tmpTime % 60;
			
			// 时
			tmpTime = tmpTime / 60;
			var hour:int = tmpTime;
			
			return ((hour > 9) ? (hour.toString()) : ("0" + hour.toString())) + ":" + 
				((minute > 9) ? (minute.toString()):("0" + minute.toString())) + ":" +
				((second > 9) ? (second.toString()):("0" + second.toString()));
		}
	}
}