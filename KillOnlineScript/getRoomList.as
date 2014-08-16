
getRoomList();
function getRoomList():void
{
	var data:Object = new Object();
	data.AREA = "areaA";
	data.cmd = "getRoomsList";
	faced.sendNotification(GameEvents.NETCALL, data);
}
bodyAct();
function bodyAct():void
{
	var data:Object = new Object();
	data.Type = "yun";
	data.cmd = "Emot";
	faced.sendNotification(GameEvents.NETCALL, data);
}
lastSay();
function lastSay():void
{
	var data:Object = new Object();
	data.Act = "LastSay";
	data.cmd = "GameCmd_Act";
	data.Msg = "无语";
	faced.sendNotification(GameEvents.NETCALL, data);
}

function speaker():void
{
	
}