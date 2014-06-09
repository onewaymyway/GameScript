package com.tg.console
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Console
	{
		public static var consoleLayer:Sprite;
		private static var textComp:TextField;
		
		private static var shown:Boolean = false;
		
		public static function init(layer:Sprite):void
		{
			consoleLayer = layer;
			createComp();
		}
		
		public static function switchStatus():void
		{
			if(shown)
				hide();
			else
				show();
		}
		
		public static function show():void
		{
			shown = true;
			if(consoleLayer == null)
				return;	
			
			if(textComp == null)
				createComp();
			
			consoleLayer.addChild(textComp);
		}
		
		public static function hide():void
		{
			shown = false;
			if(textComp == null || consoleLayer == null)
				return;	
			if(!consoleLayer.contains(textComp))
				return;
			
			consoleLayer.removeChild(textComp);
		}
		
		public static function output():void
		{
			if(textComp == null || consoleLayer == null)
				return;
			
			trace(textComp.text);
		}
		
		public static function clear():void
		{
			if(textComp == null)
				return;
			
			textComp.text = "";
		}
		
		public static function writeLine(text:String):void
		{
			textComp.appendText("\n");
			textComp.appendText(text);
		}
		
		private static function createComp():TextField
		{
			var formatter:TextFormat = new TextFormat();
			formatter.font = "宋体";
			formatter.bold = true;
			formatter.size = 14;
			formatter.color = 0xFF00FF;
			formatter.align = TextFormatAlign.LEFT;
			
			textComp = new TextField();
			textComp.autoSize = TextFieldAutoSize.NONE; 
			textComp.type = TextFieldType.DYNAMIC;
			textComp.wordWrap = true;
			textComp.selectable = true;
			textComp.multiline = true;
			textComp.width = 400;
			textComp.height = 600;
			
			textComp.background = true;
			textComp.backgroundColor = 0xFFFFFF;
			
			//textField.embedFonts = true;
			textComp.defaultTextFormat = formatter;
			
			return textComp;
		}
	}
}