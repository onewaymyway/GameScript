import Core.GameEvents;
import Core.Resource;
import Core.model.NetProxy;
import Core.model.data.MainData;
import Core.model.data.UserData;
import Core.view.PlusMediator;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.tg.Tools.StringToolsLib;
import com.tg.Tools.TextTools;
import com.tg.Tools.TimeTools;
import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import org.puremvc.as3.interfaces.IFacade;
import org.puremvc.as3.patterns.facade.Facade;

import roomEvents.KillerRoomEvents;

var faced:IFacade;
faced=Facade.getInstance();
trace("faced:"+faced);
var netP:NetProxy;
trace("NetProxy.NAME)"+NetProxy.NAME);

trace(faced.retrieveProxy(NetProxy.NAME));

netP=faced.retrieveProxy(NetProxy.NAME);
trace("netp"+netP);


var cnt;
cnt=netP.connection;
cnt.addEventListener(SFSEvent.CONNECTION_RESUME,onConnectionLost);
cnt.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);

var waitTime:int;
waitTime=60*1000;

function updateState():void
{
	if(timeConnect>0)
	{
	   clearTimeout(timeConnect);
	   timeConnect=-1;
	   DebugTools.debugTrace("清除重连","断线类型");
	}else
	{
		
	}
}



var timeConnect:Number=-1;

function onConnectionLost(event:SFSEvent) : void
{
	DebugTools.debugTrace(event.type,"断线类型");
	DebugTools.debugTrace("连接断开，"+waitTime+"ms后重新连接："+StringToolsLib.getTimeStamp(TimeTools.getTimeNow()),"LoseConnect");
	
	timeConnect=setTimeout(tryLogin,waitTime);
}
function tryLogin():void
{
	faced.sendNotification(GameEvents.LOGINEVENT.LOGIN);
	
	DebugTools.debugTrace("重连","LoseConnect");
}
trace("connection"+cnt);
var copyList:Array=[];
function addCopyID(id:int):void
{
	var i:int;
	var len:int;
	len=copyList.length;
	for(i=0;i<len;i++)
	{
		if(copyList[i]==id)
		{
			return;
		}
	}
	copyList.push(id);
}
function removeCopyID(id:int):void
{
	var i:int;
	var len:int;
	len=copyList.length;
	for(i=0;i<len;i++)
	{
		if(copyList[i]==id)
		{
			copyList.splice(i,1);
			return;
		}
	}
}
var isCopyOn:Boolean;
isCopyOn=false;
var isTalkOn:Boolean;
isTalkOn=false;
var actionDic:Object={};
var ttList:Array=["算命","缘","姻","蛋","算","胸","美","情"];
actionDic["算命"]=["不是美女不给算","心不诚不算","胸不大不算","没有眼缘不给算"];
actionDic["缘"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
actionDic["姻"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
actionDic["蛋"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
actionDic["算"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
actionDic["胸"]=["没有C的我看都不看一眼","只算前程学业感情","心不诚不算","没有眼缘不给算"];
actionDic["美"]=["胸没有C的我看都不看一眼","年龄","星座","没有眼缘不给算"];
actionDic["情"]=["胸没有C的我看都不看一眼","年龄","星座","没有眼缘不给算"];
function getRandomItem(arr:Array):*
{
	var i:int;
	var len:int;
	
	len=arr.length;
	i=int(len*99*Math.random())%len;
	var rst:String;
	rst=arr[i];
	DebugTools.debugTrace("talk:"+rst+" i:"+i,"Talk",arr);
	return rst;
}
//checkInfo(2823053);
function checkInfo(uid:int):void
{
	faced.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, uid);
}
//getUInfoData(2823053);
function getUInfoData(uid:int):void
{
	var data:Object;
	data={};
	data.UserId = uid+"";
	data.cmd = "PlayerInfo";
	faced.sendNotification(GameEvents.NETCALL, data);
}

function freshWeb():void
{
	faced.sendNotification(GameEvents.REFRESH_WEB);
	
}


function talkTo(msg:String):void
{
	if(!msg)
	{
		return;
	}
	if(!isTalkOn)
	{
		return;
	}
	var tStr:String;
	var i:int;
	var len:int;
	len=ttList.length;
	
	for(i=0;i<len;i++)
	{
		tStr=ttList[i];
		if(msg.indexOf(tStr)<0)
		{
			continue;
		}
		if(actionDic[tStr])
		{
			//DebugTools.debugTrace("talkkk:"+JSONTools.getJSONString(actionDic[tStr]),"Talk",actionDic[tStr]);
			var tArr:Array;
			tArr=actionDic[tStr];
			var sendMsg:String;
			var tI:int;
			tI=Math.ceil(tArr.length*Math.random()*99)%tArr.length;
			sendMsg=tArr[tI];
			//DebugTools.debugTrace("talkSendMsg:"+sendMsg,"Talk",actionDic[tStr]);
			sendChat(sendMsg);
			return;
		}
	}
}
cnt.addEventListener(SFSEvent.EXTENSION_RESPONSE, onMsg);

var reportTypeList:Array=["Speaker","SystemMsg","HallMsg"];
//reportTypeList=["Speaker","SystemMsg"];
var msgDic:Object={};
function getMsgListByType(type:String):Array
{
	var rst:Array;
	if(msgDic[type])
	{
		rst=msgDic[type];
	}else
	{
		rst=[];
		msgDic[type]=rst;
	}
	return rst;
}
function isReportType(type:String):String
{
	var i:int;
	var len:int;
	len=reportTypeList.length;
	for(i=0;i<len;i++)
	{
		if(type.indexOf(reportTypeList[i])>=0)
		{
			return reportTypeList[i];
		}
	}
	return null;
}
function onMsg(msgO:*):void
{
	trace("get message:"+msgO);
	trace(msgO.params);
	var responseParams:* = msgO.params.params;
	var cmd:*;
	cmd={};
	cmd = responseParams.toObject();
	trace("cmd"+cmd);
	trace("responseParams)"+responseParams);
	var type:String;
	type=msgO.params.cmd;
	DebugTools.debugTrace(msgO.params.cmd+"\n"+JSONTools.getJSONString(cmd),msgO.params.cmd,cmd);
	//DebugTools.debugTrace("msgO.params","MSG",msgO.params);
	//DebugTools.debugTrace("type:"+type.indexOf("Speaker")>=0,"types",msgO.params);
	//DebugTools.debugTrace("type:"+type+":"+type.length,"types",msgO.params);
	
	if(isReportType(type))
	{
		
		updateState();
//		cmd.mType=isReportType(type);
		//dealSpeaker(cmd,isReportType(type));
	}

	if(cmd["UserId"]==UserData.UserInfo.UserId)
	{
		return;
	}
	if(!cmd["UserId"]) 
	{
		return;
	}
	if(cmd["UserName"])
	{
		var tUserData:Object;
		tUserData={};
		tUserData["name"]=cmd["UserName"];
		tUserData["id"]=cmd["UserId"];
		DebugTools.debugTrace(cmd["UserName"],"Names",tUserData);
	}
	var tmsg:String;
	tmsg=cmd["Msg"];
	if(!tmsg) 
	{
		return;
	}
	
	if(isCopyOn)
	{
		if(tmsg.indexOf("别学我")>=0)
		{
			removeCopyID(cmd["UserId"]);
			sendChat(cmd["UserName"]+"离开复读列表");
		}else
		{
			if(tmsg.indexOf("学我说话")>=0)
			{
				addCopyID(cmd["UserId"]);
				
				sendChat(cmd["UserName"]+"加入复读列表");
				return;
			}
		}
	}

	
	var i:int;
	var len:int;
	len=copyList.length;
	if(isCopyOn)
	{
		for(i=0;i<len;i++)
		{
			if(cmd["UserId"]==copyList[i])
			{
				sendChat(cmd["Msg"]);
				return;
			}
		}
	}

	
	talkTo(cmd["Msg"]);
	//if(cmd["UserId"]==2002671||cmd["UserId"]==3106306||3067010==cmd["UserId"])
	// {
	//   sendChat(cmd["Msg"]);
	// }
}
function sendChat(msg:String):void
{
	var data = new Object();
	data.Msg = msg;
	data.Color = "";
	data.cmd = "SayInRoom";
	faced.sendNotification(GameEvents.NETEVENT.NETCALL, data);
	
}

//var speakList:Array=[];
function dealSpeaker(msg:Object,type:String):void
{
	//DebugTools.debugTrace("收集数据："+speakList.length,"Report");
	msg.time=TimeTools.getTimeNow();
	JSONTools.adaptForJSON(msg);
	var tList:Array;
	tList=getMsgListByType(type);
	tList.push(msg);
	DebugTools.debugTrace("收集数据"+type+"："+tList.length,"Report");
	if(tList.length>=10)
	{
		reportSpeakesToSever(type,tList);
	}
}
var loader:URLLoader;
loader=new URLLoader();
loader.addEventListener(Event.COMPLETE, reportResult);
loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErro);
loader.addEventListener(IOErrorEvent.IO_ERROR,ioErro);
function reportSpeakesToSever(type:String,data:Array):void
{
	
	
	
	var url:String="http://sogasoga.sinaapp.com/killOnline/getcontent.php";
	//url="http://t1.ss911.cn/User/Friend.ss?u="+MainData.LoginInfo.uservalues+"&p="+p+"&t=0&userid="+pid+"";
	var dataStr:String;
	dataStr=JSONTools.getJSONString(data);
	dataStr=TextTools.getPlainText(dataStr);
	data.splice(0,data.length);
	DebugTools.debugTrace("上传收集数据:"+type+"\n"+dataStr,"Report",data);
	var uv:URLVariables=new URLVariables();
	uv.action="put";
	uv.content=dataStr;
	uv.type=type;
	
	var rq:URLRequest = new URLRequest();
	rq.url =url;
	rq.method = URLRequestMethod.GET;
	rq.data=uv;
	

	loader.load(rq);
	DebugTools.debugTrace("上传喇叭end","Report");
}
function securityErro(e:Event):void
{
	DebugTools.debugTrace("上传收集数据失败 securityErro","Report");
}
function ioErro(e:Event):void
{
	DebugTools.debugTrace("上传收集数据失败 ioErro","Report");
}
function reportResult(e):void
{
	DebugTools.debugTrace("上传收集数据成功:"+JSONTools.getJSONObject(e.target.data),"Report");
}
DebugTools.debugTrace("run success","CMDS");
