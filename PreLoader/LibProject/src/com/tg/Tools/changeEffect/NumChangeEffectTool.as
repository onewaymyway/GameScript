package com.tg.Tools.changeEffect
{
	import com.tg.Tools.StringToolsLib;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;

	public class NumChangeEffectTool
	{
		public function NumChangeEffectTool()
		{
		}
		
		public static const normalTxt:int=0;
		public static const moneyTxt:int=1;
		/**
		 * 带显示转换的数字文本框变闪烁
		 * @param txt
		 * @param preValue
		 * @param newValue
		 * @param type normalTxt:普通数字 moneyTxt：转成xx亿xx万类型的数字
		 * 
		 */
		public static function changeTxt(txt:TextField,preValue:Number,newValue:Number,type:int=normalTxt):void
		{
			if(preValue==newValue) return;
			var effect:ChangeEffect;
			effect=new ChangeEffect(txt,getNumChangeType(preValue,newValue),change);
			effect.playEffect();
		    function change():void
			{
				if(type==normalTxt)
				{
					txt.text=newValue+"";
				}else
				{
					txt.text=StringToolsLib.getMoneyText(newValue);
				}
				
				
			}
		}
		/**
		 * 简单数字文本框变化闪烁 
		 * @param txt
		 * @param newValue
		 * 
		 */
		public static function changeNormalNumTxt(txt:TextField,newValue:Number):void
		{
			var preValue:Number;
			preValue=Number(txt.text);
			
			if(preValue==newValue) return;
			var effect:ChangeEffect;
			effect=new ChangeEffect(txt,getNumChangeType(preValue,newValue),change);
			effect.playEffect();
			function change():void
			{
					txt.text=newValue+"";
			}
		}
		private static function getNumChangeType(preValue:Number,newValue:Number):int
		{
			if(preValue<newValue)  return ChangeEffect.typeUp;
			return ChangeEffect.typeDown;
		}
		/**
		 * 显示对象变化闪烁 
		 * @param dis
		 * @param type ChangeEffect.typeFlash
		 * @param callBack
		 * 
		 */
		public static function changeNotice(dis:DisplayObject,type:int=2,callBack:Function=null):void
		{
			var effect:ChangeEffect;
			effect=new ChangeEffect(dis,type,callBack);
			effect.playEffect();

		}
		/**
		 * 文本显示框 
		 * @param txt 要显示的文本框
		 * @param newTxt 要更新的数值
		 * @param type 1是增加，2是减少
		 * 
		 */		
		public static function txtChangeNotice(txt:TextField,newTxt:String,type:int = 1):void
		{
			var effect:ChangeEffect;
			
			if(txt.text == newTxt)
				return;
			txt.text=newTxt;
			if(type == 1)
			{
				type = ChangeEffect.typeDown;
			}
			else
			{
				type = ChangeEffect.typeUp;
			}
			effect=new ChangeEffect(txt,type);
			effect.playEffect();
			
		}
	}
}