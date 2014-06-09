package com.tg.Tools
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * 获取显示对象的布局类型
	 * 用于判断显示对象的主要显示区域相对于(0,0)点的分布情况
	 * @author ww
	 * 
	 *      var disType:int;
			disType=DisLayOutType.getDisMainType(tip);
			switch(disType)
			{
				case DisLayOutType.Left:

					break;
				case DisLayOutType.Right:

					break;
				case DisLayOutType.Up:

					break;
				case DisLayOutType.Down:

					break;
			}
	 * 
	 */
	public class DisLayOutType
	{
		public function DisLayOutType()
		{
		}
		public static const Left:int=1;
		public static const Right:int=2;
		public static const Up:int=3;
		public static const Down:int=4;
		
		public var leftLen:Number;
		public var rightLen:Number;
		public var upLen:Number;
		public var downLen:Number;
		
		public var mainType:int;
		
		/**
		 * 设置显示对象 
		 * @param dis
		 * 
		 */
		public function setDis(dis:DisplayObject):void
		{
			if(!dis) return ;
			
			var tRec:Rectangle;
			tRec=dis.getBounds(dis);
			
			
			leftLen=-tRec.x;
			rightLen=tRec.x+tRec.width;
			upLen=-tRec.y;
			downLen=tRec.y+tRec.height;
			
			if(leftLen<0) leftLen=0;
			if(rightLen<0) rightLen=0;
			if(upLen<0) upLen=0;
			if(downLen<0) downLen=0;
			
			if(Math.abs(leftLen-rightLen)*tRec.height>Math.abs(upLen-downLen)*tRec.width)
			{
				mainType=vType;
			}else
			{
				mainType=hType;
			}
		}
		
		/**
		 * 水平方向偏向
		 * @return 
		 * 
		 */
		public function get vType():int
		{
			return isRight?Right:Left;
		}
		/**
		 * 垂直方向偏向
		 * @return 
		 * 
		 */
		public function get hType():int
		{
			return isDown?Down:Up;
		}
		/**
		 * 是否偏向右边
		 * @return 
		 * 
		 */
		public function get isRight():Boolean
		{
			return leftLen<rightLen;
		}
		
		/**
		 * 是否偏向下方
		 * @return 
		 * 
		 */
		public function get isDown():Boolean
		{
			return upLen<downLen;
		}
		
		/**
		 * 获取显示对象的主布局偏向
		 * @param dis
		 * @return 
		 * 
		 */
		public static function getDisMainType(dis:DisplayObject):int
		{
			var tRst:DisLayOutType;
			tRst=new DisLayOutType();
			tRst.setDis(dis);
			return tRst.mainType;
		}

		/**
		 * 获取显示对象的布局描述
		 * @param dis
		 * @return 
		 * 
		 */
		public static function getDisLayOutType(dis:DisplayObject):DisLayOutType
		{
			var tRst:DisLayOutType;
			tRst=new DisLayOutType();
			tRst.setDis(dis);
			return tRst;
		}
	}
}