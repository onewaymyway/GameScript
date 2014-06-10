import Core;
import Core.GameEvents;
import Core.Resource;
import Core.model.NetProxy;
import Core.model.data.MainData;
import Core.model.data.UserData;
import Core.view.PlusMediator;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.utils.Dictionary;

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

trace("connection"+cnt);
var copyList:Array=[2002671,3106306,3067010];
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

function talkTo(msg:String):void
{
	if(!msg)
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
	DebugTools.debugTrace(JSONTools.getJSONString(cmd),"MSG",cmd);
	
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
	if(tmsg.indexOf("别学我")>=0)
	{
		removeCopyID(cmd["UserId"]);
	}else
	{
		if(tmsg.indexOf("学我说话")>=0)
		{
			addCopyID(cmd["UserId"]);
		}
	}
	
	var i:int;
	var len:int;
	len=copyList.length;
	for(i=0;i<len;i++)
	{
		if(cmd["UserId"]==copyList[i])
		{
			sendChat(cmd["Msg"]);
			return;
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


trace("import success");
