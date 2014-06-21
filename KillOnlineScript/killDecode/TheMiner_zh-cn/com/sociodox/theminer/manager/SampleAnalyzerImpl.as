package com.sociodox.theminer.manager
{
	
    import com.sociodox.theminer.TheMiner;
    import com.sociodox.theminer.data.ClassTypeStatsHolder;
    import com.sociodox.theminer.data.FunctionCall;
    import com.sociodox.theminer.data.InternalEventEntry;
    import com.sociodox.theminer.data.InternalEventsStatsHolder;
    import com.sociodox.theminer.window.Configuration;
    
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.LocalConnection;
    import flash.net.URLLoader;
    import flash.net.URLStream;
    import flash.sampler.DeleteObjectSample;
    import flash.sampler.NewObjectSample;
    import flash.sampler.Sample;
    import flash.sampler.StackFrame;
    import flash.sampler.clearSamples;
    import flash.sampler.getSamples;
    import flash.sampler.pauseSampling;
    import flash.sampler.setSamplerCallback;
    import flash.sampler.startSampling;
    import flash.sampler.stopSampling;
    import flash.system.ApplicationDomain;
    import flash.system.System;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import __AS3__.vec.Vector;

	
	
    public class SampleAnalyzerImpl extends Object
    {
        private var mInternalStats:InternalEventsStatsHolder;
        private var mFullObjectDict:Dictionary = null;
        private var mFullObjectInfoDict:Dictionary = null;
        public var mObjectTypeDict:Dictionary = null;
        public var mClassNameBuffer:Dictionary = null;
        private var mFunctionTimes:Dictionary = null;
        private var mFunctionTimesArray:Array = null;
        private var mStatsTypeList:Array = null;
        private var lastSampleTime:Number = 0;
        private var lastSample:Sample = null;
        private var mIsSampling:Boolean = false;
        private var mIsSamplingPaused:Boolean = false;
        private var mMinerInstance:TheMiner = null;
        private var tempArrayOut:ByteArray;
        private var mIsRecording:Boolean = false;
        public var mLineString:Dictionary;
        private var mNumberStack:Vector.<int>;
        private var mSamplingFrameCount:int = 0;
        private var mSocioTrace:String;
        private var mCurrentFrameID:int = 0;
        public var mFrameCounter:int = 0;
        public var mSamplerFrameCounter:int = 0;
        private static const INTERNAL_EVENT_VERIFY:String = "[verify]";
        private static const INTERNAL_EVENT_MARK:String = "[mark]";
        private static const INTERNAL_EVENT_REAP:String = "[reap]";
        private static const INTERNAL_EVENT_SWEEP:String = "[sweep]";
        private static const INTERNAL_EVENT_ENTERFRAME:String = "[enterFrameEvent]";
        private static const INTERNAL_EVENT_TIMER_TICK:String = "flash.utils::Timer/tick";
        private static const INTERNAL_EVENT_PRE_RENDER:String = "[pre-render]";
        private static const INTERNAL_EVENT_RENDER:String = "[render]";
        private static const INTERNAL_EVENT_AVM1:String = "[avm1]";
        private static const INTERNAL_EVENT_MOUSE:String = "[mouseEvent]";
        private static const INTERNAL_EVENT_IO:String = "[io]";
        private static const INTERNAL_EVENT_EXECUTE_QUEUE:String = "[execute-queued]";
        private static var mEnterFrameName:String = null;
        private static var FRAME_SAMPLE:ByteArray = new ByteArray();
        private static var OBJECT_COLLECTED:ByteArray = new ByteArray();
        private static var NEW_OBJECT_STRING:ByteArray = new ByteArray();
        private static var DELETE_OBJECT_STRING:ByteArray = new ByteArray();
        private static var BASE_OBJECT_STRING:ByteArray = new ByteArray();

        public function SampleAnalyzerImpl()
        {
            this.mInternalStats = new InternalEventsStatsHolder();
            this.tempArrayOut = new ByteArray();
            this.mLineString = new Dictionary(true);
            this.mNumberStack = new Vector.<int>(25, true);
            this.mFullObjectDict = new Dictionary();
            this.mFullObjectInfoDict = new Dictionary();
            this.mObjectTypeDict = new Dictionary();
            this.mClassNameBuffer = new Dictionary();
            this.mFunctionTimes = new Dictionary();
            this.mFunctionTimesArray = new Array();
            this.mStatsTypeList = new Array();
            this.lastSampleTime = 0;
            if (ApplicationDomain.currentDomain.hasDefinition("flash.sampler.setSamplerCallback"))
            {
                setSamplerCallback(this.SamplerCallBack);
            }
            FRAME_SAMPLE.writeUTFBytes("\t\t" + Localization.Lbl_SA_SamplingFrame + " ");
            NEW_OBJECT_STRING.writeUTFBytes("\t" + Localization.Lbl_SA_NewObject + "\t");
            OBJECT_COLLECTED.writeUTFBytes("\t" + Localization.Lbl_SA_Collected + "\t");
            DELETE_OBJECT_STRING.writeUTFBytes("\t" + Localization.Lbl_SA_DeletedObject + "\t");
            BASE_OBJECT_STRING.writeUTFBytes("\t" + Localization.Lbl_SA_BaseSample + "\t");
            return;
        }// end function

        public function Init(aMinerInstance:TheMiner) : void
        {
            this.mMinerInstance = aMinerInstance;
            var _loc_2:* = Configuration.IsSamplingRequired();
            pauseSampling();
            if (_loc_2)
            {
                startSampling();
            }
            this.mFrameCounter = 0;
            this.mSamplerFrameCounter = 0;
            return;
        }// end function

        public function StartSampling() : void
        {
            this.mIsSampling = true;
            this.mIsSamplingPaused = false;
            startSampling();
            return;
        }// end function

        public function PauseSampling() : void
        {
            if (this.mIsSampling)
            {
            }
            if (!this.mIsSamplingPaused)
            {
                pauseSampling();
                this.mIsSamplingPaused = true;
            }
            return;
        }// end function

        public function IsSamplingPaused() : Boolean
        {
            return this.mIsSamplingPaused;
        }// end function

        public function ResumeSampling() : void
        {
            if (this.mIsSampling)
            {
            }
            if (this.mIsSamplingPaused)
            {
                startSampling();
                this.mIsSamplingPaused = false;
            }
            return;
        }// end function

        public function StopSampling() : void
        {
            this.mIsSampling = false;
            this.mIsSamplingPaused = false;
            stopSampling();
            return;
        }// end function

        public function ClearSamples() : void
        {
            clearSamples();
            return;
        }// end function

        public function ForceGC() : void
        {
            try
            {
                System.gc();
            }
            catch (e:Error)
            {

               
            }
			try
			{ 
				new LocalConnection().connect("Force GC!");
				new LocalConnection().connect("Force GC!");
			}
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function GetInternalsEvents() : InternalEventsStatsHolder
        {
            return this.mInternalStats;
        }// end function

        public function GetFunctionTimes() : Array
        {
            return this.mFunctionTimesArray;
        }// end function

        public function GetClassInstanciationStats() : Array
        {
            return this.mStatsTypeList;
        }// end function

        public function GetFrameDataByteArray() : ByteArray
        {
            return this.tempArrayOut;
        }// end function

        public function ResetMemoryStats() : void
        {
            var _loc_1:ClassTypeStatsHolder = null;
            for each (_loc_1 in this.mStatsTypeList)
            {
                
                _loc_1.Added = 0;
                _loc_1.Removed = 0;
                _loc_1.Current = 0;
                _loc_1.Cumul = 0;
                _loc_1.AllocSize = 0;
                _loc_1.CollectSize = 0;
            }
            return;
        }// end function

        public function ResetPerformanceStats() : void
        {
            var _loc_1:InternalEventEntry = null;
            this.mFrameCounter = 0;
            this.mSamplerFrameCounter = 0;
            for each (_loc_1 in this.mFunctionTimes)
            {
                
                _loc_1.Clear();
            }
            return;
        }// end function

        private function SamplerCallBack(e = null) : void
        {
            pauseSampling();
            trace("The Miner: SamplerCallBack");
            this.ProcessSampling();
            startSampling();
            return;
        }// end function

        public function ProcessSampling() : void
        {
            var _loc_2:NewObjectSample = null;
            var _loc_3:DeleteObjectSample = null;
            var _loc_15:StackFrame = null;
            var _loc_16:String = null;
            var _loc_19:Sample = null;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:int = 0;
            var _loc_23:int = 0;
            var _loc_24:Number = NaN;
            var _loc_25:int = 0;
            var _loc_26:int = 0;
            var _loc_27:Class = null;
            var _loc_28:* = undefined;
            var _loc_29:Event = null;
            var _loc_30:FunctionCall = null;
            var _loc_31:int = 0;
            var _loc_32:Boolean = false;
            var _loc_33:String = null;
            var _loc_34:int = 0;
            var _loc_35:int = 0;
            var _loc_36:Boolean = false;
            var _loc_37:String = null;
            var _loc_38:StackFrame = null;
            var _loc_39:String = null;
            var _loc_40:* = undefined;
            var _loc_41:InternalEventEntry = null;
            var _loc_42:InternalEventEntry = null;
            var _loc_43:int = 0;
            var _loc_44:StackFrame = null;
            var _loc_45:String = null;
            var _loc_46:* = undefined;
            var _loc_47:InternalEventEntry = null;
            var _loc_48:String = null;
            var _loc_1:* = getSamples();
            var _loc_4:ClassTypeStatsHolder = null;
            var _loc_49:String = this;
            var _loc_50:* = this.mCurrentFrameID + 1;
            _loc_49.mCurrentFrameID = _loc_50;
            var _loc_49:String = this;
            var _loc_50:* = this.mFrameCounter + 1;
            _loc_49.mFrameCounter = _loc_50;
            var _loc_49:String = this;
            var _loc_50:* = this.mSamplerFrameCounter + 1;
            _loc_49.mSamplerFrameCounter = _loc_50;
            var _loc_5:String = null;
            var _loc_6:String = null;
            if (Commands.IsRecordingSamples)
            {
                if (!this.mIsRecording)
                {
                    this.tempArrayOut.length = 0;
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_Time);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_TimeDiff);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_SampleType);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_ObjectID);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_SampleSize);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_ObjectType);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_WasCollected);
                    this.tempArrayOut.writeByte(9);
                    this.tempArrayOut.writeUTFBytes(Localization.Lbl_SamplesDump_InstanciationStack);
                    this.tempArrayOut.writeByte(13);
                    this.tempArrayOut.writeByte(10);
                    this.mIsRecording = true;
                }
            }
            else
            {
                this.mIsRecording = false;
            }
            var _loc_7:Array = null;
            var _loc_8:* = Commands.IsRecordingSamples;
            if (!Configuration.PROFILE_LOADERS)
            {
            }
            var _loc_9:* = Configuration.COMMAND_LINE_SAMPLING_LSTENER;
            if (!Configuration.PROFILE_FUNCTION)
            {
            }
            var _loc_10:* = Configuration.COMMAND_LINE_SAMPLING_LSTENER;
            if (!Configuration.PROFILE_MEMORY)
            {
            }
            var _loc_11:* = Configuration.COMMAND_LINE_SAMPLING_LSTENER;
            if (!Configuration.PROFILE_INTERNAL_EVENTS)
            {
            }
            var _loc_12:* = Configuration.COMMAND_LINE_SAMPLING_LSTENER;
            var _loc_13:* = LoaderAnalyser.GetInstance();
            var _loc_14:int = 0;
            if (_loc_8)
            {
                var _loc_49:String = this;
                var _loc_50:* = this.mSamplingFrameCount + 1;
                _loc_49.mSamplingFrameCount = _loc_50;
            }
            else
            {
                this.mSamplingFrameCount = 0;
            }
            var _loc_17:Boolean = true;
            var _loc_18:int = 0;
            for each (_loc_19 in _loc_1)
            {
                
                if (_loc_19 == null)
                {
                    _loc_18 = _loc_18 + 1;
                    continue;
                }
                _loc_20 = _loc_19.time;
                if (this.lastSampleTime == 0)
                {
                    this.lastSampleTime = _loc_20;
                }
                _loc_21 = _loc_20 - this.lastSampleTime;
                _loc_22 = 0;
                _loc_4 = null;
                if (_loc_17)
                {
                    if (_loc_8)
                    {
                        _loc_24 = _loc_20;
                        _loc_22 = 0;
                        while (_loc_24 >= 1)
                        {
                            
                            _loc_26 = _loc_24 % 10;
                            this.mNumberStack[_loc_22] = _loc_26;
                            _loc_24 = _loc_24 / 10;
                            _loc_22 = _loc_22 + 1;
                        }
                        _loc_25 = _loc_22 - 1;
                        while (_loc_25 >= 0)
                        {
                            
                            this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                            _loc_25 = _loc_25 - 1;
                        }
                        this.tempArrayOut.writeBytes(FRAME_SAMPLE);
                        _loc_24 = this.mSamplingFrameCount;
                        _loc_22 = 0;
                        while (_loc_24 >= 1)
                        {
                            
                            _loc_26 = _loc_24 % 10;
                            this.mNumberStack[_loc_22] = _loc_26;
                            _loc_24 = _loc_24 / 10;
                            _loc_22 = _loc_22 + 1;
                        }
                        _loc_25 = _loc_22 - 1;
                        while (_loc_25 >= 0)
                        {
                            
                            this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                            _loc_25 = _loc_25 - 1;
                        }
                        this.tempArrayOut.writeByte(13);
                        this.tempArrayOut.writeByte(10);
                    }
                    _loc_17 = false;
                }
                _loc_2 = _loc_19 as NewObjectSample;
                _loc_7 = _loc_19.stack;
                _loc_23 = 0;
                _loc_24 = 0;
                _loc_25 = 0;
                if (_loc_2 != null)
                {
                    _loc_27 = _loc_2.type;
                    _loc_28 = _loc_2.object;
                    if (_loc_8)
                    {
                        if (_loc_27 == FunctionCall)
                        {
                            _loc_30 = _loc_28 as FunctionCall;
                            if (_loc_30 != null)
                            {
                                this.tempArrayOut.writeUTFBytes(_loc_30._methodName);
                                this.tempArrayOut.writeByte(40);
                                this.tempArrayOut.writeByte(41);
                                this.tempArrayOut.writeByte(9);
                                this.tempArrayOut.writeUTFBytes(_loc_30._methodArguments);
                                this.tempArrayOut.writeByte(9);
                                if (_loc_30._fqcn != null)
                                {
                                    this.tempArrayOut.writeUTFBytes(_loc_30._fqcn);
                                    this.tempArrayOut.writeByte(9);
                                    if (_loc_30._lineNumber > 0)
                                    {
                                        _loc_24 = _loc_30._lineNumber;
                                        _loc_22 = 0;
                                        _loc_26 = 0;
                                        while (_loc_24 >= 1)
                                        {
                                            
                                            _loc_26 = _loc_24 % 10;
                                            this.mNumberStack[_loc_22] = _loc_26;
                                            _loc_24 = _loc_24 / 10;
                                            _loc_22 = _loc_22 + 1;
                                        }
                                        _loc_31 = _loc_22 - 1;
                                        while (_loc_31 >= 0)
                                        {
                                            
                                            this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_31]);
                                            _loc_31 = _loc_31 - 1;
                                        }
                                    }
                                }
                                this.tempArrayOut.writeByte(13);
                                this.tempArrayOut.writeByte(10);
                                delete Commands.FunctionCallHolder[_loc_30];
                            }
                        }
                        else if (_loc_7 != null)
                        {
                            _loc_32 = false;
                            if (_loc_5 != null)
                            {
                                if (_loc_4 == null)
                                {
                                    _loc_4 = this.mObjectTypeDict[_loc_27] as ClassTypeStatsHolder;
                                }
                                _loc_32 = _loc_4.TypeName.indexOf(_loc_5) == -1;
                            }
                            if (!_loc_32)
                            {
                                _loc_23 = _loc_7.length;
                                _loc_24 = _loc_20;
                                _loc_22 = 0;
                                while (_loc_24 >= 1)
                                {
                                    
                                    _loc_26 = _loc_24 % 10;
                                    this.mNumberStack[_loc_22] = _loc_26;
                                    _loc_24 = _loc_24 / 10;
                                    _loc_22 = _loc_22 + 1;
                                }
                                _loc_25 = _loc_22 - 1;
                                while (_loc_25 >= 0)
                                {
                                    
                                    this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                    _loc_25 = _loc_25 - 1;
                                }
                                this.tempArrayOut.writeByte(9);
                                _loc_24 = _loc_21;
                                _loc_22 = 0;
                                while (_loc_24 >= 1)
                                {
                                    
                                    _loc_26 = _loc_24 % 10;
                                    this.mNumberStack[_loc_22] = _loc_26;
                                    _loc_24 = _loc_24 / 10;
                                    _loc_22 = _loc_22 + 1;
                                }
                                _loc_25 = _loc_22 - 1;
                                while (_loc_25 >= 0)
                                {
                                    
                                    this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                    _loc_25 = _loc_25 - 1;
                                }
                                this.tempArrayOut.writeBytes(NEW_OBJECT_STRING);
                                _loc_24 = _loc_2.id;
                                _loc_22 = 0;
                                while (_loc_24 >= 1)
                                {
                                    
                                    _loc_26 = _loc_24 % 10;
                                    this.mNumberStack[_loc_22] = _loc_26;
                                    _loc_24 = _loc_24 / 10;
                                    _loc_22 = _loc_22 + 1;
                                }
                                _loc_25 = _loc_22 - 1;
                                while (_loc_25 >= 0)
                                {
                                    
                                    this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                    _loc_25 = _loc_25 - 1;
                                }
                                this.tempArrayOut.writeByte(9);
                                _loc_33 = this.mLineString[_loc_2.size];
                                if (_loc_33 == null)
                                {
                                    var _loc_51:* = String(_loc_2.size);
                                    _loc_33 = String(_loc_2.size);
                                    this.mLineString[_loc_2.size] = _loc_51;
                                }
                                this.tempArrayOut.writeUTFBytes(_loc_33);
                                this.tempArrayOut.writeByte(9);
                                _loc_16 = this.mClassNameBuffer[_loc_27];
                                if (_loc_16 == null)
                                {
                                    var _loc_51:* = String(_loc_27);
                                    _loc_16 = String(_loc_27);
                                    this.mClassNameBuffer[_loc_27] = _loc_51;
                                }
                                this.tempArrayOut.writeUTFBytes(_loc_16);
                                if (_loc_2.object != null)
                                {
                                    this.tempArrayOut.writeByte(9);
                                    this.tempArrayOut.writeByte(9);
                                }
                                else
                                {
                                    this.tempArrayOut.writeBytes(OBJECT_COLLECTED);
                                }
                                _loc_14 = 0;
                                while (_loc_14 < _loc_23)
                                {
                                    
                                    _loc_15 = _loc_7[_loc_14];
                                    if (_loc_15.name != null)
                                    {
                                        this.tempArrayOut.writeUTFBytes(_loc_15.name);
                                        this.tempArrayOut.writeByte(40);
                                        this.tempArrayOut.writeByte(41);
                                    }
                                    if (_loc_15.file != null)
                                    {
                                        this.tempArrayOut.writeByte(91);
                                        this.tempArrayOut.writeUTFBytes(_loc_15.file);
                                        if (_loc_15.line > 0)
                                        {
                                            this.tempArrayOut.writeByte(58);
                                            _loc_33 = this.mLineString[_loc_15.line];
                                            if (_loc_33 == null)
                                            {
                                                var _loc_51:* = String(_loc_15.line);
                                                _loc_33 = String(_loc_15.line);
                                                this.mLineString[_loc_15.line] = _loc_51;
                                            }
                                            this.tempArrayOut.writeUTFBytes(_loc_33);
                                        }
                                        this.tempArrayOut.writeByte(93);
                                    }
                                    this.tempArrayOut.writeByte(44);
                                    _loc_14 = _loc_14 + 1;
                                }
                                this.tempArrayOut.writeByte(13);
                                this.tempArrayOut.writeByte(10);
                            }
                        }
                    }
                    _loc_29 = _loc_28 as Event;
                    if (_loc_29)
                    {
                    }
                    if (_loc_7 != null)
                    {
                    }
                    if (_loc_7.length == 1)
                    {
                        if (mEnterFrameName == null)
                        {
                            if (_loc_7[0].name == INTERNAL_EVENT_ENTERFRAME)
                            {
                                mEnterFrameName = _loc_7[0].name;
                            }
                        }
                        else if (mEnterFrameName === _loc_7[0].name)
                        {
                            this.mInternalStats.mFree.Add(_loc_21);
                        }
                        if (_loc_29.target === this.mMinerInstance)
                        {
                            this.lastSampleTime = _loc_20;
                            continue;
                        }
                    }
                    if (_loc_9)
                    {
                        if (_loc_28 is Loader)
                        {
                            _loc_13.PushLoader(_loc_28);
                        }
                        else if (_loc_28 is URLStream)
                        {
                            _loc_13.PushLoader(_loc_28);
                        }
                        else if (_loc_28 is URLLoader)
                        {
                            _loc_13.PushLoader(_loc_28);
                        }
                    }
                    if (_loc_11)
                    {
                        if (_loc_4 == null)
                        {
                            _loc_4 = this.mObjectTypeDict[_loc_27] as ClassTypeStatsHolder;
                        }
                        _loc_34 = 0;
                        if (_loc_2.size > 0)
                        {
                            _loc_34 = int(_loc_2.size);
                        }
                        if (_loc_4 == null)
                        {
                            _loc_4 = new ClassTypeStatsHolder();
                            _loc_4.Type = _loc_27;
                            _loc_4.TypeName = getQualifiedClassName(_loc_27);
                            this.mStatsTypeList.push(_loc_4);
                            this.mObjectTypeDict[_loc_27] = _loc_4;
                            this.mFullObjectDict[_loc_2.id] = _loc_4;
                            this.mFullObjectInfoDict[_loc_2.id] = _loc_34;
                            _loc_4.AllocSize = _loc_4.AllocSize + _loc_34;
                        }
                        else
                        {
                            if (this.mCurrentFrameID != _loc_4.mFrameID)
                            {
                                _loc_4.AddedFrame = 0;
                                _loc_4.RemovedFrame = 0;
                                _loc_4.mFrameID = this.mCurrentFrameID;
                            }
                            var _loc_51:* = _loc_4;
                            var _loc_52:* = _loc_4.AddedFrame + 1;
                            _loc_51.AddedFrame = _loc_52;
                            var _loc_51:* = _loc_4;
                            var _loc_52:* = _loc_4.Added + 1;
                            _loc_51.Added = _loc_52;
                            var _loc_51:* = _loc_4;
                            var _loc_52:* = _loc_4.Cumul + 1;
                            _loc_51.Cumul = _loc_52;
                            var _loc_51:* = _loc_4;
                            var _loc_52:* = _loc_4.Current + 1;
                            _loc_51.Current = _loc_52;
                            this.mFullObjectDict[_loc_2.id] = _loc_4;
                            this.mFullObjectInfoDict[_loc_2.id] = _loc_34;
                            _loc_4.AllocSize = _loc_4.AllocSize + _loc_34;
                        }
                    }
                }
                else
                {
                    var _loc_51:* = _loc_19 as DeleteObjectSample;
                    _loc_3 = _loc_19 as DeleteObjectSample;
                    if (_loc_51 != null)
                    {
                        _loc_4 = this.mFullObjectDict[_loc_3.id];
                        _loc_35 = this.mFullObjectInfoDict[_loc_3.id];
                        if (_loc_4)
                        {
                            delete this.mFullObjectDict[_loc_4];
                            delete this.mFullObjectInfoDict[_loc_4];
                        }
                        if (_loc_8)
                        {
                        }
                        if (_loc_4 != null)
                        {
                            if (_loc_4.Type != FunctionCall)
                            {
                                _loc_36 = false;
                                if (_loc_5 != null)
                                {
                                    _loc_36 = _loc_4.TypeName.indexOf(_loc_5) == -1;
                                }
                                if (!_loc_36)
                                {
                                    _loc_24 = _loc_20;
                                    _loc_22 = 0;
                                    while (_loc_24 >= 1)
                                    {
                                        
                                        _loc_26 = _loc_24 % 10;
                                        this.mNumberStack[_loc_22] = _loc_26;
                                        _loc_24 = _loc_24 / 10;
                                        _loc_22 = _loc_22 + 1;
                                    }
                                    _loc_25 = _loc_22 - 1;
                                    while (_loc_25 >= 0)
                                    {
                                        
                                        this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                        _loc_25 = _loc_25 - 1;
                                    }
                                    this.tempArrayOut.writeByte(9);
                                    _loc_24 = _loc_21;
                                    _loc_22 = 0;
                                    while (_loc_24 >= 1)
                                    {
                                        
                                        _loc_26 = _loc_24 % 10;
                                        this.mNumberStack[_loc_22] = _loc_26;
                                        _loc_24 = _loc_24 / 10;
                                        _loc_22 = _loc_22 + 1;
                                    }
                                    _loc_25 = _loc_22 - 1;
                                    while (_loc_25 >= 0)
                                    {
                                        
                                        this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                        _loc_25 = _loc_25 - 1;
                                    }
                                    this.tempArrayOut.writeBytes(DELETE_OBJECT_STRING);
                                    _loc_24 = _loc_3.id;
                                    _loc_22 = 0;
                                    while (_loc_24 >= 1)
                                    {
                                        
                                        _loc_26 = _loc_24 % 10;
                                        this.mNumberStack[_loc_22] = _loc_26;
                                        _loc_24 = _loc_24 / 10;
                                        _loc_22 = _loc_22 + 1;
                                    }
                                    _loc_25 = _loc_22 - 1;
                                    while (_loc_25 >= 0)
                                    {
                                        
                                        this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                        _loc_25 = _loc_25 - 1;
                                    }
                                    this.tempArrayOut.writeByte(9);
                                    _loc_37 = this.mLineString[_loc_3.size];
                                    if (_loc_37 == null)
                                    {
                                        var _loc_51:* = String(_loc_3.size);
                                        _loc_37 = String(_loc_3.size);
                                        this.mLineString[_loc_3.size] = _loc_51;
                                    }
                                    this.tempArrayOut.writeUTFBytes(_loc_37);
                                    if (_loc_4 != null)
                                    {
                                        this.tempArrayOut.writeByte(9);
                                        _loc_16 = this.mClassNameBuffer[_loc_4.Type];
                                        if (_loc_16 == null)
                                        {
                                            var _loc_51:* = String(_loc_4.Type);
                                            _loc_16 = String(_loc_4.Type);
                                            this.mClassNameBuffer[_loc_4.Type] = _loc_51;
                                        }
                                        this.tempArrayOut.writeUTFBytes(_loc_16);
                                    }
                                    this.tempArrayOut.writeByte(13);
                                    this.tempArrayOut.writeByte(10);
                                }
                            }
                        }
                        if (_loc_11)
                        {
                            if (_loc_4 != null)
                            {
                                if (this.mCurrentFrameID != _loc_4.mFrameID)
                                {
                                    _loc_4.AddedFrame = 0;
                                    _loc_4.RemovedFrame = 0;
                                    _loc_4.mFrameID = this.mCurrentFrameID;
                                }
                                var _loc_51:* = _loc_4;
                                var _loc_52:* = _loc_4.RemovedFrame + 1;
                                _loc_51.RemovedFrame = _loc_52;
                                var _loc_51:* = _loc_4;
                                var _loc_52:* = _loc_4.Removed + 1;
                                _loc_51.Removed = _loc_52;
                                if (_loc_4.Current > 0)
                                {
                                    var _loc_51:* = _loc_4;
                                    var _loc_52:* = _loc_4.Current - 1;
                                    _loc_51.Current = _loc_52;
                                }
                                if (_loc_3.size)
                                {
                                    _loc_4.CollectSize = _loc_4.CollectSize + _loc_3.size;
                                }
                                if (_loc_3.size > _loc_35)
                                {
                                    _loc_4.AllocSize = _loc_4.AllocSize + (_loc_3.size - _loc_35);
                                }
                            }
                            else
                            {
                                _loc_18 = _loc_18 + 1;
                            }
                        }
                    }
                    else
                    {
                        _loc_23 = _loc_7.length;
                        if (_loc_8)
                        {
                            if (_loc_7 != null)
                            {
                                if (_loc_6)
                                {
                                    _loc_38 = _loc_7[0];
                                    _loc_39 = _loc_38.name;
                                    _loc_40 = this.mFunctionTimes[_loc_39];
                                    if (_loc_40 != null)
                                    {
                                        _loc_41 = _loc_40 as InternalEventEntry;
                                        _loc_32 = _loc_41.qName.indexOf(_loc_6) == -1;
                                    }
                                }
                                if (!_loc_32)
                                {
                                    _loc_24 = _loc_20;
                                    _loc_22 = 0;
                                    while (_loc_24 >= 1)
                                    {
                                        
                                        _loc_26 = _loc_24 % 10;
                                        this.mNumberStack[_loc_22] = _loc_26;
                                        _loc_24 = _loc_24 / 10;
                                        _loc_22 = _loc_22 + 1;
                                    }
                                    _loc_25 = _loc_22 - 1;
                                    while (_loc_25 >= 0)
                                    {
                                        
                                        this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                        _loc_25 = _loc_25 - 1;
                                    }
                                    this.tempArrayOut.writeByte(9);
                                    _loc_24 = _loc_21;
                                    _loc_22 = 0;
                                    while (_loc_24 >= 1)
                                    {
                                        
                                        _loc_26 = _loc_24 % 10;
                                        this.mNumberStack[_loc_22] = _loc_26;
                                        _loc_24 = _loc_24 / 10;
                                        _loc_22 = _loc_22 + 1;
                                    }
                                    _loc_25 = _loc_22 - 1;
                                    while (_loc_25 >= 0)
                                    {
                                        
                                        this.tempArrayOut.writeByte(48 + this.mNumberStack[_loc_25]);
                                        _loc_25 = _loc_25 - 1;
                                    }
                                    this.tempArrayOut.writeBytes(BASE_OBJECT_STRING);
                                    this.tempArrayOut.writeByte(9);
                                    this.tempArrayOut.writeByte(9);
                                    this.tempArrayOut.writeByte(9);
                                    this.tempArrayOut.writeByte(9);
                                    _loc_14 = 0;
                                    while (_loc_14 < _loc_23)
                                    {
                                        
                                        _loc_15 = _loc_7[_loc_14];
                                        if (_loc_15.name != null)
                                        {
                                            this.tempArrayOut.writeUTFBytes(_loc_15.name);
                                            this.tempArrayOut.writeByte(40);
                                            this.tempArrayOut.writeByte(41);
                                        }
                                        if (_loc_15.file != null)
                                        {
                                            this.tempArrayOut.writeByte(91);
                                            this.tempArrayOut.writeUTFBytes(_loc_15.file);
                                            if (_loc_15.line > 0)
                                            {
                                                this.tempArrayOut.writeByte(58);
                                                _loc_33 = this.mLineString[_loc_15.line];
                                                if (_loc_33 == null)
                                                {
                                                    var _loc_51:* = String(_loc_15.line);
                                                    _loc_33 = String(_loc_15.line);
                                                    this.mLineString[_loc_15.line] = _loc_51;
                                                }
                                                this.tempArrayOut.writeUTFBytes(_loc_33);
                                            }
                                            this.tempArrayOut.writeByte(93);
                                        }
                                        this.tempArrayOut.writeByte(44);
                                        _loc_14 = _loc_14 + 1;
                                    }
                                    this.tempArrayOut.writeByte(13);
                                    this.tempArrayOut.writeByte(10);
                                }
                            }
                        }
                        if (_loc_10)
                        {
                            _loc_43 = 0;
                            while (_loc_43 < _loc_23)
                            {
                                
                                _loc_44 = _loc_7[_loc_43];
                                _loc_45 = _loc_44.name;
                                _loc_46 = this.mFunctionTimes[_loc_45];
                                if (_loc_46 == undefined)
                                {
                                    _loc_46 = new InternalEventEntry();
                                    _loc_46.SetStack(_loc_7);
                                    _loc_46.qName = _loc_45;
                                    this.mFunctionTimesArray.push(_loc_46);
                                    this.mFunctionTimes[_loc_45] = _loc_46;
                                    if (_loc_45.indexOf("sociodox") != -1)
                                    {
                                        _loc_46.needSkip = true;
                                    }
                                    if (_loc_45.indexOf("sampler::") != -1)
                                    {
                                        _loc_46.needSkip = true;
                                    }
                                }
                                _loc_47 = _loc_46;
                                if (_loc_43 == 0)
                                {
                                    _loc_42 = _loc_46;
                                    if (_loc_47.lastUpdateId != _loc_20)
                                    {
                                        _loc_47.Add(_loc_21, _loc_20);
                                    }
                                }
                                else
                                {
                                    if (_loc_42 != _loc_46)
                                    {
                                    }
                                    if (_loc_47.lastUpdateId != _loc_20)
                                    {
                                        _loc_47.AddParentTime(_loc_21, _loc_20);
                                    }
                                }
                                _loc_43 = _loc_43 + 1;
                            }
                        }
                        if (_loc_12)
                        {
                            _loc_48 = null;
                            if (_loc_48 == null)
                            {
                                _loc_48 = _loc_7[(_loc_23 - 1)].name;
                            }
                            switch(_loc_48)
                            {
                                case INTERNAL_EVENT_ENTERFRAME:
                                {
                                    this.mInternalStats.mEnterFrame.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_MARK:
                                {
                                    this.mInternalStats.mMark.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_REAP:
                                {
                                    this.mInternalStats.mReap.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_SWEEP:
                                {
                                    this.mInternalStats.mSweep.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_PRE_RENDER:
                                {
                                    this.mInternalStats.mPreRender.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_RENDER:
                                {
                                    this.mInternalStats.mRender.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_VERIFY:
                                {
                                    this.mInternalStats.mVerify.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_TIMER_TICK:
                                {
                                    this.mInternalStats.mTimers.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_AVM1:
                                {
                                    this.mInternalStats.mAvm1.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_MOUSE:
                                {
                                    this.mInternalStats.mMouse.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_IO:
                                {
                                    this.mInternalStats.mIo.Add(_loc_21);
                                    break;
                                }
                                case INTERNAL_EVENT_EXECUTE_QUEUE:
                                {
                                    this.mInternalStats.mExecuteQueue.Add(_loc_21);
                                    break;
                                }
                                default:
                                {
                                    break;
                                    break;
                                }
                            }
                        }
                    }
                }
                this.lastSampleTime = _loc_20;
            }
            this.lastSample = _loc_19;
            clearSamples();
            return;
        }// end function

    }
}
