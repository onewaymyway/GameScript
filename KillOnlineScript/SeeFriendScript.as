

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import Core;

import Core.GameEvents;
import Core.Resource;
import Core.model.NetProxy;
import Core.model.data.MainData;
import Core.model.data.UserData;
import Core.view.PlusMediator;

import org.puremvc.as3.interfaces.IFacade;
import org.puremvc.as3.patterns.facade.Facade;

import roomEvents.KillerRoomEvents;

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

getFriendList(3140460);
//seeFriendList(3140460);
//UserData.UserInfo.UserId=3072991;
//faced.sendNotification(PlusMediator.OPEN, {url:Resource.FriendPath, x:600, y:100});

function seeFriendList(pID:int):void
{
	UserData.UserInfo.UserId=pID;
	faced.sendNotification(PlusMediator.OPEN, {url:Resource.FriendPath, x:600, y:100});
}
//sendFace();
function sendFace():void
{
	var data:* = {};
	data.Site = 1;
	data.Type = "yun";
	faced.sendNotification(KillerRoomEvents.BODYFACE, data);
	
}

function getFriendList(pid:int):void
{
	var loader:URLLoader;
	loader=new URLLoader();
	ThePage = 1;
	T = 0;
	var url:String="http://t1.ss911.cn/User/Friend.ss";
	DebugTools.debugTrace("尝试获取好友信息 id:"+pid+" P:"+Rst,"Friend",Rst);
	LoadData(ThePage);
	function LoadData(P:int):void
	{


		var data:URLVariables = new URLVariables();
		data.userid = pid;
		data.u = MainData.LoginInfo.uservalues;
		data.p = P;
		data.t = String(T);
		var rq:URLRequest = new URLRequest();
		rq.url = "/User/Friend.ss";
		rq.data = data;
		rq.method = URLRequestMethod.GET;
		loader.load(rq);
		loader.addEventListener(Event.COMPLETE, loaded);
		return;
	}// end function
	
	function loaded(e) : void
	{
		var Rst:Object = JSON.decode(e.target.data);
		Data = Rst;
		if (Data.count)
		{
		}
		if (Data.count < 1)
		{
			MaxPage = 1;
			
		}
		else
		{
			MaxPage = Math.ceil(Data.count / 11);
		}
		
		DebugTools.debugTrace("好友 id:"+pid+" P:"+Rst,"Friend",Rst);
		if(ThePage<MaxPage)
		{
			ThePage++;
			LoadData(MaxPage);
		}else
		{
			loader=null;
			DebugTools.debugTrace("好友结束 id:"+pid+" P:"+Rst,"Friend",Rst);
		}
		return;
	}// end function
}
