package killClass
{
	import com.tg.Tools.TimeTools;
	import com.tg.Trigger;

	public class RoomInfoCollector
	{
		public function RoomInfoCollector()
		{
			
			TimeTools.me.addDelay(mainLoop,5,null,99999999,30);
		}
		
		public var tRoomList:Array;
		
		public static var isOn:Boolean=false;
		
		public var areaList:Array=["areaA","areaB"];
		public var tID:int=0;
		public function getTArea():String
		{
			var rst:String;
			rst=areaList[tID];
			tID=(tID+1)%areaList.length;
			return rst;	
		}
		public function mainLoop():void
		{
			if(!isOn) return;
			
			if(!tRoomList||tRoomList.length<1)
			{
				KillClient.me.getRoomList("areaA");
				return;
			}
			
			var tRoomData:Object;
			tRoomData=tRoomList.shift();
			RoomPlayerListGetter.me.getRoomListByID(tRoomData["RoomId"]);
		}
		
		public function dealMsg(data:Object):void
		{
			var roomList:Array;
			var i:int;
			var len:int;
			roomList=data["Rooms"];
			tRoomList=[];
			len=roomList.length;
			
			var tRoom:Object;
			for(i=0;i<len;i++)
			{
			
				tRoom=roomList[i];
				if(tRoom["NowPlayerNum"]>0)
				{
					tRoomList.push(tRoom);
				}
			}
			
			
		}
		
		
	}
}