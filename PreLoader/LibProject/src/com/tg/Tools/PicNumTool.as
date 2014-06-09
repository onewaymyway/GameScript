package com.tg.Tools
{
	import com.tg.Tools.changeEffect.NumChangeEffectTool;
	import com.tools.ClassTools;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 图片数字控制类 
	 * @author ww
	 * 
	 * 
	 * 
	 *      var numMoney:PicNumTool;
			var oMc:MovieClip;
			oMc=new NumsMC;
			
			numMoney=new PicNumTool;
			numMoney.setNumMC(oMc);
			tContent.addChild(numMoney);
			numMoney.x=moneyTxt.x;
			numMoney.y=moneyTxt.y;
			numMoney.ifChangeFlash=false;
			numMoney.isChangeEffect=true;
	 * 
	 */
	public class PicNumTool  extends Sprite
	{
		public function PicNumTool()
		{
			super();
		}
		/**
		 * 包含数字的mc  1~10帧分别放0~9的数字 
		 */
		private var numMc:MovieClip;
		/**
		 * 生成mc的类
		 */
		private var numClaz:Class;
		
		
		/**
		 * 数字的最大宽度 
		 */
	    private var maxWidth:Number;
		/**
		 * 设置内容MC 1~10帧分别放0~9的数字 
		 * @param mc
		 * 
		 */
		public function setNumMC(mc:MovieClip):void
		{
			this.numMc=mc;
			numClaz=ClassTools.getClass(mc);
			
			var i:int;
			var len:int;
			maxWidth=0;
			len=mc.totalFrames;
			for(i=1;i<=len;i++)
			{
				mc.gotoAndStop(i);
				if(mc.width>maxWidth)
				{
					maxWidth=mc.width;
				}
			}
		}
		/**
		 * 数字间距 
		 */
		public var dx:int=0;
		
		
		/**
		 * 是否在数字改变时显示变更滚动动画
		 */
		public var isChangeEffect:Boolean=false;
		/**
		 * 是否在数字改变时闪烁
		 */
		public var ifChangeFlash:Boolean=true;
		/**
		 * 变更滚动循环次数 
		 */
		public var round:int=2;
		/**
		 * 获取一个图片数字 
		 * @param num
		 * @return 
		 * 
		 */
		private function getANum(num:int):DisplayObject
		{
			if(!numClaz) return null;
			var rst:MovieClip;
			rst=new numClaz;
			if(isChangeEffect)
			{
				MCControlTools.playRandomAndStopAt(rst,num+1,null,12,round);
			}else
			{
				rst.gotoAndStop(num+1);
			}
			
			return rst;
		}
		
		/**
		 * 当前显示的数 
		 */
		public var tNumber:Number;
		/**
		 * 设置要显示的数字 
		 * @param num
		 * 
		 */
		public function setNum(num:int):void
		{
			if(ifChangeFlash&&tNumber==num) return;
			tNumber=num;
			DisplayUtil.clean(this);
			if(!numClaz) return ;
			var str:String;
			str=String(num);
			var i:int;
			var len:int;
			var tNum:DisplayObject;
			var tN:int;
			var tx:Number;
			tx=0;
		    len=str.length;
			for(i=0;i<len;i++)
			{
				tN=int(str.charAt(i));
				tNum=getANum(tN);
				addChild(tNum);
				tNum.x=tx;
				tx+=maxWidth+dx;
				
			}
			if(ifChangeFlash)
			NumChangeEffectTool.changeNotice(this);
		}
	}
}