package com.tg.Tools.dataStruct
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.Tools.ShadeTools;
	
	import flash.display.DisplayObject;

	public class AutoTipDes
	{
		public function AutoTipDes()
		{
			eventType=DownClick;
		}
		
		public static const DownClick:int=0;
		public static const Up:int=1;
		
		public var target:*;
		public var tip:DisplayObject;
		public var tipID:int;
		public var time:int=0;
		public var waitTime:int=10;
		public var showWaitTime:int=500;
		public var completeFun:Function;
		public var autoControl:Boolean=true;
		public var force:Boolean=false;
		public var eventType:int=DownClick;
		
		public function callBack():void
		{
			if(completeFun!=null)
			{
				completeFun();
			}
		}
		public function clearTip():void
		{
			DisplayUtil.selfRemove(tip);
		}
		public function clear():void
		{
			if(target)
			{
				if(target.name=="taskContentTxt")
				{
					var i:int;
					i=1;
				}
				trace("clear:"+target.name);
			}
			
			if(force)
				ShadeTools.me().clearShade();
			clearTip();
			completeFun=null;
			tip=null;
			target=null;
		}
	}
}