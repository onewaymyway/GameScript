package com.sociodox.theminer.window
{
    import com.sociodox.theminer.manager.*;
    import com.sociodox.theminer.ui.*;
    import com.sociodox.theminer.ui.button.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.sampler.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Configuration extends Sprite implements IWindow
    {
        private var mInfos:TextField;
        private var mVersionUpdate:TextField;
        private var mRefreshFPS:TextField;
        private var mMinimieButton:MenuButton;
        private var mStatsButton:MenuButton;
        private var mMemoryProfilerButton:MenuButton;
        private var mInternalEventButton:MenuButton;
        private var mFunctionTimeButton:MenuButton;
        private var mLoaderProfilerButton:MenuButton;
        private var mMonsters:MenuButton;
        private var mSaveFilters:MenuButton;
        private var mAnalyticsButton:MenuButton;
        private var mSaveLocalizationButton:MenuButton;
        private var mPasteLocalizationButton:MenuButton;
        private var mUpdateVersionButton:MenuButton;
        private var mOpacityDown:MenuButton;
        private var mOpacitySymbol:MenuButton;
        private var mOpacityUp:MenuButton;
        private var mRefreshDown:MenuButton;
        private var mRefreshSymbol:MenuButton;
        private var mRefreshUp:MenuButton;
        private var mButtonDict:Dictionary;
        private var mEnterTime:int = 0;
        private var myformat:TextFormat = null;
        private var myglow:GlowFilter = null;
        private var _loadFile:FileReference;
        private var mSWFListOutput:FileReference;
        private var mBlend:Boolean = false;
        private var mLastTime:int;
        public static const SETUP_START_MINIMIZED:String = "SETUP_START_MINIMIZED";
        public static const SETUP_MEMORY_PROFILING_ENABLED:String = "SETUP_MEMORY_PROFILING_ENABLED";
        public static const SETUP_INTERNALEVENT_PROFILING_ENABLED:String = "SETUP_INTERNALEVENT_PROFILING_ENABLED";
        public static const SETUP_FUNCTION_PROFILING_ENABLED:String = "SETUP_FUNCTION_PROFILING_ENABLED";
        public static const SETUP_LOADERS_PROFILING_ENABLED:String = "SETUP_LOADERS_PROFILING_ENABLED";
        public static const SETUP_LOADERS_SAVE_FILTERS:String = "SETUP_LOADERS_SAVE_FILTERS";
        public static const SETUP_SOCKETS_PROFILING_ENABLED:String = "SETUP_SOCKETS_PROFILING_ENABLED";
        public static const SETUP_MEMGRAPH_PROFILING_ENABLED:String = "SETUP_MEMGRAPH_PROFILING_ENABLED";
        public static const SETUP_MONSTER_DEBUGGER:String = "SETUP_MONSTER_DEBUGGER";
        public static const SETUP_ANALYTICS_ENABLED:String = "SETUP_ANALYTICS_ENABLED";
        public static const SETUP_FRAME_UPDATE:String = "SETUP_FRAME_UPDATE";
        public static const SETUP_OPACITY:String = "SETUP_OPACITY";
        public static var SAVED_FILTER_MEMORY:String = "";
        public static var SAVED_FILTER_PERFORMANCE:String = "";
        public static var SAVED_FILTER_LOADER:String = "";
        public static var SAVED_FILTER_USEREVENT:String = "";
        public static var _PROFILE_MEMORY:Boolean = false;
        public static var _PROFILE_FUNCTION:Boolean = false;
        public static var _SAVE_FILTERS:Boolean = false;
        public static var _PROFILE_INTERNAL_EVENTS:Boolean = false;
        public static var _PROFILE_LOADERS:Boolean = false;
        private static var _PROFILE_SOCKETS:Boolean = false;
        private static var _PROFILE_MEMGRAPH:Boolean = false;
        private static var _START_MINIMIZED:Boolean = false;
        private static var _PROFILE_MONSTER:Boolean = false;
        private static var _ANALYTICS_ENABLED:Boolean = true;
        private static var _FRAME_UPDATE_SPEED:int = 1;
        private static var _INTERFACE_OPACITY:int = 6;
        public static var mSaveObj:SharedObject;
        private static var mInstance:Configuration = null;
        public static const LOAD_SKIN_EVENT:String = "LoadSkinEvent";
        public static const SAVE_LOCALIZATION_EVENT:String = "SaveLocalizationEvent";
        public static const PASTE_LOCALIZATION_EVENT:String = "PasteLocalizationEvent";
        public static var COMMAND_LINE_SAMPLING_LSTENER:Boolean = false;

        public function Configuration()
        {
            this.mButtonDict = new Dictionary(true);
            this.mSWFListOutput = new FileReference();
            mInstance = this;
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "Config", "Config Enter");
            return;
        }// end function

        public function UpdateSkin() : void
        {
            var _loc_2:TextFormat = null;
            var _loc_1:* = Stage2D.stage.stageWidth;
            this.graphics.clear();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 1);
            this.graphics.drawRect(0, 16, _loc_1, Stage2D.stage.stageHeight - 18);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.6);
            this.graphics.drawRect(0, 17, _loc_1, 1);
            this.graphics.endFill();
            this.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.8);
            this.graphics.drawRect(0, 16, _loc_1, 1);
            this.graphics.endFill();
            if (this.mRefreshFPS != null)
            {
                this.myformat.color = SkinManager.COLOR_GLOBAL_TEXT;
                this.myglow.color = SkinManager.COLOR_GLOBAL_TEXT_GLOW;
                this.mRefreshFPS.defaultTextFormat = this.myformat;
                this.mInfos.defaultTextFormat = this.myformat;
                this.mRefreshFPS.filters = [this.myglow];
                this.mInfos.filters = [this.myglow];
                this.mVersionUpdate.filters = [this.myglow];
                _loc_2 = new TextFormat("_sans", 14, SkinManager.COLOR_GLOBAL_TEXT, true);
                this.mVersionUpdate.defaultTextFormat = _loc_2;
                this.mVersionUpdate.textColor = SkinManager.COLOR_SELECTION_OVERLAY;
                this.mVersionUpdate.text = "";
                this.mVersionUpdate.visible = false;
            }
            return;
        }// end function

        private function Init() : void
        {
            this.alpha = Commands.Opacity / 10;
            this.mouseEnabled = false;
            var _loc_1:* = Stage2D.stage.stageWidth;
            var _loc_2:* = new Sprite();
            this.myformat = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            this.myglow = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mRefreshFPS = new TextField();
            this.mRefreshFPS.mouseEnabled = false;
            this.mRefreshFPS.autoSize = TextFieldAutoSize.LEFT;
            this.mRefreshFPS.defaultTextFormat = this.myformat;
            this.mRefreshFPS.selectable = false;
            this.mRefreshFPS.x = 135;
            this.mRefreshFPS.y = 20 + 14;
            this.mRefreshFPS.text = Commands.RefreshRate.toString();
            this.mRefreshFPS.filters = [this.myglow];
            addChild(this.mRefreshFPS);
            this.mVersionUpdate = new TextField();
            this.mVersionUpdate.mouseEnabled = false;
            this.mVersionUpdate.selectable = false;
            this.mVersionUpdate.width = 200;
            this.mVersionUpdate.x = 2;
            addChild(this.mVersionUpdate);
            this.mVersionUpdate.visible = false;
            var _loc_3:* = new TextField();
            this.mInfos = new TextField();
            this.mInfos.mouseEnabled = false;
            this.mInfos.autoSize = TextFieldAutoSize.LEFT;
            this.mInfos.defaultTextFormat = this.myformat;
            this.mInfos.selectable = false;
            _loc_3.defaultTextFormat = this.myformat;
            this.mInfos.x = 2;
            this.mInfos.y = 20;
            this.mInfos.appendText(Localization.Lbl_Cfg_Opacity + ":\n");
            _loc_3.text = Localization.Lbl_Cfg_Opacity;
            var _loc_4:* = _loc_3.textWidth + 10;
            var _loc_5:* = this.mInfos.y + 3;
            this.mOpacityDown = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_Cfg_ClickTransparent, true);
            addChild(this.mOpacityDown);
            _loc_4 = _loc_4 + 16;
            this.mOpacitySymbol = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_GRADIENT, null, -1, "", false, null, false);
            addChild(this.mOpacitySymbol);
            _loc_4 = _loc_4 + 16;
            this.mOpacityUp = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_ARROW_UP, null, -1, Localization.Lbl_Cfg_ClickOpaque, true);
            addChild(this.mOpacityUp);
            _loc_3.text = Localization.Lbl_Cfg_RefreshSpeed + "(" + Localization.Lbl_Cfg_Fps + "):";
            this.mInfos.appendText(_loc_3.text + "\n");
            _loc_4 = _loc_3.textWidth + 23;
            this.mRefreshFPS.x = _loc_4 - 18;
            _loc_5 = _loc_5 + 14;
            this.mRefreshDown = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_ARROW_DOWN, null, -1, Localization.Lbl_Cfg_ClickRefreshLess, true);
            addChild(this.mRefreshDown);
            _loc_4 = _loc_4 + 16;
            this.mRefreshSymbol = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_PERFORMANCE, null, -1, "", false, null, false);
            addChild(this.mRefreshSymbol);
            _loc_4 = _loc_4 + 16;
            this.mRefreshUp = new MenuButton(_loc_4, _loc_5, MenuButton.ICON_ARROW_UP, null, -1, Localization.Lbl_Cfg_ClickRefreshMore, true);
            addChild(this.mRefreshUp);
            _loc_5 = _loc_5 + 14;
            this.mInfos.appendText(Localization.Lbl_Cfg_SelectTheProfilers);
            _loc_5 = _loc_5 + 14;
            this.mInfos.filters = [this.myglow];
            addChild(this.mInfos);
            var _loc_6:int = 4;
            this.mMinimieButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_MINIMIZE, null, -1, Localization.Lbl_Cfg_IfActivatedMinimized, true, Localization.Lbl_Cfg_ToggleSeeWholeMenu);
            addChild(this.mMinimieButton);
            this.mButtonDict[this.mMinimieButton] = this.mMinimieButton;
            _loc_6 = _loc_6 + 16;
            if (START_MINIMIZED)
            {
                this.mMinimieButton.OnClick(null);
            }
            this.mStatsButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_STATS, null, -1, Localization.Lbl_Cfg_ToggleGraphEnabled, true, Localization.Lbl_Cfg_ToggleGraphDisabled);
            addChild(this.mStatsButton);
            this.mButtonDict[this.mStatsButton] = this.mStatsButton;
            _loc_6 = _loc_6 + 16;
            if (PROFILE_MEMGRAPH)
            {
                this.mStatsButton.OnClick(null);
            }
            this.mMemoryProfilerButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_MEMORY, null, -1, Localization.Lbl_Cfg_ToggleMemoryEnabled, true, Localization.Lbl_Cfg_ToggleMemoryDisabled);
            addChild(this.mMemoryProfilerButton);
            this.mButtonDict[this.mMemoryProfilerButton] = this.mMemoryProfilerButton;
            _loc_6 = _loc_6 + 16;
            if (PROFILE_MEMORY)
            {
                this.mMemoryProfilerButton.OnClick(null);
            }
            this.mInternalEventButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_EVENTS, null, -1, Localization.Lbl_Cfg_ToggleInternalEnabled, true, Localization.Lbl_Cfg_ToggleInternalDisabled);
            addChild(this.mInternalEventButton);
            this.mButtonDict[this.mInternalEventButton] = this.mInternalEventButton;
            _loc_6 = _loc_6 + 16;
            if (PROFILE_INTERNAL_EVENTS)
            {
                this.mInternalEventButton.OnClick(null);
            }
            this.mFunctionTimeButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_PERFORMANCE, null, -1, Localization.Lbl_Cfg_TogglePerformanceEnabled, true, Localization.Lbl_Cfg_TogglePerformanceDisabled);
            addChild(this.mFunctionTimeButton);
            this.mButtonDict[this.mFunctionTimeButton] = this.mFunctionTimeButton;
            _loc_6 = _loc_6 + 16;
            if (PROFILE_FUNCTION)
            {
                this.mFunctionTimeButton.OnClick(null);
            }
            this.mLoaderProfilerButton = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_LOADER, null, -1, Localization.Lbl_Cfg_ToggleLoaderEnabled, true, Localization.Lbl_Cfg_ToggleLoaderDisabled);
            addChild(this.mLoaderProfilerButton);
            this.mButtonDict[this.mLoaderProfilerButton] = this.mLoaderProfilerButton;
            _loc_6 = _loc_6 + 16;
            if (PROFILE_LOADERS)
            {
                this.mLoaderProfilerButton.OnClick(null);
            }
            this.mMonsters = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_MONSTER, null, -1, Localization.Lbl_Cfg_ToggleMonsterEnabled, true, Localization.Lbl_Cfg_ToggleMonsterDisabled);
            addChild(this.mMonsters);
            this.mButtonDict[this.mMonsters] = this.mMonsters;
            _loc_6 = _loc_6 + 16;
            if (_PROFILE_MONSTER)
            {
                this.mMonsters.OnClick(null);
            }
            this.mSaveFilters = new MenuButton(_loc_6, _loc_5, MenuButton.ICON_FILTER, null, -1, Localization.Lbl_RequirePro + "\n" + Localization.Lbl_Cfg_SaveFilters, true, null);
            addChild(this.mSaveFilters);
            this.mButtonDict[this.mSaveFilters] = this.mSaveFilters;
            _loc_6 = _loc_6 + 16;
            _loc_5 = _loc_5 + 17;
            this.mInfos = new TextField();
            this.mInfos.mouseEnabled = false;
            this.mInfos.autoSize = TextFieldAutoSize.LEFT;
            this.mInfos.defaultTextFormat = this.myformat;
            this.mInfos.selectable = false;
            this.mInfos.appendText(Localization.Lbl_Cfg_InfoSelfAnalytics);
            this.mInfos.filters = [this.myglow];
            this.mInfos.x = 2;
            this.mInfos.y = _loc_5;
            addChild(this.mInfos);
            _loc_3.text = Localization.Lbl_Cfg_InfoSelfAnalytics;
            _loc_4 = _loc_3.textWidth + 8;
            this.mAnalyticsButton = new MenuButton(_loc_4, this.mInfos.y + 4, MenuButton.ICON_CLIPBOARD, null, -1, Localization.Lbl_Cfg_ToggleAnalyticsEnabled, true, Localization.Lbl_Cfg_ToggleAnalyticsDisabled);
            addChild(this.mAnalyticsButton);
            this.mButtonDict[this.mAnalyticsButton] = this.mAnalyticsButton;
            this.mInfos.appendText("\t\t" + Localization.Lbl_Cfg_InfoSelfAnalyticsMore);
            _loc_6 = _loc_6 + 16;
            if (_ANALYTICS_ENABLED)
            {
                this.mAnalyticsButton.OnClick(null);
            }
            ToolTip.Text = Localization.Lbl_Configs;
            _loc_5 = _loc_5 + 17;
            _loc_3.text = Localization.Lbl_Cfg_InfoLoadSkin;
            _loc_6 = _loc_3.textWidth + 10;
            _loc_5 = _loc_5 + 15;
            this.mUpdateVersionButton = new MenuButton(7, _loc_5, MenuButton.ICON_LINK, null, -1, "http://www.sociodox.com/theminer/", true, "");
            addChild(this.mUpdateVersionButton);
            this.mUpdateVersionButton.visible = false;
            Security.loadPolicyFile("http://www.sociodox.com/crossdomain.xml");
            var _loc_7:* = new URLStream();
            _loc_7.addEventListener(Event.COMPLETE, this.OnVersionCompleted);
            _loc_7.load(new URLRequest("http://www.sociodox.com/theminer/version.txt?" + Math.random() * int.MAX_VALUE));
            this.UpdateSkin();
            return;
        }// end function

        private function startLoadingFile() : void
        {
            this._loadFile = new FileReference();
            this._loadFile.addEventListener(Event.SELECT, this.selectHandler);
            var _loc_1:* = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
            this._loadFile.browse([_loc_1]);
            return;
        }// end function

        private function selectHandler(event:Event) : void
        {
            this._loadFile.removeEventListener(Event.SELECT, this.selectHandler);
            this._loadFile.addEventListener(Event.COMPLETE, this.loadCompleteHandler);
            this._loadFile.load();
            return;
        }// end function

        private function loadCompleteHandler(event:Event) : void
        {
            this._loadFile.removeEventListener(Event.COMPLETE, this.loadCompleteHandler);
            var _loc_2:* = new Loader();
            _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
            var _loc_3:* = SharedObject.getLocal("Skin");
            _loc_3.setProperty("skin", this._loadFile.data);
            _loc_3.flush();
            _loc_2.loadBytes(this._loadFile.data);
            return;
        }// end function

        private function OnSaveLocalization(event:Event) : void
        {
            var _loc_3:* = undefined;
            var _loc_2:String = "";
            for (_loc_3 in Object(Localization))
            {
                
                _loc_2 = _loc_2 + (_loc_3 + "\n");
            }
            System.setClipboard(_loc_2);
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function OnPasteLocalization(event:Event) : void
        {
            event.stopImmediatePropagation();
            event.stopPropagation();
            return;
        }// end function

        private function OnLoadSkin(event:Event) : void
        {
            this.startLoadingFile();
            trace("LoadSkin");
            return;
        }// end function

        private function OnDonateOut(event:MouseEvent) : void
        {
            return;
        }// end function

        private function OnDonateOver(event:MouseEvent) : void
        {
            return;
        }// end function

        private function OnDonate(event:MouseEvent) : void
        {
            return;
        }// end function

        public function Update() : void
        {
            var _loc_1:URLRequest = null;
            if (this.mOpacityDown.mIsSelected)
            {
                if (Commands.Opacity > 3)
                {
                    var _loc_2:* = Commands;
                    var _loc_3:* = Commands.Opacity - 1;
                    _loc_2.Opacity = _loc_3;
                }
                this.alpha = Commands.Opacity / 10;
                this.mOpacityDown.Reset();
                Configuration.INTERFACE_OPACITY = Commands.Opacity;
                Save();
            }
            if (this.mOpacityUp.mIsSelected)
            {
                if (Commands.Opacity <= 9)
                {
                    var _loc_2:* = Commands;
                    var _loc_3:* = Commands.Opacity + 1;
                    _loc_2.Opacity = _loc_3;
                }
                this.alpha = Commands.Opacity / 10;
                this.mOpacityUp.Reset();
                Configuration.INTERFACE_OPACITY = Commands.Opacity;
                Save();
            }
            if (this.mRefreshDown.mIsSelected)
            {
                if (Commands.RefreshRate > 1)
                {
                    var _loc_2:* = Commands;
                    var _loc_3:* = Commands.RefreshRate - 1;
                    _loc_2.RefreshRate = _loc_3;
                }
                this.mRefreshFPS.text = Commands.RefreshRate.toString();
                this.mRefreshDown.Reset();
                Configuration.FRAME_UPDATE_SPEED = Commands.RefreshRate;
                Save();
            }
            if (this.mRefreshUp.mIsSelected)
            {
                if (Commands.RefreshRate < 60)
                {
                    var _loc_2:* = Commands;
                    var _loc_3:* = Commands.RefreshRate + 1;
                    _loc_2.RefreshRate = _loc_3;
                }
                this.mRefreshFPS.text = Commands.RefreshRate.toString();
                this.mRefreshUp.Reset();
                Configuration.FRAME_UPDATE_SPEED = Commands.RefreshRate;
                Save();
            }
            if (this.mMemoryProfilerButton.mIsSelected != Configuration.PROFILE_MEMORY)
            {
                Configuration.PROFILE_MEMORY = this.mMemoryProfilerButton.mIsSelected;
                Save();
            }
            if (this.mMinimieButton.mIsSelected != Configuration.START_MINIMIZED)
            {
                Configuration.START_MINIMIZED = this.mMinimieButton.mIsSelected;
                Save();
            }
            if (this.mStatsButton.mIsSelected != Configuration.PROFILE_MEMGRAPH)
            {
                Configuration.PROFILE_MEMGRAPH = this.mStatsButton.mIsSelected;
                Save();
            }
            if (this.mInternalEventButton.mIsSelected != Configuration.PROFILE_INTERNAL_EVENTS)
            {
                Configuration.PROFILE_INTERNAL_EVENTS = this.mInternalEventButton.mIsSelected;
                Save();
            }
            if (this.mFunctionTimeButton.mIsSelected != Configuration.PROFILE_FUNCTION)
            {
                Configuration.PROFILE_FUNCTION = this.mFunctionTimeButton.mIsSelected;
                Save();
            }
            if (this.mSaveFilters.mIsSelected)
            {
                Commands.BuyPro("FilterSaving");
                this.mSaveFilters.Reset();
            }
            if (this.mLoaderProfilerButton.mIsSelected != Configuration.PROFILE_LOADERS)
            {
                Configuration.PROFILE_LOADERS = this.mLoaderProfilerButton.mIsSelected;
                Save();
            }
            if (this.mMonsters.mIsSelected != Configuration.PROFILE_MONSTER)
            {
                Configuration.PROFILE_MONSTER = this.mMonsters.mIsSelected;
                Save();
            }
            if (this.mAnalyticsButton.mIsSelected != Configuration.ANALYTICS_ENABLED)
            {
                Configuration.ANALYTICS_ENABLED = this.mAnalyticsButton.mIsSelected;
                if (this.mAnalyticsButton.mIsSelected)
                {
                    Analytics.Track("Process", "PlayerInfo", "vmVersion: " + System.vmVersion);
                    Analytics.Track("Process", "PlayerInfo", "language: " + Capabilities.language);
                    Analytics.Track("Process", "PlayerInfo", "os: " + Capabilities.os);
                    Analytics.Track("Process", "PlayerInfo", "version: " + Capabilities.version);
                    Analytics.Track("Process", "PlayerInfo", "screenResolution: " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
                }
                Save();
            }
            if (this.mVersionUpdate.visible)
            {
                this.mUpdateVersionButton.visible = true;
                this.mUpdateVersionButton.x = this.mVersionUpdate.x + this.mVersionUpdate.textWidth + 5;
                if (this.mUpdateVersionButton.mIsSelected)
                {
                    Analytics.Track("Process", "Update");
                    _loc_1 = new URLRequest(this.mUpdateVersionButton.mToolTipText);
                    navigateToURL(_loc_1, "_self");
                    this.mUpdateVersionButton.mIsSelected = false;
                }
            }
            if (this.mVersionUpdate != null)
            {
                this.mVersionUpdate.y = this.mInfos.y + this.mInfos.textHeight + 15;
                this.mUpdateVersionButton.y = this.mVersionUpdate.y + 5;
            }
            if (getTimer() > this.mLastTime + 250)
            {
                this.mLastTime = getTimer();
                if (this.mBlend)
                {
                    this.mUpdateVersionButton.blendMode = BlendMode.HARDLIGHT;
                }
                else
                {
                    this.mUpdateVersionButton.blendMode = BlendMode.NORMAL;
                }
                this.mBlend = !this.mBlend;
            }
            return;
        }// end function

        public function Dispose() : void
        {
            this.graphics.clear();
            this.mInfos = null;
            var _loc_1:* = int((getTimer() - this.mEnterTime) / 1000) * 1000;
            Analytics.Track("Tab", "Config", "Config Exit", _loc_1);
            this.mStatsButton.Dispose();
            this.mStatsButton = null;
            this.mMemoryProfilerButton.Dispose();
            this.mMemoryProfilerButton = null;
            this.mInternalEventButton.Dispose();
            this.mInternalEventButton = null;
            this.mFunctionTimeButton.Dispose();
            this.mFunctionTimeButton = null;
            this.mLoaderProfilerButton.Dispose();
            this.mLoaderProfilerButton = null;
            this.mMonsters.Dispose();
            this.mMonsters = null;
            this.mAnalyticsButton.Dispose();
            this.mAnalyticsButton = null;
            this.mButtonDict = null;
            return;
        }// end function

        private function OnVersionCompleted(event:Event) : void
        {
            var _loc_3:URLStream = null;
            var _loc_4:String = null;
            var _loc_5:Array = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Array = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:Boolean = false;
            var _loc_2:* = Configuration.IsSamplingRequired();
            pauseSampling();
            try
            {
                _loc_3 = event.target as URLStream;
                if (_loc_3 != null)
                {
                    _loc_4 = _loc_3.readUTFBytes(_loc_3.bytesAvailable);
                    _loc_5 = _loc_4.split(".");
                    _loc_6 = int(_loc_5[0]);
                    _loc_7 = int(_loc_5[1]);
                    _loc_8 = int(_loc_5[2]);
                    _loc_9 = "1.4.01".split(".");
                    _loc_10 = int(_loc_9[0]);
                    _loc_11 = int(_loc_9[1]);
                    _loc_12 = int(_loc_9[2]);
                    _loc_13 = false;
                    if (_loc_6 > _loc_10)
                    {
                        _loc_13 = true;
                    }
                    else if (_loc_6 == _loc_10)
                    {
                        if (_loc_7 > _loc_11)
                        {
                            _loc_13 = true;
                        }
                        else if (_loc_7 == _loc_11)
                        {
                            if (_loc_8 > _loc_12)
                            {
                                _loc_13 = true;
                            }
                        }
                    }
                    if (_loc_13)
                    {
                        this.mVersionUpdate.visible = true;
                        this.mVersionUpdate.text = Localization.Lbl_Cfg_NewVersionAvailable + "(" + _loc_6 + "." + _loc_7 + "." + _loc_8 + "):";
                        this.mVersionUpdate.width = this.mVersionUpdate.textWidth;
                    }
                }
            }
            catch (err:Error)
            {
            }
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        public function Unlink() : void
        {
            if (this.parent != null)
            {
                this.parent.removeChild(this);
            }
            return;
        }// end function

        public function Link(aParent:DisplayObjectContainer, aPos:int) : void
        {
            aParent.addChildAt(this, aPos);
            return;
        }// end function

        private static function loadBytesHandler(event:Event) : void
        {
            var _loc_2:* = event.target as LoaderInfo;
            _loc_2.removeEventListener(Event.COMPLETE, loadBytesHandler);
            var _loc_3:* = _loc_2.content as Bitmap;
            SkinManager.SetSkin(_loc_3.bitmapData);
            if (mInstance != null)
            {
                mInstance.UpdateSkin();
            }
            return;
        }// end function

        public static function IsSamplingRequired() : Boolean
        {
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
                return true;
            }
            if (Commands.mIsCollectingSamplesData)
            {
                return true;
            }
            return false;
        }// end function

        public static function Load() : void
        {
            var _loc_2:ByteArray = null;
            var _loc_3:Loader = null;
            trace("TheMiner : Loading configs...");
            var _loc_1:* = SharedObject.getLocal("Skin");
            if (_loc_1 != null)
            {
                if (_loc_1.data["skin"] != undefined)
                {
                    _loc_2 = _loc_1.data["skin"] as ByteArray;
                    if (_loc_2 != null)
                    {
                        _loc_3 = new Loader();
                        _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
                        _loc_3.loadBytes(_loc_2);
                    }
                }
            }
            PROFILE_MEMORY = false;
            PROFILE_INTERNAL_EVENTS = false;
            PROFILE_FUNCTION = false;
            PROFILE_LOADERS = false;
            SAVE_FILTERS = false;
            PROFILE_SOCKETS = false;
            PROFILE_MEMGRAPH = false;
            PROFILE_MONSTER = false;
            ANALYTICS_ENABLED = true;
            if (!mSaveObj)
            {
                return;
            }
            if (mSaveObj.data["SAVED_FILTER_MEMORY"] != undefined)
            {
                SAVED_FILTER_MEMORY = mSaveObj.data["SAVED_FILTER_MEMORY"];
            }
            if (mSaveObj.data["SAVED_FILTER_PERFORMANCE"] != undefined)
            {
                SAVED_FILTER_PERFORMANCE = mSaveObj.data["SAVED_FILTER_PERFORMANCE"];
            }
            if (mSaveObj.data["SAVED_FILTER_LOADER"] != undefined)
            {
                SAVED_FILTER_LOADER = mSaveObj.data["SAVED_FILTER_LOADER"];
            }
            if (mSaveObj.data["SAVED_FILTER_USEREVENT"] != undefined)
            {
                SAVED_FILTER_USEREVENT = mSaveObj.data["SAVED_FILTER_USEREVENT"];
            }
            if (mSaveObj.data[SETUP_START_MINIMIZED] != undefined)
            {
                START_MINIMIZED = mSaveObj.data[SETUP_START_MINIMIZED];
            }
            if (mSaveObj.data[SETUP_MEMORY_PROFILING_ENABLED] != undefined)
            {
                PROFILE_MEMORY = mSaveObj.data[SETUP_MEMORY_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_INTERNALEVENT_PROFILING_ENABLED] != undefined)
            {
                PROFILE_INTERNAL_EVENTS = mSaveObj.data[SETUP_INTERNALEVENT_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_FUNCTION_PROFILING_ENABLED] != undefined)
            {
                PROFILE_FUNCTION = mSaveObj.data[SETUP_FUNCTION_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_LOADERS_PROFILING_ENABLED] != undefined)
            {
                PROFILE_LOADERS = mSaveObj.data[SETUP_LOADERS_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_SOCKETS_PROFILING_ENABLED] != undefined)
            {
                PROFILE_SOCKETS = mSaveObj.data[SETUP_SOCKETS_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_MEMGRAPH_PROFILING_ENABLED] != undefined)
            {
                PROFILE_MEMGRAPH = mSaveObj.data[SETUP_MEMGRAPH_PROFILING_ENABLED];
            }
            if (mSaveObj.data[SETUP_MONSTER_DEBUGGER] != undefined)
            {
                PROFILE_MONSTER = mSaveObj.data[SETUP_MONSTER_DEBUGGER];
            }
            if (mSaveObj.data[SETUP_ANALYTICS_ENABLED] != undefined)
            {
                ANALYTICS_ENABLED = mSaveObj.data[SETUP_ANALYTICS_ENABLED];
            }
            if (mSaveObj.data[SETUP_FRAME_UPDATE] != undefined)
            {
                FRAME_UPDATE_SPEED = mSaveObj.data[SETUP_FRAME_UPDATE];
            }
            if (mSaveObj.data[SETUP_OPACITY] != undefined)
            {
                INTERFACE_OPACITY = mSaveObj.data[SETUP_OPACITY];
            }
            return;
        }// end function

        static function Save() : void
        {
            trace("TheMiner : Saving!");
            if (!mSaveObj)
            {
                try
                {
                    mSaveObj = SharedObject.getLocal("TheMinerConfig");
                }
                catch (err:Error)
                {
                }
            }
            if (!mSaveObj)
            {
                return;
            }
            mSaveObj.clear();
            mSaveObj.setProperty(SETUP_START_MINIMIZED, START_MINIMIZED);
            mSaveObj.setProperty(SETUP_MEMORY_PROFILING_ENABLED, PROFILE_MEMORY);
            mSaveObj.setProperty(SETUP_INTERNALEVENT_PROFILING_ENABLED, PROFILE_INTERNAL_EVENTS);
            mSaveObj.setProperty(SETUP_FUNCTION_PROFILING_ENABLED, PROFILE_FUNCTION);
            mSaveObj.setProperty(SETUP_LOADERS_PROFILING_ENABLED, PROFILE_LOADERS);
            mSaveObj.setProperty(SETUP_SOCKETS_PROFILING_ENABLED, PROFILE_SOCKETS);
            mSaveObj.setProperty(SETUP_MEMGRAPH_PROFILING_ENABLED, PROFILE_MEMGRAPH);
            mSaveObj.setProperty(SETUP_MONSTER_DEBUGGER, PROFILE_MONSTER);
            mSaveObj.setProperty(SETUP_ANALYTICS_ENABLED, ANALYTICS_ENABLED);
            mSaveObj.setProperty(SETUP_FRAME_UPDATE, FRAME_UPDATE_SPEED);
            mSaveObj.setProperty(SETUP_OPACITY, INTERFACE_OPACITY);
            if (SAVE_FILTERS)
            {
                mSaveObj.setProperty("SAVED_FILTER_MEMORY", SAVED_FILTER_MEMORY);
                mSaveObj.setProperty("SAVED_FILTER_PERFORMANCE", SAVED_FILTER_PERFORMANCE);
                mSaveObj.setProperty("SAVED_FILTER_LOADER", SAVED_FILTER_LOADER);
                mSaveObj.setProperty("SAVED_FILTER_USEREVENT", SAVED_FILTER_USEREVENT);
            }
            else
            {
                mSaveObj.setProperty("SAVED_FILTER_MEMORY", "");
                mSaveObj.setProperty("SAVED_FILTER_PERFORMANCE", "");
                mSaveObj.setProperty("SAVED_FILTER_LOADER", "");
                mSaveObj.setProperty("SAVED_FILTER_USEREVENT", "");
            }
            var _loc_1:String = "";
            if (START_MINIMIZED)
            {
                _loc_1 = _loc_1 + "_";
            }
            if (PROFILE_MEMORY)
            {
                _loc_1 = _loc_1 + "M";
            }
            if (PROFILE_INTERNAL_EVENTS)
            {
                _loc_1 = _loc_1 + "E";
            }
            if (PROFILE_FUNCTION)
            {
                _loc_1 = _loc_1 + "F";
            }
            if (PROFILE_LOADERS)
            {
                _loc_1 = _loc_1 + "L";
            }
            if (PROFILE_SOCKETS)
            {
                _loc_1 = _loc_1 + "S";
            }
            if (PROFILE_MEMGRAPH)
            {
                _loc_1 = _loc_1 + "G";
            }
            Analytics.Track("Action", "SaveConfig", "Save:" + _loc_1);
            mSaveObj.flush();
            return;
        }// end function

        public static function get INTERFACE_OPACITY() : int
        {
            return _INTERFACE_OPACITY;
        }// end function

        public static function set INTERFACE_OPACITY(value:int) : void
        {
            _INTERFACE_OPACITY = value;
            return;
        }// end function

        public static function get FRAME_UPDATE_SPEED() : int
        {
            return _FRAME_UPDATE_SPEED;
        }// end function

        public static function set FRAME_UPDATE_SPEED(value:int) : void
        {
            _FRAME_UPDATE_SPEED = value;
            return;
        }// end function

        public static function get ANALYTICS_ENABLED() : Boolean
        {
            return _ANALYTICS_ENABLED;
        }// end function

        public static function set ANALYTICS_ENABLED(value:Boolean) : void
        {
            _ANALYTICS_ENABLED = value;
            return;
        }// end function

        public static function get PROFILE_MEMORY() : Boolean
        {
            return _PROFILE_MEMORY;
        }// end function

        public static function set PROFILE_MEMORY(value:Boolean) : void
        {
            _PROFILE_MEMORY = value;
            return;
        }// end function

        public static function get PROFILE_FUNCTION() : Boolean
        {
            return _PROFILE_FUNCTION;
        }// end function

        public static function set PROFILE_FUNCTION(value:Boolean) : void
        {
            _PROFILE_FUNCTION = value;
            return;
        }// end function

        public static function get SAVE_FILTERS() : Boolean
        {
            return _SAVE_FILTERS;
        }// end function

        public static function set SAVE_FILTERS(value:Boolean) : void
        {
            _SAVE_FILTERS = value;
            return;
        }// end function

        public static function get PROFILE_INTERNAL_EVENTS() : Boolean
        {
            return _PROFILE_INTERNAL_EVENTS;
        }// end function

        public static function set PROFILE_INTERNAL_EVENTS(value:Boolean) : void
        {
            _PROFILE_INTERNAL_EVENTS = value;
            return;
        }// end function

        public static function get PROFILE_LOADERS() : Boolean
        {
            return _PROFILE_LOADERS;
        }// end function

        public static function set PROFILE_LOADERS(value:Boolean) : void
        {
            _PROFILE_LOADERS = value;
            return;
        }// end function

        public static function get PROFILE_SOCKETS() : Boolean
        {
            return _PROFILE_SOCKETS;
        }// end function

        public static function set PROFILE_SOCKETS(value:Boolean) : void
        {
            _PROFILE_SOCKETS = value;
            return;
        }// end function

        public static function get START_MINIMIZED() : Boolean
        {
            return _START_MINIMIZED;
        }// end function

        public static function set START_MINIMIZED(value:Boolean) : void
        {
            _START_MINIMIZED = value;
            return;
        }// end function

        public static function get PROFILE_MEMGRAPH() : Boolean
        {
            return _PROFILE_MEMGRAPH;
        }// end function

        public static function set PROFILE_MEMGRAPH(value:Boolean) : void
        {
            _PROFILE_MEMGRAPH = value;
            return;
        }// end function

        public static function get PROFILE_MONSTER() : Boolean
        {
            return _PROFILE_MONSTER;
        }// end function

        public static function set PROFILE_MONSTER(value:Boolean) : void
        {
            _PROFILE_MONSTER = value;
            return;
        }// end function

    }
}
