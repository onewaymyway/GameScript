package com.tg.display
{
	import com.tg.text.Lang;

	public class TimeChange extends Object
	{
		public static const lastDay:String = TimeChangeLang.OutOfSeven;
		
		public static function timeFormat(param1:Object, param2:Boolean = true, param3:Boolean = true) : Object
		{
			var _loc_4:* = new Date(param1.startTime * 1000);
			var _loc_5:* = new Date(param1.endTime * 1000);
			var _loc_6:String = "";
			if (param2)
			{
				
			}
			if (param3)
			{
				_loc_6 = " - ";
			}
			var _loc_7:String = "";
			if (param2)
			{
				_loc_7 = _loc_7 + (_loc_4.hours + ":" + hoursFormat(_loc_4.minutes));
			}
			_loc_7 = _loc_7 + _loc_6;
			if (param3)
			{
				_loc_7 = _loc_7 + (_loc_5.hours + ":" + hoursFormat(_loc_5.minutes));
			}
			return {openTime:_loc_7, time:_loc_4.hours + "." + _loc_4.minutes};
		}
		
		public static function hoursFormat(param1:Number) : String
		{
			var _loc_2:String = null;
			if (param1 < 10)
			{
				_loc_2 = "0" + param1;
			}
			else
			{
				_loc_2 = param1 + "";
			}
			return _loc_2;
		}
		
		public static function countStr(param1:String) : int
		{
			var _loc_2:int = 0;
			var _loc_3:* = param1.length;
			var _loc_4:int = 0;
			while (_loc_4 < _loc_3)
			{
				
				if (param1.charCodeAt(_loc_4) > 127)
				{
					_loc_2 = _loc_2 + 2;
				}
				else
				{
					_loc_2 = _loc_2 + 1;
				}
				_loc_4 = _loc_4 + 1;
			}
			return _loc_2;
		}
		
		public static function mainTimerDate(param1:Number, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true, param6:Boolean = true, param7:Boolean = true, param8:String = "") : String
		{
			var _loc_12:String = null;
			var _loc_13:String = null;
			var _loc_14:String = null;
			var _loc_15:String = null;
			var _loc_16:String = null;
			var _loc_17:String = null;
			var _loc_9:* = new Date(param1 * 1000);
			var _loc_10:Array = [];
			var _loc_11:String = "";
			if (param2)
			{
				_loc_12 = hoursFormat(_loc_9.fullYear);
				_loc_11 = _loc_11 + (_loc_12 + TimeChangeLang.Year);
				_loc_10.push(_loc_12);
			}
			if (param3)
			{
				_loc_13 = hoursFormat((_loc_9.month + 1));
				_loc_11 = _loc_11 + (_loc_13 + TimeChangeLang.Month);
				_loc_10.push(_loc_13);
			}
			if (param4)
			{
				_loc_14 = hoursFormat(_loc_9.getDate());
				_loc_11 = _loc_11 + (_loc_14 + TimeChangeLang.Date);
				_loc_10.push(_loc_14);
			}
			if (param5)
			{
				_loc_15 = hoursFormat(_loc_9.hours);
				_loc_11 = _loc_11 + (_loc_15 + TimeChangeLang.Hour);
				_loc_10.push(_loc_15);
			}
			if (param6)
			{
				_loc_16 = hoursFormat(_loc_9.minutes);
				_loc_11 = _loc_11 + (_loc_16 + TimeChangeLang.Minute);
				_loc_10.push(_loc_16);
			}
			if (param7)
			{
				_loc_17 = hoursFormat(_loc_9.seconds);
				_loc_11 = _loc_11 + (_loc_17 + TimeChangeLang.Second);
				_loc_10.push(_loc_17);
			}
			if (param8.length >= 1)
			{
				_loc_11 = _loc_10.join(param8);
			}
			return _loc_11;
		}
		
		public static function timerToNum(param1:Number) : String
		{
			var _loc_2:* = new Date(param1 * 1000);
			var _loc_3:* = hoursFormat(_loc_2.hours) + "." + hoursFormat(_loc_2.minutes);
			return _loc_3;
		}
		
		public static function timerInfo(param1:Number, param2:Number, param3:String = "Current") : String
		{
			if (param3 == "Current") 
			{
				param3 = TimeChangeLang.Current;
			}
			var timeDiff:Number=param2 - param1;
			var day:int=timeDiff / 86400;
			var hour:int=timeDiff / 3600;
			var min:int=timeDiff / 60;
			if (day >= 7) 
			{
				return lastDay;
			}
			if (day >= 2 && day < 7) 
			{
				return Lang.sprintf(TimeChangeLang.DaysAgo, day);
			}
			if (day >= 1) 
			{
				return TimeChangeLang.Yesterday;
			}
			if (hour >= 1) 
			{
				return Lang.sprintf(TimeChangeLang.HoursAgo, hour);
			}
			if (min >= 30) 
			{
				return TimeChangeLang.HalfHourAgo;
			}
			if (min <= 0) 
			{
				return param3;
			}
			return Lang.sprintf(TimeChangeLang.MinutesAgo, min);
		}
		
		public static function diffTimerInfo(param1:Number, param2:Number) : Object
		{
			var _loc_3:* = new Date(param1 * 1000);
			var _loc_4:* = new Date(param2 * 1000);
			var _loc_5:* = _loc_4.getDate() - _loc_3.getDate();
			var _loc_6:* = _loc_4.hours - _loc_3.hours;
			var _loc_7:* = _loc_4.minutes - _loc_3.minutes;
			var _loc_8:Object = {};
			_loc_8.date = _loc_5;
			_loc_8.hours = _loc_6;
			_loc_8.minutes = _loc_7;
			return _loc_8;
		}
		
		public static function mainTime(param1:int, param2:String, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true) : String
		{
			var _loc_6:* = param1;
			var _loc_7:int = 0;
			var _loc_8:int = 0;
			var _loc_9:int = 0;
			var _loc_10:String = "";
			var _loc_11:String = "";
			var _loc_12:String = "";
			if (_loc_6 / 3600 > 0)
			{
				_loc_7 = Math.floor(_loc_6 / 3600);
				_loc_6 = _loc_6 - _loc_7 * 3600;
			}
			if (_loc_6 / 60 > 0)
			{
				_loc_8 = Math.floor(_loc_6 / 60);
				_loc_6 = _loc_6 - _loc_8 * 60;
			}
			_loc_9 = _loc_6;
			_loc_10 = hoursFormat(_loc_7);
			_loc_11 = hoursFormat(_loc_8);
			_loc_12 = hoursFormat(_loc_9);
			var _loc_13:Array = [];
			if (param3)
			{
				_loc_13.push(_loc_10);
			}
			if (param4)
			{
				_loc_13.push(_loc_11);
			}
			if (param5)
			{
				_loc_13.push(_loc_12);
			}
			if (_loc_7 >= 72)
			{
				return TimeChangeLang.ThreeDaysLater;
			}
			if (_loc_7 >= 48)
			{
			}
			if (_loc_7 < 72)
			{
				return TimeChangeLang.Acquired;
			}
			if (_loc_7 >= 24)
			{
			}
			if (_loc_7 < 48)
			{
				return TimeChangeLang.Tomorrow;
			}
			var _loc_14:* = _loc_13.join(param2);
			return _loc_14;
		}
		
		public static function mainTime2(param1:int, param2:String, param3:Boolean = false, param4:Boolean = true, param5:Boolean = true, param6:Boolean = true) : Array
		{
			var _loc_7:* = param1;
			var _loc_8:int = 0;
			var _loc_9:int = 0;
			var _loc_10:int = 0;
			var _loc_11:String = "";
			var _loc_12:String = "";
			var _loc_13:String = "";
			if (_loc_7 / 3600 > 0)
			{
				_loc_8 = Math.floor(_loc_7 / 3600);
				_loc_7 = _loc_7 - _loc_8 * 3600;
			}
			if (_loc_7 / 60 > 0)
			{
				_loc_9 = Math.floor(_loc_7 / 60);
				_loc_7 = _loc_7 - _loc_9 * 60;
			}
			_loc_10 = _loc_7;
			if (param3)
			{
				_loc_11 = hoursFormat(_loc_8);
				_loc_12 = hoursFormat(_loc_9);
				_loc_13 = hoursFormat(_loc_10);
			}
			else
			{
				_loc_11 = _loc_8 + "";
				_loc_12 = _loc_9 + "";
				_loc_13 = _loc_10 + "";
			}
			var _loc_14:Array = [];
			if (param4)
			{
				_loc_14.push(_loc_11);
			}
			if (param5)
			{
				_loc_14.push(_loc_12);
			}
			if (param6)
			{
				_loc_14.push(_loc_13);
			}
			return _loc_14;
		}
		
	}
}