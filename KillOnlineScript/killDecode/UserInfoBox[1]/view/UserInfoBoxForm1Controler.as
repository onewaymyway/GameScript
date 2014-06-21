package view
{
    import Core.*;
    import Core.model.data.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class UserInfoBoxForm1Controler extends Object
    {
        private var _data:Object = null;
        private var myLoader:Loader;
        private var theViewer:MovieClip;
        private var facade:MyFacade;
        private var selectMenu:SelectOneBox;
        private var spyInfo:Object;
        private var otherInfo:Object;
        public var userInfo:Object;
        public var levelObj:level_logo_l;
        public var SpyLevelObj:Spylevel_log;

        public function UserInfoBoxForm1Controler(MC:MovieClip)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            if (!this.levelObj)
            {
                this.levelObj = new level_logo_l();
                this.theViewer.killInfo_form.addChild(this.levelObj);
                this.levelObj.y = 10;
                this.levelObj.x = 2;
            }
            if (!this.SpyLevelObj)
            {
                this.SpyLevelObj = new Spylevel_log();
                this.theViewer.spyInfo_form.addChild(this.SpyLevelObj);
                this.SpyLevelObj.y = 8;
                this.SpyLevelObj.x = 10;
            }
            if (this.selectMenu == null)
            {
                this.selectMenu = new SelectOneBox();
                this.selectMenu.addEventListener(MouseEvent.MOUSE_DOWN, this.selectMenuHandler);
            }
            this.selectMenu.SetBoxs([this.theViewer.kill_btn, this.theViewer.spy_btn, this.theViewer.other_btn], ["killinfo", "spyinfo", "otherinfo"], 0);
            return;
        }// end function

        private function selectMenuHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            this.theViewer.killInfo_form.visible = false;
            this.theViewer.spyInfo_form.visible = false;
            this.theViewer.otherInfo_form.visible = false;
            if (this.selectMenu.selectData == "killinfo")
            {
                if (this.userInfo)
                {
                    this.levelObj.setLevel(this.userInfo.Integral);
                }
                this.theViewer.killInfo_form.visible = true;
            }
            else if (this.selectMenu.selectData == "spyinfo")
            {
                if (this.spyInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "SpyInfo";
                    _loc_2.UserId = String(this.userInfo.UserId);
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                else
                {
                    this.SpyLevelObj.setLevel(this.spyInfo.Integral);
                }
                this.theViewer.spyInfo_form.visible = true;
            }
            else if (this.selectMenu.selectData == "lyinfo")
            {
                this.theViewer.lyInfo_form.visible = true;
            }
            else if (this.selectMenu.selectData == "otherinfo")
            {
                if (this.otherInfo == null)
                {
                    _loc_2 = new Object();
                    _loc_2.cmd = "OtherInfo";
                    _loc_2.UserId = String(this.userInfo.UserId);
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
                }
                this.theViewer.setChildIndex(this.theViewer.otherInfo_form, (this.theViewer.numChildren - 1));
                this.theViewer.otherInfo_form.visible = true;
            }
            return;
        }// end function

        public function setOtherInfo(Info:Object) : void
        {
            var _loc_2:Object = null;
            this.otherInfo = Info;
            if (Info.LyInfo)
            {
            }
            if (Info.LyInfo.length > 0)
            {
                this.setLyInfo(Info.LyInfo[0]);
            }
            else
            {
                _loc_2 = {win1:"0", win2:"0", win3:"0", lost:"0"};
                this.setLyInfo(_loc_2);
            }
            if (Info.DnInfo)
            {
            }
            if (Info.DnInfo.length > 0)
            {
                this.setDnInfo(Info.DnInfo[0]);
            }
            else
            {
                _loc_2 = {win1:"0", win2:"0", win3:"0", lost:"0"};
                this.setDnInfo(_loc_2);
            }
            if (Info.DdzInfo)
            {
            }
            if (Info.DdzInfo.length > 0)
            {
                this.setDdzInfo(Info.DdzInfo[0]);
            }
            else
            {
                _loc_2 = {win1:"0", win2:"0", win3:"0", win4:"0", lost:"0"};
                this.setDdzInfo(_loc_2);
            }
            return;
        }// end function

        public function setDdzInfo(Info:Object) : void
        {
            this.theViewer.otherInfo_form.ldInfo_form.win1_txt.text = String(Info.win1);
            this.theViewer.otherInfo_form.ldInfo_form.win5_txt.text = String(Info.win2);
            this.theViewer.otherInfo_form.ldInfo_form.win10_txt.text = String(Info.win3);
            this.theViewer.otherInfo_form.ldInfo_form.win20_txt.text = String(Info.win4);
            this.theViewer.otherInfo_form.ldInfo_form.P_txt.text = int((int(Info.win1) + int(Info.win2) + int(Info.win3) + int(Info.win4)) / (int(Info.win1) + int(Info.win2) + int(Info.win3) + int(Info.win4) + int(Info.lost)) * 100) + "%";
            this.theViewer.otherInfo_form.ldInfo_form.lostT_txt.text = String(Info.lost);
            return;
        }// end function

        public function setLyInfo(Info:Object) : void
        {
            this.theViewer.otherInfo_form.lyInfo_form.win100_txt.text = String(Info.win1);
            this.theViewer.otherInfo_form.lyInfo_form.win1000_txt.text = String(Info.win2);
            this.theViewer.otherInfo_form.lyInfo_form.win10000_txt.text = String(Info.win3);
            this.theViewer.otherInfo_form.lyInfo_form.P_txt.text = int((int(Info.win1) + int(Info.win2) + int(Info.win3)) / (int(Info.win1) + int(Info.win2) + int(Info.win3) + int(Info.lost)) * 100) + "%";
            this.theViewer.otherInfo_form.lyInfo_form.lostT_txt.text = String(Info.lost);
            return;
        }// end function

        public function setDnInfo(Info:Object) : void
        {
            this.theViewer.otherInfo_form.dnInfo_form.win100_txt.text = String(Info.win1);
            this.theViewer.otherInfo_form.dnInfo_form.win1000_txt.text = String(Info.win2);
            this.theViewer.otherInfo_form.dnInfo_form.win10000_txt.text = String(Info.win3);
            this.theViewer.otherInfo_form.dnInfo_form.P_txt.text = int((int(Info.win1) + int(Info.win2) + int(Info.win3)) / (int(Info.win1) + int(Info.win2) + int(Info.win3) + int(Info.lost)) * 100) + "%";
            this.theViewer.otherInfo_form.dnInfo_form.lostT_txt.text = String(Info.lost);
            return;
        }// end function

        public function setSpyInfo(Info:Object) : void
        {
            this.spyInfo = Info;
            this.theViewer.spyInfo_form.integral_txt.text = String(Info.Integral);
            this.theViewer.spyInfo_form.winT_txt.text = String(int(Info.uc_win) + int(Info.man_win));
            this.theViewer.spyInfo_form.lostT_txt.text = String(int(Info.uc_fail) + int(Info.man_fail));
            this.theViewer.spyInfo_form.winS_txt.text = String(int(Info.uc_win));
            this.theViewer.spyInfo_form.lostS_txt.text = String(int(Info.uc_fail));
            this.theViewer.spyInfo_form.P_txt.text = int((int(Info.uc_win) + int(Info.man_win)) / (int(Info.uc_win) + int(Info.man_win) + int(Info.uc_fail) + int(Info.man_fail)) * 100) + "%";
            this.SpyLevelObj.setLevel(this.spyInfo.Integral);
            return;
        }// end function

        public function clearData() : void
        {
            this.theViewer.spyInfo_form.integral_txt.text = "";
            this.theViewer.spyInfo_form.winT_txt.text = "";
            this.theViewer.spyInfo_form.lostT_txt.text = "";
            this.theViewer.spyInfo_form.winS_txt.text = "";
            this.theViewer.spyInfo_form.lostS_txt.text = "";
            this.theViewer.spyInfo_form.P_txt.text = "";
            var _loc_1:Object = {win1:"", win2:"", win3:"", win4:"", lost:""};
            this.setDnInfo(_loc_1);
            this.setLyInfo(_loc_1);
            this.setDdzInfo(_loc_1);
            this.spyInfo = null;
            this.userInfo = null;
            this.otherInfo = null;
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:Object = null;
            if (MainData.getGameArea() == GameAreaType.spy)
            {
                this.theViewer.spy_btn.x = -14;
                this.theViewer.kill_btn.x = 42;
                this.selectMenu.index = 1;
                if (this.spyInfo == null)
                {
                    if (this.userInfo)
                    {
                        _loc_1 = new Object();
                        _loc_1.cmd = "SpyInfo";
                        _loc_1.UserId = String(this.userInfo.UserId);
                        this.facade.sendNotification(GameEvents.NETCALL, _loc_1);
                    }
                }
                else
                {
                    this.SpyLevelObj.setLevel(this.spyInfo.Integral);
                }
                this.theViewer.killInfo_form.visible = false;
                this.theViewer.spyInfo_form.visible = true;
                this.theViewer.otherInfo_form.visible = false;
            }
            else
            {
                this.selectMenu.index = 0;
                this.theViewer.kill_btn.x = -14;
                this.theViewer.spy_btn.x = 42;
                this.theViewer.killInfo_form.visible = true;
                this.theViewer.spyInfo_form.visible = false;
                this.theViewer.otherInfo_form.visible = false;
            }
            return;
        }// end function

    }
}
