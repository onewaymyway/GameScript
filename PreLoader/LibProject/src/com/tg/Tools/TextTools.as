package com.tg.Tools
{
	import com.tg.html.HtmlText;
	import com.tools.ArrayTool;
	
	import flash.events.TextEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 文本框相关的工具 
	 * @author ww
	 * 
	 */
	public class TextTools
	{
		public function TextTools()
		{
		}
		/**
		 * 设置文本颜色 
		 * @param text
		 * @param color
		 * 
		 */
		public static function setTextColor(text:TextField,color:uint):void
		{
			var format:TextFormat;
			format=text.defaultTextFormat;
			format.color=color;
			text.defaultTextFormat=format;
			text.setTextFormat(format);
		}
		
		/**
		 * 设置文本是否加粗
		 * @param text
		 * 
		 */
		public static function setTextBold(text:TextField):void
		{
			var format:TextFormat;
			format=text.defaultTextFormat;
			format.bold=true;
			text.defaultTextFormat=format;
			text.setTextFormat(format);
		}
		
		/**
		 * 设置文本行间距 
		 * @param text
		 * @param leading
		 * 
		 */
		public static function setTextLeading(text:TextField,leading:Number=8):void
		{
			var format:TextFormat;
			format=text.defaultTextFormat;
			format.leading=leading;
			text.defaultTextFormat=format;
			text.setTextFormat(format);
		}
		/**
		 * 设置文本字体 
		 * @param text
		 * @param font
		 * 
		 */
		public static function setTextFont(text:TextField,font:String):void
		{
			
			var format:TextFormat;
			format=text.defaultTextFormat;
			format.font=font;
			text.defaultTextFormat=format;
			text.setTextFormat(format);
			trace("setFont:"+font);
		}
		public static const defaultFontList:Array=["微软雅黑","楷体","楷体_GB2312","宋体"];
		public static const defaultFont:String="宋体";
		/**
		 * 设置文本框字体 
		 * @param text 文本框
		 * @param fontList 想用的字体列表
		 * 
		 */
		public static function setTextFontList(text:TextField,fontList:Array):void
		{
			setTextFont(text,getAvailableFont(fontList));
		}
		
		/**
		 * 获取可用的字体 
		 * @param fontList 想用的字体列表
		 * @return 可用的字体
		 * 
		 */
		public static function getAvailableFont(fontList:Array):String
		{
			var fonts:Array = Font.enumerateFonts(true);
			var fontNameList:Array=[];
			for (i = 0; i < fonts.length; i++) 
			{
				trace(fonts[i].fontName);
				fontNameList.push(fonts[i].fontName);
			}
			var tFont:String;
			var i:int;
			var len:int;
			len=fontList.length;
			for(i=0;i<len;i++)
			{
				tFont=fontList[i];
				if(!ArrayTool.isDistict(fontNameList,tFont))
				{
					return tFont;
				}
			}


			return defaultFont;
		}
//		"<a href='event:" + eventName + "'><u>" + text + "</u></a>";
		/**
		 * 触发文本框的linkEvent 
		 * @param txt
		 * 
		 */
		public static function linkEvent(txt:TextField):void
		{
			var evt:TextEvent;
			evt=new TextEvent(TextEvent.LINK,true);
			evt.text=HtmlText.getLinkTextEvent(txt);
			txt.dispatchEvent(evt);
		}
		
		/**
		 * 创建指定event名称的链接类型HTML文本
		 * @param text 文本内容
		 * @param eventName 链接的event属性值
		 */
		public static function linkText(text:String, eventName:String):String 
		{
			return "<a href='event:" + eventName + "'><u>" + text + "</u></a>";
		}
		
		private static var cText:TextField=new TextField;
		public static function getPlainText(text:String):String
		{
		  cText.htmlText=text;
		  return cText.text;
		}
		public static function getColorText(text:String, color:uint = 0):String
		{
			var fontAttr:String = "";
			fontAttr = fontAttr + (" color=\"#" + color.toString(16) + "\"");
			text = "<font" + fontAttr + ">" + text + "</font>";
			return text;
		}
		/**
		 * 获取文本框中的linkEvent 
		 * @param txt
		 * @return 
		 * 
		 */
		public static function getLinkTextEvent(txt:TextField):String
		{
			var rst:String;
			rst="unknow";
			var htmlStr:String;
			htmlStr=txt.htmlText;
			var tT:String;
			tT="<A HREF=\"event:";
			
			var eT:String;
			eT="\"";
			
			var tI:int;
			var eI:int;
			var sI:int;
			tI=htmlStr.indexOf(tT);
			sI=tI+tT.length;
			if(tI>=0)
			{
				
				eI=htmlStr.indexOf(eT,sI);
				if(eI>=0)
				{
					rst=htmlStr.substring(sI,eI);
				}
			}
			
			return rst;
		}
		
		
		public static function getATextField(width:Number,height:Number):TextField
		{
			//调试输出文本
			var rst:TextField;
			rst=new TextField;
			rst.y=0;
			rst.width=width;
			rst.height=height;
			rst.multiline=true;
			rst.wordWrap=true;
			rst.textColor=0xFFFF00;
			rst.background=true;
			rst.backgroundColor=0x000000;
			rst.selectable=true;
			
			return rst;
		}
	}
}