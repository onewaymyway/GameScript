package com.tg.layoutTool
{
	import com.tg.StageUtil;
	import com.tg.Tools.DisplayUtil;
	import com.tg.layoutTool.struct.AdaptDes;
	import com.tools.ObjectTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * 窗口变化处理器
	 * @author ww
	 * 
	 */
	public class ResizeDealer
	{
		public function ResizeDealer()
		{
			_mainContainer = new Sprite();
			_mainContainer.graphics.beginFill(0, 1);
			_mainContainer.graphics.drawRect(0, 0, screenMaxWidth, screenMaxHeight);
			_mainContainer.graphics.endFill();
			
			if(!blackShader)
			{
				blackShader = new Sprite();
				blackShader.graphics.beginFill(0, 1);
				blackShader.graphics.drawRect(0, 0, screenMaxWidth, screenMaxHeight);
				blackShader.graphics.endFill();
			}
			_oWidth=_mainContainer.width;
			_oHeight=_mainContainer.height;
			
			relateItemList=[];
			absoluteItemList=[];
			linerGroupList=[];
		}
		
		/**
		 * 主容器
		 */
		private var container:DisplayObjectContainer;
		
		/**
		 * 遮挡用的黑板
		 */
		private static var blackShader:Sprite;
		/**
		 * 进行相对定位的显示对象数组
		 * 在调整过程中使用相对坐标
		 */
		[ArrayElementType("com.tg.layoutTool.struct.AdaptDes")]
		private var relateItemList:Array;
		/**
		 * 进行绝对比例进行定位的显示对象数组
		 * 在调整过程中将显示对象坐标调整到原先的位置
		 */
		[ArrayElementType("com.tg.layoutTool.struct.AdaptDes")]
		private var absoluteItemList:Array;
		/**
		 * 按间隔比例排列的显示对象组列表
		 * 
		 */
		private var linerGroupList:Array;
		/**
		 * 定位的主参照物，该参照物将在调整过程中被缩放
		 * 若为空取显示区域的数据代替
		 */
		private var _mainContainer:Sprite;
		
		
		/**
		 * 最初的宽
		 */
		private var _oWidth:Number;
		/**
		 * 最初的高
		 */
		private var _oHeight:Number;
		
		/**
		 * 当前的缩放值 
		 */
		public var scale:Number;
		
		public function setContainer(tDis:DisplayObjectContainer):void
		{
			container=tDis;
		}
		/**
		 * 设置将被调整大小的主参照物 
		 * @param tDis
		 * 
		 */
		public function setMainContainer(tDis:Sprite):void
		{
			_mainContainer=tDis;
			_oWidth=_mainContainer.width;
			_oHeight=_mainContainer.height;
		}
		/**
		 * 添加通过相对坐标定位的显示对象 
		 * @param dis 要定位的显示对象
		 * @param property 要定位的属性x|y
		 * @param destDis 相对的对象
		 * 
		 */
		public function addRelateItem(dis:DisplayObject,property:String,destDis:DisplayObject):void
		{
			var adaptInfo:AdaptDes;
			adaptInfo=new AdaptDes;
			
			adaptInfo.dis=dis;
			adaptInfo.destDis=destDis;
			adaptInfo.property=property;
			adaptInfo.value=dis[property]-destDis[property];
			
			relateItemList.push(adaptInfo);
		}
		/**
		 * 添加通过相对坐标定位的显示对象 
		 * @param dis  要定位的显示对象
		 * @param destDis 相对的对象
		 * 
		 */
		public function addRelateItemXY(dis:DisplayObject,destDis:DisplayObject):void
		{
			addRelateItem(dis,"x",destDis);
			addRelateItem(dis,"y",destDis);
		}
		/**
		 * 添加通过绝对比例定位的显示对象 
		 * @param dis   要定位的显示对象
		 * @param property  要定位的属性x|y
		 * 
		 */
		public function addAbsoluteItem(dis:DisplayObject,property:String):void
		{
			var adaptInfo:AdaptDes;
			adaptInfo=new AdaptDes;
			
			adaptInfo.dis=dis;
			adaptInfo.property=property;
			var tValue:Number;
            switch(property)
			{
				case "x":
					tValue=dis.x/width;
					break;
				case "y":
					tValue=dis.y/height;
					break;
			}
			adaptInfo.value=tValue;
			
			absoluteItemList.push(adaptInfo);
		}
		/**
		 * 添加通过绝对比例定位的显示对象数组
		 * @param disList 要定位的显示对象数组
		 * @param property 要定位的属性x|y
		 * 
		 */
		public function addAbsoluteItemList(disList:Array,property:String):void
		{
			var dis:DisplayObject;
			var i:int;
			var len:int;
			len=disList.length;
			for(i=0;i<len;i++)
			{
				dis=disList[i];
				addAbsoluteItem(dis,property);
			}
		}
		/**
		 * 添加通过绝对比例定位的显示对象数组
		 * @param disList 要定位的显示对象数组
		 * 
		 */
		public function addAbsoluteItemListXY(disList:Array):void
		{
			addAbsoluteItemList(disList,"x");
			addAbsoluteItemList(disList,"y");
		}
		/**
		 * 添加通过绝对比例定位的显示对象  
		 * @param dis 要定位的显示对象
		 * 
		 */
		public function addAbsoluteItemXY(dis:DisplayObject):void
		{
			addAbsoluteItem(dis,"x");
			addAbsoluteItem(dis,"y");
		}
		
		public function addLinerGroup(linerGroup:Array,property:String):void
		{
			var adaptInfo:AdaptDes;
			adaptInfo=new AdaptDes;
			
			adaptInfo.disList=linerGroup;
			adaptInfo.property=property;
			
			linerGroup.sortOn(property,Array.NUMERIC);
			var tVProperty:String;
			tVProperty=getVProperty(tVProperty);
			var tValueList:Array=[];
			var tD:Number;
			tD=0;
			var tDis:DisplayObject;
			var i:int;
			var len:int;
			var sumD:Number;
			sumD=0;
			len=linerGroup.length;
			for(i=0;i<len;i++)
			{
				tDis=linerGroup[i];
				tValueList[i]=tDis[property]-tD;
				tD=tDis+tDis[tVProperty];
				sumD+=tDis[tVProperty];
				
			}
			var emptyD:Number;
			emptyD=this[tVProperty]-sumD;
			adaptInfo.value=sumD;
			if(emptyD==0) emptyD=1;
			for(i=0;i<len;i++)
			{
				tValueList[i]=tValueList[i]/emptyD;				
			}
			
			adaptInfo.valueList=tValueList;
			
			linerGroupList.push(adaptInfo);

			
		}
		/**
		 * 记录当前的布局数据
		 * 数据将用于在调整时进行布局
		 * 
		 */
		public function record():void
		{
			_oWidth=width;
			_oHeight=height;
		}
		/**
		 * 调整布局
		 * 
		 */
		public function dealResize():void
		{
			dealMainContainer();
			dealAbsoluteItem();
			dealLinerGroup();
			dealRelateItem();
			adaptToScreen();
		}
		
		/**
		 * 调整主参考对象 
		 * 
		 */
		private function dealMainContainer():void
		{
			var scaleWidth:Number;
			var scaleHeight:Number;
			scaleWidth=screenWidth/_oWidth;
			scaleHeight=screenHeight/_oHeight;
			scale=scaleWidth<scaleHeight?scaleWidth:scaleHeight;
			
			if(_mainContainer)
			{
				_mainContainer.scaleX=_mainContainer.scaleY=scale;
			}
			
		}
		/**
		 * 处理绝对布局的显示对象 
		 * 
		 */
		private function dealAbsoluteItem():void
		{
			ObjectTools.adaptObjectList(absoluteItemList,dealAbsoluteItemFun);
		}
		private function dealAbsoluteItemFun(adaptInfo:AdaptDes):void
		{
			var property:String;
			var tValue:Number;
			var dis:Object;
			dis=adaptInfo.dis;
			property=adaptInfo.property;
			switch(property)
			{
				case "x":
					tValue=width*adaptInfo.value;
					break;
				case "y":
					tValue=height*adaptInfo.value;
					break;
			}
			dis[property]=tValue;
		}
		/**
		 * 处理线性布局的元素 
		 * 
		 */
		private function dealLinerGroup():void
		{
			ObjectTools.adaptObjectList(linerGroupList,dealLinerGroupFun);
		}
		private function getVProperty(property:String):String
		{
			var rst:String;
			rst="width";
			switch(property)
			{
				case "x":
					rst="width";
					break;
				case "y":
					rst="height";
					break;
			}
			return rst;
		}
		private function dealLinerGroupFun(adaptInfo:AdaptDes):void
		{
			var property:String;
			property=adaptInfo.property;
			
		    var tVProperty:String;
			tVProperty=getVProperty(tVProperty);
			var tValueList:Array=[];
			var tD:Number;
			tD=0;
			var tDis:DisplayObject;
			var i:int;
			var len:int;
			var sumD:Number;
			var emptyD:Number;
			var linerGroup:Array;
			linerGroup=adaptInfo.disList;
			sumD=adaptInfo.value;
			emptyD=this[tVProperty]-sumD;
			len=linerGroup.length;
			for(i=0;i<len;i++)
			{
				tDis=linerGroup[i];
				tDis[property]=tD+tValueList[i]*emptyD;
				tD=tDis+tDis[tVProperty];				
			}
			

			
		}
		/**
		 * 处理相对布局的显示对象 
		 * 
		 */
		private function dealRelateItem():void
		{
			ObjectTools.adaptObjectList(relateItemList,dealRelateItemFun);
		}
		private function dealRelateItemFun(adaptInfo:AdaptDes):void
		{
		   var property:String;
		   property=adaptInfo.property;
		   adaptInfo.dis[property]=adaptInfo.destDis[property]+adaptInfo.value;
		}
		/**
		 * 当前主容器的宽
		 * @return 
		 * 
		 */
		public function get width():Number
		{
			if(_mainContainer) return _mainContainer.width;
			
			return screenWidth;
		}
		
		/**
		 * 当前主容器高
		 * @return 
		 * 
		 */
		public function get height():Number
		{
			if(_mainContainer) return _mainContainer.height;
			
			return screenHeight;
		}
		
		/**
		 * 当前显示区域宽
		 * @return 
		 * 
		 */
		public function get screenWidth():Number
		{
			return StageUtil.adjustedStageWidth;
		}
		
		/**
		 * 当前显示区域高
		 * @return 
		 * 
		 */
		public function get screenHeight():Number
		{
			return StageUtil.adjustedStageHeight;
		}
		/**
		 * 最大显示区域宽
		 * @return 
		 * 
		 */
		public function get screenMaxWidth():Number
		{
			return StageUtil.maxStageWidth;
		}
		/**
		 * 最大显示区域高
		 * @return 
		 * 
		 */
		public function get screenMaxHeight():Number
		{
			return StageUtil.maxStageHeight;
		}
		
		/**
		 * 将对象调整到屏幕的合适位置 
		 * 
		 */
		public function adaptToScreen():void
		{
			if(container)
			{
				StageUtil.setDisVCenter(container);
				StageUtil.setDisHCenter(container);
				if(blackShader)
				{
					if(container.parent)
					{
						var tParent:DisplayObjectContainer;
						tParent=container.parent;
						if(blackShader.parent!=tParent)
						{
							tParent.addChildAt(blackShader,0);
						}
					}
					StageUtil.setDisVCenter(blackShader);
					StageUtil.setDisHCenter(blackShader);
				}
			}
		}
		
		/**
		 * 隐藏黑色背景 
		 * 
		 */
		public function hide():void
		{
			DisplayUtil.selfRemove(blackShader);
		}
		
		public function clear():void
		{
//			blackShader=null;
			container=null;
			this._mainContainer=null;
			this.container=null;
			this.absoluteItemList=[];
			this.linerGroupList=[];
			this.relateItemList=[];
		}
	}
}