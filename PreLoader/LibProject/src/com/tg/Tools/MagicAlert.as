package com.tg.Tools
{
	
	import com.greensock.TweenMax;
	import com.tg.StageUtil;
	import com.tg.Tools.style.StyleLib;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	


	/**
	 * Magic提示信息类 
	 * @author ww
	 * 
	 */
	public class MagicAlert
	{
		
		public static const DefaultTX:int=99599;
		/**
		 * setTimeout 返回值 
		 */
		private static var _tID:uint;
		/**
		 * 是否在显示中 
		 */		
		private static var isShow:Boolean;
		/**
		 * 当前使用的文本框 
		 */		
		private static var tTxt:TextField;
		/**
		 * 要显示的字符串列表 
		 */		
		private static var TxtList:Array;
		/**
		 * 当前使用的文本框ID 
		 */		
		private static var tTxtID:int=0;
		/**
		 * 文本框初始显示位置Y坐标 
		 */		
		private static var startY:int=260;
		/**
		 * 文本框目标显示位置Y坐标 
		 */		
		private static var endY:int=100;
		/**
		 * 前一个使用的文本框 
		 */		
		private static var pTxt:TextField;
		/**
		 * 文本框的特效背景 
		 */		
		public static var showBackEffect:MovieClip;
		
		public static var tContainer:DisplayObjectContainer;
		
		public function MagicAlert()
		{

		}
		/**
		 * 初始化文本框 
		 * 
		 */		
		private static function initTxt():void
		{
			TxtList=[];
			
			
			var i:int;
			for(i=0;i<2;i++)
			{
				tTxt=new TextField;
				tTxt.mouseEnabled=false;
				tTxt.filters=[StyleLib.black1TipFilter];
				tTxt.multiline=true;
				TxtList.push(tTxt);
			}			
			
		}
		/**
		 * 获取一个文本框 
		 * @return 
		 * 
		 */		
		private static function getTxt():TextField
		{
			pTxt=tTxt;
			
			
			var ttTxt:TextField;
			if(!TxtList) initTxt();
			tTxtID=(tTxtID+1)%2;
			tTxt=TxtList[tTxtID];
			if(tTxt.parent)
			{
				tTxt.parent.removeChild(tTxt);
			}
			TweenMax.killTweensOf(tTxt);
			return TxtList[tTxtID];
		}
		/**
		 * 显示一条蓝字
		 * @param str 显示内容
		 * @param delay 延迟时间
		 * @param target 剧中参照物 默认为舞台剧中
		 * @param dx 剧中横向偏移，仅当target有值时采用
		 * 
		 */
		public static function showMagicAlertStr(str:String,delay:int=0,target:DisplayObject=null,dx:Number=DefaultTX):void
		{
			var tX:Number;
			if(target&&tContainer)
			{
				var rec:Rectangle;
				rec=target.getBounds(tContainer);
				if(dx==DefaultTX)
				{
					tX=rec.x+rec.width*0.5;
				}else
				{
					tX=rec.x+dx;
				}
			}else
			{
				tX=DefaultTX;
			}
			if(delay>0)
			{
				setTimeout(showMagicAlert,delay,str.split("\n"),tX);
			}else
			{
				showMagicAlert(str.split("\n"),tX);
			}
			
		}

		/**
		 * 显示提示信息 
		 * @param messageList 提示信息文本框列表
		 * html格式
		 * 
		 */
		public static function showMagicAlert(messageList:Array=null,tX:Number=DefaultTX):void
		{
			if(!messageList||messageList.length<1) return;
			tTxt=getTxt();
			var len:int=messageList.length;
			var i:int;
			var html:String;
			var tFormat:TextFormat;
			var gFilter:GlowFilter;
			var tFilterList:Array;
			html=messageList[0];
			for(i=1;i<len;i++)
			{
				tTxt.htmlText+="<br>"+messageList[i];
				html+="\n"+messageList[i];
			}
			tTxt.htmlText=html;
//			tTxt.setTextFormat(MyTextStyle.getMagicAlertTextFormat());
			tTxt.setTextFormat(StyleLib.MagicAlertTxtFormat);
			tTxt.width  = tTxt.textWidth+10;
			tTxt.height  = tTxt.textHeight+10;
//			tTxt.x=(ModelLocator.getInstance().stageWidth - tTxt.width)/2;
			tFilterList=[StyleLib.black1TipFilter];
			if(tTxt.length>0)
			{
//			tFormat=tTxt.getTextFormat(0,1);
//			if(tFormat.color==0xb80606)
//			{
//				gFilter=MyTextStyle.redFilter;
//				tFilterList.push(gFilter);
//			}
//			if(tFormat.color==0x06a703)
//			{
//				gFilter=MyTextStyle.greenFilter;
//				tFilterList.push(gFilter);
//			}
			}
			tTxt.filters=tFilterList;
			tTxt.y=startY;
			tTxt.alpha=1;
			if(pTxt)
			{
				if(pTxt.y>tTxt.y-50)
				{
					TweenMax.to(pTxt,0.2,{y:tTxt.y-pTxt.height,onComplete:flyOut,onCompleteParams:[pTxt,0.5]});
				}else
				{
					flyOut(pTxt,0.5);
				}
				
			}
//			BoxFactory.getInstance().getBoxView(TipCommad.TIP_VIEW_NAME).addChild(tTxt);
//			ModelLocator.getInstance().gameStage.addChild(tTxt);
			tContainer.addChild(tTxt);
			if(tX==DefaultTX)
			{
				StageUtil.setDisVCenterK(tTxt);
			}else
			{
				tTxt.x=tX-tTxt.width*0.5;
			}
			
			clearTimeout(_tID);
			_tID=setTimeout(flyOut,1000,tTxt);
					
		}
		/**
		 * 文本框飞往目标位置 
		 * @param txt
		 * @param time
		 * 
		 */		
		private static function flyOut(txt:TextField,time:Number=5):void
		{
			TweenMax.killTweensOf(txt);
			TweenMax.to(txt,time,{y:endY,alpha:0,onComplete:hideTxt,onCompleteParams:[txt]});
		}
		/**
		 * 移除文本框 
		 * @param txt
		 * 
		 */		
		private static function hideTxt(txt:TextField):void
		{
			if(txt.parent)
			{
				txt.parent.removeChild(txt);
			}
		}

		
	}
}