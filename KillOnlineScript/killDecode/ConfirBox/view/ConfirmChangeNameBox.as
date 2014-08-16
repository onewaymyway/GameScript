package view
{
    import Core.*;
    import Core.model.vo.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import mx.utils.*;
    import uas.*;

    public class ConfirmChangeNameBox extends Sprite
    {
        private var thisObj:confirm_ChangeName_box = null;
        private var funcObj:Object;
        public var Arr:Object;
        private var facade:Object;

        public function ConfirmChangeNameBox(viewobj:Object, arr:Object = null)
        {
            this.facade = MyFacade.getInstance();
            this.thisObj = new confirm_ChangeName_box();
            this.Arr = arr;
            this.thisObj.ok_btn.addEventListener("click", this.okClick);
            this.thisObj.close2_btn.addEventListener("click", this.CloselClick);
            this.thisObj.close_btn.addEventListener("click", this.CloselClick);
            this.thisObj.chk_btn.addEventListener("click", this.okClick);
            this.thisObj.name_txt.addEventListener(Event.CHANGE, this.txtChangeHandler);
            viewobj.addChild(this.thisObj);
            MainView.DRAG.setDrag(this.thisObj.drag_mc, this.thisObj, viewobj);
            this.thisObj.x = viewobj.stage.stageWidth / 2;
            this.thisObj.y = viewobj.stage.stageHeight / 2;
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "ok_btn")
            {
                this.send();
            }
            else if (event.currentTarget.name == "chk_btn")
            {
                _loc_2 = new Object();
                _loc_2.NewNickName = String(this.thisObj.name_txt.text);
                _loc_2.cmd = "CheckNickName";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            else
            {
                if (event.currentTarget.name != "close_btn")
                {
                }
                if (event.currentTarget.name == "close2_btn")
                {
                    Sprite(this.thisObj.parent).removeChild(this.thisObj);
                }
            }
            return;
        }// end function

        private function CloselClick(event:MouseEvent) : void
        {
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function txtChangeHandler(event:Event) : void
        {
            this.thisObj.name_txt.text = StringUtil.trim(this.thisObj.name_txt.text);
            return;
        }// end function

        private function send() : void
        {
            var _loc_1:uint = 0;
            if (this.thisObj.isdelfas_chickBox.selectData == "true")
            {
                _loc_1 = 1;
            }
            var _loc_2:* = new Object();
            _loc_2.ToolId = String(this.Arr.TID);
            _loc_2.UserId = String(this.Arr.PIP);
            _loc_2.NewNickName = String(this.thisObj.name_txt.text);
            _loc_2.Delfas = String(_loc_1);
            _loc_2.cmd = "UseTool";
            this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            Sprite(this.thisObj.parent).removeChild(this.thisObj);
            return;
        }// end function

        private function chkHaveName(type:Object) : void
        {
            var _loc_2:* = new LoadURL();
            _loc_2.addEventListener(Event.COMPLETE, this.loaderHandler);
            _loc_2.load(Resource.HTTP + "haveuser.aspx?username=" + this.thisObj.name_txt.text, type);
            this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"正在验证昵称..."});
            return;
        }// end function

        private function loaderHandler(event:Event) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:Object = null;
            var _loc_2:* = UStr.getObjByString(event.target.data);
            var _loc_3:* = new AlertVO();
            if (_loc_2.re == 0)
            {
                if (event.target.note == "1")
                {
                    this.facade.sendNotification(GameEvents.LOADINGEVENT.LOADED);
                    _loc_3.msg = "恭喜您！！此昵称可以使用";
                    this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
                }
                else
                {
                    _loc_4 = 0;
                    if (this.thisObj.isdelfas_chickBox.selectData == "true")
                    {
                        _loc_4 = 1;
                    }
                    _loc_5 = new CallCmdVO();
                    _loc_5.arg = [{TID:this.Arr.arr.TID, UserName:this.thisObj.name_txt.text, DelFas:_loc_4}];
                    _loc_5.code = "ActChangeName";
                    _loc_5.resp = null;
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_5);
                    Sprite(parent).removeChild(this.thisObj);
                }
            }
            else if (_loc_2.re == 1)
            {
                _loc_3.msg = "对不起！！此昵称已经存在";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            else if (_loc_2.re == 2)
            {
                _loc_3.msg = "对不起！！用户名太长,最多6个中文或12个英文字符，或含有特殊符号";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERT, _loc_3);
            }
            return;
        }// end function

    }
}
