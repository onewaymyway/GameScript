

import Core.model.NetProxy;
import Core.model.data.MainData;
import Core.model.data.UserData;

import com.smartfoxserver.v2.entities.data.SFSObject;
import com.tools.DebugTools;

import flash.sampler.Sample;
import flash.sampler.getMemberNames;

import uas.LoadURL;
import uas.UStr;
import uas.mcFunc;

DebugTools.debugTrace("myID:"+UserData.UserInfo.UserId,"MSG");

DebugTools.debugTrace("myValues:"+MainData.LoginInfo.uservalues,"MSG");
DebugTools.debugTrace("server:"+MainData.LoginInfo.Server,"MSG",MainData.LoginInfo.Server);
DebugTools.debugTrace("ip:"+MainData.LoginInfo.userip,"MSG",MainData.LoginInfo);
DebugTools.debugTrace("zone:"+MainData.LoginInfo.Zone,"MSG",MainData.LoginInfo);

var data:Object;
data={};
data.a="aa";
DebugTools.debugTrace("CmdData:"+CmdData,"MSG",CmdData);
//CmdData.getData(data);
DebugTools.debugTrace("CmdData:"+CmdData.getData(data),"MSG",CmdData);
var _loc_2:* = new Object();
_loc_2.BinaryData = CmdData.getData(data);
DebugTools.debugTrace("Object:"+_loc_2,"MSG",_loc_2);
var _loc_3:* = SFSObject.newFromObject(_loc_2);
DebugTools.debugTrace("SFSObject:"+_loc_3,"MSG",_loc_3);
DebugTools.debugTrace("CmdData.prototype:"+CmdData.prototype,"MSG",CmdData.prototype);
getMemberNames(data);
var kk:*;
kk=new CmdData();

DebugTools.debugTrace("kk:"+getMemberNames(kk),"MSG",kk);
//DebugTools.debugTrace("CmdData.prototype:"+getMemberNames(data,true),"MSG",getMemberNames(CmdData));
