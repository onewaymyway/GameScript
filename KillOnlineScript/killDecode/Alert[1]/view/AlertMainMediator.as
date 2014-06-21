package view
{
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class AlertMainMediator extends Mediator
    {
        private var parentOBJ:Object;
        private var aFrame:AlertFrame;
        private var strMcArr:Array;
        private var timer:Timer;
        private var alertFrame:Object;
        private var alertMsgFrame:Object;
        public static const NAME:String = "AlertMainMediator";

        public function AlertMainMediator(obj:Object = null)
        {
            this.strMcArr = new Array();
            this.parentOBJ = obj;
            super(NAME, obj);
            this.timer = new Timer(2 * 1000);
            this.timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this.aFrame = this.parentOBJ.addChild(new AlertFrame()) as AlertFrame;
            this.alertMsgFrame = this.aFrame.addChild(new Sprite());
            this.alertFrame = this.aFrame.addChild(new Sprite());
            this.aFrame.alert_bg.visible = false;
            this.aFrame.alert_bg.height = this.getViewComponent().stage.stageHeight;
            this.aFrame.alert_bg.width = this.getViewComponent().stage.stageWidth;
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            this.RemoveOneNews();
            return;
        }// end function

        public function ShowAlertMsg(STR:String) : void
        {
            if (STR == "null")
            {
                return;
            }
            if (this.strMcArr.length >= 2)
            {
                this.RemoveOneNews();
            }
            var _loc_2:* = new AlertMsgTxt();
            this.alertMsgFrame.addChild(_loc_2);
            this.strMcArr.push(_loc_2);
            _loc_2.x = this.getViewComponent().stage.stageWidth / 2;
            _loc_2.y = this.getViewComponent().stage.stageHeight / 2 + this.strMcArr.length * 28 - 50;
            if (String(STR) != "undefined")
            {
                _loc_2._txt.htmlText = STR;
                _loc_2._txt.autoSize = "left";
                _loc_2._txt.x = -_loc_2._txt.width / 2;
            }
            if (this.strMcArr.length == 1)
            {
                this.timer.start();
            }
            return;
        }// end function

        public function CleanNews() : void
        {
            this.timer.stop();
            while (this.alertMsgFrame.numChildren > 0)
            {
                
                this.alertMsgFrame.removeChildAt(0);
            }
            while (this.alertFrame.numChildren > 0)
            {
                
                this.alertFrame.removeChildAt(0);
            }
            this.strMcArr = new Array();
            this.aFrame.alert_bg.visible = false;
            return;
        }// end function

        public function RemoveOneNews() : void
        {
            this.alertMsgFrame.removeChild(this.strMcArr[0]);
            this.strMcArr.shift();
            var _loc_1:uint = 0;
            while (_loc_1 < this.strMcArr.length)
            {
                
                this.strMcArr[_loc_1].y = this.strMcArr[_loc_1].y - 28;
                _loc_1 = _loc_1 + 1;
            }
            if (this.strMcArr.length == 0)
            {
                this.timer.stop();
            }
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [GameEvents.ALERTEVENT.ALERT, GameEvents.ALERTEVENT.ALERTMSG, GameEvents.ALERTEVENT.CONFIRM];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            var _loc_3:MovieClip = null;
            trace(sender.getName());
            var _loc_2:* = sender.getBody();
            switch(sender.getName())
            {
                case GameEvents.ALERTEVENT.ALERT:
                {
                    _loc_3 = this.alertFrame.addChild(new alert_mc());
                    _loc_3.addEventListener(TextEvent.LINK, this.linkHandler);
                    this.SetMCOBJ(_loc_3, _loc_2);
                    break;
                }
                case GameEvents.ALERTEVENT.ALERTMSG:
                {
                    sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    this.ShowAlertMsg(_loc_2.msg);
                    break;
                }
                case GameEvents.ALERTEVENT.CONFIRM:
                {
                    _loc_3 = this.alertFrame.addChild(new confirm_mc());
                    _loc_3.addEventListener(TextEvent.LINK, this.linkHandler);
                    this.SetMCOBJ(_loc_3, _loc_2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function SetMCOBJ(mc:MovieClip, obj:Object) : void
        {
            mc.x = this.getViewComponent().stage.stageWidth / 2;
            mc.y = this.getViewComponent().stage.stageHeight / 2;
            this.aFrame.alert_bg.visible = true;
            mc.Arr = obj;
            mc.msg_txt.htmlText = obj.msg;
            mc.addEventListener("OK", this.confirmHandler);
            mc.addEventListener("CANCEL", this.cancelClick);
            return;
        }// end function

        private function cancelClick(event:Event)
        {
            this.alertFrame.removeChild(event.target);
            return;
        }// end function

        private function confirmHandler(event:Event) : void
        {
            sendNotification(GameEvents.LOADINGEVENT.LOADED);
            var _loc_2:* = event.target;
            if (this.alertFrame.numChildren == 1)
            {
                this.aFrame.alert_bg.visible = false;
            }
            this.alertFrame.removeChild(_loc_2);
            if (_loc_2.Arr.code != "")
            {
                sendNotification(_loc_2.Arr.code, _loc_2.Arr.arr);
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

        GameEvents.ALERTEVENT.ALERT = "Game_alert";
        GameEvents.ALERTEVENT.ALERTMSG = "Game_alertGameMsg";
        GameEvents.ALERTEVENT.CONFIRM = "Game_comfirm";
    }
}
