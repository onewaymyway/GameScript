package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.events.*;
    import model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class FriendMediator extends Mediator implements IMediator
    {
        private var friendBox:friend_Box;
        private var selectMenu:SelectOneBox;
        private var selectChild:SelectListsChild;
        private var selectRadio:SelectRadioBox;
        private var friendListChild:FriendListChild;
        private var listsChildArr:Array;
        private var friendInfoArr:Array;
        private var listData_cmd:CallCmdVO;
        private var proxy:FriendListProxy;
        public static const NAME:String = "FriendMediator";

        public function FriendMediator(viewComponent:Object = null)
        {
            super(NAME, viewComponent);
            return;
        }// end function

        override public function onRegister() : void
        {
            this.proxy = new FriendListProxy();
            this.proxy.addEventListener(FriendListProxy.DATE_LOADED, this.proxyHandler);
            this.proxy.addEventListener(FriendListProxy.importFriends_LOADED, this.proxyImportHandler);
            this.listData_cmd = new CallCmdVO();
            this.friendListChild = new FriendListChild();
            this.selectRadio = new SelectRadioBox();
            this.selectChild = new SelectListsChild();
            this.listsChildArr = new Array();
            this.selectMenu = new SelectOneBox();
            this.friendBox = new friend_Box();
            this.friendBox.loading_mc.visible = false;
            this.viewComponent.addChild(this.friendBox);
            this.friendBox.lists.mask = this.friendBox.mask_mc;
            MainView.DRAG.setDrag(this.friendBox.drag_mc, this.viewComponent, this.viewComponent.parent);
            this.friendBox.close_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.friendBox.close2_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.friendBox.reload_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.friendBox.add_frame.add_act_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.friendBox.list_title_bar.prev_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.friendBox.list_title_bar.next_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.selectChild.addEventListener(MouseEvent.MOUSE_DOWN, this.selectChildHandler);
            this.selectMenu.addEventListener(MouseEvent.MOUSE_DOWN, this.selectMenuHandler);
            this.selectMenu.SetBoxs([this.friendBox.friend_btn, this.friendBox.black_btn, this.friendBox.family_btn, this.friendBox.add_btn, this.friendBox.set_btn], ["friend", "black", "family", "add", "set"], 0);
            this.selectRadio.addEventListener(MouseEvent.MOUSE_DOWN, this.selectRadioHandler);
            this.selectRadio.SetBoxs([this.friendBox.set_frame.set3_btn, this.friendBox.set_frame.set2_btn, this.friendBox.set_frame.set1_btn], ["0", "1", "2"], -1);
            return;
        }// end function

        override public function onRemove() : void
        {
            this.proxy.closeLoader();
            this.proxy = null;
            this.selectMenu.cleanChild();
            this.selectMenu = null;
            this.selectChild.cleanChild();
            this.selectChild = null;
            this.selectRadio.cleanChild();
            this.selectRadio = null;
            this.friendListChild.cleanChild();
            this.friendListChild = null;
            mcFunc.removeAllMc(this.friendBox.lists);
            mcFunc.removeAllMc(this.friendBox);
            this.friendBox.close_btn.removeEventListener(MouseEvent.CLICK, this.btnHandler);
            mcFunc.removeAllMc(this.viewComponent);
            this.listsChildArr = null;
            this.friendInfoArr = null;
            this.listData_cmd = null;
            this.friendBox = null;
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [GameEvents.PlUSEVENT.FRIENDSTRING, GameEvents.PlUSEVENT.FRIENDLISTDATA, GameEvents.PlUSEVENT.BLACKLISTDATA, GameEvents.PlUSEVENT.RELOADFRIENDLISTDATA, GameEvents.PlUSEVENT.FRIEND_NEEDVERIFY];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            switch(sender.getName())
            {
                case GameEvents.PlUSEVENT.FRIENDLISTDATA:
                {
                    this.proxy.reFreshThePage();
                    break;
                }
                case GameEvents.PlUSEVENT.BLACKLISTDATA:
                {
                    this.proxy.reFreshThePage();
                    break;
                }
                case GameEvents.PlUSEVENT.RELOADFRIENDLISTDATA:
                {
                    this.proxy.reFreshThePage();
                    break;
                }
                case GameEvents.PlUSEVENT.FRIENDSTRING:
                {
                    UserData.UserInfo.FriendSeting = String(sender.getBody());
                    this.selectRadio.selectByValue(sender.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function proxyHandler(event:Event) : void
        {
            var _loc_2:AlertVO = null;
            this.friendBox.loading_mc.visible = false;
            if (!this.friendBox)
            {
                return;
            }
            this.setListPage(FriendListProxy.ThePage, FriendListProxy.MaxPage);
            if (FriendListProxy.Data.ErrMsg)
            {
                _loc_2 = new AlertVO();
                _loc_2.msg = FriendListProxy.Data.ErrMsg;
                this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                return;
            }
            if (FriendListProxy.Data.t == 0)
            {
                this.selectMenu.index = 0;
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
            }
            else if (FriendListProxy.Data.t == 1)
            {
                this.selectMenu.index = 1;
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
            }
            else if (FriendListProxy.Data.t == 2)
            {
                this.selectMenu.index = 2;
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
            }
            this.friendInfoArr = FriendListProxy.Data.data as Array;
            this.setListsValue(this.friendInfoArr, FriendListProxy.Data.t);
            return;
        }// end function

        private function proxyImportHandler(event:Event) : void
        {
            this.selectMenu.def();
            return;
        }// end function

        private function setListPage(P:int, MAXP:int) : void
        {
            if (!this.friendBox)
            {
                return;
            }
            this.friendBox.list_title_bar.page_txt.text = P + "/" + MAXP;
            if (P == 1)
            {
                this.friendBox.list_title_bar.prev_btn.mouseEnabled = false;
            }
            else
            {
                this.friendBox.list_title_bar.prev_btn.mouseEnabled = true;
            }
            if (P == MAXP)
            {
                this.friendBox.list_title_bar.next_btn.mouseEnabled = false;
            }
            else
            {
                this.friendBox.list_title_bar.next_btn.mouseEnabled = true;
            }
            return;
        }// end function

        private function setListsValue(OBJ:Object, TYPE:String) : void
        {
            var _loc_3:Array = null;
            var _loc_4:uint = 0;
            var _loc_5:friend_list_mc = null;
            mcFunc.removeAllMc(this.friendBox.lists);
            if (OBJ)
            {
                _loc_3 = OBJ as Array;
                _loc_4 = 0;
                while (_loc_4 < _loc_3.length)
                {
                    
                    _loc_5 = new friend_list_mc();
                    this.setListMcValue(_loc_5, _loc_3[_loc_4], TYPE);
                    this.friendBox.lists.addChild(_loc_5);
                    _loc_4 = _loc_4 + 1;
                }
                mcFunc.reSetMcsWhere(this.friendBox.lists, 240, 0, 240, 20);
            }
            this.friendBox.scorll_mc.setToTop();
            return;
        }// end function

        private function setListMcValue(MC:Object, INFO:Object, TYPE:String) : void
        {
            MC.friend_name_txt.htmlText = "     " + INFO["userName"];
            if (TYPE == "2")
            {
                MC.del_btn.visible = false;
            }
            else
            {
                MC.del_btn.visible = true;
            }
            if (uint(INFO["online"]) > 0)
            {
                if (int(INFO["vip"]) > 0)
                {
                    if (!MC.vip_log)
                    {
                        MC.vip_log = MC.addChild(new Vip_Log());
                        MC.vip_log.y = 4;
                    }
                    MC.vip_log.visible = true;
                    MC.vip_log.gotoAndStop("vip" + int(INFO["vip"]));
                }
                else if (MC.vip_log)
                {
                    MC.vip_log.visible = false;
                }
                if (uint(INFO["online"]) == uint(MainData.LoginInfo.Id))
                {
                    MC.states_txt.text = "在线";
                    MC.friend_name_txt.textColor = 0;
                    MC.states_txt.textColor = 0;
                }
                else
                {
                    MC.states_txt.text = MainData.getLineName(INFO["online"]);
                    MC.friend_name_txt.textColor = 0;
                    MC.states_txt.textColor = 0;
                }
            }
            else
            {
                if (MC.vip_log)
                {
                    MC.vip_log.visible = false;
                }
                MC.friend_name_txt.textColor = 6710886;
                MC.states_txt.textColor = 3355443;
                MC.states_txt.text = "离线";
                MC.btn_bg.visible = false;
            }
            this.friendListChild.addListChild(MC, INFO, TYPE);
            return;
        }// end function

        private function selectRadioHandler(event:MouseEvent) : void
        {
            UserData.UserInfo.FriendSeting = String(this.selectRadio.selectData);
            var _loc_2:* = new Object();
            _loc_2.cmd = "FriendCmd_FriendSet";
            _loc_2.Status = String(this.selectRadio.selectData);
            this.sendNotification(GameEvents.NETCALL, _loc_2);
            return;
        }// end function

        private function selectMenuHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            mcFunc.removeAllMc(this.friendBox.lists);
            this.friendBox.scorll_mc.setToTop();
            if (this.selectMenu.selectData == "friend")
            {
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
                this.proxy.LoadData(1, 0);
                this.friendBox.loading_mc.visible = true;
                mcFunc.removeAllMc(this.friendBox.lists);
            }
            else if (this.selectMenu.selectData == "family")
            {
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
                this.proxy.LoadData(1, 2);
                this.friendBox.loading_mc.visible = true;
                mcFunc.removeAllMc(this.friendBox.lists);
            }
            else if (this.selectMenu.selectData == "black")
            {
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = true;
                this.proxy.LoadData(1, 1);
                this.friendBox.loading_mc.visible = true;
                mcFunc.removeAllMc(this.friendBox.lists);
            }
            else if (this.selectMenu.selectData == "add")
            {
                this.friendBox.add_frame.fName_txt.text = "";
                this.friendBox.loading_mc.visible = false;
                this.friendBox.add_frame.visible = true;
                this.friendBox.set_frame.visible = false;
                this.friendBox.list_title_bar.visible = false;
                mcFunc.removeAllMc(this.friendBox.lists);
            }
            else if (this.selectMenu.selectData == "set")
            {
                mcFunc.removeAllMc(this.friendBox.lists);
                this.friendBox.loading_mc.visible = false;
                this.friendBox.add_frame.visible = false;
                this.friendBox.set_frame.visible = true;
                this.friendBox.list_title_bar.visible = false;
                if (UserData.UserInfo.FriendSeting == "-1")
                {
                    _loc_2 = {cmd:"FriendCmd_GetSet"};
                    this.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                else
                {
                    this.selectRadio.selectByValue(UserData.UserInfo.FriendSeting);
                }
            }
            return;
        }// end function

        private function selectChildHandler(event:MouseEvent) : void
        {
            return;
        }// end function

        private function btnHandler(event:Event) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            switch(event.currentTarget.name)
            {
                case "prev_btn":
                {
                    mcFunc.removeAllMc(this.friendBox.lists);
                    this.proxy.prve();
                    this.friendBox.loading_mc.visible = true;
                    break;
                }
                case "next_btn":
                {
                    mcFunc.removeAllMc(this.friendBox.lists);
                    this.proxy.next();
                    this.friendBox.loading_mc.visible = true;
                    break;
                }
                case "close_btn":
                {
                    this.viewComponent.remove();
                    break;
                }
                case "close2_btn":
                {
                    this.viewComponent.remove();
                    break;
                }
                case "add_act_btn":
                {
                    var _loc_4:* = this.friendBox.add_frame.fName_txt.text;
                    this.friendBox.add_frame.fName_txt.text = this.friendBox.add_frame.fName_txt.text;
                    _loc_2 = _loc_4;
                    if (_loc_2 == "")
                    {
                        this.sendNotification(GameEvents.ALERTEVENT.ALERT, {msg:"请输入要添加的用户名！"});
                    }
                    else if (_loc_2 == UserData.UserInfo.UserName)
                    {
                        this.sendNotification(GameEvents.ALERTEVENT.ALERT, {msg:"不必加自己为好友！"});
                    }
                    else
                    {
                        _loc_3 = new Object();
                        _loc_3.UserName = _loc_2;
                        _loc_3.cmd = "FriendCmd_FriendAdd";
                        this.sendNotification(GameEvents.NETCALL, _loc_3);
                    }
                    break;
                }
                case "reload_btn":
                {
                    mcFunc.removeAllMc(this.friendBox.lists);
                    this.proxy.reFreshThePage();
                    this.friendBox.loading_mc.visible = true;
                    break;
                }
                case "import_btn":
                {
                    mcFunc.removeAllMc(this.friendBox.lists);
                    this.proxy.importFriends();
                    this.friendBox.loading_mc.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        GameEvents.PlUSEVENT.FRIENDSTRING = "friend_SETING";
        GameEvents.PlUSEVENT.FRIENDLISTDATA = "friend_list_data";
        GameEvents.PlUSEVENT.BLACKLISTDATA = "black_list_data";
        GameEvents.PlUSEVENT.RELOADFRIENDLISTDATA = "reload_friend_list_data";
        GameEvents.PlUSEVENT.FRIEND_NEEDVERIFY = "FRIEND_NEEDVERIFY";
        GameEvents.PlUSEVENT.FRIEND_ALERT = "FRIEND_ALERT";
        GameEvents.PlUSEVENT.FRIEND_REJECT = "FRIEND_REJECT";
        GameEvents.PlUSEVENT.FRIEND_VERIFY = "FRIEND_VERIFY";
    }
}
