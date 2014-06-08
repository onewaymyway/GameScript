

	import Core;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import Core.model.NetProxy;
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.tools.DebugTools;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.tools.JSONTools;
	import Core.GameEvents;
	import roomEvents.KillerRoomEvents;
	import Core.view.PlusMediator;
	import Core.Resource;
	import Core.model.data.UserData;
	import Core.model.data.MainData;
	
	var myID:int;
	myID=1549754;
	var faced:IFacade;
	faced=Facade.getInstance();
	trace("faced:"+faced);
	var data = new Object();
	data.Msg = "聊天测试啊qqqq";
	data.Color = "";
    data.cmd = "SayInRoom";
	//faced.sendNotification(GameEvents.NETEVENT.NETCALL, data);
	//faced.sendNotification(KillerRoomEvents.PLAYERLIST_OPEN);
	DebugTools.debugTrace("myID:"+UserData.UserInfo.UserId,"MSG");
	
	DebugTools.debugTrace("myValues:"+MainData.LoginInfo.uservalues,"MSG");
	//3046791


	seeFriendList(3140460);
	//UserData.UserInfo.UserId=3072991;
	//faced.sendNotification(PlusMediator.OPEN, {url:Resource.FriendPath, x:600, y:100});
	
	function seeFriendList(pID:int):void
	{
	UserData.UserInfo.UserId=pID;
	faced.sendNotification(PlusMediator.OPEN, {url:Resource.FriendPath, x:600, y:100});
	}
	sendFace();
	function sendFace():void
	{
	var data:* = {};
	data.Site = 1;
	data.Type = "yun";
   faced.sendNotification(KillerRoomEvents.BODYFACE, data);

}
