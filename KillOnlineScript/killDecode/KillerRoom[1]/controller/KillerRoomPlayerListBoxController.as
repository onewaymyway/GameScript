package controller
{
    import Core.*;
    import Core.model.data.*;
    import flash.events.*;
    import model.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomPlayerListBoxController extends Object
    {
        private var facade:Object;
        private var _datalist:Array = null;
        private var childArr:Array;
        public var theViewer:KillerRoomPlayerlist_box;

        public function KillerRoomPlayerListBoxController(param1:KillerRoomPlayerlist_box)
        {
            this.theViewer = param1;
            this.childArr = new Array();
            this.facade = MyFacade.getInstance();
            this.theViewer.addEventListener(Event.ADDED_TO_STAGE, this.addedStagehandler);
            this.theViewer.addEventListener(Event.REMOVED_FROM_STAGE, this.removeStagehandler);
            this.theViewer.close_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.close2_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.theViewer.refresh_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            return;
        }// end function

        private function addedStagehandler(event:Event) : void
        {
            this.theViewer.x = MainData.MainStage.stageWidth - 320;
            this.theViewer.y = MainData.MainStage.stageHeight - 320;
            this.showList(KillerRoomData.RoomUserList);
            return;
        }// end function

        private function removeStagehandler(event:Event) : void
        {
            mcFunc.removeAllMc(this.theViewer.lists);
            this.theViewer.scorll_mc.setToTop();
            return;
        }// end function

        public function showList(param1:Object) : void
        {
            var _loc_3:String = null;
            var _loc_4:uint = 0;
            var _loc_5:KillerRoomPlayerListMcController = null;
            var _loc_2:* = new Array();
            mcFunc.removeAllMc(this.theViewer.lists);
            for (_loc_3 in param1)
            {
                
                if (int(param1[_loc_3]["RoomSite"]) != 100)
                {
                    _loc_2.push(param1[_loc_3]);
                }
            }
            _loc_2.sortOn(["RoomSite"], [Array.NUMERIC]);
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_5 = new KillerRoomPlayerListMcController(new KillerRoomPlayerlist_mc());
                this.theViewer.lists.addChild(_loc_5.theViewer);
                _loc_5.Data = _loc_2[_loc_4];
                _loc_4 = _loc_4 + 1;
            }
            mcFunc.reSetMcsWhere(this.theViewer.lists, 230, 0, 0, 20);
            this.theViewer.lists.dispatchEvent(new Event(Event.CHANGE));
            this.theViewer.count_txt.text = String("(" + _loc_2.length + ")人");
            return;
        }// end function

        public function set dataList(param1:Array) : void
        {
            return;
        }// end function

        private function btnHandler(event:MouseEvent) : void
        {
            switch(event.currentTarget.name)
            {
                case "close_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.PLAYERLIST_CLOSE);
                    break;
                }
                case "close2_btn":
                {
                    this.facade.sendNotification(KillerRoomEvents.PLAYERLIST_CLOSE);
                    break;
                }
                case "refresh_btn":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function reGetPlist(param1:Object) : void
        {
            this.showList(param1);
            return;
        }// end function

    }
}
