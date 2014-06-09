package com.tg.display
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.file.File;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

    public class Image extends Sprite
    {
		public static var errorImage:BitmapData = new BitmapData(1, 1, true, 0);
		private static var enterFrameSprite:Sprite = new Sprite();
		
		public static var loadClass:Class = Sprite;
		
		private static var _cacheList:Object = {};
		private static var listFadeIn:Array = [];
		private static var listCall:Array = [];
		
        private var _file:File;
        private var _time:int = 0;
        private var _startTime:int = 0;
        public var url:String;
        public var bShowErr:Boolean = true;
        public var onComplete:Function;
        
		
		/**
		 * 向容器中加图片，加图片前将自动清空容器子元素 
		 * @param parent
		 * @param url
		 * @param showLoading
		 * @param fadeTime
		 * @return 加上的图片
		 * 
		 */
		public static function addPic(parent:DisplayObjectContainer,url:String, showLoading:Boolean = false, fadeTime:int = 100):Image
		{
			DisplayUtil.clean(parent);
			var pic:Image;
			pic=new Image(url,showLoading,0);
			pic.mouseChildren=false;
			pic.mouseEnabled=false;
			parent.addChild(pic);
			return pic;
		}
		/**
		 * 添加水平翻转的图片 
		 * @param parent
		 * @param url
		 * @param showLoading
		 * @param fadeTime
		 * @return 
		 * 
		 */
		public static function addPicR(parent:DisplayObjectContainer,url:String, showLoading:Boolean = false, fadeTime:int = 100,callBack:Function=null):Image
		{
			DisplayUtil.clean(parent);
			var pic:Image;
			pic=new Image(url,showLoading,0);
			pic.onComplete=reverse;
			pic.mouseChildren=false;
			pic.mouseEnabled=false;
			parent.addChild(pic);
			pic.visible=false;
			return pic;
			
			function reverse(pic:Image):void
			{
				pic.scaleX=-1;
				pic.x=pic.width;
				pic.visible=true;
				trace("turn pic");
				if(callBack!=null)
				{
					callBack();
					callBack=null;
				}
			}
		}
		
		/**
		 * 添加按比例缩放的图片 
		 * @param parent
		 * @param url
		 * @param showLoading
		 * @param fadeTime
		 * @return 
		 * 
		 */
		public static function addPicScaled(parent:DisplayObjectContainer,url:String, scaleX:Number=1,scaleY:Number=1,showLoading:Boolean = false, fadeTime:int = 100):Image
		{
			DisplayUtil.clean(parent);
			var pic:Image;
			pic=new Image(url,showLoading,0);
			pic.onComplete=reverse;
			pic.mouseChildren=false;
			pic.mouseEnabled=false;
			parent.addChild(pic);
			pic.visible=false;
			return pic;
			
			function reverse(pic:Image):void
			{
				pic.scaleX=scaleX;
				pic.scaleY=scaleY;
				pic.visible=true;
				trace("scale pic");
			}
		}
        public function Image(url:String, showLoading:Boolean = false, fadeTime:int = 100)
        {
			if(url==""||url==null) return;
            this.getImageUrl(url, showLoading, fadeTime);
        }

        public function getImageUrl(url:String, showLoading:Boolean = false, fadeTime:int = 100) : void
        {
            if (url == null || url.length <= 0)
			{
				// trace("no image");
                return;
			}
			
            this.url = url;
            this._time = fadeTime;
            if (_cacheList[url])
            {
                if (_cacheList[url] is BitmapData)
                {
                    addChild(new Bitmap(_cacheList[url], "auto", true));
                    this.runComplete();
                }
                else if (_cacheList[url] is Class)
                {
                    addChild(new _cacheList[url]);
                    this.runComplete();
                }
            }
            else
            {
                this._file = new File();
                this._file.onComplete = this.completeHandler;
                this._file.onError = this.ioErrorHandler;
                this._file.load(url);
                if (showLoading == true)
                {
					var mc:Sprite = new loadClass();
					mc.x = 37;
					mc.y = 37;
                    this.addChild(mc);
                }
            }
        }

        private function ioErrorHandler() : void
        {
            this.clear();
            if (this.bShowErr)
                addChild(new Bitmap(errorImage));
			
            this.runComplete();
        }

        private function completeHandler() : void
        {
            this.clear();
            var loader:Loader = this._file.loader;
            addChild(loader.content);
			
			var content:Object;
            if (loader)
            {
                content = loader.content;
                if (content is Bitmap)
                {
                    (content as Bitmap).smoothing = true;
                    if (_cacheList[this.url] == null)
                        _cacheList[this.url] = (content as Bitmap).bitmapData.clone();
                }
                else if ((this.url.indexOf("icons/farm/") != -1 || this.url.indexOf("icons/fate/") != -1) && _cacheList[this.url] == null || this.url.indexOf("icons/study_stunt/") != -1 || this.url.indexOf("roles/effects/long") != -1)
                {
                    _cacheList[this.url] = content.constructor as Class;
                }
            }
			
            this.runComplete();
        }

        private function runComplete() : void
        {
            listCall.push(this.runCompleteCallback);
            if (this._time > 0)
                this.fadeIn();
        }

        private function runCompleteCallback() : void
        {
            if (this.onComplete is Function == false)
                return;
			
            if (this.onComplete.length == 0)
                this.onComplete();
            else
                this.onComplete(this);
        }

        private function clear() : void
        {
            while (this.numChildren)
            {
                
                this.removeChildAt(0);
            }
        }

        private function fadeIn() : void
        {
            this._startTime = getTimer();
            alpha = 0;
            listFadeIn.push(this.fadeInPass);
        }

        private function fadeInPass() : void
        {
            var pastTime:int = getTimer() - this._startTime;
            this.alpha = pastTime / this._time;
			
			// time out
            if (this.alpha >= 1)
            {
                this.alpha = 1;
                var index:int = listFadeIn.indexOf(this.fadeInPass);
                listFadeIn.splice(index, 1);
            }
        }

        public static function isInCache(param1:String) : Boolean
        {
            return _cacheList.hasOwnProperty(param1);
        }

        private static function enterFrameImage(event:Event) : void
        {
            if (listCall.length > 0)
            {
                for each (var callFun:Function in listCall)
				{
					callFun();
				}
                listCall = [];
            }
			
            for each (var fadeFun:Function in listFadeIn)
			{
				fadeFun();
			}
        }

        public static function init() : void
        {
            enterFrameSprite.addEventListener(Event.ENTER_FRAME, enterFrameImage);
        }
    }
}
