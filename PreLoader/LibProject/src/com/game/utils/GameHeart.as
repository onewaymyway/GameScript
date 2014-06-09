package com.game.utils
{
	import org.osflash.signals.Signal;

	public class GameHeart
	{
		
		private const _serverDate:Date = new Date();
		
		private const _scopy:Date = new Date();
		
		private var _signal:Signal;
		
		private static var _instance:GameHeart;
		/**
		 * return copy 
		 * @return 
		 * 
		 */		
		public function get serverDate():Date
		{
			_scopy.time = _serverDate.time;
			return _scopy;
		}

		public static function getInstance():GameHeart
		{
			if (!_instance)
			{
				_instance = new GameHeart();
			}
			return _instance;
		}
		
		public function GameHeart()
		{
			if (_instance)
			{
				throw new Error("this is Singletion")
				return;
			}
			_signal = new Signal();
		}
		
		public function setTime(value:Number):void
		{
			_serverDate.time = value;
			_scopy.time = value;
			signal.dispatch(_scopy);
		}

		public function get signal():Signal
		{
			return _signal;
		}
		
	}
}