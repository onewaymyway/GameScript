package com.game.utils
{
	import flash.utils.Dictionary;

	public class AlarmClock
	{
		private static var _instance:AlarmClock;
		
		private var funMap:Dictionary;
		private var dateMap:Dictionary;
		private var _logindate:Date;
		
		public static function getInstance():AlarmClock
		{
			if (!_instance)
			{
				_instance = new AlarmClock();
			}
			return _instance;
		}
		
		public function AlarmClock()
		{
			if (_instance)
			{
				throw new Error("this is Singletion")
				return;
			}
			dateMap = new Dictionary();
			funMap = new Dictionary();
			_logindate = new Date();
			GameHeart.getInstance().signal.add(heartCallBack)
		}
		
		/**
		 * 登陆成功后设置登录成功时的服务器时间 
		 * @param value
		 * 
		 */		
		public function setLoginDate(value:uint):void
		{
			_logindate.time = value * 1000;
			
			/*for (var id:String in dateMap) 
			{
				if (dateMap[id].time <= _logindate.time)
				{
					delete funMap[id];
					delete dateMap[id];
				}
			}*/
		}
		/**
		 * 注册闹钟事件 
		 * @param id 		唯一的名字
		 * @param date  	期望出发时的时间
		 * @param callback 	回调函数
		 * 
		 */		
		public function regist(id:String,date:Date,callback:Function):void
		{
			funMap[id] = callback;
			dateMap[id] = date;
		}
		
		private function heartCallBack(date:Date):void
		{
			for (var id:String in dateMap) 
			{
				if (dateMap[id].time <= date.time)
				{
					Function(funMap[id]).call();
					delete funMap[id];
					delete dateMap[id];
				}
			}
		}

		public function get logindate():Date
		{
			return _logindate;
		}

	}
}