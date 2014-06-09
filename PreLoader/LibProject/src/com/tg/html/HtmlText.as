package com.tg.html
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class HtmlText extends Object
	{
		public static const Yellow1:uint  = 0xFFFF00;
		public static const Yellow2:uint = 0xFFF200;
		public static const Yellow3:uint = 0xEB6100;
		
		public static const Green1:uint  = 0x00FF00;
		public static const Green2:uint  = 0x009944;
		
		public static const Blue1:uint   = 0x0000FF;
		public static const Blue2:uint   = 0x00AEEF;
		
		public static const Gray1:uint   = 0x666666;
		public static const Gray2:uint   = 0x999999;
		
		public static const White:uint   = 0xFFFFFF;
		public static const Red:uint     = 0xFF0000;
		public static const Orange:uint  = 0xF7941D;
		public static const Purple:uint  = 0xFF00FF;
		
		public static function yellow1(string:String, 
									   fontSize:uint = 12) : String
		{return format(string, Yellow1,fontSize);}
		public static function yellow2(string:String, 
									   fontSize:uint = 12) : String
		{return format(string, Yellow2,fontSize);}
		public static function yellow3(string:String, 
									   fontSize:uint = 12) : String
		{return format(string, Yellow3,fontSize);}
		
		public static function green1(string:String, 
									  fontSize:uint = 12) : String
		{return format(string, Green1,fontSize);}
		public static function green2(string:String, 
									  fontSize:uint = 12) : String
		{return format(string, Green2,fontSize);}
		
		public static function blue1(string:String, 
									 fontSize:uint = 12) : String
		{return format(string, Blue1,fontSize);}
		public static function blue2(string:String, 
									 fontSize:uint = 12) : String
		{return format(string, Blue2,fontSize);}
		
		public static function gray1(string:String, 
									 fontSize:uint = 12) : String
		{return format(string, Gray1,fontSize);}
		public static function gray2(string:String, 
									 fontSize:uint = 12) : String
		{return format(string, Gray2,fontSize);}
		
		public static function white(string:String, 
									 fontSize:uint = 12) : String
		{return format(string, White,fontSize);}
		
		public static function red(string:String, 
								   fontSize:uint = 12) : String
		{return format(string, Red,fontSize);}
		
		public static function orange(string:String, 
									  fontSize:uint = 12) : String
		{return format(string, Orange,fontSize);}
		
		public static function purple(string:String, 
									  fontSize:uint = 12) : String
		{return format(string, Purple,fontSize);}
		
		/**
		 * 
		 * @param text		待包装文本
		 * @param color			文字背景色
		 * @param fontSize		字体大小
		 * @param fontFace		字体外观
		 * @param bold			粗体
		 * @param italic		斜体
		 * @param underline		下划线
		 * @param url			超链接
		 * @param align			对齐方式
		 */
		public static function format(text:String, color:uint = 0, 
									  fontSize:uint = 12, fontFace:String = "", 
									  bold:Boolean = false, italic:Boolean = false, underline:Boolean = false, 
									  url:String = null, align:String = null) : String
		{
			// bold, italic, underline
			if (bold)
				text = "<b>" + text + "</b>";
			if (italic)
				text = "<i>" + text + "</i>";
			if (underline)
				text = "<u>" + text + "</u>";
			
			// font
			var fontAttr:String = "";
			if (fontFace)
				fontAttr = fontAttr + (" face=\"" + fontFace + "\"");
			if (fontSize > 0)
				fontAttr = fontAttr + (" size=\"" + fontSize + "\"");
			fontAttr = fontAttr + (" color=\"#" + color.toString(16) + "\"");
			text = "<font" + fontAttr + ">" + text + "</font>";
			
			// href, align
			if (url)
				text = "<a href=\"" + url + "\" target=\"_blank\">" + text + "</a>";
			if (align)
				text = "<p align=\"" + align + "\">" + text + "</p>";
			
			return text;
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
	}
}