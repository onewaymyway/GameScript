package com.tg.systemMessage.event
{
	import flash.events.Event;
	
	/**
	 * @author hdz
	 *
	 * @date 2014-2-14
	 **/
	
	public class MsgEvent extends Event
	{
		public static const remove:String = "remove";
		public var obj:Object;
		
		public function MsgEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}