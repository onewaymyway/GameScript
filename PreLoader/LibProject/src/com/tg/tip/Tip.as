package com.tg.tip
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.tg.Filter;
	import com.tg.StageUtil;
	import com.tg.Tools.DisplayUtil;
	import com.tg.Tools.TextTools;
	import com.tg.Tools.TimeTools;
	import com.tg.html.HtmlText;
	import com.tg.html.htmlFormat;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class Tip
	{
		/** 显示内容边框预留距离 */
		private static const contentOffset:Point = new Point(6, 6);
		/** 多提示面板，面板间距纵向 */
		private static var contentSpan:Point = new Point(10, 0);
		/** 与鼠标间隔距离 */
		private static const mouseOffset:Point = new Point(15, 15);
		private static var _offset:Point = new Point(0, 0);
		
		private static var layer:Sprite;
		private static var tipContainer:Sprite;
		private static var targetContainer:Sprite;
		
		public static function init(layer:Sprite):void
		{
			Tip.layer = layer;
			//Tip.layer.stage.addEventListener(MouseEvent.CLICK, stageTargetClick);
			Tip.layer.stage.addEventListener(MouseEvent.CLICK, stageCaptureClick, true);
//			this.loaderInfo.uncaughtErrorEvents.
			Tip.layer.addEventListener(MouseEvent.CLICK,stageCaptureClick);
			tipContainer = new Sprite();
			targetContainer = new Sprite();
			targetContainer.mouseEnabled = false;
			
			Tip.layer.addChild(tipContainer);
			Tip.layer.addChild(targetContainer);
			
			targetRepos = new Dictionary(true);
			createBubbleTweenText();
		}
		
		private static function stageTargetClick(ev:MouseEvent):void
		{
			if(ev.target is TextField &&(!isSelfTxt(ev.target as DisplayObject))) return;
			if(ev.target == ev.currentTarget)
			{stageCaptureClick(null);}
		}
		
		private static function isSelfTxt(dis:DisplayObject):Boolean
		{
			if(dis is TextField)
			{
				if(DisplayUtil.isSonOf(dis,tipContainer))
				{
					return true;
				}
			}
			return false;
		}
		private static function stageCaptureClick(ev:MouseEvent):void
		{
			//if(ev&&(ev.target is TextField)&&(!isSelfTxt(ev.target as DisplayObject))) return;
			if(TimeTools.getTimeNow()-500<preTime) return;
			while(tipContainer.numChildren != 0)
			{tipContainer.removeChildAt(0);}
			tipContainer.visible = false;
		}
		
		// ---------- 功能型提示面板
		
		private static var preTime:Number=0;
		/**
		 * 可操作提示，用户点击舞台后消失
		 * 
		 * @param content	提示内容，可为文本或者显示对象
		 */
		public static function clickToOpen(content:*) : Sprite
		{
			preTime=TimeTools.getTimeNow();
			var tipContent:DisplayObject;
			if (content is DisplayObject)
			{
				tipContent = content;
			}
			else
			{
				var tf:TextField = new TextField();
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.multiline = true;
				tf.htmlText = "<font color=\"#F9DC8E\">" + content + "</font>";// 白色字
				
				tipContent = tf;
			}
			
			//-------------------- 绘制提示内容盛放框
			
			tipContent.x = contentOffset.x;
			tipContent.y = contentOffset.y;
			
			var right:int = tipContent.width + contentOffset.x * 2;
			var bottom:int = tipContent.height + contentOffset.y * 2;
			var ellipseWidth:int = 8;
			
			DisplayUtil.clean(tipContainer);
			tipContainer.graphics.clear();
			tipContainer.graphics.lineStyle(1, 0, 0.3);
			tipContainer.graphics.beginFill(0, 0.75);
			tipContainer.graphics.drawRoundRect(2, 2, right, bottom, ellipseWidth, ellipseWidth);
			tipContainer.graphics.endFill();
			tipContainer.graphics.lineStyle(1, 8082482);
			tipContainer.graphics.beginFill(1118481);
			tipContainer.graphics.drawRoundRect(0, 0, right, bottom, ellipseWidth, ellipseWidth);
			tipContainer.graphics.endFill();
			
			//-------------------- 调整提示内容容器位置
			var mouseX:int = layer.mouseX;
			var targetX:int = mouseX + mouseOffset.x; 
			if (targetX + tipContainer.width > StageUtil.adjustedStageWidth - _offset.x * 2)
				targetX = mouseX - tipContainer.width - mouseOffset.x;
			
			var mouseY:int = layer.mouseY;
			var targetY:int = mouseY + mouseOffset.y;
			if (targetY + tipContainer.height > StageUtil.adjustedStageHeight - _offset.y * 2)
				targetY = mouseY - tipContainer.height - mouseOffset.y;
			if (targetY < mouseOffset.y)
				targetY = mouseOffset.y;
			
			tipContainer.x = Math.floor(targetX);
			tipContainer.y = Math.floor(targetY);
			
			tipContainer.addChild(tipContent);
			tipContainer.visible = true;
			
			return tipContainer;
		}
		
		public static function set offset(value:Point) : void
		{
			_offset = value;
			//_instance.hideOpened();
		}
		
		// ---------- 文本浮动提示
		
		private static var angle:Number = 0;
		private static var speed:Number = 0.15;
		private static var txtTween:TextField;
		
		/**
		 * 文本浮动提示
		 * 
		 * @param target	提示文本的目标对象
		 * @param text		提示文本内容
		 * @param color		提示文本颜色
		 * @param fontSize	提示文本字体
		 */
		public static function textBubble(target:DisplayObject, text:String, color:uint = 0xFFFF00, fontSize:int = 18) : void
		{
			angle = 0;
			
			var htmlText:String = htmlFormat(text, fontSize, color, true);
			
			txtTween.filters = [Filter.filter2];
			txtTween.htmlText = htmlText;
			txtTween.alpha = angle;
			txtTween.x = target.x + (target.width - txtTween.width) / 2;
			txtTween.y = target.y - 27;
			target.parent.addChild(txtTween);
			layer.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private static function enterFrame(event:Event) : void
		{
			var txtAlpha:Number = Math.sin(angle);
			txtTween.alpha = txtAlpha;
			angle = angle + speed;
			if (angle >= 1.5)
				txtTween.y = txtTween.y - 0.5;
			
			if (angle >= 3.2)
			{
				angle = 0;
				layer.removeEventListener(Event.ENTER_FRAME, enterFrame);
				txtTween.parent.removeChild(txtTween);
			}
		}
		
		private static function createBubbleTweenText():void
		{
			angle = 0;
			
			txtTween = new TextField();
			txtTween.mouseEnabled = false;
			txtTween.autoSize = TextFieldAutoSize.LEFT;
		}
		
		
		// ---------- 鼠标滑过提示显示
		
		private static var targetRepos:Dictionary;
		private static var curTarget:DisplayObject;
		private static var tipContent:DisplayObject;
		private static var extendDir:int = MouseTip.EXTEND_RIGHT;
		
		/**
		 * 给目标对象添加提示性信息
		 * 
		 * @param target		要添加提示信息的目标对象
		 * @param content		提示信息内容
		 */
		public static function addTargetTip(target:DisplayObject, content:* = null) : void
		{
			clearTarget(target);
			
			addOneTargetTip(target, content);
			addTargetTipEvent(target);
		}
		
		/**
		 * 给目标对象添加多个提示性信息
		 * @param target		要添加提示信息的目标对象
		 * @param contentList	提示信息内容
		 */
		public static function addTargetMutipleTips(target:DisplayObject, ...contentList) : void
		{
			clearTarget(target);
			
			for(var i:int = 0; i < contentList.length; i++)
			{addOneTargetTip(target, contentList[i]);}
			
			addTargetTipEvent(target);
		}
		
		/**
		 * 给目标对象添加固定位置的提示性信息
		 * @param target		要添加提示信息的目标对象
		 * @param content		提示信息内容
		 * @param position		提示信息坐标
		 * @param topBase		提示信息是否基于顶部计算距离
		 */
		public static function addTargetFixedTip(target:DisplayObject, content:*, position:Point, topBase:Boolean = true) : void
		{
			clearTarget(target);
			
			addOneTargetTip(target, content, position, topBase);
			addTargetTipEvent(target);
		}
		
		private static function clearTarget(target:DisplayObject) : void
		{
			if (target == null) {trace("清理提示绑定，目标为空。");return;}
			
			if (targetRepos[target]) {removeTarget(target)};
		}
		
		
		/**
		 * 移除目标对象的提示性信息
		 * @param target		要添加提示信息的目标对象
		 */
		public static function removeTarget(target:DisplayObject) : void
		{
			if (target && targetRepos[target])
			{
				if (curTarget == target)
					hideTargetTip();
				
				removeTargetTipEvent(target);
				delete targetRepos[target];
			}
		}
		
		/**
		 * 更新目标对象的提示性信息显示
		 * @param target	
		 */
		public static function updateTarget(target:DisplayObject = null) : void
		{
			drawTargetTipBackground();
		}
		
		private static function addOneTargetTip(target:DisplayObject, content:*, pos:Point = null, topBase:Boolean = true) : void
		{
			// 确定提示显示对象
			var disp:DisplayObject;
			if (content is String)
			{
				var text:TextField = new TextField();
				text.selectable = false;
				text.autoSize = TextFieldAutoSize.LEFT;
				text.multiline = true;
//				text.htmlText = HtmlText.white(content);
				TextTools.setTextColor(text,HtmlText.White);
				text.htmlText = content;
				if (text.height > 20)
				{
					var tf:TextFormat = text.defaultTextFormat;
					tf.leading = 3;
					text.setTextFormat(tf);
					text.defaultTextFormat=tf;
					text.htmlText = content;
				}
				disp = text;
			}
			else if (content is DisplayObject) {disp = content;}
			else {return;}
			
			DisplayUtil.setMouseEnableK(disp,false);
			// 存放mouse tip对象和提示内容参数
			if (targetRepos[target] == null)
				targetRepos[target] = new MouseTip([disp], pos, topBase);
			else
				(targetRepos[target] as MouseTip).contentList.push(disp);
		}
		
		private static function addTargetTipEvent(target:DisplayObject) : void
		{
			var mouseMove:Function = function (event:MouseEvent) : void
			{
				
				curTarget = target;
				
				if (layer == null) 
					return;
				
				// 不存在提示内容
				var task:MouseTip = targetRepos[target] as MouseTip;
				if ((task == null) || task.contentList == null || task.contentList.length == 0)
					return;
				
				// 是否需要重新填充提示内容
				var tmpContent:DisplayObject = task.contentList[0];
				if (tipContent && tipContent != tmpContent)
				{
					while (targetContainer.numChildren)
						targetContainer.removeChildAt(0);
					
					tipContent = null;
				}
				
				if (tipContent != tmpContent)
				{
					tipContent = tmpContent;
					
					for(var i:int = 0; i < task.contentList.length; i++)
					{
						tmpContent = task.contentList[i];
						targetContainer.addChild(tmpContent);
					}
					
					drawTargetTipBackground();
				}
				
				// 调整Tip面板坐标
				
				var mouseX:int = layer.mouseX;
				var targetX:int = mouseX + mouseOffset.x;
				if (targetX + targetContainer.width > StageUtil.adjustedStageWidth - _offset.x * 2)
				{
					targetX = mouseX - targetContainer.width - mouseOffset.x + 5;
					task.toward = MouseTip.EXTEND_LEFT;
				}
				else
				{
					task.toward = MouseTip.EXTEND_RIGHT;
				}
				
				var mouseY:int = layer.mouseY;
				var targetY:int = mouseY + mouseOffset.y;
				if (targetY + targetContainer.height > StageUtil.adjustedStageHeight - _offset.y * 2)
					targetY = mouseY - targetContainer.height - mouseOffset.y + 5;
				if (targetY < mouseOffset.y)
					targetY = mouseOffset.y;
				
				if (task.position != null)
				{
					if(Math.abs(targetContainer.x - task.position.x) > 50 || Math.abs(targetContainer.y -task.position.y - targetContainer.height) > 50)
					{
						targetContainer.x = task.position.x;
						targetContainer.y = task.position.y - targetContainer.height;
					}
					else
					{
//						TweenLite.to(targetContainer,.2,{x:task.position.x,y:task.position.y - targetContainer.height,ease:Linear.easeNone});
//					}
					
					
						targetContainer.x = task.position.x;
						targetContainer.y = task.position.y - targetContainer.height;
					}
				}
				else
				{
					if(Math.abs(targetContainer.x - Math.floor(targetX)) > 50 || Math.abs(targetContainer.y - Math.floor(targetY)) > 50)
					{
						targetContainer.x = Math.floor(targetX);
						targetContainer.y = Math.floor(targetY);
					}
					else
					{
//						TweenLite.to(targetContainer,.2,{x:Math.floor(targetX),y:Math.floor(targetY),ease:Linear.easeNone});
//					}
						targetContainer.x = Math.floor(targetX);
						targetContainer.y = Math.floor(targetY);
					}
				}
				
				if (task.toward != extendDir)
				{
					extendDir = task.toward;
					drawTargetTipBackground();
				}
				
				event.updateAfterEvent();
			};
			
			var mouseOver:Function = function (event:MouseEvent) : void
			{
				showTargetTip();
				target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			};
			
			var mouseOut:Function = function (event:MouseEvent) : void
			{
				hideTargetTip();
				target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			};
			
			
			(targetRepos[target] as MouseTip).mouseOver = mouseOver;
			(targetRepos[target] as MouseTip).mouseOut = mouseOut;
			(targetRepos[target] as MouseTip).mouseMove = mouseMove;
			target.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
		}
		private static function removeTargetTipEvent(target:DisplayObject) : void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, (targetRepos[target] as MouseTip).mouseOver);
			target.removeEventListener(MouseEvent.MOUSE_OUT, (targetRepos[target] as MouseTip).mouseOut);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, (targetRepos[target] as MouseTip).mouseMove);
		}
		
		/**
		 * 开启目标对象提示信息
		 */		
		private static function showTargetTip() : void
		{
			if(targetContainer)
			{
				TweenLite.killTweensOf(targetContainer);
				targetContainer.alpha = 1;
			}
			if (layer && targetContainer && !layer.contains(targetContainer))
			{
				layer.addChild(targetContainer);
			}
		}
		/**
		 * 关闭目标对象提示信息
		 */
		public static function hideTargetTip() : void
		{
//			TweenLite.to(targetContainer,.2,{alpha:0,ease:Linear.easeNone, onComplete:comFun});
			comFun();
			
		}
		private static function comFun():void
		{
			curTarget = null;
			tipContent = null;
			
			targetContainer.graphics.clear();
			
			if (layer && targetContainer && layer.contains(targetContainer))
			{layer.removeChild(targetContainer);}
			
			while (targetContainer.numChildren)
			{targetContainer.removeChildAt(0);}
			targetContainer.alpha = 1;
		}
		
		private static function drawTargetTipBackground() : void
		{
			if (curTarget == null)
				return;
			
			var task:MouseTip = (targetRepos[curTarget] as MouseTip);
			
			var addonX:int;
			var addonY:int;
			var handler:Function = function (index:int) : void
			{
				var subContent:DisplayObject = task.contentList[index];
				//visible = subContent.visible;
				var subWidth:int = subContent ? (subContent.width + contentOffset.x * 2) : (100);
				var subHeight:int = subContent ? (subContent.height + contentOffset.y * 2) : (50);
				
				var ellipse:int = 8;
				targetContainer.graphics.lineStyle(1, 0, 0.3);
				targetContainer.graphics.beginFill(0, 0.75);
				targetContainer.graphics.drawRoundRect(2 + addonX, 2 + addonY, subWidth, subHeight, ellipse, ellipse);
				targetContainer.graphics.endFill();
				targetContainer.graphics.lineStyle(1, 8082482);
				targetContainer.graphics.beginFill(1118481);
				targetContainer.graphics.drawRoundRect(0 + addonX, 0 + addonY, subWidth, subHeight, ellipse, ellipse);
				targetContainer.graphics.endFill();
				
				subContent.x = contentOffset.x + addonX;
				subContent.y = contentOffset.y + addonY;
				addonX = addonX + (subWidth + 5);
				addonY = addonY + contentSpan.y;
			};
			
			targetContainer.graphics.clear();
			
			var i:int;
			if(MouseTip.EXTEND_LEFT == task.toward)
			{
				for(i = task.contentList.length - 1; i >= 0; i--)
				{handler(i);}
			}
			else
			{
				for(i = 0; i < task.contentList.length; i++)
				{handler(i);}
			}
		}
		
		
		// ---------- 
		
		
	}
}