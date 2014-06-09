package com.tg.avatar.war
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.avatar.war.consts.BattleRoleState;
	import com.tg.avatar.war.data.RoleDataFormat;
	import com.tg.avatar.war.load.AnimationData;
	import com.tg.avatar.war.load.PlayerAnimationData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Role extends Movie
	{
		/**
		 * 朝左
		 */
		public static const LEFT:String = "left";
		/**
		 * 朝右
		 */
		public static const RIGHT:String = "right";
		
		public static const STANDBY:String = "standby";
		public static const ATTACK:String = "attack";
		public static const ATTACKED:String = "attacked";
		public static const STUNT:String = "stunt";		// 绝技
		public static const DIE:String = "die";			// 死亡
		public static const WIN:String = "win";			// 胜利
		
		public static const STAND:String = "stand";		// 站立
		public static const MAGIC:String = "magic";		// 魔法
		public static const DEFENSE:String = "defense"; // 防守
		public static const SQUAT:String = "squat";		// 蹲下
		public static const EFFECT:String = "effect";	// 效果
		
		protected var _defaultFrameRate:Number = 0;
		private var _speed:int;
		
		// 资源数据
		protected var _bmd:BitmapData;
		private var _roleBmd:PlayerAnimationData;
		protected var _standbyDF:RoleDataFormat;
		protected var _attackDF:RoleDataFormat;
		protected var _attackedDF:RoleDataFormat;
		protected var _stuntDF:RoleDataFormat;
		protected var _dieDF:RoleDataFormat;
		protected var _winDF:RoleDataFormat;
		
		protected var _defenseDF:RoleDataFormat;
		
		// 动作控制
		protected var _actionType:String = "stand";
		private var _stopFrame:int = 1;
		
		//面向
		protected var _defaultFace:String = "right";
		protected var _face:String = "right";
		protected var _faceChanged:Boolean = false;
		
		public var hasJump:Boolean = false;
		public var position:String;
		
		protected var _bloodTroughPosition:Point;
		//protected var _momentumTroughPosition:Point;
		
		// 眩晕
		private var _reel:MovieClip;
		
		public var myScaleX:Number = 1;
		public var myScaleY:Number = 1;
		
		private var _stateEffectLayer:Sprite;
		private var _stateEffectLayerBack:Sprite;
		
		protected var _isPlayer:Boolean;
		public function get isPlayer():Boolean
		{return _isPlayer;}
		public function set isPlayer(value:Boolean):void
		{_isPlayer = value;}
		
		public function Role(roleBmd:PlayerAnimationData = null, frameRate:Number = 12, speed:int = 1)
		{
			super(frameRate);
			
			this._defaultFrameRate = frameRate;
			this._speed = speed;
			this._roleBmd = roleBmd;
			
//			WarResManager.me.analyseBitMapData(roleBmd);
			
			createRoleName();
			resolveAvatar();
			_stateEffectLayer=new Sprite;
			addChild(_stateEffectLayer);
			_stateEffectLayerBack=new Sprite;
			
			addChildAt(_stateEffectLayerBack,0);
		}

		public function init() : void
		//public function init(sign:String) : void
		{
			//this._sign = sign;
			//this.showShadow();
			//this.showRoleJob();
			//this.showRoleName();
			//this.showBloodTrough();
			//this.showMomentumTrough();
			this.showRoleName();
			//showRegPoint();
		}
		
		public override function clear():void
		{
//			this.clearReel();
			clearState();
			this._roleBmd = null;
			this.stopHandler = null;
			clearShadow();
			this._bmd=null;
			super.clear();
		}
		
		
		////////////////////////////////
		// ---------------- 角色数据处理
		////////////////////////////////
		
		private function resolveAvatar():void
		{
//			this._bmd 					= _roleBmd["content"];				// content is BitmapData
//			this._bmd 					= WarResManager.me.getBitMapData(_roleBmd);			
//			this._defaultFace 			= _roleBmd["defaultFace"];			// defaultFace is String
//			this._bloodTroughPosition 	= _roleBmd["bloodTroughPosition"];	// bloodTroughPosition is Point
//			this._shadowScaleX 			= _roleBmd["shadowScale"].x;		// shadowScale is Point
//			this._shadowScaleY 			= _roleBmd["shadowScale"].y;		// shadowScale is Point
			
			
//			this._bmd 					= WarResManager.me.getBitMapData(_roleBmd);			
//			this._defaultFace 			= _roleBmd.standby.direction;			// defaultFace is String
			this._defaultFace 			= Role.RIGHT;	
			this._bloodTroughPosition 	= new Point(_roleBmd.troughX,_roleBmd.troughY);	// bloodTroughPosition is Point
			this._shadowScaleX 			= _roleBmd.shadowX/100;		// shadowScale is Point
			this._shadowScaleY 			= _roleBmd.shadowY/100;		// shadowScale is Point
			
			this.changeFace(false);
		}
		
		public function changeFace(change:Boolean) : void
		{
			this._faceChanged = change;
			this._face = change ? (this._defaultFace == Role.LEFT ? (Role.RIGHT) : (Role.LEFT)) : (this._defaultFace);
			
			if (this._roleBmd != null)
			{
				this.dealChangeFace(change, Role.STANDBY, 	this._roleBmd["standby"]);
				this.dealChangeFace(change, Role.ATTACK, 	this._roleBmd["attack"]);
				this.dealChangeFace(change, Role.ATTACKED, 	this._roleBmd["attacked"]);
				
				try
				{
					this.dealChangeFace(change, Role.STUNT, this._roleBmd["stunt"]);
					this.dealChangeFace(change, Role.DIE, 	this._roleBmd["die"]);
					this.dealChangeFace(change, Role.WIN, 	this._roleBmd["win"]);
				}
				catch(err:Error)
				{
					// 早期资源无Stunt属性
					
				}
			}
		}
		
		private function dealChangeFace(towardsChanged:Boolean, actionSign:String, actionParams:AnimationData) : void
		{
			// 兼容不存在的数据
			if(actionParams == null)
				return;
//			
//			this.setDataFormat(actionSign, 
//				actionParams["minWidth"], actionParams["minHeight"], 
//				actionParams["maxWidth"], actionParams["maxHeight"], 
//				actionParams["clipOffset"], new Point(towardsChanged ? (-actionParams["regPoint"]["x"]) : (actionParams["regPoint"]["x"]), actionParams["regPoint"]["y"]), 
//				actionParams["action"], actionParams["frameRate"]);
			
			if (!this["_" + actionSign + "DF"])
			{
				this["_" + actionSign + "DF"] = new RoleDataFormat();
			}
			
			var format:RoleDataFormat = this["_" + actionSign + "DF"];
//			format.smallWidth = minWidth;
//			format.smallHeight = minHeight;
//			format.bigWidth = maxWidth;
//			format.bigHeight = maxHeight;
//			format.offset =  new Point(actionParams.offsetX, actionParams.offsetY);
			
			format.regPoint = new Point(!towardsChanged? actionParams.offsetX:-actionParams.offsetX, actionParams.offsetY);
			
//			if(_defaultFace==Role.LEFT)
//			{
//				format.regPoint = new Point(towardsChanged? actionParams.offsetX:-actionParams.offsetX, actionParams.offsetY);
//			}else
//			{
//				format.regPoint = new Point(!towardsChanged? actionParams.offsetX:-actionParams.offsetX, actionParams.offsetY);
//			}
			
			format.targetActionFrame = actionParams.targetFrame;
			format.frameRate = actionParams.frameRate * this._speed;
			if(actionSign==Role.DIE)
			{
				format.targetActionFrame=actionParams.frameCount;
			}
			if(actionSign==Role.WIN)
			{
				format.targetActionFrame=actionParams.frameCount-1;
			}
//			format.frameInterval = interval;
			format.frames = actionParams.frames;
		}
		
		protected function setDataFormat(actionSign:String, 
										 minWidth:Number, minHeight:Number, 
										 maxWidth:int, maxHeight:int, 
										 clipOffset:Point = null, regPoint:Point = null, 
										 action:int = 0, frameRate:Number = 12, 
										 interval:int = 0, frames:Array = null) : void
		{
			if (!this["_" + actionSign + "DF"])
			{
				this["_" + actionSign + "DF"] = new RoleDataFormat();
			}
			
			var format:RoleDataFormat = this["_" + actionSign + "DF"];
			format.smallWidth = minWidth;
			format.smallHeight = minHeight;
			format.bigWidth = maxWidth;
			format.bigHeight = maxHeight;
			format.offset = clipOffset || new Point(0, 0);
			format.regPoint = regPoint || new Point(0, 0);
			
			format.targetActionFrame = action;
			format.frameRate = frameRate * this._speed;
			
			format.frameInterval = interval;
//			format.frames = frames;
		}
		
		
		////////////////////////////
		// ---------------- 角色动作
		////////////////////////////
		
		/**  待机*/
		public function standby(triggerCallback:Function = null) : void
		{
			if (!this._standbyDF)
				return;
			this.motion(Role.STANDBY, this._standbyDF, triggerCallback);
		}
		/**  攻击*/
		public function attack(triggerCallback:Function) : void
		{
			if (!this._attackDF)
				return;
			this.motion(Role.ATTACK, this._attackDF, triggerCallback);
		}
		/**  被攻击*/
		public function attacked(triggerCallback:Function) : void
		{
			if (!this._attackedDF)
				return;
			this.motion(Role.ATTACKED, this._attackedDF, triggerCallback);
		}
		/**  防守*/
		public function defense(triggerCallback:Function) : void
		{
			if (!this._defenseDF)
				return;
			this.motion(Role.DEFENSE, this._defenseDF, triggerCallback);
		}
		/**  绝技*/
		public function stunt(triggerCallback:Function) : void
		{
			if (!this._stuntDF)
			{
				attack(triggerCallback);
				return;
			}
				
			this.motion(Role.STUNT, this._stuntDF, triggerCallback);
		}
		/**  死亡*/
		public function die(triggerCallback:Function):void
		{
			hideStateEffectLayer();
			if (!this._dieDF)
				return;
			this.stopFrame = this._dieDF.targetActionFrame;
			this.motion(Role.DIE, this._dieDF, triggerCallback);
		}
		/**  胜利*/
		public function win(triggerCallback:Function) : void
		{
			if (!this._winDF)
			{
				triggerCallback();
				return;
			}
			this.stopFrame = this._winDF.targetActionFrame+1;
			this.motion(Role.WIN, this._winDF, triggerCallback);
		}
		/**  播放动作*/
		protected function motion(action:String, format:RoleDataFormat, func:Function) : void
		{
			if (this._actionType == action)
			{
				play();
				return;
			}
			
			this._actionType = action;
			this.trigger(func, format.targetActionFrame);
			
			format.isFilpH = _faceChanged;
			
			_frameInterval = format.frameInterval;
			_frameRate = format.frameRate || _defaultFrameRate;

			analyze0(this._bmd, format);
			

			
			this.updateStopFrame();
			this.startPlay();
		}
		
		override protected function analyze(bmd:BitmapData, perWidth:Number, perHeight:Number, totalWidth:int, totalHeight:int, offsetX:Number=0, offsetY:Number=0):void
		{
			this._width = perWidth;
			this._height = perHeight;
			
			var column:int = Math.floor(totalWidth / perWidth);
			var row:int = Math.floor(totalHeight / perHeight);			
			
			
			var key:String = [offsetX, offsetY].join(",");

//			this._frames=WarResManager.me.getFramesByKey(_roleBmd,key);
			this._totalFrames = column * row;
			this._currentFrame = 0;
		}
		

		
		
		private var _targetActionFrame:int = 0;
		private var _currentActionFrame:int = 0;
		private function trigger(fun:Function, frame:int = 0) : void
		{
			frame = frame || this._targetActionFrame;
			removeFrameAction(this._currentActionFrame);
			
			if(fun != null && frame > 0)
			{
				addFrameAction(frame, fun);
			}
			
			this._currentActionFrame = frame;
		}
		
		private function updateStopFrame() : void
		{
			if (this._stopFrame == 0)
				return;
			
			addFrameAction(this._stopFrame, function () : void
			{
				stop();
				if(_stopHandler != null)
					_stopHandler(_actionType);
			});
		}
		public function startPlay() : void
		{
			gotoAndPlay(2);
		}
		
		////////////////////////////
		// ---------------- 名字处理
		////////////////////////////
		
		protected var _name:TextField; // 名称
		
		/** 显示名字 */
		public function showRoleName():void
		{
//			_stateEffectLayer.visible=true;
			if(_name == null)
				createRoleName();
			
			if(_name.parent == null)
			{
				var index:int = 0;
				if (this._reel && this._reel.parent)
					index = getChildIndex(this._reel) - 1;
				
				if (index > 0)
					addChildAt(this._name, index);
				else
					addChild(this._name);
				
				this._name.x = (-this._name.width) / 2;
				//this._name.y = Math.floor(this._bloodTroughPosition.y) - 20;
				this._name.y = Math.floor(this._bloodTroughPosition.y) - 20;
			}
			
			this._name.visible = true;
		}
		
		/** 隐藏名字 */
		public function hideRoleName():void
		{
//			_stateEffectLayer.visible=false;
			if (this._name && this._name.parent)
				removeChild(this._name);
			
			this._name.visible = false;
		}
		private function createRoleName():void
		{
			this._name = new TextField();
			this._name.selectable = false;
			this._name.autoSize = TextFieldAutoSize.LEFT;
			this._name.defaultTextFormat = new TextFormat(null, null, 0xFFFFFF);
			
			var dsf:DropShadowFilter = new DropShadowFilter();
			dsf.blurX = 2;
			dsf.blurY = 2;
			dsf.color = 0;
			dsf.strength = 10;
			dsf.angle = 45;
			dsf.distance = 0;
			dsf.quality = BitmapFilterQuality.LOW;
			this._name.filters = [dsf];
		}
		
		public function set roleName(param1:String) : void
		{
			this._name.htmlText = param1;
		}
		public function get roleName() : String
		{
			return this._name.text;
		}
		public function set roleNameColor(value:uint) : void
		{
			this._name.defaultTextFormat = new TextFormat(null, null, value);
		}
		
		
		
		
		
		/////////////////////////
		private var _trough:Sprite;
		
		/** 显示气槽 */
		public function showTrough(troughSprite:Sprite) : void
		{
			if(_trough == null)
				_trough = troughSprite;
			if(!contains(_trough))
				addChild(_trough);
			
			_trough.x = -Math.floor(_trough.width / 2);
			_trough.y = Math.floor(_bloodTroughPosition.y)+10;
			

		}
		
		public function hideTrough() : void
		{
			if(_trough == null)
				return;
			if(contains(_trough))
				removeChild(_trough);
		}
		
		public function get trough():Sprite
		{
			return _trough;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		////////////////////////////
		// -------------------- 血槽
		////////////////////////////
		
		private var _maxHp:int;
		private var _leftHp:int;
		
		public function set maxHp(value:int) : void
		{
			this._maxHp = value;
		}
		public function get maxHp() : int
		{
			return this._maxHp;
		}
		
		public function set leftHp(value:int) : void
		{
			this._leftHp = value;
		}
		public function get leftHp() : int
		{
			return this._leftHp;
		}
		
		
		////////////////////////////
		// -------------------- 气槽
		////////////////////////////
		
		private var _maxMp:int = 100;
		private var _leftMp:int;
		
		// properties
		
		public function set maxMp(value:int) : void
		{
			this._maxMp = value;
		}
		public function get maxMp() : int
		{
			return this._maxMp;
		}
		
		public function set leftMp(value:int) : void
		{
			this._leftMp = value;
		}
		public function get leftMp() : int
		{
			return this._leftMp;
		}
		
		
		
		////////////////////////////
		// ---------------- 人物持续状态处理
		////////////////////////////

		
		public function hideStateEffectLayer():void
		{
			_stateEffectLayerBack.visible=this._stateEffectLayer.visible=false;
		}
		public function showStateEffectLayer():void
		{
			_stateEffectLayerBack.visible=this._stateEffectLayer.visible=true;
		}
		/**
		 * 状态特效对象字典 
		 */
		private var stateO:Object={};

		
		public static const backEffectLayer:int=2;
		public static const upEffectLayer:int=1;
		/**
		 * 显示持续状态
		 * 默认将特效挂载到（0,0）位置
		 * @param stateName 状态名 BattleRoleState中枚举
		 * @param stateClass 状态特效类
		 * 
		 */
		public function showState(stateName:String,stateClass:Class=null,layer:int=1) : void
		{
			
			if(stateClass==null)
			{
				trace("showState err:no stateClass :"+stateName);
				return;
			}
			var tState:MovieClip;
			tState=stateO[stateName];
			var tScale:int;
			tScale=(this.face==RIGHT)? 1:-1;
			
			if (tState == null)
			{
				tState = new stateClass();
				

				stateO[stateName]=tState;
				switch(stateName)
				{
					case BattleRoleState.STATE_XuanYun:
					case BattleRoleState.STATE_MeiHuo:
						tState.x = this._bloodTroughPosition.x;
						tState.y = this._bloodTroughPosition.y - 15;
						break;
					case BattleRoleState.STATE_BingDong:
						tState.x = 0;
						tState.y = 0;
						tState.scaleX=1;
						break;
					default:
						tState.x = 0;
						tState.y = 0;
						tState.scaleX=tScale;
				}
			}
			
			tState.gotoAndPlay(1);
			if(layer==upEffectLayer)
			{
				_stateEffectLayer.addChild(tState);
			}else
			{
				_stateEffectLayerBack.addChild(tState);
			}
			
		}
		/** 隐藏持续状态 */
		public function hideState(stateName:String) : void
		{
			var tState:MovieClip;
			tState=stateO[stateName];
			if(tState)
			{
				tState.stop();
			}
//			if (tState && tState.parent)
//			{
//				tState.parent.removeChild(tState);
//			}	
			DisplayUtil.selfRemove(tState);
		}
		/** 清理持续状态资源 */
		public function clearState() : void
		{
			var tStateName:String;
			var tState:MovieClip;
			for(tStateName in stateO)
			{
				tState=stateO[tStateName];
				if (tState )
				{
					hideState(tStateName);
					tState.stop();
				}
			}
			stateO={};
		}
		
		/////////////
		// ----- 影子
		////////////
		
		protected var _shadow:Bitmap;
		protected var _shadowScaleX:Number = 1;
		protected var _shadowScaleY:Number = 1;
		
		public function showShadow(shadow:Bitmap = null) : void
		{
			if (!this._shadow && shadow != null)
			{
				//var clazz:Class = BattleResource.Shadow;
				//this._shadow = new Bitmap(new clazz, "auto", true);
				this._shadow = shadow;
				this._shadow.scaleX = this._shadowScaleX;
				this._shadow.scaleY = this._shadowScaleY;
				
				//if (this._shadowWidth)
				//	this._shadow.width = this._shadowWidth;
				//if (this._shadowHeight)
				//	this._shadow.height = this._shadowHeight;
				
				this._shadow.x = _regPoint.x - this._shadow.width / 2;
				this._shadow.y = _regPoint.y - this._shadow.height / 2;
				trace("_regPoint:"+_regPoint.x+" "+ _regPoint.y);
			}
			
			if(_shadow == null)
			{
				return;
			}
			
			if(!contains(_shadow))
			{
				addChildAt(this._shadow, 0);
			}
		}
		public function hideShadow() : void
		{
			if ((this._shadow != null) && (this._shadow.parent != null))
				removeChild(this._shadow);
			
		}
		public function clearShadow():void
		{
			hideShadow();
			_shadow.bitmapData.dispose();
			_shadow = null;
		}
		/////////////////////////////////////
		// ---------------- 私有方法，详细实现
		/////////////////////////////////////
		
		
		
		// the methods below are bean's properties.
		
		private var _stopHandler:Function;
		public function set stopHandler(value:Function) : void
		{
			this._stopHandler = value;
		}
		
		public function set stopFrame(value:int) : void
		{
			removeFrameAction(this._stopFrame);
			this._stopFrame = value;
			this.updateStopFrame();
		}
		
		public function set targetActionFrame(value:int) : void
		{
			this._targetActionFrame = value;
			removeFrameAction(this._targetActionFrame);
		}
		
		protected var _isAttacker:Boolean = false;
		public function set isAttacker(value:Boolean) : void
		{
			this._isAttacker = value;
			if (this.isAttacker)
			{
				this._face = Role.RIGHT;
				this.changeFace(this._defaultFace != Role.RIGHT);
			}
			else
			{
				this._face = Role.LEFT;
				this.changeFace(this._defaultFace != Role.LEFT);
			}
		}
		public function get isAttacker() : Boolean
		{
			return this._isAttacker;
		}
		
		
		
		public function get face() : String
		{
			return this._face;
		}
		public function set face(value:String) : void
		{
			this.changeFace(value != this._face);
		}
		
		public function set bloodTroughPosition(value:Point) : void
		{
			this._bloodTroughPosition = value;
		}
		
		public function get bloodTroughPosition() : Point
		{
			return this._bloodTroughPosition;
		}
	}
}