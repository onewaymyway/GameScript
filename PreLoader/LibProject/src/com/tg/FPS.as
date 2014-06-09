package com.tg
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	

	/**
	 * 帧频率查看
	 * @author hdz
	 * 
	 */
	public class FPS
	{
		private static var container:Sprite;
		
		private static var fpsTxt:TextField;
		private static var memoryTxt:TextField;
		private static var versionTxt:TextField;
		
		private static var timer:Timer
		private static var stage:Stage;
		
		public static const version:String = VER::LABEL;
		
		public function FPS()
		{
			
		}
		
		public static function init(stage:Stage):void
		{
			if(container != null)
				return;
			
			FPS.stage = stage;
			
			container = new Sprite();
			container.mouseChildren = false;
			container.x = 122;
			
			container.graphics.beginFill(0x000000,0.5);
			container.graphics.drawRect(0,0,77,40);
			container.graphics.endFill();
			
			var formatter:TextFormat = new TextFormat();
			formatter.font = "Tahoma";
			formatter.size = 11;
			formatter.color = 0xffffff;
			
			fpsTxt = new TextField();
			fpsTxt.setTextFormat(formatter);
			fpsTxt.defaultTextFormat = formatter
			fpsTxt.height = 18;
			//fpsTxt.filters = [new GlowFilter(0x000000, 1, 2, 2, 2)];
			container.addChild(fpsTxt);
			
			memoryTxt = new TextField;
			memoryTxt.setTextFormat(formatter);
			memoryTxt.defaultTextFormat = formatter
			memoryTxt.y = 13;
			memoryTxt.height = 18;
			//memoryTxt.filters = [new GlowFilter(0x000000, 1, 2, 2, 2)];
			container.addChild(memoryTxt);
			
			versionTxt = new TextField();
			versionTxt.setTextFormat(formatter);
			versionTxt.defaultTextFormat = formatter
			versionTxt.text = "version:  " + version;
			versionTxt.y = 26;
			versionTxt.height = 18;
			versionTxt.setTextFormat(formatter);
			//versionTxt.filters = [new GlowFilter(0x000000, 1, 2, 2, 2)];
			container.addChild(versionTxt);
			container.x = 0;
			container.y = 0;
			stage.addChild(container);
			
			// ----- 机制初始化
			container.addEventListener(Event.ENTER_FRAME, enterframe);
			container.buttonMode = true;
			container.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			container.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			//Tip.addTargetTip(container,"可以拖动我");
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
		}
		public static function mouseDown(e:MouseEvent):void
		{
			container.startDrag();
		}
		public static function mouseUp(e:MouseEvent):void
		{
			container.stopDrag();
		}
		
		private static var realFrameSpeed:int;
		private static var countPerSecond:Number = 0;
		
		/**
		 * 每秒汇总一次，该秒内帧数
		 */		
		private static function onTimer(e:Event):void
		{
			realFrameSpeed = countPerSecond;
			countPerSecond = 0;
		}
		
		/**
		 * 帧改变执行 
		 * 如果丢帧，则导致countPerSecond累计减少
		 */	
		private static function enterframe(e:Event):void
		{
			countPerSecond++;
			
			if (stage)
			{
				fpsTxt.text = "FPS:  " + realFrameSpeed + " / " + stage.frameRate;
				memoryTxt.text = "mem:" + (System.totalMemory / 1024 / 1024).toFixed(2) + "MB";
			}
		}
	}
}

