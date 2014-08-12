package com.tg.file
{
	import com.game.loader.TGLoader;
	import com.tg.Tools.MagicAlert;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class File extends Object
	{
		// ---------- static code
		/** 尝试多次加载上限 */
		public static const RELOAD_LIMIT:int = 3;
		/** 版本号生成函数 */
		public static var onVersion:Function;
		
		/** 加载任务标记 */
		private static var tokenCounter:int = 0;
		/*** 资源的版本号 */
		public static var version:Dictionary = new Dictionary();
		
		private static const errorMap:Dictionary = new Dictionary();
		
		public static  function getFileMD5(filePath:String):String
		{
			if(!version[filePath]) return "unknownFile";
			return version[filePath].md5;
		}
		
		public static function getVersionFile(filePath:String):String
		{
			return TGLoader.getUrl(filePath);
		}
		/**
		 * 
		 * @param uriList		1	 params: uriList:Array(String)
		 * @param callback		1	 params: params: contentList:Array(File)
		 * 
		 * @param progress		<br/>
		 * 	&nbsp;&nbsp;&nbsp;	4	 params: taskCount:int, taskStep:int, stepPercent:int, speedLabel:String<br/>
		 * 	&nbsp;&nbsp;&nbsp;	3	 params: taskStep:int, stepPercent:int, speedLabel:String<br/>
		 * 	&nbsp;&nbsp;&nbsp;	more params: taskStep:int, stepPercent:int<br/>
		 * 
		 * @param completed		2	 params: stepIndex:int, finished:Boolean
		 * @param error			1	 params: stepIndex:int
		 */
		public static function loadList(uriList:Array, callback:Function, 
										progress:Function = null, completed:Function = null, error:Function = null) : int
		{
			tokenCounter++;
			TaskRecord.setTaskStatus(tokenCounter, true);
			loadStep(uriList, 0, [], callback, progress, completed, error, tokenCounter);
			return tokenCounter;
		}
		
		public static function stopLoadList(token:int) : void
		{
			TaskRecord.setTaskStatus(token, false);
		}
		
		private static function loadStep(stepList:Array, stepIndex:int, contentList:Array, callback:Function, 
										 progress:Function = null, completed:Function = null, error:Function = null, 
										 id:int = 0) : void
		{
			var file:File = new File();
			contentList[stepIndex] = file;
			var len:int = stepList.length;
			
			file.onComplete = function () : void
			{
				if(!TaskRecord.taskOn(id))
					return;
				
				var finished:Boolean = stepIndex >= len - 1;
				if (completed is Function)
				{
					completed(stepIndex, finished);
				}
				
				if (finished)
				{
					TaskRecord.setTaskStatus(id, false);
					callback(contentList);
				}
				else
				{
					loadStep(stepList, (stepIndex + 1), contentList, callback, progress, completed, error, id);
				}
			};
			
			file.onProgress = function (bytesTotal:int, bytesLoaded:int, speedLabel:String) : void
			{
				if (progress is Function)
				{
					var percent:int = Math.floor(bytesLoaded / bytesTotal * 100);
					percent = Math.min(100, percent);
					if (progress.length == 4)
					{
						progress(len, stepIndex, percent, speedLabel);
					}
					else if (progress.length == 3)
					{
						progress(stepIndex, percent, speedLabel);
					}
					else
					{
						progress(stepIndex, percent);
					}
				}
			};
			
			file.onError = function () : void
			{
				if (error is Function)
				{
					error(stepIndex);
				}
			};
			
			file.load(stepList[stepIndex]); 
		}
		
		///////////////////////////////////////////
		// ---------- non-static code ---------- //
		///////////////////////////////////////////
		
		/**  2 params : totalBytes:int, loadedBytes:int;<br/>3 params : totalBytes:int, loadedBytes:int, speedLabel:String;*/
		public var onProgress:Function;
		/** none paramter */
		public var onComplete:Function;
		/** none paramter */
		public var onError:Function;
		
		private var _uri:String;
		private var _loader:Loader;
		
		private var _useNewDomain:Boolean = false;
		private var _applicationDomain:ApplicationDomain;
		
		private var _lastBytes:uint = 0;
		private var _speed:Number = 0;
		
		private var _urlRnd:int = 0;
		private var _timer:Timer;
		
		/** 尝试加载次数 */
		private var _reloadCount:int;
		
		public function File()
		{
			this._loader = new Loader();
			this._reloadCount = File.RELOAD_LIMIT;
		}
		
		/**
		 * 加载指定文件
		 * @param uri	指定文件资源标识，不携带参数
		 */
		public function load(uri:String,useCache:Boolean=true) : void
		{
			this._uri = uri;
			var request:URLRequest = new URLRequest(TGLoader.getUrl(this._uri,useCache));
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			context.applicationDomain = this._useNewDomain ? (new ApplicationDomain()) : (new ApplicationDomain(ApplicationDomain.currentDomain));
			
			this.addEvent();
			this._loader.load(request, context);
		}
		public function unLoad():void
		{
			if(loader)
			{
				loader.unload();
			}
		}
		private function complete(event:Event) : void
		{
			this._applicationDomain = this._loader.contentLoaderInfo.applicationDomain;
			this.removeEvent();
			//如果文件大小不一样，则重新下载
			if (TGLoader.version&&TGLoader.version[_uri] && _loader.contentLoaderInfo.bytesTotal != TGLoader.version[_uri].w)
			{
				if (!errorMap[_uri])
					errorMap[_uri] = 1;
				
				if (errorMap[_uri] > 5)
				{
					CONFIG::CDN {
						MagicAlert.showMagicAlertStr("从云服务器文件和缓存文件不一致,请联系客服：\n" + _uri);
						return;
					}
					this.onComplete();
				}
				else{
					load(uri,false);
				}
				
				errorMap[_uri] ++;
				return;
			}
			
			if (this.onComplete is Function)
			{
				this.onComplete();
			}
		}
		
		private function progress(ev:ProgressEvent) : void
		{
			if (this.onProgress is Function)
			{
				if (this.onProgress.length == 3)
				{
					if (ev.bytesLoaded - this._lastBytes > 0)
					{
						var bytes:int = ev.bytesLoaded - this._lastBytes;
						this._lastBytes = ev.bytesLoaded;
						
						var up:int = bytes / 1024;
						var down:int = bytes % 1024;
						this._speed = up + Math.floor(down / 1024 * 10) / 10;
					}
					this.onProgress(ev.bytesTotal, ev.bytesLoaded, this._speed + "kb/s");
				}
				else
				{
					this.onProgress(ev.bytesTotal, ev.bytesLoaded);
				}
			}
		}
		
		private function httpStatus(event:HTTPStatusEvent) : void
		{
		}
		
		private function securityErrorHandler(ev:SecurityErrorEvent) : void
		{
//			delayToLoad();
		}
		private function ioErrorHandler(ev:IOErrorEvent) : void
		{
			loadError();
		}
		private function loadError():void
		{
			//trace("File::loadError " + _uri);
//			CONFIG::debug {
//				trace("文件加载失败，重新加载尝试，" + uri);
//				MagicAlert.showMagicAlertStr("文件加载失败，重新加载尝试，" + uri);
//			}
//			MagicAlert.showMagicAlertStr("文件加载失败，重新加载尝试，" + uri);
//			delayToLoad();
		}
		
		// ----- 尝试重新加载
		
		private function delayToLoad() : void
		{
			this._loader.unloadAndStop();
			
			if (this._reloadCount <= 0)
			{
				this.stopLoad();
				this.removeEvent();
				if (this.onError is Function)
				{
					this.onError();
				}
				MagicAlert.showMagicAlertStr("文件加载失败，重新加载依然失败，" + uri);
				return;
			}
			this._reloadCount--;
			this._timer = new Timer(500, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
			this._timer.start();
		}
		
		private function startLoad(ev:TimerEvent) : void
		{
			this.stopLoad();
			
			this._urlRnd++;
			//if (this._urlRnd == 3)
			//{
			//	this._urlRnd = Math.random() * 100;
			//}
			
			this.load(this._uri);
		}
		
		private function stopLoad() : void
		{
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.startLoad);
		}
		
		// ----- 功能函数
		
		public function getClassByName(className:String) : Class
		{
			try
			{
				return this._applicationDomain.getDefinition(className) as Class;
			}
			catch (err:Error)
			{
				throw new Error(className + " not found in " + _uri + "\n" + err);
			}
			return null;
		}
		
        public function hasClass(className:String):Boolean
		{
			return this._applicationDomain.hasDefinition(className);
		}
		public function getClassObject(className:String) : Object
		{
			var clazz:Class = this.getClassByName(className) as Class;
			return new clazz();
		}
		
		// ----- event bind
		
		private function addEvent() : void
		{
			var li:LoaderInfo = this._loader.contentLoaderInfo;
			li.addEventListener(Event.COMPLETE, 					this.complete);
			li.addEventListener(ProgressEvent.PROGRESS, 			this.progress);
			li.addEventListener(HTTPStatusEvent.HTTP_STATUS, 		this.httpStatus);
			li.addEventListener(IOErrorEvent.IO_ERROR, 				this.ioErrorHandler);
			li.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	this.securityErrorHandler);
		}
		private function removeEvent() : void
		{
			var li:LoaderInfo = this._loader.contentLoaderInfo;
			li.removeEventListener(Event.COMPLETE, 						this.complete);
			li.removeEventListener(ProgressEvent.PROGRESS, 				this.progress);
			li.removeEventListener(HTTPStatusEvent.HTTP_STATUS, 		this.httpStatus);
			li.removeEventListener(IOErrorEvent.IO_ERROR, 				this.ioErrorHandler);
			li.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	this.securityErrorHandler);
		}
		
		// the methods below are bean's properties.
		
		/**
		 * 
		 */
		public function set useNewDomain(value:Boolean) : void
		{
			this._useNewDomain = value;
		}
		
		/**
		 * resource location width no paramter
		 */
		public function get uri():String
		{
			return _uri;
		}
		
		public function get loader() : Loader
		{
			return this._loader;
		}
		
		/**
		 * 获取资源所属应用于
		 */
		public function get applicationDomain() : ApplicationDomain
		{
			return this._applicationDomain;
		}
		
		/**
		 * 获取字节序列
		 */
		public function get bytes() : ByteArray
		{
			return this._loader.contentLoaderInfo.bytes;
		}

		/**
		 * 获取Sprite内容
		 */
		public function get content() : Sprite
		{
			return this._loader.content as Sprite;
		}
		
		/**
		 * 获取Bitmap内容
		 */
		public function get bitmap() : Bitmap
		{
			return this._loader.content as Bitmap;
		}
		
	}
}

/**加载任务状态记录*/
class TaskRecord
{
	private static var processes:Object = new Object();
	
	public static function taskOn(token:int):Boolean
	{
		if(processes[token] != null)
		{
			return processes[token] as Boolean;
		}
		return false;
	}
	
	public static function setTaskStatus(taskToken:int, sttaus:Boolean):void
	{
		processes[taskToken] = sttaus;
	}
}
