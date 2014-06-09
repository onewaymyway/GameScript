package com.tg.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.animation.IAnimatable;

	/**
	 * 动画渲染类
	 * 
	 * @example Basic usage:
	 * <listing version="3.0">
	 import br.com.stimuli.loading.BulkLoader;
	 
		private function testRender():void
		{
			mc = TgMovieClip.create(loader.getBitmapData(fileName + ".png"),loader.getText(fileName + ".json"),"art");
			addChild(mc);
			mc.frameRate = 12;
			Starling.current.juggler.add(mc);
			
			//mc.opaqueBackground = 0x336633;
			mc.x = 0;
			mc.y = 0;
			
			//如果使用EnterFrame来播放动画，则frameRate不能使用
			//this.addEventListener(flash.events.Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onEnterFrame(event:flash.events.Event):void
		{
			mc.onEnterFrame();
		}
	</listing>
     * @langversion ActionScript 3.0
     * @playerversion Flash 9.0
     *
     * @author icefire
     * @since  18.12.2013
	 */
	public class TgMovieClip extends Bitmap implements IAnimatable
	{
		public var frames:Vector.<BitmapData>;
		public var frameRate:int = 12;
		
		private static const translateMatrix:Matrix = new Matrix();
		private const bitmapsMap:Dictionary = new Dictionary(true);
		
		private var currentFrame:int = 0;
		private var lastTime:Number = 0;

		
		public function TgMovieClip(autoDispose:Boolean=false)
		{
			if (autoDispose)
				addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		/**
		 * 动画渲染方法 
		 * @param time
		 * 
		 */		
		public function advanceTime(time:Number):void
		{
			if (!frames || frames.length == 0)
				return;
			
			lastTime += time;
			
			const tmpframeRate:Number = 1 / frameRate;
			
			if (lastTime < tmpframeRate)
				return;
			
			lastTime -= tmpframeRate;
			
			if (currentFrame > frames.length-1)
				currentFrame = 0;
			
			bitmapData = frames[currentFrame];
			currentFrame++;
		}
		
		/**
		 * 侦听EnterFrame事件来播放动画，使用这个方法播放时，frameRate失效 
		 */		
		public function onEnterFrame():void
		{
			if (!frames || frames.length == 0)
				return;
			
			
			if (currentFrame > frames.length - 1)
				currentFrame = 0;
			
			bitmapData = frames[currentFrame];
			currentFrame++;
		}
		
		public function dispose():void
		{
			bitmapData.dispose();
			currentFrame = 0;
			
			var tmpbmpd:BitmapData;
			while(Boolean(tmpbmpd = frames.pop()))
				tmpbmpd.dispose();
			
			
			for(var bit:* in bitmapsMap)
			{
				(bitmapsMap[bit] as BitmapData).dispose();
				delete bitmapsMap[bit];
			}
		}
		
		/**
		 * 创建动画实例, 可以用Flash cs6 或者TexturePackage软件导出
		 * @param sourceBitmapData 源bitmapData数据
		 * @param sourceJsonData 源 JSON数据，目前只支持JsonArray
		 * @param prefix 动画帧名称前缀，用来支持一个纹理中包含多个动画
		 * @return 返回动画实例
		 */		
		public static function create(sourceBitmapData:BitmapData,sourceJsonData:String,prefix:String,autoDispose:Boolean=false):TgMovieClip
		{
			var tgMc:TgMovieClip = new TgMovieClip(autoDispose);
			var sourceJsonObj:*  = JSON.parse(sourceJsonData);
			var allframes:Array = sourceJsonObj.frames;
			
			function isStartWithPrefix(frame:*, index:int, arr:Array):Boolean
			{
				return String(frame.filename).indexOf(prefix) == 0;
			}
			
			if (prefix && prefix.length > 0)
				allframes = allframes.filter(isStartWithPrefix);
			
			
			tgMc.frames = Vector.<BitmapData>([]);
			
			for (var i:int = 0; i < allframes.length; i++) 
			{
				tgMc.frames.push(tgMc.createKeyFrame(allframes[i],sourceBitmapData));
			}
			
			tgMc.bitmapData = tgMc.frames[tgMc.currentFrame];
			return tgMc;
		}
		
		private function createKeyFrame(item:Object,srouceBmpd:BitmapData):BitmapData
		{
			var key:String = createKey(item.frame);
			if (bitmapsMap[key])
				return bitmapsMap[key];
			
			
			var sourceRec:Rectangle
			var bmpd:BitmapData;
			
			if (item.rotated)
			{
				sourceRec = new Rectangle(item.frame.x,item.frame.y,item.frame.h,item.frame.w);
				bmpd = new BitmapData(item.frame.h,item.frame.w);
			}
			else
			{
				sourceRec = new Rectangle(item.frame.x,item.frame.y,item.frame.w,item.frame.h);
				bmpd = new BitmapData(item.frame.w,item.frame.h);
			}

			bmpd.copyPixels(srouceBmpd,sourceRec,new Point());
			//旋转和裁切
			if (item.rotated || item.trimmed)
			{
				var newbd:BitmapData;
				if (item.rotated)
				{
					translateMatrix.rotate(-Math.PI/2);
					translateMatrix.translate(0,bmpd.width);
					newbd = new BitmapData(bmpd.height,bmpd.width,true,0x00000000);
					newbd.draw(bmpd,translateMatrix);
					bmpd.dispose();
					bmpd = null;
					translateMatrix.identity();
					bmpd = newbd;
				}
				
				if (item.trimmed)
				{
					translateMatrix.translate(item.spriteSourceSize.x,item.spriteSourceSize.y);
					newbd = new BitmapData(item.sourceSize.w,item.sourceSize.h,true,0x00000000);
					newbd.draw(bmpd,translateMatrix);
					bmpd.dispose();
					bmpd = null;
					translateMatrix.identity();
					bmpd = newbd;
				}
			}
			bitmapsMap[key] = bmpd;
			return bmpd;
		}
		
		private function createKeyFrame2(item:Object,srouceBmpd:BitmapData):BitmapData
		{
			var key:String = createKey(item.frame);
			if (bitmapsMap[key])
				return bitmapsMap[key];
			
			var sourceRec:Rectangle = new Rectangle(item.frame.x,item.frame.y,item.frame.w,item.frame.h);
			var bmpd:BitmapData = new BitmapData(item.frame.w,item.frame.h);
			bmpd.copyPixels(srouceBmpd,sourceRec,new Point());
			//旋转和裁切
			if (item.rotated || item.trimmed)
			{
				var newbd:BitmapData;
				if (item.rotated)
				{
					translateMatrix.rotate(-Math.PI/2);
					translateMatrix.translate(0,bmpd.width);
					newbd = new BitmapData(bmpd.height,bmpd.width);
					newbd.draw(bmpd,translateMatrix);
					bmpd.dispose();
					bmpd = null;
					translateMatrix.identity();
					bmpd = newbd;
				}
				
				if (item.trimmed)
				{
					translateMatrix.translate(item.spriteSourceSize.x,item.spriteSourceSize.y);
					newbd = new BitmapData(item.sourceSize.w,item.sourceSize.h);
					newbd.draw(bmpd,translateMatrix);
					bmpd.dispose();
					bmpd = null;
					translateMatrix.identity();
					bmpd = newbd;
				}
			}
			bitmapsMap[key] = bmpd;
			return bmpd;
		}
		
		private function createKey(t:Object):String
		{
			var strTmp:String = "x:{0}|y:{1}|w:{2}|h:{3}";
			strTmp = strTmp.replace("{0}",t.x);
			strTmp = strTmp.replace("{1}",t.y);
			strTmp = strTmp.replace("{2}",t.w);
			strTmp = strTmp.replace("{3}",t.h);
			return strTmp;
		}
		
		
		private function onRemoveFromStage(evt:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			dispose();
		}
		
	}
}