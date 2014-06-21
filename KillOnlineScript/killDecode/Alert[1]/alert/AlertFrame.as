package alert
{
    import flash.display.*;
    import flash.events.*;

    public class AlertFrame extends Sprite
    {
        public var alert_bg:LockBg;

        public function AlertFrame()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, init);
            return;
        }// end function

        private function init(event:Event) : void
        {
            var _loc_2:Sprite = null;
            _loc_2 = this.getChildByName("alert_bg") as Sprite;
            _loc_2.visible = false;
            _loc_2.height = stage.stageHeight;
            _loc_2.width = stage.stageWidth;
            return;
        }// end function

    }
}
