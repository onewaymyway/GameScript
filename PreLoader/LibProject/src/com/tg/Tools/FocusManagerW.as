package com.tg.Tools
{

	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * 焦点管理类
	 * @author ww
	 * 
	 */
	public class FocusManagerW
	{
		/**
		 * 使用的焦点滤镜 
		 */		
		public static const focusFilter:GlowFilter = new GlowFilter(0xffdf47,1,8,8,2,BitmapFilterQuality.MEDIUM);
		
		public static const focusFilterBig:GlowFilter = new GlowFilter(0xffdf47,1,16,16,2,BitmapFilterQuality.MEDIUM);
		/**
		 * 加背景框的焦点滤镜 
		 */
		private static const focusFilterK:GlowFilter = new GlowFilter(0xffdf47,1,8,8,2,BitmapFilterQuality.MEDIUM,false,true);
		/**
		 * 前一个焦点对象 
		 */		
		private static var preFocusItem:DisplayObject;
		/**
		 * 创建的焦点对象的背景 
		 */		
		private static var textBack:Sprite;
		public function FocusManagerW()
		{
		}
		/**
		 * 获取焦点背景 
		 * @return 
		 * 
		 */		
		private static function getTextBack():Sprite
		{
			if(!textBack)
			{
				textBack=new Sprite();
				var temp:Sprite=new Sprite;
				temp.graphics.clear();
				temp.graphics.beginFill(0x000000);
				temp.graphics.drawRect(0,0,20,20);
				temp.alpha = 1;
				textBack.addChild(temp);
			}
			return textBack;
		}
		/**
		 * 在焦点对象下方加上背景 
		 * @param txt
		 * 
		 */		
		private static function setTextBack(txt:DisplayObject):void
		{
			if(!txt.parent) return;
			var tParent:DisplayObjectContainer=txt.parent;
			getTextBack();
			var tREc:Rectangle=txt.getRect(txt.parent);
			textBack.x=tREc.x-2;
			textBack.y=tREc.y-2;
			textBack.width=tREc.width+4;
			textBack.height=tREc.height+4;
			tParent.addChildAt(getTextBack(),tParent.getChildIndex(txt));
			
		}
		/**
		 * 为显示对象加上焦点滤镜 
		 * @param display 焦点对象
		 * @param setBack 
		 * 是否要加背景框
		 * false 不加
		 * true 加
		 * 
		 */		
		public static function setFocus(display:DisplayObject,setBack:Boolean=false):void
		{
			if(preFocusItem==display) return;
			if(textBack&&textBack.parent==display) return;
			clearFocus();
			
			preFocusItem=display;
			if((preFocusItem is TextField)||setBack)
			{
				////trace("setFocus textfield:"+(preFocusItem as TextField).text);
				setTextBack(preFocusItem );
				preFocusItem=textBack;
				preFocusItem.filters=[focusFilterK];
				return;
			}
			if(preFocusItem)
			{
				preFocusItem.filters=[focusFilter];
				//trace("setFocus:"+preFocusItem.name);
			}
			
			
		}
		public static function setMouseEnable(dis:DisplayObjectContainer,enable:Boolean=true):void
		{
			if(!dis) return;
			dis.mouseChildren=enable;
			dis.mouseEnabled=enable;
		}
		/**
		 * 清除焦点效果 
		 * 
		 */		
		public static function clearFocus():void
		{
			if(preFocusItem&&preFocusItem.filters.length>0)
			{
				preFocusItem.filters=null;
			}
			if(textBack&&textBack.parent)
			{
				textBack.parent.removeChild(textBack);
			}
			preFocusItem=null;
		}
		/**
		 * 清除前一个焦点对象的记录 
		 * 
		 */		
		public static function clearPre():void
		{
			preFocusItem=null;
		}
		/**
		 * 设置面板可以进行Mouseover焦点管理 
		 * @param disp 要设置的面板
		 * 
		 */		
		public static function setFocusManagerAble(disp:DisplayObject):void
		{
			disp.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false);
			disp.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler,false,0,true);
			disp.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler,false);
			disp.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler,false,0,true);
		}
		/**
		 * 设置可以响应Mouseover焦点管理的对象 
		 * @param disp 要设置可管理的对象
		 * @param setBack 是否要为对象添加背景框
		 * false 不添加
		 * true 添加
		 * 
		 */		
		public static function setFocusAbleItem(disp:*,setBack:Boolean=false):void
		{
			if(disp )
			{
				if(setBack)
				{
					disp.orz="setBack";
				}
				else
				{
					disp.orz="hello";
				}
				
			}
		}
		/**
		 * 设置选中状态 
		 * @param e
		 * 
		 */		
		private static function mouseOverHandler(e:MouseEvent):void
		{
			////trace("mouseOverHandler:"+e.target.name);		
			////trace("mouseOverHandler current:"+e.currentTarget.name);	
			var tTarget:DisplayObject=null;
			if(e.target.hasOwnProperty("orz")) tTarget=e.target as DisplayObject;
			if(e.target.parent == null) 
				return;
			if(e.target.parent)
				if(e.target.parent.hasOwnProperty("orz")) 
					tTarget=e.target.parent as DisplayObject;
			if(e.target.parent.parent&&e.target.parent.parent.hasOwnProperty("orz")) tTarget=e.target.parent.parent as DisplayObject;
			if(tTarget)
			{
				var tname:String=tTarget.name;	
				////trace(tname+":over");	
				if(tTarget["orz"]=="setBack")
				{
					FocusManagerW.setFocus(tTarget,true);
				}
				else
				{
					FocusManagerW.setFocus(tTarget);
				}

				
				return;
			}
		}
		/**
		 * 去除选中状态 
		 * @param e
		 * 
		 */		
		private static function mouseOutHandler(e:MouseEvent):void
		{
			////trace("mouseOutHandler:"+e.target.name);	
			if(e.target.parent.hasOwnProperty("orz")) return;
			if(e.target.parent.parent&&e.target.parent.parent.hasOwnProperty("orz")) return;
			if(e.target.hasOwnProperty("orz")||e.target.parent.hasOwnProperty("orz"))
			{
				FocusManagerW.clearFocus();
				return;
				
			}
		}
		


		/**
		 * 设置按钮组的单选中 
		 * @param tname
		 * @param List
		 * @return 
		 * 
		 */
		public static function setSelectItemById(tid:int,List:Array):void
		{
			var i:int;
			var mc:MovieClip;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(i==tid)
				{
					mc.select(true);	
				}else
				{
					mc.select(false);	
				}					
			}			
			//			return tid;			
		}

		/**
		 * 设置按钮组的单选中 
		 * @param tname
		 * @param List
		 * @return 
		 * 
		 */
		public static function setFocusById(tid:int,List:Array,filter:GlowFilter=null):void
		{
			var i:int;
			var mc:MovieClip;
			if(!filter) filter=focusFilter;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(i==tid)
				{
					mc.filters = [filter];	
				}else
				{
					if(mc.filters)
						mc.filters=null;	
				}					
			}			
			//			return tid;			
		}
		/**
		 * 设置显示对象单选选中
		 * @param tname 对象名字
		 * @param List 对象所在的组
		 * @return 对象ID
		 * 
		 */		
		public static function setFocusByName(tname:String,List:Array):int
		{
			var i:int;
			var mc:DisplayObject;
			var tid:int;
			tid=-1;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(mc.name==tname)
				{
					setSelect(mc,true);	
				}else
				{
					setSelect(mc,false);
				}					
			}			
			return tid;			
		}
		
		/**
		 * 设置按钮组的单选中 
		 * @param tname
		 * @param List
		 * @return 
		 * 
		 */
		public static function setSelectByName(tname:String,List:Array):int
		{
			var i:int;
			var mc:DisplayObject;
			var tid:int;
			tid=-1;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(mc.name==tname)
				{
//					mc.gotoAndStop(2);	
					setSelect(mc,true);
					tid=i;
				}else
				{
//					mc.gotoAndStop(1);
					setSelect(mc,false);
				}					
			}			
			return tid;			
		}
		
		/**
		 * 设置按钮组的单选中 
		 * @param tname
		 * @param List
		 * @return 
		 * 
		 */
		public static function setSelectById(tid:int,List:Array):*
		{
			var i:int;
			var mc:*;
			var tMC:*;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(i==tid)
				{
//					mc.gotoAndStop(2);	
					setSelect(mc,true);
					tMC=mc;
				}else
				{
//					mc.gotoAndStop(1);
					setSelect(mc,false);
				}					
			}			
    		return tMC;			
		}
		
		/**
		 * 设置按钮组的单选中 
		 * @param tname
		 * @param List
		 * @return 
		 * 
		 */
		public static function setSelectByItem(tItem:*,List:Array):int
		{
			var i:int;
			var mc:*;
			var tid:int;
			tid=-1;
			for(i=List.length-1;i>=0;i--)
			{
				mc=List[i]
				if(mc==tItem)
				{
//					mc.gotoAndStop(2);	
					setSelect(mc,true);
					tid=i;
				}else
				{
//					mc.gotoAndStop(1);
					setSelect(mc,false);
				}					
			}			
			return tid;	
		}

		/**
		 * 设置对象的选中状态 
		 * @param item
		 * @param select
		 * 
		 */
		public static function setSelect(item:*,select:Boolean):void
		{
			var tMC:MovieClip;
			tMC=item as MovieClip;
			if(tMC&&tMC.totalFrames>1)
			{
				if(select)
				{
					tMC.gotoAndStop(tMC.totalFrames);
				}else
				{
					tMC.gotoAndStop(1);
				}
				return;
			}
			
			var tDis:DisplayObject;
			tDis=item as DisplayObject;
			if(tDis)
			{
				if(select)
				{
					tDis.filters=[focusFilter];
				}else
				{
					tDis.filters=null;
				}
				return;
			}
			
		}
	}
}