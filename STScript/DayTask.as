//每日任务脚本 摇钱树 四海同心 抢绣球 好友送花脚本
import com.tg.st.service.Data;
import com.tg.st.data.protocal.MoneyTreeStruct;
import com.tg.st.data.protocal.FourForOneStruct;
import com.tg.st.data.protocal.MaiYiStruct;
//摇钱树
Data.call(MoneyTreeStruct.waterTree, [0]);
//四海同心
Data.call(FourForOneStruct.join, [3]);
//摆摊
Data.call(MaiYiStruct.beginBooth,[]);


//抢绣球
import com.tg.st.service.Data;
import com.tg.st.data.protocal.GrabBallStruct;

var i:int;
var len:int;
len=20;

work();
function work():void
{
	len--;
	if(len>0)
	{
		Data.call(GrabBallStruct.grabBall,[],work);
	}
}

//好友送花 自动送脚本
import com.tg.st.data.protocal.FriendDataStruct;
import com.tg.st.service.Data;

//好友送花
Data.call(FriendDataStruct.attention_list, [], friendsBack);
var fList:Array=[];
function friendsBack(data:Array):void
{
	
	fList=data[0];
	sendOne();
}

function sendOne():void
{
	if(fList.length>0)
	{
		var tData:Object;
		tData=fList.shift();
		if(tData)
		{
			Data.call(FriendDataStruct.send_flower, [tData[0]],sendOne);
		}
	}
}