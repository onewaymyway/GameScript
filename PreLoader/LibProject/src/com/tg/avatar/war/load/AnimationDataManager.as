package com.tg.avatar.war.load
{
	
	import com.game.loader.TGLoader;
	
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	public final class AnimationDataManager
	{
		private static const basePath:String = "avatar/war/";
		
		private static var _instance:AnimationDataManager;
		
		private var animationPool:Dictionary;
		
		private var configjsonLoader:TGLoader;
		private var imageLoader:TGLoader;
		
		private var copyBitmapQueue:Vector.<QueueData> = Vector.<QueueData>([]);
		private var copyBitmapFunIsRunning:Boolean = false;
		
		private var _progressFun:Function;
		private var _completeFun:Function;
		private var _onError:Function;
		
		public function AnimationDataManager()
		{
			if (_instance)
				throw new Error("This is Singleton.");
			animationPool = new Dictionary();
		}
		
		public static function getInstance():AnimationDataManager
		{
			if (!_instance)
				_instance = new AnimationDataManager();
			return _instance;
		}
		
		
		public function load(signs:Vector.<String>,pregressFun:Function=null,completeFun:Function=null,errorFun:Function=null):void
		{
			this._progressFun=pregressFun;
			this._completeFun=completeFun;
			this._onError=errorFun;
			
			var tmpPb:PlayerAnimationData;
			for (var i:int = 0; i < signs.length; i++) 
			{
				if (!animationPool[signs[i]]) {
					tmpPb = new PlayerAnimationData();
					tmpPb.sign = signs[i];
					animationPool[signs[i]] = tmpPb;
				}
			}
			
			if (!configjsonLoader)
				configjsonLoader = new TGLoader("configJson");
			
			if (!imageLoader)
				imageLoader = new TGLoader("imageWdp");

			loadConfigJson();
		}
		
		
		public function remove(sign:String):void
		{
			var p:PlayerAnimationData = animationPool[sign];
			p.dispose();
			delete animationPool[sign];
		}
		
		public function getItem(sign:String):PlayerAnimationData
		{
			return animationPool[sign];
		}
		
		public function clear():void
		{
			for each (var p:PlayerAnimationData in animationPool) 
			{
				p.dispose();
				delete animationPool[p.sign];
			}
		}
		
		private function loadConfigJson():void
		{
			for each (var p:PlayerAnimationData in animationPool) 
			{
				configjsonLoader.add(basePath+p.sign+"/config.json",{id:p.sign}).addEventListener(BulkLoader.COMPLETE,onJsonItemLoaded);
			}
			configjsonLoader.addEventListener(BulkLoader.COMPLETE,onJsonAllLoaded);
			configjsonLoader.addEventListener(BulkLoader.ERROR,onError);
			configjsonLoader.addEventListener(BulkLoader.PROGRESS, onAllProgress);
			configjsonLoader.start();
		}
		
		private function onJsonItemLoaded(e:Event):void 
		{
			LoadingItem(e.target).removeEventListener(BulkLoader.COMPLETE,onJsonItemLoaded);
			var loaderId:String = LoadingItem(e.target).id;
			var p:PlayerAnimationData = PlayerAnimationData(animationPool[loaderId]);
			var tmpstr:String = configjsonLoader.getText(p.sign);
			var tmpObj:Object = JSON.parse(tmpstr);
			p.hasStuntState = tmpObj.hasStunt;
			p.hasWinState = tmpObj.hasWin;
			p.hasDieState = tmpObj.hasDie;
			p.shadowX = tmpObj.shadow.x;
			p.shadowY = tmpObj.shadow.y;
			p.nameX = tmpObj.name.x;
			p.nameY = tmpObj.name.y;
			p.troughX = tmpObj.trough.x;
			p.troughY = tmpObj.trough.y;
			
			p.standby = new AnimationData();
			copyPropertity(p.standby,tmpObj.animation.standby);
			
			p.attack = new AnimationData();
			copyPropertity(p.attack,tmpObj.animation.attack);
			
			p.attacked = new AnimationData();
			copyPropertity(p.attacked,tmpObj.animation.attacked);
			
			if (p.hasDieState) {
				p.die = new AnimationData();
				copyPropertity(p.die,tmpObj.animation.die)
			}
			if (p.hasStuntState) {
				p.stunt = new AnimationData();
				copyPropertity(p.stunt,tmpObj.animation.stunt)
			}
			if (p.hasWinState) {
				p.win = new AnimationData();
				copyPropertity(p.win,tmpObj.animation.win)
			}
		}
		
		private function onJsonAllLoaded(evt:BulkProgressEvent):void 
		{
			configjsonLoader.removeEventListener(BulkLoader.COMPLETE,onJsonAllLoaded);
			configjsonLoader.removeEventListener(BulkLoader.ERROR,onError);
			configjsonLoader.removeEventListener(BulkLoader.PROGRESS, onAllProgress);
			configjsonLoader.clear();
			configjsonLoader = null;
			loadImage();
		}
		
		private function copyPropertity(target:AnimationData,source:Object):void
		{
			target.direction = source.direction;
			target.frameCount = source.frameCount;
			target.offsetX = source.offsetX;
			target.offsetY = source.offsetY;
			target.targetFrame = source.targetFrame;
			target.frameRate = source.frameRate;
		}
		
		private function loadImage():void
		{
			var key:String;
			for each (var p:PlayerAnimationData in animationPool) 
			{
				key = p.sign + "@standby";
				imageLoader.add(basePath+p.sign+"/standby.png",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				
				key = p.sign + "@attack";
				imageLoader.add(basePath+p.sign+"/attack.wdp",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				
				key = p.sign + "@attacked";
				imageLoader.add(basePath+p.sign+"/attacked.png",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				
				if (p.hasDieState) {
					key = p.sign + "@die";
					imageLoader.add(basePath+p.sign+"/die.png",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				}
				
				if (p.hasStuntState) {
					key = p.sign + "@stunt";
					imageLoader.add(basePath+p.sign+"/stunt.wdp",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				}
				
				if (p.hasWinState) {
					key = p.sign + "@win";
					imageLoader.add(basePath+p.sign+"/win.png",{id:key,type:"image"}).addEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
				}
			}
			imageLoader.addEventListener(BulkLoader.COMPLETE,onImageAllLoaded);
			imageLoader.addEventListener(BulkLoader.ERROR,onError);
			imageLoader.addEventListener(BulkLoader.PROGRESS, onAllProgress);
			imageLoader.start();
		}
		
		private function onImageItemLoaded(e:Event):void
		{
			LoadingItem(e.target).removeEventListener(BulkLoader.COMPLETE,onImageItemLoaded);
			var loaderId:String = LoadingItem(e.target).id;
			var index:int = loaderId.indexOf("@");
			var sign:String = loaderId.substr(0,index);
			var state:String = loaderId.substr(index+1);
			
			var p:PlayerAnimationData = PlayerAnimationData(animationPool[sign]);
			var bmpd:BitmapData;
			switch(state)
			{
				case "standby":
					bmpd = imageLoader.getBitmapData(loaderId);
					//copyBitmapData(p.standby,bmpd);
					copyBitmapQueue.push(new QueueData(sign,"standby",bmpd));
					break;
				case "attack":
					bmpd = imageLoader.getBitmapData(loaderId);
					//copyBitmapData(p.attack,bmpd);
					copyBitmapQueue.push(new QueueData(sign,"attack",bmpd));
					break;
				case "attacked":
					bmpd = imageLoader.getBitmapData(loaderId);
					//copyBitmapData(p.attacked,bmpd);
					copyBitmapQueue.push(new QueueData(sign,"attacked",bmpd));
					break;
				case "die":
					if (p.hasDieState) {
						bmpd = imageLoader.getBitmapData(loaderId);
						//copyBitmapData(p.die,bmpd);
						copyBitmapQueue.push(new QueueData(sign,"die",bmpd));
					}
					break;
				case "stunt":
					if (p.hasStuntState) {
						bmpd = imageLoader.getBitmapData(loaderId);
						//copyBitmapData(p.stunt,bmpd);
						copyBitmapQueue.push(new QueueData(sign,"stunt",bmpd));
					}
					break;
				case "win":
					if (p.hasWinState) {
						bmpd = imageLoader.getBitmapData(loaderId);
						//copyBitmapData(p.stunt,bmpd);
						copyBitmapQueue.push(new QueueData(sign,"win",bmpd));
					}
					break;
			}
			
			executeQueue();
		}
		
		private function onImageAllLoaded(e:BulkProgressEvent):void
		{
			imageLoader.removeEventListener(BulkLoader.COMPLETE,onImageAllLoaded);
			imageLoader.removeEventListener(BulkLoader.ERROR,onError);
			imageLoader.removeEventListener(BulkLoader.PROGRESS, onAllProgress);
			imageLoader.clear();
			imageLoader = null;
			onAllWorkDown();
		}
		
		private function onAllWorkDown():void
		{
			_progressFun=null;
			if(_completeFun!=null)
			{
				_completeFun();
				_progressFun=null;
				_completeFun=null;
			}
		}
		
		private function copyBitmapData(target:AnimationData,source:BitmapData):void
		{
			copyBitmapFunIsRunning = true;
			target.frames = Vector.<BitmapData>([]);
			var bmpd:BitmapData;
			var wstep:int = source.width/target.frameCount;
			var hstep:int = source.height;
			var tmpRect:Rectangle = new Rectangle(0,0,wstep,hstep);
			var p:Point = new Point();
			for (var i:int = 0; i < target.frameCount; i++) 
			{
				bmpd = new BitmapData(wstep,hstep);
				bmpd.copyPixels(source,tmpRect,p);
				if (target.direction == "left")
					bmpd = flipHorizontal(bmpd);				
				target.frames[i] = bmpd;
				tmpRect.offset(wstep,0);
			}
			copyBitmapFunIsRunning = false;
		}
		
		private function flipHorizontal(bmpData:BitmapData, transparent:Boolean = true, fillColor:uint = 0):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.a = -1;
			matrix.tx = bmpData.width;
			var tbmpd:BitmapData = new BitmapData(bmpData.width, bmpData.height, transparent, fillColor);
			tbmpd.draw(bmpData, matrix);
			bmpData.dispose();
			return tbmpd;
		}
		
		private function executeQueue():void
		{
			while (copyBitmapQueue.length > 0)
			{
				if (!copyBitmapFunIsRunning)
				{
					var queueItem:QueueData = copyBitmapQueue.shift();
					var p:PlayerAnimationData = PlayerAnimationData(animationPool[queueItem.target]);
					switch(queueItem.state)
					{
						case "standby":
							copyBitmapData(p.standby,queueItem.source);
							break;
						case "attack":
							copyBitmapData(p.attack,queueItem.source);
							break;
						case "attacked":
							copyBitmapData(p.attacked,queueItem.source);
							break
						case "die":
							if (p.hasDieState) {
								copyBitmapData(p.die,queueItem.source);
							}
							break;
						case "stunt":
							if (p.hasStuntState) {
								copyBitmapData(p.stunt,queueItem.source);
							}
							break;
						case "win":
							if (p.hasWinState) {
								copyBitmapData(p.win,queueItem.source);
							}
							break;
					}
				}
			}
		}
		
		private function onError(e:ErrorEvent):void
		{
//			var item:LoadingItem = e.target as LoadingItem;
//			trace (item.errorEvent is SecurityErrorEvent); 
//			trace (item.errorEvent is IOError); 
//			trace (evt); // outputs more information 
			
			if(_onError != null)
			{
				_onError();
			}
			else 
				throw e;
		}
		
		private function onAllProgress(e:BulkProgressEvent):void
		{
//			trace(e);
//			trace(""+e.itemsLoaded+"/"+e.itemsTotal) ;
//			trace(e.ratioLoaded);
			if(_progressFun != null)
			{
				_progressFun(int(e.weightPercent*100),e.itemsLoaded,e.itemsTotal);
			}
		}
		
	}
}
import flash.display.BitmapData;

class QueueData
{
	public var target:String;
	public var state:String;
	public var source:BitmapData;
	
	public function QueueData(target:String,state:String,source:BitmapData)
	{
		this.target = target;
		this.state = state;
		this.source = source;
	}
}