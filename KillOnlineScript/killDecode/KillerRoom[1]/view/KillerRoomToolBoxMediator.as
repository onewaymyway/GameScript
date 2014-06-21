package view
{
    import Core.model.data.*;
    import Core.view.*;
    import controller.*;
    import model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomToolBoxMediator extends Mediator implements IMediator
    {
        private var toolBox_obj:killerRoom_tool_list_box = null;
        private var toolBoxController:KillerRoomToolsBoxContrller;
        public static const NAME:String = "KillerRoomToolBoxMediator";

        public function KillerRoomToolBoxMediator(param1:Object = null)
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
            return [KillerRoomEvents.SHOWBTNS, KillerRoomEvents.TOOLSLIST_OPEN, KillerRoomEvents.TOOLSLIST_DATALIST, KillerRoomEvents.TOOLSLIST_CLOSE, KillerRoomEvents.TOOLSLIST_TOOL_USED, KillerRoomEvents.OUTROOM, KillerRoomEvents.TOOLSACT_SET_SERIESSET, KillerRoomEvents.TOOLSACT_MYONETOOLNUM];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                case KillerRoomEvents.TOOLSLIST_OPEN:
                {
                    if (this.toolBox_obj == null)
                    {
                        this.toolBox_obj = new killerRoom_tool_list_box();
                        this.toolBoxController = new KillerRoomToolsBoxContrller(this.toolBox_obj);
                        this.viewComponent.addChild(this.toolBox_obj);
                        MainView.DRAG.setDrag(this.toolBox_obj.drag_mc, this.toolBox_obj, this.viewComponent);
                        MainData.newUserTaskData.setTarget("选择讨好卡", this.toolBox_obj.class2_btn);
                        MainData.newUserTaskData.setTarget("选择整蛊卡", this.toolBox_obj.class1_btn);
                        MainData.newUserTaskData.setTarget("刷新道具", this.toolBox_obj.reset_btn);
                    }
                    else
                    {
                        this.viewComponent.addChild(this.toolBox_obj);
                    }
                    break;
                }
                case KillerRoomEvents.TOOLSACT_SET_SERIESSET:
                {
                    this.toolBoxController.setGoonSet(int(param1.getBody()));
                    break;
                }
                case KillerRoomEvents.TOOLSLIST_DATALIST:
                {
                    KillerRoomData.toolsListData = param1.getBody() as Array;
                    this.toolBoxController.dataList = param1.getBody() as Array;
                    break;
                }
                case KillerRoomEvents.TOOLSLIST_CLOSE:
                {
                    if (mcFunc.hasTheChlid(this.toolBox_obj, this.viewComponent))
                    {
                        this.viewComponent.removeChild(this.toolBox_obj);
                    }
                    break;
                }
                case KillerRoomEvents.TOOLSLIST_TOOL_USED:
                {
                    if (mcFunc.hasTheChlid(this.toolBox_obj, this.viewComponent))
                    {
                        this.toolBoxController.minusToolNum(param1.getBody() as uint);
                    }
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    if (mcFunc.hasTheChlid(this.toolBox_obj, this.viewComponent))
                    {
                        this.viewComponent.removeChild(this.toolBox_obj);
                    }
                    break;
                }
                case KillerRoomEvents.SHOWBTNS:
                {
                    this.setBtn(param1.getBody());
                    break;
                }
                case KillerRoomEvents.TOOLSACT_MYONETOOLNUM:
                {
                    this.toolBoxController.oneToolNum(param1.getBody());
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function setBtn(param1:Object) : void
        {
            if (param1.isCanTool)
            {
            }
            return;
        }// end function

    }
}
