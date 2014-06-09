package com.tg.Tools
{
	import com.tg.StageUtil;
	import com.tg.Tools.dataStruct.AutoTipDes;
	import com.tg.display.PublicSkin;
	import com.tg.st.Task.bean.TaskConsts;
	import com.tg.st.commonData.CommonData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 新手引导类
	 * @author ww
	 * 
	 */
	public class GuidManager
	{
		public function GuidManager()
		{
			StageUtil.stage.addEventListener(MouseEvent.MOUSE_DOWN,click);
			StageUtil.stage.addEventListener(Event.RESIZE,resize);
		}
		
		
		private static var _instance:GuidManager;
		
		public static function get me():GuidManager
		{
			if(!_instance) _instance=new GuidManager;
			return _instance;
		}
	
		
		/**
		 * 默认tip 
		 */
		public var helpTip:MovieClip;
		
		/**
		 * 默认放置tip的容器
		 */
		public var container:DisplayObjectContainer;
		
		
		//
		//指导框类型定义
		//
		public static const Type_ToContinue:int=1;
		public static const Type_ToClose:int=2;
		public static const Type_ToGetTask:int=3;
		public static const Type_ToAutoRun:int=4;
		public static const Type_ToSubmitTask:int=5;
		public static const Type_ToEnterMission:int=6;
		public static const Type_ToHang:int=7;
		public static const Type_ToHangMission:int=8;
		public static const Type_ToBackTown:int=9;
		public static const Type_Begin:int=10;
		public static const Type_End:int=11;
		public static const TipSignList:Array=
			[
				"点击继续",//0
				"点击继续",//1
				"点击关闭",//2
				"点击任务栏领取任务",//3
				"点击任务自动寻路",//4
				"点击提交任务",//5
				"点击当前任务关卡",//6
				"点击挂机",//7
				"点击挂机副本",//8
				"点击回到城镇",//9
				"开始指导",//10
				"结束指导",//11
				"点击继续",//12
			];
		
		//
		//任务过程定义
		//
		public static const State_Empty:int=0;
		public static const State_TaskToClick:int=1;
		public static const State_TaskToTalkToNPC:int=2;
		public static const State_toEnterMission:int=3;
		public static const State_goPassMission:int=4;
//		public static const State_TaskToTalk
		
		/**
		 * 当前加tip的对象
		 */
		private var tTarget:*;
		/**
		 * 当前的tip
		 */
		private var tTip:DisplayObject;
		
		/**
		 * 当前引导的任务信息 
		 */
		public var tTaskInfo:Object;
		
		/**
		 * 当前引导任务的进度状态 
		 */
		private var tState:int;
		
		/**
		 * 引导的最大等级数 
		 */
		public static var MaxLevel:int=40;
		
		/**
		 * 是否刚升到最大等级 
		 */
		public static var isUpToMaxLevel:Boolean=false;
		
		/**
		 * 设置当前引导任务的进度 
		 * @param state
		 * 
		 */
		public function setTaskState(state:int):void
		{
			if(!tTaskInfo) return;
			tState=state;
		}
		
		/**
		 * 获取tip 
		 * @param id
		 * @return 
		 * 
		 */
		public function getGuideIconByID(id:int):MovieClip
		{
			if(!TipSignList[id]) id=0;
			return PublicSkin.instance.getSkin(TipSignList[id]);
		}
		/**
		 * 设置当前引导的任务信息 
		 * @param taskO
		 * 
		 */
		public function setTaskInfo(taskO:Object):void
		{
			tTaskInfo=taskO;
			if(!tTaskInfo) return;
			switch(tTaskInfo.state)
			{
				case TaskConsts.Task_state_Complete:
					setTaskState(State_TaskToClick);
					break;
				case TaskConsts.Task_state_Accepted:
					setTaskState(State_TaskToClick);
					break;
				case TaskConsts.Task_state_toAccept:
					setTaskState(State_TaskToClick);
					break;
				case TaskConsts.Task_state_levelToAccept:
					setTaskState(State_Empty);
					break;
				default:
					setTaskState(State_Empty);
			}
		}
		
		/**
		 * 是否开启自动引导功能 
		 */
		private var autoTaskEnable:Boolean=true;
		/**
		 *  是否引导副本任务（任务栏）
		 * @param auto
		 * 
		 */		
		public function setAutoTaskGuidEnable(auto:Boolean):void
		{
			autoTaskEnable=auto;
			if(autoTaskEnable)
			{
				tryStartTaskAutoGuid();
			}
		}
		
		/**
		 * 获取当前的状态
		 * @return 
		 * 
		 */
		public function get taskState():int
		{
			if(!CommonData.playerBean) return State_Empty;
			if(CommonData.playerBean.level>MaxLevel) return State_Empty;
			if(!tTaskInfo) return State_Empty;
			return tState;
		}
		
		/**
		 * 当前是否处于引导状态
		 * @return 
		 * 
		 */
		public function get isAutoHelp():Boolean
		{
			if(!CommonData.playerBean) return false;
			if(CommonData.playerBean.level>MaxLevel) return false;
			var data:Object=CommonData.playerBean;
			
			if(!tTaskInfo) return false;
			return true;
		}
		
		/**
		 * 当前的指导任务集合 
		 */
		private var guideTaskO:Object={};
		/**
		 * 设置当前的任务列表 
		 * @param taskList
		 * 
		 */
		public function setTaskList(taskList:Array):void
		{
			guideTaskO={};
			
			var i:int;
			var len:int;
			var tTask:Object;
			len=taskList.length;
			for(i=0;i<len;i++)
			{
				tTask=taskList[i];
				if(tTask.stype==TaskConsts.TaskStypeID_Guide)
				{
					guideTaskO[tTask.taskSign]=true;
					guideTaskIDToSign[tTask.taskSign]=tTask.id;
				}
				
			}
//			guideTaskO["zhenxing_shan"]=true;
		}
		
		private var guideTaskIDToSign:Object={};

		public function getGuidTaskIDBySign(taskSign:String):int
		{
			return guideTaskIDToSign[taskSign];
		}
		/**
		 * 当前是否有指导任务 
		 * @param taskSign 任务Sign
		 * @return 
		 * 
		 */
		public function isGuidTaskBySign(taskSign:String):Boolean
		{
//			if(!CommonData.playerBean) return false;
//			if(CommonData.playerBean.level>MaxLevel) return false;
			return guideTaskO[taskSign];
//			return true;
		}
		
		public static const defaultWaitTime:int=10;
		public static const newTaskWaitTIme:int=20;
		private var tWaitTime:int;
		
		private var tAutoControl:Boolean;
		
		/**
		 * 显示普通引导tip 
		 * @param target
		 * @param type
		 * @param autoControl
		 * @param waitTime
		 * @param clearPre
		 * 
		 */		
		public function showTipAuto(target:*,type:int=Type_ToContinue,autoControl:Boolean=true,waitTime:int=defaultWaitTime,clearPre:Boolean=true):void
		{
		
			if(clearPre)
			{
				clearAllWaitTip();
			}
			addAutoTipID(target,type,0,autoControl,waitTime);

		}

		/**
		 * 显示任务栏的引导tip 
		 * @param target
		 * @param type
		 * @param autoControl
		 * @param waitTime
		 * @param clearPre
		 * 
		 */
		public function showTaskAutoTip(target:*,type:int=Type_ToContinue,autoControl:Boolean=true,waitTime:int=defaultWaitTime,clearPre:Boolean=false):void
		{
			
			if(clearPre)
			{
				clearAllWaitTip();
			}
			trace("showTaskAutoTip:"+target.name);
			removeAutoTipDes(tTaskAutoTipDes);
			clearTaskAutoTip();
			tTaskAutoTipDes=new AutoTipDes();
			tTaskAutoTipDes.autoControl=autoControl;
			tTaskAutoTipDes.target=target;
			tTaskAutoTipDes.time=0;
			tTaskAutoTipDes.tipID=type;
			tTaskAutoTipDes.tip=getGuideIconByID(type);
			if(CommonData.isInTown&&autoTaskEnable)
			{
				addAutoTipDes(tTaskAutoTipDes);
				if(!tAutoTipDes)
				{
					showNextTip();
				}
			}
			
		}

		/**
		 * 清除任务栏的引导对象 
		 * 
		 */
		public function clearTaskAutoTip():void
		{
			if(tTaskAutoTipDes)
			{
				if(tAutoTipDes==tTaskAutoTipDes)
				{
					tAutoTipDes=null;
				}
				tTaskAutoTipDes.clear();
				tTaskAutoTipDes=null;
			}
		}
		
		public function stopAutoGuidTask():void
		{
			clearTip();
			clearTimeout(autoClickT);
			clearTimeout(tTime);
			clearTimeout(autoTaskTipT);
			
		}
		/**
		 * 当前的任务栏引导对象
		 */
		private var tTaskAutoTipDes:AutoTipDes;
		
		/**
		 * 当前的引导对象队列
		 */
		private var tTipList:Array=[];
		
		/**
		 * 清空引导对象列表
		 * 
		 */
		public function clearAllWaitTip():void
		{
			var i:int;
			var len:int;
			var tDes:AutoTipDes;
			len=tTipList.length;
			for(i=0;i<len;i++)
			{
				tDes=tTipList[i];
				if(tDes&&(tDes!=tTaskAutoTipDes))
				{
					tDes.clear();
				}
			}
			
			tTipList.splice(0,tTipList.length);
			tAutoTipDes=null;
		}
		/**
		 * 向引导列表中添加引导元素
		 * @param target
		 * @param tipID
		 * @param time
		 * @param autoControl
		 * @param waitTime
		 * @param backFun
		 * 
		 */
		public function addAutoTipID(target:*,tipID:int,time:int=0,autoControl:Boolean=true,waitTime:int=defaultWaitTime,backFun:Function=null):void
		{
			var tDes:AutoTipDes;
			tDes=new AutoTipDes();
			tDes.target=target;
			tDes.completeFun=backFun;
			tDes.time=time;
			tDes.tipID=tipID;
			tDes.tip=getGuideIconByID(tipID);
//			tTipList.push(tDes);
			addAutoTipDes(tDes);
			if(!tAutoTipDes)
			{
				showNextTip();
			}
		}
       
		/**
		 * 向引导列表中添加引导元素
		 * @param target
		 * @param tip
		 * @param time
		 * @param autoControl
		 * @param waitTime
		 * @param backFun
		 * 
		 */
		public function addAutoTip(target:*,tip:DisplayObject,time:int=0,autoControl:Boolean=true,waitTime:int=defaultWaitTime,backFun:Function=null,force:Boolean=false,showWait:int=500,evtType:int=AutoTipDes.DownClick):void
		{
			var tDes:AutoTipDes;
			tDes=new AutoTipDes();
			tDes.target=target;
			tDes.completeFun=backFun;
			tDes.time=time;
			tDes.tip=tip;
			tDes.force=force;
			tDes.waitTime=waitTime;
			tDes.showWaitTime=showWait;
			tDes.autoControl=autoControl;
			tDes.eventType=evtType;
//			tTipList.push(tDes);
		 
			addAutoTipDes(tDes);
			if(!tAutoTipDes)
			{
				showNextTip();
			}
		}
		
		/**
		 * 设置指导任务Tip 
		 * @param target 点击对象
		 * @param tip  
		 * @param time  点击次数
		 * @param autoControl 是否自动点击
		 * @param waitTime 延迟 单位 秒
		 * @param backFun 点击后的回调
		 * @param force 是否强制
		 * 
		 */
		public function setGuidAutoTip(target:*,tip:DisplayObject,time:int=0,autoControl:Boolean=true,waitTime:int=defaultWaitTime,backFun:Function=null,force:Boolean=true,showWait:int=500,evtType:int=AutoTipDes.DownClick):void
		{
			clearAllWaitTip();
			addAutoTip(target,tip,time,autoControl,waitTime,backFun,force,showWait,evtType);
		}
		/**
		 * 从引导列表中删除引导tip 
		 * @param autoDes
		 * 
		 */
		private function removeAutoTipDes(autoDes:AutoTipDes):void
		{
			if(!autoDes) return;
			var i:int;
			var len:int;
			var tDes:AutoTipDes;
			len=tTipList.length;
			for(i=len-1;i>=0;i--)
			{
				tDes=tTipList[i];
				if(tDes)
				{
					if(!tDes.target||(tDes.target as DisplayObject).stage==null)
					{
						tTipList.splice(i,0);
						tDes.clear();
						continue;
					}
					if(tDes.target==autoDes.target)
					{
						tTipList.splice(i,0);
						if(tDes!=autoDes)
						tDes.clear();
					}
				}
			}
		}
		/**
		 * 向引导列表中添加一个引导tip 
		 * @param autoDes
		 * 
		 */
		private function addAutoTipDes(autoDes:AutoTipDes):void
		{
			removeAutoTipDes(autoDes);
			
			tTipList.push(autoDes);
		}
							   
		/**
		 * 是否是当前的指导的主线或支线任务 
		 * @param taskO
		 * @return 
		 * 
		 */
		public function isGuidTask(taskO:Object):Boolean
		{
			if(!CommonData.playerBean) return false;
			if(CommonData.playerBean.level>MaxLevel) return false;
			var data:Object=CommonData.playerBean;
			if(!tTaskInfo) return false;
			if(!taskO) return false;
			if(tTaskInfo.stype==taskO.stype&&tTaskInfo.stype==TaskConsts.TaskStypeID_Guide)
			{
				if(tTaskInfo.id==taskO.id)
				{
					return true;
				}
			}else
			{
				if((tTaskInfo.missionID==taskO.missionID)&&(tTaskInfo.type==taskO.type))
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 获取当前任务状态 
		 * @return 
		 * 
		 */
		public function getTaskState():int
		{
			if(!tTaskInfo) return TaskConsts.Task_state_Complete;
			return tTaskInfo.state;
		}
		
		/**
		 * 显示当前的引导tip 
		 * 
		 */
		public function showTip():void
		{
			if(!tAutoTipDes)
			{
				showNextTip();
				return;
			} 
			
			clearTimeout(tTime);
		    var dTime:int;
			dTime=tAutoTipDes? tAutoTipDes.showWaitTime:500;
			tTime=setTimeout(updateTip,dTime);
		}
		
		
		
		private var tTime:int;
		
		private var autoClickT:int;
		
		/**
		 * 重新显示tip 
		 * 
		 */
		public function reshowTip():void
		{
			clearTimeout(tTime);
			tTime=setTimeout(updateTip,500);
		}
		/**
		 * 更新tip状态 
		 * 
		 */
		private function updateTip():void
		{
			clearTimeout(autoClickT);
			if(!tAutoTipDes)
			{
				showNextTip();
				return;
			}
			var target:DisplayObject;
			target=tAutoTipDes.target as DisplayObject;
			
			if(!target)
			{
				tAutoTipDes.clear();
				tAutoTipDes=null;
				showNextTip();
				return;
			}
			if(!target.stage)
			{
				tAutoTipDes.clear();
				tAutoTipDes=null;
				showNextTip();
				return;
			}
			var tParent:DisplayObjectContainer;
			var targetPoint:Point;
//			helpTip.gotoAndStop(type);
			tTip=tAutoTipDes.tip;
			MCControlTools.playAllMC(tTip as DisplayObjectContainer);
			DisplayUtil.disTipTo(tTip,target,tAutoTipDes.force);
			DisplayUtil.moveToNewParent(tTip,container);
			
			if(tAutoTipDes.autoControl)
			autoClickT=setTimeout(autoClick,tAutoTipDes.waitTime*1000);
		}
		
		/**
		 * 更新tip位置 
		 * 
		 */
		public function updateTipS():void
		{
			if(!tAutoTipDes)
			{
				return;
			}
			var target:DisplayObject;
			target=tAutoTipDes.target as DisplayObject;
			tTip=tAutoTipDes.tip;
			MCControlTools.playAllMC(tTip as DisplayObjectContainer);
			DisplayUtil.disTipTo(tTip,target,tAutoTipDes.force);
			DisplayUtil.moveToNewParent(tTip,container);
		}
		
		
		public var forceRestartTaskAutoGuidFun:Function;
		
		/**
		 * 强制重启任务引导 
		 * 
		 */
		public function forceToRestartTaskAutoGuid():void
		{
			if(!isAutoHelp) return;
		    if(!CommonData.isInTown) return;
			if(UserStateSensor.me.isPlayerIdel()&&autoTaskEnable)
			{
				if(forceRestartTaskAutoGuidFun!=null)
				{
					forceRestartTaskAutoGuidFun();
				}
			}
			
		}
		/**
		 * 尝试重启任务引导 
		 * 
		 */
		public function tryStartTaskAutoGuid():void
		{
			//trace("tryStartTaskAutoGuid");
			
			clearTimeout(autoTaskTipT);
			
			if(tTaskAutoTipDes&&tTaskAutoTipDes.tip&&tTaskAutoTipDes.target)
			{
				if(!isAutoHelp) return;
				if(UserStateSensor.me.isPlayerIdel()&&autoTaskEnable)
				{
				//	trace("pushTaskAuToTipDes");
					addAutoTipDes(tTaskAutoTipDes);
					autoTaskTipT=setTimeout(showNextTip,5*1000);
				}
					
			}else
			{
				forceToRestartTaskAutoGuid();
			}
			
			
		}
		
		private var autoTaskTipT:int;
		/**
		 * 显示下一个tip 
		 * @param force 是否强制显示下一个tip
		 * 
		 */
		private function showNextTip(force:Boolean=true):void
		{
			clearTip();
			if(!force&&tAutoTipDes!=null) //非强制更新，且当前有要显示的Tip
			{
				showTip();
				return;
			};
			tAutoTipDes=null;
			if(tTipList.length>0)//面版型Tip不为空
			{
				tAutoTipDes=tTipList.shift();
			}else
			{			
				tryStartTaskAutoGuid();
				return;
				
			} 
			if(!tAutoTipDes)
			{
				return;
			}
			clearTimeout(autoTaskTipT);
			
//			if(!tAutoTipDes.tip)
//			{
//				tAutoTipDes.tip=helpTip;
//				helpTip.gotoAndStop(tAutoTipDes.tipID);
//			}
//			if(tAutoTipDes==tTaskAutoTipDes)
//			{
//				helpTip.gotoAndStop(tAutoTipDes.tipID);
//			}
			if(!tAutoTipDes) return;
			showTip();
		}
		/**
		 * 自动模拟当前显示对象点击 
		 * 
		 */
		private function autoClick():void
		{
			if(!tAutoTipDes) 
			{
				showNextTip();
				return;
			}
			tTarget=tAutoTipDes.target;
			if(!tTarget)
			{
				return;
			}

			var tTxt:TextField;
			tTxt=tTarget as TextField;
			if(tTxt)
			{
				clearTarget();
				tTxt.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				tTxt.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				TextTools.linkEvent(tTxt);
			}else
			{
				var target:DisplayObject;
				target=tTarget as DisplayObject;
				
				if(target)
				{
					switch(tAutoTipDes.eventType)
					{
						case AutoTipDes.Up:
							target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
							break;
						default:
							target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
							target.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
					
				}
			}
			

			

		}
		
		/**
		 * 清除当前引导tip 
		 * 
		 */
		public function clearTarget():void
		{
			tTarget=null;
			clearTip();
			if(tAutoTipDes)
			{
				tAutoTipDes.clear();
			}
		}
		/**
		 * 清除公用tip 
		 * 
		 */
		public function clearTip():void
		{
			DisplayUtil.selfRemove(tTip);
//			MCControlTools.playAllMC(helpTip,false);
//			ShadeTools.me().clearShade();
		}
		
		private var backFun:Function;
		private var backFunT:int;
		/**
		 * 添加自动引导函数 
		 * @param fun
		 * @param waitTime
		 * 
		 */
		public function addGuidFun(fun:Function,waitTime:int=defaultWaitTime):void
		{
			tWaitTime=waitTime;
			backFun=fun;
			if(backFun!=null)
			{
				backFunT=setTimeout(callBackFun,tWaitTime*1000);
			}
				
		}
		/**
		 * 回调自动引导函数 
		 * 
		 */
		private function callBackFun():void
		{
			if(backFun!=null)
			{
				backFun();
				backFun=null;
			}
		}
		
		/**
		 * 当前的引导对象 
		 */
		private var tAutoTipDes:AutoTipDes;
		/**
		 * 监听全局鼠标事件处理tip状态变化
		 * @param evt
		 * 
		 */
		private function click(evt:MouseEvent):void
		{
			clearTimeout(autoClickT);
			clearTimeout(backFunT);
			backFun=null;
//			if((evt.target==this.tTarget)||DisplayUtil.isSonOf(evt.target as DisplayObject,this.tTarget as DisplayObject))
//			{
//				clearTarget();
//			}
			clearTip();
			if(tAutoTipDes)
			{
				if((evt.target==tAutoTipDes.target)||DisplayUtil.isSonOf(evt.target as DisplayObject,tAutoTipDes.target))
				{
					tAutoTipDes.time--;
				}
				tAutoTipDes.clearTip();
			}
			dealTipState();
		}
		/**
		 * 更新tip状态信息 
		 * 
		 */
		private function dealTipState():void
		{
			clearTip();
			if(!tAutoTipDes)
			{
				showNextTip();
				return;
			}
			if(tAutoTipDes.time<=0)
			{
				if(tAutoTipDes!=tTaskAutoTipDes)
				{
					tAutoTipDes.callBack();
					tAutoTipDes.clear();
				}
				tAutoTipDes=null;
			}
			
			if(tAutoTipDes)
			{
				showTip();
			}else
			{
				showNextTip();
			}
			
		}
		/**
		 * 屏幕变化时更新tip显示 
		 * @param evt
		 * 
		 */
		private function resize(evt:Event):void
		{
			reshowTip();
		}
		
		private function textLink(evt:TextEvent):void
		{
			
		}
	}
}