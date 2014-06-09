package com.tg.Tools.dataStruct.patterns
{
	public class PatternMatchMachine
	{
		public function PatternMatchMachine()
		{
			reset();
			_preActionData={"x":0,"y":0};
		}
		
		public var _stateList:Array;
		public var _tState:int;
		public var _matchedCallBack:Function;
		public var _preActionData:Object;
		public var patternSign:String="pattern";
		
		public var resultData:Object;
		
		/**
		 * 处理新的状态
		 * @param actionData
		 * 
		 */
		public function dealAction(actionData:Object):void
		{
			if(getNextActionValue()==getTActionValue(actionData))
			{
				tActionMatched(actionData);
			}else
			{
				_preActionData=actionData;
				reset();
			}
		}
		
		/**
		 * 当前状态的值
		 * @param actionData
		 * @return 
		 * 
		 */
		protected function getTActionValue(actionData:Object):int
		{
			return actionData.x-_preActionData.x;
		}
		/**
		 * 匹配需要的值
		 * @return 
		 * 
		 */
		protected function getNextActionValue():int
		{
			return _stateList[_tState];
		}
		
		/**
		 * 当前状态匹配成功
		 * @param actionData
		 * 
		 */
		protected function tActionMatched(actionData:Object):void
		{
			_tState++;
			_preActionData=actionData;
			if(isMatched())
			{
				createResultData();
				patternMatched();
				reset();
			}
		}
		
		/**
		 * 判断是否模式匹配完成
		 * @return 
		 * 
		 */
		protected function isMatched():Boolean
		{
			if(_tState>=_stateList.length)
			{
				return true;
			}
			return false;
		}
		/**
		 * 匹配完成后创建结果对象
		 * 
		 */
		protected function createResultData():void
		{
			resultData=_preActionData;
		}
		/**
		 * 匹配完成
		 * 
		 */
		protected function patternMatched():void
		{
			
			if(_matchedCallBack!=null)
			{
				if(_matchedCallBack.length==1)
				{
					_matchedCallBack(this);
				}else
				{
					_matchedCallBack();
				}
				
			}
		}
		/**
		 * 重置
		 * 
		 */
		protected function reset():void
		{
			_tState=0;

		}
		
		/**
		 * 创建动作匹配类
		 * @param sign 模式sign PatternLib中定义
		 * @param callBack 匹配完成后的回调
		 * @return 匹配类
		 * 
		 */
		public static function createCommonPattern(sign:String,callBack:Function=null):PatternMatchMachine
		{
			var rst:PatternMatchMachine;
			rst=new PatternMatchMachine();
			rst._stateList=PatternLib.getPatternBySign(sign);
			rst._matchedCallBack=callBack;
			rst.patternSign=sign;
			return rst;
		}
	}
}