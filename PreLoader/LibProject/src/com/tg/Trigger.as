package com.tg
{
	import flash.display.Stage;
	import flash.events.Event;

	public class Trigger
	{
		private static var stage:Stage;
		
		public static function init(stage:Stage):void
		{
			if(Trigger.stage != null)
				return;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private static function onEnterFrame(ev:Event):void
		{
			onTrigger();
		}
		
		
		////////////////////////////
		// ---------------- 秒触发器
		////////////////////////////
		
		private static var secondTriggerList:Array = new Array();
		
		private static var first:Boolean = true;
		private static var lastTime:int = 0;
		private static var leftTime:int = 0;
		
		private static function onTrigger():void
		{
			//var currentTime:int = getTimer();
			var currentTime:int = (new Date()).time;
			
			if(first)
			{
				lastTime = currentTime;
				first = false;
				leftTime = 0;
			}
			else
			{
				var past:int = currentTime - lastTime + leftTime;
				if(past >= 1000)
				{
					leftTime = past - 1000;
					lastTime = currentTime;
					
					for(var i:int = 0; i < secondTriggerList.length; i++)
					{
						(secondTriggerList[i] as Function)();
					}
				}
			}
		}
		/**
		 * 保证函数没有参数，或者参数有默认值即可 
		 * @param callback
		 * 
		 */		
		public static function addSecondTrigger(callback:Function):void
		{
			if(callback == null)
				return;
			removeSecondTrigger(callback);
			
			secondTriggerList.push(callback);
		}
		public static function removeSecondTrigger(callback:Function):void
		{
			if(callback == null)
				return;
//			if(callback.length != 0)
//				return;
			
			for(var i:int = 0; i < secondTriggerList.length; i++)
			{
				if(callback == secondTriggerList[i])
				{
					secondTriggerList.splice(i, 1);
					break;
				}
			}
			
		}
	}
}