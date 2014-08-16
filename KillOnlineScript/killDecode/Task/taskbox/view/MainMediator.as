package taskbox.view
{
    import Core.*;
    import Core.model.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.events.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import taskbox.controller.*;
    import taskbox.model.*;
    import uas.*;

    public class MainMediator extends Mediator
    {
        private var theViewer:TaskBox_MainMc;
        private var selectMenu:SelectOneBox;
        public static const NAME:String = "TaskBox_MainMediator";
        public static const OKALERT:String = "TaskBox_OKALERT";
        public static const LOADING:String = "TaskBox_LOADING";
        public static const CLOSE:String = "TaskBox_CLOSE";

        public function MainMediator(viewComponent:Object = null)
        {
            super(NAME, viewComponent);
            return;
        }// end function

        public function init() : void
        {
            this.selectMenu = new SelectOneBox();
            this.selectMenu.addEventListener(MouseEvent.MOUSE_DOWN, this.selectMenuHandler);
            this.selectMenu.SetBoxs([this.theViewer.newuser_btn, this.theViewer.day_btn, this.theViewer.up_btn, this.theViewer.help_btn], ["newuser", "day", "up", "help"], 0);
            MainData.TaskListData.addEventListener(ListProxy.LOADED_DAYLIST, this.dayListHandler);
            MainData.TaskListData.addEventListener(ListProxy.LOADED_UPLIST, this.upListHandler);
            MainData.TaskListData.addEventListener(ListProxy.LOADED_GuideLIST, this.guideListHandler);
            MainData.TaskListData.addEventListener(ListProxy.DATE_LOADErr, this.ProxyERRHandler);
            return;
        }// end function

        override public function onRegister() : void
        {
            this.theViewer = new TaskBox_MainMc();
            this.theViewer.x = (this.viewComponent.stage.stageWidth - this.theViewer.width) / 2;
            this.theViewer.y = (this.viewComponent.stage.stageHeight - this.theViewer.height) / 2;
            this.theViewer.close_btn.addEventListener(MouseEvent.CLICK, this.closeHandler);
            this.viewComponent.addChild(this.theViewer);
            MainView.DRAG.setDrag(this.theViewer.drag_mc, this.viewComponent, this.viewComponent.parent);
            this.theViewer.newuser_btn.newTask_log.visible = false;
            this.theViewer.day_btn.newTask_log.visible = false;
            this.theViewer.up_btn.newTask_log.visible = false;
            MainData.TaskListData.addEventListener(TasksListProxy.LOADED_ALLLIST, this.NewTaskLoaded);
            MainData.TaskListData.LoadAll(true);
            return;
        }// end function

        private function NewTaskLoaded(event:Event) : void
        {
            MainData.TaskListData.removeEventListener(TasksListProxy.LOADED_ALLLIST, this.NewTaskLoaded);
            if (MainData.TaskListData.isHasNewDayTask())
            {
                this.theViewer.day_btn.newTask_log.visible = true;
            }
            if (MainData.TaskListData.isHasNewguideTask())
            {
                this.theViewer.newuser_btn.newTask_log.visible = true;
            }
            if (MainData.TaskListData.isHasNewUpTask())
            {
                this.theViewer.up_btn.newTask_log.visible = true;
            }
            this.init();
            return;
        }// end function

        private function selectMenuHandler(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            mcFunc.removeAllMc(this.theViewer._list);
            this.theViewer.scorll_mc.setToTop();
            if (this.selectMenu.selectData == "newuser")
            {
                if (MainData.TaskListData.guideListdata)
                {
                    this.showGuidelist(MainData.TaskListData.guideListdata.taskInfo);
                }
                else
                {
                    MainData.TaskListData.LoadGuideListData();
                    this.theViewer.loading_mc.visible = true;
                }
                this.theViewer.help_mc.visible = false;
                this.theViewer.newuser_btn.newTask_log.visible = false;
            }
            else if (this.selectMenu.selectData == "day")
            {
                if (MainData.TaskListData.dayListdata)
                {
                    this.showDaylist(MainData.TaskListData.dayListdata.taskInfo);
                }
                else
                {
                    MainData.TaskListData.LoadDayListData();
                    this.theViewer.loading_mc.visible = true;
                }
                this.theViewer.help_mc.visible = false;
                this.theViewer.day_btn.newTask_log.visible = false;
            }
            else if (this.selectMenu.selectData == "up")
            {
                if (MainData.TaskListData.upListdata)
                {
                    this.showUplist(MainData.TaskListData.upListdata.taskInfo);
                }
                else
                {
                    MainData.TaskListData.LoadUpListData();
                    this.theViewer.loading_mc.visible = true;
                }
                this.theViewer.help_mc.visible = false;
                this.theViewer.up_btn.newTask_log.visible = false;
            }
            else if (this.selectMenu.selectData == "help")
            {
                this.theViewer.help_mc.visible = true;
                mcFunc.removeAllMc(this.theViewer._list);
                this.theViewer.scorll_mc.setToTop();
            }
            return;
        }// end function

        private function dayListHandler(event:Event) : void
        {
            var _loc_2:AlertVO = null;
            this.theViewer.loading_mc.visible = false;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            if (event.target.dayListdata.msg == "OK")
            {
                if (event.target.dayListdata.taskInfo)
                {
                    this.showDaylist(event.target.dayListdata.taskInfo);
                }
                else
                {
                    _loc_2 = new AlertVO();
                    _loc_2.msg = "没有任务数据";
                    this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
            }
            else
            {
                _loc_2 = new AlertVO();
                _loc_2.msg = String(event.target.dayListdata.msg);
                this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            return;
        }// end function

        private function guideListHandler(event:Event) : void
        {
            var _loc_2:AlertVO = null;
            this.theViewer.loading_mc.visible = false;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            if (event.target.guideListdata.msg == "OK")
            {
                if (event.target.guideListdata.taskInfo)
                {
                    this.showGuidelist(event.target.guideListdata.taskInfo);
                }
                else
                {
                    _loc_2 = new AlertVO();
                    _loc_2.msg = "没有任务数据";
                    this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
            }
            else
            {
                _loc_2 = new AlertVO();
                _loc_2.msg = String(event.target.guideListdata.msg);
                this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            return;
        }// end function

        private function upListHandler(event:Event) : void
        {
            var _loc_2:AlertVO = null;
            this.theViewer.loading_mc.visible = false;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            if (event.target.upListdata.msg == "OK")
            {
                if (event.target.upListdata.taskInfo)
                {
                    this.showUplist(event.target.upListdata.taskInfo);
                }
                else
                {
                    _loc_2 = new AlertVO();
                    _loc_2.msg = "没有任务数据";
                    this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
                }
            }
            else
            {
                _loc_2 = new AlertVO();
                _loc_2.msg = String(event.target.upListdata.msg);
                this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            }
            return;
        }// end function

        private function ProxyERRHandler(event:Event) : void
        {
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            var _loc_2:* = new AlertVO();
            _loc_2.msg = "连接失败";
            this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            return;
        }// end function

        override public function onRemove() : void
        {
            MainData.TaskListData.removeEventListener(TasksListProxy.LOADED_ALLLIST, this.NewTaskLoaded);
            MainData.TaskListData.removeEventListener(ListProxy.LOADED_DAYLIST, this.dayListHandler);
            MainData.TaskListData.removeEventListener(ListProxy.LOADED_UPLIST, this.upListHandler);
            MainData.TaskListData.removeEventListener(ListProxy.LOADED_GuideLIST, this.guideListHandler);
            MainData.TaskListData.removeEventListener(ListProxy.DATE_LOADErr, this.ProxyERRHandler);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [OKALERT, CLOSE, LOADING];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            switch(sender.getName())
            {
                case OKALERT:
                {
                    break;
                }
                case CLOSE:
                {
                    this.viewComponent.remove();
                    break;
                }
                case LOADING:
                {
                    this.theViewer.loading_mc.visible = Boolean(sender.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function showGuidelist(arr:Array) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:TaskBox_ListGuideChild = null;
            this.theViewer.loading_mc.visible = false;
            mcFunc.removeAllMc(this.theViewer._list);
            if (arr)
            {
            }
            if (arr.length > 0)
            {
                while (_loc_2 < arr.length)
                {
                    
                    _loc_3 = new TaskBox_ListGuideChild();
                    _loc_3.y = _loc_2 * 55;
                    this.theViewer._list.addChild(_loc_3);
                    new ListGuideChildController(_loc_3, arr[_loc_2]);
                    _loc_2 = _loc_2 + 1;
                }
                this.theViewer.scorll_mc.setToTop();
                this.itemBtnModel(0);
            }
            else
            {
                this.itemBtnModel(1);
                this.selectMenu.index = 1;
                if (MainData.TaskListData.dayListdata)
                {
                    this.showDaylist(MainData.TaskListData.dayListdata.taskInfo);
                }
                else
                {
                    MainData.TaskListData.LoadDayListData();
                    this.theViewer.loading_mc.visible = true;
                }
                this.theViewer.help_mc.visible = false;
            }
            return;
        }// end function

        private function showDaylist(arr:Array) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:TaskBox_ListChild = null;
            mcFunc.removeAllMc(this.theViewer._list);
            this.theViewer.loading_mc.visible = false;
            while (_loc_2 < arr.length)
            {
                
                _loc_3 = new TaskBox_ListChild();
                _loc_3.y = _loc_2 * 55;
                this.theViewer._list.addChild(_loc_3);
                new ListChildController(_loc_3, arr[_loc_2], "/Task/SetDay.ss");
                _loc_2 = _loc_2 + 1;
            }
            this.theViewer.scorll_mc.setToTop();
            return;
        }// end function

        private function showUplist(arr:Array) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:TaskBox_ListChild = null;
            mcFunc.removeAllMc(this.theViewer._list);
            this.theViewer.loading_mc.visible = false;
            while (_loc_2 < arr.length)
            {
                
                _loc_3 = new TaskBox_ListChild();
                _loc_3.y = _loc_2 * 55;
                this.theViewer._list.addChild(_loc_3);
                new ListChildController(_loc_3, arr[_loc_2], "/Task/SetUp.ss");
                _loc_2 = _loc_2 + 1;
            }
            this.theViewer.scorll_mc.setToTop();
            return;
        }// end function

        private function itemBtnModel(t:int) : void
        {
            if (t == 0)
            {
                this.theViewer.newuser_btn.visible = true;
                this.theViewer.day_btn.x = 172;
                this.theViewer.up_btn.x = 329;
                this.theViewer.help_btn.visible = false;
            }
            else
            {
                this.theViewer.newuser_btn.visible = false;
                this.theViewer.day_btn.x = 15;
                this.theViewer.up_btn.x = 172;
                this.theViewer.help_btn.x = 329;
            }
            return;
        }// end function

        private function closeHandler(event:Event) : void
        {
            this.viewComponent.remove();
            return;
        }// end function

    }
}
