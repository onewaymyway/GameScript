package Core.controller
{
    import Core.*;
    import Core.model.*;
    import Core.view.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import uas.*;

    public class JsToAsCommand extends SimpleCommand implements ICommand
    {

        public function JsToAsCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:* = param1.getBody() as Object;
            t.objToString(_loc_2);
            if (this.hasOwnProperty(_loc_2.cmd))
            {
                var _loc_3:String = this;
                _loc_3.this[_loc_2.cmd](_loc_2);
            }
            else
            {
                this.sendNotification(GameEvents.ALERTEVENT.ALERT, {msg:"没有此操作" + _loc_2.cmd});
            }
            return;
        }// end function

        public function OpenMyGoods(param1:Object) : void
        {
            this.sendNotification(PlusMediator.OPEN, {url:Resource.SkinListsPath, x:300, y:100});
            return;
        }// end function

        public function CloseClient(param1:Object) : void
        {
            var _loc_2:* = facade.retrieveProxy(NetProxy.NAME) as NetProxy;
            NetProxy.CloseSeverMsg = "与服务器断开";
            _loc_2.closeClient();
            return;
        }// end function

        public function OpenAdmin(param1:Object) : void
        {
            Resource.AdminPath = String(param1.url);
            this.sendNotification(PlusMediator.OPEN, {url:param1.url + "AdminBox.swf", x:300, y:100});
            return;
        }// end function

        public function ShakeStart(param1:Object) : void
        {
            this.sendNotification("JsToAs_ShakeStart", param1);
            return;
        }// end function

        public function SavePhotoComplete(param1:Object) : void
        {
            this.sendNotification("JsToAs_SavePhotoComplete", param1);
            return;
        }// end function

        public function SharePhotoComplete(param1:Object) : void
        {
            this.sendNotification("JsToAs_SharePhotoComplete", param1);
            return;
        }// end function

    }
}
