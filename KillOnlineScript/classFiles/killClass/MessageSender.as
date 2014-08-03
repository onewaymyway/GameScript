package killClass
{
	import com.tg.Trigger;

	public class MessageSender
	{
		public function MessageSender()
		{
			messageList=[];
			Trigger.addSecondTrigger(dealMessage);
		}
		
		public var messageList:Array;
		public var sendFun:Function;
		private function dealMessage():void
		{
			if(messageList.length<1)
			{
				return;
			} 
			if(sendFun==null)
			{
				return;
			}
			var tMsg:Object;
			tMsg=messageList.shift();
			sendFun(tMsg.uid,tMsg.msg);
		}
		
		public function addMsg(msg:Object):void
		{
			messageList.push(msg);
		}
		public function addMsgS(uid:int,msg:String):void
		{
			var msgO:Object;
			msgO={};
			msgO["uid"]=uid;
			msgO["msg"]=msg;
			addMsg(msgO);
		}
	}
}