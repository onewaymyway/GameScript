package com.tg.st.Task.bean
{
	public class TaskConsts
	{
		public function TaskConsts()
		{
		}
		/**
		 * 主线任务副本
		 */
		public static const Task_Type_Main:String="MainTask";
		/**
		 * 支线任务副本
		 */
		public static const Task_Type_Sub:String="SubTask";
		/**
		 * 指导任务
		 */
		public static const Task_Type_Guid:String="GuidTask";
		/**
		 * 平反王任务副本
		 */
		public static const Task_Type_King:String="KingTask";
		/**
		 * 18好汉任务副本
		 */
		public static const Task_Type_Man18:String="Man18Task";
		/**
		 * 英雄任务副本
		 */
		public static const Task_Type_Hero:String="HeroTask";
		/**
		 * 城市间切换任务，人物在地图中寻路
		 */
		public static const Task_Type_Walk:String="Task_Type_Walk";
		public static const Task_TypeArr:Array=[
			TaskConsts.Task_Type_Main,//0
			TaskConsts.Task_Type_King,//1
			TaskConsts.Task_Type_Man18,//2
			TaskConsts.Task_Type_Hero,//3
			TaskConsts.Task_Type_Walk,//4
		];
		
		public static const Task_idTypeList:Array=
			[
				TaskConsts.Task_Type_Main,//0
				TaskConsts.Task_Type_Main,//1
				TaskConsts.Task_Type_Hero,//2
				TaskConsts.Task_Type_Man18,//3
			];
		
		public static function  getTaskTypeByID(id:int):String
		{
			return Task_idTypeList[id];
		}
		public static const TaskTypeID_Main:int=1;
		public static const TaskTypeID_Elite:int=2;
		public static const TaskTypeID_Man18:int=3;
		
		public static const TaskStypeID_Main:int=1;
		public static const TaskStypeID_Sub:int=2;
		public static const TaskStypeID_Guide:int=3;
		
		public static const MissionState_canHang:int=1;
		public static const MissionState_canEnter:int=2;
		public static const MissionState_locked:int=3;
		public static const MissionState_FightedLocked:int=4;
		public static const MissionState_NotOpen:int=4;
		/**
		 * 等级可接
		 */
		public static const Task_state_levelToAccept:int=2;
		/**
		 * 可接
		 */
		public static const Task_state_toAccept:int=1;
		/**
		 * 已接未完成
		 */
		public static const Task_state_Accepted:int=3;
		/**
		 * 已完成未提交 
		 */		
		public static const Task_state_Complete:int=4;
		/**
		 * 已提交 
		 */
		public static const Task_state_Submitted:int=5;
		
		public static const Cost_Elite:int=10;
		public static const Cost_Man18:int=10;
		public static const Cost_Main:int=5;
		
		
		//指导任务标志定义
//		public static const Task_Type_Main:String="MainTask";
		
		public static var Task_beginID:int=1;
		public static var Task_endID:int=34;
		
	}
}