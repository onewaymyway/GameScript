package killClass
{
	public class CopyMachine
	{
		
		public static  var isCopyOn:Boolean;
		
		
		public static var isOnlyMe:Boolean;
		
		public static var isTranslateOn:Boolean;
		
		public static var copyList:UserList;
		
		public function CopyMachine()
		{
			isCopyOn=false;
			isOnlyMe=false;
			isTranslateOn=false;
			copyList=new UserList();
		}
		
		public function dealMsg(cmd:Object):void
		{
			var tmsg:String;
			tmsg=cmd["Msg"];
			if(!tmsg) 
			{
				return;
			}
			
			if(isCopyOn)
			{
				if(tmsg.indexOf("别学我")>=0)
				{
					copyList.removeID(cmd["UserId"]);
					KillClient.me.sendChat(cmd["UserName"]+"离开复读列表");
				}else
				{
					if(tmsg.indexOf("学我说话")>=0)
					{
						copyList.addID(cmd["UserId"]);
						
						KillClient.me.sendChat(cmd["UserName"]+"加入复读列表");
						return;
					}
				}
			}
			
			
			if(isCopyOn&&copyList.isInList(cmd["UserId"]))
			{
				
				if(isTranslateOn&&CmdMachine.managerList.isInList(cmd["UserId"]))
				{
					Translator.me.traslateStr(cmd["Msg"]);
				}else
				{
					if(MoneySystem.me.spendMoney(cmd["UserId"],1)>=0)
					{
						Translator.me.traslateStr(cmd["Msg"]);
					}else
					{
						KillClient.me.sendChat(cmd["Msg"]);
					}
					
				}
				

			}
			
		}
	}
}