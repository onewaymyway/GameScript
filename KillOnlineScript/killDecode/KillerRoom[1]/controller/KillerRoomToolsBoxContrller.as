package controller
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import model.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomToolsBoxContrller extends MovieClip
    {
        private var facade:Object;
        private var menuSelect:Object;
        public var _datalist:Array;
        private var childArr:Array;
        public var selectedChild:Object;
        private var theViewer:killerRoom_tool_list_box;

        public function KillerRoomToolsBoxContrller(param1:killerRoom_tool_list_box)
        {
            this.theViewer = param1;
            this.childArr = new Array();
            this.facade = MyFacade.getInstance();
            this.theViewer.toolgoon_num.addEventListener(Event.ADDED_TO_STAGE, this.addedStagehandler);
            this.theViewer.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStagehandler);
            this.theViewer.gobuy_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.close_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.close2_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.reset_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.buy_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.buyLog_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.toolgoon_num.addEventListener(Event.CHANGE, this.toolNumHanlder);
            this.theViewer.toolgoon_chick.addEventListener(Event.CHANGE, this.toolChickHanlder);
            this.menuSelect = new SelectOneBox();
            this.menuSelect.addEventListener(MouseEvent.MOUSE_DOWN, this.menuSelectHandler);
            this.menuSelect.SetBoxs([this.theViewer.class1_btn, this.theViewer.class2_btn, this.theViewer.class3_btn], [1, 2, 3], 0);
            return;
        }// end function

        private function toolChickHanlder(event:Event) : void
        {
            var _loc_2:AlertVO = null;
            if (UserData.UserInfo.Vip > 0)
            {
                if (KillerRoomData.beToolID == 786 || KillerRoomData.beToolID == 100786)
                {
                    this.theViewer.toolgoon_chick.selectData = 0;
                    _loc_2 = new AlertVO();
                    _loc_2.msg = "阿帕奇不能连续使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
                else if (this.menuSelect.selectData != 3)
                {
                    KillerRoomData.isToolSeries = this.theViewer.toolgoon_chick.selectData;
                    if (KillerRoomData.isToolSeries == 0)
                    {
                        this.facade.sendNotification(KillerRoomEvents.TOOLSACT_SERIESACT_STOP);
                    }
                }
                else
                {
                    this.theViewer.toolgoon_chick.selectData = 0;
                    _loc_2 = new AlertVO();
                    _loc_2.msg = "功能卡不能连续使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
            }
            else
            {
                this.theViewer.toolgoon_chick.selectData = 0;
                _loc_2 = new AlertVO();
                _loc_2.msg = "VIP玩家才可使用";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            return;
        }// end function

        private function toolNumHanlder(event:Event) : void
        {
            KillerRoomData.toolSeriesNum = this.theViewer.toolgoon_num.num;
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            this.theViewer.x = this.theViewer.stage.stageWidth - 320;
            this.theViewer.y = this.theViewer.stage.stageHeight - 320;
            this.theViewer.toolgoon_num.num = 1;
            this.loadToolList();
            return;
        }// end function

        private function removeStagehandler(event:Event) : void
        {
            this.theViewer.selectedChild = null;
            KillerRoomData.beToolID = 0;
            return;
        }// end function

        private function loadToolList() : void
        {
            this.theViewer.loading_mc.visible = true;
            this.theViewer.gobuy_btn.visible = false;
            var _loc_1:* = new Object();
            _loc_1.cmd = "GoodsCmd_MyTools";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_1);
            return;
        }// end function

        public function setGoonSet(param1:int) : void
        {
            var _loc_2:* = param1;
            this.theViewer.toolgoon_chick.selectData = param1;
            KillerRoomData.isToolSeries = _loc_2;
            return;
        }// end function

        public function showList(param1:uint, param2:Boolean = true) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:KillerRoom_tool_Listmc = null;
            var _loc_6:KillerRoomToolsBoxChildController = null;
            if (UserData.UserInfo.Vip < 3)
            {
                this.theViewer.toolgoon_num.max = 99;
            }
            else if (UserData.UserInfo.Vip < 5)
            {
                this.theViewer.toolgoon_num.max = 999;
            }
            else if (UserData.UserInfo.Vip >= 5)
            {
                this.theViewer.toolgoon_num.max = 9999;
            }
            if (param1 == 3)
            {
                var _loc_7:int = 0;
                this.theViewer.toolgoon_chick.selectData = 0;
                KillerRoomData.isToolSeries = _loc_7;
            }
            KillerRoomData.beToolID = 0;
            this.theViewer.loading_mc.visible = false;
            this.theViewer.gobuy_btn.visible = false;
            mcFunc.removeAllMc(this.theViewer.lists);
            if (param2)
            {
                if (MainData.newUserTaskData.nowId == 1005)
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择讨好卡"});
                }
                else if (MainData.newUserTaskData.nowId == 1006)
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择整蛊卡"});
                }
                else if (MainData.newUserTaskData.nowId == 1007)
                {
                    this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择讨好卡"});
                }
            }
            this.childArr = new Array();
            if (this._datalist)
            {
                _loc_3 = 0;
                _loc_4 = 0;
                while (_loc_4 < this._datalist.length)
                {
                    
                    if (uint(this._datalist[_loc_4].Class) == param1 && uint(this._datalist[_loc_4].Num) != 0)
                    {
                        _loc_5 = new KillerRoom_tool_Listmc();
                        _loc_6 = new KillerRoomToolsBoxChildController(_loc_5, this._datalist[_loc_4], this);
                        _loc_6.arrI = _loc_4;
                        this.childArr.push(_loc_6);
                        this.theViewer.lists.addChild(_loc_5);
                        if (param2)
                        {
                            if (MainData.newUserTaskData.nowId == 1005 && param1 == 2 && _loc_3 == 0)
                            {
                                MainData.newUserTaskData.setTarget("选择道具卡", _loc_5);
                                this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择道具卡"});
                            }
                            else if (MainData.newUserTaskData.nowId == 1007 && param1 == 2 && _loc_3 == 0)
                            {
                                MainData.newUserTaskData.setTarget("选择道具卡", _loc_5);
                                this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择道具卡"});
                            }
                            else if (MainData.newUserTaskData.nowId == 1006 && param1 == 1 && _loc_3 == 0)
                            {
                                MainData.newUserTaskData.setTarget("选择道具卡", _loc_5);
                                this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"选择道具卡"});
                            }
                            else
                            {
                                MainData.newUserTaskData.clearBtn("选择道具卡");
                            }
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                if (_loc_3 > 0)
                {
                    this.theViewer.gobuy_btn.visible = false;
                }
                else
                {
                    if (param2)
                    {
                        if (MainData.newUserTaskData.nowId == 1005 && param1 == 2)
                        {
                            MainData.newUserTaskData.nowId = 0;
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERT, {Msg:"任务结束 \n没有讨好道具，不能完成任务."});
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSE);
                        }
                        else if (MainData.newUserTaskData.nowId == 1007 && param1 == 2)
                        {
                            MainData.newUserTaskData.nowId = 0;
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERT, {Msg:"任务结束 \n没有讨好道具，不能完成任务."});
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSE);
                        }
                        else if (MainData.newUserTaskData.nowId == 1006 && param1 == 1)
                        {
                            MainData.newUserTaskData.nowId = 0;
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_ALERT, {Msg:"任务结束 \n没有整蛊道具，不能完成任务."});
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSE);
                        }
                    }
                    this.theViewer.gobuy_btn.visible = true;
                }
                mcFunc.reSetMcsWhere(this.theViewer.lists, 250, 0, 60, 70);
                this.theViewer.scorll_mc.setToTop();
            }
            return;
        }// end function

        public function minusToolNum(param1:uint) : void
        {
            var _loc_4:uint = 0;
            var _loc_2:Boolean = true;
            var _loc_3:int = -1;
            _loc_4 = 0;
            while (_loc_4 < this._datalist.length)
            {
                
                if (this._datalist[_loc_4].Id == param1)
                {
                    _loc_3 = this._datalist[_loc_4].Class;
                    this._datalist[_loc_4].Num = uint(this._datalist[_loc_4].Num) - 1;
                    if (this._datalist[_loc_4].HToolName)
                    {
                        this._datalist[_loc_4].HCount = this._datalist[_loc_4].HCount - 100;
                        if (this._datalist[_loc_4].HCount <= 0)
                        {
                            this._datalist[_loc_4].HCount = 0;
                        }
                    }
                    if (int(this._datalist[_loc_4].Num) <= 0)
                    {
                        _loc_2 = false;
                        KillerRoomData.beToolID = 0;
                        if (MainData.newUserTaskData.nowId == 1005 && _loc_3 == 2)
                        {
                            this.showList(this.menuSelect.selectData, false);
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                        else if (MainData.newUserTaskData.nowId == 1007 && _loc_3 == 2)
                        {
                            this.showList(this.menuSelect.selectData, false);
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                        else if (MainData.newUserTaskData.nowId == 1006 && _loc_3 == 1)
                        {
                            this.showList(this.menuSelect.selectData, false);
                            this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                        }
                        else
                        {
                            this.showList(this.menuSelect.selectData);
                        }
                    }
                    else if (MainData.newUserTaskData.nowId == 1005 && _loc_3 == 2)
                    {
                        this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                    }
                    else if (MainData.newUserTaskData.nowId == 1007 && _loc_3 == 2)
                    {
                        this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                    }
                    else if (MainData.newUserTaskData.nowId == 1006 && _loc_3 == 1)
                    {
                        this.facade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_STEP, {stepname:"完成"});
                    }
                }
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_2)
            {
                _loc_4 = 0;
                while (_loc_4 < this.childArr.length)
                {
                    
                    if (this.childArr[_loc_4].Tid == param1)
                    {
                        this.childArr[_loc_4].reSet();
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return;
        }// end function

        public function oneToolNum(param1:Object) : void
        {
            var _loc_3:uint = 0;
            var _loc_2:Boolean = true;
            _loc_3 = 0;
            while (_loc_3 < this._datalist.length)
            {
                
                if (this._datalist[_loc_3].Id == param1.Id)
                {
                    this._datalist[_loc_3].Num = param1.Num;
                    if (this._datalist[_loc_3].HToolName)
                    {
                        this._datalist[_loc_3].HCount = param1.HCount;
                    }
                    if (int(this._datalist[_loc_3].Num) <= 0)
                    {
                        _loc_2 = false;
                        KillerRoomData.beToolID = 0;
                        this.showList(this.menuSelect.selectData);
                    }
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            if (_loc_2)
            {
                _loc_3 = 0;
                while (_loc_3 < this.childArr.length)
                {
                    
                    if (this.childArr[_loc_3].Tid == param1.Id)
                    {
                        this.childArr[_loc_3].reSet();
                        break;
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return;
        }// end function

        public function set dataList(param1:Array) : void
        {
            this._datalist = param1;
            this.showList(this.menuSelect.selectData);
            return;
        }// end function

        private function menuSelectHandler(event:MouseEvent) : void
        {
            this.showList(this.menuSelect.selectData);
            return;
        }// end function

        private function btnHandler(event:MouseEvent) : void
        {
            switch(event.currentTarget.name)
            {
                case "close_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.TOOLSACT_SERIESACT_STOP);
                    this.facade.sendNotification(KillerRoomEvents.TOOLSLIST_CLOSE);
                    break;
                }
                case "close2_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.TOOLSACT_SERIESACT_STOP);
                    this.facade.sendNotification(KillerRoomEvents.TOOLSLIST_CLOSE);
                    break;
                }
                case "reset_btn":
                {
                    this.loadToolList();
                    break;
                }
                case "buy_btn":
                {
                    OpenWin.open("http://www.ss911.cn/pages/pay/CharCenterone.aspx?gameid=2");
                    break;
                }
                case "buyLog_btn":
                {
                    OpenWin.open("/User/UseToollog_p.ss");
                    break;
                }
                case "gobuy_btn":
                {
                    this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.PlugPath.MallPlusPath.url, x:0, y:0});
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
