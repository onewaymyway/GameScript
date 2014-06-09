package com.tg.Tools
{
	import com.tools.ArrayTool;
	import com.tools.ClassTools;
	import com.tools.JSONTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;

	/**
	 * 调试输出面板
	 * @author ww
	 * 
	 */
	public class DebugToolScreen
	{
		public function DebugToolScreen()
		{
			msgList=[];
		}
		/**
		 * 父容器 
		 */
		public var container:DisplayObjectContainer;
		
		private static var _instance:DebugToolScreen;
		
		public static function get me():DebugToolScreen
		{
			if(!_instance) _instance=new DebugToolScreen;
			return _instance;
		}
		
		/**
		 * 输出文本框
		 */
		private var outPutTxt:TextField;
		/**
		 * 输出选择文本框
		 */
		private var choiceTxt:TextField;
		/**
		 * 显示隐藏拖动按钮
		 */
		private var switchTxt:TextField;
		
		/**
		 * 脚步输入文本框
		 */
		private var inputTxt:TextField;
		/**
		 * 执行脚本按钮文本框
		 */
		private var executeTxt:TextField;
		/**
		 * 背景
		 */
		public var back:Sprite;
		/**
		 * 是否已经初始化
		 */
		private var isInited:Boolean=false;
		/**
		 * 初始化Ui 
		 * 
		 */
		private function initUI():void
		{
			
			if(back) return;
			back=new Sprite();

			
			//调试输出文本
			outPutTxt=new TextField;
			outPutTxt.y=0;
			outPutTxt.width=480;
			outPutTxt.height=175;
			outPutTxt.multiline=true;
			outPutTxt.wordWrap=true;
			outPutTxt.textColor=0xFFFF00;
			outPutTxt.background=true;
			outPutTxt.backgroundColor=0x000000;
			outPutTxt.selectable=true;
			back.addChild(outPutTxt);
			outPutTxt.addEventListener(TextEvent.LINK,checkDataClick);
			
			
			//脚步输入文本
			inputTxt=new TextField;
			inputTxt.type=TextFieldType.INPUT;
			inputTxt.y=0;
			inputTxt.width=480;
			inputTxt.height=175;
			inputTxt.multiline=true;
			inputTxt.wordWrap=true;
			inputTxt.textColor=0xFFFF00;
			inputTxt.background=true;
			inputTxt.backgroundColor=0x000000;
			inputTxt.selectable=true;
			inputTxt.visible=false;
			inputTxt.text="trace(\"hello script\");";
			back.addChild(inputTxt);
			
			
			//频道选择文本
			choiceTxt=new TextField;
			choiceTxt.x=outPutTxt.width+4;
			choiceTxt.y=20;
			choiceTxt.width=100;
			choiceTxt.height=175-choiceTxt.y;
			choiceTxt.multiline=true;
			choiceTxt.wordWrap=true;
			choiceTxt.textColor=0xFFFF00;
			choiceTxt.background=true;
			choiceTxt.backgroundColor=0x000000;
			choiceTxt.selectable=false;
			back.addChild(choiceTxt);
			choiceTxt.addEventListener(TextEvent.LINK,choiceClick);
			
			
			//界面控制文本
			switchTxt=new TextField;
			switchTxt.text="debug";
			switchTxt.selectable=false;
			switchTxt.width=switchTxt.textWidth+4;
			switchTxt.height=switchTxt.textHeight+4;
			switchTxt.background=true;
			switchTxt.backgroundColor=0x00FF00;
			switchTxt.x=outPutTxt.x+outPutTxt.width+2;
			back.addChild(switchTxt);
			switchTxt.addEventListener(MouseEvent.MOUSE_DOWN,backDown);
			switchTxt.addEventListener(MouseEvent.MOUSE_UP,backUp);
			
			switchTxt.addEventListener(MouseEvent.CLICK,switchClick);
			
			
			//执行脚本按钮文本
			executeTxt=new TextField;
			executeTxt.text="cmds";
			executeTxt.selectable=false;
			executeTxt.width=switchTxt.textWidth+4;
			executeTxt.height=switchTxt.textHeight+4;
			executeTxt.background=true;
			executeTxt.backgroundColor=0x00FF00;
			executeTxt.x=switchTxt.x+switchTxt.width+2;
			back.addChild(executeTxt);
			executeTxt.addEventListener(MouseEvent.CLICK,cmdsClick);
			
			disList=[outPutTxt,choiceTxt];
			isInited=true;
		}
		private function cmdsClick(evt:MouseEvent):void
		{
			if(!inputTxt) return;
			if(inputTxt.visible)
			{
				inputTxt.visible=false;
				excuteCmds();
			}else
			{
				initScript(container.root);
				inputTxt.visible=true;
			}
		}
		private var isCMDsInited:Boolean=false;
		public var tRoot:Sprite;
		
		/**
		 * 初始化脚本解析器 
		 * @param _root 脚步上下文
		 * 
		 */
		public function initScript(_root:DisplayObject):void
		{
			ClassTools.getDefines(_root);
			if(!isCMDsInited)
			{
				isCMDsInited=ScriptAdapter.initScript(_root);
				if(isCMDsInited)
				{
					debugOut("ScriptInited Success","CMDs");
				}
				
//				isCMDsInited=true;
			};
		}
		/**
		 * 执行脚本 
		 * 
		 */
		private function excuteCmds():void
		{
//			if(!tRoot) return;
			initScript(container.root);
			
			
			var str:String;
			str=inputTxt.text;
			
			if(str=="")
			{
				
				return;
			}
			try
			{
				ScriptAdapter.exeCmds(str);
			} 
			catch(error:Error) 
			{
				debugOut("excuteCmdsError:"+error.message+"\n"+error.getStackTrace(),"CMDs");
			}
			
		}
		/**
		 * 要控制的显示UI 
		 */
		private var disList:Array=[];
		/**
		 * 切换显示 
		 * @param evt
		 * 
		 */
		private function switchClick(evt:MouseEvent):void
		{
			var i:int;
			var len:int;
			len=disList.length;
			var tDis:DisplayObject;
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				if(tDis)
				{
					tDis.visible=!tDis.visible;
				}
			}
		}
		private function checkDataClick(evt:TextEvent):void
		{
			showDataBySign(evt.text);
		}
		private function backDown(evt:MouseEvent):void
		{
			back.startDrag();
		}
		private function backUp(evt:MouseEvent):void
		{
		    back.stopDrag();	
		}
		/**
		 * 控制显示 
		 * @param show
		 * 
		 */
		private function showMe(show:Boolean):void
		{
			if(show)
			{
				initUI();
				if(container)
				{
					container.addChild(back);
				}
			}
			else
			{
				DisplayUtil.selfRemove(back);
			}

		}
		/**
		 *  
		 */
		private var msgDic:Dictionary;
		
		/**
		 * 调试信息队列 
		 */
		private var msgList:Array;
		
		/**
		 * 整体渲染 
		 * 
		 */
		public function render():void
		{
			renderTxt();
			renderChoice();
		}
		
		/**
		 * 频道文字颜色
		 */
		private var colorDic:Object={};
		/**
		 * 频道颜色列表
		 */
		public const colorList:Array=[0xFF0000,0x00FF00,0xFFFF00,0x00FFFF];
		public function getSignColor(sign:String):uint
		{
			return colorDic[sign];
		}
		/**
		 * 渲染输出 
		 * 
		 */
		public function renderTxt():void
		{
			if(!outPutTxt) return;
			var i:int;
			var len:int;
			len=msgList.length;
			var tMsg:Object;
			var rst:String;
			rst="";
			for(i=0;i<len;i++)
			{
				tMsg=msgList[i];
				if(!choiceO[tMsg.type]) continue;
				if(tMsg["sign"])
				{
					rst+=TextTools.getColorText("["+tMsg.type+"]:"+tMsg.msg+" "+TextTools.linkText("data",tMsg["sign"]),getSignColor(tMsg.type))+"\n";
				}else
				{
					rst+=TextTools.getColorText("["+tMsg.type+"]:"+tMsg.msg,getSignColor(tMsg.type))+"\n";
				}
				
			}
			outPutTxt.htmlText=rst;
			outPutTxt.scrollV=outPutTxt.maxScrollV;
			
		}
		/**
		 * 保留的最大调试信息数 
		 */
		public static var maxLine:int=200;
		/**
		 * 添加一条调试信息 
		 * @param str 调试信息
		 * @param msgType 频道
		 * 
		 */
		public function addNewMsg(str:String,msgType:String="default",dataO:Object=null):void
		{
			var data:Object;
			data={"msg":str,"type":msgType,"data":dataO};
			if(dataO)
			{
				data["sign"]=addDataO(dataO);
			}
			msgList.push(data);
			if(msgList.length>maxLine)
			{
//				msgList.splice(maxLine*0.5,maxLine);
				deleteSome();
			}
			if(choiceO.hasOwnProperty(msgType))
			{
				
			}else
			{
				choiceO[msgType]=true;
				colorDic[msgType]=ArrayTool.getRandom(colorList);
				renderChoice();
			}
			
			renderTxt();
		}
		
		private function deleteSome():void
		{
			var i:int;
			var down:int;
			var tData:Object;
			down=msgList.length*0.5;
			for(i=down;i>=0;i--)
			{
				tData=msgList.shift();
//				msgList.splice(i,1);
				if(tData)
				{
					removeDataO(tData["sign"]);
				}
			}
		}
		
		/**
		 * 附加数据缓存 
		 */
		private var dataObjDic:Object={};
		
		/**
		 * 添加附加数据 
		 * @param data
		 * @return 
		 * 
		 */
		private function addDataO(data:Object):String
		{
			var tSign:String;
			tSign=String(IDManager.me.getANewID());
			dataObjDic[tSign]=data;
			return tSign;
		}
		/**
		 * 清除附加数据 
		 * @param sigh
		 * 
		 */
		private function removeDataO(sigh:String):void
		{
			delete dataObjDic[sigh];
		}
		
		/**
		 * 显示附加数据 
		 * @param sign
		 * 
		 */
		private function showDataBySign(sign:String):void
		{
			if(dataObjDic[sign])
			{
				addNewMsg("\n"+JSONTools.getJSONString(dataObjDic[sign]),"ObjectTrace");
			}
		}
		/**
		 * 清空数据 
		 * 
		 */
		private function clear():void
		{
			
			dataObjDic={};
			msgList=[];
			render();
		}
		/**
		 * 处理频道状态 
		 * @param evt
		 * 
		 */
		private function choiceClick(evt:TextEvent):void
		{
			var tType:String;
			tType=evt.text;
			if(choiceO.hasOwnProperty(tType))
			{
				choiceO[tType]=!choiceO[tType];
				render();
			}
		}
		/**
		 * 频道状态 
		 */
		private var choiceO:Object={};
		/**
		 * 显示频道选择 
		 * 
		 */
		private function renderChoice():void
		{
			if(!switchTxt) return;
			var kk:String;
			var rst:String;
			var color:uint;
			rst="";
			for(kk in choiceO)
			{
				color=choiceO[kk]? 0xFFFF00:0x00FFFF;
				rst+=TextTools.getColorText(TextTools.linkText(kk,kk),color)+" ";
			}
			choiceTxt.htmlText=rst;
		}
		/**
		 * 添加调试输出 
		 * @param str
		 * @param msgType
		 * 
		 */
		public static function debugOut(str:String,msgType:String="default",data:Object=null):void
		{
			me.addNewMsg(str,msgType,data);
		}
		/**
		 * 是否显示面板 
		 * @param show
		 * 
		 */
		public static function set isShow(show:Boolean):void
		{
			me.showMe(show);
		}

		

	}

}