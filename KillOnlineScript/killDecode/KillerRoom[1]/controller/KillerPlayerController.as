package controller
{
    import Core.*;
    import Core.controller.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import model.*;
    import roomEvents.*;
    import uas.*;

    public class KillerPlayerController extends Object
    {
        private var facade:Object;
        private var marry_type:marryLogo_Type_mc;
        private var level_logo:Object;
        public var player_figure:FiguresController;
        private var _playerInfo:Object;
        private var timerSayBox:Timer;
        private var petSprite:Object;
        private var mousePic_obj:Object;
        private var _iden:uint;
        public var toolsid:uint = 0;
        private var timerMouseLog:Timer;
        private var timerToolFace:Timer;
        public var isShowTool:Boolean = true;
        public var theFigureType:Object;
        public var theViewer:player_mc;
        private var isToolFigure:Boolean = false;
        private var theX:int;
        private var theY:int;

        public function KillerPlayerController(param1:player_mc)
        {
            var v:* = param1;
            this.theViewer = v;
            this.facade = MyFacade.getInstance();
            this.theViewer.host_mc.visible = false;
            this.theViewer.host_mc.mouseEnabled = false;
            this.theViewer.familyName_txt.mouseEnabled = false;
            this.theViewer.player_name_btn.mouseChildren = false;
            this.theViewer.player_name_btn.buttonMode = true;
            this.theViewer.player_name_btn.useHandCursor = true;
            this.theViewer.player_name_btn.addEventListener(MouseEvent.MOUSE_OVER, this.playernameMouseHandler);
            this.theViewer.player_name_btn.addEventListener(MouseEvent.MOUSE_OUT, this.playernameMouseHandler);
            this.theViewer.player_name_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.playernameMouseHandler);
            this.theViewer.mouseAct_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.playerMouseHandler);
            this.theViewer.mouseAct_btn.addEventListener(MouseEvent.MOUSE_OVER, this.playerMouseHandler);
            this.theViewer.mouseAct_btn.addEventListener(MouseEvent.MOUSE_OUT, this.playerMouseHandler);
            this.marry_type = new marryLogo_Type_mc();
            this.marry_type.y = -40;
            this.theViewer.addChild(this.marry_type);
            this.theViewer.setChildIndex(this.marry_type, (this.theViewer.getChildIndex(this.theViewer.figure_mc) + 1));
            if (MainData.getGameArea() == GameAreaType.spy)
            {
                this.level_logo = new Spylevel_log();
            }
            else
            {
                this.level_logo = new level_logo_m();
            }
            this.level_logo.x = 24;
            this.level_logo.y = -21;
            this.theViewer.addChild(this.level_logo as MovieClip);
            this.theViewer.setChildIndex(this.level_logo as MovieClip, (this.theViewer.getChildIndex(this.theViewer.figure_mc) + 1));
            this.timerToolFace = new Timer(1000, 2);
            this.timerToolFace.addEventListener(TimerEvent.TIMER_COMPLETE, this.timerToolFaceHandLer);
            this.timerMouseLog = new Timer(100);
            this.timerMouseLog.addEventListener(TimerEvent.TIMER, this.timerMouseLogHandLer);
            this.timerSayBox = new Timer(3 * 1000);
            this.timerSayBox.addEventListener(TimerEvent.TIMER, this.timerSayBoxHandLer);
            this.theViewer.sendTool_mc.stop();
            this.theViewer.setStates = function (param1:String) : void
            {
                states = param1;
                return;
            }// end function
            ;
            this.theViewer.clearSkin = function () : void
            {
                clearSkin();
                return;
            }// end function
            ;
            this.init();
            return;
        }// end function

        private function removeFromStageHandler(event:Event) : void
        {
            return;
        }// end function

        private function timerToolFaceHandLer(event:TimerEvent) : void
        {
            if (this.player_figure)
            {
                this.player_figure.theViewer.toolface_mc.visible = false;
                mcFunc.removeAllMc(this.player_figure.theViewer.toolface_mc);
            }
            return;
        }// end function

        private function timerMouseLogHandLer(event:TimerEvent) : void
        {
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
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Check");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_KILLACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite) || this.iden == 3)
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Kill");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_REVOTEACT)
            {
                if (this.states == "player")
                {
                    this.mousePic_obj.act("Revote");
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_VOTEACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Vote");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SNIPEACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Snipe");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAVEACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        this.mousePic_obj.act("Save");
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_BARRIERACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Barrier");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_GAGACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Gag");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_EXPLOSIONACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Explosion");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAgentACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("SAgent");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SpyACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Spy");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_CupidACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Cupid");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
                }
            }
            else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_RogueACT)
            {
                if (this.states == "player")
                {
                    if (KillerRoomData.votePlayerID == 0)
                    {
                        if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                        {
                            this.mousePic_obj.act("nothing");
                        }
                        else
                        {
                            this.mousePic_obj.act("Rogue");
                        }
                    }
                    else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                    {
                        this.mousePic_obj.act("Revote");
                    }
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
            return;
        }// end function

        private function playernameMouseHandler(event:MouseEvent) : void
        {
            switch(event.type)
            {
                case MouseEvent.MOUSE_DOWN:
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, this._playerInfo.UserId);
                    break;
                }
                case MouseEvent.MOUSE_OVER:
                {
                    this.theViewer.player_name_btn.player_name_txt.textColor = 16763904;
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    this.theViewer.player_name_btn.player_name_txt.textColor = 16777215;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function playerMouseHandler(event:MouseEvent) : void
        {
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
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
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Check");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_KILLACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite) || this.iden == 3)
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Kill");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_REVOTEACT)
                    {
                        if (this.states == "player")
                        {
                            this.mousePic_obj.act("Revote");
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_VOTEACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Vote");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAgentACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("SAgent");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SpyACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Spy");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_CupidACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Cupid");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_RogueACT)
                    {
                        if (this.states == "player")
                        {
                            if (KillerRoomData.votePlayerID == 0)
                            {
                                if (KillerRoomData.UserPlayerID == uint(this._playerInfo.RoomSite))
                                {
                                    this.mousePic_obj.act("nothing");
                                }
                                else
                                {
                                    this.mousePic_obj.act("Rogue");
                                }
                            }
                            else if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite))
                            {
                                this.mousePic_obj.act("Revote");
                            }
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
                    this.timerMouseLog.start();
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    this.timerMouseLog.stop();
                    this.mousePic_obj.stopDrag();
                    this.mousePic_obj.act("nothing");
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    if (KillerRoomData.beToolID != 0 && KillerRoomData.isCanTool)
                    {
                        if (SendTimeContrller.CanSendTool())
                        {
                            this.ActionTools(this._playerInfo.UserId);
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_CHECKACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Check(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_KILLACT)
                    {
                        if (this.states == "player" && this.iden != 3)
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Kill(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_VOTEACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Vote(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SNIPEACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Snipe(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAVEACT)
                    {
                        if (this.states == "player")
                        {
                            if (uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0)
                            {
                                this.Save(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_BARRIERACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Barrier(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_GAGACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Gag(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_EXPLOSIONACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Explosion(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SAgentACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.SAgent(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_SpyACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Spy(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_CupidACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Cupid(this._playerInfo.RoomSite);
                            }
                        }
                    }
                    else if (KillerRoomData.mouseAct == KillerRoomEvents.MOUSEACT_RogueACT)
                    {
                        if (this.states == "player")
                        {
                            if ((uint(KillerRoomData.votePlayerID) == uint(this._playerInfo.RoomSite) || KillerRoomData.votePlayerID == 0) && KillerRoomData.UserPlayerID != uint(this._playerInfo.RoomSite))
                            {
                                this.Rogue(this._playerInfo.RoomSite);
                            }
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
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function init() : void
        {
            this.theViewer.voted_num.visible = false;
            this.theViewer.vote_txt.visible = false;
            this.theViewer.ready_mc.visible = false;
            this.theViewer.host_mc.visible = false;
            this.theViewer.checked_mc.visible = false;
            this.theViewer.Identity_mc.visible = false;
            this.theViewer.thetools_mc.visible = true;
            this.theViewer.figure_mc.visible = true;
            this.toBeSave();
            this.theViewer.say_box.visible = false;
            this.theViewer.say_box.mouseChildren = false;
            this.theViewer.say_box.mouseEnabled = false;
            this.theViewer.mouseAct_btn.visible = false;
            this.theViewer.lastsay_box.visible = false;
            return;
        }// end function

        public function def() : void
        {
            if (this.player_figure)
            {
                this.player_figure.init();
            }
            this.theViewer.voted_num.visible = false;
            this.theViewer.vote_txt.visible = false;
            this.theViewer.ready_mc.visible = false;
            this.theViewer.checked_mc.visible = false;
            this.theViewer.Identity_mc.visible = false;
            this.theViewer.thetools_mc.visible = true;
            mcFunc.removeAllMc(this.theViewer.thetools_mc);
            this.theViewer.figure_mc.visible = true;
            this.theViewer.lastsay_box.visible = false;
            this.theViewer.mouseAct_btn.visible = true;
            if (this.petSprite)
            {
                this.petSprite.gotoAndStop("live");
            }
            this.toolsid = 0;
            this.theViewer.pet_mc.visible = true;
            return;
        }// end function

        public function setWhere(param1:int, param2:int) : void
        {
            var _loc_3:* = param1;
            this.theX = param1;
            this.theViewer.x = _loc_3;
            var _loc_3:* = param2;
            this.theY = param2;
            this.theViewer.y = _loc_3;
            return;
        }// end function

        public function set mousePicObj(param1:Object) : void
        {
            this.mousePic_obj = param1;
            return;
        }// end function

        public function updatePlayerInfo(param1:Object) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = this._playerInfo.states;
            this._playerInfo = new Object();
            this._playerInfo.states = _loc_2;
            for (_loc_3 in param1)
            {
                
                this._playerInfo[_loc_3] = param1[_loc_3];
            }
            return;
        }// end function

        public function set playerInfo(param1:Object) : void
        {
            var _loc_2:String = null;
            this.init();
            this._playerInfo = new Object();
            for (_loc_2 in param1)
            {
                
                this._playerInfo[_loc_2] = param1[_loc_2];
            }
            this.level = int(param1.Integral);
            this.playerType = param1.UserSex;
            this.site = param1.RoomSite;
            this.playerName = param1.UserName;
            this.familyName = param1.FamilyName;
            this.pet = String(this._playerInfo.Pet);
            this.saybg = String(this._playerInfo.Speak);
            this.votenumbg = String(this._playerInfo.Board);
            this.numbg = String(this._playerInfo.Gleis);
            if (uint(param1.UserId) == uint(UserData.UserInfo.UserId))
            {
            }
            return;
        }// end function

        public function get UserId() : Object
        {
            return this._playerInfo.UserId;
        }// end function

        public function get RoomSite() : Object
        {
            return this._playerInfo.RoomSite;
        }// end function

        public function get playerInfo() : Object
        {
            return this._playerInfo;
        }// end function

        public function set level(param1:int) : void
        {
            this.level_logo.setLevel(param1, false);
            return;
        }// end function

        public function set playerType(param1:String) : void
        {
            var _loc_2:Class = null;
            if (UserData.isToolFigure(this._playerInfo))
            {
                this.isToolFigure = true;
                if (this.theFigureType != this._playerInfo.UserToolState[10].toolid)
                {
                    mcFunc.removeAllMc(this.theViewer.figure_mc);
                    _loc_2 = getDefinitionByName("figure_tool") as Class;
                    this.player_figure = new FiguresFromToolController(new _loc_2);
                    this.theViewer.figure_mc.addChild(this.player_figure.theViewer);
                    this.player_figure.figure = "/resource/tool/" + this._playerInfo.UserToolState[10].toolid + ".swf";
                    this.theFigureType = this._playerInfo.UserToolState[10].toolid;
                }
                return;
            }
            this.isToolFigure = false;
            if (this.theFigureType != param1)
            {
                mcFunc.removeAllMc(this.theViewer.figure_mc);
                if (param1 == "0")
                {
                    _loc_2 = getDefinitionByName("figure_boy") as Class;
                }
                else
                {
                    _loc_2 = getDefinitionByName("figure_girl") as Class;
                }
                this.player_figure = new FiguresController(new _loc_2);
                this.theViewer.figure_mc.addChild(this.player_figure.theViewer);
                this.theFigureType = param1;
            }
            if (this._playerInfo.Hat)
            {
                this.player_figure.hat = this._playerInfo.Hat;
            }
            else
            {
                this.player_figure.hat = "null";
            }
            if (this._playerInfo.Face)
            {
                this.player_figure.face = this._playerInfo.Face;
            }
            else
            {
                this.player_figure.face = "null";
            }
            if (this._playerInfo.Wing)
            {
                this.player_figure.wing = this._playerInfo.Wing;
            }
            else
            {
                this.player_figure.wing = "null";
            }
            if (this._playerInfo.Halo)
            {
                this.player_figure.halo = this._playerInfo.Halo;
            }
            else
            {
                this.player_figure.halo = "null";
            }
            if (this._playerInfo.Head)
            {
                this.player_figure.head = this._playerInfo.Head;
            }
            else
            {
                this.player_figure.head = "null";
            }
            if (this._playerInfo.Cloth)
            {
                this.player_figure.cloth = this._playerInfo.Cloth;
            }
            else
            {
                this.player_figure.cloth = "null";
            }
            if (this._playerInfo.Ku)
            {
                this.player_figure.ku = this._playerInfo.Ku;
            }
            else
            {
                this.player_figure.ku = "null";
            }
            return;
        }// end function

        public function set toolface(param1:String) : void
        {
            if (this.isShowTool && !this.isToolFigure)
            {
                this.timerToolFace.stop();
                this.player_figure.theViewer.toolface_mc.visible = true;
                mcFunc.removeAllMc(this.player_figure.theViewer.toolface_mc);
                ViewPicLoad.load(param1, this.player_figure.theViewer.toolface_mc);
                this.timerToolFace.start();
            }
            return;
        }// end function

        public function set UserToolState(param1:Object) : void
        {
            this._playerInfo.UserToolState = param1;
            return;
        }// end function

        public function toolFigure(param1:String) : void
        {
            if (param1 && param1 != "undefined" && param1 != "null")
            {
                mcFunc.removeAllMc(this.theViewer.thetools_mc);
                this.playerType = this._playerInfo.UserSex;
            }
            else if (param1 == "null" || param1 == "")
            {
                mcFunc.removeAllMc(this.theViewer.thetools_mc);
                this.playerType = this._playerInfo.UserSex;
            }
            this.pet = String(this._playerInfo.Pet);
            this.saybg = String(this._playerInfo.Speak);
            this.votenumbg = String(this._playerInfo.Board);
            this.numbg = String(this._playerInfo.Gleis);
            return;
        }// end function

        public function set UserSex(param1:Object) : void
        {
            this._playerInfo.UserSex = param1;
            return;
        }// end function

        public function changePlayerType() : void
        {
            if (this.isToolFigure)
            {
                return;
            }
            this.playerType = this._playerInfo.UserSex;
            this.pet = String(this._playerInfo.Pet);
            this.saybg = String(this._playerInfo.Speak);
            this.votenumbg = String(this._playerInfo.Board);
            this.numbg = String(this._playerInfo.Gleis);
            return;
        }// end function

        public function set site(param1:uint) : void
        {
            this.theViewer.pid_txt.text = String(param1);
            return;
        }// end function

        public function set playerName(param1:String) : void
        {
            this.theViewer.player_name_btn.player_name_txt.autoSize = "left";
            this.theViewer.player_name_btn.player_name_txt.text = param1;
            this.theViewer.player_name_btn.player_name_txt.x = (-this.theViewer.player_name_btn.player_name_txt.width) / 2;
            return;
        }// end function

        public function set marryType(param1:uint) : void
        {
            if (param1 != 0)
            {
                this.marry_type.x = this.theViewer.player_name_btn.x + this.theViewer.player_name_btn.player_name_txt.x - 18;
                this.marry_type.gotoAndStop("type" + param1);
                this.marry_type.visible = true;
            }
            else
            {
                this.marry_type.visible = false;
            }
            return;
        }// end function

        public function set iden(param1:int) : void
        {
            this._iden = param1;
            this.theViewer.Identity_mc.gotoAndStop(param1);
            if (uint(this._playerInfo.UserId) == uint(UserData.UserInfo.UserId) && param1 > 1)
            {
                MainView.ReMoveToRandomXY(this.theViewer, 5, 8, this.theX, this.theY);
            }
            this.theViewer.Identity_mc.visible = true;
            return;
        }// end function

        public function get iden() : int
        {
            return this._iden;
        }// end function

        public function get states() : String
        {
            return this._playerInfo.states;
        }// end function

        public function set states(param1:String) : void
        {
            if (this.player_figure)
            {
                this.player_figure.theViewer.toolface_mc.visible = false;
                mcFunc.removeAllMc(this.player_figure.theViewer.toolface_mc);
            }
            if (this._playerInfo.states != param1)
            {
                this._playerInfo.states = param1;
                if (param1 == "player")
                {
                    this.isShowTool = true;
                    this.isCanClick = true;
                    this.iden = 0;
                    this.theViewer.pet_mc.visible = true;
                    this.player_figure.init();
                    this.ready = false;
                }
                else if (param1 == "viewer")
                {
                    this.isShowTool = false;
                    this.toBeSave();
                    this.theViewer.figure_mc.visible = true;
                    this.theViewer.thetools_mc.visible = false;
                    mcFunc.removeAllMc(this.theViewer.thetools_mc);
                    this.toolsid = 0;
                    this.isCanClick = true;
                    this.iden = 0;
                    this.theViewer.pet_mc.visible = false;
                    this.player_figure.isView();
                }
                else if (param1 == "dead")
                {
                    this.isShowTool = false;
                    this.theViewer.figure_mc.visible = true;
                    this.theViewer.thetools_mc.visible = false;
                    this.toBeSave();
                    mcFunc.removeAllMc(this.theViewer.thetools_mc);
                    this.toolsid = 0;
                    this.isCanClick = true;
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                    this.player_figure.setFace("death");
                }
                else if (param1 == "offliner")
                {
                    this.isShowTool = false;
                    this.toBeSave();
                    this.isCanClick = false;
                    this.theViewer.pet_mc.visible = false;
                    this.theViewer.host_mc.visible = false;
                    mcFunc.removeAllMc(this.theViewer.thetools_mc);
                    this.theViewer.thetools_mc.visible = false;
                    this.player_figure.isOffline();
                }
                else if (param1 == "ready")
                {
                    this.isCanClick = true;
                    this.ready = true;
                }
                else if (param1 == "wait")
                {
                    this.isShowTool = true;
                    this.toBeSave();
                    this.isCanClick = true;
                    this.iden = 0;
                    this.theViewer.pet_mc.visible = true;
                    this.player_figure.init();
                    this.ready = false;
                }
            }
            return;
        }// end function

        public function setOffLine(param1:uint) : void
        {
            return;
        }// end function

        public function toBeSave(param1:int = -1) : void
        {
            if (param1 == 1)
            {
                this.theViewer.saveAction_mc.visible = true;
                this.theViewer.saveAction_mc.gotoAndPlay(("Save" + 1));
            }
            else if (param1 == 0)
            {
                this.theViewer.saveAction_mc.visible = true;
                this.theViewer.saveAction_mc.gotoAndPlay("Save" + 0);
            }
            else if (param1 == 7)
            {
                this.beKilled(7);
            }
            else
            {
                this.theViewer.saveAction_mc.visible = false;
            }
            return;
        }// end function

        public function toBeKill(param1:String) : void
        {
            this.player_figure.theViewer.gotoAndStop(param1);
            return;
        }// end function

        public function toBeCupid() : void
        {
            this.theViewer.cupid_mc.play();
            return;
        }// end function

        public function beKilled(param1:uint) : void
        {
            this.theViewer.figure_mc.visible = true;
            this.theViewer.thetools_mc.visible = false;
            mcFunc.removeAllMc(this.theViewer.thetools_mc);
            this.isShowTool = false;
            if (this.states != "dead")
            {
                if (this.player_figure)
                {
                    this.player_figure.timer.stop();
                    mcFunc.removeAllMc(this.player_figure.theViewer.toolface_mc);
                }
                if (param1 == 1)
                {
                    this.player_figure.theViewer.gotoAndStop("kill1");
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                else if (param1 == 2)
                {
                    this.player_figure.theViewer.gotoAndStop("kill2");
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                else if (param1 == 3)
                {
                    this.player_figure.theViewer.gotoAndStop("kill3");
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                else if (param1 == 7)
                {
                    this.player_figure.theViewer.gotoAndStop("kill7");
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                else if (param1 == 10)
                {
                    this.player_figure.theViewer.gotoAndStop("kill10");
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                else
                {
                    this.player_figure.theViewer.gotoAndStop("kill" + param1);
                    if (this.petSprite)
                    {
                        this.petSprite.gotoAndStop("dead");
                    }
                }
                this._playerInfo.viewer = 4;
            }
            return;
        }// end function

        public function sendTool(param1:uint) : void
        {
            try
            {
                this.theViewer.sendTool_mc.num = param1;
                this.theViewer.sendTool_mc.gotoAndPlay(2);
                if (this.isShowTool)
                {
                    this.player_figure.setFace("haha");
                }
            }
            catch (e:ErrorEvent)
            {
            }
            return;
        }// end function

        public function set ready(param1:Boolean) : void
        {
            this.theViewer.ready_mc.visible = param1;
            return;
        }// end function

        public function set host(param1:Boolean) : void
        {
            this.theViewer.host_mc.visible = param1;
            return;
        }// end function

        public function set familyName(param1:String) : void
        {
            if (String(param1) != "null")
            {
                this.theViewer.familyName_txt.text = param1;
            }
            else
            {
                this.theViewer.familyName_txt.text = "";
            }
            return;
        }// end function

        public function set inter(param1:String) : void
        {
            var _loc_2:inter_mc = null;
            if (param1 != "0" && param1 != "" && param1 != "undefined" && param1 != "null")
            {
                _loc_2 = new inter_mc();
                _loc_2.x = 25;
                _loc_2.y = -75;
                _loc_2.showInter(param1);
                this.theViewer.addChild(_loc_2);
            }
            return;
        }// end function

        public function set interOther(param1:int) : void
        {
            var _loc_2:inter_o_mc = null;
            if (param1 != 0)
            {
                _loc_2 = new inter_o_mc();
                _loc_2.x = 25;
                _loc_2.y = -50;
                _loc_2.showInter(param1);
                this.theViewer.addChild(_loc_2);
            }
            return;
        }// end function

        public function set voteNum(param1:int) : void
        {
            if (param1 > 0)
            {
                this.theViewer.voted_num.visible = true;
                this.theViewer.voted_num.num_txt.text = String(param1);
            }
            else
            {
                this.theViewer.voted_num.visible = false;
            }
            return;
        }// end function

        public function set vote(param1:int) : void
        {
            if (param1 > 0)
            {
                this.theViewer.vote_txt.visible = true;
                this.theViewer.vote_txt.text = String(param1);
            }
            else
            {
                this.theViewer.vote_txt.visible = false;
            }
            return;
        }// end function

        public function set pet(param1:String) : void
        {
            var _loc_2:Loader = null;
            mcFunc.removeAllMc(this.theViewer.pet_mc);
            if (param1 != "null" && param1 != "undefined" && param1 != "0" && param1 != "")
            {
                _loc_2 = new Loader();
                _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadPet);
                _loc_2.load(new URLRequest(param1));
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.pet_mc);
                this.petSprite = null;
            }
            return;
        }// end function

        public function set isCanClick(param1:Boolean) : void
        {
            this.theViewer.mouseAct_btn.visible = param1;
            return;
        }// end function

        private function loadPet(event:Event) : void
        {
            this.petSprite = this.theViewer.pet_mc.addChild(event.target.content);
            if (this.states == "dead")
            {
                this.petSprite.gotoAndStop("dead");
            }
            return;
        }// end function

        public function cheked() : void
        {
            this.theViewer.checked_mc.visible = true;
            this.theViewer.checked_mc.gotoAndPlay(2);
            return;
        }// end function

        public function bodyFace(param1:String) : void
        {
            if (this.player_figure)
            {
                mcFunc.removeAllMc(this.player_figure.theViewer.toolface_mc);
            }
            this.player_figure.setFace(param1);
            return;
        }// end function

        public function set say(param1:String) : void
        {
            this.theViewer.setChildIndex(this.theViewer.say_box, (this.theViewer.numChildren - 1));
            this.theViewer.say_box.visible = true;
            this.theViewer.say_box.say_txt.htmlText = param1;
            this.timerSayBox.stop();
            this.timerSayBox.start();
            return;
        }// end function

        public function set lastSay(param1:String) : void
        {
            this.theViewer.setChildIndex(this.theViewer.lastsay_box, (this.theViewer.numChildren - 1));
            this.theViewer.lastsay_box.visible = true;
            this.theViewer.lastsay_box.say_txt.htmlText = param1;
            return;
        }// end function

        private function timerSayBoxHandLer(event:TimerEvent) : void
        {
            this.theViewer.say_box.visible = false;
            this.timerSayBox.stop();
            return;
        }// end function

        private function Vote(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Vote";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Kill(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Kill";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Check(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Check";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Snipe(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Snipe";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Barrier(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Barrier";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Gag(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Gag";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Explosion(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Explosion";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Save(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "Save";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function SAgent(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "SAgentAct";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Spy(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "SpyAct";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Cupid(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "CupidAct";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function Rogue(param1:uint) : void
        {
            if (KillerRoomData.votePlayerID == param1)
            {
                KillerRoomData.votePlayerID = 0;
            }
            else
            {
                KillerRoomData.votePlayerID = param1;
            }
            var _loc_2:* = new Object();
            _loc_2.Act = "RogueAct";
            _loc_2.Site = String(param1);
            _loc_2.cmd = "GameCmd_Act";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function ActionTools(param1:uint) : void
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            if (uint(KillerRoomData.gameStates) == 1)
            {
                if (uint(KillerRoomData.beToolID) == 167 || uint(KillerRoomData.beToolID) == 165 || uint(KillerRoomData.beToolID) == 158 || uint(KillerRoomData.beToolID) > 100000)
                {
                    _loc_3 = new AlertVO();
                    _loc_3.msg = "抱歉,晚上不能使用此道具";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    return;
                }
            }
            var _loc_2:* = new Object();
            if (uint(KillerRoomData.beToolID) == 788 || uint(KillerRoomData.beToolID) == 100788)
            {
                _loc_4 = new Object();
                _loc_4.url = Resource.HTTP + "plus/Tool788Form.swf";
                _loc_4.x = 0;
                _loc_4.y = 0;
                _loc_4.ToolId = String(KillerRoomData.beToolID);
                _loc_4.UserId = String(param1);
                this.facade.sendNotification(PlusMediator.ACTION, _loc_4);
                return;
            }
            if (uint(KillerRoomData.beToolID) == 726 || uint(KillerRoomData.beToolID) == 727 || uint(KillerRoomData.beToolID) == 728)
            {
                if (uint(UserData.UserInfo.UserId) != param1)
                {
                    _loc_5 = {UIP:KillerRoomData.UserPlayerID, ToUserId:param1, ToUserName:this._playerInfo.UserName, ToolId:KillerRoomData.beToolID};
                    this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_ADDWEDDING, _loc_5);
                }
                else
                {
                    _loc_3 = new AlertVO();
                    _loc_3.msg = "对不起，此道具不能对自己使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                }
            }
            else if (uint(KillerRoomData.beToolID) == 729)
            {
                _loc_2 = new Object();
                _loc_2.UserId = String(param1);
                _loc_2.ToUserId = String(param1);
                _loc_2.FromUserId = String(UserData.UserInfo.UserId);
                _loc_2.cmd = "VoiceCmd_Test";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (uint(KillerRoomData.beToolID) == 732 || uint(KillerRoomData.beToolID) == 100732)
            {
                if (uint(UserData.UserInfo.UserId) == param1)
                {
                    _loc_5 = {UIP:KillerRoomData.UserPlayerID, PIP:param1, TID:KillerRoomData.beToolID};
                    this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_CHANGENAME, _loc_5);
                }
                else
                {
                    _loc_6 = new AlertVO();
                    _loc_6.msg = "对不起，此道具只能对自己使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_6);
                }
            }
            else if (uint(KillerRoomData.beToolID) == 742)
            {
                _loc_5 = {UIP:KillerRoomData.UserPlayerID, PIP:param1, TID:KillerRoomData.beToolID};
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_BriDay, _loc_5);
            }
            else if (uint(KillerRoomData.beToolID) == 784 || uint(KillerRoomData.beToolID) == 100784)
            {
                if (uint(UserData.UserInfo.UserId) == param1)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "UseTool";
                    _loc_2.ToolId = String(KillerRoomData.beToolID);
                    _loc_2.UserId = String(param1);
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                else
                {
                    _loc_6 = new AlertVO();
                    _loc_6.msg = "对不起，此道具只能对自己使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_6);
                }
            }
            else
            {
                _loc_2 = new Object();
                _loc_2.cmd = "UseTool";
                _loc_2.ToolId = String(KillerRoomData.beToolID);
                _loc_2.UserId = String(param1);
                if (KillerRoomData.isToolSeries == 1)
                {
                    _loc_2.Num = String(KillerRoomData.toolSeriesNum);
                    KillerRoomData.seriesToolAct.start(_loc_2);
                }
                else
                {
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
            }
            return;
        }// end function

        private function regetVote(param1:Object) : void
        {
            KillerRoomData.votePlayerID = uint(param1);
            this.theViewer.mouseAct_btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            return;
        }// end function

        public function set saybg(param1:String) : void
        {
            var _loc_2:LoadSwfToMc = null;
            var _loc_3:LoadSwfToMc = null;
            if (param1 != "null" && param1 != "undefined" && param1 != "0" && param1 != "")
            {
                mcFunc.removeAllMc(this.theViewer.say_box.bg);
                _loc_2 = new LoadSwfToMc();
                _loc_2.load(param1, this.theViewer.say_box.bg);
                mcFunc.removeAllMc(this.theViewer.lastsay_box.bg);
                _loc_3 = new LoadSwfToMc();
                _loc_3.load(param1, this.theViewer.lastsay_box.bg);
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.say_box.bg);
                this.theViewer.say_box.bg.addChild(new player_saybg());
                this.theViewer.lastsay_box.bg.addChild(new player_saybg());
            }
            return;
        }// end function

        public function set votenumbg(param1:String) : void
        {
            var _loc_2:LoadSwfToMc = null;
            if (param1 != "null" && param1 != "undefined" && param1 != "0" && param1 != "")
            {
                mcFunc.removeAllMc(this.theViewer.voted_num.bg);
                _loc_2 = new LoadSwfToMc();
                _loc_2.load(param1, this.theViewer.voted_num.bg);
            }
            else
            {
                mcFunc.removeAllMc(this.theViewer.voted_num.bg);
                this.theViewer.voted_num.bg.addChild(new player_voteNumbg());
            }
            return;
        }// end function

        public function set numbg(param1:String) : void
        {
            var _loc_2:LoadSwfToMc = null;
            mcFunc.removeAllMc(this.theViewer.num_bg);
            if (param1 != "null" && param1 != "undefined" && param1 != "0" && param1 != "")
            {
                _loc_2 = new LoadSwfToMc();
                _loc_2.load(param1, this.theViewer.num_bg);
            }
            else if (uint(this._playerInfo.UserId) == uint(UserData.UserInfo.UserId))
            {
                this.theViewer.num_bg.addChild(new myGleisBg());
            }
            else
            {
                this.theViewer.num_bg.addChild(new otherGleisBg());
            }
            return;
        }// end function

        public function clear() : void
        {
            this.voteNum = 0;
            this._playerInfo = new Object();
            mcFunc.removeAllMc(this.theViewer.pet_mc);
            this.petSprite = null;
            this.player_figure.clear();
            mcFunc.removeAllMc(this.theViewer.figure_mc);
            this.player_figure = null;
            return;
        }// end function

        public function clearSkin() : void
        {
            if (this.player_figure)
            {
                var _loc_1:String = "null";
                this._playerInfo.Hat = "null";
                this.player_figure.hat = _loc_1;
                var _loc_1:String = "null";
                this._playerInfo.Face = "null";
                this.player_figure.face = _loc_1;
                var _loc_1:String = "null";
                this._playerInfo.Head = "null";
                this.player_figure.head = _loc_1;
                var _loc_1:String = "null";
                this._playerInfo.Cloth = "null";
                this.player_figure.cloth = _loc_1;
                var _loc_1:String = "null";
                this._playerInfo.Ku = "null";
                this.player_figure.ku = _loc_1;
            }
            return;
        }// end function

    }
}
