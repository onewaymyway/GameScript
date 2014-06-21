package controller
{
    import Core.*;
    import Core.model.data.*;
    import com.adobe.format.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    import model.*;
    import roomEvents.*;

    public class RecVoiceController extends Object
    {
        private var facade:Object;
        private var _loader:URLLoader = null;
        public var isRecording:Boolean = false;
        public var isUpdating:Boolean = false;
        private var _recordByte:ByteArray;
        private var _microphone:Microphone;
        private var _timer:Timer;
        private var _times:int = 0;
        private var level:MovieClip;
        private var voiceBtn:SimpleButton;
        private var loadingMc:MovieClip;
        private var sendObj:Object;

        public function RecVoiceController(param1:MovieClip)
        {
            this._timer = new Timer(1000);
            this.facade = MyFacade.getInstance();
            this.voiceBtn = param1.voice_send_btn;
            this.loadingMc = param1.voiceLoading_mc;
            this.level = param1.voice_level;
            this.voiceBtn.addEventListener(MouseEvent.MOUSE_DOWN, this.voiceBtnHandler);
            this.voiceBtn.addEventListener(MouseEvent.MOUSE_OUT, this.voiceBtnHandler);
            this.voiceBtn.addEventListener(MouseEvent.MOUSE_UP, this.voiceBtnHandler);
            this.init();
            return;
        }// end function

        public function onRemove() : void
        {
            if (this.voiceBtn)
            {
                this.voiceBtn.removeEventListener(MouseEvent.MOUSE_DOWN, this.voiceBtnHandler);
                this.voiceBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.voiceBtnHandler);
                this.voiceBtn.removeEventListener(MouseEvent.MOUSE_UP, this.voiceBtnHandler);
            }
            if (this._loader)
            {
                this._loader.removeEventListener(Event.COMPLETE, this.onUploaded);
                this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.errHandler);
                this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errHandler);
            }
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.recStart);
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this._stopRecordHandler);
            }
            return;
        }// end function

        private function init() : void
        {
            this.loadingMc.visible = false;
            this._microphone = Microphone.getMicrophone();
            if (this._microphone == null)
            {
                return;
            }
            this._microphone.rate = 8;
            this._microphone.setLoopBack(false);
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, this.onUploaded);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.errHandler);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errHandler);
            this._timer.addEventListener(TimerEvent.TIMER, this.recStart);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this._stopRecordHandler);
            return;
        }// end function

        private function voiceBtnHandler(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.MOUSE_DOWN)
            {
                this._startRecHandler(null);
            }
            else if (event.type == MouseEvent.MOUSE_OUT)
            {
                this._stopRecordHandler(null);
            }
            else if (event.type == MouseEvent.MOUSE_UP)
            {
                if (!this.isRecording)
                {
                    return;
                }
                this._saveWavHandler();
            }
            return;
        }// end function

        private function recStart(event:Event = null) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._times + 1;
            _loc_2._times = _loc_3;
            if (this._times > 14)
            {
                this._saveWavHandler();
            }
            return;
        }// end function

        private function recEnd(event:Event = null) : void
        {
            this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 0);
            this.level.graphics.clear();
            this._timer.stop();
            return;
        }// end function

        private function _startRecHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (KillerRoomData.isBeGaged)
            {
                _loc_2 = new Object();
                _loc_2.code = "";
                _loc_2.arr = null;
                _loc_2.msg = "你被森林老人禁言了，下个白天自动解除";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
                return;
            }
            if (this._microphone == null)
            {
                _loc_2 = new Object();
                _loc_2.code = "";
                _loc_2.arr = null;
                _loc_2.msg = "对不起，你没有麦克风设备";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
                return;
            }
            if (this.isRecording || this.isUpdating)
            {
                return;
            }
            this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 1);
            this.isRecording = true;
            this._times = 0;
            this._timer.start();
            this._recordByte = new ByteArray();
            this._microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, this._microphoneSampleDataHandler);
            return;
        }// end function

        public function _stopRecordHandler(event:Event = null) : void
        {
            this.recEnd();
            if (!this.isRecording)
            {
                return;
            }
            this.isRecording = false;
            this._microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, this._microphoneSampleDataHandler);
            return;
        }// end function

        private function _microphoneSampleDataHandler(event:SampleDataEvent) : void
        {
            this.level.graphics.clear();
            this.level.graphics.beginFill(65280, 1);
            this.level.graphics.drawRect(0, 0, 22, (-this._microphone.activityLevel) * 0.5);
            this.level.graphics.endFill();
            this._recordByte.writeBytes(event.data);
            return;
        }// end function

        private function _saveWavHandler(event:Event = null) : void
        {
            var cmd:Object;
            var e:* = event;
            this._stopRecordHandler();
            if (!KillerRoomData.isCanChat)
            {
                return;
            }
            var _wavWriter:* = new WAVWriter();
            _wavWriter.numOfChannels = 1;
            _wavWriter.sampleBitRate = 8;
            _wavWriter.samplingRate = 8000;
            var _resultSamples:* = new ByteArray();
            this._recordByte.position = 0;
            if (!this._recordByte || this._recordByte.bytesAvailable <= 0)
            {
                cmd = new Object();
                cmd.code = "";
                cmd.arr = null;
                cmd.msg = "说话时间太短";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, cmd);
                this.isUpdating = false;
                this.loadingMc.visible = false;
                return;
            }
            _wavWriter.processSamples(_resultSamples, this._recordByte, _wavWriter.samplingRate, 1);
            var request:* = new URLRequest();
            request.method = URLRequestMethod.POST;
            request.contentType = "application/octet-stream";
            var url:String;
            url = url + ("times=" + this._times);
            url = url + ("&roomId=" + UserData.UserRoom);
            url = url + ("&userId=" + UserData.UserInfo.UserId);
            url = url + ("&line=" + MainData.LoginInfo.Id);
            var mp3Name:* = UserData.UserInfo.UserId + "_" + (new Date().minutes * 60 + new Date().getSeconds());
            url = url + ("&uploadFileName=" + mp3Name + ".wav");
            request.url = url;
            request.data = _resultSamples;
            try
            {
                this.isUpdating = true;
                this._loader.dataFormat = URLLoaderDataFormat.BINARY;
                this._loader.load(request);
                this.loadingMc.visible = true;
            }
            catch (error:Error)
            {
                isUpdating = false;
                loadingMc.visible = false;
            }
            return;
        }// end function

        private function errHandler(event:Event) : void
        {
            var _loc_2:* = new Object();
            _loc_2.code = "";
            _loc_2.arr = null;
            _loc_2.msg = "语音上传失败";
            this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            this.isUpdating = false;
            this.loadingMc.visible = false;
            return;
        }// end function

        private function onUploaded(event:Event) : void
        {
            this.sendObj = null;
            this.loadingMc.visible = false;
            this.isUpdating = false;
            return;
        }// end function

    }
}
