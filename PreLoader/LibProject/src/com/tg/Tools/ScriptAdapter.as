package com.tg.Tools
{
	import com.tools.DebugTools;
	
	import flash.display.DisplayObject;

	/**
	 * 脚步解释器适配器
	 * @author ww
	 * 
	 */
	public class ScriptAdapter
	{
		public function ScriptAdapter()
		{
		}
		/**
		 * 解释器初始化函数
		 */
		public static var initFun:Function;
		/**
		 * 执行脚本函数
		 */
		public static var exeCmdsFun:Function;
		
		
		private static var isInited:Boolean=false;
		/**
		 * 初始化脚步
		 * @param root 脚步上下文
		 * 
		 */
		public static function initScript(root:DisplayObject):Boolean
		{
			if(isInited)
			{
				return true;
			}else
			{
				
				if(initFun==null) return false;
				initFun(root);
				isInited=true;
				return true;
			}
		}
		
		/**
		 * 执行脚本
		 * @param script
		 * 
		 */
		public static function exeCmds(script:String):void
		{
			if(!isInited) 
			{
				DebugTools.debugTrace("在初始化解释器之前执行脚本","Warning");
				return;
			}
			exeCmdsFun(script);
		}
	}
}