package com.tg.systemMessage
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.tg.systemMessage.event.MsgEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
//	import flash.text.TextFieldAutoSize;
//	import flash.text.TextFormat;
//	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	/** 系统消息显示类
	 * @author hdz
	 *
	 * @date 2014-2-14
	 **/
	
	public class SystemMessage extends Sprite
	{
		/**消息视图显示的位置:屏幕正上方*/
		public static const LOCATION_TOP:int = 1;
		/**消息视图显示的位置:屏幕正中*/
		public static const LOCATION_CENTER:int = 2;
		/**消息视图显示的位置:屏幕正下方*/
		public static const LOCATION_BOTTOM:int = 3;
		
		/** 用于显示消息的内容 */
		private var text1:TextField;
		
		/** 倒计时显示框
		 * 三秒钟自动消失
		 *  */
		private var text2:TextField;
		public var type:int;
		public static var cla:Class;
		
		public var mc:MovieClip;
		
		public function SystemMessage(str:String = "",iconType:int = 1)
		{
			super();
			
//			graphics.beginFill(0,0.7);
//			graphics.drawRoundRect(0,0,400,100,20,20);
//			graphics.endFill();
//			
//			graphics.lineStyle(3,0xffff00);
//			graphics.drawCircle(5+45 / 2,16+45 / 2,45 / 2);
//			
//			graphics.beginFill(0xffff00);
//			graphics.drawEllipse(25,22,4,23);
//			
//			graphics.drawCircle(25+2,51+3,6 / 2);
//			graphics.endFill();
//			
//			text1 = new TextField();
//			var font1:TextFormat = new TextFormat("",16,0xffff00);
//			font1.align = TextFormatAlign.CENTER;  
//			text1.defaultTextFormat = font1;
//			
//			text1.multiline = true;
//			text1.wordWrap = true;
//			text1.selectable = false;
//			text1.autoSize = TextFieldAutoSize.CENTER;
//				
//				
//			text1.text = str;
//			text1.width = 362;
//			text1.height = 43;
//			text1.x = 51;
//			text1.y = 21;
//			
//			
//			text2 = new TextField();
//			var font2:TextFormat = new TextFormat("",12,0xffffff);
//			font2.align = TextFormatAlign.CENTER; 
//			text2.defaultTextFormat = font2;
//			text2.multiline = true;
//			text2.wordWrap = true;
//			text2.selectable = false;
//			text2.autoSize = TextFieldAutoSize.CENTER;
				
//			text2.text = "三秒钟自动消失（3）";
//			text2.width = width;
//			text2.height = text2.textHeight+5;
//			text2.x = 0;
//			text2.y = 76;
			
			
//			this.addChild(text1);
//			this.addChild(text2);
//			
//			this.alpha = 0.3;
			this.mouseEnabled = false;
			mc = new cla();
			mc["tex1"].text = str;
			mc["tex2"].text = "（3）";
			
			if(iconType == 1)
			{
				mc["icon1"].visible = true;
				mc["icon2"].visible = false;
			}
			else
			{
				mc["icon1"].visible = false;
				mc["icon2"].visible = true;
			}
			this.addChild(mc);
			time.addEventListener(TimerEvent.TIMER,updata);
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
		}
		public function beginPlay():void
		{
			TweenLite.to(this, 0.2, {y:this.y-this.height,alpha:1,ease:Linear.easeNone, onComplete:comFun1});
			conNum = maxNum;
		}
		public var time:Timer = new Timer(1000);
		
		public static const maxNum:int = 3;
		public var conNum:int = maxNum;
		
		private function updata(e:Event):void
		{
			conNum--;
			if(conNum >=0)
//			text2.text = "三秒钟自动消失（" + conNum + "）";
			mc["tex2"].text = "（"+conNum+"）";
			if(conNum <= 0)
			{
				time.stop();
				time.removeEventListener(TimerEvent.TIMER,updata);
				TweenLite.to(this, 0.2, {y:this.y-this.height,alpha:0,ease:Linear.easeNone, onComplete:comFun2});
			}
		}		
		private function comFun1():void
		{
			this.alpha = 1;
			time.start();
		}
		private function comFun2():void
		{
			var event:MsgEvent = new MsgEvent(MsgEvent.remove);
			event.obj = this;
			this.dispatchEvent(event);
		}
		private function remove(e:Event):void
		{
			time.stop();
			time.removeEventListener(TimerEvent.TIMER,updata);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,remove);
		}
		
	}
}