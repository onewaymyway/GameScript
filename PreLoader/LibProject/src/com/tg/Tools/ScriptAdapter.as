package com.tg.Tools
{
	import com.tools.DebugTools;
	import com.tools.LoadTools;
	
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
		
		/**
		 * 加载类定义 
		 */
		public static var loadClassFun:Function;
		
		
		
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
		
		public static function loadClass(classStr:String):void
		{
			if(!isInited) 
			{
				DebugTools.debugTrace("在初始化解释器之前执行脚本","Warning");
				return;
			}
			loadClassFun(classStr);
		}
		
		public static function loadClassList(classList:Array,backFun:Function):void
		{
			load();
			function load():void
			{
				if(classList.length<1)
				{
					backFun();
				}else
				{
					LoadTools.loadTxt(classList.shift(),loadComplete);
				}
			}
			
			function loadComplete(data:String):void
			{
				loadClass(data);
				load();
			}
		}
		
		public static function loadScriptList(scriptList:Array,backFun:Function):void
		{
			load();
			function load():void
			{
				if(scriptList.length<1)
				{
					backFun();
				}else
				{
					LoadTools.loadTxt(scriptList.shift(),loadComplete);
				}
			}
			
			function loadComplete(data:String):void
			{
				exeCmds(data);
				load();
			}
		}
	}
}