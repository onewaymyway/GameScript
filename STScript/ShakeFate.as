
//摇战魂脚本
import com.tg.st.data.protocal.FateDataStruct;
import com.tg.st.mod.Notice;
import com.tg.st.service.Data;
import com.tg.util.Notifier;
import com.tools.DebugTools;

var i:int;
var len:int;
len=40;
var seeCount:int;
seeCount=2;

shake();
function shake():void
{
	len--;
	if(len>0)
	{
		Data.call(FateDataStruct.shake,[],shakeBack);
	}else
	{
		openPanel();
	}
}
//##################### 摇 ################
//协议号:18000
//c >> s:
//s >> c:
//array(滚动面战魂
//	int:16	位置
//	int:32	战魂id号
//	int:16	战魂等级
//	int:32	经验值
//)
//array(背包战魂
//	int:16	位置
//	int:32	战魂id号
//	int:16	战魂等级
//	int:32	经验值
//)
//锁
//array(
//	int:16	位置
//	int:8	1：锁，0：未锁
//)
//int:16	免费摇动的次数
//int:16	锁定后累积摇动次数
//int:8	0：失败 1：成功 3：摇动失败
function shakeBack(dataList:Array):void
{
	var rst:int;
	rst=dataList[5];
	if(rst==1)
	{
		var fateList:Array;
		fateList=dataList[0];
		var i:int;
		var len:int;
		var fateDic:Object;
		fateDic={};
		len=fateList.length;
		var tFateID:int;
		for(i=0;i<len;i++)
		{
			tFateID=fateList[i][1];
			if(tFateID>300&&tFateID<600)
			{
				if(!fateDic[tFateID])
				{
					fateDic[tFateID]=1;
				}else
				{
					fateDic[tFateID]=fateDic[tFateID]+1;

				}
				if(fateDic[tFateID]>=seeCount)
				{
					DebugTools.debugTrace("摇出"+fateDic[tFateID]+"个高级战魂："+tFateID,"战魂");
					openPanel();
					return;
				}
			}
		}
		shake();
	}else
	{
		DebugTools.debugTrace("摇战魂出错","战魂");
		openPanel();
	}
}

function openPanel():void
{
	Notifier.notify(Notice.FATE_CLICK);
}