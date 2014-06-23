package killClass
{
	import com.tools.ArrayTool;
	import com.tools.DebugTools;

	public class TalkMachine
	{
		
		public var actionDic:Object={};
		public var ttList:Array=["算命","缘","姻","蛋","算","胸","美","情"];
		public var isTalkOn:Boolean;
		
		public function TalkMachine()
		{
			actionDic["算命"]=["不是美女不给算","心不诚不算","胸不大不算","没有眼缘不给算"];
			actionDic["缘"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
			actionDic["姻"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
			actionDic["蛋"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
			actionDic["算"]=["只算前程学业感情","只算前程学业感情","心不诚不算","没有眼缘不给算"];
			actionDic["胸"]=["没有C的我看都不看一眼","只算前程学业感情","心不诚不算","没有眼缘不给算"];
			actionDic["美"]=["胸没有C的我看都不看一眼","年龄","星座","没有眼缘不给算"];
			actionDic["情"]=["胸没有C的我看都不看一眼","年龄","星座","没有眼缘不给算"];
			
			isTalkOn=false;
		}
		

		public var talkFun:Function;
		
		public function talkTo(msg:String):void
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
					sendMsg=ArrayTool.getRandom(tArr);
					//DebugTools.debugTrace("talkSendMsg:"+sendMsg,"Talk",actionDic[tStr]);
					if(talkFun!=null)
					{
						talkFun(sendMsg);
					}
					
					return;
				}
			}
		}
	}
}