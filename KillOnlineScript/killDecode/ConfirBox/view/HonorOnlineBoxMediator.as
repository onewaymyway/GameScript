package view
{
    import Core.*;
    import flash.display.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class HonorOnlineBoxMediator extends Mediator implements IMediator
    {
        private var honorLayer:Sprite;
        public static const NAME:String = "HonorOnlineBoxMediator";

        public function HonorOnlineBoxMediator(viewComponent:Object = null)
        {
            super(NAME, viewComponent);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [GameEvents.PlUSEVENT.HONORONLINE_SHOW];
        }// end function

        override public function handleNotification(sender:INotification) : void
        {
            var _loc_2:Object = null;
            switch(sender.getName())
            {
                case GameEvents.PlUSEVENT.HONORONLINE_SHOW:
                {
                    this.ShowHonorOnline(sender.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function ShowHonorOnline(STRArr:Object) : void
        {
            var _loc_2:honorVipOnline_box = null;
            var _loc_3:Vip_Log = null;
            var _loc_4:honorOnline_box = null;
            var _loc_5:honorYOnline_box = null;
            if (!this.honorLayer)
            {
                this.honorLayer = new Sprite();
                this.viewComponent.addChild(this.honorLayer);
            }
            if (STRArr["VipHonor"])
            {
                _loc_2 = new honorVipOnline_box();
                _loc_2.honor_txt.visible = true;
                _loc_2.honor_bg.visible = true;
                _loc_2.honor_txt.htmlText = String(STRArr["VipHonor"]);
                _loc_2.honor_txt.autoSize = "left";
                _loc_2.honor_txt.x = -_loc_2.honor_txt.width / 2 + 10;
                _loc_2.honor_bg.width = _loc_2.honor_txt.width + 40;
                _loc_2.honor_bg.height = _loc_2.honor_txt.height + 20;
                _loc_3 = new Vip_Log();
                _loc_2.vip_log.x = _loc_2.honor_txt.x - 20;
                _loc_2.vip_log.addChild(_loc_3);
                _loc_3.gotoAndStop("vip" + STRArr.VipGrade);
                this.honorLayer.addChild(_loc_2);
            }
            if (STRArr["WeekHonor"])
            {
                _loc_4 = new honorOnline_box();
                _loc_4.honor_txt.visible = true;
                _loc_4.honor_bg.visible = true;
                _loc_4.honor_txt.htmlText = String(STRArr["WeekHonor"]);
                _loc_4.honor_txt.autoSize = "left";
                _loc_4.honor_txt.x = -_loc_4.honor_txt.width / 2;
                _loc_4.honor_bg.width = _loc_4.honor_txt.width + 40;
                _loc_4.honor_bg.height = _loc_4.honor_txt.height + 10;
                this.honorLayer.addChild(_loc_4);
            }
            if (STRArr["YearHonor"])
            {
                _loc_5 = new honorYOnline_box();
                _loc_5.honor_txt.visible = true;
                _loc_5.honor_bg.visible = true;
                _loc_5.honor_txt.htmlText = String(STRArr["YearHonor"]);
                _loc_5.honor_txt.autoSize = "left";
                _loc_5.honor_txt.x = -_loc_5.honor_txt.width / 2;
                _loc_5.honor_bg.width = _loc_5.honor_txt.width + 40;
                _loc_5.honor_bg.height = _loc_5.honor_txt.height + 10;
                this.honorLayer.addChild(_loc_5);
            }
            this.reWhere();
            return;
        }// end function

        private function reWhere() : void
        {
            var _loc_3:Sprite = null;
            var _loc_4:Sprite = null;
            var _loc_1:* = this.honorLayer.numChildren;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                _loc_3 = this.honorLayer.getChildAt(_loc_2) as Sprite;
                _loc_3.x = this.viewComponent.stage.stageWidth / 2;
                if (_loc_2 == 0)
                {
                    _loc_3.y = this.viewComponent.stage.stageHeight / 2 - 80;
                }
                else
                {
                    _loc_4 = this.honorLayer.getChildAt((_loc_2 - 1)) as Sprite;
                    _loc_3.y = _loc_4.y + _loc_4.height + 10;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        GameEvents.PlUSEVENT.HONORONLINE_SHOW = "PlUSEVENT_HONORONLINE_SHOW";
    }
}
