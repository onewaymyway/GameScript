package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import uas.*;

    public class KillerRoomPlugGameMediator extends Mediator implements IMediator
    {
        private var desk:Object;
        private var loader:Loader = null;
        private var plusname:Array;
        private var frame:Sprite;
        private var plugObj:Sprite;
        public static const NAME:String = "KillerRoomPlugGameMediator";
        public static const OPEN:String = "KillerRoomPlugGameMediator_OPEN";
        public static const CLOSE:String = "KillerRoomPlugGameMediator_CLOSE";
        public static const ACTION:String = "KillerRoomPlugGameMediator_ACTION";
        public static var game:Object = null;

        public function KillerRoomPlugGameMediator(param1:Object = null)
        {
            this.plusname = [];
            super(NAME, param1);
            return;
        }// end function

        override public function onRegister() : void
        {
            this.desk = new Object();
            this.frame = new Sprite();
            this.viewComponent.addChild(this.frame);
            return;
        }// end function

        override public function onRemove() : void
        {
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [OPEN, CLOSE, ACTION];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:Object = null;
            var _loc_3:* = undefined;
            _loc_2 = param1.getBody();
            switch(param1.getName())
            {
                case OPEN:
                {
                    _loc_3 = _loc_2.url + Resource.GetFileNameV(_loc_2.url);
                    if (mcFunc.hasTheChlid(this.desk[_loc_3], this.frame))
                    {
                        return;
                    }
                    game = null;
                    mcFunc.removeAllMc(this.frame);
                    this.loadPlus(_loc_3, _loc_2.x, _loc_2.y, _loc_2);
                    break;
                }
                case CLOSE:
                {
                    game = null;
                    mcFunc.removeAllMc(this.frame);
                    CleanMenory.clean();
                    break;
                }
                case ACTION:
                {
                    _loc_3 = _loc_2.url + Resource.GetFileNameV(_loc_2.url);
                    if (this.desk[_loc_3])
                    {
                        if (this.desk[_loc_3].hasOwnProperty("action"))
                        {
                            var _loc_4:* = this.desk[_loc_3];
                            _loc_4.this.desk[_loc_3]["action"](_loc_2);
                        }
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

        private function loadPlus(param1:String, param2:int, param3:int, param4:Object) : void
        {
            if (this.plusname.length == 0)
            {
                this.plusname = [param1, param2, param3, param4];
                if (this.loader == null)
                {
                    this.loader = new Loader();
                    this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.plusLoaded);
                }
                this.loader.load(new URLRequest(param1), new LoaderContext(false, ApplicationDomain.currentDomain));
            }
            return;
        }// end function

        private function plusLoaded(event:Event) : void
        {
            event.target.content.x = this.plusname[1];
            event.target.content.y = this.plusname[2];
            this.frame.addChild(event.target.content);
            this.desk[this.plusname[0]] = event.target.content;
            game = this.desk[this.plusname[0]];
            if (this.desk[this.plusname[0]].hasOwnProperty("init"))
            {
                var _loc_2:* = this.desk[this.plusname[0]];
                _loc_2.this.desk[this.plusname[0]]["init"](this.plusname[3]);
            }
            this.desk[this.plusname[0]].addEventListener(GameEvents.PlUSEVENT.ACTION, this.plusActionHeandler);
            this.plusname = [];
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.plusLoaded);
            this.loader = null;
            return;
        }// end function

        private function plusActionHeandler(event:Event) : void
        {
            var _loc_2:* = event.currentTarget.actionData;
            this.sendNotification(_loc_2.code, _loc_2);
            return;
        }// end function

    }
}
