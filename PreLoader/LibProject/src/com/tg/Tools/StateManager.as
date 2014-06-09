package com.tg.Tools
{

	/**
	 * 状态恢复类
	 * 用于打开其它窗口操作完成之后恢复之前的窗口
	 * @author ww
	 * 
	 */
	public class StateManager
	{
		public function StateManager()
		{
		}
		
		private static var instance:StateManager;
		
		public static function me():StateManager
		{
			if(!instance) instance=new StateManager();
			return instance;
		}
		
		/**
		 * 待恢复状态字典 
		 */
		private var stateCallDatas:Object={};
		/**
		 * 用于恢复状态的函数 
		 */
		public static var noticeHandleFun:Function;
		/**
		 * 恢复状态 
		 * @param data 恢复状态所需的数据
		 * 
		 */
		private function stateHandler(data:Object):void
		{
			if(data&&(noticeHandleFun!=null))
			{
				noticeHandleFun(data.notice,data.data);
			}
		}
		/**
		 * 添加待恢复的状态 
		 * @param stateName 状态名（建议在StateDefines中定义）
		 * @param stateData 恢复状态所需的信息
		 * 
		 */
		public function addRecoverState(stateName:String,stateData:Object):void
		{
			stateCallDatas[stateName]=stateData;
		}
		/**
		 * 添加利用Notice恢复状态的内容 
		 * @param stateName 状态名（建议在StateDefines中定义）
		 * @param notice 恢复用的notice
		 * @param data 恢复用的数据
		 * 
		 */
		public function addRecoverStateNotice(stateName:String,notice:String,data:Object=null):void
		{
			addRecoverState(stateName,{"notice":notice,"data":data});
		}
		/**
		 * 请求恢复状态 
		 * @param stateName 状态名（建议在StateDefines中定义）
		 * 
		 */
		public function dealStateRecover(stateName:String):void
		{
			if(stateCallDatas[stateName])
			{

					stateHandler(stateCallDatas[stateName]);
	
				delete stateCallDatas[stateName];
			}
		}
		/**
		 * 清除待恢复状态 
		 * @param stateName
		 * 
		 */
		public function clearStateRecover(stateName:String):void
		{
			delete stateCallDatas[stateName];
		}
	}
}