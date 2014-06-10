package
{
	import com.tg.StageUtil;
	import com.tg.Tools.DebugToolScreen;
	import com.tg.Tools.DisplayUtil;
	import com.tg.Tools.DomainTools;
	import com.tg.Tools.ScriptAdapter;
	import com.tg.Tools.StringToolsLib;
	import com.tg.Trigger;
	import com.tools.ClassTools;
	import com.tools.DebugTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.Security;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import parser.Script;
	
	/**
	 * 
	 * @author ww
	 * 
	 * this class is inspired by jpauclair's work 
	 * you can find his blog here :
	 * http://jpauclair.net/2010/02/17/one-swf-to-rule-them-all-the-almighty-preloadswf/
	 * 
	 * 
	 */
	public class MyPreloader extends Sprite
	{
		public function MyPreloader()
		{
			ScriptAdapter.exeCmdsFun=Script.execute;
			ScriptAdapter.initFun=Script.init;
			Security.allowDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		/**
		 * 是否已经初始化
		 */
		private var mInitialized:Boolean = false;
		/**
		 * 要注入的类名
		 */
		private var mHookClass:String="";
		/**
		 * 自己的类名
		 */
		private var myClassName:String="";
		private function init(event:Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.init);

			this.InitHandlers(this.root);
			
			myClassName=getQualifiedClassName(this);
			return;
		}// end function
		public function InitHandlers(aRoot:DisplayObject) : void
		{
			trace("PreLoader : Indirect profilier launch (waiting for main SWF to load)");
			aRoot.addEventListener("allComplete", this.allCompleteHandler);
			aRoot.addEventListener("allComplete", this.SWFReferecesHandler);
			return;
		}
		
		private var loaderInfoDic:Dictionary=new Dictionary();
		private var domainDic:Dictionary=new Dictionary();
		private function dealLoaderLoader(loaderInfo:LoaderInfo):void
		{
			
			DomainTools.me.addNewLoaderInfo(loaderInfo);
			return;
//			if(!loaderInfo) return;
//			if(!loaderInfo.url) return;
//			var turl:String;
//			turl=StringToolsLib.getPreValue(loaderInfo.url,"?");
//			if(loaderInfoDic[turl]) return;
//			loaderInfoDic[turl]=loaderInfo;
//			trace("===================================================");
//			trace("PreLoader : File loaded:", loaderInfo.url, "Class:", getQualifiedClassName(loaderInfo.content));
//			
//			
//			trace("loader defines:\n"+ClassTools.getLoaderDefines(loaderInfo));
//			trace("===================================================");
//			
//			if(!domainDic[loaderInfo.applicationDomain])
//			{
//				domainDic[loaderInfo.applicationDomain]=turl;
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//				trace("new domain Added");
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//			}else
//			{
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//				trace("oldDomain");
//				trace("ooooooooooooooooooooooooooooooooooooooooo");
//			}

		}
		private function allCompleteHandler(event:Event) : void
		{
			var loaderInfo:LoaderInfo;
			try
			{
				loaderInfo = LoaderInfo(event.target);

				dealLoaderLoader(loaderInfo);
				
				//如果已经初始化则不再创建调试窗口
				if (this.mInitialized)
				{
					return;
				}
				
				if (loaderInfo.content.root.stage == null)//当前加载的对象不在显示列表，不创建调试窗口
				{
					trace("PreLoader : File loaded but no stage:", loaderInfo.url);
					return;
				}
				else
				{
					trace("root.stage defines defines:");
					ClassTools.getDefines(loaderInfo.content.root.stage);
					if(myClassName==getQualifiedClassName(loaderInfo.content))
					{
						trace("是自己 退出");
						return;
					}
					if (this.mHookClass != "")
					{
						
						if (this.mHookClass != getQualifiedClassName(loaderInfo.content))
						{
							trace("PreLoader : File loaded with stage but wrong class:", loaderInfo.url, getQualifiedClassName(loaderInfo.content));
							return;
						}
						else
						{
							trace("PreLoader : File loaded with stage:", loaderInfo.url, "Class:", getQualifiedClassName(loaderInfo.content));
						}
					}
				}
				this.SetRoot(loaderInfo.content.root as Sprite);
			}
			catch (e:Error)
			{
				trace("PreLoader : ", e);
				DebugTools.debugTrace(e.message+""+e.getStackTrace(),"error");
			}
			return;
		}// end function
		private function SWFReferecesHandler(event:Event) : void
		{
			var loaderInfo:LoaderInfo;
			try
			{
				loaderInfo = LoaderInfo(event.target);
				
				
//				DebugTools.debugTrace("PreLoader : File loaded:"+loaderInfo.url+ "Class:"+getQualifiedClassName(loaderInfo.content)+"\n"+ClassTools.getDefines(loaderInfo.content.root.stage),"defines");
				
			}
			catch (e:Error)
			{
				trace("PreLoader : ", e);
				DebugTools.debugTrace(e.message+e.getStackTrace(),"error");
			}
			return;
		}// end function
		
		public var MainSprite:Sprite;
		private function SetRoot(aSprite:Sprite) : void
		{

			if(mInitialized) return;
			try
			{
				trace("The PreLoader: SetRoot");
				this.mInitialized = true;
				this.MainSprite = aSprite;
				
				DomainTools.me.addDomain(aSprite.stage.loaderInfo.applicationDomain);

//				StageUtil.regist(aSprite.stage);
				StageUtil.regist(aSprite.stage);
				Trigger.init(aSprite.stage);
				DebugToolScreen.me.container=MainSprite.stage;
				DebugToolScreen.isShow=true;
//				StageUtil.setDisTop(DebugToolScreen.me.back);
//				StageUtil.setDisLeft(DebugToolScreen.me.back);
				DebugTools.debugTrace("setRoot","PreLoader");
				Trigger.addSecondTrigger(update);
				
			}
			catch (e:Error)
			{
				trace("PreLoader : ", e);
			}
//			throw new Error("SetRoot");
			return;
		}// end function
		/**
		 * 将调试窗口放到最前端 
		 * 
		 */		
		private function update():void
		{
//			throw new Error("update");
			DebugToolScreen.isShow=true;
			DisplayUtil.setTop(DebugToolScreen.me.back);
			

		}
		
		//
		//以下这些设置可以减少被主flash影响的概率
		//
		override public function get name() : String
		{
			return "root3";
		}// end function
		
		override public function get parent() : DisplayObjectContainer
		{
			return null;
		}// end function
		
		override public function getChildAt(index:int) : DisplayObject
		{
			return null;
		}// end function
		
		override public function get numChildren() : int
		{
			return 0;
		}// end function
		
		override public function getObjectsUnderPoint(point:Point) : Array
		{
			return null;
		}// end function

	}
}