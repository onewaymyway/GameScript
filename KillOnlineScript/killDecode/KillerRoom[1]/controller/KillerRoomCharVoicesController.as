package controller
{
    import Core.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import model.*;
    import roomEvents.*;

    public class KillerRoomCharVoicesController extends Object
    {
        private var facade:Object;
        private var voices:Array;
        private var nowPlayerVo:KillerRoomCharVoicesVo = null;
        private var loadSound:Sound;
        private var channel:SoundChannel;
        private var isPlaying:Boolean = false;
        private var playingI:int = 0;
        private var IO_ERROR_I:int = 0;
        public static var s_VoicesController:KillerRoomCharVoicesController = null;

        public function KillerRoomCharVoicesController()
        {
            this.facade = MyFacade.getInstance();
            this.voices = new Array();
            return;
        }// end function

        public function addVoice(param1:KillerRoomCharVoicesVo) : void
        {
            this.voices.push(param1);
            if (!this.isPlaying)
            {
                this.playingI = this.voices.length - 1;
            }
            this.autoPlay();
            return;
        }// end function

        public function stopAllVoices() : void
        {
            this.voices.splice(0);
            this.isPlaying = false;
            this.playingI = 0;
            if (this.channel)
            {
                this.channel.stop();
                this.channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            }
            return;
        }// end function

        public function stopNowVoice() : void
        {
            if (this.channel)
            {
                this.channel.stop();
                this.channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            }
            if (this.nowPlayerVo)
            {
                this.nowPlayerVo.target.stopVoice();
                this.cleanOne(this.nowPlayerVo);
            }
            return;
        }// end function

        public function play(param1:KillerRoomCharVoicesVo = null) : void
        {
            var _loc_2:SoundLoaderContext = null;
            if (this.isPlaying && this.nowPlayerVo)
            {
                if (this.channel)
                {
                    this.channel.stop();
                    this.channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                }
                if (this.nowPlayerVo)
                {
                    this.nowPlayerVo.target.stopVoice();
                    this.cleanOne(this.nowPlayerVo);
                }
            }
            if (param1)
            {
                if (this.nowPlayerVo && param1.url == this.nowPlayerVo.url)
                {
                    this.nowPlayerVo.target.stopVoice();
                    this.nowPlayerVo = null;
                    this.isPlaying = false;
                    return;
                }
                this.nowPlayerVo = param1;
                this.isPlaying = true;
                this.nowPlayerVo.target.playVoice();
                this.loadSound = new Sound();
                _loc_2 = new SoundLoaderContext(2000);
                this.loadSound.load(new URLRequest(this.nowPlayerVo.url), _loc_2);
                this.channel = this.loadSound.play();
                this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 1);
                if (this.channel)
                {
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                }
            }
            return;
        }// end function

        public function autoPlay() : void
        {
            if (this.isPlaying || KillerRoomData.roomStates == 0)
            {
                this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 0);
                return;
            }
            if (this.voices[this.playingI])
            {
                this.isPlaying = true;
                this.nowPlayerVo = this.voices[this.playingI];
                this.nowPlayerVo.target.playVoice();
                if (this.loadSound)
                {
                    this.loadSound.removeEventListener(IOErrorEvent.IO_ERROR, this.soundIOErrHandler);
                }
                this.loadSound = new Sound();
                this.loadSound.load(new URLRequest(this.nowPlayerVo.url));
                this.loadSound.addEventListener(IOErrorEvent.IO_ERROR, this.soundIOErrHandler);
                this.channel = this.loadSound.play();
                this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 1);
                if (this.channel)
                {
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                }
            }
            else
            {
                this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 0);
            }
            return;
        }// end function

        private function soundIOErrHandler(event:Event) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.IO_ERROR_I + 1;
            _loc_2.IO_ERROR_I = _loc_3;
            if (this.IO_ERROR_I < 4)
            {
                this.isPlaying = false;
                this.autoPlay();
            }
            else
            {
                this.soundCompleteHandler(null);
            }
            return;
        }// end function

        private function soundCompleteHandler(event:Event) : void
        {
            this.IO_ERROR_I = 0;
            if (this.channel)
            {
                this.channel.stop();
                this.channel.removeEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
            }
            var _loc_2:int = -1;
            if (this.nowPlayerVo)
            {
                this.nowPlayerVo.target.stopVoice();
                _loc_2 = this.cleanOne(this.nowPlayerVo);
                if (_loc_2 == -1)
                {
                    this.isPlaying = false;
                    this.nowPlayerVo = null;
                    this.facade.sendNotification(KillerRoomEvents.PAUSE_BG_SOUND, 0);
                    return;
                }
                this.playingI = _loc_2;
            }
            this.nowPlayerVo = null;
            this.isPlaying = false;
            this.autoPlay();
            return;
        }// end function

        public function cleanOne(param1:KillerRoomCharVoicesVo) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.voices.length)
            {
                
                if (param1.url == this.voices[_loc_2].url)
                {
                    this.voices.splice(_loc_2, 1);
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public static function sharedController() : KillerRoomCharVoicesController
        {
            if (s_VoicesController == null)
            {
                s_VoicesController = new KillerRoomCharVoicesController;
            }
            return s_VoicesController;
        }// end function

    }
}
