package killClass
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;

	public class CmdMachine
	{
		public function CmdMachine()
		{
		}
		public var managerList:UserList;
		public function dealPrivateMsg(msgO:Object):void
		{
			var tMsg:Object;
			//	DebugTools.debugTrace("私聊：","私聊",msgO);
			if(!msgO["PrivateChats"]) 
			{
				return;
			}
			
			tMsg=msgO["PrivateChats"][0];
			if(managerList.isInList(tMsg["UserId"]))
			{
				var tStr:String;
				tStr=tMsg["Msgs"][0]["Msg"];
				DebugTools.debugTrace("私聊："+tStr,"私聊",tMsg);
				dealCMDs(tStr,tMsg["UserId"]);
			}
		}

		public var tExeUID:int;
		public var cmdOwner:Object;
		function dealCMDs(cmd:String,uid:int):void
		{
			var cmds:Array;
			cmds=cmd.split(":");
			DebugTools.debugTrace("命令"+cmds[0],"执行命令",cmds);
			//   sendPrivate(uid,"收到命令："+JSONTools.getJSONString(cmds));
			cmdOwner.tSender.addMsgS(uid,"收到命令："+JSONTools.getJSONString(cmds));
			tExeUID=uid;
			switch(cmds[0])
			{
				case "chat":
					cmdOwner.sendChat(cmds[1]);
					break;
				case "room":
					cmdOwner.joinRoom(cmds[1]);
					break;
				case "复读机开启":
					cmdOwner.isCopyOn=true;
					cmdOwner.sendChat("复读机已开启");
					break;
				case "复读机关闭":
					cmdOwner.isCopyOn=false;
					cmdOwner.sendChat("复读机已关闭");
					break;
				case "只复读我":
					cmdOwner.isOnlyMe=true;
					cmdOwner.sendChat("复读机只复制主人模式");
					break;
				case "自由复读":
					cmdOwner.isOnlyMe=false;
					cmdOwner.sendChat("复读机自由模式");
					break;
				case "跟我来":
					cmdOwner.getUInfoData(uid);
					cmdOwner.sendChat("尝试进入房间中");
					break;
			}
			cmdOwner.tSender.addMsgS(uid,"执行结束命令："+JSONTools.getJSONString(cmds));
		}
	}
}