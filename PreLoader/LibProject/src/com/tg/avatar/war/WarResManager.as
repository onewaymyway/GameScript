package com.tg.avatar.war
{
	import com.tg.avatar.war.data.MovieDataFormat;
	import com.tg.avatar.war.data.RoleDataFormat;
	import com.tools.DebugTools;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class WarResManager
	{
		public function WarResManager()
		{
		}
		
		private static var _instance:WarResManager;
		
		public static function get me():WarResManager
		{
			if(!_instance) _instance=new WarResManager;

			return _instance;
		}
		
		private var _dataDic:Dictionary;
		
		private static const Data:String="Data";
		
		/**
		 * 根据描述文件获取位图资源 
		 * @param roleBmd
		 * @return 
		 * 
		 */
		public function getBitMapData(roleBmd:Object):BitmapData
		{
			if (_dataDic == null)
				_dataDic = new Dictionary(true);
			if (!_dataDic[roleBmd])
				_dataDic[roleBmd] = {};
			if(!_dataDic[roleBmd][Data])
			{
				_dataDic[roleBmd][Data]=roleBmd["content"] as BitmapData;
			}
			return _dataDic[roleBmd][Data];
		}
		
		/**
		 * 清除位图资源 
		 * @param roleBmd
		 * 
		 */
		public function clearBitMapData(roleBmd:Object):void
		{
			var data:BitmapData;
			data=getBitMapData(roleBmd);
			if(data)
			{
				data.dispose();
			}
			delete _dataDic[roleBmd];
		}
		
		/**
		 * 已经解析过的资源 
		 */
		private var analysedDic:Dictionary;
		/**
		 * 解析资源文件 
		 * @param roleBmd
		 * 
		 */
		public function analyseBitMapData(roleBmd:Object):void
		{
			if(!analysedDic)
			{
				analysedDic=new Dictionary(true);
			}
			if(analysedDic[roleBmd]) return;
			
			analyseAction(roleBmd,"standBy");
			analyseAction(roleBmd,"attack");
			analyseAction(roleBmd,"attacked");
			

			
			try
			{
				analyseAction(roleBmd,"stunt");
				analyseAction(roleBmd,"die");
			}
			catch(err:Error)
			{
				// 早期资源无Stunt属性
				
			}
			analysedDic[roleBmd]=true;
			clearBitMapData(roleBmd);
		}
		/**
		 * 帧序列解析缓存 
		 */
		protected static var _bitmapList:Dictionary;
		/**
		 * 机械具体的帧动作 
		 * @param roleBmd
		 * @param perWidth
		 * @param perHeight
		 * @param totalWidth
		 * @param totalHeight
		 * @param offsetX
		 * @param offsetY
		 * 
		 */
		protected function analyze(roleBmd:Object, 
								   perWidth:Number, perHeight:Number, totalWidth:int, totalHeight:int, 
								   offsetX:Number = 0, offsetY:Number = 0) : void
		{
			var bmd:BitmapData;
			bmd=getBitMapData(roleBmd);
		
			if(!bmd) return;
			
			if (_bitmapList == null)
				_bitmapList = new Dictionary(true);
			if (!_bitmapList[roleBmd])
				_bitmapList[roleBmd] = {};
			
			var key:String = [offsetX, offsetY].join(",");
			
			var column:int = Math.floor(totalWidth / perWidth);
			var row:int = Math.floor(totalHeight / perHeight);	
			
			var _frames:Array;
			if (_bitmapList[roleBmd][key])
			{
				_frames = _bitmapList[roleBmd][key];
				trace("use preserved bmdframes");
			}
			else
			{
				_frames = [];
				DebugTools.traceBMDSize(bmd.width,bmd.height);
				DebugTools.traceMemory("解析前");
				var r:int = 0;
				while (r < row)
				{
					var c:int = 0;
					while (c < column)
					{
						var subBmd:BitmapData = new BitmapData(perWidth, perHeight, true, 0);
						//						trace("bmd width:"+perWidth+" height:"+perHeight);
						DebugTools.traceBMDSize(perWidth,perHeight);
						var rect:Rectangle = new Rectangle(c * perWidth + offsetX, r * perHeight + offsetY, perWidth, perHeight);
						subBmd.copyPixels(bmd, rect, new Point());
						//						DebugTools.traceMemory("解析中");
						_frames.push(subBmd);
						subBmd = null;
						c++;
					}
					r++;
				}
				_bitmapList[roleBmd][key] = _frames;
			}
			bmd=null;
		}
		
		/**
		 * 解析动作帧序列 
		 * @param roleBmd
		 * @param actionSign
		 * 
		 */
		private function analyseAction(roleBmd:Object,actionSign:String):void
		{
			var actionParams:Object;
			actionParams=roleBmd[actionSign];
			if(!actionParams) return;
			
			actionParams["clipOffset"] = actionParams["clipOffset"] || new Point(0, 0);
			this.analyze(roleBmd, 
				actionParams["minWidth"], actionParams["minHeight"], 
				actionParams["maxWidth"], actionParams["maxHeight"], 
				actionParams["clipOffset"].x, actionParams["clipOffset"].y);
		}
		
		/**
		 * 根据描述文件获取帧序列 
		 * @param roleBmd
		 * @param format
		 * @return 
		 * 
		 */
		public function getFrame(roleBmd:Object,format:MovieDataFormat):Array
		{
//			return [];
			var key:String = [format.offset.x, format.offset.y].join(",");
			return _bitmapList[roleBmd][key];
		}
		/**
		 * 根据动作Key获取帧序列 
		 * @param roleBmd
		 * @param key
		 * @return 
		 * 
		 */
		public function getFramesByKey(roleBmd:Object,key:String):Array
		{
			return _bitmapList[roleBmd][key];
		}
		/**
		 * 清除所有资源 
		 * 
		 */
		public function clear():void
		{
			clearFrames();
			clearAnalysedDic();
			clearBitmapDatas();
		}
		/**
		 * 清理缓存的位图文件资源 
		 * 
		 */
		private function clearBitmapDatas():void
		{
			if(!_dataDic) return;
			for (var k:* in _dataDic)
			{
				delete _dataDic[k];
			}
			_dataDic = null;
		}
		/**
		 * 清除分析后的帧列表资源
		 * 
		 */
		private function clearFrames():void
		{
			if(!_bitmapList) return;
			for (var k:* in _bitmapList)
			{
				delete _bitmapList[k];
			}
			_bitmapList = null;
		}
		
		/**
		 * 清除解析记录资源
		 * 
		 */
		private function clearAnalysedDic():void
		{
			if(!analysedDic) return;
			for (var k:* in analysedDic)
			{
				delete analysedDic[k];
			}
			analysedDic = null;
		}
	}
}