package com.tg.tip
{
	import com.tg.Filter;
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

	public class CopyofTip
	{
		private static const contentOffset:Point = new Point(6, 6);
		private static const mouseOffset:Point = new Point(15, 15);
		private static var _offset:Point = new Point(0, 0);
		
		private static var layer:Sprite;
		private static var tipContainer:Sprite;
		private static var targetContainer:Sprite;
		
		public static function init(layer:Sprite):void
		{
			CopyofTip.layer = layer;
			CopyofTip.layer.stage.addEventListener(MouseEvent.CLICK, stageTargetClick);
			CopyofTip.layer.stage.addEventListener(MouseEvent.CLICK, stageCaptureClick, true);
			
			tipContainer = new Sprite();
			targetContainer = new Sprite();
			
			CopyofTip.layer.addChild(tipContainer);
			CopyofTip.layer.addChild(targetContainer);
			
			createBubbleTweenText();
		}
		
		private static function stageTargetClick(ev:MouseEvent):void
		{
			if(ev.target == ev.currentTarget)
			{stageCaptureClick(null);}
		}
		
		private static function stageCaptureClick(ev:MouseEvent):void
		{
			while(tipContainer.numChildren != 0)
			{tipContainer.removeChildAt(0);}
			tipContainer.visible = false;
		}
		
		// ---------- 功能型提示面板
		
		/**
		 * 可操作提示，用户点击舞台后消失
		 * 
		 * @param content	提示内容，可为文本或者显示对象
		 */
		public static function clickToOpen(content:*) : Sprite
		{
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
				tf.htmlText = "<font color=\"#ffffff\">" + content + "</font>";// 白色字
				
				tipContent = tf;
			}
			
			//-------------------- 绘制提示内容盛放框
			
			tipContent.x = contentOffset.x;
			tipContent.y = contentOffset.y;
			
			var right:int = tipContent.width + contentOffset.x * 2;
			var bottom:int = tipContent.height + contentOffset.y * 2;
			var ellipseWidth:int = 8;
			
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
			if (targetX + tipContainer.width > layer.stage.stageWidth - _offset.x * 2)
				targetX = mouseX - tipContainer.width - mouseOffset.x;
			
			var mouseY:int = layer.mouseY;
			var targetY:int = mouseY + mouseOffset.y;
			if (targetY + tipContainer.height > layer.stage.stageHeight - _offset.y * 2)
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
		
		private static var _targets:Dictionary;
		private static var _target:DisplayObject;
		private static var _content:DisplayObject;
		
		public static function addTarget(target:DisplayObject, content:* = null) : void
		{
			clearTarget(target);
			
			addOne(target, content);
			addEvent(target);
		}
		
		public static function addTargetMoreTips(target:DisplayObject, ...contentList) : void
		{
			clearTarget(target);
			
			for(var i:int = 0; i < contentList.length; i++)
			{addOne(target, contentList[i]);}
			addEvent(target);
		}
		
		public static function addFixedTarget(target:DisplayObject, content:*, position:Point, topBase:Boolean = true) : void
		{
			clearTarget(target);
			
			addOne(target, content, position, topBase);
			addEvent(target);
		}
		
		public static function removeTarget(target:DisplayObject) : void
		{
			if (target && _targets[target])
			{
				if (_target == target)
				{
					hide();
				}
				removeEvent(target);
				delete _targets[target];
			}
		}
		
		public static function updateTarget(target:DisplayObject = null) : void
		{
			draw();
			//updateTarget1();
		}
		
		private static function addOne(target:DisplayObject, content:*, pos:Point = null, topBase:Boolean = true) : void
		{
			// 确定提示显示对象
			var disp:DisplayObject;
			if (content is String)
			{
				var text:TextField = new TextField();
				text.selectable = false;
				text.autoSize = TextFieldAutoSize.LEFT;
				text.multiline = true;
				text.htmlText = HtmlText.white(content);
				if (text.height > 20)
				{
					var tf:TextFormat = new TextFormat();
					tf.leading = 3;
					text.setTextFormat(tf);
				}
				disp = text;
			}
			else if (content is DisplayObject) {disp = content;}
			else {return;}
			
			// 存放mouse tip对象和提示内容参数
			if (_targets[target] == null)
				_targets[target] = new MouseTip([], pos, topBase);
			else
				(_targets[target] as MouseTip).contentList.push(disp);
		}
		
		private static function addEvent(target:DisplayObject) : void
		{
			/*  */
			var mouseMove:Function = function (event:MouseEvent) : void
			{
				_target = target;
				
				// 未初始化
				if (layer == null) 
					return;
				
				// 不存在提示内容
				var task:MouseTip = _targets[target] as MouseTip;
				if ((task == null) || task.contentList == null || task.contentList.length == 0)
					return;
				
				// 
				var _loc_5:int = 0;
				var _loc_6:int = 0;
				var _loc_7:int = 0;
				
				var _loc_2:DisplayObject = _targets[target]["contents"][0];
				if (_content && _content != _loc_2)
				{
					while (targetContainer.numChildren)
						targetContainer.removeChildAt(0);
					
					_content = null;
				}
				
				if (_content != _loc_2)
				{
					_content = _loc_2;
					_loc_6 = _targets[target]["contents"].length;
					_loc_7 = 0;
					while (_loc_7 < _loc_6)
					{
						_loc_2 = _targets[target]["contents"][_loc_7];
						targetContainer.addChild(_loc_2);
						_loc_7++;
					}
					draw();
				}
				
				/*
				var _loc_3:* = layer.mouseX + mouseOffset.x;
				var _loc_4:* = layer.mouseY + mouseOffset.y;
				if (_loc_3 + width > stage.stageWidth - _offset.x * 2)
				{
					_loc_3 = _parent.mouseX - width - mouseOffset.x + 5;
					_loc_5 = CopyofTip.LEFT;
				}
				else
				{
					_loc_5 = CopyofTip.RIGHT;
				}
				
				if (_loc_4 + height > stage.stageHeight - _offset.y * 2)
					_loc_4 = _parent.mouseY - height - mouseOffset.y + 5;
				
				if (_loc_4 < mouseOffset.y)
					_loc_4 = mouseOffset.y;
				
				if (_targets[target].pos != null)
				{
					x = _targets[target].pos.x;
					y = _targets[target].pos.y - height;
				}
				else
				{
					x = Math.floor(_loc_3);
					y = Math.floor(_loc_4);
				}
				
				if (_loc_5 != _dir)
				{
					_dir = _loc_5;
					draw();
				}
				event.updateAfterEvent();
				*/
			};
			
			var mouseOver:Function = function (event:MouseEvent) : void
			{
				removeEnterFrame();
				
				show();
				target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			};
			
			var mouseOut:Function = function (event:MouseEvent) : void
			{
				hide();
				target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			};
			
			_targets[target].mouseOver = mouseOver;
			_targets[target].mouseOut = mouseOut;
			_targets[target].mouseMove = mouseMove;
			target.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
			
		}
		
		private static function removeEvent(target:DisplayObject) : void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, _targets[target].mouseOver);
			target.removeEventListener(MouseEvent.MOUSE_OUT, _targets[target].mouseOut);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, _targets[target].mouseMove);
		}
		
		private static function removeEnterFrame() : void
		{
			/*
			if (this._enterFrame is Function)
				removeEventListener(Event.ENTER_FRAME, this._enterFrame);
			*/
		}
		
		private static function clearTarget(target:DisplayObject) : void
		{
			/*
			if (target == null)
				throw new Error("target不能为null！");
			
			if (this._targets[target])
				this.removeTarget(target);
			*/
		}
		
		private static function show() : void
		{
			/*
			if (this._parent)
			{
				this._parent.addChild(this);
			}
			if (x == 0 && y == 0)
			{
				x = 10000;
				y = 10000;
			}
			*/
		}
		
		public static function hide() : void
		{
			/*
			this._target = null;
			this._content = null;
			graphics.clear();
			this.removeEnterFrame();
			if (this._parent && parent)
				parent.removeChild(this);
			
			while (numChildren)
			{
				removeChildAt(0);
			}
			*/
		}
		
		private static function draw() : void
		{
			/*
			var addonX:int;
			var addonY:int;
			var i:int;
			if (this._target == null)
				return;
			
			graphics.clear();
			addonX;
			addonY;
			var handler:* = function (param1:int) : void
			{
				var _loc_2:* = _targets[_target]["contents"][param1];
				visible = _loc_2.visible;
				var _loc_3:* = _loc_2 ? (_loc_2.width + _contentOffset.x * 2) : (100);
				var _loc_4:* = _loc_2 ? (_loc_2.height + _contentOffset.y * 2) : (50);
				var _loc_5:int = 8;
				graphics.lineStyle(1, 0, 0.3);
				graphics.beginFill(0, 0.75);
				graphics.drawRoundRect(2 + addonX, 2 + addonY, _loc_3, _loc_4, _loc_5, _loc_5);
				graphics.endFill();
				graphics.lineStyle(1, 8082482);
				graphics.beginFill(1118481);
				graphics.drawRoundRect(0 + addonX, 0 + addonY, _loc_3, _loc_4, _loc_5, _loc_5);
				graphics.endFill();
				_loc_2.x = _contentOffset.x + addonX;
				_loc_2.y = _contentOffset.y + addonY;
				addonX = addonX + (_loc_3 + 5);
				addonY = addonY + _contentSpan.y;
			};
			
			var start:int;
			var end:* = this._targets[this._target]["contents"].length;
			if (CopyofTip.LEFT == this._dir)
			{
				i = (end - 1);
				while (i >= start)
				{
					
					handler(i);
					i = (i - 1);
				}
			}
			else
			{
				i = start;
				while (i < end)
				{
					
					handler(i);
					i = (i + 1);
				}
			}
			*/
		}
	}
}