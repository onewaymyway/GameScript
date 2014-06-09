package  com.tg.component
{
	import com.tg.Trigger;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 *倒计时组件
	 * @author Hdz
	 * 
	 */
	public class CountDown extends Sprite
	{
		private var resName:String;
		private var linkName:String;
		private var myView:MovieClip;
		
		/***倒计时的TextField***/
		private var countDownT:TextField;
		
		/***上次执行的时间***/
		private var lestTimer:int;
		/***每次的间隔***/
		private var gapTimer:int = 1000;
		
		/***剩余时间***/
		private var timer:uint = 0;
		/***当时间到为0时 回调的事件   改事件***/
		private var fun:Function
		
		/***加速按钮***/
		private var speedUpbtn:Sprite
		
		/***加速点击事件***/
		private var speedUpClickFun:Function;
		
		/** 倒计时后的提示 */
		private var tishi:String = "";
		/**获取时间文本*/
		public function get text():TextField
		{
			return this.countDownT;
		}
		/**
		 * 获取当前倒计时时间 
		 * @return 
		 * 
		 */		
		public function get Timer():int
		{
			return timer;
		}
		
		public function CountDown(size:int = 17,showBj:Boolean = true,_tishi:String = "",color:uint = 0xffffff)
		{
			this.linkName = "button";
			tishi = _tishi;
			var text_F:TextFormat = new TextFormat();
			text_F.font = "微软雅黑";
			text_F.size = size;
			text_F.bold = true;
			text_F.color = color;
			countDownT = new TextField();
			countDownT.selectable = countDownT.mouseEnabled = countDownT.mouseWheelEnabled = false;
			countDownT.textColor = 0;
			countDownT.setTextFormat(text_F);
			countDownT.defaultTextFormat = text_F;
			countDownT.width = 100;
			countDownT.height = 50;
			this.addChild(countDownT);
			
			speedUpbtn = button;
			this.addChild(speedUpbtn);
			speedUpbtn.x = countDownT.x + countDownT.width;
			speedUpbtn.y = countDownT.y+5;
			
			
			var sp1:Sprite = new Sprite();
			this.addChildAt(sp1,0);
			sp1.visible = showBj
			sp1.graphics.beginFill(0,0.5);
			sp1.graphics.drawRoundRect(-10,3,103,20,5);
			
			
		}
		private function get button():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(2,0xd9b58c);
			
			s.graphics.moveTo(0,0);
			s.graphics.lineTo(5*1.5,4.8*1.5);
			s.graphics.lineTo(0,9.6*1.5);
			
			s.graphics.moveTo(8,0);
			s.graphics.lineTo(5*1.5+8,4.8*1.5);
			s.graphics.lineTo(8,9.6*1.5);
			s.scaleX = .8;
			s.scaleY = .8;
			s.buttonMode = true;
			
			var s1:Sprite = new Sprite();
			s1.graphics.beginFill(0,0);
			s1.graphics.drawRect(0,0,19,19);
			s1.graphics.endFill();
			s.addChild(s1);
			
			return s;
		}
		
		
		/***开始倒计时***/
		public function start():void{
			lestTimer = 0;
			this.visible = true;
//			if(this.hasEventListener(Event.ENTER_FRAME) == false){
//				this.addEventListener(Event.ENTER_FRAME,upData);
//			}
			//Trigger.removeSecondTrigger(upData);
			
		}
		
		private static var first:Boolean = true;
		private static var lastTime:int = 0;
		private static var leftTime:int = 0;
		
		/**
		 * 更新时间 
		 * @param event
		 * 
		 */		
		protected function upData():void
		{
//			var currentTime:int = (new Date()).time;
//			
//			if(first)
//			{
//				lastTime = currentTime;
//				first = false;
//				leftTime = 0;
//			}
//			else
//			{
//				var past:int = currentTime - lastTime + leftTime;
//				if(past >= 1000)
//				{
//					leftTime = past - 1000;
//					lastTime = currentTime;
//					
					
					if(timer <= 0 ){
						countDownT.text = "00:00:00"+tishi;
						this.stop();
						isStop = true;
						return;
					}
					countDownT.text = this.countTimer(timer);
					timer--;
					countDownT.width = countDownT.textWidth+5;
					speedUpbtn.x = countDownT.x + countDownT.width;
					speedUpbtn.y = countDownT.y + 5+2;
					
//				}
//			}
		}
		
		/****根据秒数计算时间***/
		private function countTimer(_msec:uint):String
		{
			var hour:int = _msec / 3600;
			var minute:int = (_msec / 60)%60;
			var second:int = _msec % 60;
			
			var hourS:String;
			if(hour >= 154 || hour == 0)
			{
				hourS = "00";
			}
			else
			{
				if(hour < 10)
				{
					hourS = "0" + hour; 
				}
				else
				{
					hourS = hour + "";
				}
			}
			//分钟
			var minuteS:String;
			if(minute >= 60 || minute == 0)
			{
				minuteS = "00";
			}
			else
			{
				if(minute < 10)
				{
					minuteS = "0" + minute; 
				}
				else
				{
					minuteS = minute + "";
				}
			}
			
			var secondS:String = second < 10 ? "0"+""+second : second+"";
			
//			if(hour >=24){
//				return (int(hour / 24))+"天";
//			}
			
			return hourS+":"+minuteS+":"+secondS+tishi;
			
		}
		
		/***设置时间停止时回调的方法***/
		public function setStopFun(_fun:Function):void{
			fun = _fun;
		}
		
		/**
		 * 设置时间  毫秒数 
		 * @param _timer
		 * 
		 */		
		public function setTimer(_timer:uint):void
		{
			timer = _timer / 1000;
			countDownT.text = this.countTimer(timer);
			
			countDownT.width = countDownT.textWidth+5;
			speedUpbtn.x = countDownT.x + countDownT.width;
			speedUpbtn.y = countDownT.y+5;
			Trigger.addSecondTrigger(upData);
		}
		public var isStop:Boolean = false;
		/***停止倒计时***/
		public function stop():void{
			
			isStop = true;
			if(fun != null){
				fun();
			}
//			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				this.visible = false;
				Trigger.removeSecondTrigger(upData);
//				this.removeEventListener(Event.ENTER_FRAME,upData);
			}
		}
		
		/**这里指支持 TextFormat 设置样式 不支持htmls*/
		public function setTimerTextFormat(_textFormat:TextFormat):void
		{
			countDownT.setTextFormat(_textFormat);
			countDownT.defaultTextFormat = _textFormat;
		}
		/**
		 *  设置点击加速按钮后的回调事件 
		 * 
		 *   只有在现实按钮的情况下才可以设置
		 * @param fun
		 * 
		 */		
		public function addButtonClick(fun:Function):void{
			if(fun == null || speedUpbtn == null){
				return;
			}
			speedUpClickFun = fun;
			speedUpbtn.addEventListener(MouseEvent.CLICK,speedUpClickFun);
		}
		
		/**显示或隐藏加速按钮
		 * @param bool 隐藏或显示
		 * */
		public function showUpBtn(bool:Boolean):void{
			if(bool ){
				speedUpbtn.visible = false;
			}
			else
			{
				speedUpbtn.visible = true;
			}
		}
		
		/***获取加速按钮**/
		public function getSpeedUpbtn():Sprite{
			return speedUpbtn;
		}
		
		/***清除本类****/
		public function clean():void{
			/****如果 加速按钮有事件的话 清除事件****/
			if(speedUpbtn && speedUpbtn.hasEventListener(MouseEvent.CLICK)){
				speedUpbtn.removeEventListener(MouseEvent.CLICK,speedUpClickFun);
			}
			/***清除时间事件***/
			this.stop();
			/***清除本类的显示***/
			while(this.numChildren){
				this.removeChildAt(0);
			}
			//countDownT = null;
			//speedUpbtn = null;
			fun = null;
		}
	}
}