package controller
{
    import Core.*;
    import Core.model.data.*;
    import flash.display.*;
    import flash.events.*;
    import model.*;

    public class KillerRoomPlayerListMcController extends Sprite
    {
        private var _data:Object;
        private var facade:Object;
        private var levelmc:level_logo_l;
        private var vipmc:Vip_Log;
        public var theViewer:KillerRoomPlayerlist_mc;

        public function KillerRoomPlayerListMcController(param1:KillerRoomPlayerlist_mc)
        {
            this.levelmc = new level_logo_l();
            this.vipmc = new Vip_Log();
            this.theViewer = param1;
            this.facade = MyFacade.getInstance();
            this.theViewer.bg_mc.visible = false;
            this.levelmc.x = 125;
            this.levelmc.y = 5;
            this.theViewer.addChild(this.levelmc);
            this.vipmc.x = 105;
            this.vipmc.y = 4;
            this.vipmc.visible = false;
            this.theViewer.addChild(this.vipmc);
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.addedStagehandler);
            this.theViewer.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
            this.theViewer.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            this.theViewer.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            return;
        }// end function

        public function set Data(param1:Object) : void
        {
            this._data = param1;
            var _loc_2:String = "0";
            this.levelmc.setLevel(int(this._data.Integral));
            if (int(this._data.Vip) > 0)
            {
                this.vipmc.visible = true;
                this.vipmc.gotoAndStop("vip" + int(this._data.Vip));
            }
            if ((String(KillerRoomData.RoomInfo.RoomMaster) == String(UserData.UserInfo.UserId) || int(UserData.UserInfo.Vip) >= int(this._data.Vip)) && KillerRoomData.RoomInfo.RoomStatus == 0 && (String(KillerRoomData.RoomInfo.RoomMaster) != String(param1.UserId) || int(UserData.UserInfo.Vip) >= 10))
            {
                this.theViewer.kick_btn.visible = true;
            }
            else
            {
                this.theViewer.kick_btn.visible = false;
            }
            if (uint(this._data.RoomSite) > 100)
            {
                _loc_2 = "围观";
                if (String(KillerRoomData.RoomInfo.RoomMaster) == String(UserData.UserInfo.UserId) && KillerRoomData.RoomInfo.RoomStatus == 0)
                {
                    this.theViewer.kick_btn.visible = true;
                }
                else
                {
                    this.theViewer.kick_btn.visible = false;
                }
            }
            else
            {
                _loc_2 = String(this._data.RoomSite);
            }
            if (this._data.UserId == UserData.UserInfo.UserId)
            {
                this.theViewer.name_txt.htmlText = "<font color=\'#ff0000\'>[" + _loc_2 + "]" + this._data.UserName + "</font>";
                this.theViewer.add_btn.visible = false;
                this.theViewer.kick_btn.visible = false;
                this.theViewer.parent.setChildIndex(this.theViewer, 0);
            }
            else
            {
                this.theViewer.name_txt.text = "[" + _loc_2 + "]" + this._data.UserName;
                this.theViewer.add_btn.visible = true;
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                this.theViewer.bg_mc.visible = true;
            }
            else if (event.type == MouseEvent.MOUSE_OUT)
            {
                this.theViewer.bg_mc.visible = false;
            }
            else if (event.type == MouseEvent.MOUSE_DOWN)
            {
                switch(event.target.name)
                {
                    case "kick_btn":
                    {
                        if (String(KillerRoomData.RoomInfo.RoomMaster) == String(UserData.UserInfo.UserId))
                        {
                            this.kickPlayer();
                        }
                        else if (String(KillerRoomData.RoomInfo.RoomMaster) == String(this._data.UserId))
                        {
                            _loc_2 = new Object();
                            _loc_2.cmd = "WaitKickMaster";
                            _loc_2.UserId = String(this._data.UserId);
                            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                        }
                        else
                        {
                            this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, {func:this.kickPlayer, arr:"", msg:"提示需要消耗10点VIP值"});
                        }
                        break;
                    }
                    case "add_btn":
                    {
                        _loc_2 = {cmd:"FriendCmd_FriendAdd", UserName:String(this._data.UserName)};
                        this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                        break;
                    }
                    default:
                    {
                        this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, this._data.UserId);
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        public function kickPlayer(param1:Object = null) : void
        {
            var _loc_2:* = new Object();
            _loc_2.cmd = "KickUser";
            _loc_2.UserId = String(this._data.UserId);
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

    }
}
