package Core.view
{
    import Core.gameEvents.*;
    import Core.model.vo.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ConfirmBoxMediator extends Mediator
    {
        public static const NAME:String = "Core_ComfirmBoxMediator";

        public function ConfirmBoxMediator(param1:Object = null)
        {
            super(NAME, param1);
            return;
        }// end function

        override public function onRegister() : void
        {
            return;
        }// end function

        override public function onRemove() : void
        {
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ConfirmEvent.OPEN];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                case ConfirmEvent.OPEN:
                {
                    this.showUserMsg(param1.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function showUserMsg(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:AlertVO = null;
            switch(param1.kinds)
            {
                case "accepts":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = param1.kinds + "-" + param1.Uname + "-" + param1.MsgUID + "-" + param1.MsgTime;
                    _loc_3.arr = param1;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "callGame":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = "<font color=\'#ff0000\'>" + param1.Uname + "</font> 邀请你一起游戏！";
                    _loc_3.arr = param1;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
                    break;
                }
                case "other":
                {
                    _loc_3 = new AlertVO();
                    _loc_3.code = "";
                    _loc_3.msg = param1.MsgStr;
                    _loc_3.arr = param1;
                    _loc_2 = new confirm_box();
                    this.viewComponent.addChild(_loc_2);
                    _loc_2.show(_loc_3);
                    MainView.DRAG.setDrag(_loc_2.drag_mc, _loc_2, this.viewComponent);
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
