package controller
{
    import Core.*;
    import Core.model.data.*;
    import flash.events.*;
    import flash.utils.*;
    import model.*;
    import roomEvents.*;

    public class KillerRoomGameOverController extends Object
    {
        private var facade:Object;
        private var closeTimer:Timer;
        public var theViewer:gameOver_frame;
        private var theParent:Object;

        public function KillerRoomGameOverController(param1:gameOver_frame, param2:Object)
        {
            this.closeTimer = new Timer(30 * 1000, 1);
            this.theViewer = param1;
            this.theParent = param2;
            this.facade = MyFacade.getInstance();
            this.theViewer.close_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.closeFrame);
            this.closeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.closeFrame);
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.init);
            return;
        }// end function

        private function init(event:Event) : void
        {
            this.theViewer.x = MainData.MainStage.stageWidth / 2;
            this.theViewer.y = MainData.MainStage.stageHeight / 2;
            this.theViewer.list_bg.visible = false;
            this.closeTimer.start();
            return;
        }// end function

        public function closeFrame(event:Event = null) : void
        {
            var _loc_2:uint = 0;
            this.closeTimer.stop();
            try
            {
                this.theParent.removeChild(this.theViewer);
            }
            catch (e)
            {
            }
            _loc_2 = 1;
            while (_loc_2 <= 8)
            {
                
                this.clearTxt(this.theViewer["ss" + _loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = 1;
            while (_loc_2 <= 4)
            {
                
                this.clearTxt(this.theViewer["jc" + _loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = 1;
            while (_loc_2 <= 14)
            {
                
                this.clearTxt(this.theViewer["pm" + _loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function setValue(param1:Object, param2:Boolean = false) : void
        {
            var _loc_6:Object = null;
            var _loc_3:* = param1.Winner;
            var _loc_4:* = param1.Players;
            var _loc_5:* = param1.SysMsgs;
            for (_loc_6 in _loc_5)
            {
                
                this.facade.sendNotification(KillerRoomEvents.SYSBOXMSG, "<font color=\'#FF0000\'>[提示]</b></font> " + _loc_5[_loc_6]);
            }
            if (KillerRoomData.GameType == 15)
            {
                this.theViewer.JcTitle_mc.visible = false;
                this.theViewer.JwinLose_mc.visible = false;
            }
            else
            {
                this.theViewer.JcTitle_mc.visible = true;
                this.theViewer.JwinLose_mc.visible = true;
            }
            this.theParent.addChild(this.theViewer);
            _loc_4.sortOn(["Site"], [Array.NUMERIC]);
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            var _loc_10:uint = 0;
            while (_loc_10 < _loc_4.length)
            {
                
                if (uint(_loc_4[_loc_10].Iden) == 1 || uint(_loc_4[_loc_10].Iden) == 8 || uint(_loc_4[_loc_10].Iden) == 9 || uint(_loc_4[_loc_10].Iden) == 12 || uint(_loc_4[_loc_10].Iden) == 7 || uint(_loc_4[_loc_10].Iden) == 11 || uint(_loc_4[_loc_10].Iden) == 14)
                {
                    _loc_9 = _loc_9 + 1;
                    this.setMcValue(this.theViewer["pm" + _loc_9], _loc_4[_loc_10]);
                    if (_loc_4[_loc_10].Site == KillerRoomData.UserPlayerID)
                    {
                        this.theViewer.list_bg.x = this.theViewer["pm" + _loc_9].x;
                        this.theViewer.list_bg.y = this.theViewer["pm" + _loc_9].y;
                        this.theViewer.list_bg.visible = true;
                        if (MainData.newUserTaskData.nowId == 1003)
                        {
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                    }
                    if (_loc_3 == 2)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("haha", _loc_4[_loc_10].Site));
                    }
                    else if (_loc_3 == 3)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("cry", _loc_4[_loc_10].Site));
                    }
                }
                else if (uint(_loc_4[_loc_10].Iden) == 2)
                {
                    _loc_7 = _loc_7 + 1;
                    this.setMcValue(this.theViewer["jc" + _loc_7], _loc_4[_loc_10]);
                    if (_loc_4[_loc_10].Site == KillerRoomData.UserPlayerID)
                    {
                        this.theViewer.list_bg.x = this.theViewer["jc" + _loc_7].x;
                        this.theViewer.list_bg.y = this.theViewer["jc" + _loc_7].y;
                        this.theViewer.list_bg.visible = true;
                        if (MainData.newUserTaskData.nowId == 1003)
                        {
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                    }
                    if (_loc_3 == 2)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("haha", _loc_4[_loc_10].Site));
                    }
                    else if (_loc_3 == 3)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("cry", _loc_4[_loc_10].Site));
                    }
                }
                else if (uint(_loc_4[_loc_10].Iden) == 3 || uint(_loc_4[_loc_10].Iden) == 6 || uint(_loc_4[_loc_10].Iden) == 10 || uint(_loc_4[_loc_10].Iden) == 13 || uint(_loc_4[_loc_10].Iden) == 15)
                {
                    _loc_8 = _loc_8 + 1;
                    this.setMcValue(this.theViewer["ss" + _loc_8], _loc_4[_loc_10]);
                    if (_loc_4[_loc_10].Site == KillerRoomData.UserPlayerID)
                    {
                        this.theViewer.list_bg.x = this.theViewer["ss" + _loc_8].x;
                        this.theViewer.list_bg.y = this.theViewer["ss" + _loc_8].y;
                        this.theViewer.list_bg.visible = true;
                        if (MainData.newUserTaskData.nowId == 1003)
                        {
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                    }
                    if (_loc_3 == 2)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("cry", _loc_4[_loc_10].Site));
                    }
                    else if (_loc_3 == 3)
                    {
                        this.facade.sendNotification(KillerRoomEvents.BODYFACE, new Array("haha", _loc_4[_loc_10].Site));
                    }
                }
                _loc_10 = _loc_10 + 1;
            }
            if (_loc_3 == 2)
            {
                if (KillerRoomData.GameType == 15)
                {
                    this.theViewer.pmwinLogo_mc.visible = true;
                    this.theViewer.winLogo_mc.visible = false;
                }
                else
                {
                    this.theViewer.pmwinLogo_mc.visible = false;
                    this.theViewer.winLogo_mc.visible = true;
                }
                this.theViewer.loseLogo_mc.visible = false;
                this.theViewer.SwinLose_mc.gotoAndStop(2);
                if (param2)
                {
                    this.theViewer.JwinLose_mc.gotoAndStop(3);
                    this.theViewer.PwinLose_mc.gotoAndStop(3);
                }
                else
                {
                    this.theViewer.JwinLose_mc.gotoAndStop(1);
                    this.theViewer.PwinLose_mc.gotoAndStop(1);
                }
            }
            else if (_loc_3 == 3)
            {
                if (param2)
                {
                    this.theViewer.SwinLose_mc.gotoAndStop(3);
                }
                else
                {
                    this.theViewer.SwinLose_mc.gotoAndStop(1);
                }
                this.theViewer.JwinLose_mc.gotoAndStop(2);
                this.theViewer.PwinLose_mc.gotoAndStop(2);
                this.theViewer.pmwinLogo_mc.visible = false;
                this.theViewer.winLogo_mc.visible = false;
                this.theViewer.loseLogo_mc.visible = true;
            }
            return;
        }// end function

        private function setMcValue(param1:Object, param2:Object) : void
        {
            var mc:* = param1;
            var obj:* = param2;
            mc.id_txt.text = String(obj.Site);
            mc.username_txt.text = obj.UserName;
            mc.score_txt.text = String(obj.Score);
            mc.aScore_txt.text = String(obj.aScore);
            mc.coin_txt.text = String(obj.Gold);
            try
            {
                mc.iden_log.gotoAndStop("iden" + obj.Iden);
            }
            catch (e)
            {
                mc.iden_log.gotoAndStop(1);
            }
            return;
        }// end function

        private function clearTxt(param1:Object) : void
        {
            param1.id_txt.text = "";
            param1.username_txt.text = "";
            param1.score_txt.text = "";
            param1.aScore_txt.text = "";
            param1.coin_txt.text = "";
            param1.iden_log.gotoAndStop(0);
            return;
        }// end function

    }
}
