﻿package com.sociodox.theminer.manager
{

    public class Localization extends Object
    {
        private static const EMPTY_STRING:String = "";
        public static var LangCode:String;
        public static var Lbl_Minimize:String = "";
        public static var Lbl_RuntimeStatistics:String = "";
        public static var Lbl_MouseListeners:String = "";
        public static var Lbl_Overdraw:String = "";
        public static var Lbl_DisplayObjectsLifeCycle:String = "";
        public static var Lbl_MemoryProfiler:String = "";
        public static var Lbl_ThisFeatureRequireDebugPlayer:String = "";
        public static var Lbl_InternalEventsProfiler:String = "";
        public static var Lbl_PerformanceProfiler:String = "";
        public static var Lbl_LoadersProfiler:String = "";
        public static var Lbl_Configs:String = "";
        public static var Lbl_About:String = "";
        public static var Lbl_ScreenCapture:String = "";
        public static var Lbl_ForceSyncGarbageCollector:String = "";
        public static var Lbl_Done:String = "";
        public static var Lbl_SaveSamples:String = "";
        public static var Lbl_StartRecordingSamples:String = "";
        public static var Lbl_SaveTraces:String = "";
        public static var Lbl_StartRecordingExecutionTrace:String = "";
        public static var Lbl_FPS:String = "";
        public static var Lbl_Mb:String = "";
        public static var Lbl_FS_Current:String = "";
        public static var Lbl_FS_Min:String = "";
        public static var Lbl_FS_Max:String = "";
        public static var Lbl_FS_fps:String = "";
        public static var Lbl_FS_TotalMemoryKo:String = "";
        public static var Lbl_FS_FreeMemoryKo:String = "";
        public static var Lbl_FS_PrivateMemoryKo:String = "";
        public static var Lbl_FS_FlashVersion:String = "";
        public static var Lbl_FS_Debug:String = "";
        public static var Lbl_FS_Release:String = "";
        public static var Lbl_FS_AVMVersion:String = "";
        public static var Lbl_FS_TheMinerVersion:String = "";
        public static var Lbl_FS_StageSize:String = "";
        public static var Lbl_O_DisplayObjectOnStage:String = "";
        public static var Lbl_O_MaxDepth:String = "";
        public static var Lbl_DOLC_Create:String = "";
        public static var Lbl_DOLC_ReUse:String = "";
        public static var Lbl_DOLC_Removed:String = "";
        public static var Lbl_DOLC_WaitingGC:String = "";
        public static var Lbl_DOLC_DisplayObjectOnStage:String = "";
        public static var Lbl_DOLC_AddedToStage:String = "";
        public static var Lbl_DOLC_RemovedFromStage:String = "";
        public static var Lbl_MFP_SaveALLCurrentProfilerData:String = "";
        public static var Lbl_MFP_Saved:String = "";
        public static var Lbl_MFP_ClearCurrentData:String = "";
        public static var Lbl_MFP_DataCleared:String = "";
        public static var Lbl_MFP_PauseRefresh:String = "";
        public static var Lbl_MFP_ResumeRefresh:String = "";
        public static var Lbl_MP_HEADERS_QNAME:String = "";
        public static var Lbl_MP_HEADERS_ADD:String = "";
        public static var Lbl_MP_HEADERS_DEL:String = "";
        public static var Lbl_MP_HEADERS_CURRENT:String = "";
        public static var Lbl_MP_HEADERS_CUMUL:String = "";
        public static var Lbl_IE_VERIFY:String = "";
        public static var Lbl_IE_MARK:String = "";
        public static var Lbl_IE_REAP:String = "";
        public static var Lbl_IE_SWEEP:String = "";
        public static var Lbl_IE_ENTERFRAME:String = "";
        public static var Lbl_IE_TIMERS:String = "";
        public static var Lbl_IE_PRERENDER:String = "";
        public static var Lbl_IE_RENDER:String = "";
        public static var Lbl_IE_AVM1:String = "";
        public static var Lbl_IE_IO:String = "";
        public static var Lbl_IE_MOUSE:String = "";
        public static var Lbl_IE_FREE:String = "";
        public static var Lbl_FP_SortSelfTime:String = "";
        public static var Lbl_FP_SortTotalTime:String = "";
        public static var Lbl_FP_FunctionName:String = "";
        public static var Lbl_FP_Self:String = "";
        public static var Lbl_FP_Total:String = "";
        public static var Lbl_FP_ClickCopyToClipboard:String = "";
        public static var Lbl_L_URLStream:String = "";
        public static var Lbl_L_URLLoader:String = "";
        public static var Lbl_L_Loader:String = "";
        public static var Lbl_L_Success:String = "";
        public static var Lbl_L_Failed:String = "";
        public static var Lbl_L_ShowLoadersWithErrors:String = "";
        public static var Lbl_L_NoUrlFound:String = "";
        public static var Lbl_L_Progress:String = "";
        public static var Lbl_L_Url:String = "";
        public static var Lbl_L_Status:String = "";
        public static var Lbl_L_Size:String = "";
        public static var Lbl_LD_Waiting:String = "";
        public static var Lbl_LD_Completed:String = "";
        public static var Lbl_LA_Init:String = "";
        public static var Lbl_LA_IOError:String = "";
        public static var Lbl_LA_URL:String = "";
        public static var Lbl_LA_Percent:String = "";
        public static var Lbl_LA_Unload:String = "";
        public static var Lbl_LA_SecurityError:String = "";
        public static var Lbl_LA_NoUrlLoader:String = "";
        public static var Lbl_LA_NoUrlStream:String = "";
        public static var Lbl_SA_SamplingFrame:String = "";
        public static var Lbl_SA_NewObject:String = "";
        public static var Lbl_SA_Collected:String = "";
        public static var Lbl_SA_DeletedObject:String = "";
        public static var Lbl_SA_BaseSample:String = "";
        public static var Lbl_Cfg_Opacity:String = "";
        public static var Lbl_Cfg_ClickTransparent:String = "";
        public static var Lbl_Cfg_ClickOpaque:String = "";
        public static var Lbl_Cfg_RefreshSpeed:String = "";
        public static var Lbl_Cfg_Fps:String = "";
        public static var Lbl_Cfg_ClickRefreshLess:String = "";
        public static var Lbl_Cfg_ClickRefreshMore:String = "";
        public static var Lbl_Cfg_SelectTheProfilers:String = "";
        public static var Lbl_Cfg_IfActivatedMinimized:String = "";
        public static var Lbl_Cfg_ToggleSeeWholeMenu:String = "";
        public static var Lbl_Cfg_ToggleGraphEnabled:String = "";
        public static var Lbl_Cfg_ToggleGraphDisabled:String = "";
        public static var Lbl_Cfg_ToggleMemoryEnabled:String = "";
        public static var Lbl_Cfg_ToggleMemoryDisabled:String = "";
        public static var Lbl_Cfg_ToggleInternalEnabled:String = "";
        public static var Lbl_Cfg_ToggleInternalDisabled:String = "";
        public static var Lbl_Cfg_TogglePerformanceEnabled:String = "";
        public static var Lbl_Cfg_TogglePerformanceDisabled:String = "";
        public static var Lbl_Cfg_ToggleLoaderEnabled:String = "";
        public static var Lbl_Cfg_ToggleLoaderDisabled:String = "";
        public static var Lbl_Cfg_ToggleMonsterEnabled:String = "";
        public static var Lbl_Cfg_ToggleMonsterDisabled:String = "";
        public static var Lbl_Cfg_InfoSelfAnalytics:String = "";
        public static var Lbl_Cfg_InfoSelfAnalyticsMore:String = "";
        public static var Lbl_Cfg_InfoLoadSkin:String = "";
        public static var Lbl_Cfg_ToggleAnalyticsEnabled:String = "";
        public static var Lbl_Cfg_ToggleAnalyticsDisabled:String = "";
        public static var Lbl_Cfg_LoadSkinFile:String = "";
        public static var Lbl_Cfg_ReloadSkin:String = "";
        public static var Lbl_Cfg_NewVersionAvailable:String = "";
        public static var Lbl_FP_FunctionNameFilter:String = "";
        public static var Lbl_MP_QNameFilter:String = "";
        public static var Lbl_LP_FileNameFilter:String = "";
        public static var Lbl_Cfg_MonsterIconDisabled:String = "";
        public static var Lbl_Cfg_MonsterIconActive:String = "";
        public static var Lbl_Cfg_MonsterIconNotActive:String = "";
        public static var Lbl_MFP_Sort:String = "";
        public static var Lbl_Quit:String = "";
        public static var Lbl_TheMinerNeedFlashPlayerDebug:String = "";
        public static var Lbl_Cfg_Localization:String = "";
        public static var Lbl_Cfg_LoadLocalization:String = "";
        public static var Lbl_Cfg_PasteLocalization:String = "";
        public static var Lbl_Console_Console:String = "";
        public static var Lbl_UserEvents:String = "";
        public static var Lbl_UserEvents_Status:String = "";
        public static var Lbl_UserEvents_Value1:String = "";
        public static var Lbl_UserEvents_Value2:String = "";
        public static var Lbl_UserEvents_Info:String = "";
        public static var Lbl_MFP_AvgPerFrame:String = "";
        public static var Lbl_SamplesDump_WasCollected:String = "";
        public static var Lbl_SamplesDump_SampleSize:String = "";
        public static var Lbl_SamplesDump_Time:String = "";
        public static var Lbl_SamplesDump_TimeDiff:String = "";
        public static var Lbl_SamplesDump_SampleType:String = "";
        public static var Lbl_SamplesDump_ObjectID:String = "";
        public static var Lbl_SamplesDump_ObjectType:String = "";
        public static var Lbl_SamplesDump_InstanciationStack:String = "";
        public static var Lbl_TracesDump_FunctionName:String = "";
        public static var Lbl_TracesDump_Arguments:String = "";
        public static var Lbl_TracesDump_File:String = "";
        public static var Lbl_TracesDump_LineNumber:String = "";
        public static var Lbl_Cfg_SaveFilters:String = "";
        public static var Lbl_LD_SwfLoaded:String = "";
        public static var Lbl_LD_SaveEncriptionFreeSWF:String = "";
        public static var Lbl_LD_GoToLink:String = "";
        public static var Lbl_RequirePro:String = "";
        private static var mInitialized:Boolean = Init();

        public function Localization()
        {
            return;
        }// end function

        private static function Init() : Boolean
        {
            LangCode = "zh-cn";
            Lbl_Minimize = "最小化";
            Lbl_RuntimeStatistics = "即时状态";
            Lbl_MouseListeners = "滑鼠事件";
            Lbl_Overdraw = "显示重绘区域";
            Lbl_DisplayObjectsLifeCycle = "显示物件状态";
            Lbl_MemoryProfiler = "记忆体分析器";
            Lbl_ThisFeatureRequireDebugPlayer = "这个功能需安装除错版的播放器";
            Lbl_InternalEventsProfiler = "内部事件分析器";
            Lbl_PerformanceProfiler = "效能分析器";
            Lbl_LoadersProfiler = "载入器分析器";
            Lbl_Configs = "设定";
            Lbl_About = "关于";
            Lbl_ForceSyncGarbageCollector = "强制启动记忆体回收机制";
            Lbl_Done = "完成";
            Lbl_SaveSamples = "复制资料到剪贴簿" + "\n包含新的物件, 已移除的物件, 函式执行时间" + "\n所有的栏位用空格(Tab)分隔, 方便使用编辑器开启编辑及排序.";
            Lbl_StartRecordingSamples = "开始记录资料";
            Lbl_SaveTraces = "储存影格相关资料(类别名称，路径，参数，行数)";
            Lbl_StartRecordingExecutionTrace = "开始记录执行输出";
            Lbl_FPS = "FPS:";
            Lbl_Mb = "Mb:";
            Lbl_FS_Current = "目前状态";
            Lbl_FS_Min = "最小值";
            Lbl_FS_Max = "最大值";
            Lbl_FS_fps = "fps:";
            Lbl_FS_TotalMemoryKo = "total-memory (Ko):";
            Lbl_FS_FreeMemoryKo = "free-memory (Ko):";
            Lbl_FS_PrivateMemoryKo = "private-memory (Ko):";
            Lbl_FS_FlashVersion = "Flash 版本:";
            Lbl_FS_Debug = "Debug";
            Lbl_FS_Release = "Release";
            Lbl_FS_AVMVersion = "AVM 版本:";
            Lbl_FS_TheMinerVersion = "TheMiner 版本:";
            Lbl_FS_StageSize = "舞台大小";
            Lbl_O_DisplayObjectOnStage = "舞台上的显示物件";
            Lbl_O_MaxDepth = "最大深度";
            Lbl_DOLC_Create = "建立";
            Lbl_DOLC_ReUse = "重新使用";
            Lbl_DOLC_Removed = "移除";
            Lbl_DOLC_WaitingGC = "等待回收";
            Lbl_DOLC_DisplayObjectOnStage = "舞台上的显示物件";
            Lbl_DOLC_AddedToStage = "加入舞台";
            Lbl_DOLC_RemovedFromStage = "从舞台上移除";
            Lbl_MFP_SaveALLCurrentProfilerData = "复制到剪贴簿";
            Lbl_MFP_Saved = "储档";
            Lbl_MFP_ClearCurrentData = "清除资料";
            Lbl_MFP_DataCleared = "已清除资料";
            Lbl_MFP_PauseRefresh = "暂停";
            Lbl_MFP_ResumeRefresh = "继续";
            Lbl_MP_HEADERS_QNAME = "[完整的类别名称]";
            Lbl_MP_HEADERS_ADD = "[新增]";
            Lbl_MP_HEADERS_DEL = "[删除]";
            Lbl_MP_HEADERS_CURRENT = "[Current]";
            Lbl_MP_HEADERS_CUMUL = "[Cumul]";
            Lbl_IE_VERIFY = "VERIFY";
            Lbl_IE_MARK = "MARK";
            Lbl_IE_REAP = "REAP";
            Lbl_IE_SWEEP = "SWEEP";
            Lbl_IE_ENTERFRAME = "ENTER FRAME";
            Lbl_IE_TIMERS = "TIMERS";
            Lbl_IE_PRERENDER = "PRE-RENDER";
            Lbl_IE_RENDER = "RENDER";
            Lbl_IE_AVM1 = "AVM1";
            Lbl_IE_IO = "IO";
            Lbl_IE_MOUSE = "MOUSE";
            Lbl_IE_FREE = "FREE";
            Lbl_FP_SortSelfTime = "依据 Self-Time 排序";
            Lbl_FP_SortTotalTime = "依据 Total-Time 排序";
            Lbl_FP_FunctionName = "函式名称";
            Lbl_FP_Self = "Self";
            Lbl_FP_Total = "Total";
            Lbl_FP_ClickCopyToClipboard = "复制到剪贴簿";
            Lbl_L_URLStream = "URLStream";
            Lbl_L_URLLoader = "URLLoader";
            Lbl_L_Loader = "Loader";
            Lbl_L_Success = "成功";
            Lbl_L_Failed = "失败";
            Lbl_L_ShowLoadersWithErrors = "只显示失败的载入器";
            Lbl_L_NoUrlFound = "网址错误";
            Lbl_L_Progress = "载入处理中";
            Lbl_L_Url = "网址";
            Lbl_L_Status = "状态";
            Lbl_L_Size = "大小";
            Lbl_LD_Waiting = "等待中";
            Lbl_LD_Completed = "完成";
            Lbl_LA_Init = "初始化";
            Lbl_LA_IOError = "IO 错误";
            Lbl_LA_URL = "网址: ";
            Lbl_LA_Percent = " %";
            Lbl_LA_Unload = "卸载";
            Lbl_LA_SecurityError = "安全性错误";
            Lbl_LA_NoUrlLoader = "网址错误: URLLoader";
            Lbl_LA_NoUrlStream = "网址错误: URLStream";
            Lbl_SA_SamplingFrame = "影格";
            Lbl_SA_NewObject = "新增物件";
            Lbl_SA_Collected = "已收集物件";
            Lbl_SA_DeletedObject = "删除物件";
            Lbl_SA_BaseSample = "Base Sample";
            Lbl_Cfg_Opacity = "透明度";
            Lbl_Cfg_ClickTransparent = "增加透明度";
            Lbl_Cfg_ClickOpaque = "降低透明度";
            Lbl_Cfg_RefreshSpeed = "刷新速度";
            Lbl_Cfg_Fps = "Fps";
            Lbl_Cfg_ClickRefreshLess = "增加刷新速度";
            Lbl_Cfg_ClickRefreshMore = "降低刷新速度";
            Lbl_Cfg_SelectTheProfilers = "选择在背景执行的分析器";
            Lbl_Cfg_IfActivatedMinimized = "最小化执行";
            Lbl_Cfg_ToggleSeeWholeMenu = "分析器执行时显示完整选单";
            Lbl_Cfg_ToggleGraphEnabled = "启用MemoryGraph 分析器";
            Lbl_Cfg_ToggleGraphDisabled = "关闭MemoryGraph 分析器";
            Lbl_Cfg_ToggleMemoryEnabled = "启用memory 分析器";
            Lbl_Cfg_ToggleMemoryDisabled = "关闭memory 分析器";
            Lbl_Cfg_ToggleInternalEnabled = "启用InternalEvents 分析器";
            Lbl_Cfg_ToggleInternalDisabled = "关闭InternalEvents 分析器";
            Lbl_Cfg_TogglePerformanceEnabled = "启用performance 分析器";
            Lbl_Cfg_TogglePerformanceDisabled = "关闭performance 分析器";
            Lbl_Cfg_ToggleLoaderEnabled = "启用loaders 分析器";
            Lbl_Cfg_ToggleLoaderDisabled = "关闭loaders 分析器";
            Lbl_Cfg_ToggleMonsterEnabled = "启用MonsterDebugger";
            Lbl_Cfg_ToggleMonsterDisabled = "关闭MonsterDebugger";
            Lbl_Cfg_InfoSelfAnalytics = "自行分析:";
            Lbl_Cfg_InfoSelfAnalyticsMore = "(无法从你的专案或是网址取得分析资料)";
            Lbl_Cfg_InfoLoadSkin = "载入主题";
            Lbl_Cfg_ToggleAnalyticsEnabled = "启用分析";
            Lbl_Cfg_ToggleAnalyticsDisabled = "关闭分析";
            Lbl_Cfg_LoadSkinFile = "载入主题档案";
            Lbl_Cfg_ReloadSkin = "重新载入预设主题";
            Lbl_Cfg_NewVersionAvailable = "目前最新版本:";
            Lbl_ScreenCapture = "撷取萤幕";
            Lbl_MP_QNameFilter = "类别名称筛选器";
            Lbl_FP_FunctionNameFilter = "函式名称筛选器";
            Lbl_LP_FileNameFilter = "档案名称筛选器";
            Lbl_Cfg_MonsterIconDisabled = "关闭Monster Debugger";
            Lbl_Cfg_MonsterIconActive = "启动Monster Debugger";
            Lbl_Cfg_MonsterIconNotActive = "Monster Debugger 尚未连线";
            Lbl_MFP_Sort = "排序";
            Lbl_Quit = "结束";
            Lbl_TheMinerNeedFlashPlayerDebug = "执行TheMiner 需安装除错版的播放器";
            Lbl_Cfg_Localization = "多国语系设定";
            Lbl_Cfg_LoadLocalization = "复制多国语系资料到剪行簿";
            Lbl_Cfg_PasteLocalization = "套用多国语系设定";
            Lbl_Console_Console = "主控台";
            Lbl_UserEvents = "User Events";
            Lbl_UserEvents_Status = "状态";
            Lbl_UserEvents_Value1 = "数值1";
            Lbl_UserEvents_Value2 = "数值2";
            Lbl_UserEvents_Info = "Info";
            Lbl_MFP_AvgPerFrame = "Avg / Frame";
            Lbl_SamplesDump_WasCollected = "Is in M​​emory";
            Lbl_SamplesDump_SampleSize = "Object Size";
            Lbl_SamplesDump_Time = "Time";
            Lbl_SamplesDump_TimeDiff = "Time Diff";
            Lbl_SamplesDump_SampleType = "Sample Type";
            Lbl_SamplesDump_ObjectID = "Object ID";
            Lbl_SamplesDump_ObjectType = "Object Type";
            Lbl_SamplesDump_InstanciationStack = "Allocation Stack";
            Lbl_TracesDump_FunctionName = "函式类别名称";
            Lbl_TracesDump_Arguments = "参数";
            Lbl_TracesDump_File = "档案";
            Lbl_TracesDump_LineNumber = "行数";
            Lbl_Cfg_SaveFilters = "开启自动存档功能\n->记忆体/ 效能/ 载入器";
            Lbl_LD_SwfLoaded = "SWF Loaded";
            Lbl_LD_SaveEncriptionFreeSWF = "Save SWF bytes\n[raw, or post-decryption]";
            Lbl_RequirePro = "*Require PRO version";
            return true;
        }// end function

    }
}
