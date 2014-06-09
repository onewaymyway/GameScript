package com.tg.systemMessage
{
	import com.tg.StageUtil;
	import com.tg.Tools.LoadMusic;
	import com.tg.systemMessage.event.MsgEvent;
	
	import flash.display.Sprite;
	
	
	/** 系统消息管理类
	 * @author hdz
	 *
	 * @date 2014-2-14
	 **/
	
	public class MessageManager
	{
		private static var msgArr:Array = [];
		
		private static var _instance:MessageManager;
		/** 弹框显示所在面板 */
		private static var layer:Sprite;
		
		
		public function MessageManager()
		{
		}
		public static function init(layer:Sprite):void
		{
			MessageManager.layer = layer;
		}
		private static function get instance():MessageManager
		{
			if(!_instance)
				_instance = new MessageManager();
			return _instance
		}
		/**
		 * 显示系统消息 
		 * @param con 消息内容
		 * @param type 提示图标类型 1是叹号，2是对号
		 * @param type 消息显示位置
		 * </br>
		 * 消息视图显示的位置:屏幕正上方</br>
		 *	SystemMessage.LOCATION_TOP</br>
		 *	消息视图显示的位置:屏幕正中</br>
		 *	SystemMessage.LOCATION_CENTER</br>
		 *	消息视图显示的位置:屏幕正下方</br>
		 *	SystemMessage.LOCATION_BOTTOM</br>
		 * 
		 */	
		public static function systemMessage(con:String,iconType:int = 1,type:int = 2):void
		{
			LoadMusic.Play("team");
			var msg:SystemMessage = new SystemMessage(con,iconType);
			msg.addEventListener(MsgEvent.remove,remove);
			for(var i:int = 0; i < msgArr.length;i++)
			{
				MessageManager.layer.removeChild(msgArr[i]);
				msgArr.splice(i,1);
			}
			switch(type)
			{
				case SystemMessage.LOCATION_TOP:
					msg.y = 100;
					break;
				case SystemMessage.LOCATION_CENTER:
					msg.y = StageUtil.adjustedStageHeight /2-msg.height/2
					break;
				case SystemMessage.LOCATION_BOTTOM:
					msg.y = StageUtil.adjustedStageHeight - 100
					break;
			}
			msg.x = StageUtil.adjustedStageWidth/2-msg.width/2;
			
			msg.beginPlay();
			
			msg.type = type;
			MessageManager.layer.addChild(msg);
			msgArr.push(msg);
		}
		/**
		 * 删除消息框 
		 * @param e
		 * 
		 */		
		private static function remove(e:MsgEvent):void
		{
			for(var i:int = 0; i < msgArr.length;i++)
			{
				if(msgArr[i] == e.obj)
				{
					MessageManager.layer.removeChild(msgArr[i]);
					msgArr.splice(i,1);
				}
			}
		}
		
		
	}
}
