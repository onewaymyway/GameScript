package com.tg.Tools
{
	import com.tg.StageUtil;
	import com.tg.Trigger;
	import com.tg.st.commonData.CommonData;
	import com.tg.window.Window;
	import com.tg.window.WindowWrapper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 用户状态探测类 
	 * 用于分析当前用户所处的状态
	 * @author ww
	 * 
	 */
	public class UserStateSensor
	{
		public function UserStateSensor()
		{
			StageUtil.stage.addEventListener(MouseEvent.MOUSE_DOWN,click);
			Trigger.addSecondTrigger(timeTick);
		}
		
		private static var _instance:UserStateSensor;
		
		public static function get me():UserStateSensor
		{
			if(!_instance) _instance=new UserStateSensor;
			return _instance;
		}
		
		public function allWindowClose():void
		{
			//trace("userStateSensor:allWindowClose");
			dealTState();
		}
		
		
		private function playerIdle():void
		{
			//trace("userStateSensor:playerIdle");
			idleLevel++;
			trace("idleLevel:"+idleLevel);
			if(idleLevel>5)
			{
				idleLevel=0;
//				GuidManager.me.forceToRestartTaskAutoGuid();
			}else
			if(idleLevel>4)
			{
				if(GuidManager.me.isAutoHelp)
				if(CommonData.isInTown)
				{
					WindowWrapper.closeAllWindow();
				}
				
			}else
			if(idleLevel>3)
			{
				GuidManager.me.setAutoTaskGuidEnable(true);
				
			}else
			{
				dealTState();
			}
			
			
		}
		
		private function dealTState():void
		{
			//trace("userStateSensor:dealTState");
			if(isIdle&&WindowWrapper.isAllHide())
			GuidManager.me.tryStartTaskAutoGuid();
		}
		
		
		public function  playerActive():void
		{
			idleLevel=0;
			GuidManager.me.stopAutoGuidTask();
		}
		public function isPlayerIdel():Boolean
		{
		  return 	(isIdle&&WindowWrapper.isAllHide()&&CommonData.isInTown);
		}
		private var preTime:int;
		private var isIdle:Boolean=true;
		private var idleLevel:int;
		private function click(evt:Event=null):void
		{
			var tTime:int;
			tTime=(new Date()).time;
			preTime=tTime;
			isIdle=false;
			idleLevel=0;
			Trigger.removeSecondTrigger(timeTick);
			Trigger.addSecondTrigger(timeTick);
		//	trace("userStateSensor:click");
		}
		
		private function timeTick():void
		{
			var tTime:int;
			tTime=(new Date()).time;
			//trace("userStateSensor:timeTick");
			if(tTime-preTime>10*1000)
			{
				isIdle=true;	
				preTime=tTime;
				playerIdle();
			}else
			{
				isIdle=false;
			}
		}
	}
}