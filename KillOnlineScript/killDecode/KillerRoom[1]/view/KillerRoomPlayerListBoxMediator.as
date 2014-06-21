package view
{
    import Core.model.data.*;
    import Core.so.*;
    import Core.view.*;
    import controller.*;
    import flash.events.*;
    import model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;
    import roomEvents.*;
    import uas.*;

    public class KillerRoomPlayerListBoxMediator extends Mediator implements IMediator
    {
        private var playerListBox_obj:KillerRoomPlayerListBoxController;
        private var RoomUsersSo:SO;
        public static const NAME:String = "KillerRoomPlayerListBoxMediator";

        public function KillerRoomPlayerListBoxMediator(param1:Object = null)
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
            return [KillerRoomEvents.PLAYERLIST_OPEN, KillerRoomEvents.PLAYERLIST_CLOSE, KillerRoomEvents.PLAYERLIST_DATA, KillerRoomEvents.OUTROOM];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            switch(param1.getName())
            {
                case KillerRoomEvents.PLAYERLIST_OPEN:
                {
                    if (this.playerListBox_obj == null)
                    {
                        this.playerListBox_obj = new KillerRoomPlayerListBoxController(new KillerRoomPlayerlist_box());
                        this.viewComponent.addChild(this.playerListBox_obj.theViewer);
                        MainView.DRAG.setDrag(this.playerListBox_obj.theViewer.drag_mc, this.playerListBox_obj.theViewer, this.viewComponent);
                    }
                    else
                    {
                        this.viewComponent.addChild(this.playerListBox_obj.theViewer);
                    }
                    this.RoomUsersSo = ServerSO.getRemote("RoomUsers" + UserData.UserRoom);
                    this.RoomUsersSo.addEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
                    this.RoomUsersSo.connect();
                    break;
                }
                case KillerRoomEvents.PLAYERLIST_DATA:
                {
                    if (mcFunc.hasTheChlid(this.playerListBox_obj.theViewer, this.viewComponent))
                    {
                        this.playerListBox_obj.showList(this.RoomUsersSo.data);
                    }
                    break;
                }
                case KillerRoomEvents.PLAYERLIST_CLOSE:
                {
                    if (this.RoomUsersSo)
                    {
                        this.RoomUsersSo.removeEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
                        this.RoomUsersSo.close();
                    }
                    if (this.playerListBox_obj && mcFunc.hasTheChlid(this.playerListBox_obj.theViewer, this.viewComponent))
                    {
                        this.viewComponent.removeChild(this.playerListBox_obj.theViewer);
                    }
                    break;
                }
                case KillerRoomEvents.OUTROOM:
                {
                    if (this.RoomUsersSo)
                    {
                        this.RoomUsersSo.removeEventListener(SyncEvent.SYNC, this.syncUserSOHandler);
                        this.RoomUsersSo.close();
                    }
                    if (this.playerListBox_obj && mcFunc.hasTheChlid(this.playerListBox_obj.theViewer, this.viewComponent))
                    {
                        this.viewComponent.removeChild(this.playerListBox_obj.theViewer);
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

        private function syncUserSOHandler(event:SyncEvent) : void
        {
            KillerRoomData.RoomUserList = this.RoomUsersSo.data;
            facade.sendNotification(KillerRoomEvents.PLAYERLIST_DATA);
            return;
        }// end function

    }
}
