package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.events.*;

    public class FriendListChild extends Object
    {
        private var _arrBox:Array;
        private var facade:MyFacade;
        private var Type:String;

        public function FriendListChild()
        {
            this.facade = MyFacade.getInstance();
            this._arrBox = new Array();
            return;
        }// end function

        public function addListChild(MC:Object, INFO:Object, TYPE:String) : void
        {
            if (!this.hasObj(MC))
            {
                this._arrBox.push(MC);
            }
            this.Type = TYPE;
            MC.INFO = INFO;
            MC.del_btn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            MC.chat_btn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            MC._btn.buttonMode = true;
            MC._btn.useHandCursor = true;
            MC._btn.addEventListener(MouseEvent.CLICK, this.clickHandler);
            MC.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
            MC.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            MC.btn_bg.visible = false;
            return;
        }// end function

        private function enterHandler(event:Event) : void
        {
            var _loc_2:* = event.currentTarget;
            if (!_loc_2.hitTestPoint(MainData.MainStage.mouseX, MainData.MainStage.mouseY, true))
            {
                _loc_2.btn_bg.visible = false;
                _loc_2.removeEventListener(Event.ENTER_FRAME, this.enterHandler);
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
                    _loc_2.btn_bg.visible = true;
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    _loc_2.removeEventListener(Event.ENTER_FRAME, this.enterHandler);
                    _loc_2.addEventListener(Event.ENTER_FRAME, this.enterHandler);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function clickHandler(event:MouseEvent) : void
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_2:* = event.currentTarget;
            if (_loc_2.name == "_btn")
            {
                _loc_2.parent.btn_bg.visible = false;
                _loc_3 = {UserID:_loc_2.parent.INFO["userId"], Line:_loc_2.parent.INFO["online"], FTbID:_loc_2.parent.INFO["f_id"]};
                if (this.Type == "1")
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.INFOBOXSHOW, _loc_2.parent.INFO["userId"]);
                }
                else
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.FREINFOBOXSHOW, _loc_3);
                }
            }
            else if (_loc_2.name == "del_btn")
            {
                _loc_4 = new Object();
                _loc_4.arr = {FriendId:String(_loc_2.parent.INFO["userId"])};
                _loc_4.msg = "你确定要删除[ <font color=\'#FF0000\'><a href=\"event:" + _loc_2.parent.INFO["userId"] + "\"><U>" + _loc_2.parent.INFO["userName"] + "</U></a></font> ]好友吗？";
                _loc_4.func = this.delFriend;
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_DELFRIEND, _loc_4);
            }
            else if (_loc_2.name == "chat_btn")
            {
                _loc_5 = new Object();
                _loc_5.url = Resource.HTTP + "PriaveChatBox.swf";
                _loc_5.x = 0;
                _loc_5.y = 0;
                _loc_5.isnew = 1;
                _loc_5.FasUserId = _loc_2.parent.INFO["userId"];
                _loc_5.UserName = _loc_2.parent.INFO["userName"];
                _loc_5.Face = String(_loc_2.parent.INFO["userFace"]);
                _loc_5.Online = uint(_loc_2.parent.INFO["online"]);
                this.facade.sendNotification(PlusMediator.ACTION, _loc_5);
            }
            return;
        }// end function

        private function delFriend(o:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.FriendId = String(o.FriendId);
            _loc_2.Both = String(o.Both);
            _loc_2.cmd = "FriendCmd_FriendRemove";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function hasObj(OBJ:Object) : Boolean
        {
            var _loc_2:uint = 0;
            while (_loc_2 < this._arrBox.length)
            {
                
                if (this._arrBox[_loc_2] == OBJ)
                {
                    return true;
                }
                _loc_2 = _loc_2 + 1;
            }
            return false;
        }// end function

        public function cleanChild() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this._arrBox.length)
            {
                
                if (this._arrBox[_loc_1].hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

    }
}
