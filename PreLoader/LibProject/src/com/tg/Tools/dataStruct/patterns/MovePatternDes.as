package com.tg.Tools.dataStruct.patterns
{
	import com.tg.Tools.FunctionTools;
	import com.tg.Tools.UserActionSensor;

	public class MovePatternDes
	{
		
		public static const ChangeSignParttern:Array=[10,50,80];
		public static const ChangeList:Array=["YangGuangBOSS","AnLuShanBOSS","QinQiong"];
		
		public function MovePatternDes()
		{
			tState=0;
			
			patternList=[];
//			patternList.push(PatternMatchMachine.createCommonPattern(PatternLib.ChangeSignPattern,patternMatched));
//			patternList.push(PatternMatchMachine.createCommonPattern(PatternLib.WinEffectPattern,patternMatched));
			
			var i:int;
			var len:int;
			var tSign:String;
			var sList:Array;
			sList=PatternLib.me.patternEnableList;
			len=sList.length;
			for(i=0;i<len;i++)
			{
				patternList.push(PatternMatchMachine.createCommonPattern(sList[i],patternMatched));
				
			}
//			changeSignMachine=PatternMatchMachine.createCommonPattern(PatternLib.ChangeSignPattern,patternMatched);
//			changeSignMachine._matchedCallBack=changeSignMatched;
		}
		public var preX:int;
		public var preY:int;
		public var pid:int;
		public var tState:int;
		
//		private var changeSignMachine:PatternMatchMachine;
		
		private var patternList:Array;
		
		
//		private function changeSignMatched():void
//		{
//			
//			trace("changeSignMatched");
//			var tSign:String;
//			tSign=ChangeList[changeSignMachine._preActionData.y%ChangeList.length];
//			UserActionSensor.me.playerTryChange(pid,tSign);
//		}
		
		public static var patternMatchedCallBack:Function;
		private function patternMatched(pattern:PatternMatchMachine):void
		{
			trace("signMatched:"+pattern.patternSign);
		
			FunctionTools.callFunction(patternMatchedCallBack,[pid,pattern]);
		}
		
		public function dealMove(x:int,y:int):void
		{
			var actionData:Object;
			actionData={"x":x,"y":y};
			
			var i:int;
			var len:int;
			var tPattern:PatternMatchMachine;
			len=patternList.length;
			for(i=0;i<len;i++)
			{
				tPattern=patternList[i];
				if(tPattern)
				{
					tPattern.dealAction(actionData);
				}
			}
//			changeSignMachine.dealAction(actionData);
			
		}
		
		public static function getChangeSign(signID:int):String
		{
			return ChangeList[signID%ChangeList.length];
		}
		public static function getPatternData(tX:int,tY:int,signID:int=1):Array
		{
			var rst:Array;
			var i:int;
			var len:int;
			len=ChangeSignParttern.length;
			tY-=tY%ChangeList.length;
			tY+=signID;
			rst=[];
			rst.push([tX,tY]);
			for(i=0;i<len;i++)
			{
				tX+=ChangeSignParttern[i];
				rst.push([tX,tY]);
			}
//			rst.push(rst[0]);
			return rst;
		}

	}
}