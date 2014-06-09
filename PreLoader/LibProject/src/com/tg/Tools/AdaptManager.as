package com.tg.Tools
{
	import com.tg.StageUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 自适应辅助类
	 * @author ww
	 * 
	 */
	public class AdaptManager
	{
		public function AdaptManager()
		{
			_disDic=new Dictionary();
//			StageUtil.stage.addEventListener(Event.RESIZE,resizeHandler,false,0,true);
		}
		
		private static var _instance:AdaptManager;
		
		public static function get me():AdaptManager
		{
			if(!_instance) _instance=new AdaptManager;
			return _instance;
		}
		
		private var _disDic:Dictionary;
		
		private function addToStage(evt:Event):void
		{
			var tTarget:DisplayObject;
			tTarget=evt.target as DisplayObject;
			if(tTarget&&_disDic[tTarget])
			{
				
				trace("dis addToStageAdapt:"+tTarget.toString());
				callAdaptFun(tTarget,evt,true,true);
			}
		}
		
		private function callAdaptFun(dis:DisplayObject,evt:Event=null,removeEvent:Boolean=false,removeDis:Boolean=false):void
		{
			if(!dis) return;
			if(!dis.stage) return;
			var tFun:Function;
			tFun=_disDic[dis];
			if(tFun!=null)
			{
				switch(tFun.length)
				{
					case 0:
						tFun();
						break;
					case 1:
						tFun(evt);
						break;
					case 2:
						tFun(StageUtil.adjustedStageWidth,StageUtil.adjustedStageHeight);
						break;
					default:
						tFun();
				}
				if(removeEvent)
				{
					dis.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
				}
			}
			if(removeDis)
			{
				delete _disDic[dis];
			}

		}
//		private function resizeHandler(evt:Event=null):void
//		{
//			var tDis:DisplayObject;
//			for(tDis in _disDic)
//			{
//				callAdaptFun(tDis,evt);
//			}
//		}
		/**
		 * 添加自适应对象 
		 * @param dis 自适应对象
		 * @param adptFun 自适应函数 参数为0~2个
		 * @param resize 是否添加resize事件控制
		 * 
		 */
		public function addAdaptDis(dis:DisplayObject,adptFun:Function,resize:Boolean=true):void
		{
			if(!dis) return;
			if(adptFun==null) return;
			if(_disDic[dis]) return;
			_disDic[dis]=adptFun;
			dis.addEventListener(Event.ADDED_TO_STAGE,addToStage,false,0,true);
			if(resize)
			{
				StageUtil.stage.addEventListener(Event.RESIZE,adptFun,false,0,true);
			}
			if(dis.stage)
			{
				callAdaptFun(dis,null,true,true);
			}

			
		}

		private function removeEvent(dis:DisplayObject):void
		{
			if(!dis) return;
			dis.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			var tAdaptFun:Function;
			tAdaptFun=_disDic[dis];
			if(tAdaptFun!=null)
			{
				StageUtil.stage.removeEventListener(Event.RESIZE,tAdaptFun);
			}
		}
		public function removeAdaptDis(dis:DisplayObject):void
		{
			if(!dis) return;
			removeEvent(dis);
			if(_disDic[dis])
			{
				delete _disDic[dis];
			}
		}
	}
}