package view
{
    import Core.*;
    import Core.model.data.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class UserInfoBoxForm6 extends Object
    {
        private var _arrBox:Array;
        private var facade:MyFacade;
        private var theViewer:MovieClip;
        private var userInfo:Object;
        private var pageController:UserInfoBoxFormListPageController;

        public function UserInfoBoxForm6(MC:MovieClip)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            this.theViewer.mymaster_form.getapp_btn.addEventListener("click", this.ClickHandler);
            this.theViewer.myapp_form.teach_btn.addEventListener("click", this.ClickHandler);
            this.theViewer.myapp_form.menu1_mc.history_btn.addEventListener("click", this.ClickHandler);
            this.theViewer.myapp_form.menu2_mc.myapps_btn.addEventListener("click", this.ClickHandler);
            this.theViewer.myapp_form.menu1_mc.visible = true;
            this.theViewer.myapp_form.menu2_mc.visible = false;
            this.theViewer.mymaster_form.finish_btn.visible = false;
            this.theViewer.form6NoData_mc.visible = false;
            this.pageController = new UserInfoBoxFormListPageController(this.theViewer.myapp_form.pagelist_mc, 1, 1);
            this.pageController.addEventListener(UserInfoBoxFormListPageController.PAGE_CLICK, this.pageHandler);
            return;
        }// end function

        private function pageHandler(event:Event) : void
        {
            var _loc_2:* = event.target.page;
            var _loc_3:* = new Object();
            _loc_3.cmd = "TeachCmd_MyStudents";
            _loc_3.Type = "1";
            _loc_3.Page = _loc_2 + "";
            _loc_3.UserId = String(this.userInfo.UserId);
            this.facade.sendNotification(GameEvents.NETCALL, _loc_3);
            return;
        }// end function

        public function setTeachInfo(UserInfo:Object, Info:Object) : void
        {
            var _loc_4:userinfobox_form6_list_mc = null;
            this.theViewer.mymaster_form.getapp_btn.mouseEnabled = true;
            this.userInfo = UserInfo;
            this.theViewer.mymaster_form.visible = true;
            this.theViewer.myapp_form.visible = false;
            this.theViewer.form6NoData_mc.visible = false;
            mcFunc.removeAllMc(this.theViewer.mymaster_form.list);
            var _loc_3:uint = 0;
            while (_loc_3 < Info.Users.length)
            {
                
                _loc_4 = new userinfobox_form6_list_mc();
                this.theViewer.mymaster_form.list.addChild(_loc_4);
                new UserInfoBoxForm6ListChid(_loc_4, Info.Users[_loc_3], UserInfo.UserId == UserData.UserInfo.UserId, 1);
                _loc_3 = _loc_3 + 1;
            }
            if (UserInfo.UserId == UserData.UserInfo.UserId)
            {
                this.theViewer.mymaster_form.listtitle_txt.text = "状态";
                if (Info.Users.length == 0)
                {
                    this.theViewer.mymaster_form.getapp_btn.visible = false;
                }
                else
                {
                    this.theViewer.mymaster_form.getapp_btn.visible = false;
                }
            }
            else
            {
                if (UserInfo.Integral < 700)
                {
                }
                if (UserData.UserInfo.Integral >= 6400)
                {
                    this.theViewer.mymaster_form.listtitle_txt.text = "等级";
                    if (Info.Users.length == 0)
                    {
                        this.theViewer.mymaster_form.getapp_btn.visible = true;
                    }
                    else
                    {
                        this.theViewer.mymaster_form.getapp_btn.visible = false;
                    }
                }
                else
                {
                    this.theViewer.mymaster_form.listtitle_txt.text = "等级";
                    this.theViewer.mymaster_form.getapp_btn.visible = false;
                }
            }
            mcFunc.reSetMcsWhere(this.theViewer.mymaster_form.list, 240, 0, 240, 20);
            return;
        }// end function

        public function setStudentInfo(UserInfo:Object, Info:Object) : void
        {
            var _loc_4:userinfobox_form6_list_mc = null;
            if (UserInfo.Integral < 6400)
            {
            }
            if (Info.Users.length == 0)
            {
                this.theViewer.form6NoData_mc.visible = true;
                return;
            }
            this.theViewer.form6NoData_mc.visible = false;
            this.theViewer.myapp_form.teach_btn.mouseEnabled = true;
            if (UserInfo.UserId == UserData.UserInfo.UserId)
            {
                this.theViewer.myapp_form.listtitle_txt.text = "状态";
                this.theViewer.myapp_form.teach_btn.visible = false;
            }
            else
            {
                if (UserInfo.Integral >= 6400)
                {
                }
                if (UserData.UserInfo.Integral < 700)
                {
                }
                if (Info.Type == 0)
                {
                    this.theViewer.myapp_form.listtitle_txt.text = "等级";
                    this.theViewer.myapp_form.teach_btn.visible = true;
                }
                else
                {
                    this.theViewer.myapp_form.listtitle_txt.text = "等级";
                    this.theViewer.myapp_form.teach_btn.visible = false;
                }
            }
            if (Info.Type == 0)
            {
                this.theViewer.myapp_form.menu1_mc.visible = true;
                this.theViewer.myapp_form.menu2_mc.visible = false;
                this.theViewer.myapp_form.pagelist_mc.visible = false;
                if (int(Info.Empty) == 0)
                {
                    this.theViewer.myapp_form.teach_btn.visible = false;
                }
                this.theViewer.myapp_form.count_txt.text = "还可收 " + Info.Empty + " 个徒弟";
            }
            else
            {
                this.theViewer.myapp_form.pagelist_mc.visible = true;
                this.theViewer.myapp_form.teach_btn.visible = false;
                this.theViewer.myapp_form.menu1_mc.visible = false;
                this.theViewer.myapp_form.menu2_mc.visible = true;
                this.theViewer.myapp_form.count_txt.text = "";
                this.pageController.setPages(Info.Page, Info.Pages);
            }
            this.userInfo = UserInfo;
            this.theViewer.mymaster_form.visible = false;
            this.theViewer.myapp_form.visible = true;
            mcFunc.removeAllMc(this.theViewer.myapp_form.list);
            var _loc_3:uint = 0;
            while (_loc_3 < Info.Users.length)
            {
                
                _loc_4 = new userinfobox_form6_list_mc();
                this.theViewer.myapp_form.list.addChild(_loc_4);
                new UserInfoBoxForm6ListChid(_loc_4, Info.Users[_loc_3], UserInfo.UserId == UserData.UserInfo.UserId, 2 + int(Info.Type));
                _loc_3 = _loc_3 + 1;
            }
            mcFunc.reSetMcsWhere(this.theViewer.myapp_form.list, 240, 0, 240, 20);
            return;
        }// end function

        private function ClickHandler(event:Event) : void
        {
            var _loc_2:* = new Object();
            if (event.target.name == "getapp_btn")
            {
                this.theViewer.mymaster_form.getapp_btn.mouseEnabled = false;
                _loc_2.cmd = "TeachCmd_Request";
                _loc_2.ToUserId = String(this.userInfo.UserId);
                _loc_2.Type = "2";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.target.name == "teach_btn")
            {
                this.theViewer.myapp_form.teach_btn.mouseEnabled = false;
                _loc_2.cmd = "TeachCmd_Request";
                _loc_2.ToUserId = String(this.userInfo.UserId);
                _loc_2.Type = "1";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.target.name == "history_btn")
            {
                this.theViewer.myapp_form.menu1_mc.visible = false;
                this.theViewer.myapp_form.menu2_mc.visible = true;
                _loc_2.cmd = "TeachCmd_MyStudents";
                _loc_2.Type = "1";
                _loc_2.Page = "1";
                _loc_2.UserId = String(this.userInfo.UserId);
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else if (event.target.name == "myapps_btn")
            {
                this.theViewer.myapp_form.menu1_mc.visible = true;
                this.theViewer.myapp_form.menu2_mc.visible = false;
                _loc_2.cmd = "TeachCmd_MyStudents";
                _loc_2.Type = "0";
                _loc_2.UserId = String(this.userInfo.UserId);
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            return;
        }// end function

        private function getCount(I:int) : uint
        {
            var _loc_2:uint = 0;
            if (I < 6400)
            {
                _loc_2 = 0;
            }
            else if (I < 24000)
            {
                _loc_2 = 1;
            }
            else if (I < 60000)
            {
                _loc_2 = 2;
            }
            else if (I < 180000)
            {
                _loc_2 = 3;
            }
            else if (I < 360000)
            {
                _loc_2 = 4;
            }
            else if (I >= 360000)
            {
                _loc_2 = 5;
            }
            return _loc_2;
        }// end function

    }
}
