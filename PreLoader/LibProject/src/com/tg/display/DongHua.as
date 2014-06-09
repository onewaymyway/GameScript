package com.tg.display
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;

	public class DongHua extends Sprite
	{
		public function DongHua()
		{
			
		}
		public function start():void
		{
			TweenLite.to(this, 1, {y:this.y-80,alpha:0.3,ease:Linear.easeNone, onComplete:comFun1});
		}
		public function comFun1():void
		{
			try
			{
				this.parent.removeChild(this);
			}catch(e:Error){
				
			}
		}
	}
}