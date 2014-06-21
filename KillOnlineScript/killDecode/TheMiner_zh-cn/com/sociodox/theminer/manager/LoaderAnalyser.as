package com.sociodox.theminer.manager
{
    import com.sociodox.theminer.data.*;
    import com.sociodox.theminer.window.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.sampler.*;
    import flash.utils.*;

    public class LoaderAnalyser extends Object
    {
        private var mLoaderDict:Dictionary;
        private var mDisplayLoaderRef:Dictionary;
        private var mLoadersData:Array;
        private static var mInstance:LoaderAnalyser = null;

        public function LoaderAnalyser()
        {
            this.mLoadersData = new Array();
            this.mLoaderDict = new Dictionary(true);
            this.mDisplayLoaderRef = new Dictionary(true);
            return;
        }// end function

        public function Update() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:LoaderInfo = null;
            var _loc_3:LoaderData = null;
            for (_loc_1 in this.mDisplayLoaderRef)
            {
                
                if (_loc_1 == null)
                {
                    continue;
                }
                if (_loc_1 is SWFEntry)
                {
                    continue;
                }
                _loc_2 = _loc_1.contentLoaderInfo;
                if (_loc_2 == null)
                {
                    continue;
                }
                _loc_3 = this.mLoaderDict[_loc_2];
                if (_loc_3 == null)
                {
                }
            }
            return;
        }// end function

        public function GetLoadersData() : Array
        {
            return this.mLoadersData;
        }// end function

        public function PushLoader(aLoader) : void
        {
            var _loc_2:LoaderData = null;
            var _loc_3:SWFEntry = null;
            var _loc_4:Loader = null;
            var _loc_5:URLStream = null;
            var _loc_6:URLLoader = null;
            if (aLoader == null)
            {
                return;
            }
            if (aLoader is SWFEntry)
            {
                _loc_3 = aLoader as SWFEntry;
                if (aLoader == null)
                {
                    return;
                }
                _loc_2 = this.mLoaderDict[_loc_3];
                if (_loc_2 != null)
                {
                    return;
                }
                this.mDisplayLoaderRef[aLoader] = true;
                _loc_2 = new LoaderData();
                _loc_2.mFirstEvent = getTimer();
                _loc_2.mLoadedBytes = _loc_3.mBytes.length;
                _loc_2.mLoadedBytesText = String(_loc_2.mLoadedBytes);
                _loc_2.mProgress = 1;
                _loc_2.mProgressText = Localization.Lbl_LD_SwfLoaded;
                if (_loc_3.mUrl != null)
                {
                    _loc_2.mUrl = _loc_3.mUrl;
                }
                this.mLoadersData.push(_loc_2);
                this.mLoaderDict[_loc_3] = _loc_2;
                _loc_2.mType = LoaderData.SWF_LOADED;
                _loc_2.mLoadedData = _loc_3.mBytes;
            }
            else if (aLoader is Loader)
            {
                _loc_4 = aLoader;
                if (_loc_4.contentLoaderInfo == null)
                {
                    return;
                }
                _loc_2 = this.mLoaderDict[_loc_4.contentLoaderInfo];
                if (_loc_2 != null)
                {
                    return;
                }
                this.mDisplayLoaderRef[aLoader] = true;
                _loc_2 = new LoaderData();
                if (_loc_4.contentLoaderInfo.url != null)
                {
                    _loc_2.mUrl = _loc_4.contentLoaderInfo.url;
                }
                this.mLoadersData.push(_loc_2);
                this.mLoaderDict[_loc_4.contentLoaderInfo] = _loc_2;
                _loc_2.mType = LoaderData.DISPLAY_LOADER;
                this.configureListeners(_loc_4.contentLoaderInfo);
            }
            else if (aLoader is URLStream)
            {
                _loc_2 = this.mLoaderDict[aLoader];
                if (_loc_2 != null)
                {
                    return;
                }
                _loc_5 = aLoader;
                _loc_2 = new LoaderData();
                this.mLoaderDict[aLoader] = _loc_2;
                this.mLoadersData.push(_loc_2);
                _loc_2.mType = LoaderData.URL_STREAM;
                this.configureListeners(aLoader);
            }
            else if (aLoader is URLLoader)
            {
                _loc_2 = this.mLoaderDict[aLoader];
                if (_loc_2 != null)
                {
                    return;
                }
                _loc_6 = aLoader;
                _loc_2 = new LoaderData();
                this.mLoadersData.push(_loc_2);
                this.mLoaderDict[aLoader] = _loc_2;
                _loc_2.mType = LoaderData.URL_LOADER;
                this.configureListeners(aLoader);
            }
            return;
        }// end function

        private function configureListeners(dispatcher:IEventDispatcher) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:Boolean = true;
            var _loc_4:* = int.MAX_VALUE;
            dispatcher.addEventListener(Event.COMPLETE, this.completeHandler, _loc_2, _loc_4, _loc_3);
            dispatcher.addEventListener(Event.OPEN, this.openHandler, _loc_2, _loc_4, _loc_3);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, this.progressHandler, _loc_2, _loc_4, _loc_3);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler, _loc_2, _loc_4, _loc_3);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler, _loc_2, _loc_4, _loc_3);
            if (dispatcher is Loader)
            {
                dispatcher.addEventListener(Event.INIT, this.initHandler, _loc_2, _loc_4, _loc_3);
                dispatcher.addEventListener(Event.UNLOAD, this.unLoadHandler, _loc_2, _loc_4, _loc_3);
            }
            else if (dispatcher is URLLoader)
            {
                dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler, _loc_2, _loc_4, _loc_3);
            }
            else if (dispatcher is URLStream)
            {
                dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler, _loc_2, _loc_4, _loc_3);
            }
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_4:LoaderInfo = null;
            var _loc_5:ByteArray = null;
            var _loc_2:* = Configuration.IsSamplingRequired();
            pauseSampling();
            var _loc_3:* = this.mLoaderDict[event.target];
            if (_loc_3 != null)
            {
                if (_loc_3.mFirstEvent == -1)
                {
                    _loc_3.mFirstEvent = getTimer();
                }
                if (_loc_3.mIsFinished)
                {
                    _loc_3 = this.PreventReUse(_loc_3, event.target);
                }
                _loc_3.mProgress = 1;
                _loc_3.mProgressText = LoaderData.LOADER_STATUS_COMPLETED;
                _loc_3.mIsFinished = true;
                if (_loc_3.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_4 = event.target as LoaderInfo;
                    _loc_5 = new ByteArray();
                    _loc_4.bytes.position = 0;
                    _loc_4.bytes.readBytes(_loc_5, 0, _loc_4.bytes.length);
                    _loc_3.mLoadedData = null;
                    _loc_3.mUrl = event.target.url;
                }
                if (_loc_3.mUrl == null)
                {
                }
                if (_loc_3.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_3.mUrl = event.target.url;
                }
                else if (event.target is URLStream)
                {
                    _loc_3.mUrl = Localization.Lbl_LA_NoUrlStream;
                    _loc_3.mLoadedData = null;
                }
                if (event.target is URLLoader)
                {
                    _loc_3.mUrl = Localization.Lbl_LA_NoUrlLoader;
                    _loc_3.mLoadedData = null;
                }
            }
            if (_loc_2)
            {
                startSampling();
            }
            return;
        }// end function

        private function PreventReUse(ld:LoaderData, aLoader:Object) : LoaderData
        {
            var _loc_3:* = new LoaderData();
            _loc_3.mFirstEvent = getTimer();
            _loc_3.mType = ld.mType;
            this.mLoadersData.push(_loc_3);
            this.mLoaderDict[aLoader] = _loc_3;
            return _loc_3;
        }// end function

        private function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            var _loc_3:LoaderInfo = null;
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                _loc_2.mHTTPStatusText = event.status.toString();
                _loc_3 = event.target as LoaderInfo;
                if (_loc_3 != null)
                {
                    _loc_2.mUrl = _loc_3.url;
                }
                _loc_2.mStatus = event;
                if (_loc_2.mUrl == null)
                {
                }
            }
            return;
        }// end function

        private function initHandler(event:Event) : void
        {
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                _loc_2.mProgressText = Localization.Lbl_LA_Init;
                if (_loc_2.mUrl == null)
                {
                }
                if (_loc_2.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.mUrl = event.target.url;
                }
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            var _loc_3:Array = null;
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                _loc_2.mIOError = event;
                _loc_2.mProgressText = Localization.Lbl_LA_IOError;
                if (_loc_2.mUrl == null)
                {
                    _loc_2.mUrl = _loc_2.mIOError.text;
                    _loc_3 = event.text.split(Localization.Lbl_LA_URL);
                    if (_loc_3.length > 1)
                    {
                        _loc_2.mUrl = _loc_3[1];
                    }
                }
            }
            return;
        }// end function

        private function openHandler(event:Event) : void
        {
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                if (_loc_2.mUrl == null)
                {
                }
                if (_loc_2.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.mUrl = event.target.url;
                }
            }
            return;
        }// end function

        private function progressHandler(event:ProgressEvent) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:Number = NaN;
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                _loc_3 = false;
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
                if (Commands.mIsCollectingSamplesData)
                {
                    _loc_3 = true;
                    pauseSampling();
                }
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                if (event.bytesTotal > 0)
                {
                    _loc_4 = int(event.bytesLoaded / event.bytesTotal * 10000) / 100;
                    if (_loc_2.mProgress > event.bytesLoaded / event.bytesTotal)
                    {
                        _loc_2 = this.PreventReUse(_loc_2, event.target);
                    }
                    _loc_2.mLoadedBytes = int(event.bytesLoaded);
                    _loc_2.mLoadedBytesText = String(int(event.bytesLoaded));
                    _loc_2.mProgress = event.bytesLoaded / event.bytesTotal;
                    if (_loc_4 == 100)
                    {
                        _loc_2.mProgressText = LoaderData.LOADER_STATUS_COMPLETED;
                    }
                    else
                    {
                        _loc_2.mProgressText = _loc_4.toString() + Localization.Lbl_LA_Percent;
                    }
                }
                else
                {
                    if (_loc_2.mProgress > event.bytesLoaded)
                    {
                        _loc_2 = this.PreventReUse(_loc_2, event.target);
                    }
                    _loc_2.mLoadedBytes = int(event.bytesLoaded);
                    _loc_2.mLoadedBytesText = String(event.bytesLoaded);
                    _loc_2.mProgress = event.bytesLoaded;
                    _loc_2.mProgressText = int(_loc_2.mProgress).toString();
                }
                if (_loc_2.mUrl == null)
                {
                }
                if (_loc_2.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.mUrl = event.target.url;
                }
                if (_loc_3)
                {
                    startSampling();
                }
            }
            return;
        }// end function

        private function unLoadHandler(event:Event) : void
        {
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                _loc_2.mProgressText = Localization.Lbl_LA_Unload;
                if (_loc_2.mUrl == null)
                {
                }
                if (_loc_2.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.mUrl = event.target.url;
                }
            }
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            var _loc_2:* = this.mLoaderDict[event.target];
            if (_loc_2 != null)
            {
                if (_loc_2.mFirstEvent == -1)
                {
                    _loc_2.mFirstEvent = getTimer();
                }
                _loc_2.mSecurityError = event;
                _loc_2.mProgressText = Localization.Lbl_LA_SecurityError;
                if (_loc_2.mUrl == null)
                {
                }
                if (_loc_2.mType == LoaderData.DISPLAY_LOADER)
                {
                    _loc_2.mUrl = event.target.url;
                }
                else
                {
                    _loc_2.mUrl = _loc_2.mSecurityError.text;
                }
            }
            return;
        }// end function

        public static function GetInstance() : LoaderAnalyser
        {
            if (mInstance == null)
            {
                mInstance = new LoaderAnalyser;
            }
            return mInstance;
        }// end function

    }
}
