package killClass
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.events.SyncEvent;
	
	import killClass.so.SO;
	import killClass.so.ServerSO;

	public class RoomPlayerListGetter
	{
		public function RoomPlayerListGetter()
		{
		}
		
		
		public var RoomUsersSo:SO;
		public var tRoomID:int=-1;
		
		private static var instance:RoomPlayerListGetter;
		public static function get me():RoomPlayerListGetter
		{
			if(!instance)
			{
				instance=new RoomPlayerListGetter();
			}
			return instance;
		}
		
		public function getRoomListByID(roomID:int):void
		{
			tRoomID=roomID;
			getRoomList();
		}
		public function getRoomSitDataO(roomID:int,backFun:Function):void
		{
			var roomSo:SO;
			roomSo = ServerSO.getRemote("RoomUsers" + roomID);
			roomSo.addEventListener(SyncEvent.SYNC, ssyncUserSOHandler);
			roomSo.connect();
			function ssyncUserSOHandler(event:SyncEvent) : void
			{
				//	KillerRoomData.RoomUserList = this.RoomUsersSo.data;
				DebugTools.debugTrace("RoomUsersSo.data","room",roomSo.data);
				var tRoomData:Object;
				tRoomData=roomSo.data;
				var roomData:Object;
				roomData={};
				var kk:String;
				for(kk in tRoomData)
				{
					roomData[tRoomData[kk]["RoomSite"]]=tRoomData[kk];
				}
				DebugTools.debugTrace("RoomData:"+roomID+"\n"+JSONTools.getJSONString(roomData),"room",roomData);
				sclearSo();
				backFun(roomData);
				return;
			}
			
			function sclearSo():void
			{
				roomSo.removeEventListener(SyncEvent.SYNC, ssyncUserSOHandler);
				roomSo.close();
			}
		}
		public function actionRoomSit(roomID:int,sit:int,backFun:Function):void
		{
			getRoomSitDataO(roomID,roomDataBack);
			function roomDataBack(roomData:Object):void
			{
				if(!roomData) return;
				if(!roomData[sit]) return;
				try
				{
					var tPData:Object;
					tPData=roomData[sit];
					var sID:int;
					sID=tPData["UserId"];
					backFun(sID);
				}catch(e:*)
				{
					
				}
				
			}
		}
		public function getRoomList():void
		{
			RoomUsersSo = ServerSO.getRemote("RoomUsers" + tRoomID);
			RoomUsersSo.addEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
			RoomUsersSo.connect();
		}
		
		
		public function syncUserSOHandler(event:SyncEvent) : void
		{
			//	KillerRoomData.RoomUserList = this.RoomUsersSo.data;
			DebugTools.debugTrace("RoomUsersSo.data","room",RoomUsersSo.data);
			var tRoomData:Object;
			tRoomData=RoomUsersSo.data;
			var tRoomPlayerList:Array;
			tRoomPlayerList=[];
			var kk:String;
			for(kk in tRoomData)
			{
				tRoomPlayerList.push(tRoomData[kk]);
			}
			if(tRoomPlayerList.length<1) return;
			KillClient.me.collector.dealSpeaker(tRoomPlayerList,"RoomPlayerList");
			DebugTools.debugTrace("RoomData:"+tRoomID+"\n"+JSONTools.getJSONString(tRoomPlayerList),"room",tRoomPlayerList);
			clearSo();
			return;
		}
		
		public function clearSo():void
		{
			RoomUsersSo.removeEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
			RoomUsersSo.close();
		}
	}
}