package com.tg.Tools.movie
{
	import com.tg.Tools.SWFResLoadTools;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * MovieClip转位图动画工具类
	 * @author ww
	 * 
	 */
	public class BMDManager
	{
		public function BMDManager()
		{
			dataDic=new Dictionary();
		}
		private static var _instance:BMDManager;
		
		public static function get me():BMDManager
		{
			if(!_instance) _instance=new BMDManager;
			return _instance;
		}
		/**
		 * 动画数据缓存 
		 */
		public var dataDic:Dictionary;
		public function addBMDMovie(container:DisplayObjectContainer,url:String,rate:int=24,canDispose:Boolean=true,className:String="MC",x:Number=0,y:Number=0):BMDMovie
		{
			if(!container)return null;
			var tBMDMovie:BMDMovie;
			tBMDMovie=getBMDMovie(url,rate,canDispose,className);
			container.addChild(tBMDMovie);
			tBMDMovie.x=x;
			tBMDMovie.y=y;
			return tBMDMovie;
		}
		/**
		 * 根据资源路径获取位图动画 
		 * 动画在MC链接类中
		 * @param url
		 * @param rate
		 * @param canDispose
		 * @return 
		 * 
		 */
		public function getBMDMovie(url:String,rate:int=24,canDispose:Boolean=true,className:String="MC"):BMDMovie
		{
			var rst:BMDMovie;
			rst=new BMDMovie();
			rst.setFrameRate(rate);
			getMCData(url,className,setUp,canDispose);
			return rst;
			function setUp(data:BMDMovieData):void
			{
				data.candispose=canDispose;
				rst.setData(data);
				rst.play();
			}
		}
		public function resetBMDData(bmdMovie:BMDMovie,url:String,rate:int=24,canDispose:Boolean=true,className:String="MC"):BMDMovie
		{
			getMCData(url,className,setUp,canDispose);
			return bmdMovie;
			function setUp(data:BMDMovieData):void
			{
				data.candispose=canDispose;
				bmdMovie.setFrameRate(rate);
				bmdMovie.setData(data);
				bmdMovie.play();
			}
		}
		public var callBackDic:Object={};
		public function getMCData(url:String,className:String,backFun:Function,candispose:Boolean=true):void
		{
			var tKey:String;
			tKey=url+className;
			if(!candispose&&dataDic[tKey])
			{
				backFun(dataDic[tKey]);
				return;
			}
//			if(callBackDic[tKey]
			SWFResLoadTools.getRes(url,className,getMCBack);
			function getMCBack(mc:MovieClip):void
			{
				if(candispose)
				{
					backFun(getDataByMC(mc))
					return;
				}
				if(!dataDic[tKey])
				{
					dataDic[tKey]=getDataByMC(mc);
				}
				
				backFun(dataDic[tKey])
				if(candispose)
				{
					delete dataDic[tKey];
				}
			}
		}
		
		/**
		 * MovieClip转位图动画数据 
		 * @param mc
		 * @return 
		 * 
		 */
		public static function getDataByMC(mc:MovieClip):BMDMovieData
		{
			if(!mc) return null;
			var rst:BMDMovieData;
			rst=new BMDMovieData();
			var i:int;
			var len:int;
			var tRec:Rectangle;
			var bitmapData:BitmapData ;
			var tM:Matrix;
			var kPoint:Point=new Point;
			var rbmpd:BitmapData;
			var p:Point = new Point();
			rst.frames = Vector.<BitmapData>([]);
			rst.offSets= Vector.<Point>([]);
			tM=new Matrix();
			len=mc.totalFrames;
			rst.frameCount=len;
			for(i=0;i<len;i++)
			{
				mc.gotoAndStop(i+1);
				tRec=mc.getBounds(mc);
				bitmapData=new BitmapData(tRec.width,tRec.height,true,0xffffff); 
				tM.tx=-tRec.x;
				tM.ty=-tRec.y;
				kPoint=new Point(tRec.x,tRec.y);
				bitmapData.draw(mc,tM,null,null,null);
				
				tRec=bitmapData.getColorBoundsRect(0xFFFFFFFF,0x00000000,false);
				rbmpd=new BitmapData(tRec.width,tRec.height);
				kPoint.x+=tRec.x;
				kPoint.y+=tRec.y;
				rbmpd.copyPixels(bitmapData,tRec,p);
				bitmapData.dispose();
				
				rst.frames.push(rbmpd);
				rst.offSets.push(kPoint);
			}
			return rst;
		}
	}
}