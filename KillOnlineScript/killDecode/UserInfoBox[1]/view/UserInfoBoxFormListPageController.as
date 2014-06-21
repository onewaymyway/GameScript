package view
{
    import flash.events.*;

    public class UserInfoBoxFormListPageController extends EventDispatcher
    {
        private var viewer:Object;
        private var thisPage:uint = 0;
        private var maxPage:uint = 0;
        public static const PAGE_CLICK:Object = "UserInfoBoxFormListPageController_PAGE_CLICK";

        public function UserInfoBoxFormListPageController(v:Object, tp:uint, mp:uint)
        {
            this.viewer = v;
            this.thisPage = tp;
            this.viewer.prve_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.viewer.next_btn.addEventListener(MouseEvent.MOUSE_DOWN, this.btnHandler);
            this.setPages(tp, mp);
            return;
        }// end function

        public function setPages(tp:uint, mp:uint) : void
        {
            this.maxPage = mp;
            this.page = this.checkBtn(tp);
            return;
        }// end function

        public function set page(n:uint) : void
        {
            this.thisPage = n;
            this.viewer.page_txt.text = this.thisPage + "/" + this.maxPage;
            return;
        }// end function

        public function get page() : uint
        {
            return this.thisPage;
        }// end function

        private function btnHandler(event:Event) : void
        {
            var _loc_2:int = 0;
            if (event.target.name == "prve_btn")
            {
                _loc_2 = this.checkBtn((this.thisPage - 1));
                this.page = _loc_2;
                dispatchEvent(new Event(PAGE_CLICK));
            }
            else if (event.target.name == "next_btn")
            {
                _loc_2 = this.checkBtn((this.thisPage + 1));
                this.page = _loc_2;
                dispatchEvent(new Event(PAGE_CLICK));
            }
            return;
        }// end function

        private function checkBtn(p:int) : int
        {
            if (p <= 1)
            {
                p = 1;
                this.viewer.prve_btn.mouseEnabled = false;
                this.viewer.prve_btn.alpha = 0.5;
            }
            else
            {
                this.viewer.prve_btn.mouseEnabled = true;
                this.viewer.prve_btn.alpha = 1;
            }
            if (p >= this.maxPage)
            {
                p = this.maxPage;
                this.viewer.next_btn.mouseEnabled = false;
                this.viewer.next_btn.alpha = 0.5;
            }
            else
            {
                this.viewer.next_btn.mouseEnabled = true;
                this.viewer.next_btn.alpha = 1;
            }
            return p;
        }// end function

    }
}
