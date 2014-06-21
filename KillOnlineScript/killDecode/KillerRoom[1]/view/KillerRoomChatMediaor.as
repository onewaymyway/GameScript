package view
{
    import Core.*;
    import Core.controller.*;
    import Core.model.data.*;
    import Core.view.*;
    import controller.*;
    import flash.events.*;
    import model.*;
    import mx.utils.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomChatMediaor extends Mediator
    {
        private var ChatBoxMc:killerRoom_chat;
        private var selectLabaList:SelectList;
        private var selectColorList:SelectList;
        private var recVoiceController:RecVoiceController;
        public static const NAME:String = "KillerRoomChatMediaor";

        public function KillerRoomChatMediaor(param1:Object = null)
        {
            super(NAME, param1);
            return;
        }// end function

        public function init() : void
        {
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba1, "喇叭2金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba2, "绿喇叭3金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba3, "蓝喇叭5金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba4, "粉喇叭8金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba5, "紫喇叭10金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba6, "闪喇叭12金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba7, "闪喇叭15金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba8, "福喇叭18金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labaList.laba9, "每日免费使用一次", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba1, "喇叭2金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba2, "绿喇叭3金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba3, "蓝喇叭5金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba4, "粉喇叭8金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba5, "紫喇叭10金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba6, "闪喇叭12金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba7, "闪喇叭15金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba8, "福喇叭18金币", 2);
            MainView.ALT.setAlt(this.ChatBoxMc.labasend_btn.laba9, "每日免费使用一次", 2);
            this.ChatBoxMc.chatMsg_box.cleanChat();
            this.ChatBoxMc.sysMsg_box.cleanChat();
            this.ChatBoxMc.chatMsg_box.addChat("欢迎进入房间,请文明游戏.");
            this.setLaBaBtn(uint(MainData.LabaBtnType));
            return;
        }// end function

        override public function onRegister() : void
        {
            this.selectLabaList = new SelectList();
            this.selectLabaList.addEventListener(MouseEvent.MOUSE_DOWN, this.selectLabaListHandler);
            this.selectColorList = new SelectList();
            this.selectColorList.addEventListener(MouseEvent.MOUSE_DOWN, this.selectColorListHandler);
            this.ChatBoxMc = new killerRoom_chat();
            this.ChatBoxMc.color_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.ChatBoxMc.sayall_face_mc.addEventListener(MouseEvent.CLICK, this.onFaceClick);
            this.ChatBoxMc.chatMsg_box.maxH = -1;
            this.ChatBoxMc.sysMsg_box.maxH = -1;
            this.ChatBoxMc.addEventListener(TextEvent.LINK, this.linkHandler);
            this.ChatBoxMc.x = 0;
            this.ChatBoxMc.y = this.viewComponent.stage.stageHeight;
            this.viewComponent.addChild(this.ChatBoxMc);
            this.recVoiceController = new RecVoiceController(this.ChatBoxMc.voice_send_layer);
            this.ChatBoxMc.send_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.ChatBoxMc.send_txt.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            this.ChatBoxMc.labasend_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.ChatBoxMc.labaList.visible = false;
            this.ChatBoxMc.color_list.visible = false;
            this.ChatBoxMc.labaList_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.ChatBoxMc.labaList.laba9.visible = false;
            this.selectLabaList.SetList([this.ChatBoxMc.labaList.laba1, this.ChatBoxMc.labaList.laba2, this.ChatBoxMc.labaList.laba3, this.ChatBoxMc.labaList.laba4, this.ChatBoxMc.labaList.laba5, this.ChatBoxMc.labaList.laba6, this.ChatBoxMc.labaList.laba7, this.ChatBoxMc.labaList.laba8, this.ChatBoxMc.labaList.laba9], [1, 2, 3, 4, 5, 6, 7, 8, 99], -1);
            this.setLaBaBtn(uint(MainData.LabaBtnType));
            this.selectColorList.SetList([this.ChatBoxMc.color_list.color0, this.ChatBoxMc.color_list.color1, this.ChatBoxMc.color_list.color2, this.ChatBoxMc.color_list.color3, this.ChatBoxMc.color_list.color4, this.ChatBoxMc.color_list.color5, this.ChatBoxMc.color_list.color6, this.ChatBoxMc.color_list.color7], [[0, 16777215], [1, "#FF0000"], [2, "#00FF00"], [3, "#0000FF"], [4, "#FFFF00"], [5, "#00FFFF"], [6, "#FF00FF"], [7, "#000000"]], 0);
            this.init();
            return;
        }// end function

        override public function onRemove() : void
        {
            this.recVoiceController.onRemove();
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [KillerRoomEvents.SETCHATMAXSCORLL, KillerRoomEvents.CLEANSYSMSGBOX, KillerRoomEvents.CHATBOXMSG, KillerRoomEvents.CHATBOXVOICE, KillerRoomEvents.LASTBOXMSG, GameEvents.NEWSLISTEVENT.SYSBOXMSG, KillerRoomEvents.SYSBOXMSG, KillerRoomEvents.SHOWBTNS, KillerRoomEvents.ROOMACT_STARTGAME, KillerRoomEvents.ROOMACT_GAMEOVER, KillerRoomEvents.OUTROOM];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            _loc_2 = param1.getBody();
            switch(param1.getName())
            {
                case KillerRoomEvents.SETCHATMAXSCORLL:
                {
                    this.ChatBoxMc.sysMsg_box.maxH = uint(_loc_2);
                    this.ChatBoxMc.chatMsg_box.maxH = uint(_loc_2);
                    break;
                }
                case KillerRoomEvents.CLEANSYSMSGBOX:
                {
                    this.ChatBoxMc.sysMsg_box.cleanChat();
                    break;
                }
                case KillerRoomEvents.ROOMACT_STARTGAME:
                {
                    this.ChatBoxMc.sysMsg_box.cleanChat();
                    this.ChatBoxMc.chatMsg_box.cleanChat();
                    KillerRoomCharVoicesController.sharedController().stopAllVoices();
                    break;
                }
                case KillerRoomEvents.CHATBOXMSG:
                {
                    _loc_3 = _loc_2.UserName;
                    this.chickChatFace(_loc_2.Msg, _loc_2.Site);
                    if (_loc_2.Device)
                    {
                        if (KillerRoomData.UserPlayerID == _loc_2.Site)
                        {
                            _loc_2.UserName = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + "</b></font> ";
                        }
                        else
                        {
                            _loc_2.UserName = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#99FF00\'><b>" + _loc_3 + "</b></font> ";
                        }
                        this.ChatBoxMc.chatMsg_box.addMobileChat(_loc_2);
                        return;
                    }
                    if (KillerRoomData.UserPlayerID == _loc_2.Site)
                    {
                        _loc_3 = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + " :</b></font> ";
                    }
                    else
                    {
                        _loc_3 = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#99FF00\'><b>" + _loc_3 + " :</b></font> ";
                    }
                    _loc_3 = _loc_3 + "<font color=\'" + _loc_2.Color + "\'>" + _loc_2.Msg + "</font> ";
                    this.ChatBoxMc.chatMsg_box.addChat(String(_loc_3));
                    break;
                }
                case KillerRoomEvents.CHATBOXVOICE:
                {
                    _loc_4 = _loc_2.UserName;
                    if (int(_loc_2.Site) > 100)
                    {
                        _loc_2.Site = "围观";
                    }
                    if (KillerRoomData.UserPlayerID == _loc_2.Site)
                    {
                        _loc_2.UserName = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#FF0000\'><b>" + "你说" + "</b></font> ";
                    }
                    else
                    {
                        _loc_2.UserName = "<font color=\'#FFFF00\'><b>[" + _loc_2.Site + "]</b></font><font color=\'#99FF00\'><b>" + _loc_4 + "</b></font> ";
                    }
                    this.ChatBoxMc.chatMsg_box.addChatVoice(_loc_2);
                    break;
                }
                case KillerRoomEvents.SYSBOXMSG:
                {
                    this.ChatBoxMc.sysMsg_box.addChat(String(_loc_2));
                    break;
                }
                case GameEvents.NEWSLISTEVENT.SYSBOXMSG:
                {
                    this.ChatBoxMc.sysMsg_box.addChat(_loc_2);
                    break;
                }
                case KillerRoomEvents.LASTBOXMSG:
                {
                    _loc_5 = "<font color=\'#CAFFFF\'>[遗言] " + "<b>[" + _loc_2.Site + "][" + _loc_2.UserName + " ] </b></font>:<font color=\'#FF0000\'><b>" + _loc_2.Msg + " </b></font>";
                    this.ChatBoxMc.sysMsg_box.addChat(String(_loc_5));
                    break;
                }
                case KillerRoomEvents.SHOWBTNS:
                {
                    this.setBtn(param1.getBody());
                    break;
                }
                case KillerRoomEvents.ROOMACT_GAMEOVER:
                {
                    this.ChatBoxMc.sysMsg_box.cleanChat();
                    this.ChatBoxMc.chatMsg_box.cleanChat();
                    KillerRoomCharVoicesController.sharedController().stopAllVoices();
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    this.ChatBoxMc.labaList.visible = false;
                    this.ChatBoxMc.color_list.visible = false;
                    this.ChatBoxMc.sysMsg_box.cleanChat();
                    this.ChatBoxMc.chatMsg_box.cleanChat();
                    KillerRoomCharVoicesController.sharedController().stopAllVoices();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function selectLabaListHandler(event:Event) : void
        {
            MainData.LabaBtnType = uint(this.selectLabaList.selectData);
            this.SendNewsMsg(this.selectLabaList.selectData as int);
            return;
        }// end function

        private function selectColorListHandler(event:Event) : void
        {
            this.ChatBoxMc.color_list.visible = false;
            this.setColorBtn(this.selectColorList.selectData[0] as int);
            return;
        }// end function

        private function onFaceClick(event:Event) : void
        {
            var _loc_2:* = new Object();
            _loc_2.cmd = "Emot";
            switch(event.target.name)
            {
                case "face1_btn":
                {
                    _loc_2.Type = "HI";
                    break;
                }
                case "face2_btn":
                {
                    _loc_2.Type = "haha";
                    break;
                }
                case "face3_btn":
                {
                    _loc_2.Type = "yun";
                    break;
                }
                case "face4_btn":
                {
                    _loc_2.Type = "cry";
                    break;
                }
                case "face5_btn":
                {
                    _loc_2.Type = "hugry";
                    break;
                }
                case "face6_btn":
                {
                    _loc_2.Type = "qt";
                    break;
                }
                case "face7_btn":
                {
                    _loc_2.Type = "yeah";
                    break;
                }
                case "face8_btn":
                {
                    _loc_2.Type = "fuck";
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (SendTimeContrller.CanSendFace())
            {
                this.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            return;
        }// end function

        private function onClick(event:Event) : void
        {
            var _loc_3:Array = null;
            var _loc_2:* = event.currentTarget;
            switch(_loc_2)
            {
                case this.ChatBoxMc.send_btn:
                {
                    this.SendChatMsg();
                    break;
                }
                case this.ChatBoxMc.labasend_btn:
                {
                    this.SendNewsMsg();
                    break;
                }
                case this.ChatBoxMc.labaList_btn:
                {
                    if (this.ChatBoxMc.labaList.visible == false)
                    {
                        this.ChatBoxMc.labaList.visible = true;
                    }
                    else
                    {
                        this.ChatBoxMc.labaList.visible = false;
                    }
                    break;
                }
                case this.ChatBoxMc.color_btn:
                {
                    if (this.ChatBoxMc.color_list.visible == false)
                    {
                        this.ChatBoxMc.color_list.visible = true;
                    }
                    else
                    {
                        this.ChatBoxMc.color_list.visible = false;
                    }
                    break;
                }
                case this.ChatBoxMc.test1_btn:
                {
                    _loc_3 = ["kill1", 1];
                    this.sendNotification(KillerRoomEvents.ROOMTOBEKILL, _loc_3);
                    break;
                }
                case this.ChatBoxMc.test2_btn:
                {
                    _loc_3 = ["kill2", 1];
                    this.sendNotification(KillerRoomEvents.ROOMTOBEKILL, _loc_3);
                    break;
                }
                case this.ChatBoxMc.test3_btn:
                {
                    _loc_3 = ["offline", 1];
                    this.sendNotification(KillerRoomEvents.ROOMTOBEKILL, _loc_3);
                    break;
                }
                case this.ChatBoxMc.test4_btn:
                {
                    _loc_3 = ["isview", 1];
                    this.sendNotification(KillerRoomEvents.ROOMTOBEKILL, _loc_3);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            if (event.keyCode == 13)
            {
                this.SendChatMsg();
                if (this.ChatBoxMc.send_txt.scrollV >= 2)
                {
                    this.ChatBoxMc.send_txt.htmlText = "";
                }
            }
            return;
        }// end function

        private function chickChatFace(param1:String, param2:uint) : void
        {
            param1 = param1.toUpperCase();
            var _loc_3:* = new Object();
            _loc_3.Site = param2;
            _loc_3.Type = "";
            if (param1.indexOf("HI") != -1 || param1.indexOf("你好") != -1 || param1.indexOf("您好") != -1 || param1.indexOf("你们好") != -1 || param1.indexOf("大家好") != -1)
            {
                _loc_3.Type = "HI";
            }
            else if (param1.indexOf("哈") != -1 || param1.indexOf("嘻") != -1 || param1.indexOf("呵") != -1 || param1.indexOf("HAHA") != -1)
            {
                _loc_3.Type = "haha";
            }
            else if (param1.indexOf("YEAH") != -1 || param1.indexOf("赢") != -1 || param1.indexOf("胜利") != -1 || param1.indexOf("WIN") != -1)
            {
                _loc_3.Type = "yeah";
            }
            else if (param1.indexOf("哭") != -1 || param1.indexOf("伤心") != -1 || param1.indexOf("惨") != -1 || param1.indexOf("5555") != -1)
            {
                _loc_3.Type = "cry";
            }
            else if (param1.indexOf("生气") != -1 || param1.indexOf("怒") != -1 || param1.indexOf("杀人") != -1 || param1.indexOf("气死") != -1)
            {
                _loc_3.Type = "hugry";
            }
            else if (param1.indexOf("可爱") != -1 || param1.indexOf("真的") != -1 || param1.indexOf("喜欢") != -1 || param1.indexOf("漂亮") != -1 || param1.indexOf("美") != -1 || param1.indexOf("酷") != -1)
            {
                _loc_3.Type = "qt";
            }
            else if (param1.indexOf("汗") != -1 || param1.indexOf("晕") != -1 || param1.indexOf("。。。。") != -1 || param1.indexOf("....") != -1)
            {
                _loc_3.Type = "yun";
            }
            else if (param1.indexOf("鄙视") != -1)
            {
                _loc_3.Type = "fuck";
            }
            if (_loc_3.Type != "")
            {
                this.sendNotification(KillerRoomEvents.BODYFACE, _loc_3);
            }
            return;
        }// end function

        public function SendChatMsg() : void
        {
            var _loc_1:Object = null;
            if (this.ChatBoxMc.send_txt.text.indexOf(":?soviewer") > -1)
            {
                facade.sendNotification(PlusMediator.OPEN, {url:"/swf/SoViewerTreeBox.swf", x:10, y:20});
                this.ChatBoxMc.send_txt.text = "";
                return;
            }
            if (KillerRoomData.isCanChat)
            {
                if (this.ChatBoxMc.send_txt.scrollV >= 2)
                {
                    this.ChatBoxMc.send_txt.text = this.ChatBoxMc.send_txt.getLineText((this.ChatBoxMc.send_txt.scrollV - 1));
                }
                if (this.ChatBoxMc.send_txt.text != "")
                {
                    if (SendTimeContrller.CanSendChat())
                    {
                        _loc_1 = new Object();
                        _loc_1.Msg = String(this.ChatBoxMc.send_txt.text);
                        _loc_1.Color = String(this.selectColorList.selectData[1]);
                        _loc_1.cmd = "SayInRoom";
                        this.sendNotification(GameEvents.NETEVENT.NETCALL, _loc_1);
                    }
                    this.ChatBoxMc.send_txt.text = "";
                }
            }
            return;
        }// end function

        public function SendNewsMsg(param1:int = 0) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            if (KillerRoomData.isCanSpeaker)
            {
                if (param1 != 0)
                {
                    this.ChatBoxMc.labaList.visible = false;
                    this.setLaBaBtn(param1);
                }
                else
                {
                    param1 = MainData.LabaBtnType;
                }
                _loc_2 = StringUtil.trim(this.ChatBoxMc.send_txt.text);
                if (_loc_2 != "")
                {
                    _loc_3 = new Object();
                    _loc_3.Msg = _loc_2;
                    _loc_3.Type = String(MainData.LabaBtnType);
                    _loc_3.cmd = "Speaker";
                    this.sendNotification(GameEvents.NETEVENT.NETCALL, _loc_3);
                }
                this.ChatBoxMc.send_txt.text = "";
            }
            else
            {
                facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, {msg:"游戏死亡后，不能发喇叭"});
            }
            return;
        }// end function

        private function setLaBaBtn(param1:uint) : void
        {
            this.ChatBoxMc.labaList.visible = false;
            MainData.LabaBtnType = param1;
            var _loc_2:uint = 1;
            while (_loc_2 <= 9)
            {
                
                if (_loc_2 == param1)
                {
                    this.ChatBoxMc.labasend_btn["laba" + param1].visible = true;
                }
                else
                {
                    this.ChatBoxMc.labasend_btn["laba" + _loc_2].visible = false;
                }
                _loc_2 = _loc_2 + 1;
            }
            if (param1 == 99)
            {
                this.ChatBoxMc.labasend_btn["laba" + 9].visible = true;
            }
            return;
        }// end function

        private function setColorBtn(param1:uint) : void
        {
            this.ChatBoxMc.color_list.visible = false;
            var _loc_2:uint = 0;
            while (_loc_2 < 8)
            {
                
                if (_loc_2 == param1)
                {
                    this.ChatBoxMc.color_btn["color" + param1].visible = true;
                }
                else
                {
                    this.ChatBoxMc.color_btn["color" + _loc_2].visible = false;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function setBtn(param1:Object) : void
        {
            if (param1.isCanChat)
            {
                KillerRoomData.isCanChat = true;
                this.ChatBoxMc.send_btn.mouseEnabled = true;
                this.ChatBoxMc.voice_send_layer.mouseChildren = true;
                this.ChatBoxMc.labasend_btn.mouseEnabled = true;
                this.ChatBoxMc.labasend_btn.mouseChildren = true;
                this.ChatBoxMc.sayall_face_mc.mouseEnabled = true;
                this.ChatBoxMc.sayall_face_mc.mouseChildren = true;
                this.ChatBoxMc.labaList_btn.mouseEnabled = true;
            }
            else
            {
                this.recVoiceController._stopRecordHandler();
                KillerRoomData.isCanChat = false;
                this.ChatBoxMc.voice_send_layer.mouseChildren = false;
                this.ChatBoxMc.send_btn.mouseEnabled = false;
                this.ChatBoxMc.sayall_face_mc.mouseEnabled = false;
                this.ChatBoxMc.sayall_face_mc.mouseChildren = false;
            }
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            if (event.text.indexOf("/") > -1)
            {
                OpenWin.open(event.text);
            }
            else
            {
                this.sendNotification(GameEvents.PlUSEVENT.INFOBOXSHOW, int(event.text));
            }
            return;
        }// end function

    }
}
