package view
{
    import Core.*;
    import Core.model.vo.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import json.*;
    import uas.*;

    public class UserLuxuryForm extends Object
    {
        private var _data:Object = null;
        private var myLoader:Loader;
        private var theViewer:MovieClip;
        private var facade:MyFacade;

        public function UserLuxuryForm(MC:MovieClip)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            this.theViewer.clear_btn.addEventListener(MouseEvent.CLICK, this.btnsClickHandler);
            return;
        }// end function

        private function btnsClickHandler(event:Event) : void
        {
            this.theViewer.load_txt.visible = true;
            this.theViewer.load_txt.text = "Loading...";
            var _loc_2:* = new LoadURL();
            _loc_2.addEventListener(Event.COMPLETE, this.loaderClearHandler);
            _loc_2.load("/User/ClearToolAdv.ss");
            return;
        }// end function

        private function loaderClearHandler(event:Event) : void
        {
            var _loc_3:AlertVO = null;
            var _loc_2:* = JSON.decode(event.target.data);
            if (_loc_2.msg == "OK")
            {
                this.isClearBtn = false;
                mcFunc.removeAllMc(this.theViewer.loadpic_mc);
                this.theViewer.title_txt.htmlText = "";
                this.theViewer.msg_txt.htmlText = "";
                this.theViewer.load_txt.text = "目前还没有奢侈品";
            }
            else
            {
                this.theViewer.load_txt.text = "";
                _loc_3 = new AlertVO();
                _loc_3.msg = String(_loc_2.msg);
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            return;
        }// end function

        public function set isClearBtn(b:Boolean) : void
        {
            this.theViewer.clear_btn.visible = b;
            return;
        }// end function

        public function loadLuxurySwf(url:String) : void
        {
            mcFunc.removeAllMc(this.theViewer.loadpic_mc);
            if (url == "null")
            {
                return;
            }
            this.myLoader = new Loader();
            this.myLoader.contentLoaderInfo.addEventListener(Event.INIT, this.loaderHandler);
            this.myLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.errHandler);
            this.myLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.errHandler);
            var _loc_2:* = new URLRequest(url);
            this.myLoader.load(_loc_2);
            return;
        }// end function

        private function errHandler(event:ErrorEvent) : void
        {
            trace(event);
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var _loc_2:* = event.target.content;
            if (_loc_2.width <= 200)
            {
            }
            if (_loc_2.height > 200)
            {
                if (_loc_2.width > _loc_2.height)
                {
                    _loc_2.width = 200;
                    _loc_2.scaleY = _loc_2.scaleX;
                }
                else if (_loc_2.width < _loc_2.height)
                {
                    _loc_2.height = 200;
                    _loc_2.scaleX = _loc_2.scaleY;
                }
            }
            this.theViewer.loadpic_mc.addChild(_loc_2);
            return;
        }// end function

    }
}
