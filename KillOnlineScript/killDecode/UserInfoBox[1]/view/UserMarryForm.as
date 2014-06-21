package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import uas.*;

    public class UserMarryForm extends Object
    {
        public var ring_type_mc:MovieClip;
        private var facade:Object;
        public var _data:Object = null;
        public var theViewer:MovieClip;

        public function UserMarryForm(v:MovieClip)
        {
            this.theViewer = v;
            this.facade = MyFacade.getInstance();
            this.ring_type_mc = new marryRing_Type_mc();
            this.theViewer.addChild(this.ring_type_mc);
            this.theViewer.unpart_btn.addEventListener(MouseEvent.CLICK, this.btnClick);
            this.theViewer.updatemary_btn.addEventListener(MouseEvent.CLICK, this.btnClick);
            this.theViewer.freeupdate_btn.addEventListener(MouseEvent.CLICK, this.btnClick);
            this.theViewer.update_time_btn.addEventListener(MouseEvent.CLICK, this.btnClick);
            return;
        }// end function

        public function btnClick(event:Event) : void
        {
            if (event.currentTarget.name == "unpart_btn")
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_OPEN, {code:GameEvents.PlUSEVENT.CONFIRMBOX_UNWEDDING, msg:"分手将扣除100金币的手续费,\n\n你确定要分手吗?", marryid:this._data.MarryId});
                this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXCLOSE);
            }
            else if (event.currentTarget.name == "updatemary_btn")
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_UPDATAMARRY, {marryid:this._data.MarryId, marrytype:this._data.MarryType});
                this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXCLOSE);
            }
            else if (event.currentTarget.name == "freeupdate_btn")
            {
                this.facade.sendNotification(GameEvents.PlUSEVENT.CONFIRMBOX_UPDATAMARRY, {marryid:this._data.MarryId, marrytype:this._data.MarryType});
                this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXCLOSE);
            }
            else if (event.currentTarget.name == "update_time_btn")
            {
                this.facade.sendNotification(PlusMediator.OPEN, {url:Resource.HTTP + "plus/MarryUpdateTime.swf", x:0, y:0, name1:this._data.User1Name, name2:this._data.User2Name, time:this._data.time, type:this._data.MarryType, target:this});
            }
            return;
        }// end function

        public function setData(Info:Object, USERID:uint) : void
        {
            var _loc_3:Date = null;
            var _loc_4:Date = null;
            var _loc_5:int = 0;
            var _loc_6:ChineseLunisolarCalendar = null;
            this._data = Info;
            this.theViewer.date_log.gotoAndStop("d0");
            this.theViewer.book_mc.visible = false;
            if (!Info.hasOwnProperty("MarryId"))
            {
                this.ring_type_mc.visible = false;
                this.theViewer.noMarry_mc.visible = true;
            }
            else
            {
                this.ring_type_mc.visible = true;
                this.theViewer.noMarry_mc.visible = false;
                _loc_3 = new Date();
                _loc_4 = DateStr.strToDateFormat(Info.MarryDate);
                _loc_5 = Math.floor(Math.abs(_loc_3.valueOf() - _loc_4.valueOf()) / (24 * 60 * 60 * 1000)) + 1;
                this.theViewer.marry_txt.htmlText = "我们恋爱的第 <font color=\'#FF0066\'><b> " + _loc_5 + "</b></font> 天";
                this.theViewer.username_txt.htmlText = "<b>" + Info.User1Name + "<b>";
                this.theViewer.partname_txt.htmlText = "<b>" + Info.User2Name + "<b>";
                this.ring_type_mc.gotoAndStop("type" + Info.MarryType);
                this.theViewer.marryType = Info.MarryType;
                this.theViewer.book_mc.picurl = Info.Photo;
                _loc_6 = new ChineseLunisolarCalendar(new Date(_loc_4));
                if (_loc_6.getCMonth() == 7)
                {
                }
                if (_loc_6.getCDay() == 7)
                {
                    this.theViewer.date_log.gotoAndStop("d7_7");
                }
                else
                {
                    if (_loc_4.getMonth() == 1)
                    {
                    }
                    if (_loc_4.getDate() == 14)
                    {
                        this.theViewer.date_log.gotoAndStop("d2_14");
                    }
                }
                if (!Info.Share)
                {
                    this.theViewer.photo2_btn.visible = false;
                    this.theViewer.book_btn.visible = false;
                    this.theViewer.share_btn.visible = false;
                    this.theViewer.photo_btn.visible = true;
                }
                else if (Info.Share == 0)
                {
                    this.theViewer.photo2_btn.visible = false;
                    this.theViewer.book_btn.visible = false;
                    this.theViewer.share_btn.visible = true;
                    this.theViewer.photo_btn.visible = false;
                }
                else
                {
                    if (int(Info.Share) != USERID)
                    {
                    }
                    if (int(Info.Share) == 1)
                    {
                        this.theViewer.photo2_btn.visible = true;
                        this.theViewer.book_btn.visible = true;
                        this.theViewer.share_btn.visible = false;
                        this.theViewer.photo_btn.visible = false;
                        this.loadMarryBook(Info.Photo);
                    }
                    else
                    {
                        if (int(Info.Share) != USERID)
                        {
                        }
                        if (int(Info.Share) != 0)
                        {
                            this.theViewer.photo2_btn.visible = false;
                            this.theViewer.book_btn.visible = false;
                            this.theViewer.share_btn.visible = true;
                            this.theViewer.photo_btn.visible = false;
                        }
                    }
                }
                if (USERID == UserData.UserInfo.UserId)
                {
                    this.theViewer.photo2_btn.visible = this.theViewer.photo_btn.visible == false;
                    this.theViewer.photo_btn.mouseEnabled = true;
                    this.theViewer.share_btn.mouseEnabled = true;
                    var _loc_7:Boolean = true;
                    this.theViewer.unpart_btn.visible = true;
                    this.theViewer.update_time_btn.visible = _loc_7;
                    if (Number(Info.MarryType) < 4)
                    {
                        this.theViewer.updatemary_btn.visible = true;
                        this.theViewer.freeupdate_btn.visible = false;
                    }
                    else
                    {
                        if (Number(Info.MarryType) >= 4)
                        {
                        }
                        if (Number(Info.MarryType) < 7)
                        {
                            this.theViewer.updatemary_btn.visible = false;
                            this.theViewer.freeupdate_btn.visible = true;
                        }
                    }
                }
                else
                {
                    this.theViewer.photo_btn.mouseEnabled = false;
                    this.theViewer.share_btn.mouseEnabled = false;
                    this.theViewer.photo2_btn.visible = false;
                    var _loc_7:Boolean = false;
                    this.theViewer.unpart_btn.visible = false;
                    this.theViewer.update_time_btn.visible = _loc_7;
                    this.theViewer.freeupdate_btn.visible = false;
                    this.theViewer.updatemary_btn.visible = false;
                }
                var _loc_7:* = String(Info.MarryDate).substring(0, String(Info.MarryDate).lastIndexOf("."));
                this.theViewer.marryDate_txt.text = String(Info.MarryDate).substring(0, String(Info.MarryDate).lastIndexOf("."));
                this._data.time = _loc_7;
            }
            return;
        }// end function

        private function loadMarryBook(url:String) : void
        {
            mcFunc.removeAllMc(this.theViewer.book_mc.pic_mc);
            var _loc_2:* = new LoadSwfToMc();
            _loc_2.load(url, this.theViewer.book_mc.pic_mc);
            return;
        }// end function

        public function jsShare() : void
        {
            this.theViewer.photo2_btn.visible = true;
            this.theViewer.book_btn.visible = true;
            this.theViewer.share_btn.visible = false;
            this.theViewer.photo_btn.visible = false;
            this.loadMarryBook(this.theViewer.book_mc.picurl);
            return;
        }// end function

        public function form2Btn() : void
        {
            if (!this.theViewer.share_btn.hasEventListener(MouseEvent.CLICK))
            {
                this.theViewer.book_btn.addEventListener(MouseEvent.MOUSE_OVER, this.form2book_mcHandler);
                this.theViewer.book_mc.addEventListener(MouseEvent.MOUSE_OUT, this.form2book_mcHandler);
                this.theViewer.share_btn.addEventListener(MouseEvent.CLICK, this.form2btnHandler);
                this.theViewer.photo2_btn.addEventListener(MouseEvent.CLICK, this.form2btnHandler);
                this.theViewer.photo_btn.addEventListener(MouseEvent.CLICK, this.form2btnHandler);
            }
            return;
        }// end function

        private function form2book_mcHandler(event:Event) : void
        {
            if (event.currentTarget.name == "book_btn")
            {
            }
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                this.theViewer.book_mc.visible = true;
                this.theViewer.book_mc.gotoAndPlay(2);
                this.ring_type_mc.visible = false;
            }
            else
            {
                if (event.currentTarget.name == "book_mc")
                {
                }
                if (event.type == MouseEvent.MOUSE_OUT)
                {
                    this.ring_type_mc.visible = true;
                    this.theViewer.book_mc.gotoAndStop(1);
                    this.theViewer.book_mc.visible = false;
                }
            }
            return;
        }// end function

        private function form2btnHandler(event:Event) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = event.currentTarget.name;
            if (_loc_2 == "share_btn")
            {
                this.theViewer.share_btn.mouseEnabled = false;
                ExternalInterface.call("shareBase", "晒晒我的结婚证", "这是我们一生中最值得纪念的日子，我们的爱情，因为今天而绽放美丽，我们的婚姻，因为今天而拥抱幸福。", "我们已经结为合法夫妻了，希望在未来的岁月里，我们彼此珍惜，相亲相爱，相濡以沫，牵手一生!", this.theViewer.book_mc.picurl, "/LoadJS/ShareMarryPhoto.ss", "");
            }
            else
            {
                if (_loc_2 != "photo2_btn")
                {
                }
                if (_loc_2 == "photo_btn")
                {
                    _loc_3 = {cmd:"JoinRoom", RoomId:String(0), Password:"", RoomType:"photoroom"};
                    this.facade.sendNotification(GameEvents.NETCALL, _loc_3);
                    this.facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXCLOSE);
                }
            }
            return;
        }// end function

    }
}
