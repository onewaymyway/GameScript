package view
{
    import Core.*;
    import Core.controller.*;
    import Core.model.data.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import gs.*;
    import model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomBgMediator extends Mediator implements IMediator
    {
        private var bg_frame:Object;
        private var bg_mc:Object;
        private var loaded_bg_mc:Object;
        private var loader:Loader;
        private var isAVM1:Boolean = true;
        private var bgurlBak:String = "";
        private var loaderI:uint = 0;
        private var waitSoundUrl:String = "";
        public var loadSound_wait:Sound;
        public var loadSound_day:Sound;
        public var loadSound_night:Sound;
        public var loadSound:Sound;
        private var tempst:SoundTransform;
        public var channel:SoundChannel;
        private var isSound:Boolean = true;
        private var isSoundReady:Boolean = true;
        private var mousePic_obj:Object;
        private var ShakeI:int = 0;
        private var ShakeXYArr:Array;
        private var volume:Number = 1;
        public static const NAME:String = "KillerRoomBgMediator";

        public function KillerRoomBgMediator(param1:Object = null)
        {
            this.loadSound_wait = new Sound();
            this.loadSound_day = new Sound();
            this.loadSound_night = new Sound();
            this.tempst = new SoundTransform();
            super(NAME, param1);
            this.waitSoundUrl = Resource.HTTP + "sounds/xxsg.mp3";
            this.loadSound_wait.load(new URLRequest(this.waitSoundUrl));
            this.loadSound_wait.addEventListener(IOErrorEvent.IO_ERROR, this.soundErrHandker);
            this.loadSound_day.load(new URLRequest(Resource.HTTP + "sounds/tll.mp3"));
            this.loadSound_day.addEventListener(IOErrorEvent.IO_ERROR, this.soundErrHandker);
            this.loadSound_night.load(new URLRequest(Resource.HTTP + "sounds/wyjh.mp3"));
            this.loadSound_night.addEventListener(IOErrorEvent.IO_ERROR, this.soundErrHandker);
            RoomData.Rooms.isSound = true;
            return;
        }// end function

        private function soundCompleteHandler(event:Event) : void
        {
            if (this.isSound)
            {
                this.channel = this.loadSound.play();
                if (this.channel)
                {
                    this.channel.soundTransform = new SoundTransform(this.volume);
                    this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                }
            }
            return;
        }// end function

        override public function onRegister() : void
        {
            this.loader = new Loader();
            this.bg_frame = this.viewComponent.addChild(new Sprite());
            this.bg_frame.x = (-(995 - MainData.MainStage.stageWidth)) / 2;
            this.bg_frame.y = (-(610 - MainData.MainStage.stageHeight)) / 2;
            this.ShakeXYArr = new Array();
            this.ShakeXYArr.push([0, 4]);
            this.ShakeXYArr.push([-5, 0]);
            this.ShakeXYArr.push([5, 1]);
            this.ShakeXYArr.push([0, 1]);
            this.ShakeXYArr.push([0, -7]);
            this.ShakeXYArr.push([-4, 0]);
            this.ShakeXYArr.push([2, 0]);
            this.ShakeXYArr.push([-1, -2]);
            this.ShakeXYArr.push([2, 0]);
            this.ShakeXYArr.push([-1, 0]);
            this.ShakeXYArr.push([0, 0]);
            if (UserData.UserInfo.Wintimes < 20)
            {
                this.bg_frame.addEventListener(MouseEvent.MOUSE_OVER, this.mouseStatusHandler);
                this.bg_frame.addEventListener(MouseEvent.MOUSE_OUT, this.mouseStatusHandler);
                this.bg_frame.mouseChildren = false;
                this.mousePic_obj = this.viewComponent.addChild(new mouse_pic_bg_log());
                this.mousePic_obj.mouseEnabled = false;
            }
            return;
        }// end function

        private function mouseStatusHandler(event:MouseEvent) : void
        {
            if (UserData.UserInfo.Wintimes >= 20)
            {
                this.bg_frame.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseStatusHandler);
                this.bg_frame.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseStatusHandler);
                this.viewComponent.removeChild(this.mousePic_obj);
                return;
            }
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
                    this.viewComponent.setChildIndex(this.mousePic_obj, (this.viewComponent.numChildren - 1));
                    this.mousePic_obj.startDrag(true);
                    if (KillerRoomData.beToolID != 0 && KillerRoomData.isCanTool)
                    {
                        if (SendTimeContrller.CanShowTool())
                        {
                            this.mousePic_obj.act("Tools");
                        }
                        else
                        {
                            this.mousePic_obj.act("nothing");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_CHECKACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Check");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_KILLACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Kill");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_REVOTEACT)
                    {
                        this.mousePic_obj.act("Revote");
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_VOTEACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Vote");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SNIPEACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Snipe");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAVEACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Save");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_BARRIERACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Barrier");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_GAGACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Gag");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_EXPLOSIONACT)
                    {
                        if (KillerRoomData.votePlayerID == 0)
                        {
                            this.mousePic_obj.act("Explosion");
                        }
                        else
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_NOTHING)
                    {
                        this.mousePic_obj.act("nothing");
                    }
                    else
                    {
                        this.mousePic_obj.act("nothing");
                    }
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    this.mousePic_obj.stopDrag();
                    this.mousePic_obj.act("nothing");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function onRemove() : void
        {
            this.loader.unload();
            if (this.bg_mc != null)
            {
                this.bg_mc.soundTransform = new SoundTransform(0);
            }
            if (this.channel)
            {
                this.channel.stop();
            }
            this.bg_mc = null;
            this.bgurlBak = "";
            mcFunc.removeAllMc(this.bg_frame);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [KillerRoomEvents.MOUSEACT_CHANGE, KillerRoomEvents.LOADBG, KillerRoomEvents.OUTROOM, KillerRoomEvents.SET_BG_STATES, KillerRoomEvents.SET_SOUND, KillerRoomEvents.LOAD_BG_SOUND, KillerRoomEvents.SHAKE_BG, KillerRoomEvents.PAUSE_BG_SOUND];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var surl:String;
            var s:SoundTransform;
            var sender:* = param1;
            switch(sender.getName())
            {
                case KillerRoomEvents.MOUSEACT_CHANGE:
                {
                    this.bg_frame.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
                    break;
                }
                case KillerRoomEvents.LOADBG:
                {
                    this.loadbg(Resource.HTTP + "bg/" + sender.getBody() + ".swf" + Resource.GetFileNameV(sender.getBody() + ".swf"));
                    surl = String(sender.getBody());
                    var _loc_4:int = 0;
                    var _loc_7:int = 0;
                    var _loc_8:* = KillerRoomData.RoomSetInfoXml.games;
                    var _loc_6:* = new XMLList("");
                    for each (_loc_9 in _loc_8)
                    {
                        
                        var _loc_10:* = _loc_8[_loc_7];
                        with (_loc_8[_loc_7])
                        {
                            if (@gametype == String(KillerRoomData.RoomInfo.GameType) && @linetype == String(MainData.getGameArea()))
                            {
                                _loc_6[_loc_7] = _loc_9;
                            }
                        }
                    }
                    var _loc_5:* = _loc_6.bglist.bg;
                    var _loc_3:* = new XMLList("");
                    for each (_loc_6 in _loc_5)
                    {
                        
                        var _loc_7:* = _loc_5[_loc_4];
                        with (_loc_5[_loc_4])
                        {
                            if (@value == surl)
                            {
                                _loc_3[_loc_4] = _loc_6;
                            }
                        }
                    }
                    surl = String(_loc_3.@music);
                    this.loadWaitSound(surl);
                    break;
                }
                case KillerRoomEvents.LOAD_BG_SOUND:
                {
                    surl = String(sender.getBody());
                    this.loadWaitSound(surl);
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    this.loader.unload();
                    if (this.bg_mc != null)
                    {
                        this.bg_mc.soundTransform = new SoundTransform(0);
                    }
                    if (this.channel)
                    {
                        this.channel.stop();
                    }
                    this.bg_mc = null;
                    this.bgurlBak = "";
                    mcFunc.removeAllMc(this.bg_frame);
                    break;
                }
                case KillerRoomEvents.SET_SOUND:
                {
                    s = sender.getBody() as SoundTransform;
                    if (s.volume == 0)
                    {
                        RoomData.Rooms.isSound = false;
                        this.isSound = false;
                        if (KillerRoomData.isKillGameType && this.isSoundReady)
                        {
                            if (this.channel)
                            {
                                this.channel.stop();
                            }
                        }
                        else if (KillerRoomData.RoomInfo.RoomStatus == 0)
                        {
                            if (this.channel)
                            {
                                this.channel.stop();
                            }
                        }
                    }
                    else
                    {
                        RoomData.Rooms.isSound = true;
                        this.isSound = true;
                        if (KillerRoomData.isKillGameType && this.isSoundReady && !KillerRoomData.isKillVoice)
                        {
                            this.channel = this.loadSound.play();
                            if (this.channel)
                            {
                                this.channel.soundTransform = new SoundTransform(this.volume);
                                this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                            }
                        }
                        else if (KillerRoomData.RoomInfo.RoomStatus == 0 && this.isSoundReady && !KillerRoomData.isKillVoice)
                        {
                            this.channel = this.loadSound.play();
                            if (this.channel)
                            {
                                this.channel.soundTransform = new SoundTransform(this.volume);
                                this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                            }
                        }
                    }
                    break;
                }
                case KillerRoomEvents.SHAKE_BG:
                {
                    this.ShakeI = 0;
                    this.bg_frame.removeEventListener(Event.ENTER_FRAME, this.bgShakeHandler);
                    this.bg_frame.addEventListener(Event.ENTER_FRAME, this.bgShakeHandler);
                    break;
                }
                case KillerRoomEvents.PAUSE_BG_SOUND:
                {
                    this.pauseBgSound(uint(sender.getBody()));
                    break;
                }
                case KillerRoomEvents.SET_BG_STATES:
                {
                    switch(uint(sender.getBody()))
                    {
                        case 0:
                        {
                            if (this.bg_mc)
                            {
                            }
                            if (this.channel)
                            {
                            }
                            if (this.isSound && this.isSoundReady && !KillerRoomData.isKillVoice)
                            {
                                if (this.channel)
                                {
                                }
                            }
                            break;
                        }
                        case 1:
                        {
                            if (this.channel)
                            {
                            }
                            if (this.isSound && this.isSoundReady)
                            {
                                if (this.channel)
                                {
                                }
                            }
                            if (this.bg_mc)
                            {
                            }
                            break;
                        }
                        case 2:
                        {
                            if (this.channel)
                            {
                            }
                            if (this.isSound && this.isSoundReady && !KillerRoomData.isKillVoice)
                            {
                                if (this.channel)
                                {
                                }
                            }
                            if (this.bg_mc)
                            {
                            }
                            break;
                        }
                        case 3:
                        {
                            if (this.channel)
                            {
                            }
                            if (this.isSound && this.isSoundReady && !KillerRoomData.isKillVoice)
                            {
                                if (this.channel)
                                {
                                }
                            }
                            if (this.bg_mc)
                            {
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    switch(uint(sender.getBody()))
                    {
                        case 0:
                        {
                            if (this.channel)
                            {
                            }
                            if (this.isSound && this.isSoundReady)
                            {
                                if (this.channel)
                                {
                                }
                            }
                            break;
                        }
                        default:
                        {
                            if (this.channel)
                            {
                            }
                            break;
                            break;
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function bgShakeHandler(event:Event) : void
        {
            if (this.ShakeI < this.ShakeXYArr.length)
            {
                this.bg_frame.x = (-(995 - MainData.MainStage.stageWidth)) / 2 + this.ShakeXYArr[this.ShakeI][0];
                this.bg_frame.y = (-(610 - MainData.MainStage.stageHeight)) / 2 + this.ShakeXYArr[this.ShakeI][1];
                var _loc_2:String = this;
                var _loc_3:* = this.ShakeI + 1;
                _loc_2.ShakeI = _loc_3;
            }
            else
            {
                this.ShakeI = 0;
                this.bg_frame.removeEventListener(Event.ENTER_FRAME, this.bgShakeHandler);
            }
            return;
        }// end function

        private function loadWaitSound(param1:String) : void
        {
            if (param1 != "" && this.waitSoundUrl != Resource.HTTP + "sounds/" + param1 + ".mp3")
            {
                this.waitSoundUrl = Resource.HTTP + "sounds/" + param1 + ".mp3";
                if (this.channel)
                {
                    this.channel.stop();
                }
                this.loadSound_wait = new Sound();
                this.loadSound_wait.load(new URLRequest(this.waitSoundUrl));
                this.loadSound = this.loadSound_wait;
                if (this.isSound && this.isSoundReady)
                {
                    this.channel = this.loadSound.play();
                    if (this.channel)
                    {
                        this.channel.soundTransform = new SoundTransform(this.volume);
                        this.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                    }
                }
            }
            return;
        }// end function

        private function loadbg(param1:String) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.loaderI + 1;
            _loc_2.loaderI = _loc_3;
            this.loader.unloadAndStop();
            if (this.bgurlBak != param1)
            {
                if (this.isAVM1)
                {
                    this.loader.unload();
                    this.bg_mc = null;
                    this.loader = new Loader();
                    this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderHandker);
                    this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loaderErrHandker);
                }
                else if (this.bg_mc != null)
                {
                    this.bg_mc.soundTransform = new SoundTransform(0);
                    this.bg_mc = null;
                }
                this.bgurlBak = param1;
                this.loader.load(new URLRequest(param1));
            }
            return;
        }// end function

        private function loaderHandker(event:Event) : void
        {
            this.loaderI = 0;
            if (event.target.content is AVM1Movie)
            {
                this.isAVM1 = true;
                this.reconfigureListeners(this.loader.contentLoaderInfo);
                this.bg_mc = null;
            }
            else
            {
                this.isAVM1 = false;
            }
            event.target.content.alpha = 0;
            this.bg_frame.addChild(event.target.content);
            TweenLite.to(event.target.content, 0.3, {alpha:1, onComplete:this.ShowBgTweenHandler, onCompleteParams:[event.target.content]});
            if (!this.bg_mc)
            {
                this.sendNotification(KillerRoomEvents.LOADED_BG);
            }
            return;
        }// end function

        private function ShowBgTweenHandler(param1:MovieClip) : void
        {
            if (mcFunc.hasTheChlid(this.bg_mc, this.bg_frame))
            {
                this.bg_frame.removeChild(this.bg_mc);
            }
            this.bg_mc = param1;
            return;
        }// end function

        private function reconfigureListeners(param1:IEventDispatcher) : void
        {
            param1.removeEventListener(Event.COMPLETE, this.loaderHandker);
            param1.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderErrHandker);
            return;
        }// end function

        private function loaderErrHandker(event:Event) : void
        {
            this.sendNotification(KillerRoomEvents.LOADED_BG);
            if (this.loaderI < 3)
            {
                this.loadbg(Resource.HTTP + "bg/bg.swf");
            }
            else
            {
                this.loaderI = 0;
            }
            return;
        }// end function

        private function soundErrHandker(event:Event) : void
        {
            this.isSoundReady = false;
            return;
        }// end function

        private function pauseBgSound(param1:Boolean) : void
        {
            if (this.channel)
            {
                if (param1)
                {
                    this.volume = 0;
                    this.channel.soundTransform = new SoundTransform(0);
                    if (this.bg_mc)
                    {
                        this.bg_mc.soundTransform = new SoundTransform(0);
                    }
                }
                else
                {
                    this.volume = 1;
                    if (this.bg_mc)
                    {
                        this.bg_mc.soundTransform = new SoundTransform(1);
                    }
                    this.channel.soundTransform = new SoundTransform(1);
                }
            }
            return;
        }// end function

    }
}
