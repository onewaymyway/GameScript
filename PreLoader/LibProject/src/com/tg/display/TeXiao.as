package com.tg.display
{
	import com.greensock.TweenLite;
	import com.tg.UiLayout;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class TeXiao
	{
		private static var _instance:TeXiao;
		public function TeXiao()
		{
		}
		public static function get instance():TeXiao
		{
			_instance = new TeXiao();
			return _instance;
		}
		public var pxyArr:Array = [[168,60],
									[250,60],
									[220,110]
									]
		public var objArr:Array;
		public var overTexiao:MovieClip ;
		
		private var targetType:int;
		
		//缓动完毕后的回调函数
		private var backFun:Function = new Function();;
		/**
		 * 开始生成特效  
		 * @param initial 起始点（世界坐标）
		 * @param target 1、元宝 2、铜钱  3、战力
		 * @param disArr 动画元素对象数组
		 * @param overTexiao 到达目标点的特效
		 * @param type 特效是横向生成还是纵向生成 1、横向 2、纵向
		 * @param time 预留
		 * 
		 */			
		public function play(initial:Point,targetType:int,disArr:Array,overTexiao:MovieClip,backFun:Function = null,type:int = 1,time:Number = 0.1):void
		{
			var i:int
			objArr = [];
			var n:int;
			var px:Number;
			this.overTexiao =overTexiao; 
			this.targetType = targetType;
			this.backFun = backFun;
			switch(type)
			{
				case 1:
				{
					var dis:DisplayObject
					for(i = 0; i < disArr.length;i++)
					{
						n = int(Math.random()*disArr.length);
						dis = disArr[i];
						
						objArr.push(dis);
						
						px = Math.random() * 260/2;
						px = (Math.random() * 100)>50?-px:px;
					
						dis.x = initial.x + px-(UiLayout.screen.parent.x - UiLayout.screen.x);
						dis.y = initial.y - (UiLayout.screen.parent.y - UiLayout.screen.y);
						if(i == 0)
						{
							dis.scaleX = 0.3;
							dis.scaleY = 0.3;
							TweenLite.to(dis, time+Math.random()*0.7 + 0.8, {x:pxyArr[targetType-1][0], y:pxyArr[targetType-1][1],scaleX:.6,scaleY:.6, onComplete:comFun1,onCompleteParams:[dis]});
						}
						else
						{
							TweenLite.to(dis, time+Math.random()*0.7 + 0.8, {x:pxyArr[targetType-1][0], y:pxyArr[targetType-1][1], onComplete:comFun1,onCompleteParams:[dis]});	
						}
						UiLayout.effect.addChild(dis);
					}
					
					break;
				}
					case 2:
						for( i= 0; i < disArr.length;i++)
						{
							n = int(Math.random()*disArr.length);
							dis = disArr[i];
							
							objArr.push(dis);
							
							px = Math.random() * 260/2;
							px = (Math.random() * 100)>50?-px:px;
							
							dis.x = initial.x -(UiLayout.screen.parent.x - UiLayout.screen.x);
							dis.y = initial.y + px- (UiLayout.screen.parent.y - UiLayout.screen.y);
							if(i == 0)
							{
								dis.scaleX = 0.2;
								dis.scaleY = 0.2;
								TweenLite.to(dis, time+Math.random()*0.7 + 0.8, {x:pxyArr[targetType-1][0], y:pxyArr[targetType-1][1],scaleX:.5,scaleY:.5, onComplete:comFun1,onCompleteParams:[dis]});
							}
							else
							{
								TweenLite.to(dis, time+Math.random()*0.7 + 0.8, {x:pxyArr[targetType-1][0], y:pxyArr[targetType-1][1], onComplete:comFun1,onCompleteParams:[dis]});	
							}
							UiLayout.effect.addChild(dis);
						}
						break;
					
				default:
				{
					break;
				}
			}
			
			
		}
		private function comFun1(btm:DisplayObject):void
		{
			for(var i:int = 0; i < objArr.length;i++)
			{
				if(objArr[i] == btm)
				{
					UiLayout.effect.removeChild(objArr[i]);
					objArr.splice(i,1);
					if(overTexiao)
					{
						overTexiao.gotoAndPlay(1);
						overTexiao.x =pxyArr[targetType-1][0];
						overTexiao.y =pxyArr[targetType-1][1];
						
						UiLayout.effect.addChild(overTexiao);
					}
					break;
				}
			}
			try{
				if(objArr.length == 0)
					backFun();
			}catch(e:Error){
				
			}
		}
		
		
	}
}