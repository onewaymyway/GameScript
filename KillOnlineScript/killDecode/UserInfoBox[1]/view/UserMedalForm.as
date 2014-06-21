package view
{
    import Core.*;
    import Core.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import uas.*;

    public class UserMedalForm extends Object
    {
        private var _data:Object = null;
        private var theViewer:MovieClip;
        private var facade:MyFacade;
        private var listARR:Array;
        private var pageController:UserInfoBoxFormListPageController;

        public function UserMedalForm(MC:MovieClip)
        {
            this.facade = MyFacade.getInstance();
            this.theViewer = MC;
            this.theViewer.help_txt.htmlText = "<a href=\"event:help\"><u>勋章介绍</u></a>";
            this.theViewer.addEventListener(TextEvent.LINK, this.linkHandler);
            this.pageController = new UserInfoBoxFormListPageController(this.theViewer.pagelist_mc, 1, 1);
            this.pageController.addEventListener(UserInfoBoxFormListPageController.PAGE_CLICK, this.pageHandler);
            return;
        }// end function

        private function pageHandler(event:Event) : void
        {
            this.pagelist(uint(event.target.page));
            return;
        }// end function

        public function setListArr(arr:Array) : void
        {
            this.listARR = arr;
            var _loc_2:* = Math.ceil(arr.length / 9);
            this.pageController.setPages(1, _loc_2);
            this.pagelist(1);
            return;
        }// end function

        public function pagelist(p:uint) : void
        {
            var _loc_4:MedalGradeLog = null;
            var _loc_5:LoadSwfToMc = null;
            var _loc_6:MedalGradeLog = null;
            mcFunc.removeAllMc(this.theViewer.lists);
            var _loc_2:* = (p - 1) * 9;
            var _loc_3:* = p * 9;
            if (_loc_3 > this.listARR.length)
            {
                _loc_3 = this.listARR.length;
            }
            if (this.listARR != null)
            {
                while (_loc_2 < _loc_3)
                {
                    
                    _loc_4 = this.theViewer.lists.addChild(new MedalGradeLog());
                    _loc_4.gotoAndStop("l" + this.listARR[_loc_2]["MedalGrade"]);
                    _loc_5 = new LoadSwfToMc();
                    _loc_5.load("/resource/tool/" + this.listARR[_loc_2].ToolId + ".png", _loc_4.pic_mc);
                    MainView.ALT.setAlt(_loc_4.pic_mc, this.listARR[_loc_2]["MedalName"] + "\n已接收：" + this.listARR[_loc_2]["ToolNum"] + "个", 1, 0, 40, 20);
                    this.theViewer.lists.addChild(_loc_4);
                    _loc_2 = _loc_2 + 1;
                }
            }
            while (_loc_2 < p * 9)
            {
                
                _loc_6 = this.theViewer.lists.addChild(new MedalGradeLog());
                _loc_6.gotoAndStop("l0");
                this.theViewer.lists.addChild(_loc_6);
                _loc_2 = _loc_2 + 1;
            }
            mcFunc.reSetMcsWhere(this.theViewer.lists, 220, 0, 73, 83);
            return;
        }// end function

        public function cleanLists() : void
        {
            this.listARR = null;
            while (this.theViewer.lists.numChildren > 0)
            {
                
                this.theViewer.lists.removeChildAt(0);
            }
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            var _loc_2:URLRequest = null;
            var _loc_3:String = null;
            switch(event.text)
            {
                case "help":
                {
                    _loc_2 = new URLRequest("http://www.ss911.cn/pages/medalgrade.aspx");
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
