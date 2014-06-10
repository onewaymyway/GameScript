

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
//var data = new Object();
//data.Msg = "聊天测试啊qqqq";
//data.Color = "";
//data.cmd = "SayInRoom";
//faced.sendNotification(GameEvents.NETEVENT.NETCALL, data);
//faced.sendNotification(KillerRoomEvents.PLAYERLIST_OPEN);
DebugTools.debugTrace("myID:"+UserData.UserInfo.UserId,"MSG");

DebugTools.debugTrace("myValues:"+MainData.LoginInfo.uservalues,"MSG");
//3046791

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

var loader:URLLoader;
var ThePage:int = 1;
var T :int= 0;
var pid:int;
var url:String="http://t1.ss911.cn/User/Friend.ss";
pid=3140460;
getFriendList(pid);
function getFriendList(pid:int):void
{
	
	
	
	
	DebugTools.debugTrace("尝试获取好友信息 id:"+pid,"Friend");
	loadData(ThePage);
	
	
	
}
function loadData(p:int):void
{
	
	
	loader=new URLLoader();

	
	var url:String="http://t1.ss911.cn/User/Friend.ss?u=usrvar&p=1&t=0&userid=1548710";
	url="http://t1.ss911.cn/User/Friend.ss?u="+MainData.LoginInfo.uservalues+"&p="+p+"&t=0&userid="+pid+"";
	DebugTools.debugTrace("url:"+url,"Friend");
	var rq:URLRequest = new URLRequest();
	rq.url =url;
	rq.method = URLRequestMethod.GET;
	
	loader.addEventListener(Event.COMPLETE, loaded);
	
	loader.load(rq);
	
	DebugTools.debugTrace("loadData id:"+pid,"Friend",rq);
	
}

function loaded(e) : void
{
	DebugTools.debugTrace("loaded id:"+pid,"Friend");
	var rst:Object = JSONTools.getJSONObject(e.target.data);
	var Data:Object= rst;
	DebugTools.debugTrace("loaded id:"+pid,"Friend",Data);
	var MaxPage:int;
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
	
	DebugTools.debugTrace("好友 id:"+pid+" P:"+rst,"Friend",rst);
	if(ThePage<MaxPage)
	{
		ThePage++;
		loadData(ThePage);
	}else
	{
		loader=null;
		DebugTools.debugTrace("好友结束 id:"+pid+" P:"+rst,"Friend",rst);
	}
	
}
