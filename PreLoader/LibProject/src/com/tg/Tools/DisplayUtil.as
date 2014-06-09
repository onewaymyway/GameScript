package com.tg.Tools
{
	import com.tg.Tools.style.ColorMatrix;
	import com.tg.Tools.style.StyleLib;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * 封装常用显示对象操作
	 * @author luli&ww
	 */
	public class DisplayUtil
	{
        /**
         * 清空指定container
         * @param container 指定容器
         */
        public static function clean(container:DisplayObjectContainer):void 
		{
			if(!container) return;
			while(container.numChildren)
			{
				releaseResource(container.removeChildAt(0));
			}
        }
		
		/**
		 * 清除对象的资源 
		 * 该对象是Bitmap||该对象有dispose函数时有效
		 * @param resource
		 * 
		 */
		public static function releaseResource(resource:Object):void
		{
			if(!resource) return;
			
			if(resource is Bitmap)
			{
				var bmp:Bitmap;
				bmp=resource as Bitmap;
				if(bmp&&bmp.bitmapData)
				{
					bmp.bitmapData.dispose();
				}		
				
			}
			
			var releaseFun:Function;
			
			if(resource.hasOwnProperty("dispose")&&(resource["dispose"] is Function))
			{
				releaseFun=resource["dispose"];
			}
			if(releaseFun!=null)
			{
				releaseFun();
			}
		}
		/**
		 * 将显示对象设置到父容器的最顶层 
		 * @param dis
		 * 
		 */
		public static function setTop(dis:DisplayObject):void
		{
			if(dis.parent)
			{
				var tParent:DisplayObjectContainer;
				tParent=dis.parent;
				tParent.setChildIndex(dis,tParent.numChildren-1);
			}
		}
		
		
		/**
		 * 隐藏容器中的条目 
		 * @param container
		 * @param preFix 条目名字前缀
		 * @param count 最大index
		 * @param start 最小index
		 * 
		 */
		public static function setHideItems(container:DisplayObjectContainer,preFix:String,end:int,start:int=0):void
		{
			var i:int;
			for(i=start;i<=end;i++)
			{
				container[preFix+i].visible=false;
			}
		}
		/**
		 * 重置容器中的条目 
		 * @param container
		 * @param preFix
		 * @param end
		 * @param start
		 * 
		 */
		public static function resetItems(container:DisplayObjectContainer,preFix:String,end:int,start:int=0):void
		{
			var i:int;
			for(i=start;i<=end;i++)
			{
				container[preFix+i].reset();
			}
		}
		
		/**
		 * 获取容器中的Item列表 
		 * @param container
		 * @param preFix
		 * @param end
		 * @param start
		 * @return 
		 * 
		 */
		public static function getItemList(container:DisplayObjectContainer,preFix:String,end:int,start:int=0):Array
		{
			var i:int;
			var tItem:*;
			var rst:Array=[];
			for(i=start;i<=end;i++)
			{
				tItem=container[preFix+i];
				if(tItem)
				{
					rst.push(tItem);
				}
			}
			
			return rst;
		}
		/**
		 * 重置列表中的ITEM 
		 * @param itemList
		 * 
		 */
		public static function resetItemsList(itemList:Array):void
		{
			var i:int;
			var len:int;
			var tItem:*;
			len=itemList.length;
			for(i=0;i<len;i++)
			{
				tItem=itemList[i];
				if(!tItem) continue;
				tItem.reset();
			}
		}
		/**
		 * 设置items内容 
		 * @param itemsList 显示对象Item列表
		 * @param itemInforList 显示数据列表
		 * 
		 */
		public static function fillItems(itemsList:Array,itemInforList:Array):void
		{
			var i:int;
			var len:int;
			var tItemDis:*;
			var tItemInfor:Object;
			len=itemInforList.length;
			for(i=0;i<len;i++)
			{
				tItemDis=itemsList[i];
				if(!tItemDis) continue;
				tItemInfor=itemInforList[i];
				if(!tItemInfor) continue;
				tItemDis.init(tItemInfor);
			}
		}
		/**
		 * 将指定对象移除显示列表
		 * @param item 指定显示对象
		 * @param clear 在移除时是否清除该对象资源
		 */
		public static function selfRemove(item:DisplayObject,clear:Boolean=false):void {
			if(item && item.parent)
			{
				item.parent.removeChild(item);
				if(clear)
				{
					releaseResource(item);
				}
			} 
		}
		/**
		 * 给对象添加滤镜，需要考虑多个滤镜的情况
		 * @param target 需要应用滤镜的对象
		 * @param filter 滤镜滤镜
		 * @return 添加的滤镜对象
		 */
		public static function addFilter(target:DisplayObject, filter:*):void
		{
			var currentFilters:Array = target.filters || [];
			currentFilters.push(filter);
			target.filters = currentFilters;
		}
		/**
		 * 为可视对象添加发光滤镜
		 * @param target 目标对象
		 * @param color 发光颜色
		 * @param thinkness 发光范围
		 */
		public static function glow(target:DisplayObject, color:int, thinkness:int = 2):void
		{
			addFilter(target, new GlowFilter(color, 1, thinkness, thinkness));
		}
		
		/**
		 * 经典黑边滤镜
		 */
//		public static function outlineBlack(target:DisplayObject):void 
//		{
//			addFilter(target, FilterStyle.blackFilter);
//		}
		/**
		 * 增加灰度滤镜
		 */
		public static function gray(target:DisplayObject):void 
		{
			target.filters = [StyleLib.grayFilter];
		}
		
		public static function dark(target:DisplayObject,brightness:int=-35):void 
		{
			var mat:ColorMatrix = new ColorMatrix();
			

			
			mat.adjustBrightness(255*brightness/100);
			
			var cm:ColorMatrixFilter = new ColorMatrixFilter(mat.matrix);
			target.filters=[cm];
		}
		/**
		 * 添加元素到容器中，并设置元素的name和坐标
		 */
		public static function moveTarget(container:DisplayObjectContainer, target:DisplayObject, x:int = 0, y:int = 0, name:String = ""):void 
		{
			container.addChild(target);
			target.x = x;
			target.y = y;
			if(name) target.name = name;
		}
		
		/**
		 * 设置是否接受鼠标事件 
		 * @param dis
		 * @param enable
		 * 
		 */
		public static function setMouseEnable(dis:*,enable:Boolean):void
		{
			dis.mouseEnabled=enable;
			dis.mouseChildren=enable;
		}
		public static function setMouseEnableK(dis:Object,enable:Boolean):void
		{
			if(dis.hasOwnProperty("mouseEnabled"))
			{
				dis.mouseEnabled=enable;
			}
			if(dis.hasOwnProperty("mouseChildren"))
			{
				dis.mouseChildren=enable;
			}
		}
		/**
		 * 相对兄弟对象居中
		 * @param targetDis 兄弟对象
		 * @param disList 居中对象列表
		 * @param dX 居中对象间距
		 * 
		 */
		public static function centerToBro(targetDis:DisplayObject,disList:Array,dX:Number=20):void
		{
			var tRect:Rectangle;
			tRect=targetDis.getBounds(targetDis);
			var cX:Number;
			cX=tRect.x+0.5*tRect.width+targetDis.x;
            disList=getShowDis(disList);
			centerToX(cX,disList,dX);
		}
		
		public static function centerToBroH(targetDis:DisplayObject,dis:DisplayObject,d:Number=0):void
		{
			var tRect:Rectangle;
			tRect=targetDis.getBounds(targetDis);
		    var cY:Number;
			cY=tRect.y+tRect.height*0.5+d+targetDis.y;
			disUpToY(cY,dis);
		}
		/**
		 * 相对父容器居中
		 * @param targetDis 父容器
		 * @param disList 居中对象列表
		 * @param dX 居中对象间距
		 * 
		 */
		public static function centerToParent(targetDis:DisplayObject,disList:Array,dX:Number=20):void
		{
			var tRect:Rectangle;
			tRect=targetDis.getBounds(targetDis);
			var cX:Number;
			cX=tRect.x+0.5*tRect.width;
			disList=getShowDis(disList);
			centerToX(cX,disList,dX);
		}
		
		/**
		 * 居中至X坐标
		 * @param cX
		 * @param disList  居中对象列表
		 * @param dX 居中对象间距
		 * 
		 */
		public static function centerToX(cX:Number,disList:Array,dX:Number=20):void
		{
			var sumWidth:int;
			sumWidth=0;
			var i:int;
			var len:int;
			len=disList.length;
			var tDis:DisplayObject;
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				sumWidth+=tDis.width;
			}
			sumWidth+=(len-1)*dX;
			var sX:int;
			sX=cX-0.5*sumWidth;
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				tDis.x=sX;
				sX+=tDis.width+dX;
			}
		}
		
		/**
		 * 将显示对象相对于X坐标居中
		 * @param cX
		 * @param dis
		 * 
		 */
		public static function disCenterToX(cX:Number,dis:DisplayObject):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			dis.x=cX-tRect.x-0.5*tRect.width;
		}
		
		/**
		 * 右对齐至
		 * @param rX
		 * @param dis
		 * @param d
		 * 
		 */
		public static function disRightToX(rX:Number,dis:DisplayObject,d:Number=0):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			dis.x=rX-tRect.x-tRect.width-d;
		}
		
		/**
		 * 左对齐至
		 * @param lX
		 * @param dis
		 * @param d
		 * 
		 */
		public static function disLeftToX(lX:Number,dis:DisplayObject,d:Number=0):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			dis.x=lX-tRect.x+d;
		}
		
		/**
		 * 上对齐至
		 * @param y
		 * @param dis
		 * @param d
		 * 
		 */
		public static function disUpToY(y:Number,dis:DisplayObject,d:Number=0):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			dis.y=y-tRect.y+d;
		}
		
		/**
		 * 下对齐至
		 * @param y
		 * @param dis
		 * @param d
		 * 
		 */
		public static function disDownToY(y:Number,dis:DisplayObject,d:Number=0):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			dis.y=y-tRect.y-tRect.height-d;
		}
		/**
		 * 将显示对象相对于Y坐标居中
		 * @param cY
		 * @param dis
		 * 
		 */
		public static function disCenterToY(cY:Number,dis:DisplayObject):void
		{
			var tRect:Rectangle;
			tRect=dis.getBounds(dis);
			var cX:Number;
			dis.y=cY-tRect.y-0.5*tRect.height;
		}
		
		public static function disCenterToDis(dis:DisplayObject,target:DisplayObject):void
		{
			var tRec:Rectangle;
			tRec=target.getBounds(target);
			disCenterToXY(tRec.x+tRec.width*0.5,tRec.y+tRec.height*0.5,dis);
			
		}
		/**
		 * 将显示对象相对于XY坐标居中
		 * @param cX
		 * @param cY
		 * @param dis
		 * 
		 */
		public static function disCenterToXY(cX:Number,cY:Number,dis:DisplayObject):void
		{
			disCenterToX(cX,dis);
			disCenterToY(cY,dis);
		}
		/**
		 * 将显示对象列表移到x坐标处
		 * @param sX
		 * @param disList
		 * @param dX
		 * 
		 */
		public static function showToX(sX:Number,disList:Array,dX:Number=20):void
		{
			var i:int;
			var len:int;
			var tDis:DisplayObject;
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				tDis.x=sX;
				sX+=tDis.width+dX;
			}
		}
		public static function getShowDis(disList:Array):Array
		{
			var tDis:DisplayObject;
			var i:int;
			var len:int;
			len=disList.length;
			var rst:Array;
			rst=[];
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				if(tDis&&tDis.visible)
				{
					rst.push(tDis);
				}
			}
			return rst;
		}
		
		/**
		 * 判断是否是几代以内的子对象 
		 * @param child
		 * @param parent
		 * @param n 代数
		 * @return 
		 * 
		 */
		public static function isSonOf(child:DisplayObject,parent:DisplayObject,n:int=4):Boolean
		{
			var i:int;
			var tChild:DisplayObject;
			tChild=child;
			if(!tChild) return false;
			for(i=0;i<n;i++)
			{
				tChild=tChild.parent;
				if(!tChild) break;
				if(tChild==parent)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 设置对象组的显示隐藏 
		 * @param disList
		 * @param ifShow
		 * 
		 */
		public static function setDisListVisible(disList:Array,ifShow:Boolean=true):void
		{
			var i:int;
			var len:int;
			var tDis:DisplayObject;
			len=disList.length;
			for(i=0;i<len;i++)
			{
				tDis=disList[i];
				if(tDis)
				{
					tDis.visible=ifShow;
				}
			}
		}
		
		/**
		 * 设置对象组的选中组 
		 * @param disGroupList
		 * @param id
		 * 
		 */
		public static function showSelectList(disGroupList:Array,id:int):void
		{
			var i:int;
			var len:int;
			len=disGroupList.length;
			for(i=0;i<len;i++)
			{
				if(disGroupList[i])
				{
					if(disGroupList[i] is Array)
					{
						setDisListVisible(disGroupList[i],id==i);
					}
					if(disGroupList[i] is DisplayObject)
					{
						setDisListVisible([disGroupList[i]],id==i);
					}
				}
			}
		}
		/**
		 * 将显示对象移至新的父容器 
		 * @param dis
		 * @param newParent
		 * 
		 */
		public static function moveToNewParent(dis:DisplayObject,newParent:DisplayObjectContainer):void
		{
			if(!dis) return;
			if(!newParent) return;
			var tPoint:Point;
			tPoint=dis.localToGlobal(new Point(0,0));
			tPoint=newParent.globalToLocal(tPoint);
			newParent.addChild(dis);
			dis.x=tPoint.x;
			dis.y=tPoint.y;
		}
		/**
		 * 将tip显示到对象上 
		 * @param tip
		 * @param target
		 * @param force 是否锁定对象
		 * 
		 */
		public static function disTipTo(tip:DisplayObject,target:DisplayObject,force:Boolean=false):void
		{
			if(!target) return;
			if(!tip) return;
			var tParent:DisplayObjectContainer;
			tParent=target.parent;
			if(!tParent) return;
			var tRec:Rectangle;
			tRec=target.getBounds(tParent);
			
			if(target is TextField)
			{
				var tTxt:TextField;
				tTxt=target as TextField;
				tRec.width=tTxt.textWidth;
				tRec.height=tTxt.textHeight;
			}
			
			DisplayUtil.setMouseEnable(tip,false);

			
			tParent.addChild(tip);
			var disType:int;
			disType=DisLayOutType.getDisMainType(tip);
			switch(disType)
			{
				case DisLayOutType.Left:
					disRightToX(tRec.x,tip);
//					centerToBroH(target,tip);
					tip.y=tRec.y+0.5*tRec.height;
					if(target is TextField)
					{
						tip.y=tRec.y+5;
					}else
					{
						
					}
					break;
				case DisLayOutType.Right:
					disLeftToX(tRec.x+tRec.width,tip);
//					centerToBroH(target,tip);
					
					tip.y=tRec.y+0.5*tRec.height;
					if(target is TextField)
					{
						tip.y=tRec.y+5;
					}
					break;
				case DisLayOutType.Up:
					disDownToY(tRec.y,tip);
//					centerToBro(target,[tip],0);
					tip.x=tRec.x+tRec.width*0.5;
					break;
				case DisLayOutType.Down:
					disUpToY(tRec.y+tRec.height,tip);
//					centerToBro(target,[tip],0);
					tip.x=tRec.x+tRec.width*0.5;
					break;
			}
			if(force)
			{
				ShadeTools.me().shadeAllBut(target);
			}
			
		}
	}
}
