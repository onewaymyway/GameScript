import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.events.SyncEvent;

import Core.model.data.UserData;
import Core.so.SO;
import Core.so.ServerSO;

import model.KillerRoomData;

import roomEvents.KillerRoomEvents;

DebugTools.debugTrace("UserData.UserRoom"+UserData.UserRoom,"room");


var RoomUsersSo:SO;
var tRoomID:int;

getRoomListByID(1001);

function getRoomListByID(roomID:int):void
{
	tRoomID=roomID;
	getRoomList();
}

function getRoomList():void
{
	RoomUsersSo = ServerSO.getRemote("RoomUsers" + tRoomID);
	RoomUsersSo.addEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
	RoomUsersSo.connect();
}


function syncUserSOHandler(event:SyncEvent) : void
{
//	KillerRoomData.RoomUserList = this.RoomUsersSo.data;
	DebugTools.debugTrace("RoomUsersSo.data","room",RoomUsersSo.data);
	DebugTools.debugTrace("RoomData:"+tRoomID+"\n"+JSONTools.getJSONString(RoomUsersSo.data),"room",RoomUsersSo.data);
	clearSo();
	return;
}

function clearSo():void
{
	RoomUsersSo.removeEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
	RoomUsersSo.close();
}
DebugTools.debugTrace("runSuccss","cmds");