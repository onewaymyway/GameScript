package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.events.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class UserInfoBoxMediator extends Mediator implements IMediator
    {
        private var userInfoBox:UserInfo_box = null;
        private var userInfo:Object = null;
        private var marryInfo:Object = null;
        private var honorInfo:Object = null;
        private var familyInfo:Object = null;
        private var luxuryInfo:Object = null;
        private var medalInfo:Object = null;
        private var selectMenu:Object = null;
        private var form6Controller:UserInfoBoxForm6;
        private var form5Controller:UserLuxuryForm;
        private var form1Controller:UserInfoBoxForm1Controler;
        private var UserHonorFormController:UserHonorForm;
        private var UserMedalFormController:UserMedalForm;
        private var UserMarryFormController:UserMarryForm;
        public static const NAME:String = "UserInfoBoxMediator";

        public function UserInfoBoxMediator(viewComponent:Object = null)
        {
            super(NAME, viewComponent);
            return;
        }// end function

        override public function onRegister() : void
        {
            return;
        }// end function

        override public function onRemove() : void
        {
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [GameEvents.PlUSEVENT.USERINFOBOXSHOW, GameEvents.PlUSEVENT.FREINFOBOXSHOW, GameEvents.PlUSEVENT.INFOBOXSHOW, GameEvents.PlUSEVENT.USERINFOBOXCLOSE, GameEvents.PlUSEVENT.PLAYERINFO, GameEvents.PlUSEVENT.HONORINFO, GameEvents.PlUSEVENT.MARRYINFO, GameEvents.PlUSEVENT.FAMILYINFO, GameEvents.PlUSEVENT.LuxuryINFO, GameEvents.PlUSEVENT.MyTeachersINFO, GameEvents.PlUSEVENT.MyStudentsINFO, "JsToAs_SharePhotoComplete", GameEvents.PlUSEVENT.SPYINFO_DATA, GameEvents.PlUSEVENT.LYINFO_DATA, GameEvents.PlUSEVENT.DNINFO_DATA, GameEvents.PlUSEVENT.MEDALINFO, GameEvents.PlUSEVENT.OTHERINFO_DATA];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            var _loc_2:* = new Object();
            switch(sender.getName())
            {
                case GameEvents.PlUSEVENT.INFOBOXSHOW:
                {
                    this.userInfo = null;
                    this.familyInfo = null;
                    this.marryInfo = null;
                    this.honorInfo = null;
                    this.luxuryInfo = null;
                    this.medalInfo = null;
                    this.creatBox();
                    mcFunc.removeAllMc(this.userInfoBox.headPic_mc.loadmc);
                    this.UserHonorFormController.cleanHonor();
                    this.userInfoBox.T = "info";
                    this.setBtns("dis");
                    _loc_2.UserId = String(sender.getBody());
                    _loc_2.cmd = "PlayerInfo";
                    this.userInfoBox.UserID = uint(sender.getBody());
                    this.userInfoBox.FTbID = 0;
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                    break;
                }
                case GameEvents.PlUSEVENT.USERINFOBOXSHOW:
                {
                    this.userInfo = null;
                    this.familyInfo = null;
                    this.marryInfo = null;
                    this.honorInfo = null;
                    this.luxuryInfo = null;
                    this.medalInfo = null;
                    this.creatBox();
                    mcFunc.removeAllMc(this.userInfoBox.headPic_mc.loadmc);
                    this.UserHonorFormController.cleanHonor();
                    this.userInfoBox.T = "user";
                    this.setBtns("dis");
                    _loc_2.UserId = String(sender.getBody());
                    _loc_2.cmd = "PlayerInfo";
                    this.userInfoBox.UserID = uint(sender.getBody());
                    this.userInfoBox.FTbID = 0;
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                    break;
                }
                case GameEvents.PlUSEVENT.FREINFOBOXSHOW:
                {
                    this.userInfo = null;
                    this.familyInfo = null;
                    this.marryInfo = null;
                    this.honorInfo = null;
                    this.luxuryInfo = null;
                    this.medalInfo = null;
                    this.creatBox();
                    mcFunc.removeAllMc(this.userInfoBox.headPic_mc.loadmc);
                    this.userInfoBox.T = "fre";
                    this.setBtns("dis");
                    this.UserHonorFormController.cleanHonor();
                    _loc_2.UserId = String(sender.getBody().UserID);
                    _loc_2.Line = String(sender.getBody().Line);
                    _loc_2.cmd = "PlayerInfo";
                    this.userInfoBox.UserID = uint(sender.getBody().UserID);
                    this.userInfoBox.FTbID = uint(sender.getBody().FTbID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                    break;
                }
                case GameEvents.PlUSEVENT.USERINFOBOXCLOSE:
                {
                    this.closeFrame();
                    break;
                }
                case GameEvents.PlUSEVENT.PLAYERINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.respGetfasInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.HONORINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.respHonorInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.MEDALINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.respMedalInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.MARRYINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.respMarryInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.FAMILYINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        if (sender.getBody().Board)
                        {
                            if (sender.getBody().Board == "UserInfoBox")
                            {
                                this.respFamilyInfo(sender.getBody());
                            }
                        }
                        else
                        {
                            this.respFamilyInfo(sender.getBody());
                        }
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.LuxuryINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.respLuxuryInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.MyTeachersINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.form6Controller.setTeachInfo(this.userInfo, sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.MyStudentsINFO:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.form6Controller.setStudentInfo(this.userInfo, sender.getBody());
                    }
                    break;
                }
                case "JsToAs_SharePhotoComplete":
                {
                    if (this.userInfoBox)
                    {
                        this.UserMarryFormController.jsShare();
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.SPYINFO_DATA:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.respSpyInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.LYINFO_DATA:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.respLYInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.DNINFO_DATA:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.form1Controller.setOtherInfo(sender.getBody());
                    }
                    break;
                }
                case GameEvents.PlUSEVENT.OTHERINFO_DATA:
                {
                    if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
                    {
                        this.userInfoBox.loading_mc.visible = false;
                        this.form1Controller.setOtherInfo(sender.getBody());
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

        private function creatBox() : void
        {
            if (this.userInfoBox == null)
            {
                this.userInfoBox = new UserInfo_box();
                this.userInfoBox.moodCtrl = new UserInfoBoxForm1MoodControler(this.userInfoBox.form1_mc.mood_mc);
                this.userInfoBox.x = 300;
                this.userInfoBox.y = 100;
                if (Resource.AdminPassword == ",lpmkonji")
                {
                    this.userInfoBox.set_btn.visible = true;
                }
                else
                {
                    this.userInfoBox.set_btn.visible = false;
                }
                this.viewComponent.addChild(this.userInfoBox);
                this.setBoxInit(this.userInfoBox);
            }
            else
            {
                this.userInfoBox.moodCtrl.init();
                if (Resource.AdminPassword == ",lpmkonji")
                {
                    this.userInfoBox.set_btn.visible = true;
                }
                else
                {
                    this.userInfoBox.set_btn.visible = false;
                }
                this.viewComponent.addChild(this.userInfoBox);
                this.selectMenu.def();
                this.cleanFacePic();
            }
            return;
        }// end function

        private function setBoxInit(OBJ:UserInfo_box) : void
        {
            OBJ.form1_mc.visible = false;
            OBJ.form2_mc.visible = false;
            OBJ.form3_mc.visible = false;
            OBJ.form4_mc.visible = false;
            MainView.DRAG.setDrag(OBJ.drag_mc, OBJ, this.viewComponent);
            OBJ.close1_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.close_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.addFre_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.bedFre_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.goGame_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.invitGame_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            OBJ.set_btn.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            this.form6Controller = new UserInfoBoxForm6(OBJ.form6_mc);
            this.form5Controller = new UserLuxuryForm(OBJ.form5_mc);
            this.form1Controller = new UserInfoBoxForm1Controler(OBJ.form1_mc);
            this.UserHonorFormController = new UserHonorForm(OBJ.form3_mc);
            this.UserMedalFormController = new UserMedalForm(OBJ.MedalGrade_form);
            this.UserMarryFormController = new UserMarryForm(OBJ.form2_mc);
            if (this.selectMenu == null)
            {
                this.selectMenu = new SelectOneBox();
                this.selectMenu.addEventListener(MouseEvent.MOUSE_DOWN, this.selectMenuHandler);
            }
            this.selectMenu.SetBoxs([OBJ.info_btn, OBJ.marry_btn, OBJ.honor_btn, OBJ.family_btn, OBJ.adv_btn, OBJ.mna_btn, OBJ.Medal_btn], ["info", "marry", "honor", "family", "luxury", "master", "medal"], 0);
            return;
        }// end function

        private function selectMenuHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            this.userInfoBox.form1_mc.visible = false;
            this.userInfoBox.form2_mc.visible = false;
            this.userInfoBox.form3_mc.visible = false;
            this.userInfoBox.form4_mc.visible = false;
            this.userInfoBox.form5_mc.visible = false;
            this.userInfoBox.form6_mc.visible = false;
            this.userInfoBox.MedalGrade_form.visible = false;
            if (this.selectMenu.selectData == "info")
            {
                if (this.userInfo != null)
                {
                    this.form1Controller.init();
                }
                else
                {
                    this.userInfoBox.loading_mc.visible = true;
                }
                this.userInfoBox.form1_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "marry")
            {
                if (this.marryInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "MarryCmd_Info";
                    _loc_2.UserId = String(this.userInfoBox.UserID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                }
                this.userInfoBox.form2_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "honor")
            {
                if (this.honorInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "GetUserHoners";
                    _loc_2.UserId = String(this.userInfoBox.UserID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                }
                this.userInfoBox.form3_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "family")
            {
                if (this.familyInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "FamilyCmd_GetFamilyByUserid";
                    _loc_2.Userid = String(this.userInfoBox.UserID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                }
                this.userInfoBox.form4_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "luxury")
            {
                if (this.luxuryInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "GetUserLuxury";
                    _loc_2.UserId = String(this.userInfoBox.UserID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                }
                this.userInfoBox.form5_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "master")
            {
                _loc_2 = new Object();
                _loc_2.cmd = "TeachCmd_GetData";
                _loc_2.UserId = String(this.userInfoBox.UserID);
                facade.sendNotification(GameEvents.NETCALL, _loc_2);
                this.userInfoBox.loading_mc.visible = true;
                this.userInfoBox.form6_mc.visible = true;
            }
            else if (this.selectMenu.selectData == "medal")
            {
                if (this.medalInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "GetUserMedals";
                    _loc_2.UserId = String(this.userInfoBox.UserID);
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                    this.userInfoBox.loading_mc.visible = true;
                }
                else
                {
                    this.respMedalInfo(this.medalInfo);
                }
                this.userInfoBox.MedalGrade_form.visible = true;
            }
            return;
        }// end function

        private function btnClickhandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            if (event.currentTarget.name != "close1_btn")
            {
            }
            if (event.currentTarget.name == "close_btn")
            {
                this.closeFrame();
            }
            else if (event.currentTarget.name == "goGame_btn")
            {
                if (this.userInfo)
                {
                    RoomData.RoomInfo = {RoomId:this.userInfo.Room};
                    facade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在进房间..."});
                    _loc_2 = {cmd:"JoinRoom", UserId:String(this.userInfo.UserId), RoomId:String(this.userInfo.Room), Password:"", LineId:String(this.userInfo.Online)};
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                this.closeFrame();
            }
            else if (event.currentTarget.name == "invitGame_btn")
            {
                if (this.userInfo)
                {
                    _loc_2 = {cmd:"Invite", UserId:String(this.userInfoBox.UserID), LineId:String(this.userInfo.Online)};
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                this.closeFrame();
            }
            else if (event.currentTarget.name == "addFre_btn")
            {
                if (this.userInfo)
                {
                    _loc_2 = {cmd:"FriendCmd_FriendAdd", UserName:String(this.userInfo.UserName)};
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                this.closeFrame();
            }
            else if (event.currentTarget.name == "bedFre_btn")
            {
                if (this.userInfo)
                {
                    _loc_2 = {cmd:"FriendCmd_Friend2BlackList", f_id:String(this.userInfoBox.FTbID)};
                    facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                this.closeFrame();
            }
            else if (event.currentTarget.name == "set_btn")
            {
                if (this.userInfo["Online"])
                {
                }
                if (MainData.LoginInfo.Id != uint(this.userInfo["Online"]))
                {
                    _loc_3 = {msg:"请切换到同一线路", code:null, obj:null};
                    facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                    return;
                }
                facade.sendNotification(GameEvents.PlUSEVENT.ADMIN_USER_SET_BOX_OPEN, {UserId:this.userInfo.UserId, UserName:this.userInfo.UserName, Ip:"0.0.0.0"});
            }
            else if (event.currentTarget.name == "vipLog")
            {
                if (this.userInfo.UserId == UserData.UserInfo.UserId)
                {
                    this.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/VipPackage.swf"});
                }
                else
                {
                    OpenWin.open("http://www.ss911.cn/Pages/VipRules.shtml");
                }
            }
            return;
        }// end function

        private function closeFrame() : void
        {
            this.cleanFacePic();
            if (mcFunc.hasTheChlid(this.userInfoBox, this.viewComponent))
            {
                this.viewComponent.removeChild(this.userInfoBox);
            }
            return;
        }// end function

        private function roomChkRes(info:Object) : void
        {
            var _loc_2:* = new AlertVO();
            if (!info.ok)
            {
                _loc_2.msg = info.msg;
                if (info.msg == "密码不正确")
                {
                }
                else if (info.msg == "confirm")
                {
                }
                facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            else
            {
                facade.sendNotification(ScenceLoaderMediator.LOAD, Resource.KillerRoomPath);
            }
            return;
        }// end function

        private function setBtns(T:String) : void
        {
            if (T == "fre")
            {
                this.userInfoBox.goGame_btn.visible = true;
                this.userInfoBox.invitGame_btn.visible = true;
                this.userInfoBox.addFre_btn.visible = false;
                if (this.userInfoBox.FTbID)
                {
                    this.userInfoBox.bedFre_btn.visible = true;
                }
                else
                {
                    this.userInfoBox.bedFre_btn.visible = false;
                }
            }
            else if (T == "user")
            {
                this.userInfoBox.goGame_btn.visible = false;
                this.userInfoBox.invitGame_btn.visible = false;
                this.userInfoBox.addFre_btn.visible = true;
                this.userInfoBox.bedFre_btn.visible = false;
            }
            else
            {
                this.userInfoBox.goGame_btn.visible = false;
                this.userInfoBox.invitGame_btn.visible = false;
                this.userInfoBox.addFre_btn.visible = false;
                this.userInfoBox.bedFre_btn.visible = false;
            }
            return;
        }// end function

        private function setGoGameBtn(B:Boolean) : void
        {
            if (B)
            {
                this.userInfoBox.goGame_btn.mouseEnabled = true;
                this.userInfoBox.goGame_btn.alpha = 1;
            }
            else
            {
                this.userInfoBox.goGame_btn.mouseEnabled = false;
                this.userInfoBox.goGame_btn.alpha = 0.5;
            }
            return;
        }// end function

        private function setInvitGameBtn(B:Boolean) : void
        {
            if (B)
            {
                this.userInfoBox.invitGame_btn.mouseEnabled = true;
                this.userInfoBox.invitGame_btn.alpha = 1;
            }
            else
            {
                this.userInfoBox.invitGame_btn.mouseEnabled = false;
                this.userInfoBox.invitGame_btn.alpha = 0.5;
            }
            return;
        }// end function

        private function respHonorInfo(Info:Object) : void
        {
            this.honorInfo = Info;
            t.obj(Info);
            this.UserHonorFormController.cleanHonor();
            this.UserHonorFormController.ShowHonorList(Info as Array);
            this.userInfoBox.loading_mc.visible = false;
            return;
        }// end function

        private function respMedalInfo(Info:Object) : void
        {
            this.medalInfo = Info;
            t.obj(Info);
            this.UserMedalFormController.cleanLists();
            this.UserMedalFormController.setListArr(Info as Array);
            this.userInfoBox.loading_mc.visible = false;
            return;
        }// end function

        private function respMarryInfo(Info:Object) : void
        {
            if (this.userInfoBox)
            {
                this.UserMarryFormController.form2Btn();
            }
            this.userInfoBox.loading_mc.visible = false;
            this.marryInfo = Info;
            this.UserMarryFormController.setData(Info, this.userInfoBox.UserID);
            return;
        }// end function

        private function respFamilyInfo(data:Object) : void
        {
            this.userInfoBox.loading_mc.visible = false;
            this.familyInfo = data;
            if (uint(data.id) != 0)
            {
                this.userInfoBox.form4_mc.info_mc.visible = true;
                this.userInfoBox.form4_mc.noData_mc.visible = false;
                this.userInfoBox.form4_mc.info_mc.family_txt.htmlText = "<b>" + UStr.StringByHTMLString(data.fname) + "</b>";
                this.userInfoBox.form4_mc.info_mc.uname_txt.htmlText = "<b>" + UStr.StringByHTMLString(data.username) + "</b>";
                this.userInfoBox.form4_mc.info_mc.socre_txt.text = data.fintegral;
                this.userInfoBox.form4_mc.info_mc.num_txt.text = data.fcount + "/" + data.fmax;
                this.userInfoBox.form4_mc.info_mc.msg_txt.htmlText = "<b>" + data.fspeak + "</b>";
            }
            else
            {
                this.userInfoBox.form4_mc.info_mc.visible = false;
                this.userInfoBox.form4_mc.info_mc.family_txt.htmlText = "";
                this.userInfoBox.form4_mc.info_mc.uname_txt.htmlText = "";
                this.userInfoBox.form4_mc.info_mc.socre_txt.text = "";
                this.userInfoBox.form4_mc.info_mc.num_txt.text = "";
                this.userInfoBox.form4_mc.info_mc.msg_txt.htmlText = "";
                this.userInfoBox.form4_mc.noData_mc.visible = true;
            }
            return;
        }// end function

        private function respLuxuryInfo(data:Object) : void
        {
            this.userInfoBox.loading_mc.visible = false;
            this.form5Controller.isClearBtn = false;
            this.luxuryInfo = data;
            if (data.length > 0)
            {
                if (this.userInfoBox.UserID == UserData.UserInfo.UserId)
                {
                    this.form5Controller.isClearBtn = true;
                }
                this.userInfoBox.form5_mc.load_txt.visible = false;
                this.userInfoBox.form5_mc.title_txt.htmlText = "<b>[ " + data[0].username + " ]</b>";
                this.userInfoBox.form5_mc.msg_txt.htmlText = data[0].dates + " 赠送" + data[0].tname;
                this.form5Controller.loadLuxurySwf(data[0].turl2 + "?isstop=1");
            }
            else
            {
                this.userInfoBox.form5_mc.load_txt.visible = true;
                this.form5Controller.loadLuxurySwf("null");
                this.userInfoBox.form5_mc.title_txt.htmlText = "";
                this.userInfoBox.form5_mc.msg_txt.htmlText = "";
                this.userInfoBox.form5_mc.load_txt.text = "目前还没有奢侈品";
            }
            return;
        }// end function

        private function respDNInfo(data:Object) : void
        {
            var _loc_2:Object = null;
            this.userInfoBox.loading_mc.visible = false;
            if (data.DnInfo[0])
            {
                this.form1Controller.setDnInfo(data.DnInfo[0]);
            }
            else
            {
                _loc_2 = {win1:"0", win2:"0", win3:"0", lost:"0"};
                this.form1Controller.setDnInfo(_loc_2);
            }
            return;
        }// end function

        private function respLYInfo(data:Object) : void
        {
            var _loc_2:Object = null;
            this.userInfoBox.loading_mc.visible = false;
            if (data.LyInfo[0])
            {
                this.form1Controller.setLyInfo(data.LyInfo[0]);
            }
            else
            {
                _loc_2 = {win1:"0", win2:"0", win3:"0", lost:"0"};
                this.form1Controller.setLyInfo(_loc_2);
            }
            return;
        }// end function

        private function respSpyInfo(data:Object) : void
        {
            var _loc_2:Object = null;
            this.userInfoBox.loading_mc.visible = false;
            if (data.SpyInfo[0])
            {
                this.form1Controller.setSpyInfo(data.SpyInfo[0]);
            }
            else
            {
                _loc_2 = {uc_win:"0", Integral:"0", man_fail:"0", man_win:"0", uc_fail:"0"};
                this.form1Controller.setSpyInfo(_loc_2);
            }
            return;
        }// end function

        private function respGetfasInfo(Info:Object) : void
        {
            this.userInfoBox.form2_mc.book_mc.visible = false;
            this.userInfo = Info;
            this.form1Controller.clearData();
            this.form1Controller.userInfo = Info;
            this.userInfoBox.loading_mc.visible = false;
            this.userInfoBox.form1_mc.theName_txt.htmlText = "<b>" + Info.UserName + "<b>";
            this.userInfoBox.moodCtrl.mood = String(Info.Mood);
            this.loadFacePic(Info.UserFace);
            this.userInfoBox.form1_mc.killInfo_form.expp_txt.text = Info.EXP + "";
            this.userInfoBox.form1_mc.killInfo_form.integral_txt.text = Info.Integral + "";
            if (!this.userInfoBox.form1_mc.vip_log)
            {
                this.userInfoBox.form1_mc.vip_log = this.userInfoBox.form1_mc.addChild(new VipLeft_Log());
                this.userInfoBox.form1_mc.vip_log.y = 33;
                this.userInfoBox.form1_mc.vip_log.x = 180;
                this.userInfoBox.form1_mc.vip_log.name = "vipLog";
                this.userInfoBox.form1_mc.vip_log.buttonMode = true;
                this.userInfoBox.form1_mc.vip_log.useHandCursor = true;
                this.userInfoBox.form1_mc.vip_log.addEventListener(MouseEvent.CLICK, this.btnClickhandler);
            }
            var _loc_2:* = this.userInfoBox.form1_mc.vip_log.width;
            if (!this.userInfoBox.form1_mc.killInfo_form.Rank_log)
            {
                this.userInfoBox.form1_mc.killInfo_form.Rank_log = this.userInfoBox.form1_mc.killInfo_form.addChild(new IntegralRank_log());
                this.userInfoBox.form1_mc.killInfo_form.Rank_log.y = -16;
                this.userInfoBox.form1_mc.killInfo_form.Rank_log.name = "Ranklog";
            }
            if (Info.UserName != UserData.UserInfo.UserName)
            {
                this.setBtns(this.userInfoBox.T);
                MainView.ALT.setAlt(this.userInfoBox.form1_mc.vip_log, "VIP" + Info.Vip, 1);
            }
            else
            {
                this.userInfoBox.moodCtrl.isCanEdit = true;
                MainView.ALT.setAlt(this.userInfoBox.form1_mc.vip_log, "VIP值：" + Info.VipScore, 1);
            }
            this.userInfoBox.form1_mc.vip_log.gotoAndStop("vip" + int(Info.Vip));
            if (int(Info.IntegralRank) == 0)
            {
                this.userInfoBox.form1_mc.killInfo_form.Rank_log.visible = false;
            }
            else
            {
                this.userInfoBox.form1_mc.killInfo_form.Rank_log.gotoAndStop(int(Info.IntegralRank));
                MainView.ALT.setAlt(this.userInfoBox.form1_mc.killInfo_form.Rank_log, "全服积分排名:" + Info.IntegralRank, 1);
                this.userInfoBox.form1_mc.killInfo_form.Rank_log.visible = true;
            }
            this.userInfoBox.form1_mc.vip_log.x = -this.userInfoBox.form1_mc.vip_log.width + 205;
            this.userInfoBox.form1_mc.killInfo_form.Rank_log.x = this.userInfoBox.form1_mc.vip_log.x - 28;
            this.form1Controller.levelObj.setLevel(int(Info.Integral));
            if (String(Info.UserSex) != "0")
            {
            }
            if (String(Info.UserSex) == "true")
            {
                this.userInfoBox.form1_mc.sex_mc.gotoAndStop(1);
            }
            else
            {
                this.userInfoBox.form1_mc.sex_mc.gotoAndStop(2);
            }
            this.userInfoBox.form1_mc.killInfo_form.wins_txt.text = String(Info.Wintimes);
            this.userInfoBox.form1_mc.killInfo_form.losts_txt.text = String(Info.Losttimes);
            this.userInfoBox.form1_mc.killInfo_form.winP_txt.text = int(int(Info.Wintimes) / (int(Info.Wintimes) + int(Info.Losttimes)) * 100) + "%";
            if (String(Info.FamilyName) != "null")
            {
            }
            if (Info.FamilyName != "")
            {
                this.userInfoBox.form1_mc.killInfo_form.familyName_txt.htmlText = "<b>" + UStr.StringByHTMLString(Info.FamilyName) + "<b>";
            }
            else
            {
                this.userInfoBox.form1_mc.killInfo_form.familyName_txt.htmlText = "<b>暂无<b>";
            }
            if (String(Info.MarryName) != "null")
            {
            }
            if (Info.MarryName != "")
            {
                this.userInfoBox.form1_mc.killInfo_form.marryName_txt.htmlText = "<b>" + Info.MarryName + "<b>";
            }
            else
            {
                this.userInfoBox.form1_mc.killInfo_form.marryName_txt.htmlText = "<b>暂无<b>";
            }
            if (this.userInfoBox.T == "info")
            {
            }
            if (Resource.AdminPassword != ",lpmkonji")
            {
                this.userInfoBox.form1_mc.killInfo_form.where_title.visible = false;
                this.userInfoBox.form1_mc.killInfo_form.where_txt.text = "";
            }
            else
            {
                this.userInfoBox.form1_mc.killInfo_form.where_title.visible = true;
                if (uint(Info.Online) == 0)
                {
                    this.userInfoBox.form1_mc.killInfo_form.where_txt.text = "离线";
                    this.setGoGameBtn(false);
                    this.setInvitGameBtn(false);
                }
                else if (uint(Info.Online) == int(MainData.LoginInfo.Id))
                {
                    if (uint(Info.Room) == 0)
                    {
                        this.userInfoBox.form1_mc.killInfo_form.where_txt.text = "大厅";
                        this.setGoGameBtn(false);
                        if (uint(UserData.UserRoom) == 0)
                        {
                            this.setInvitGameBtn(false);
                        }
                        else
                        {
                            this.setInvitGameBtn(true);
                        }
                    }
                    else if (uint(Info.Room) > 0)
                    {
                        this.userInfoBox.form1_mc.killInfo_form.where_txt.text = RoomData.getRoomWhereName(uint(Info.Room));
                        if (uint(UserData.UserRoom) != uint(Info.Room))
                        {
                            this.setGoGameBtn(true);
                        }
                        else
                        {
                            this.setGoGameBtn(false);
                        }
                        if (uint(UserData.UserRoom) > 0)
                        {
                            this.setInvitGameBtn(true);
                        }
                        else
                        {
                            this.setInvitGameBtn(false);
                        }
                    }
                }
                else
                {
                    if (Resource.AdminPassword == ",lpmkonji")
                    {
                        this.userInfoBox.form1_mc.killInfo_form.addEventListener(TextEvent.LINK, this.linkHandler);
                        this.userInfoBox.form1_mc.killInfo_form.where_txt.htmlText = "<a href=\"event:" + Info.Online + "\">" + MainData.getLineName(Info.Online) + "</a>";
                    }
                    else
                    {
                        this.userInfoBox.form1_mc.killInfo_form.where_txt.text = MainData.getLineName(Info.Online);
                    }
                    if (uint(UserData.UserRoom) > 0)
                    {
                        this.setInvitGameBtn(true);
                    }
                    else
                    {
                        this.setInvitGameBtn(false);
                    }
                    this.setGoGameBtn(true);
                }
            }
            this.form1Controller.init();
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:Array = null;
            if (int(event.text))
            {
                int(event.text);
            }
            if (MainData.LoginInfo.Id != int(event.text))
            {
                _loc_2 = uint(event.text);
                UserData.UserRoom = 0;
                if (MainData.LinesObj[_loc_2].Server.indexOf("|") > -1)
                {
                    _loc_3 = MainData.LinesObj[_loc_2].Server.split("|");
                }
                else
                {
                    _loc_3 = new Array(MainData.LinesObj[_loc_2].Server);
                }
                Resource.so.data.serverI = 0;
                MainData.LoginInfo.Id = int(event.text);
                MainData.LoginInfo.Server = _loc_3;
                facade.sendNotification(GameEvents.LOGINEVENT.LOGIN);
            }
            return;
        }// end function

        private function loadFacePic(PICURL:String) : void
        {
            ViewPicLoad.load(PICURL, this.userInfoBox.headPic_mc.loadmc);
            this.userInfoBox.headPic_mc.loadmc.mask = this.userInfoBox.headPic_mc.mask_mc;
            return;
        }// end function

        private function cleanFacePic() : void
        {
            mcFunc.removeAllMc(this.userInfoBox.headPic_mc.loadmc);
            return;
        }// end function

        GameEvents.PlUSEVENT.USERINFOBOXSHOW = "USERINFOBOX_SHOW";
        GameEvents.PlUSEVENT.FREINFOBOXSHOW = "FREINFOBOX_SHOW";
        GameEvents.PlUSEVENT.INFOBOXSHOW = "INFOBOX_SHOW";
        GameEvents.PlUSEVENT.USERINFOBOXCLOSE = "USERINFOBOX_CLOSE";
        GameEvents.PlUSEVENT.PLAYERINFO = "USERINFOBOX_PLAYERINFO";
        GameEvents.PlUSEVENT.HONORINFO = "USERINFOBOX_HONORINFO";
        GameEvents.PlUSEVENT.MEDALINFO = "USERINFOBOX_MEDALINFO";
        GameEvents.PlUSEVENT.MARRYINFO = "USERINFOBOX_MARRYINFO";
        GameEvents.PlUSEVENT.LuxuryINFO = "USERINFOBOX_LuxuryINFO";
        GameEvents.PlUSEVENT.FAMILYINFO = "FAMILY_MYFAMILY_DATA";
        GameEvents.PlUSEVENT.MyTeachersINFO = "FAMILY_MyTeachers_DATA";
        GameEvents.PlUSEVENT.MyStudentsINFO = "FAMILY_MyStudents_DATA";
        GameEvents.PlUSEVENT.SPYINFO_DATA = "USERINFOBOX_SPYINFO_DATA";
        GameEvents.PlUSEVENT.LYINFO_DATA = "USERINFOBOX_LYINFO_DATA";
        GameEvents.PlUSEVENT.DNINFO_DATA = "USERINFOBOX_DNINFO_DATA";
        GameEvents.PlUSEVENT.OTHERINFO_DATA = "USERINFOBOX_OTHERINFO_DATA";
    }
}
