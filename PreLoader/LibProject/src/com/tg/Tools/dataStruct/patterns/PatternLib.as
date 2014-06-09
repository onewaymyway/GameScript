package com.tg.Tools.dataStruct.patterns
{
	import com.tg.st.commonData.CommonData;

	public class PatternLib
	{
		public static const ChangeSignPattern:String="changeSignPattern";
		public static const WinEffectPattern:String="WinEffectPattern";
		public static const InfectPattern:String="InfectPattern";
		public function PatternLib()
		{
			
			patternLib={};
			patternLib[ChangeSignPattern]=[10,50,80];
			patternLib[WinEffectPattern]=[-20,30,60];
			patternLib[InfectPattern]=[-1,1,2];
			
			patternEnableList=[ChangeSignPattern,InfectPattern,WinEffectPattern];
		}
		
		public var patternEnableList:Array;
		private static var _instance:PatternLib;
		
		public static function get me():PatternLib
		{
			if(!_instance) _instance=new PatternLib;
			return _instance;
		}
		
		
//		public const changeSignPattern:Array=[10,50,80];
		
		public var patternLib:Object;
		
		public static function hasPattern(sign:String):Boolean
		{
			if(!PatternLib.me.patternLib.hasOwnProperty(sign)) return false;
			return PatternLib.me.patternLib[sign] is Array;
		}
		public static function getPatternBySign(sign:String):Array
		{
			if(!hasPattern(sign)) return [];
			return PatternLib.me.patternLib[sign];
		}
		
		public static function getPatternDataBySign(sign:String,param:int):Array
		{
		   return getPatternDataByArr(param,getPatternBySign(sign));	
		}
		
		
		public static function getPatternDataByArr(param:int,arr:Array):Array
		{
			var rst:Array;
			var i:int;
			var len:int;
			var tX:int;
			var tY:int;
			tX=CommonData.playerX;
			tY=CommonData.playerY;
			len=arr.length;
			tY-=tY%arr.length;
			tY+=param;
			rst=[];
			rst.push([tX,tY]);
			for(i=0;i<len;i++)
			{
				tX+=arr[i];
				rst.push([tX,tY]);
			}
			//			rst.push(rst[0]);
			return rst;
		}
		
		
	}
}