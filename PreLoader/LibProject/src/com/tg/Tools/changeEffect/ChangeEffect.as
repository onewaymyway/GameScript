package com.tg.Tools.changeEffect
{
	import com.greensock.TweenLite;
	import com.tg.Tools.style.StyleLib;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;

	public class ChangeEffect
	{
		public function ChangeEffect(target:DisplayObject,type:int=typeUp,backFun:Function=null)
		{
			this.backFun=backFun;
			this.target=target;
			this.type=type;
			_state=0;
		}
		public static const typeUp:int=0;
		public static const typeDown:int=1;
		public static const typeFlash:int=2;
		
		public static const colorList:Array=
			[
				0x00FF00,
				0xFF0000,
				0xdecb00
			];
		
		private var backFun:Function;
		private var target:DisplayObject;
		
		private var type:int;
		private var _state:int;
		
		public function get effect():int
		{
			return _state;
		}
		public function set effect(state:int):void
		{
			_state=state;
			if(state%2==1)
			{
				target.filters=null;
			}else
			{
				target.filters=[StyleLib.getGlowFilter(colorList[type],2,8,BitmapFilterQuality.LOW,false,false)];
			}
		}
		
		private function complete():void
		{
			target.filters=null;
			target=null;
			if(backFun!=null)
			{
				backFun();
				backFun=null;
			}
		}
		public function playEffect():void
		{
			TweenLite.killTweensOf(this,true);
			TweenLite.to(this,1,{effect:6,onComplete: complete});
		}
		
	}
}