package view
{
    import Core.*;
    import Core.model.data.*;
    import flash.events.*;

    public class UserInfoBoxForm6ListChid extends Object
    {
        private var facade:MyFacade;
        private var theViewer:userinfobox_form6_list_mc;
        private var userinfo:Object;
        private var isMe:Boolean;
        private var type:uint;

        public function UserInfoBoxForm6ListChid(MC:userinfobox_form6_list_mc, INFO:Object, IsMe:Boolean, Type:uint)
        {
            var _loc_5:level_logo_l = null;
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            this.userinfo = INFO;
            this.isMe = IsMe;
            this.type = Type;
            MC._btn.buttonMode = true;
            MC._btn.useHandCursor = true;
            MC.btn_bg.visible = false;
            MC.name_txt.text = INFO.username;
            if (!MC._btn.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                MC.addEventListener(TextEvent.LINK, this.linkHandler);
                MC._btn.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                MC._btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                MC._btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            }
            if (this.isMe)
            {
                if (uint(INFO["online"]) > 0)
                {
                    if (uint(INFO["online"]) == uint(MainData.LoginInfo.Id))
                    {
                        MC.states_txt.text = "在线";
                        MC.name_txt.textColor = 0;
                        MC.states_txt.textColor = 0;
                    }
                    else
                    {
                        MC.states_txt.text = INFO["online"] + "线";
                        MC.name_txt.textColor = 0;
                        MC.states_txt.textColor = 0;
                    }
                }
                else
                {
                    MC.name_txt.textColor = 6710886;
                    MC.states_txt.textColor = 3355443;
                    MC.states_txt.text = "离线";
                    MC.btn_bg.visible = false;
                }
                if (this.type == 1)
                {
                    MC.act_txt.htmlText = "<a href=\"event:delAct\"><u>背师</u></a> <a href=\"event:finishAct\"><u>出师</u></a>";
                }
                else if (this.type == 2)
                {
                    MC.act_txt.htmlText = "<a href=\"event:delAct\"><u>逐出</u></a> <a href=\"event:finishAct\"><u>出师</u></a>";
                }
                else if (this.type == 3)
                {
                    MC.act_txt.htmlText = "<a href=\"event:delHistoryAct\"><u>删除</u></a> ";
                }
            }
            else
            {
                MC.act_txt.text = "";
                MC._btn.mouseEnabled = false;
                _loc_5 = new level_logo_l();
                _loc_5.x = 112;
                _loc_5.y = 3;
                _loc_5.setLevel(INFO.integral);
                MC.addChild(_loc_5);
            }
            MC.addEventListener(Event.REMOVED_FROM_STAGE, this.cleanChild);
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = event.target;
            if (_loc_2.name == "_btn")
            {
                switch(event.type)
                {
                    case MouseEvent.MOUSE_OVER:
                    {
                        _loc_2.parent.btn_bg.visible = true;
                        break;
                    }
                    case MouseEvent.MOUSE_OUT:
                    {
                        _loc_2.parent.btn_bg.visible = false;
                        break;
                    }
                    case MouseEvent.MOUSE_DOWN:
                    {
                        _loc_2.parent.btn_bg.visible = false;
                        _loc_3 = {FTbID:this.userinfo["f_id"], UserID:this.userinfo["userid"], Line:this.userinfo["online"]};
                        this.facade.sendNotification(GameEvents.PlUSEVENT.FREINFOBOXSHOW, _loc_3);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            else if (_loc_2.name == "del_btn")
            {
            }
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            var _loc_2:Object = null;
            if (event.text == "delAct")
            {
                _loc_2 = new Object();
                if (this.type == 1)
                {
                    _loc_2.msg = "你确定要 背弃师门 ?";
                }
                else if (this.type == 2)
                {
                    _loc_2.msg = "你确定要把" + this.userinfo["username"] + " 逐出师门 ?";
                }
                _loc_2.type = String(this.type);
                _loc_2.func = this.delAct;
                _loc_2.arr = {userid:String(this.userinfo["userid"]), type:String(this.type)};
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, _loc_2);
            }
            else if (event.text == "finishAct")
            {
                _loc_2 = new Object();
                if (this.type == 1)
                {
                    _loc_2.msg = "你确定要 出师 ?";
                }
                else if (this.type == 2)
                {
                    _loc_2.msg = "你确定要把 [" + this.userinfo["username"] + "] 出师 ?";
                }
                _loc_2.type = String(this.type);
                _loc_2.func = this.finishAct;
                _loc_2.arr = {userid:String(this.userinfo["userid"]), type:String(this.type)};
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, _loc_2);
            }
            else if (event.text == "delHistoryAct")
            {
                _loc_2 = new Object();
                _loc_2.msg = "删除历史徒弟，需要72金币 \n你确定要  删除历史徒弟 ?";
                _loc_2.func = this.delHistory;
                _loc_2.arr = {userid:String(this.userinfo["userid"])};
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOWITHFUNC_OPEN, _loc_2);
            }
            return;
        }// end function

        public function delHistory(obj:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.ToUserId = String(obj["userid"]);
            _loc_2.cmd = "TeachCmd_DelHistoryStudent";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function delAct(obj:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.ToUserId = String(obj["userid"]);
            _loc_2.cmd = "TeachCmd_Drop";
            _loc_2.Type = String(obj.type);
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function finishAct(obj:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.cmd = "TeachCmd_Finish";
            _loc_2.Type = String(obj.type);
            _loc_2.ToUserId = String(obj["userid"]);
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        public function cleanChild(event:Event) : void
        {
            if (this.theViewer.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                this.theViewer.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                this.theViewer.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                this.theViewer.removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            }
            return;
        }// end function

    }
}
