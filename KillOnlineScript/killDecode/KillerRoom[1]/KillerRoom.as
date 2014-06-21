package 
{
    import Core.*;
    import Core.model.*;
    import Core.model.data.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import model.*;
    import roomEvents.*;
    import uas.*;
    import view.*;

    public class KillerRoom extends Sprite
    {
        private var myFacade:MyFacade;
        private var netproxy:NetProxy;
        private var srcArr:Array;
        private var srcI:uint = 0;
        private var srcLoader:LoadSwfsrc = null;

        public function KillerRoom()
        {
            this.srcArr = new Array();
            new SelectOneBox();
            this.srcArr.push("killerroomswf/RoomUserbox.swf");
            this.srcArr.push("killerroomswf/player.swf");
            this.srcArr.push("killerroomswf/toollist.swf");
            this.srcArr.push("killerroomswf/playerslist.swf");
            this.srcArr.push("killerroomswf/KillerRoomChat.swf");
            this.srcArr.push("killerroomswf/killerRoomBtns.swf");
            this.srcArr.push("killerroomswf/KillerRoomMenu.swf");
            this.srcArr.push("killerroomswf/GameOver.swf");
            this.myFacade = MyFacade.getInstance();
            this.netproxy = this.myFacade.retrieveProxy(NetProxy.NAME) as NetProxy;
            this.loadSwfsrc();
            this.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        public function init(event:Event) : void
        {
            this.netproxy.setClient(new KillerRoomClient());
            return;
        }// end function

        public function register() : void
        {
            var _loc_1:KillerRoomMainMediator = null;
            var _loc_2:KillerRoomChatMediaor = null;
            RoomData.Rooms.UserPlayerID = 0;
            RoomData.Rooms.UserHost = 0;
            this.netproxy.setClient(new KillerRoomClient());
            if (MainData.isKillRoomScenced == 0)
            {
                if (this.myFacade.hasMediator(KillerRoomBgMediator.NAME))
                {
                    this.myFacade.removeMediator(KillerRoomBgMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomPlayersMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomChatMediaor.NAME);
                    this.myFacade.removeMediator(KillerRoomPlugGameMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomToolBoxMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomPlayerListBoxMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomMainMediator.NAME);
                    mcFunc.removeAllMc(this);
                }
                this.myFacade.registerMediator(new KillerRoomBgMediator(this));
                this.myFacade.registerMediator(new KillerRoomPlayersMediator(this));
                this.myFacade.registerMediator(new KillerRoomChatMediaor(this));
                this.myFacade.registerMediator(new KillerRoomPlugGameMediator(this));
                this.myFacade.registerMediator(new KillerRoomToolBoxMediator(this));
                this.myFacade.registerMediator(new KillerRoomPlayerListBoxMediator(this));
                this.myFacade.registerMediator(new KillerRoomMainMediator(this));
                MainData.isKillRoomScenced = 1;
            }
            else
            {
                if (this.myFacade.hasMediator(KillerRoomMainMediator.NAME))
                {
                    _loc_1 = this.myFacade.retrieveMediator(KillerRoomMainMediator.NAME) as KillerRoomMainMediator;
                    this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING_AND_BG, {msg:"读取场景资料..."});
                    _loc_1.gotoRoom();
                }
                if (this.myFacade.hasMediator(KillerRoomChatMediaor.NAME))
                {
                    _loc_2 = this.myFacade.retrieveMediator(KillerRoomChatMediaor.NAME) as KillerRoomChatMediaor;
                    _loc_2.init();
                }
            }
            return;
        }// end function

        public function remove() : void
        {
            this.myFacade.sendNotification(KillerRoomEvents.OUTROOM);
            this.netproxy.clearClient();
            return;
        }// end function

        private function loadSwfsrc() : void
        {
            this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING_AND_BG, {msg:"读取场景资料...", p:(this.srcI + 1) + "/" + this.srcArr.length, bar:0});
            if (this.srcLoader == null)
            {
                this.srcLoader = new LoadSwfsrc(ApplicationDomain.currentDomain);
                this.srcLoader.addEventListener("complete", this.complatehandler);
                this.srcLoader.addEventListener("progress", this.progresshandler);
            }
            this.srcLoader.load(Resource.HTTP + this.srcArr[this.srcI] + Resource.GetFileNameV(this.srcArr[this.srcI]));
            return;
        }// end function

        private function progresshandler(event:Event) : void
        {
            var _loc_2:* = event.target.loadedBtyes / event.target.totalBtyes;
            this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING_AND_BG, {msg:"读取场景资料...", p:(this.srcI + 1) + "/" + this.srcArr.length, bar:_loc_2});
            return;
        }// end function

        private function complatehandler(event:Event) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.srcI + 1;
            _loc_2.srcI = _loc_3;
            if (this.srcI < this.srcArr.length)
            {
                this.loadSwfsrc();
            }
            else
            {
                if (this.myFacade.hasMediator(KillerRoomBgMediator.NAME))
                {
                    this.myFacade.removeMediator(KillerRoomBgMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomPlayersMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomChatMediaor.NAME);
                    this.myFacade.removeMediator(KillerRoomPlugGameMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomToolBoxMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomPlayerListBoxMediator.NAME);
                    this.myFacade.removeMediator(KillerRoomMainMediator.NAME);
                }
                this.myFacade.registerMediator(new KillerRoomBgMediator(this));
                this.myFacade.registerMediator(new KillerRoomPlayersMediator(this));
                this.myFacade.registerMediator(new KillerRoomChatMediaor(this));
                this.myFacade.registerMediator(new KillerRoomPlugGameMediator(this));
                this.myFacade.registerMediator(new KillerRoomToolBoxMediator(this));
                this.myFacade.registerMediator(new KillerRoomPlayerListBoxMediator(this));
                this.myFacade.registerMediator(new KillerRoomMainMediator(this));
                this.srcLoader.removeEventListener("complete", this.complatehandler);
                this.srcLoader = null;
                MainData.isKillRoomScenced = 1;
            }
            return;
        }// end function

    }
}
