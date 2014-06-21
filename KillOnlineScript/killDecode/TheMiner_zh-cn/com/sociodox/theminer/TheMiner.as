package com.sociodox.theminer
{
    import com.demonsters.debugger.*;
    import com.junkbyte.console.*;
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.event.*;
    import com.sociodox.theminer.manager.*;
    import com.sociodox.theminer.window.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.sampler.*;
    import flash.system.*;
    import flash.text.*;
    import flash.trace.*;
    import flash.ui.*;
    import flash.utils.*;

    public class TheMiner extends Sprite
    {
        public var mIsPreloadSWFLaunched:Boolean;
        private var MainSprite:Sprite = null;
        private var mInitialized:Boolean = false;
        private var mHookClass:String = "";
        private var mTraceFiles:Boolean = false;
        private var _frames:int = 0;
        private var _startTime:int = 0;
        private var mLastMemoryVal:int = 0;
        private var mAddChildFrameCounter:int = 0;
        private var MAX__ONTOP_ATTEMPS:int = 20;
        private var mSWFList:Array;
        private var mSWFListOutput:FileReference;
        private var mSavingIndex:int = 0;
        private var mKeepOnTopTimer:Timer;
        private var mNextTool:Class = null;
        private var mMinimize:Boolean = false;
        private var ms_prev:int;
        private var mCurrentTool:Class = null;
        private var mCurrentWindow:IWindow;
        public static var mInstance:TheMiner;
        private static var mUsrEventMgr:UserEventManager = new UserEventManager();

        public function TheMiner() : void
        {
            this.mSWFList = new Array();
            this.mSWFListOutput = new FileReference();
            mInstance = this;
            trace("TheMiner : Starting TheMiner " + "1.4.01");
            SampleAnalyzer.Init(this);
            addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            var p:Stage;
            var so:*;
            var o:*;
            var myformat:TextFormat;
            var myglow:GlowFilter;
            var needDebugPlayer:TextField;
            var sprite:Sprite;
            try
            {
                so = SharedObject.getLocal("TheMinerConfig", this.loaderInfo.loaderURL);
                Configuration.mSaveObj = so;
                trace("TheMiner : valid object", Configuration.mSaveObj.data);
                var _loc_3:int = 0;
                var _loc_4:* = Configuration.mSaveObj.data;
                while (_loc_4 in _loc_3)
                {
                    
                    o = _loc_4[_loc_3];
                    trace("TheMiner : ", o, Configuration.mSaveObj.data[o]);
                }
            }
            catch (e:Error)
            {
            }
            Configuration.Load();
            p = this.stage as Stage;
            this.InitHandlers(this.root);
            setSamplerCallback(function (event:Event) : void
            {
                SampleAnalyzer.ProcessSampling();
                return;
            }// end function
            );
            if (!Capabilities.isDebugger)
            {
                myformat = new TextFormat("_sans", 11, 4294967295, false);
                myglow = new GlowFilter(3355443, 1, 2, 2, 3, 2, false, false);
                needDebugPlayer = new TextField();
                needDebugPlayer.x = 5;
                needDebugPlayer.y = 5;
                needDebugPlayer.autoSize = TextFieldAutoSize.LEFT;
                needDebugPlayer.defaultTextFormat = myformat;
                needDebugPlayer.selectable = false;
                needDebugPlayer.filters = [myglow];
                needDebugPlayer.mouseEnabled = false;
                needDebugPlayer.text = Localization.Lbl_TheMinerNeedFlashPlayerDebug;
                p.addChild(needDebugPlayer);
                return;
            }
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            SkinManager.LoadColors();
            this.mouseEnabled = false;
            Cc.start(null);
            Cc.logch("TM", "TheMiner " + "1.4.01");
            Cc.instance.commandLine = true;
            Cc.config.alwaysOnTop = false;
            Cc.config.sharedObjectName = null;
            Cc.config.sharedObjectPath = null;
			 OptionInterface = new Options();
            OptionInterface.Init();
            addChild(OptionInterface);
            Commands.RefreshRate = Configuration.FRAME_UPDATE_SPEED;
            Commands.Opacity = Configuration.INTERFACE_OPACITY;
            if (Configuration.START_MINIMIZED)
            {
                OptionInterface.mFoldButton.OnClick(null);
            }
            if (!this.mIsPreloadSWFLaunched)
            {
                trace("TheMiner : Direct (embeded) profiler launch");
                sprite = new Sprite();
                this.SetRoot(this);
                clearSamples();
                SampleAnalyzer.ResetMemoryStats();
                SampleAnalyzer.ResetPerformanceStats();
            }
            if (this.loaderInfo.parameters["HookClass"] != undefined)
            {
                this.mHookClass = this.loaderInfo.parameters["HookClass"];
                trace("TheMiner : Trying to hook to class:", this.mHookClass);
            }
            if (this.loaderInfo.parameters["TraceFiles"] != undefined)
            {
                if (this.loaderInfo.parameters["TraceFiles"] == "true")
                {
                    this.mTraceFiles = true;
                }
                trace("TheMiner : Tracing files loaded...");
            }
            if (this.loaderInfo.parameters["MonsterDebugger"] != undefined)
            {
                if (this.loaderInfo.parameters["MonsterDebugger"] == "true")
                {
                    MonsterDebugger.initialize(this.stage, "127.0.0.1", this.OnConnectMonster);
                }
                trace("TheMiner : Monster debugger enabled");
            }
            return;
        }// end function

        private function allCompleteHandler(event:Event) : void
        {
            var loaderInfo:LoaderInfo;
            try
            {
                loaderInfo = LoaderInfo(event.target);
                if (this.mTraceFiles)
                {
                    trace("TheMiner : File loaded:", loaderInfo.url, "Class:", getQualifiedClassName(loaderInfo.content));
                }
                if (this.mInitialized)
                {
                    return;
                }
                if (loaderInfo.content.root.stage == null)
                {
                    trace("TheMiner : File loaded but no stage:", loaderInfo.url);
                    return;
                }
                else
                {
                    if (this.mHookClass != "")
                    {
                    }
                    if (this.mHookClass != getQualifiedClassName(loaderInfo.content))
                    {
                        trace("TheMiner : File loaded with stage but wrong class:", loaderInfo.url, getQualifiedClassName(loaderInfo.content));
                        return;
                    }
                    else
                    {
                        trace("TheMiner : File loaded with stage:", loaderInfo.url, "Class:", getQualifiedClassName(loaderInfo.content));
                    }
                }
                this.SetRoot(loaderInfo.content.root as Sprite);
            }
            catch (e:Error)
            {
                trace("TheMiner : ", e);
            }
            return;
        }// end function

        private function Dispose() : void
        {
            OptionInterface.ResetMenu(null);
            this.ClearTools();
            stopSampling();
            clearSamples();
            try
            {
                Stage2D.removeEventListener("DebuggerDisconnected", OptionInterface.OnDebuggerDisconnect);
            }
            catch (e:Error)
            {

               
            }
			try
			{
				Stage2D.removeEventListener("DebuggerConnected", OptionInterface.OnDebuggerConnect);
			}
            catch (e:Error)
            {

                
            }
			try
			{
				this.mSWFListOutput.removeEventListener(Event.COMPLETE, this.OnSaveComplete);
			}
            catch (e:Error)
            {

                
            }
			try
			{
				root.removeEventListener("allComplete", this.allCompleteHandler);
			}
            catch (e:Error)
            {

                
            }
			try
			{
				root.removeEventListener("allComplete", this.SWFReferecesHandler);
			}
            catch (e:Error)
            {

                
            }
			try
			{
				this.removeEventListener(Event.ENTER_FRAME, this.OnEnterFrame);
			}
            catch (e:Error)
            {
            }
            OptionInterface.Dispose();
            removeChild(OptionInterface);
            try
            {
                this.parent.removeChild(this);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function OnEnterFrame(event:Event) : void
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (Stage2D == null)
            {
                return;
            }
            if (Commands.IsRecordingTraces)
            {
                Trace.setLevel(Trace.OFF, Trace.LISTENER);
                Trace.setListener(null);
            }
            var _loc_2:Boolean = false;
            if (!Configuration._PROFILE_MEMORY)
            {
            }
            if (!Configuration._PROFILE_FUNCTION)
            {
            }
            if (!Configuration._PROFILE_LOADERS)
            {
            }
            if (!Configuration._PROFILE_INTERNAL_EVENTS)
            {
            }
            if (Configuration.COMMAND_LINE_SAMPLING_LSTENER)
            {
                _loc_2 = true;
            }
            else if (Commands.mIsCollectingSamplesData)
            {
                _loc_2 = true;
            }
            if (_loc_2)
            {
                pauseSampling();
            }
            Mouse.show();
            if (Stage2D != null)
            {
            }
            if (this.MAX__ONTOP_ATTEMPS > 0)
            {
                var _loc_7:String = this;
                _loc_7.mAddChildFrameCounter = this.mAddChildFrameCounter + 1;
            }
            if (this.mAddChildFrameCounter++ > 30)
            {
                var _loc_7:String = this;
                var _loc_8:* = this.MAX__ONTOP_ATTEMPS - 1;
                _loc_7.MAX__ONTOP_ATTEMPS = _loc_8;
                this.mAddChildFrameCounter = 0;
                Stage2D.addChildAt(this, (Stage2D.numChildren - 1));
            }
            var _loc_7:String = this;
            var _loc_8:* = this._frames + 1;
            _loc_7._frames = _loc_8;
            var _loc_3:* = getTimer();
            var _loc_4:* = _loc_3 - this._startTime;
            if (_loc_4 >= 1000 / Commands.RefreshRate)
            {
                OptionInterface.mFps = Math.round(this._frames * (1000 / _loc_4));
                this._frames = 0;
                this._startTime = _loc_3;
            }
            if (_loc_2)
            {
                SampleAnalyzer.ProcessSampling();
            }
            LoaderAnalyser.GetInstance().Update();
            if (Configuration.PROFILE_MEMGRAPH)
            {
                _loc_5 = getTimer();
                if (_loc_5 >= this.ms_prev + 300)
                {
                    _loc_6 = System.totalMemory;
                    var _loc_7:* = FlashStats;
                    var _loc_8:* = FlashStats.mSamplingStartIdx - 1;
                    _loc_7.mSamplingStartIdx = _loc_8;
                    if (FlashStats.mSamplingStartIdx < 0)
                    {
                        FlashStats.mSamplingStartIdx = FlashStats.mSamplingCount - 1;
                    }
                    this.ms_prev = _loc_5;
                    if (_loc_6 < this.mLastMemoryVal)
                    {
                        FlashStats.mMemoryGC[FlashStats.mSamplingStartIdx % FlashStats.mSamplingCount] = (this.mLastMemoryVal - _loc_6) / 1000;
                    }
                    FlashStats.mMemoryValues[FlashStats.mSamplingStartIdx % FlashStats.mSamplingCount] = _loc_6 / 1024;
                    if (_loc_6 / 1024 > FlashStats.stats.MemoryMax)
                    {
                        FlashStats.stats.MemoryMax = _loc_6 / 1024;
                    }
                    FlashStats.mMemoryMaxValues[FlashStats.mSamplingStartIdx % FlashStats.mSamplingCount] = FlashStats.stats.MemoryMax;
                    this.mLastMemoryVal = _loc_6;
                }
            }
            if (this.mCurrentWindow)
            {
                this.mCurrentWindow.Update();
            }
            if (OptionInterface != null)
            {
                OptionInterface.Update();
            }
            if (OptionInterface.mQuitButton.mIsSelected)
            {
                Analytics.Track("Process", "Quit", "Quit");
                this.Dispose();
                return;
            }
            if (this.mMinimize)
            {
                Analytics.Track("Process", "Minimize");
                OptionInterface.ResetMenu(null);
                this.ClearTools();
                this.mMinimize = false;
            }
            if (this.mNextTool != null)
            {
                this.ChangeTool(this.mNextTool);
                this.mNextTool = null;
            }
            if (_loc_2)
            {
                startSampling();
                clearSamples();
            }
            if (Commands.mIsCollectingTracesData)
            {
                Trace.setLevel(Trace.METHODS_AND_LINES_WITH_ARGS, Trace.LISTENER);
                Trace.setListener(Commands.OnTraceReceive);
            }
            return;
        }// end function

        public function InitHandlers(aRoot:DisplayObject) : void
        {
            trace("TheMiner : Indirect profilier launch (waiting for main SWF to load)");
            aRoot.addEventListener("allComplete", this.allCompleteHandler);
            aRoot.addEventListener("allComplete", this.SWFReferecesHandler);
            return;
        }// end function

        private function OnConnectMonster() : void
        {
            Analytics.Track("Process", "ConnectMD", "MonsterDebugger");
            return;
        }// end function

        private function SWFReferecesHandler(event:Event) : void
        {
            var _loc_3:LoaderInfo = null;
            var _loc_2:* = Configuration.IsSamplingRequired();
            pauseSampling();
            _loc_3 = LoaderInfo(event.target);
            var _loc_4:* = this.mSWFList.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                if (_loc_3 == this.mSWFList[_loc_5].mLoaderInfo)
                {
                    if (_loc_2)
                    {
                        startSampling();
                    }
                    return;
                }
                _loc_5 = _loc_5 + 1;
            }
            var _loc_6:* = new SWFEntry();
            _loc_6.mBytes = _loc_3.bytes;
            _loc_6.mUrl = _loc_3.url;
            _loc_6.mFromURL = _loc_3.loaderURL;
            _loc_6.mLoaderInfo = _loc_3;
            this.mSWFList.push(_loc_6);
            if (_loc_3.content is Sprite)
            {
                LoaderAnalyser.GetInstance().PushLoader(_loc_6);
            }
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function SaveSWFReferecesHandler() : void
        {
            var _loc_1:SWFEntry = null;
            if (this.mSavingIndex >= this.mSWFList.length)
            {
                return;
            }
            _loc_1 = this.mSWFList[this.mSavingIndex];
            this.mSWFListOutput.addEventListener(Event.COMPLETE, this.OnSaveComplete);
            this.mSWFListOutput.save(_loc_1.mBytes, this.mSavingIndex.toString() + ".swf");
            trace("SavingIndex", this.mSavingIndex, new Error().getStackTrace());
            var _loc_2:String = this;
            var _loc_3:* = this.mSavingIndex + 1;
            _loc_2.mSavingIndex = _loc_3;
            return;
        }// end function

        private function OnSaveComplete(event:Event) : void
        {
            this.SaveSWFReferecesHandler();
            return;
        }// end function

        private function SetRoot(aSprite:Sprite) : void
        {
            var buildType:String;
            var contract:String;
            var aSprite:* = aSprite;
            this._startTime = getTimer();
            try
            {
                trace("The Miner: SetRoot");
                this.MainSprite = aSprite;
				Stage2D = this.MainSprite.stage;
                Analytics.Init();
                this.root.loaderInfo.sharedEvents.addEventListener(UserEventEntry.USER_EVENT, mUsrEventMgr.OnSharedEvent, false, 0, true);
                buildType;
                if (this.mIsPreloadSWFLaunched)
                {
                    buildType;
                }
                else
                {
                    buildType;
                }
                contract;
                Analytics.Track("Process", "Launch", "Launch/" + contract + "/" + buildType + "/" + "1.4.01" + "/" + Localization.LangCode);
                Analytics.Report("/Launch");
                this.addEventListener(Event.ENTER_FRAME, this.OnEnterFrame);
                Commands.Init(Stage2D);
                Stage2D.addChild(this);
                this.TraceLocalParameters(Stage2D.loaderInfo);
                if (Configuration.PROFILE_MONSTER)
                {
                    Stage2D.addEventListener("DebuggerDisconnected", OptionInterface.OnDebuggerDisconnect);
                    Stage2D.addEventListener("DebuggerConnected", OptionInterface.OnDebuggerConnect);
                    MonsterDebugger.initialize(Stage2D, "127.0.0.1", this.OnConnectMonster);
                    MonsterDebugger.trace(Stage2D, "Connected from TheMiner!");
                }
                else
                {
                    OptionInterface.SetMonsterDisabled();
                }
                this.mInitialized = true;
                clearSamples();
            }
            catch (e:Error)
            {
                trace("TheMiner : ", e);
            }
            return;
        }// end function

        private function AsynchChangeTool(aTool:Class) : void
        {
            if (aTool == null)
            {
                this.mMinimize = true;
                return;
            }
            this.mMinimize = false;
            this.mNextTool = aTool;
            return;
        }// end function

        private function OnChangeTool(event:ChangeToolEvent) : void
        {
            this.ChangeTool(event.mTool);
            return;
        }// end function

        private function TraceLocalParameters(loaderInfo:LoaderInfo) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            Cc.debugch("TM", "Tracing Flash vars...");
            for (_loc_4 in loaderInfo.parameters)
            {
                
                Cc.logch("FlashVar", "FlashVar: " + _loc_4 + " = " + loaderInfo.parameters[_loc_4]);
            }
            return;
        }// end function

        private function ShowBar(event:ContextMenuEvent) : void
        {
            this.visible = !this.visible;
            return;
        }// end function

        public function ClearTools() : void
        {
            if (this.mCurrentWindow != null)
            {
                this.mCurrentWindow.Dispose();
                if (this.mCurrentWindow != null)
                {
                    this.mCurrentWindow.Unlink();
                }
                this.mCurrentWindow = null;
            }
            while (this.numChildren > 0)
            {
                
                this.removeChildAt(0);
            }
            this.addChild(OptionInterface);
            return;
        }// end function

        private function ChangeTool(aClass:Class) : void
        {
            if (this.mCurrentTool == aClass)
            {
                this.ClearTools();
                this.mCurrentTool = null;
                return;
            }
            this.ClearTools();
            this.mCurrentTool = aClass;
            this.mCurrentWindow = new aClass as IWindow;
            if (this.mCurrentWindow != null)
            {
                this.mCurrentWindow.Link(this, 0);
            }
            if (this.mCurrentWindow is UserEvent)
            {
                (this.mCurrentWindow as UserEvent).SetManager(mUsrEventMgr);
            }
            return;
        }// end function

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

        public static function Do(aActionEnum:int = -1)
        {
            switch(aActionEnum)
            {
                case -1:
                {
                    mInstance.AsynchChangeTool(null);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_CONFIGURATION:
                {
                    mInstance.AsynchChangeTool(Configuration);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_DISPLAYOBJECT_LIFECYCLE:
                {
                    mInstance.AsynchChangeTool(InstancesLifeCycle);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_FLASH_RUNTIME_STATISTICS:
                {
                    mInstance.AsynchChangeTool(FlashStats);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_FUNCTION_PERFORMANCES:
                {
                    mInstance.AsynchChangeTool(PerformanceProfiler);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_INTERNAL_EVENTS:
                {
                    mInstance.AsynchChangeTool(InternalEventsProfiler);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_LOADERS_PROFILER:
                {
                    mInstance.AsynchChangeTool(LoaderProfiler);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_USER_EVENTS:
                {
                    mInstance.AsynchChangeTool(UserEvent);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_MEMORY_PROFILER:
                {
                    mInstance.AsynchChangeTool(SamplerProfiler);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_MOUSE_LISTENERS:
                {
                    mInstance.AsynchChangeTool(MouseListeners);
                    break;
                }
                case TheMinerActionEnum.TOGGLE_INTERFACE_OVERDRAW:
                {
                    mInstance.AsynchChangeTool(Overdraw);
                    break;
                }
                case TheMinerActionEnum.CLOSE_PROFILERS:
                {
                    mInstance.ClearTools();
                    mInstance.mCurrentTool = null;
                    break;
                }
                case TheMinerActionEnum.TOGGLE_MINIMIZE:
                {
                    mInstance.AsynchChangeTool(null);
                    OptionInterface.ToggleMinimize();
                    break;
                }
                case TheMinerActionEnum.HIDE:
                {
                    mInstance.visible = false;
                    break;
                }
                case TheMinerActionEnum.SHOW:
                {
                    mInstance.visible = true;
                    break;
                }
                case TheMinerActionEnum.QUIT:
                {
                    mInstance.Dispose();
                    break;
                }
                case TheMinerActionEnum.LISTEN_SAMPLES_START:
                {
                    Configuration.COMMAND_LINE_SAMPLING_LSTENER = true;
                    break;
                }
                case TheMinerActionEnum.LISTEN_SAMPLES_STOP:
                {
                    Configuration.COMMAND_LINE_SAMPLING_LSTENER = false;
                    break;
                }
                case TheMinerActionEnum.LISTEN_SAMPLES_RESET:
                {
                    SampleAnalyzer.ResetMemoryStats();
                    SampleAnalyzer.ResetPerformanceStats();
                    break;
                }
                case TheMinerActionEnum.TAKE_MEMORY_SNAPSHOT:
                {
                    return Commands.SaveMemorySnapshot();
                }
                case TheMinerActionEnum.TAKE_PERFORMANCE_SNAPSHOT:
                {
                    return Commands.SavePerformanceSnapshot();
                }
                case TheMinerActionEnum.FORCE_GC:
                {
                    try
                    {
                        System.gc();
                    }
                    catch (e:Error)
                    {
                        try
                        {
							new LocalConnection().connect("Force GC!");
							new LocalConnection().connect("Force GC!");
                        }    catch (e:Error)
						{
						}

                    }

                    break;
                }
                case TheMinerActionEnum.DUMP_SAMPLES_START:
                {
                    Commands.StartRecordingSamples();
                    break;
                }
                case TheMinerActionEnum.DUMP_SAMPLES_STOP:
                {
                    return Commands.StopRecordingSamples(false);
                }
                case TheMinerActionEnum.DUMP_TRACES_START:
                {
                    Commands.StartRecordingTraces();
                    break;
                }
                case TheMinerActionEnum.DUMP_TRACES_STOP:
                {
                    return Commands.StopRecordingTraces(false);
                }
                case TheMinerActionEnum.TAKE_SCREEN_CAPTURE:
                {
                    Commands.SaveSnapshot();
                    return;
                }
                default:
                {
                    if (aActionEnum == TheMinerActionEnum.TOGGLE_INTERFACE_CONSOLE)
                    {
                        mInstance.AsynchChangeTool(ConsoleContainer);
                    }
                    break;
                    break;
                }
            }
            return;
        }// end function

    }
}
