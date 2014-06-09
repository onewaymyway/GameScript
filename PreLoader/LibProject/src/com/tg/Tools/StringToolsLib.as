package com.tg.Tools
{
	/**
	 * 一些常用的字符串函数
	 * @author ww
	 * 
	 */
	public class StringToolsLib
	{
		public function StringToolsLib()
		{
		}
		/**
		 * 返回数的定宽的字符串 
		 * @param num
		 * @param width
		 * @param c
		 * @return 
		 * 
		 */
		public static function numToFixString(num:int,width:int,c:String="0"):String
		{
			var rst:String;
			rst=num.toString();
			if(rst.length<width)
			{
				while(rst.length<width)
				{
					rst=c+rst;
				}
			}
			return rst;
		}
		
		
		public static const minute:int=60;
		public static const hour:int=60*minute;
		public static const fullDaySeconds:int=hour*24;
		/**
		 * 根据秒获取时间 02:59:30 
		 * @param sec
		 * @return 
		 * 
		 */
		public static function secondsToStandard(sec:Number):String
		{
		    return numToFixString(sec/hour,2)+":"+numToFixString((sec%hour)/minute,2)+":"+numToFixString(sec%minute,2);	
		}
		
		/**
		 * 根据秒获取时间 22:11 
		 * @param sec
		 * @return 
		 * 
		 */
		public static function secondsToStandardMS(sec:Number):String
		{
			return numToFixString((sec%hour)/minute,2)+":"+numToFixString(sec%minute,2);	
		}
		/**
		 * 获取当天已过的秒数
		 * @return 
		 * 
		 */
		public static function getTodaySeconds():Number
		{
			var d:Date=new Date;
			return d.hours*hour+d.minutes*minute+d.seconds;
		}
		public static function getTimeByArr(arr:Array):String
		{
			return arr[0]+"："+arr[1]+"-"+arr[2]+"："+arr[3];
		}
		public static function getTimeByStr(str:String):String
		{
			return getTimeByArr(str.split("|"));
		}
		public static function getDateTxt(sec:Number):String
		{
			var d:Date=new Date;
			d.time=sec*1000;
			return d.fullYear+"-"+(d.month+1)+"-"+d.date;
		}
		public static function getStandardHMTxt(sec:Number):String
		{
			var d:Date=new Date;
			d.time=sec*1000;
			return d.hours+":"+d.minutes;
		}
		/**
		 * 获取当天剩余的秒数
		 * @return 
		 * 
		 */
		public static function getTodayLeftSeconds():Number
		{
			return fullDaySeconds-getTodaySeconds();
		}
		
	   /**
	    * 获取当天当时的时间字符串 
	    * @return 
	    * 
	    */
	   public static function getTodayTimeString():String
	   {
		   return secondsToStandard(getTodaySeconds());
	   }
	   
	   /**
		* 获取当天剩余的时间字符串 
		* @return 
		* 
		*/
	   public static function getTodayLeftTimeString():String
	   {
		   return secondsToStandard(getTodayLeftSeconds());
	   }
	   
	   /**
	    * 获取当前的time，单位秒 
	    * @return 
	    * 
	    */
	   public static function getUTime():Number
	   {
		   var tDate:Date;
		   tDate=new Date();
		   return int(tDate.time*0.001);
	   }
	   
	   /**
	    * 返回图片地址的文件名 
	    * @param picPath
	    * @return 
	    * 
	    */
	   public static function getPicPreName(picPath:String):String
	   {
		   var i:int;
		   i=picPath.indexOf(".");
		   return picPath.substring(0,i);
	   }
	   /**
		* 将数字转换成 三位分字符串 如 123456=>123,456 
		* @param num
		* @return 
		* 
		*/		
	   public static function numToString(num:int):String
	   {
		   var tStr:String="";
		   if(num<=0) return String(num);
		   var tNum:String;
		   //var rest:int;
		   while(num>=1000)
		   {
			   tNum=(num%1000).toString();
			   if(tNum.length<2)
			   {
				   tNum="00"+tNum;
			   }
			   else
				   if(tNum.length<3)
				   {
					   tNum="0"+tNum;
				   }
			   
			   
			   if(tStr=="")
			   {
				   tStr=tNum;	
			   }
			   else
			   {
				   tStr=tNum+","+tStr;
			   }
			   num=num/1000;
		   }
		   if(tStr=="")
		   {
			   tStr=int(num).toString();	
		   }
		   else
		   {
			   tStr=int(num)+","+tStr;
		   }
		   return tStr;
	   }
	   /**
		* 获取最大页数 
		* @param nPerPage 每页条数
		* @param itemCount 总共条数
		* @return 
		* 
		*/		
	   public static function getMaxPage(nPerPage:int,itemCount:int):int
	   {
		   if(itemCount==0) return 1;
		   if(nPerPage==0) return 999;
		   var rst:int;
		   rst=int(itemCount/nPerPage);
		   if(rst*nPerPage<itemCount) rst++;
		   return rst;
	   }
	   /**
		* 获取格式化的货币信息 
		* @param money
		* @return 
		* 
		*/		
	   public static  function getMoneyText(money:Number):String
	   {
		   var tM:int;
		   tM=money/100000000;
		   if(tM>0) return tM+"亿";
		   tM=money/10000;
		   if(tM>0) return tM+"万";
		   return String(money);
	   }
	   /**
		* 获取小的数 
		* @param a
		* @param b
		* @return 
		* 
		*/		
	   public static function Min(a:Number,b:Number):Number
	   {
		   return a<b? a:b;
	   }
	   /**
		* 获取大的数 
		* @param a
		* @param b
		* @return 
		* 
		*/		
	   public static function Max(a:Number,b:Number):Number
	   {
		   return a>b? a:b;
	   }
	   /**
		* 替换文本 
		* @param str
		* @param oStr
		* @param nStr
		* @return 
		* 
		*/
	   public static function getReplace(str:String,oStr:String,nStr:String):String
	   {
		   var rst:String;
		   rst=str.replace(new RegExp(oStr, "g"),nStr);
		   return rst;
	   }
	   /**
	    * 去除不可见字符
	    * @param str
	    * @return 
	    * 
	    */
	   public static function TrimUnsee(str:String):String
	   {
		   var rst:String;
		   rst=getReplace(str," ","");
		   rst=getReplace(rst,"\r","");
		   rst=getReplace(rst,"\n","");
		   return rst;
	   }
	   
	   /**
	    * 获取非负值 
	    * @param value
	    * @return 
	    * 
	    */
	   public static function getPValue(value:int):int
	   {
		   if(value<0) return 0;
		   return value;
	   }
	   
	   /**
	    * 获取百分数
	    * @param tValue
	    * @param maxValue
	    * @return 
	    * 
	    */
	   public static function getPercent(tValue:int,maxValue:int):int
	   {
		   var resPer:int = tValue / maxValue * 100;
		   if(resPer<0) resPer=0;
		   if(resPer>100) resPer=100;
		   return resPer;
	   }
	   
	   /**
	    * 获取字符串中分隔出的第一个元素
	    * @param str
	    * @param split
	    * @return 
	    * 
	    */
	   public static function getPreValue(str:String,split:String):String
	   {
		   return str.split(split)[0];
	   }
	   /**
	    * 向字符串中插入行
	    * @param str
	    * @param iStr
	    * @param line
	    * @return 
	    * 
	    */
	   public static function insertLine(str:String,iStr:String,line:int=0):String
	   {
		   var lArr:Array;
		   lArr=str.split("\n");
		   lArr.splice(line,0,iStr);
		   return lArr.join("\n");
	   }
	}
}