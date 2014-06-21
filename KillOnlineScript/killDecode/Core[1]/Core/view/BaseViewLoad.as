package Core.view
{
    import Core.*;
    import flash.events.*;
    import flash.system.*;
    import uas.*;

    public class BaseViewLoad extends Object
    {
        private var srcArr:Array;
        private var srcI:uint = 0;
        private var main:Object;
        private var myFacade:MyFacade;
        public var frameOBJ0:Object;
        public var frameOBJ1:Object;
        public var frameOBJ2:Object;
        public var frameOBJ3:Object;
        private var srcLoader2:LoadSwfsrc = null;
        private var srcLoader:LoadSwfToMc = null;

        public function BaseViewLoad(param1:Object)
        {
            this.srcArr = new Array();
            this.myFacade = MyFacade.getInstance();
            this.main = param1;
            this.srcArr = Resource.BaseLoadPathArr;
            this.loadViewMediator();
            return;
        }// end function

        private function loadViewMediator() : void
        {
            this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"读取场景资料...", p:(this.srcI + 1) + "/" + this.srcArr.length, bar:0});
            if (int(this.srcArr[this.srcI].ap) > 0)
            {
                if (this.srcLoader == null)
                {
                    this.srcLoader = new LoadSwfToMc(ApplicationDomain.currentDomain);
                }
                this.srcLoader.load(this.srcArr[this.srcI].url + Resource.GetFileNameV(this.srcArr[this.srcI].url), this.main["frameOBJ" + this.srcArr[this.srcI].ap]);
                this.srcLoader.addEventListener("complete", this.complatehandler);
                this.srcLoader.addEventListener("progress", this.progresshandler);
            }
            else
            {
                if (this.srcLoader2 == null)
                {
                    this.srcLoader2 = new LoadSwfsrc();
                }
                this.srcLoader2.load(this.srcArr[this.srcI].url + Resource.GetFileNameV(this.srcArr[this.srcI].url));
                this.srcLoader2.addEventListener("complete", this.complatehandler);
                this.srcLoader.addEventListener("progress", this.progresshandler);
            }
            return;
        }// end function

        private function progresshandler(event:Event) : void
        {
            var _loc_2:* = event.target.loadedBtyes / event.target.totalBtyes;
            this.myFacade.sendNotification(GameEvents.LOADINGEVENT.LOADING, {msg:"读取资料库...", p:(this.srcI + 1) + "/" + this.srcArr.length, bar:_loc_2});
            return;
        }// end function

        private function complatehandler(event:Event) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this.srcI + 1;
            _loc_2.srcI = _loc_3;
            if (this.srcI < this.srcArr.length)
            {
                this.loadViewMediator();
            }
            else
            {
                trace("src+loaded");
                if (this.srcLoader2 != null)
                {
                    this.srcLoader2.removeEventListener("complete", this.complatehandler);
                    this.srcLoader2 = null;
                }
                if (this.srcLoader != null)
                {
                    this.srcLoader.removeEventListener("complete", this.complatehandler);
                    this.srcLoader = null;
                }
                this.myFacade.startup();
            }
            return;
        }// end function

    }
}
