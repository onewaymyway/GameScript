import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import Core.model.data.MainData;

var loader:URLLoader;
var ThePage:int = 1;
var T :String;
var pid:int;
var url:String="http://t1.ss911.cn/User/Friend.ss";
pid=3140460;
ThePage=1;
T="0";
getFriendList();
function getFriendList():void
{	
	DebugTools.debugTrace("尝试获取好友信息 id:"+pid,"Friend");
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
	uv.p=ThePage;
	uv.userid=pid;
	uv.t="0";
	var rq:URLRequest = new URLRequest();
	rq.url =url;
	rq.method = URLRequestMethod.GET;
	rq.data=uv;
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
		loadData();
	}else
	{
		loader=null;
		DebugTools.debugTrace("好友结束 id:"+pid+" P:"+rst,"Friend",rst);
	}
	
}