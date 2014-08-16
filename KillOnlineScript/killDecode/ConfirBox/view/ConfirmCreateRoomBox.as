package view
{
    import Core.*;
    import Core.model.data.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import uas.*;

    public class ConfirmCreateRoomBox extends Object
    {
        private var roomSetSprite:confirm_CreateRoom_box = null;
        public var Arr:Object;
        private var facade:Object;
        private var roomSetInfoXml:XML;
        private var roomSetSelectData:Object = null;
        private var roomSetGameTypeSelectData:Object = null;

        public function ConfirmCreateRoomBox(viewobj:Object, arr:Object = null)
        {
            this.roomSetSprite = new confirm_CreateRoom_box();
            this.facade = MyFacade.getInstance();
            this.roomSetSprite.ok_btn.addEventListener("click", this.okClick);
            this.roomSetSprite.close_btn.addEventListener("click", this.closelClick);
            this.roomSetSprite.area_select.addEventListener(Event.CHANGE, this.area_selectChangeHandler);
            this.roomSetSprite.game_select.addEventListener(Event.CHANGE, this.game_selectChangeHandler);
            viewobj.addChild(this.roomSetSprite);
            MainView.DRAG.setDrag(this.roomSetSprite.drag_mc, this.roomSetSprite, viewobj);
            this.Arr = arr;
            this.roomSetSprite.x = viewobj.stage.stageWidth / 2;
            this.roomSetSprite.y = viewobj.stage.stageHeight / 2;
            this.roomSetSprite.roomName_txt.text = UserData.UserInfo.UserName + "µÄ·¿¼ä";
            this.loadbgList();
            return;
        }// end function

        private function okClick(event:MouseEvent) : void
        {
            var _loc_2:Object = null;
            if (event.currentTarget.name == "ok_btn")
            {
                _loc_2 = new Object();
                _loc_2.Area = String(this.roomSetSprite.area_select.selectData);
                _loc_2.RoomName = this.roomSetSprite.roomName_txt.text;
                _loc_2.Password = this.roomSetSprite.psw_txt.text;
                _loc_2.MaxPlayerNum = String(this.roomSetSprite.count_select.selectData);
                _loc_2.BackGround = String(this.roomSetSprite.bg_select.selectData);
                _loc_2.LimitIp = String(this.roomSetSprite.isip_chickBox.selectData);
                _loc_2.GameType = String(this.roomSetSprite.game_select.selectData);
                _loc_2.cmd = "CreateRoom";
                this.facade.sendNotification(GameEvents.NETCALL, _loc_2);
            }
            Sprite(this.roomSetSprite.parent).removeChild(this.roomSetSprite);
            return;
        }// end function

        private function closelClick(event:MouseEvent) : void
        {
            Sprite(this.roomSetSprite.parent).removeChild(this.roomSetSprite);
            return;
        }// end function

        private function loadbgList() : void
        {
            var _loc_1:* = new LoadURL();
            _loc_1.addEventListener(Event.COMPLETE, this.loadbgListHandler);
            _loc_1.load(Resource.HTTP + "roomsetinfo.xml?v=" + Resource.V + "." + uint(Resource.ChildV.roomsetinfo));
            return;
        }// end function

        private function loadbgListHandler(event:Event) : void
        {
            this.roomSetInfoXml = new XML(event.target.data);
            this.roomSetSprite.area_select.index = uint(this.Arr);
            this.roomSetSetValue();
            return;
        }// end function

        private function roomSetSetValue() : void
        {
            var i:uint;
            var areaNumArr:Array;
            var i2:uint;
            var i3:uint;
            var xml:* = new Object();
            xml.def = this.roomSetInfoXml.@def;
            var _loc_3:int = 0;
            var _loc_4:* = this.roomSetInfoXml.games;
            var _loc_2:* = new XMLList("");
            for each (_loc_5 in _loc_4)
            {
                
                var _loc_6:* = _loc_5;
                with (_loc_5)
                {
                    if (@linetype != String(MainData.getGameType()))
                    {
                    }
                    if (@linetype == String(999))
                    {
                        _loc_2[_loc_3] = _loc_5;
                    }
                }
            }
            xml.games = _loc_2;
            this.roomSetGameTypeSelectData = new Object();
            this.roomSetSelectData = new Object();
            this.roomSetGameTypeSelectData["labelArr"] = new Array();
            this.roomSetGameTypeSelectData["dataArr"] = new Array();
            this.roomSetGameTypeSelectData["def"] = uint(xml.def);
            i;
            while (i < xml.games.length())
            {
                
                areaNumArr = xml.games[i].@area.toString().split("-");
                if (uint(this.roomSetSprite.area_select.selectData) >= uint(areaNumArr[0]))
                {
                }
                if (uint(this.roomSetSprite.area_select.selectData) < uint(areaNumArr[1]))
                {
                    this.roomSetGameTypeSelectData["labelArr"].push(xml.games[i].@name.toString());
                    this.roomSetGameTypeSelectData["dataArr"].push(xml.games[i].@gametype.toString());
                    this.roomSetSelectData[xml.games[i].@gametype] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["about"] = new String();
                    this.roomSetSelectData[xml.games[i].@gametype]["about"] = String(xml.games[i].about).split("\r").join("");
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["labelArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["dataArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["pn"]["def"] = uint(xml.games[i].pnlist.@def);
                    i2;
                    while (i2 < xml.games[i].pnlist.pn.length())
                    {
                        
                        this.roomSetSelectData[xml.games[i].@gametype]["pn"]["labelArr"].push(xml.games[i].pnlist.pn[i2].toString());
                        this.roomSetSelectData[xml.games[i].@gametype]["pn"]["dataArr"].push(xml.games[i].pnlist.pn[i2].@value.toString());
                        i2 = (i2 + 1);
                    }
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"] = new Object();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["labelArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["dataArr"] = new Array();
                    this.roomSetSelectData[xml.games[i].@gametype]["bg"]["def"] = uint(xml.games[i].bglist.@def);
                    i3;
                    while (i3 < xml.games[i].bglist.bg.length())
                    {
                        
                        this.roomSetSelectData[xml.games[i].@gametype]["bg"]["labelArr"].push(xml.games[i].bglist.bg[i3].toString());
                        this.roomSetSelectData[xml.games[i].@gametype]["bg"]["dataArr"].push(xml.games[i].bglist.bg[i3].@value.toString());
                        i3 = (i3 + 1);
                    }
                }
                i = (i + 1);
            }
            this.roomSetSprite.game_select.setData(this.roomSetGameTypeSelectData);
            this.roomSetSprite.count_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["pn"]);
            this.roomSetSprite.bg_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["bg"]);
            return;
        }// end function

        private function game_selectChangeHandler(event:Event) : void
        {
            this.roomSetSprite.count_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["pn"]);
            this.roomSetSprite.bg_select.setData(this.roomSetSelectData[this.roomSetSprite.game_select.selectData]["bg"]);
            return;
        }// end function

        private function area_selectChangeHandler(event:Event) : void
        {
            this.roomSetSetValue();
            return;
        }// end function

    }
}
