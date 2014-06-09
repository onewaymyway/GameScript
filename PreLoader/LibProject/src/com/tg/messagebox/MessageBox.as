package com.tg.messagebox
{
	import com.tg.StageUtil;
	import com.tg.component.CheckBox;
	import com.tg.systemMessage.MessageManager;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class MessageBox
	{
		/** 主舞台 */
		private static var stage:Stage;
		/** 弹框显示所在面板 */
		private static var layer:Sprite;
		
		/** 弹出显示面板，作为背景、按钮、文字、选框的容器 */
		private static var alertPanel:Sprite;
		/** 弹出面板模态模式下，遮盖层 */
		private static var alertBackground:Sprite;
		
		/** 选框组件 */
		private static var checkBoxComp:CheckBox;
		/** 文本组件 */
		private static var textComp:TextField;
		
		/** 面板式样 : [<br/>
		 * 	背景, 确认, 取消, 是, 否, 复选框, <br/>
		 * 	面板参数[最小宽度, 最小高度, 最大宽度, 最大高度, 顶部间距, 底部间距, 左侧间距, 右侧间距], <br/>
		 * 	按钮参数[按钮y与底部间隔, 按钮间间隔]]
		 */
		private static var currentPanelStyle:Array;
		/** 面板资源式样一 */
		public static var panelStyle1:Array;
		
		public static var sp:Sprite// = new Sprite();
		
		public static function init(stage:Stage, layer:Sprite):void
		{
			// 保存stage，用户舞台变形处理
			MessageBox.stage = stage;
			MessageBox.layer = layer;
			
			// 创建单例panel和背景
			createPanel();
			createBackground();
			createTextField();
			
			// 侦听舞台resize事件
			stage.addEventListener(Event.RESIZE, stageResized);
		}
		
		/** 有弹框正在弹出中 */
		private static var running:Boolean = false;
		/** [按钮类别, 提示内容, 回调, 复选值, 面板式样] */
		private static var currentTask:Array;
		/** [[按钮类别, 提示内容, 回调, 复选值, 面板式样]] */
		private static var allTask:Array = new Array();
		
		/**
		 * 提示框
		 * @param buttonType	按钮类别，参照com.tg.st.util.ButtonType
		 * @param content		显示内容，可为"文本"或者"DisplayObject子类"
		 * @param callback		根据widthCheckBox不同而有区别<br/>
		 * 						如果不需要显示选框，回调参数为 : int(com.tg.st.util.ResultType)<br/>
		 * 						如果需要显示选框，回调参数为 : int(com.tg.st.util.ResultType), Boolean(checked)
		 * @param widthCheckBox	是否需要显示选框
		 * @param styleType		弹框式样，目前暂时无效
		 */
		public static function show(buttonType:int, content:*, callback:Function = null, widthCheckBox:Boolean = false, styleType:int = 0):void
		{
//			if((content is String)&&(callback==null)&&(buttonType==ButtonType.OK))
//			{
//				MessageManager.systemMessage(content as String);
//				return;
//			}
			if(MessageBox.sp)
			{
				while(MessageBox.sp.numChildren)
					MessageBox.sp.removeChildAt(0);
			}
			
			allTask.push([buttonType, content, callback, widthCheckBox, styleType]);
			process();
		}
		public static function  showAlert(content:*):void
		{
			show(ButtonType.OK,content);
		}
		public static function showOKCancel(content:*,yescallBack:Function,yesParam:Array=null,noCallBack:Function=null,noParam:Array=null):void
		{
			
			show(ButtonType.OK_CANCEL,content,result);
			function result(type:int):void
			{
				if(type==ResultType.OK)
				{
					if(yesParam)
					{
						yescallBack.apply(result,yesParam);
					}else
					{
						yescallBack();
					}
				}
				else
				{
					if(noCallBack!=null)
					{
						if(noParam)
						{
							noCallBack.apply(result,noParam);
						}else
						{
							noCallBack();
						}
					}
				}
			}
			
		}
		/**
		 * 获取弹框面板 
		 * @return 
		 * 
		 */		
		public static function getPanel():Sprite
		{
			return alertPanel;
		}
		private static function process():void
		{
			// 判断任务处理情况
			if(running == true)
				return;
			
			if(allTask == null || allTask.length == 0)
				return;
			
			running = true;
			
			// ----- 取出弹框任务和指定资源
			
			// 弹框当前任务
			currentTask = allTask.shift();
			var buttonType:int 			= currentTask[0];
			var content:* 				= currentTask[1];
			var callback:Function 		= currentTask[2];
			var widthCheckBox:Boolean 	= currentTask[3];
			var styleType:int 			= currentTask[4];
			
			// 面板式样参数
			currentPanelStyle = panelStyle1;// 参数值 : currentTask[4]
			var panelBackground:Sprite 		= currentPanelStyle[0];
			var okButton:SimpleButton 		= currentPanelStyle[1];
			okButton.name = "确定";
			var cancelButton:SimpleButton 	= currentPanelStyle[2];
			cancelButton.name = "取消";
			var yesButton:SimpleButton 		= currentPanelStyle[3];
			yesButton.name = "是";
			var noButton:SimpleButton 		= currentPanelStyle[4];
			noButton.name = "否";
			var checkBox:CheckBox 			= currentPanelStyle[5];
			var panelParams:Array 			= currentPanelStyle[6];
			var buttonParams:Array 			= currentPanelStyle[7];
			
			alertPanel.addChild(panelBackground);
			
			// ----- 创建面板显示内容
			
			// 面板参数[最小宽度, 最小高度, 最大宽度, 最大高度, 顶部间距, 底部间距, 左侧间距, 右侧间距]
			var minWidth:int 	= panelParams[0];
			var minHeight:int 	= panelParams[1];
			var maxWidth:int 	= panelParams[2];
			var maxHeight:int 	= panelParams[3];
			var toTop:int 		= panelParams[4];
			var toBottom:int 	= panelParams[5];
			var toLeft:int 		= panelParams[6];
			var toRight:int 	= panelParams[7];
			
			// 
			var dispWidth:int;
			var dispHeight:int;
			var disp:DisplayObject = content as DisplayObject;
			var isText:Boolean = disp == null;
			if(isText)
			{
				var str:String = content as String;
				textComp.htmlText = (str == null) ? "" : str;
				//textComp.htmlText = (str == null) ? "" : str;
				disp = textComp;
			}
			
			// 处理宽度
			if(isText)
				dispWidth = textComp.textWidth;
			else
				dispWidth = disp.width;
			if(dispWidth > maxWidth) dispWidth = maxWidth;
			if(dispWidth < minWidth) dispWidth = minWidth;
			disp.width = dispWidth;
			
			// 处理高度
			if(isText)
				dispHeight = textComp.textHeight;
			else
				dispHeight = disp.height;
			if(dispHeight > maxHeight) dispHeight = maxHeight;
			if(dispHeight < minHeight) dispHeight = minHeight;
			disp.height = dispHeight;
			
			disp.x = toLeft;
			disp.y = toTop;
			
			// 处理背景
			panelBackground.width = dispWidth + toLeft + toRight;
			panelBackground.height = dispHeight + toTop + toBottom;
			
			alertPanel.addChild(disp);
			
			// ----- 处理选择框
			if(widthCheckBox)
			{
				
			}
			
			// ----- 处理按钮
			var yToBottom:int = buttonParams[0];//按钮y与底部间隔, 按钮间间隔
			var buttonMargin:int = buttonParams[0];
			
			if(ButtonType.OK == buttonType)
			{
				okButton.x = (dispWidth - okButton.width) / 2 + toLeft;
				okButton.y = dispHeight - yToBottom + toTop + toBottom; 
				okButton.addEventListener(MouseEvent.CLICK, okClick);
				
				alertPanel.addChild(okButton);
			}
			else if(ButtonType.OK_CANCEL == buttonType)
			{
				okButton.x = (dispWidth - okButton.width - buttonMargin - cancelButton.width) / 2 + toLeft;
				okButton.y = dispHeight - yToBottom + toTop + toBottom;
				okButton.addEventListener(MouseEvent.CLICK, okClick);
				
				cancelButton.x = okButton.x + okButton.width + buttonMargin;
				cancelButton.y = dispHeight - yToBottom + toTop + toBottom;
				cancelButton.addEventListener(MouseEvent.CLICK, cancelClick);
				
				alertPanel.addChild(okButton);
				alertPanel.addChild(cancelButton);
			}
			else if(ButtonType.YES_NO == buttonType)
			{
				yesButton.x = (dispWidth - yesButton.width - buttonMargin - noButton.width) / 2 + toLeft;
				yesButton.y = dispHeight - yToBottom + toTop + toBottom;
				yesButton.addEventListener(MouseEvent.CLICK, yesClick);
				
				noButton.x = yesButton.x + yesButton.width + buttonMargin;
				noButton.y = dispHeight - yToBottom + toTop + toBottom;
				noButton.addEventListener(MouseEvent.CLICK, noClick);
				
				alertPanel.addChild(yesButton);
				alertPanel.addChild(noButton);
			}
			
			sp = new Sprite();
			sp.x = 32;
			sp.y = 22;
			alertPanel.addChild(sp);
				
			layer.addChild(alertBackground);
			layer.addChild(alertPanel);
			
			stageResized(null);
		}
		
		// -------------------- event listeners
		
		private static function okClick(ev:MouseEvent):void
		{
			dealWidthCallback(ResultType.OK);
			running = false;
			process();
		}
		private static function cancelClick(ev:MouseEvent):void
		{
			dealWidthCallback(ResultType.CANCEL);
			running = false;
			process();
		}
		private static function yesClick(ev:MouseEvent):void
		{
			dealWidthCallback(ResultType.YES);
			running = false;
			process();
		}
		private static function noClick(ev:MouseEvent):void
		{
			dealWidthCallback(ResultType.NO);
			running = false;
			process();
		}
		
		/**
		 * 回调处理
		 * @param resultType	用户点击按钮类别
		 */
		private static function dealWidthCallback(resultType:int):void
		{
			// 弹框当前任务
			var callback:Function 		= currentTask[2];
			var widthCheckBox:Boolean 	= currentTask[3];
			var checked:Boolean = clearAlertContainer();
			
			currentTask = null;
			currentPanelStyle = null;
			
			if(callback != null)
			{
				if(widthCheckBox)
					callback(resultType, checked);
				else
					callback(resultType);
			}
		}
		
		/**
		 * 回收资源组件，并返回选框是否选中
		 * @return 	面板选框是否选中状态
		 */
		private static function clearAlertContainer():Boolean
		{
			var checked:Boolean = false;
			
			// 清理掉层中资源
			if(layer.contains(alertPanel))
				layer.removeChild(alertPanel);
			
			if(layer.contains(alertBackground))
				layer.removeChild(alertBackground);
			
			// 释放面板容器
			while(alertPanel.numChildren > 0)
			{
				alertPanel.removeChildAt(0);
			}
			
			// 释放清理资源
			if(currentPanelStyle != null)
			{
				var okButton:SimpleButton 		= currentPanelStyle[1];
				var cancelButton:SimpleButton 	= currentPanelStyle[2];
				var yesButton:SimpleButton 		= currentPanelStyle[3];
				var noButton:SimpleButton 		= currentPanelStyle[4];
				var checkBox:CheckBox 			= currentPanelStyle[5];
				
				okButton.removeEventListener(MouseEvent.CLICK, okClick);
				cancelButton.removeEventListener(MouseEvent.CLICK, cancelClick);
				yesButton.removeEventListener(MouseEvent.CLICK, yesClick);
				noButton.removeEventListener(MouseEvent.CLICK, noClick);
				
				if(checkBox != null)
				{
					checked = checkBox.checked;
					checkBox.reset();
				}
				
				textComp.text = "";
				textComp.htmlText = "";
			}
			
			return checked;
		}
		
		// -------------------- 创建资源
		
		private static function createTextField():void
		{
			var formatter:TextFormat = new TextFormat();
			formatter.font = "宋体";
			formatter.bold = false;
			formatter.size = 14;
			formatter.color = 0xFFFFFF;
			formatter.align = TextFormatAlign.CENTER;
			formatter.leading = 5;
			textComp = new TextField();
			textComp.autoSize = TextFieldAutoSize.NONE; 
			textComp.type = TextFieldType.DYNAMIC;
			textComp.wordWrap = true;
			textComp.selectable = false;
			textComp.antiAliasType = AntiAliasType.ADVANCED;
			textComp.multiline = true;
			
			
			//textField.embedFonts = true;
			textComp.defaultTextFormat = formatter;
		}
		
		/**
		 * 创建弹出提示框
		 */
		private static function createPanel():void
		{
			if(alertPanel == null)
			{
				alertPanel = new Sprite();
			}
		}
		/**
		 * 创建模态背景
		 */
		private static function createBackground():void
		{
			if(alertBackground == null)
			{
				alertBackground = new Sprite();
				alertBackground.graphics.beginFill(0x000000, 0.3);
				alertBackground.graphics.drawRect(0, 0, 1, 1);
				alertBackground.graphics.endFill();
				alertBackground.width = stage.stageWidth;
				alertBackground.height = stage.stageHeight;
				alertBackground.mouseEnabled = true;
			}
		}
		private static function stageResized(ev:Event):void
		{
			// 模态背景
			if(alertBackground != null && layer.contains(alertBackground) && alertBackground.visible == true)
			{
				alertBackground.width = stage.stageWidth;
				alertBackground.height = stage.stageHeight;
			}
			
			// 弹出提示框
			if(alertPanel != null && layer.contains(alertPanel) && alertBackground.visible == true)
			{
				alertPanel.x = (StageUtil.adjustedStageWidth - alertPanel.width) / 2;
				alertPanel.y = (StageUtil.adjustedStageHeight - alertPanel.height) / 2;
				
			}
		}
		
	}
}