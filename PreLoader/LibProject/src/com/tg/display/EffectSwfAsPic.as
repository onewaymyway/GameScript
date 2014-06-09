package com.tg.display
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.file.File;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	
	/**
	 * 用于加载swf动画，内容位于swf的主场景中
	 * @author ww
	 * 
	 */
	public class EffectSwfAsPic extends Sprite
	{
		public function EffectSwfAsPic(url:String)
		{
			super();
			loadSwf(url);
		}
		
		private var _file:File;
		private var _url:String;
		private function loadSwf(url:String):void
		{
			_url=url;
			this._file = new File();
			this._file.onComplete = this.completeHandler;
			this._file.onError = this.ioErrorHandler;
			this._file.load(url);
		}
		private function ioErrorHandler() : void
		{
//			this.clear();
            trace("load wrong:"+_url);
		}
		
		private function completeHandler() : void
		{
//			this.clear();
			var loader:Loader = this._file.loader;
			//addChild(loader);
			
			if (loader.content is Sprite)
			{
				addChild(loader.content as Sprite);
			}
			else if (loader.content is Bitmap)
			{
				addChild(loader.content as Bitmap);
			}else
			{
				addChild(loader);
			}

		}
		public function dispose():void
		{
			_file=null;
			DisplayUtil.clean(this);
		}
	}
}