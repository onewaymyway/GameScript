package view
{
    import Core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;

    public class UserHonorForm extends Object
    {
        private var _data:Object = null;
        private var theViewer:MovieClip;
        private var facade:MyFacade;
        private var listXYARR:Object;
        private var hObj:Object = null;

        public function UserHonorForm(MC:MovieClip)
        {
            this.listXYARR = new Array();
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            var _loc_2:* = new Date();
            this.theViewer.title_txt.text = _loc_2.getFullYear() + "年度荣誉榜";
            this.theViewer.help_txt.htmlText = "<a href=\"event:help\"><u>如何获取？</u></a>";
            this.theViewer.addEventListener(TextEvent.LINK, this.linkHandler);
            return;
        }// end function

        public function ShowHonorList(holist:Array) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            if (holist != null)
            {
                for (_loc_2 in holist)
                {
                    
                    _loc_3 = this.theViewer.lists.addChild(new honorTxt());
                    _loc_3.honor_txt.autoSize = "left";
                    _loc_3.honor_txt.wordWrap = false;
                    _loc_3.honor_txt.htmlText = "<b>" + String(holist[_loc_2].Date).substr(4) + "期" + holist[_loc_2].HonerName + "</b>";
                    _loc_4 = this.getColor(_loc_2);
                    _loc_3.honor_txt.textColor = _loc_4;
                    _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.onpress);
                    _loc_3.addEventListener(MouseEvent.MOUSE_UP, this.onUP);
                    _loc_3.x = 80 * Math.random();
                    _loc_3.y = 180 * Math.random();
                    this.hObj = _loc_3;
                }
            }
            return;
        }// end function

        public function cleanHonor() : void
        {
            var _loc_1:Sprite = null;
            while (this.theViewer.lists.numChildren > 0)
            {
                
                _loc_1 = this.theViewer.lists.getChildAt(0);
                _loc_1.removeEventListener(MouseEvent.MOUSE_DOWN, this.onpress);
                _loc_1.removeEventListener(MouseEvent.MOUSE_UP, this.onUP);
                this.theViewer.lists.removeChildAt(0);
            }
            return;
        }// end function

        private function onpress(event:Event)
        {
            var _loc_2:* = event.currentTarget;
            this.theViewer.lists.setChildIndex(_loc_2, (this.theViewer.lists.numChildren - 1));
            this.hObj = _loc_2;
            _loc_2._bg.width = _loc_2.width;
            _loc_2.startDrag(false, new Rectangle(0, 0, 212 - _loc_2.width, 180));
            return;
        }// end function

        private function onUP(event:Event)
        {
            if (this.hObj != null)
            {
                this.hObj.stopDrag();
            }
            return;
        }// end function

        private function getColor(colorI)
        {
            var _loc_3:Number = NaN;
            var _loc_2:* = new Array(16711680, 11403351, 65280, 255, 16776960, 65535, 16711935);
            var _loc_4:* = colorI % _loc_2.length;
            if (colorI == _loc_2.length)
            {
                colorI = 0;
            }
            _loc_3 = _loc_2[_loc_4];
            return _loc_3;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            var _loc_2:URLRequest = null;
            var _loc_3:String = null;
            switch(event.text)
            {
                case "help":
                {
                    _loc_2 = new URLRequest("http://www.ss911.cn/pages/ShowNews.aspx?PageType=0&id=140");
                    _loc_3 = "_blank";
                    navigateToURL(_loc_2, _loc_3);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

    }
}
