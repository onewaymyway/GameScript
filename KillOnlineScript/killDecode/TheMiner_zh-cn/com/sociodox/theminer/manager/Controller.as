package com.sociodox.theminer.manager
{
    import __AS3__.vec.*;
    import by.blooddy.crypto.image.*;
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.ui.*;
    import com.sociodox.theminer.window.*;
    import flash.display.*;
    import flash.net.*;
    import flash.sampler.*;
    import flash.system.*;
    import flash.trace.*;
    import flash.utils.*;

    public class Controller extends Object
    {
        public const SAVE_SWF_EVENT:String = "SaveSWFEvent";
        public const SAVE_RECORDING_EVENT:String = "SaveRecordingEvent";
        public const SAVE_RECORDING_TRACE_EVENT:String = "SaveRecordingTraceEvent";
        public const TOGGLE_MINIMIZE:String = "ToggleMinimizeEvent";
        public const TOGGLE_QUIT:String = "ToggleQuitEvent";
        public const SAVE_SNAPSHOT_EVENT:String = "saveSnapshotEvent";
        public const SCREEN_CAPTURE_EVENT:String = "screenCaptureEvent";
        private var mRoot:DisplayObject;
        private var mNumberStack:Vector.<int>;
        public var mTempNoGCFunctionCallHolder:Dictionary;
        private var mTraceBuffer:ByteArray;
        public var mIsCollectingSamplesData:Boolean = false;
        public var mIsCollectingTracesData:Boolean = false;
        private var mRecordingTime:int = 0;
        private var mRecordingTraceTime:int = 0;
        private var mRefreshSpeed:int = 0;
        private var mInterfaceOpacity:int = 0;
        private static const ZERO_PERCENT:String = "0.00";
        private static const ENTRY_TIME_PROPERTY:String = "entryTime";
        private static const CUMUL_PROPERTY:String = "Cumul";

        public function Controller()
        {
            this.mNumberStack = new Vector.<int>(25, true);
            this.mTempNoGCFunctionCallHolder = new Dictionary();
            this.mTraceBuffer = new ByteArray();
            return;
        }// end function

        public function Init(aRoot:DisplayObject) : void
        {
            this.mRoot = aRoot;
            return;
        }// end function

        public function get Opacity() : int
        {
            return this.mInterfaceOpacity;
        }// end function

        public function set Opacity(aOpacity:int) : void
        {
            this.mInterfaceOpacity = aOpacity;
            return;
        }// end function

        public function get RefreshRate() : int
        {
            return this.mRefreshSpeed;
        }// end function

        public function set RefreshRate(aRate:int) : void
        {
            this.mRefreshSpeed = aRate;
            return;
        }// end function

        public function BuyPro(feature:String = null) : void
        {
            if (feature == null)
            {
                Analytics.Track("BuyPro", "default");
                navigateToURL(new URLRequest("http://www.sociodox.com/theminer/product.html#ProVersion"), "_blank");
            }
            else
            {
                Analytics.Track("BuyPro", feature);
                navigateToURL(new URLRequest("http://www.sociodox.com/theminer/feature.html#" + feature), "_blank");
            }
            return;
        }// end function

        public function SaveSnapshot() : void
        {
            var mScreenCaptureFile:FileReference;
            var bmp:BitmapData;
            var isTooltipVisible:Boolean;
            var ba:ByteArray;
            var date:Date;
            if (this.mRoot == null)
            {
                return;
            }
            var samplingRequired:* = Configuration.IsSamplingRequired();
            pauseSampling();
            try
            {
                Analytics.Track("Action", "Screen Capture");
                mScreenCaptureFile = new FileReference();
                if (this.mRoot is Stage)
                {
                    bmp = new BitmapData((this.mRoot as Stage).stageWidth, (this.mRoot as Stage).stageHeight, false);
                }
                else
                {
                    bmp = new BitmapData(this.mRoot.width, this.mRoot.height, false);
                }
                isTooltipVisible = ToolTip.Visible;
                ToolTip.Visible = false;
                bmp.draw(this.mRoot);
                ToolTip.Visible = isTooltipVisible;
                ba = JPEGEncoder.encode(bmp);
                date = new Date();
                mScreenCaptureFile.save(ba, "TheMinerCapture" + date.fullYear.toString() + date.month.toString() + date.day.toString() + date.hours.toString() + "_" + date.minutes + date.seconds + ".jpg");
            }
            catch (e:Error)
            {
                ToolTip.Text = "Error:" + e.message;
                ToolTip.Visible = true;
            }
            if (samplingRequired)
            {
                startSampling();
            }
            return;
        }// end function

        public function SavePerformanceSnapshot(aSetToClipboard:Boolean = false) : String
        {
            var _loc_5:InternalEventEntry = null;
            var _loc_7:String = null;
            var _loc_8:Number = NaN;
            var _loc_2:* = SampleAnalyzer.GetFunctionTimes();
            _loc_2.sortOn(ENTRY_TIME_PROPERTY, Array.NUMERIC | Array.DESCENDING);
            var _loc_3:* = new ByteArray();
            var _loc_4:* = _loc_2.length;
            var _loc_6:int = 0;
            for each (_loc_5 in _loc_2)
            {
                
                _loc_6 = _loc_6 + _loc_5.entryTime;
            }
            _loc_3.writeUTFBytes(Localization.Lbl_LA_Percent);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_FP_Self);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_LA_Percent);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_FP_Total);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_FP_FunctionName);
            _loc_3.writeByte(13);
            _loc_3.writeByte(10);
            for each (_loc_5 in _loc_2)
            {
                
                _loc_8 = int(_loc_5.entryTime / _loc_6 * 10000) / 100;
                if (_loc_8 == 0)
                {
                    _loc_3.writeUTFBytes(ZERO_PERCENT);
                }
                else
                {
                    _loc_3.writeUTFBytes(String(_loc_8));
                }
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_5.entryTime.toString());
                _loc_3.writeByte(9);
                _loc_8 = int(_loc_5.entryTimeTotal / _loc_6 * 10000) / 100;
                if (_loc_8 == 0)
                {
                    _loc_3.writeUTFBytes(ZERO_PERCENT);
                }
                else
                {
                    _loc_3.writeUTFBytes(String(_loc_8));
                }
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_5.entryTimeTotal.toString());
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(String(_loc_5.mStackFrame));
                _loc_3.writeByte(13);
                _loc_3.writeByte(10);
            }
            _loc_3.position = 0;
            _loc_7 = _loc_3.readUTFBytes(_loc_3.length);
            if (aSetToClipboard)
            {
                System.setClipboard(_loc_7);
            }
            return _loc_7;
        }// end function

        public function SaveMemorySnapshot(aSetToClipboard:Boolean = false) : String
        {
            var _loc_4:ClassTypeStatsHolder = null;
            var _loc_5:String = null;
            var _loc_2:* = SampleAnalyzer.GetClassInstanciationStats();
            _loc_2.sortOn(CUMUL_PROPERTY, Array.NUMERIC | Array.DESCENDING);
            var _loc_3:* = new ByteArray();
            _loc_3.writeUTFBytes(Localization.Lbl_MP_HEADERS_QNAME);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_MP_HEADERS_ADD);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_MP_HEADERS_DEL);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_MP_HEADERS_CURRENT);
            _loc_3.writeByte(9);
            _loc_3.writeUTFBytes(Localization.Lbl_MP_HEADERS_CUMUL);
            _loc_3.writeByte(13);
            _loc_3.writeByte(10);
            for each (_loc_4 in _loc_2)
            {
                
                _loc_3.writeUTFBytes(_loc_4.TypeName);
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_4.Added.toString());
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_4.Removed.toString());
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_4.Current.toString());
                _loc_3.writeByte(9);
                _loc_3.writeUTFBytes(_loc_4.Cumul.toString());
                _loc_3.writeByte(13);
                _loc_3.writeByte(10);
            }
            _loc_3.position = 0;
            _loc_5 = _loc_3.readUTFBytes(_loc_3.length);
            if (aSetToClipboard)
            {
                System.setClipboard(_loc_5);
            }
            return _loc_5;
        }// end function

        public function StartRecordingSamples() : void
        {
            this.mIsCollectingSamplesData = true;
            this.mRecordingTime = getTimer();
            return;
        }// end function

        public function get IsRecordingSamples() : Boolean
        {
            return this.mIsCollectingSamplesData;
        }// end function

        public function StopRecordingSamples(aUseClipboard:Boolean) : String
        {
            var _loc_4:* = undefined;
            var _loc_5:ByteArray = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_2:String = null;
            var _loc_3:* = Configuration.IsSamplingRequired();
            pauseSampling();
            if (this.mIsCollectingSamplesData)
            {
                this.mIsCollectingSamplesData = false;
                _loc_5 = SampleAnalyzer.GetFrameDataByteArray();
                if (aUseClipboard)
                {
                    System.setClipboard(_loc_5.toString());
                }
                else
                {
                    _loc_2 = _loc_5.toString();
                }
                _loc_5.length = 0;
                _loc_6 = int(getTimer() - this.mRecordingTime);
                _loc_6 = _loc_6 / 100;
                if (!this.mIsCollectingTracesData)
                {
                    Analytics.Track("Action", "RecordingSamples", "Recording Samples", _loc_6);
                }
            }
            if (this.mIsCollectingTracesData)
            {
                this.mTraceBuffer.length = 0;
                this.mIsCollectingTracesData = false;
                Trace.setLevel(Trace.OFF, Trace.LISTENER);
                Trace.setListener(null);
                _loc_7 = int(getTimer() - this.mRecordingTime);
                _loc_7 = _loc_7 / 100;
                Analytics.Track("Action", "RecordingSamples", "Recording Interlaced Samples", _loc_7);
            }
            for (_loc_4 in this.mTempNoGCFunctionCallHolder)
            {
                
                delete this.mTempNoGCFunctionCallHolder[_loc_4];
            }
            if (_loc_3)
            {
                startSampling();
            }
            return _loc_2;
        }// end function

        public function StartRecordingTraces() : void
        {
            this.mTraceBuffer.writeUTFBytes(Localization.Lbl_TracesDump_FunctionName);
            this.mTraceBuffer.writeByte(9);
            this.mTraceBuffer.writeUTFBytes(Localization.Lbl_TracesDump_Arguments);
            this.mTraceBuffer.writeByte(9);
            this.mTraceBuffer.writeUTFBytes(Localization.Lbl_TracesDump_File);
            this.mTraceBuffer.writeByte(9);
            this.mTraceBuffer.writeUTFBytes(Localization.Lbl_TracesDump_LineNumber);
            this.mTraceBuffer.writeByte(13);
            this.mTraceBuffer.writeByte(10);
            this.mIsCollectingTracesData = true;
            this.mRecordingTraceTime = getTimer();
            return;
        }// end function

        public function get IsRecordingTraces() : Boolean
        {
            return this.mIsCollectingTracesData;
        }// end function

        public function StopRecordingTraces(aUseClipboard:Boolean) : String
        {
            var _loc_4:ByteArray = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:String = null;
            var _loc_3:* = Configuration.IsSamplingRequired();
            pauseSampling();
            if (this.mIsCollectingSamplesData)
            {
                this.mIsCollectingSamplesData = false;
                _loc_4 = SampleAnalyzer.GetFrameDataByteArray();
                if (aUseClipboard)
                {
                    System.setClipboard(_loc_4.toString());
                }
                else
                {
                    _loc_2 = _loc_4.toString();
                }
                _loc_5 = int(getTimer() - this.mRecordingTime);
                _loc_5 = _loc_5 / 100;
                Analytics.Track("Action", "RecordingSamples", "Recording Interlaced Samples", _loc_5);
                Trace.setLevel(Trace.OFF, Trace.LISTENER);
                Trace.setListener(null);
                this.mIsCollectingTracesData = false;
            }
            else if (this.mIsCollectingTracesData)
            {
                this.mIsCollectingTracesData = false;
                Trace.setLevel(Trace.OFF, Trace.LISTENER);
                Trace.setListener(null);
                this.mTraceBuffer.position = 0;
                if (aUseClipboard)
                {
                    System.setClipboard(this.mTraceBuffer.readUTFBytes(this.mTraceBuffer.length));
                }
                else
                {
                    _loc_2 = this.mTraceBuffer.readUTFBytes(this.mTraceBuffer.length);
                }
                this.mTraceBuffer.length = 0;
                _loc_6 = int(getTimer() - this.mRecordingTraceTime);
                _loc_6 = _loc_6 / 100;
                Analytics.Track("Action", "RecordingSamples", "Recording Traces", _loc_6);
            }
            if (_loc_3)
            {
                startSampling();
            }
            return _loc_2;
        }// end function

        public function get FunctionCallHolder() : Dictionary
        {
            return this.mTempNoGCFunctionCallHolder;
        }// end function

        public function OnTraceReceive(fqcn:String, lineNumber:uint, methodName:String, methodArguments:String) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            if (this.mIsCollectingSamplesData)
            {
                this.mTempNoGCFunctionCallHolder[new FunctionCall(fqcn, lineNumber, methodName, methodArguments)] = true;
            }
            else
            {
                this.mTraceBuffer.writeUTFBytes(methodName);
                this.mTraceBuffer.writeByte(40);
                this.mTraceBuffer.writeByte(41);
                this.mTraceBuffer.writeByte(9);
                this.mTraceBuffer.writeUTFBytes(methodArguments);
                this.mTraceBuffer.writeByte(9);
                if (fqcn != null)
                {
                    this.mTraceBuffer.writeUTFBytes(fqcn);
                    this.mTraceBuffer.writeByte(9);
                    if (lineNumber > 0)
                    {
                        _loc_5 = lineNumber;
                        _loc_6 = 0;
                        _loc_7 = 0;
                        while (_loc_5 >= 1)
                        {
                            
                            _loc_7 = _loc_5 % 10;
                            this.mNumberStack[_loc_6] = _loc_7;
                            _loc_5 = _loc_5 / 10;
                            _loc_6 = _loc_6 + 1;
                        }
                        _loc_8 = _loc_6 - 1;
                        while (_loc_8 >= 0)
                        {
                            
                            this.mTraceBuffer.writeByte(48 + this.mNumberStack[_loc_8]);
                            _loc_8 = _loc_8 - 1;
                        }
                    }
                }
                this.mTraceBuffer.writeByte(13);
                this.mTraceBuffer.writeByte(10);
            }
            return;
        }// end function

    }
}
