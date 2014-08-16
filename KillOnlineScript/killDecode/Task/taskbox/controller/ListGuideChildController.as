package taskbox.controller
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import json.*;
    import taskbox.model.*;
    import taskbox.view.*;
    import uas.*;

    public class ListGuideChildController extends Object
    {
        private var theViewer:MovieClip;
        private var myFacade:MyFacade;
        public var _data:Object;
        public var setUrl:String;
        public var webUrl:String;
        private var prizeStr:String = "";

        public function ListGuideChildController(Viewer:MovieClip, data:Object)
        {
            this.myFacade = MyFacade.getInstance();
            this._data = data;
            this.setUrl = "/Task/SetGuide.ss";
            this.theViewer = Viewer;
            this.theViewer.complete_log.visible = false;
            this.theViewer.uncomplete_log.visible = false;
            this.theViewer.guide_btn.visible = false;
            this.theViewer.set_btn.visible = false;
            this.theViewer.guide_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.set_btn.addEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.about_log.gotoAndStop(1);
            this.theViewer.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverBoxHandler);
            this.setValue(this._data);
            this.theViewer.addEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            return;
        }// end function

        private function removeHandler(event:Event) : void
        {
            this.theViewer.guide_btn.removeEventListener(MouseEvent.CLICK, this.btnHandler);
            this.theViewer.removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverBoxHandler);
            this.theViewer.removeEventListener(Event.REMOVED_FROM_STAGE, this.removeHandler);
            this.theViewer.removeEventListener(Event.ENTER_FRAME, this.enterHandler);
            return;
        }// end function

        private function mouseOverBoxHandler(event:MouseEvent) : void
        {
            this.theViewer.about_log.gotoAndStop(2);
            this.theViewer._bg.gotoAndStop(2);
            this.theViewer.addEventListener(Event.ENTER_FRAME, this.enterHandler);
            return;
        }// end function

        private function enterHandler(event:Event) : void
        {
            if (!this.theViewer._bg.hitTestPoint(MainData.MainStage.mouseX, MainData.MainStage.mouseY, true))
            {
                this.theViewer.about_log.gotoAndStop(1);
                this.theViewer._bg.gotoAndStop(1);
                this.theViewer.removeEventListener(Event.ENTER_FRAME, this.enterHandler);
            }
            return;
        }// end function

        public function setValue(o:Object) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:TaskBox_prizeChild = null;
            var _loc_2:* = JSON.decode(o.Prize);
            this.theViewer.title_txt.text = o.Title;
            this.theViewer.complete_log.visible = false;
            this.theViewer.uncomplete_log.visible = false;
            this.theViewer.guide_btn.visible = false;
            this.theViewer.set_btn.visible = false;
            if (uint(o.Status) == 0)
            {
                this.theViewer.guide_btn.visible = true;
            }
            else if (uint(o.Status) == 1)
            {
                this.theViewer.set_btn.visible = true;
            }
            else if (uint(o.Status) == 2)
            {
                this.theViewer.complete_log.visible = true;
            }
            mcFunc.removeAllMc(this.theViewer.prize_list);
            this.prizeStr = "";
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = new TaskBox_prizeChild();
                mcFunc.removeAllMc(_loc_4.img_mc);
                _loc_4.num_txt.text = " + " + String(_loc_2[_loc_3].num);
                ViewPicLoad.load(Resource.CDN + _loc_2[_loc_3].img, _loc_4.img_mc);
                _loc_4.x = 80 * _loc_3;
                this.theViewer.prize_list.addChild(_loc_4);
                this.prizeStr = this.prizeStr + " " + _loc_2[_loc_3].name + " +" + String(_loc_2[_loc_3].num);
                _loc_3 = _loc_3 + 1;
            }
            MainView.ALT.setAlt(this.theViewer.prize_list, this.prizeStr, 1);
            MainView.ALT.setAlt(this.theViewer.about_log, String(o.About), 4);
            return;
        }// end function

        private function btnHandler(event:Event) : void
        {
            var _loc_3:SetProxy = null;
            var _loc_2:* = event.target.name;
            if (_loc_2 == "guide_btn")
            {
                if (this._data.Js)
                {
                }
                if (this._data.Js != "")
                {
                    ExternalInterface.call(this._data.Js);
                    this.myFacade.sendNotification(MainMediator.CLOSE);
                    return;
                }
                MainData.newUserTaskData.tasks[this._data.Taskid].data = this._data;
                this.myFacade.sendNotification("KillerRoom_TOOLSLISTCLOSE");
                this.myFacade.sendNotification(GameEvents.PlUSEVENT.NewUserTec_SHOW_FRAME, this._data.Taskid);
                this.myFacade.sendNotification(MainMediator.CLOSE);
            }
            else if (_loc_2 == "set_btn")
            {
                _loc_3 = new SetProxy();
                _loc_3.addEventListener(SetProxy.DATE_LOADED, this.ProxyHandler);
                _loc_3.addEventListener(SetProxy.DATE_LOADErr, this.ProxyERRHandler);
                _loc_3.LoadData(this.setUrl + "?TaskID=" + this._data.Taskid);
                this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"Loading..."});
            }
            return;
        }// end function

        private function ProxyERRHandler(event:Event) : void
        {
            var _loc_2:* = new AlertVO();
            _loc_2.msg = "Á¬½ÓÊ§°Ü";
            this.myFacade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            return;
        }// end function

        private function ProxyHandler(event:Event) : void
        {
            var _loc_3:Object = null;
            var _loc_4:Array = null;
            var _loc_5:Object = null;
            var _loc_6:AlertVO = null;
            var _loc_2:* = event.target.data.msg;
            if (_loc_2.indexOf("OK") > -1)
            {
                this._data.Status = 2;
                this.theViewer.complete_log.visible = true;
                this.theViewer.set_btn.visible = false;
                this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
                _loc_3 = new Object();
                _loc_3.cmd = "ReloadMyInfo";
                _loc_4 = _loc_2.split("|");
                trace("msgArr[1]:" + _loc_4[1]);
                _loc_3.Update = String(_loc_4[1]);
                this.myFacade.sendNotification(GameEvents.NETCALL, _loc_3);
                _loc_5 = new Object();
                _loc_5.code = "";
                _loc_5.arr = null;
                _loc_5.msg = this.prizeStr;
                this.myFacade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_5);
                this.theViewer.complete_log.visible = true;
                this.theViewer.uncomplete_log.visible = false;
                this.theViewer.guide_btn.visible = false;
                this.theViewer.set_btn.visible = false;
            }
            else
            {
                _loc_6 = new AlertVO();
                _loc_6.msg = event.target.data.msg;
                this.myFacade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_6);
            }
            return;
        }// end function

    }
}
