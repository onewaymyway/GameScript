package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class UserInfoBoxForm1MoodControler extends Object
    {
        private var theViewer:MovieClip;
        private var facade:MyFacade;
        private var moodString:String;
        private var isedit:Boolean;

        public function UserInfoBoxForm1MoodControler(MC:MovieClip)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            this.theViewer.edit_btn.addEventListener(MouseEvent.CLICK, this.onEdit);
            this.theViewer.save_btn.addEventListener(MouseEvent.CLICK, this.onSave);
            this.theViewer.edit_mc.edit_txt.addEventListener(Event.CHANGE, this.checkText);
            this.theViewer.edit_mc.edit_txt.addEventListener(MouseEvent.MOUSE_DOWN, this.onEditText);
            this.init();
            return;
        }// end function

        private function onEditText(event:Event) : void
        {
            if (this.moodString == "")
            {
                this.theViewer.edit_mc.edit_txt.text = "";
                this.theViewer.edit_mc.edit_txt.textColor = 0;
            }
            this.isedit = true;
            return;
        }// end function

        private function checkText(event:Event) : void
        {
            var _loc_2:* = this.theViewer.edit_mc.edit_txt.text;
            var _loc_3:* = /\
n|\r""\n|\r/g;
            _loc_2 = _loc_2.split(_loc_3).join("");
            this.theViewer.edit_mc.edit_txt.text = _loc_2;
            return;
        }// end function

        public function init() : void
        {
            this.isedit = false;
            this.moodString = "";
            this.theViewer.more_log.visible = false;
            this.theViewer.edit_mc.visible = false;
            this.theViewer.edit_btn.visible = false;
            this.theViewer.save_btn.visible = false;
            this.theViewer.mood_txt.text = "我的个性签名";
            this.theViewer.mood_txt.textColor = 6710886;
            this.theViewer.edit_mc.edit_txt.text = "";
            this.isCanEdit = false;
            MainData.MainStage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onSave);
            return;
        }// end function

        public function set isCanEdit(b:Boolean) : void
        {
            if (b)
            {
                this.theViewer.edit_mc.visible = false;
                this.theViewer.edit_btn.visible = true;
                this.theViewer.save_btn.visible = false;
            }
            else
            {
                this.theViewer.edit_mc.visible = false;
                this.theViewer.edit_btn.visible = false;
                this.theViewer.save_btn.visible = false;
            }
            return;
        }// end function

        public function set mood(s:String) : void
        {
            this.moodString = s;
            this.theViewer.mood_txt.width = 30;
            this.theViewer.mood_txt.wordWrap = false;
            this.theViewer.mood_txt.autoSize = "left";
            if (s == "")
            {
                this.theViewer.mood_txt.text = "我的个性签名";
                this.theViewer.mood_txt.textColor = 6710886;
                this.theViewer.more_log.visible = false;
                MainView.ALT.setAlt(this.theViewer.mood_txt, "", 1);
                return;
            }
            this.theViewer.mood_txt.text = s;
            this.theViewer.mood_txt.textColor = 0;
            if (this.theViewer.mood_txt.width > 180)
            {
                this.theViewer.mood_txt.wordWrap = true;
                this.theViewer.mood_txt.autoSize = TextFieldAutoSize.NONE;
                this.theViewer.mood_txt.width = 175;
                this.theViewer.more_log.visible = true;
            }
            else
            {
                this.theViewer.more_log.visible = false;
            }
            MainView.ALT.setAlt(this.theViewer.mood_txt, s, 1);
            return;
        }// end function

        public function onEdit(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            if (UserData.UserInfo.Integral < 200)
            {
                _loc_2 = new Object();
                _loc_2.code = "";
                _loc_2.arr = null;
                _loc_2.msg = "编辑签名,需要200积分以上";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
                return;
            }
            if (UserData.MyRoomInfo)
            {
            }
            if (UserData.MyRoomInfo.RoomStatus == 1)
            {
                _loc_3 = new Object();
                _loc_3.code = "";
                _loc_3.arr = null;
                _loc_3.msg = "游戏中，不能修改签名";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_3);
            }
            else
            {
                this.theViewer.edit_btn.visible = false;
                this.theViewer.edit_mc.visible = true;
                if (this.moodString == "")
                {
                    this.theViewer.edit_mc.edit_txt.text = "点击编辑个人签名";
                    this.theViewer.edit_mc.edit_txt.textColor = 14606046;
                }
                else
                {
                    this.theViewer.edit_mc.edit_txt.text = this.moodString;
                }
                MainData.MainStage.addEventListener(MouseEvent.MOUSE_DOWN, this.onSave);
            }
            return;
        }// end function

        public function onSave(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            if (this.theViewer.edit_mc.hitTestPoint(MainData.MainStage.mouseX, MainData.MainStage.mouseY))
            {
                return;
            }
            MainData.MainStage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onSave);
            if (UserData.MyRoomInfo)
            {
            }
            if (UserData.MyRoomInfo.RoomStatus == 1)
            {
                _loc_2 = new Object();
                _loc_2.code = "";
                _loc_2.arr = null;
                _loc_2.msg = "游戏中，不能修改签名";
                this.facade.sendNotification(GameEvents.ALERTEVENT.ALERTMSG, _loc_2);
            }
            else
            {
                if (this.moodString != this.theViewer.edit_mc.edit_txt.text)
                {
                }
                if (this.isedit)
                {
                    this.moodString = this.theViewer.edit_mc.edit_txt.text;
                    _loc_3 = new Object();
                    _loc_3.cmd = "SetMood";
                    _loc_3.Mood = this.moodString;
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_3);
                    this.mood = this.moodString;
                }
            }
            this.isedit = false;
            this.theViewer.edit_mc.visible = false;
            this.theViewer.edit_btn.visible = true;
            return;
        }// end function

    }
}
