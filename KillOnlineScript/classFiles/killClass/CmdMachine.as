package killClass
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;

	public class CmdMachine
	{
		public function CmdMachine()
		{
			managerList=new UserList();
			managerList.addID(1549754);
		}
		public static var managerList:UserList;
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
		public function dealCMDs(cmd:String,uid:int):void
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
				case "addFriend":
					cmdOwner.addFriend(cmds[1]);
					break;
				case "lock":
					cmdOwner.setRoomInfo(cmds[1]);
					break;
				case "unlock":
					cmdOwner.setRoomInfo("");
					break;
				case "addFriendSit":
					cmdOwner.addFriendSit(cmds[1]);
					break;
				case "kickPlayer":
					cmdOwner.kickPlayer(cmds[1]);
					break;
				case "kickSit":
					cmdOwner.kickBySitID(cmds[1]);
					break;
				case "room":
					cmdOwner.joinRoomByID(cmds[1]);
					break;
				case "language":
					Translator.me.setDstLang(cmds[1]);
					break;
				case "复读机开启":
					CopyMachine.isCopyOn=true;
					cmdOwner.sendChat("复读机已开启");
					break;
				case "复读机关闭":
					CopyMachine.isCopyOn=false;
					cmdOwner.sendChat("复读机已关闭");
					break;
				case "翻译开启":
					CopyMachine.isTranslateOn=true;
					cmdOwner.sendChat("翻译机已开启");
					break;
				case "翻译关闭":
					CopyMachine.isTranslateOn=false;
					cmdOwner.sendChat("翻译机已关闭");
					break;
				case "只复读我":
					CopyMachine.isOnlyMe=true;
					cmdOwner.sendChat("复读机只复制主人模式");
					break;
				
				case "自由复读":
					CopyMachine.isOnlyMe=false;
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