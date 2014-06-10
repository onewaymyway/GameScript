import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import Core.model.data.MainData;

var loader:URLLoader;
//var ThePage:int = 1;
//var T :String;
//var pid:int;
var url:String="http://t1.ss911.cn/User/Friend.ss";
var friendData:Object;
friendData={};
friendData.pid=1835802;
friendData.ThePage=1;
friendData.T="0";
//pid=3140460;
//ThePage=1;
//T="0";
getFriend(1835802);
function getFriend(pid:int):void
{
      friendData={};
friendData.pid=pid;
friendData.ThePage=1;
friendData.T="0";
getFriendList();
}
//getFriendList();
function getFriendList():void
{	
	DebugTools.debugTrace("尝试获取好友信息 id:"+friendData.pid,"Friend",friendData);
//	DebugTools.debugTrace("尝试获取好友信息 id:"+friendData.pid,"Friend");
	loadData();
	
	
	
}
function loadData():void
{
	
	
	loader=new URLLoader();
	
	
	var url:String="http://t1.ss911.cn/User/Friend.ss";
	//url="http://t1.ss911.cn/User/Friend.ss?u="+MainData.LoginInfo.uservalues+"&p="+p+"&t=0&userid="+pid+"";
	DebugTools.debugTrace("url:"+url,"Friend");
	var uv:URLVariables=new URLVariables();
	uv.u=MainData.LoginInfo.uservalues;
	uv.p=friendData.ThePage;
	uv.userid=friendData.pid;
	uv.t="0";
	var rq:URLRequest = new URLRequest();
	rq.url =url;
	rq.method = URLRequestMethod.GET;
	rq.data=uv;
	loader.addEventListener(Event.COMPLETE, loaded);
	
	loader.load(rq);
	
//	DebugTools.debugTrace("loadData id:"+friendData.pid,"Friend",rq);
	
}

function loaded(e) : void
{
//	DebugTools.debugTrace("loaded id:"+friendData.pid,"Friend");
	var rst:Object = JSONTools.getJSONObject(e.target.data);
	var Data:Object= rst;
//	DebugTools.debugTrace("loaded id:"+friendData.pid,"Friend",Data);
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
	
	DebugTools.debugTrace("好友 id:"+friendData.pid+" P:"+friendData.ThePage+"/"+MaxPage,"Friend",rst);
	
	var friendList:Array;
	friendList=rst.data;
	var i:int;
	var len:int;
	var tFriend:Object;
	len=friendList.length;
	var stateList:Array;
	stateList=["离线","在线"];
	for(i=0;i<len;i++)
	{
		tFriend=friendList[i];
		DebugTools.debugTrace(tFriend.userName+":"+stateList[tFriend.online],"Friend",tFriend);
	}
	if(friendData.ThePage<MaxPage)
	{
		friendData.ThePage++;
		loadData();
	}else
	{
		loader=null;
		DebugTools.debugTrace("好友结束 id:"+friendData.pid+" P:"+friendData.ThePage,"Friend",rst);
	}
	
}