package Core.view
{
    import Core.*;
    import Core.model.data.*;
    import Core.model.vo.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class PlusMediator extends Mediator
    {
        private var desk:Object;
        private var loader:Loader = null;
        private var plusname:Array;
        public static const NAME:String = "Core_PlusMediator";
        public static const OPEN:String = "PlusMediator_OPEN";
        public static const CLOSE:String = "PlusMediator_CLOSE";
        public static const ACTION:String = "PlusMediator_ACTION";
        public static const CLOSEALL:String = "PlusMediator_CLOSEALL";

        public function PlusMediator(param1:Object = null)
        {
            this.plusname = [];
            super(NAME, param1);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [OPEN, CLOSE, CLOSEALL, ACTION];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = param1.getBody();
            if (_loc_2)
            {
                _loc_3 = _loc_2.url + Resource.GetFileNameV(_loc_2.url);
            }
            switch(param1.getName())
            {
                case OPEN:
                {
                    if (MainData.newUserTaskData.nowId != 0)
                    {
                        this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_PROMPTTITLE, "");
                    }
                    this.plusname.push([_loc_3, _loc_2.x, _loc_2.y, _loc_2]);
                    this.loadPlus();
                    break;
                }
                case CLOSE:
                {
                    if (this.getPlusObj(_loc_3))
                    {
                        this.viewComponent.removeChild(this.getPlusObj(_loc_3));
                    }
                    CleanMenory.clean();
                    break;
                }
                case ACTION:
                {
                    if (MainData.newUserTaskData.nowId == 1003)
                    {
                        this.sendNotification(GameEvents.PlUSEVENT.NewUserTec_CLOSE);
                    }
                    if (this.getPlusObj(_loc_3))
                    {
                        var _loc_4:* = this.getPlusObj(_loc_3);
                        _loc_4.this.getPlusObj(_loc_3)["action"](_loc_2);
                    }
                    else
                    {
                        this.plusname.push([_loc_3, _loc_2.x, _loc_2.y, _loc_2]);
                        this.loadPlus();
                    }
                    break;
                }
                case CLOSEALL:
                {
                    mcFunc.removeAllMc(this.viewComponent);
                    CleanMenory.clean();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function onRegister() : void
        {
            this.desk = new Object();
            return;
        }// end function

        private function loadPlus() : void
        {
            if (this.plusname.length > 0)
            {
                if (this.isHasNotPus(this.plusname[0][0]))
                {
                    if (this.loader == null)
                    {
                        this.loader = new Loader();
                        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.plusLoaded);
                        this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ErrorHandler);
                        this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.loadProgressHandler);
                        this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ErrorHandler);
                        this.loader.load(new URLRequest(this.plusname[0][0]), new LoaderContext(false, ApplicationDomain.currentDomain));
                    }
                }
                else
                {
                    this.plusname.shift();
                }
            }
            return;
        }// end function

        private function loadProgressHandler(event:ProgressEvent) : void
        {
            var _loc_2:* = event.bytesLoaded / event.bytesTotal;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"Loading...", p:"", bar:_loc_2});
            return;
        }// end function

        private function ErrorHandler(event:Event) : void
        {
            this.plusname.shift();
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.plusLoaded);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.loadProgressHandler);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ErrorHandler);
            this.loader = null;
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            var _loc_2:* = new AlertVO();
            _loc_2.msg = "打开失败";
            this.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_2);
            this.loadPlus();
            return;
        }// end function

        private function plusLoaded(event:Event) : void
        {
            this.sendNotification(GameEvents.LOADINGEVENT.LOADED, {msg:"Loading..."});
            event.target.content.x = this.plusname[0][1];
            event.target.content.y = this.plusname[0][2];
            var _loc_2:* = event.target.content;
            this.desk[this.plusname[0][0]] = String(_loc_2.name);
            if (String(this.plusname[0][0]).indexOf("admin/") > -1 || String(this.plusname[0][0]).indexOf("shake.swf") > -1)
            {
                this.viewComponent.parent.addChild(_loc_2);
            }
            else
            {
                this.viewComponent.addChild(_loc_2);
            }
            if (_loc_2.hasOwnProperty("init"))
            {
                var _loc_3:* = _loc_2;
                _loc_3._loc_2["init"](this.plusname[0][3]);
            }
            _loc_2.addEventListener(GameEvents.PlUSEVENT.ACTION, this.plusActionHeandler);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.plusLoaded);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ErrorHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.loadProgressHandler);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.ErrorHandler);
            this.loader = null;
            this.plusname.shift();
            this.loadPlus();
            return;
        }// end function

        private function plusActionHeandler(event:Event) : void
        {
            var _loc_2:* = event.currentTarget.actionData;
            this.sendNotification(_loc_2.code, _loc_2);
            return;
        }// end function

        private function isHasNotPus(param1:String) : Boolean
        {
            var _loc_2:* = this.viewComponent.numChildren;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this.viewComponent.getChildAt(_loc_3).name == this.desk[param1])
                {
                    return false;
                }
                _loc_3 = _loc_3 + 1;
            }
            return true;
        }// end function

        private function getPlusObj(param1:String) : Object
        {
            var _loc_2:* = this.viewComponent.numChildren;
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (this.viewComponent.getChildAt(_loc_3).name == this.desk[param1])
                {
                    return this.viewComponent.getChildAt(_loc_3);
                }
                _loc_3 = _loc_3 + 1;
            }
            return null;
        }// end function

    }
}
