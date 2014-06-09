//群雄争霸自动打脚本



import com.tg.st.data.protocal.KuaiFuQieCuoStruct;
import com.tg.st.service.Data;
import com.tools.DebugTools;
import flash.utils.setTimeout;

var pageLeft:int;
var wanList:Array;
var roleList:Array;
var cdTime:int;

DebugTools.debugTrace("获取列表","群雄争霸");
Data.call(KuaiFuQieCuoStruct.init,[],initInfoBack);


function initInfoBack(dataArr:Array):void
{
	cdTime=dataArr[4];
	pageLeft=dataArr[1];
	DebugTools.debugTrace("获取列表成功","群雄争霸");
	init(dataArr[0]);
	
}
function fightBack(dataArr:Array):void
{
	cdTime=dataArr[5];
	if(dataArr[0]!=4)
	{
		DebugTools.debugTrace("挑战行为成功："+roleList[0]["index"]+" result："+dataArr[0],"群雄争霸");
		roleList.shift();
	}else
	{
		DebugTools.debugTrace("挑战行为失败："+roleList[0]["index"]+" result："+dataArr[0],"群雄争霸");
	}
	showState();
	setTimeout(fight,(cdTime+1)*1000);
}
function showState():void
{
	DebugTools.debugTrace("当页剩余："+roleList.length+" 刷新剩余："+pageLeft+" cd:"+cdTime,"群雄争霸");
}
function freshBack(dataArr:Array):void
{
	
	if(dataArr[0]==0)
	{
		DebugTools.debugTrace("刷新失败","群雄争霸");
		return;
	}
	
	cdTime=0;
	pageLeft=dataArr[2];
	init(dataArr[1]);
}

function fight():void
{
	if(roleList.length>0)
	{
		DebugTools.debugTrace("挑战："+roleList[0]["index"],"群雄争霸");
		Data.call(KuaiFuQieCuoStruct.fight,[roleList[0]["index"]],fightBack);
	}else
	{
		if(pageLeft>0)
		{
			DebugTools.debugTrace("当页打完，尝试刷新","群雄争霸");
			Data.call(KuaiFuQieCuoStruct.restMan,[],freshBack);
		}
	}
}
function init(arr:Array):void
{
	DebugTools.debugTrace("解析列表","群雄争霸");
	var i:int;
	var len:int;
	len=arr.length;
	wanList=[];
	roleList=[];
	var tData:Object;
	var roleData:Object;
	for(i=0;i<len;i++)
	{
		tData=arr[i];
		roleData={};
		roleData.index=i+1;
		if(tData[9]==0)
		{
			if(tData[0]>=0)
			{
				
				roleData.power=tData[4];
			}else
			{
				roleData.power=99999999999;
			}
			roleList.push(roleData);
		}
	}
	
	roleList.sortOn("power",Array.NUMERIC|Array.DESCENDING);
	DebugTools.debugTrace("解析列表成功","群雄争霸");
	showState();
	setTimeout(fight,(cdTime+1)*1000);
	
}