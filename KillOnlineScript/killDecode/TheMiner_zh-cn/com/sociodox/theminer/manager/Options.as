package com.sociodox.theminer.manager
{
    import com.sociodox.theminer.*;
    import com.sociodox.theminer.event.*;
    import com.sociodox.theminer.ui.*;
    import com.sociodox.theminer.ui.button.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Options extends Sprite
    {
        private var mAutoStatButton:Sprite;
        private var mShowOverdraw:Sprite;
        private var mShowInstanciator:Sprite;
        private var mShowProfiler:Sprite;
        private var mShowInternalEvents:Sprite;
        private var mShowConfig:Sprite;
        private var mMinimizeButton:MenuButton;
        public var mFoldButton:MenuButton;
        private var mMouseListenerButton:MenuButton;
        private var mStatsButton:MenuButton;
        private var mOverdrawButton:MenuButton;
        private var mInstanciationButton:MenuButton;
        private var mMemoryProfilerButton:MenuButton;
        private var mInternalEventButton:MenuButton;
        private var mFunctionTimeButton:MenuButton;
        private var mLoaderProfilerButton:MenuButton;
        private var mUserEventButton:MenuButton;
        private var mConfigButton:MenuButton;
        public var mQuitButton:MenuButton;
        private var mSaveDiskButton:MenuButton;
        private var mSaveTraceButton:MenuButton;
        private var mGCButton:MenuButton;
        private var mMonsterHideBar:Sprite;
        private var debuggerIcon:DisplayObject = null;
        private var mLastSelected:Sprite = null;
        private var mToolTip:ToolTip;
        private var mButtonDict:Dictionary;
        private var mLastFps:int = 0;
        private var mLastMem:int = 0;
        private var mFPSTextField:TextField;
        private var mMemTextField:TextField;
        private var mFPSValueTextField:TextField;
        private var mMemValueTextField:TextField;
        public var mFps:int = 0;
        private var mFoldButtonWasSelected:Boolean = false;
        private var barWidth:int = 400;
        private var myformat:TextFormat = null;
        private var myformatRight:TextFormat = null;
        private var myglow:GlowFilter = null;
        private var mTextDisplayX:int = 0;
        private var mIsHidden:Boolean = false;
        private var mConsoleButton:MenuButton;
        private var mScreenCapture:MenuButton;
        private var mMonsterStatus:int = 1;
        public static const SAVE_SWF_EVENT:String = "SaveSWFEvent";
        public static const SAVE_RECORDING_EVENT:String = "SaveRecordingEvent";
        public static const SAVE_RECORDING_TRACE_EVENT:String = "SaveRecordingTraceEvent";
        public static const TOGGLE_MINIMIZE:String = "ToggleMinimizeEvent";
        public static const TOGGLE_QUIT:String = "ToggleQuitEvent";
        public static const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
        public static const SCREEN_CAPTURE_EVENT:String = "screenCaptureEvent";

        public function Options()
        {
            this.mMonsterHideBar = new Sprite();
            this.mButtonDict = new Dictionary(true);
            return;
        }// end function

        public function Init() : void
        {
            if (Stage2D)
            {
                this.OnAddedToStage();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.OnAddedToStage);
            }
            return;
        }// end function

        private function OnAddedToStage(event:Event = null) : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_6:String = null;
            if (event != null)
            {
            }
            if (event.target == this)
            {
                removeEventListener(Event.ADDED_TO_STAGE, this.OnAddedToStage);
            }
            else
            {
                return;
            }
            this.myformat = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            this.myformatRight = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false, null, null, null, null, TextFormatAlign.RIGHT);
            this.myglow = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.UpdateSkin();
            this.mToolTip = new ToolTip();
            var _loc_2:int = 2;
            var _loc_3:int = 16;
            _loc_4 = 2;
            if (Capabilities.isDebugger)
            {
                this.mFoldButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_MINIMIZE, TOGGLE_MINIMIZE, -1, Localization.Lbl_Minimize, true);
                addChild(this.mFoldButton);
                _loc_2 = _loc_2 + 16;
                this.mStatsButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_STATS, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_FLASH_RUNTIME_STATISTICS, Localization.Lbl_RuntimeStatistics);
                addChild(this.mStatsButton);
                this.mButtonDict[this.mStatsButton] = this.mStatsButton;
                this.mQuitButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_CLEAR, TOGGLE_QUIT, -1, Localization.Lbl_Quit);
                addChild(this.mQuitButton);
                this.mButtonDict[this.mQuitButton] = this.mQuitButton;
                this.mQuitButton.visible = false;
                _loc_2 = _loc_2 + 16;
                this.mMouseListenerButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_MOUSE, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_MOUSE_LISTENERS, Localization.Lbl_MouseListeners);
                addChild(this.mMouseListenerButton);
                this.mButtonDict[this.mMouseListenerButton] = this.mMouseListenerButton;
                _loc_2 = _loc_2 + 16;
                this.mOverdrawButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_OVERDRAW, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_OVERDRAW, Localization.Lbl_Overdraw);
                addChild(this.mOverdrawButton);
                this.mButtonDict[this.mOverdrawButton] = this.mOverdrawButton;
                _loc_2 = _loc_2 + 16;
                this.mInstanciationButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_LIFE_CYCLE, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_DISPLAYOBJECT_LIFECYCLE, Localization.Lbl_DisplayObjectsLifeCycle);
                addChild(this.mInstanciationButton);
                this.mButtonDict[this.mInstanciationButton] = this.mInstanciationButton;
                _loc_2 = _loc_2 + 16;
                if (Capabilities.isDebugger)
                {
                    this.mMemoryProfilerButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_MEMORY, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_MEMORY_PROFILER, Localization.Lbl_MemoryProfiler);
                    this.mButtonDict[this.mMemoryProfilerButton] = this.mMemoryProfilerButton;
                }
                else
                {
                    this.mMemoryProfilerButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_MEMORY, null, TheMinerActionEnum.TOGGLE_INTERFACE_MEMORY_PROFILER, Localization.Lbl_ThisFeatureRequireDebugPlayer);
                }
                addChild(this.mMemoryProfilerButton);
                _loc_2 = _loc_2 + 16;
                if (Capabilities.isDebugger)
                {
                    this.mInternalEventButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_EVENTS, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_INTERNAL_EVENTS, Localization.Lbl_InternalEventsProfiler);
                    this.mButtonDict[this.mInternalEventButton] = this.mInternalEventButton;
                }
                else
                {
                    this.mInternalEventButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_EVENTS, null, TheMinerActionEnum.TOGGLE_INTERFACE_INTERNAL_EVENTS, Localization.Lbl_ThisFeatureRequireDebugPlayer);
                }
                addChild(this.mInternalEventButton);
                _loc_2 = _loc_2 + 16;
                if (Capabilities.isDebugger)
                {
                    this.mFunctionTimeButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_PERFORMANCE, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_FUNCTION_PERFORMANCES, Localization.Lbl_PerformanceProfiler);
                    this.mButtonDict[this.mFunctionTimeButton] = this.mFunctionTimeButton;
                }
                else
                {
                    this.mFunctionTimeButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_PERFORMANCE, null, TheMinerActionEnum.TOGGLE_INTERFACE_FUNCTION_PERFORMANCES, Localization.Lbl_ThisFeatureRequireDebugPlayer);
                }
                addChild(this.mFunctionTimeButton);
                _loc_2 = _loc_2 + 16;
                if (Capabilities.isDebugger)
                {
                    this.mLoaderProfilerButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_LOADER, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_LOADERS_PROFILER, Localization.Lbl_LoadersProfiler);
                    this.mButtonDict[this.mLoaderProfilerButton] = this.mLoaderProfilerButton;
                }
                else
                {
                    this.mLoaderProfilerButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_LOADER, null, TheMinerActionEnum.TOGGLE_INTERFACE_LOADERS_PROFILER, Localization.Lbl_ThisFeatureRequireDebugPlayer);
                }
                addChild(this.mLoaderProfilerButton);
            }
            _loc_2 = _loc_2 + 16;
            this.mUserEventButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_LINK, null, 0, Localization.Lbl_RequirePro + "\n" + Localization.Lbl_UserEvents, true);
            this.mButtonDict[this.mUserEventButton] = this.mUserEventButton;
            addChild(this.mUserEventButton);
            _loc_2 = _loc_2 + 16;
            this.mConsoleButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_PROMPT, null, 0, Localization.Lbl_RequirePro + "\n" + Localization.Lbl_Console_Console, true);
            addChild(this.mConsoleButton);
            this.mButtonDict[this.mConsoleButton] = this.mConsoleButton;
            _loc_2 = _loc_2 + 16;
            this.mConfigButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_CONFIG, ChangeToolEvent.CHANGE_TOOL_EVENT, TheMinerActionEnum.TOGGLE_INTERFACE_CONFIGURATION, Localization.Lbl_Configs);
            addChild(this.mConfigButton);
            this.mButtonDict[this.mConfigButton] = this.mConfigButton;
            _loc_2 = _loc_2 + 16;
            this.mScreenCapture = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_CAMERA, SCREEN_CAPTURE_EVENT, -1, Localization.Lbl_ScreenCapture, true, Localization.Lbl_MFP_Saved);
            addChild(this.mScreenCapture);
            addEventListener(SCREEN_CAPTURE_EVENT, this.OnSaveSnapshot);
            this.mButtonDict[this.mScreenCapture] = this.mScreenCapture;
            _loc_2 = _loc_2 + 16;
            this.mGCButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_GC, null, -1, Localization.Lbl_ForceSyncGarbageCollector, true, Localization.Lbl_Done);
            addChild(this.mGCButton);
            _loc_2 = _loc_2 + 16;
            if (Capabilities.isDebugger)
            {
                _loc_5 = Localization.Lbl_SaveSamples;
                this.mSaveDiskButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_SAVEDISK, SAVE_RECORDING_EVENT, -1, Localization.Lbl_StartRecordingSamples, true, _loc_5);
                addChild(this.mSaveDiskButton);
                addEventListener(SAVE_RECORDING_EVENT, this.OnSaveRecording);
                _loc_2 = _loc_2 + 16;
                _loc_6 = Localization.Lbl_SaveTraces;
                this.mSaveTraceButton = new MenuButton(_loc_2, _loc_4, MenuButton.ICON_MAGNIFY, SAVE_RECORDING_TRACE_EVENT, -1, Localization.Lbl_StartRecordingExecutionTrace, true, _loc_6);
                addChild(this.mSaveTraceButton);
                addEventListener(SAVE_RECORDING_TRACE_EVENT, this.OnSaveRecordingTrace);
                _loc_2 = _loc_2 + 16;
            }
            SkinManager.IMAGE_OPTIONS_MONSTERS.x = _loc_2;
            SkinManager.IMAGE_OPTIONS_MONSTERS.y = -1;
            SkinManager.IMAGE_OPTIONS_MONSTERS.addEventListener(MouseEvent.MOUSE_MOVE, this.OnMonsterMouseMove, false, 0, true);
            SkinManager.IMAGE_OPTIONS_MONSTERS.addEventListener(MouseEvent.MOUSE_OVER, this.OnMonsterMouseOver, false, 0, true);
            SkinManager.IMAGE_OPTIONS_MONSTERS.addEventListener(MouseEvent.MOUSE_OUT, this.OnMonsterMouseOut, false, 0, true);
            addChild(SkinManager.IMAGE_OPTIONS_MONSTERS);
            SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect = SkinManager.IMAGE_OPTIONS_MONSTERS_DISABLED;
            this.mMonsterStatus = 1;
            _loc_2 = _loc_2 + 50;
            this.mTextDisplayX = _loc_2;
            this.mFPSTextField = new TextField();
            this.mFPSTextField.x = _loc_2;
            this.mFPSTextField.y = _loc_4 - 2;
            this.mFPSTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mFPSTextField.defaultTextFormat = this.myformat;
            this.mFPSTextField.selectable = false;
            this.mFPSTextField.filters = [this.myglow];
            this.mFPSTextField.mouseEnabled = false;
            this.mFPSTextField.text = Localization.Lbl_FPS;
            addChild(this.mFPSTextField);
            _loc_2 = _loc_2 + 24;
            this.mFPSValueTextField = new TextField();
            this.mFPSValueTextField.x = _loc_2;
            this.mFPSValueTextField.y = _loc_4 - 2;
            this.mFPSValueTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mFPSValueTextField.defaultTextFormat = this.myformat;
            this.mFPSValueTextField.selectable = false;
            this.mFPSValueTextField.filters = [this.myglow];
            this.mFPSValueTextField.mouseEnabled = false;
            this.mFPSValueTextField.text = "";
            addChild(this.mFPSValueTextField);
            _loc_2 = _loc_2 + 18;
            this.mMemTextField = new TextField();
            this.mMemTextField.x = _loc_2;
            this.mMemTextField.y = _loc_4 - 2;
            this.mMemTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mMemTextField.defaultTextFormat = this.myformat;
            this.mMemTextField.selectable = false;
            this.mMemTextField.filters = [this.myglow];
            this.mMemTextField.mouseEnabled = false;
            this.mMemTextField.text = Localization.Lbl_Mb;
            addChild(this.mMemTextField);
            _loc_2 = _loc_2 + 23;
            this.mMemValueTextField = new TextField();
            this.mMemValueTextField.x = _loc_2;
            this.mMemValueTextField.y = _loc_4 - 2;
            this.mMemValueTextField.autoSize = TextFieldAutoSize.LEFT;
            this.mMemValueTextField.defaultTextFormat = this.myformat;
            this.mMemValueTextField.selectable = false;
            this.mMemValueTextField.filters = [this.myglow];
            this.mMemValueTextField.mouseEnabled = false;
            this.mMemValueTextField.text = "";
            addChild(this.mMemValueTextField);
            _loc_2 = _loc_2 + 30;
            addChild(this.mToolTip);
            addEventListener(ChangeToolEvent.CHANGE_TOOL_EVENT, this.OnChangeTool);
            this.ResetColors();
            return;
        }// end function

        private function OnSaveRecording(event:Event) : void
        {
            this.mSaveTraceButton.Reset();
            this.mSaveDiskButton.Reset();
            Commands.StopRecordingSamples(true);
            return;
        }// end function

        private function OnSaveRecordingTrace(event:Event) : void
        {
            this.mSaveTraceButton.Reset();
            this.mSaveDiskButton.Reset();
            Commands.StopRecordingTraces(true);
            return;
        }// end function

        private function OnMonsterMouseMove(event:MouseEvent) : void
        {
            ToolTip.SetPosition(event.stageX + 12, event.stageY + 6);
            event.stopPropagation();
            event.stopImmediatePropagation();
            return;
        }// end function

        public function OnMonsterMouseOver(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            if (this.mMonsterStatus == 0)
            {
                ToolTip.Text = Localization.Lbl_Cfg_MonsterIconDisabled;
            }
            else if (this.mMonsterStatus == 1)
            {
                ToolTip.Text = Localization.Lbl_Cfg_MonsterIconNotActive;
            }
            else if (this.mMonsterStatus == 2)
            {
                ToolTip.Text = Localization.Lbl_Cfg_MonsterIconActive;
            }
            ToolTip.Visible = true;
            return;
        }// end function

        public function OnMonsterMouseOut(event:MouseEvent) : void
        {
            event.stopPropagation();
            event.stopImmediatePropagation();
            ToolTip.Visible = false;
            return;
        }// end function

        private function OnSaveSnapshot(event:Event) : void
        {
            Commands.SaveSnapshot();
            this.mScreenCapture.mIsSelected = false;
            return;
        }// end function

        public function UpdateSkin() : void
        {
            this.myformat.color = SkinManager.COLOR_GLOBAL_TEXT;
            this.myformatRight.color = SkinManager.COLOR_GLOBAL_TEXT;
            this.myglow.color = SkinManager.COLOR_GLOBAL_TEXT_GLOW;
            if (this.mFPSTextField != null)
            {
                this.mFPSTextField.defaultTextFormat = this.myformat;
                this.mFPSValueTextField.defaultTextFormat = this.myformat;
                this.mMemTextField.defaultTextFormat = this.myformat;
                this.mMemValueTextField.defaultTextFormat = this.myformat;
                this.mFPSTextField.filters = [this.myglow];
                this.mFPSValueTextField.filters = [this.myglow];
                this.mMemTextField.filters = [this.myglow];
                this.mMemValueTextField.filters = [this.myglow];
            }
            graphics.clear();
            graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.4);
            graphics.drawRect(0, 0, this.barWidth, 18);
            graphics.endFill();
            graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.8);
            graphics.drawRect(0, 15, this.barWidth, 1);
            graphics.endFill();
            graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.9);
            graphics.drawRect(0, 16, this.barWidth, 1);
            graphics.endFill();
            return;
        }// end function

        private function OnSaveSWF(event:Event) : void
        {
            return;
        }// end function

        private function OnChangeTool(event:ChangeToolEvent) : void
        {
            var _loc_2:MenuButton = null;
            for each (_loc_2 in this.mButtonDict)
            {
                
                if (event.target != _loc_2)
                {
                    _loc_2.Reset();
                }
            }
            return;
        }// end function

        public function ToggleMinimize() : void
        {
            if (this.mIsHidden)
            {
                this.Show();
            }
            else
            {
                this.Hide();
            }
            return;
        }// end function

        public function Hide() : void
        {
            this.mIsHidden = true;
            var _loc_1:Boolean = false;
            this.mQuitButton.visible = !_loc_1;
            this.mMouseListenerButton.visible = _loc_1;
            this.mStatsButton.visible = _loc_1;
            this.mOverdrawButton.visible = _loc_1;
            this.mInstanciationButton.visible = _loc_1;
            this.mMemoryProfilerButton.visible = _loc_1;
            this.mInternalEventButton.visible = _loc_1;
            this.mFunctionTimeButton.visible = _loc_1;
            this.mLoaderProfilerButton.visible = _loc_1;
            this.mConfigButton.visible = _loc_1;
            this.mUserEventButton.visible = _loc_1;
            this.mScreenCapture.visible = _loc_1;
            this.mConsoleButton.visible = _loc_1;
            this.mSaveDiskButton.visible = _loc_1;
            this.mSaveTraceButton.visible = _loc_1;
            this.mGCButton.visible = _loc_1;
            SkinManager.IMAGE_OPTIONS_MONSTERS.visible = _loc_1;
            this.mMonsterHideBar.visible = _loc_1;
            this.mFPSTextField.x = 32;
            this.mFPSValueTextField.x = this.mFPSTextField.x + 24;
            this.mMemTextField.x = this.mFPSValueTextField.x + 18;
            this.mMemValueTextField.x = this.mMemTextField.x + 23;
            this.graphics.clear();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.4);
            this.graphics.drawRect(0, 0, 120, 18);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.8);
            this.graphics.drawRect(0, 15, 120, 1);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.9);
            this.graphics.drawRect(0, 16, 120, 1);
            this.graphics.endFill();
            return;
        }// end function

        private function Show() : void
        {
            this.mIsHidden = false;
            var _loc_1:Boolean = true;
            this.mQuitButton.visible = !_loc_1;
            this.mMouseListenerButton.visible = _loc_1;
            this.mStatsButton.visible = _loc_1;
            this.mOverdrawButton.visible = _loc_1;
            this.mInstanciationButton.visible = _loc_1;
            this.mMemoryProfilerButton.visible = _loc_1;
            this.mInternalEventButton.visible = _loc_1;
            this.mFunctionTimeButton.visible = _loc_1;
            this.mLoaderProfilerButton.visible = _loc_1;
            this.mConfigButton.visible = _loc_1;
            this.mUserEventButton.visible = _loc_1;
            this.mScreenCapture.visible = _loc_1;
            this.mConsoleButton.visible = _loc_1;
            this.mSaveDiskButton.visible = _loc_1;
            this.mSaveTraceButton.visible = _loc_1;
            this.mGCButton.visible = _loc_1;
            SkinManager.IMAGE_OPTIONS_MONSTERS.visible = _loc_1;
            this.mMonsterHideBar.visible = _loc_1;
            this.mFPSTextField.x = this.mTextDisplayX;
            this.mFPSValueTextField.x = this.mFPSTextField.x + 24;
            this.mMemTextField.x = this.mFPSValueTextField.x + 18;
            this.mMemValueTextField.x = this.mMemTextField.x + 23;
            this.graphics.clear();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.4);
            this.graphics.drawRect(0, 0, this.barWidth, 18);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.8);
            this.graphics.drawRect(0, 15, this.barWidth, 1);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.9);
            this.graphics.drawRect(0, 16, this.barWidth, 1);
            this.graphics.endFill();
            return;
        }// end function

        public function Update() : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            if (this.mLastFps != this.mFps)
            {
                _loc_2 = SampleAnalyzer.mLineString[this.mFps];
                if (_loc_2 == null)
                {
                    var _loc_4:* = String(this.mFps);
                    _loc_2 = String(this.mFps);
                    SampleAnalyzer.mLineString[this.mFps] = _loc_4;
                }
                this.mLastFps = this.mFps;
                this.mFPSValueTextField.text = _loc_2;
            }
            if (this.mUserEventButton.mIsSelected)
            {
                Commands.BuyPro("UserEvents");
                this.mUserEventButton.Reset();
            }
            if (this.mConsoleButton.mIsSelected)
            {
                Commands.BuyPro("FlashConsole");
                this.mConsoleButton.Reset();
            }
            var _loc_1:* = int(System.totalMemory / 1024 / 1024);
            if (this.mLastMem != _loc_1)
            {
                _loc_3 = SampleAnalyzer.mLineString[_loc_1];
                if (_loc_3 == null)
                {
                    var _loc_4:* = String(_loc_1);
                    _loc_3 = String(_loc_1);
                    SampleAnalyzer.mLineString[_loc_1] = _loc_4;
                }
                this.mLastMem = _loc_1;
                this.mMemValueTextField.text = _loc_3;
            }
            if (this.mFoldButton.mIsSelected)
            {
                if (this.mFoldButtonWasSelected)
                {
                    this.Hide();
                    this.mFoldButtonWasSelected = false;
                }
            }
            else if (!this.mFoldButtonWasSelected)
            {
                this.Show();
                this.mFoldButtonWasSelected = true;
            }
            if (!Commands.IsRecordingSamples)
            {
            }
            if (this.mSaveDiskButton != null)
            {
            }
            if (this.mSaveDiskButton.mIsSelected)
            {
                Commands.StartRecordingSamples();
            }
            if (!Commands.IsRecordingTraces)
            {
            }
            if (this.mSaveTraceButton != null)
            {
            }
            if (this.mSaveTraceButton.mIsSelected)
            {
                Commands.StartRecordingTraces();
            }
            if (this.mGCButton.mIsSelected)
            {
                Analytics.Track("Action", "ForceGC");
                SampleAnalyzer.ForceGC();
                this.mGCButton.Reset();
            }
            return;
        }// end function

        public function SetMonsterDisabled() : void
        {
            this.mMonsterHideBar.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 1);
            this.mMonsterHideBar.graphics.drawRect(SkinManager.IMAGE_OPTIONS_MONSTERS.x - 2, 9, SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect.width + 4, 1);
            this.mMonsterHideBar.graphics.endFill();
            this.mMonsterHideBar.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 1);
            this.mMonsterHideBar.graphics.drawRect(SkinManager.IMAGE_OPTIONS_MONSTERS.x - 2, 10, SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect.width + 4, 2);
            this.mMonsterHideBar.graphics.endFill();
            this.mMonsterHideBar.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 1);
            this.mMonsterHideBar.graphics.drawRect(SkinManager.IMAGE_OPTIONS_MONSTERS.x - 2, 12, SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect.width + 4, 1);
            this.mMonsterHideBar.graphics.endFill();
            addChild(this.mMonsterHideBar);
            this.mMonsterStatus = 0;
            return;
        }// end function

        public function Dispose() : void
        {
            return;
        }// end function

        private function ResetColors(obj:Sprite = null) : void
        {
            if (this.mLastSelected != this.mShowInstanciator)
            {
                (this.mShowInstanciator as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mMouseListenerButton)
            {
                (this.mMouseListenerButton as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mAutoStatButton)
            {
                (this.mAutoStatButton as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mShowOverdraw)
            {
                (this.mShowOverdraw as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mShowProfiler)
            {
                (this.mShowProfiler as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mShowInternalEvents)
            {
                (this.mShowInternalEvents as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mShowConfig)
            {
                (this.mShowConfig as MenuButton).Reset();
            }
            if (this.mLastSelected != this.mMinimizeButton)
            {
                (this.mMinimizeButton as MenuButton).Reset();
            }
            if (obj != null)
            {
                obj.getChildAt(1).visible = true;
            }
            return;
        }// end function

        public function OnDebuggerConnect(event:Event) : void
        {
            SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect = SkinManager.IMAGE_OPTIONS_MONSTERS_ACTIVE;
            this.mMonsterStatus = 2;
            return;
        }// end function

        public function OnDebuggerDisconnect(event:Event) : void
        {
            SkinManager.IMAGE_OPTIONS_MONSTERS.scrollRect = SkinManager.IMAGE_OPTIONS_MONSTERS_DISABLED;
            this.mMonsterStatus = 1;
            return;
        }// end function

        public function ResetMenu(aButton:MenuButton) : void
        {
            var _loc_2:MenuButton = null;
            for each (_loc_2 in this.mButtonDict)
            {
                
                if (aButton != _loc_2)
                {
                    _loc_2.Reset();
                }
            }
            return;
        }// end function

    }
}
