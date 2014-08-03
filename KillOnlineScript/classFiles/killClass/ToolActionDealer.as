package killClass
{
	import com.tools.DebugTools;
	
	import killClass.data.BasicInfos;

	public class ToolActionDealer
	{
		public function ToolActionDealer()
		{
		}
//		[ToolAction]:ToolAction
//		{
//			"ToolStates": 0, 
//			"ToSite": [
//				{
//					"ToolMc": 1, 
//					"Site": 3, 
//					"Integral": "+1", 
//					"Url": "/resource/tool/100167.swf", 
//					"SkillIntegral": 0, 
//					"AfterUrl": "/resource/tool/face/xianhuaface.swf"
//				}
//			], 
//			"ToolId": 100167, 
//			"FromSite": 1, 
//			"Msg": "[1][nightcutmare] 对 [3][终   极] 使用(绑)鲜花卡", 
//			"ActionType": 5
//		}
		public function dealMsg(data:Object):void
		{
			if(!data) return;
			var fromID:int;
			fromID=data["FromSite"];
			var toID:int;
			toID=data["ToSite"][0]["Site"];
			var scoreStr:int;
			scoreStr=int(data["ToSite"][0]["Integral"]);
			
			RoomPlayerListGetter.me.getRoomSitDataO(BasicInfos.tRoomID,roomDataBack);
			function roomDataBack(roomData:Object):void
			{
				if(!roomData) return;
//				{"RoomSite":6,"UserName":".BOSS.","UserId":1965811,"Vip":0,"Integral":1314}
				
				try
				{
					var sData:Object;
					sData=roomData[fromID];
					var tData:Object;
					tData=roomData[toID];
					DebugTools.debugTrace(sData["UserName"]+" 对 "+tData["UserName"]+"使用道具："+scoreStr,"道具使用");
					var sID:int;
					sID=sData["UserId"];
					var tID:int;
					tID=tData["UserId"];
					trace("uid:"+BasicInfos.uid);
					if(scoreStr>0)
					{
						if(tID==BasicInfos.uid||CmdMachine.managerList.isInList(tID))
						{
							MoneySystem.me.addMoney(sID,scoreStr*10);
							KillClient.me.sendChat("玩家【"+sData["UserName"]+"】的翻译次数增加到："+MoneySystem.me.getMoney(sID));
						}
					}else
					{
						if(scoreStr<=-10)
						{
							KillClient.me.kickPlayer(sID);
							KillClient.me.sendChat("玩家【"+sData["UserName"]+"】使用恶意整蛊已被自动踢出");
						}
					}
				}catch(e:*)
				{
				}
				
			}
		}
	}
}